import os.path
from os.path import basename
from pathlib import Path
from subprocess import CalledProcessError, check_output

from skeldump.bbshotseg import SHOT_CHANGE
from skeldump.io import ShotSegmentedWriter


def fulldir(path):
    return os.path.dirname(os.path.realpath(path))


FMT_VERSION = 1
CUR_DIR = fulldir(__file__)


def add_metadata(h5f, video, num_frames, mode, limbs):
    h5f.attrs["video"] = basename(video)
    h5f.attrs["num_frames"] = num_frames
    h5f.attrs["mode"] = mode
    h5f.attrs["limbs"] = limbs


def git_describe_safe(cwd):
    try:
        return check_output(["git", "describe", "--always"], cwd=cwd).decode().strip()
    except CalledProcessError:
        return "unknown"


def extract_cmake_flags(cwd, flags):
    build_path = Path(cwd)
    flag_results = {flag: "unknown" for flag in flags}
    path_success = None
    while build_path != build_path.parent:
        cmake_path = build_path / "CMakeCache.txt"
        if cmake_path.exists():
            path_success = cmake_path
            break
        build_path = build_path.parent
    if path_success is not None:
        with open(cmake_path) as cmake_cache:
            for line in cmake_cache:
                for flag in flags:
                    if line.startswith(flag + ":STRING="):
                        flag_results[flag] = line.split("=", 1)[1]
    return flag_results


def add_fmt_metadata(h5f, fmt_type, running_op=False):
    h5f.attrs["fmt_type"] = fmt_type
    h5f.attrs["fmt_ver"] = FMT_VERSION
    skeldump_ver = "{}={}".format(fmt_type, git_describe_safe(CUR_DIR))
    if "skeldump_ver" in h5f.attrs:
        h5f.attrs["skeldump_ver"] = skeldump_ver + ";" + h5f.attrs["skeldump_ver"]
    else:
        h5f.attrs["skeldump_ver"] = skeldump_ver
    if running_op:
        import openpose

        op_py_dir = fulldir(openpose.__file__)
        h5f.attrs["op_ver"] = git_describe_safe(op_py_dir)
        for name, val in extract_cmake_flags(
            op_py_dir, ("GPU_MODE", "DL_FRAMEWORK")
        ).items():
            h5f.attrs["op_" + name] = val


def write_shots(h5f, limbs, frame_iter, writer_cls=ShotSegmentedWriter, start_frame=0):
    writer = writer_cls(h5f)
    writer.start_shot()
    frame_num = start_frame
    for frame in frame_iter:
        if frame is SHOT_CHANGE:
            writer.end_shot()
            writer.start_shot()
        else:
            writer.register_frame(frame_num)
            for pose_id, pose in frame:
                writer.add_pose(frame_num, pose_id, pose.all())
            frame_num += 1
    writer.end_shot()
