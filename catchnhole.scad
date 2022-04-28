// catchnhole: because nutsnbolts was taken
// Purpose: an ergonomic way to create nutcatches and screw holes.
//
// License: MIT

A_LOT = 200;

// bolt - generate a bolt positive.
//
// Usage:
//
//     bolt("M3x25");
//

// bolts = import("bolts.json");
nuts = import("../nuts.json");

function hex_inscribed_circle_d (w) = 2 * w / sqrt(3);

module hexagon (d, h) {
  cylinder(d = d, h = h, $fn = 6);
}

module bolt (options) {
  b = is_string(options) ? bolts[options] : options;
  echo(b);
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
