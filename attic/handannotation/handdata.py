# http://www.janabressem.de/wp-content/uploads/2016/10/Bressem_notational-system-overview_final.pdf

# TB = towards body = towards camera = ego-centeric assumption
# Assumed right hand -- if it's the left hand that should be noted

PALM_ORIENTATION = ["up", "down", "lateral", "vertical"]

DEFAULT_PALM_ORIENTATION = ("V", "TB")
DEFAULT_FINGER_SPEC = ("touching", 0)


class HandPostureSymbolic:
    """

    This class allows construction of symbolic hand gestures with the Bressem
    notational system.

    """

    def __init__(self, *bits):
        self.parts = [None]
        for bit in bits:
            addressed = bit[0]
            if isinstance(addressed, tuple):
                start = addressed[0]
                end = addressed[1] + 1
            elif isinstance(addressed, int):
                start = addressed
                end = addressed + 1
            else:
                assert addressed == "palm"
                start = 0
                end = 1
            for addressed in range(start, end):
                self.set_part(addressed, *bit[1:])
        if self.parts[0] is None:
            self.parts[0] = DEFAULT_PALM_ORIENTATION
        for idx in range(1, 6):
            self.parts[idx] = self.proc_spec(DEFAULT_FINGER_SPEC)

    @staticmethod
    def proc_spec(spec):
        if len(spec) == 2 and spec[1] == "palm":
            spec[1] = 0
        return spec

    def set_part(self, addressed, *spec):
        if self.parts[addressed] is not None:
            assert False, "Tried to set info for a part twice!"
        self.parts[addressed] = self.proc_spec(spec)


# This isn't quite right
ANGLE_WITH_PALM = {
    "flapped down": 90,
    "crooked": 120,
    "bent": 150,
    "stretched": 180,
}

triesch = {}

NUS_I = {
    "g1": HandPostureSymbolic(((2, 5), "stretched"), (1, "connected", "palm")),
    "g2": HandPostureSymbolic(((2, 5), "stretched"), (1, "bent")),
    "g3": HandPostureSymbolic(
        ((3, 5), "stretched"), ((2, "a"), "connected", (2, "d")), (1, "flapped down")
    ),
    "g4": HandPostureSymbolic(((3, 5), "stretched"), (2, "connected", (1, "b"))),
    "g5": HandPostureSymbolic(
        ((2,), "stretched"), ((1, "b"), "connected", (3, "b")), ((3, 5), "connected", 0)
    ),
    "g6": HandPostureSymbolic(
        ((2, 3), "stretched"),
        ((4, "a"), "connected", (4, "d")),
        ((5, "a"), "connected", (5, "d")),
        ((1, "b"), "connected", (4, "b")),
    ),
    "g7": HandPostureSymbolic(
        ((2, 5), "touching", "palm"),
        # Actually slightly bend over
        (1, "flapped down"),
    ),
    "g8": HandPostureSymbolic(
        ("palm", ("V", "TC")),
        (2, "stretched"),
        (5, "stretched"),
        ((3, 4), "touching", 1),
    ),
    "g9": HandPostureSymbolic(
        ("palm", ("V", "TC")),
        ((1, 5), "touching"),
        # 2-5 Spread?
    ),
    "g10": HandPostureSymbolic(
        ("palm", ("D", "di", "TC")), ((2, 5), "bent"), (1, "touching", (2, "c")),
    ),
}

NUS_II = {
    "a": HandPostureSymbolic(((2, 5), "touching", "palm"), (1, "flapped down")),
    "b": HandPostureSymbolic(((2, 5), "stretched"), (1, "flapped down")),
    "c": HandPostureSymbolic(
        (1, "connected", (5, "b")),
        ((2, 3), "stretched"),
        ((4, 5), "connected", "palm"),
    ),
    "d": HandPostureSymbolic((1, "bent"), (5, "stretched"),),
    "e": HandPostureSymbolic(
        ("palm", ("V", "TC")),
        ((3, 5), "stretched"),
        ((2, "connected", (1, "a"))),
        # 1 bent
    ),
    "f": HandPostureSymbolic(
        ("palm", ("V", "TC")), (1, "flapped down"), (1, "touching", (2, "d")),
    ),
    "g": HandPostureSymbolic(
        ("palm", ("U", "di", "AW")),
        # XXX: Not actually 90 degrees
        ((2, 5), "flapped down"),
        (1, "bent"),
    ),
    "h": HandPostureSymbolic((2, "stretched"), (1, "bent"),),
    "i": HandPostureSymbolic(("palm", ("V", "TC")), ((1, 5), "touching"),),
    "j": HandPostureSymbolic(
        ("palm", ("L", "TB")), ((2, 3), "stretched"), (1, "touching", (5, "c")),
    ),
}
