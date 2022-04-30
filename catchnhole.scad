// catchnhole: because nutsnbolts was taken
// Purpose: an ergonomic way to create nutcatches and screw holes.

// License: MIT

A_LOT = 200;

bolts = import("bolts.json");
nuts = import("nuts.json");

DEFAULT_HEAD_DIAMETER_CLEARANCE = 0.1;

function hex_inscribed_circle_d (w) = 2 * w / sqrt(3);

function bolt_data () = bolts;
function nut_data () = nuts;

module hexagon (d, h) {
  cylinder(d = d, h = h, $fn = 6);
}

//
// bolt - generate a bolt head positive
//
// Usage:
//
//     bolt_head("M3", "countersunk");
//     bolt_head("M5", head_diameter_clearence = 0.2);
//
module bolt_head (options, kind, head_diameter_clearance = DEFAULT_HEAD_DIAMETER_CLEARANCE) {
  b = is_string(options) ? bolts[options][kind] : options;

  if (kind == "socket_head") {
    cylinder(d = b.head_diameter + 2 * head_diameter_clearance, h = b.head_length);
  }
  else if (kind == "countersunk") {
    cylinder(d1 = b.diameter, d2 = b.head_diameter, h = b.head_length);
  }
}

//
// bolt - generate a bolt positive.
//
// Usage:
//
//     bolt("M3", 25);
//
module bolt (options, length, kind = "headless", head_diameter_clearance = DEFAULT_HEAD_DIAMETER_CLEARANCE, countersink = 0) {
  b = is_string(options) ? bolts[options][kind] : options;

  translate([0, 0, -countersink * (is_num(b.head_length) ? b.head_length : 0)]) {
    cylinder(d = b.diameter, h = length);

    if (kind != "headless") translate([0, 0, length]) bolt_head(b, kind, head_diameter_clearance);
  }
}

//
// nutcatch_parallel - generate a parallel (surface) nutcatch positive
//
// Usage:
//
//     nutcatch_parallel("M3");
//
module nutcatch_parallel (options, height_clearance = 0, kind = "hexagon") {
  opt = is_string(options) ? nuts[options] : options;
  n = opt[kind];
  hexagon(d = hex_inscribed_circle_d(n.width), h = n.thickness + height_clearance);
}

//
// nutcatch_sidecut - generate a sidecut nutcatch
//
// Usage:
//
//     nutcatch_sidecut("M3");
//
module nutcatch_sidecut (options, height_clearance = 0, kind = "hexagon", length = A_LOT) {
  opt = is_string(options) ? nuts[options] : options;
  n = opt[kind];
  h = n.thickness + height_clearance;
  hexagon(d = hex_inscribed_circle_d(n.width), h = h);
  translate([0, -n.width / 2, 0]) cube([length, n.width, h]);
}
