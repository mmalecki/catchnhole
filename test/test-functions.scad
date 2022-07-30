use <../catchnhole.scad>;

assert(bolt_head_length("M3", kind = "headless") == 0, "head height of a headless screw should be 0");
assert(bolt_head_length("M3") == 0, "headless screw should be the default");
