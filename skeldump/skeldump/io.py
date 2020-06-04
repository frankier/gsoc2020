from .openpose import POSE_CLASSES
from .sparsepose import create_csr, get_row_csr
from .pose import DumpReaderPoseBundle


class ShotSegmentedWriter:
    def __init__(self, h5f):
        self.h5f = h5f

        self.pose_data = {}
        self.shot_idx = 0
        self.shot_start = 0
        self.last_frame = 0

    def start_shot(self):
        pass

    def add_pose(self, frame_num, pose_id, pose):
        self.pose_data.setdefault(pose_id, {})[frame_num] = pose
        self.last_frame = frame_num

    def end_shot(self):
        shot_grp = self.h5f.create_group(f"/timeline/{self.shot_idx}")
        shot_grp.attrs["start_frame"] = self.shot_start
        shot_grp.attrs["end_frame"] = self.last_frame + 1
        for pose_id, poses in self.pose_data.items():
            data = []
            indices = []
            indptr = []
            try:
                pose_first_frame = next(iter(poses.keys()))
                pose_last_frame = next(iter(reversed(poses.keys()))) + 1
            except StopIteration:
                continue
            last_frame_num = pose_first_frame - 1

            def add_empty_rows(num_rows):
                for _ in range(num_rows):
                    indptr.append(len(data))

            for frame_num, pose in poses.items():
                add_empty_rows(frame_num - last_frame_num)
                for limb_idx, limb in enumerate(pose):
                    if not limb[2]:
                        continue
                    data.append(limb)
                    indices.append(limb_idx)
                last_frame_num = frame_num
            # Extra empty row to insert final nnz entry
            add_empty_rows(1)

            pose_group = create_csr(
                self.h5f,
                f"/timeline/{self.shot_idx}/{pose_id}",
                data,
                indices,
                indptr
            )
            pose_group.attrs["start_frame"] = pose_first_frame
            pose_group.attrs["end_frame"] = pose_last_frame
        self.shot_idx += 1
        self.shot_start = self.last_frame + 1


class ShotSegmentedReader:
    def __init__(self, h5f):
        self.h5f = h5f
        self.cls = POSE_CLASSES[self.h5f.attrs["mode"]]

    def __iter__(self):
        for shot_name, shot_grp in self.h5f["/timeline"].items():
            yield ShotReader(shot_grp, self.h5f.attrs["limbs"], self.cls)


class ShotReader:
    def __init__(self, shot_grp, num_limbs, cls):
        self.shot_grp = shot_grp
        self.num_limbs = num_limbs
        self.cls = cls

    def __iter__(self):
        for frame in range(
            self.shot_grp.attrs["start_frame"],
            self.shot_grp.attrs["end_frame"],
        ):
            bundle = []
            for pose_grp in self.shot_grp.values():
                start_frame = pose_grp.attrs["start_frame"]
                end_frame = pose_grp.attrs["end_frame"]
                if start_frame <= frame < end_frame:
                    row_num = frame - start_frame
                    bundle.append(get_row_csr(pose_grp, self.num_limbs, row_num))
            yield DumpReaderPoseBundle(bundle, self.cls)

