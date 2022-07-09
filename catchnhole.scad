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
module bolt_head (options, kind, head_diameter_clearance = DEFAULT_HEAD_DIAMETER_CLEARANCE, head_top_clearance = 0) {
  b = is_string(options) ? bolts[options][kind] : options;

  if (kind == "socket_head") {
    cylinder(d = b.head_diameter + head_diameter_clearance, h = b.head_length + head_top_clearance);
  }
  else if (kind == "countersunk") {
    head_dia = b.head_diameter + head_diameter_clearance;
    cylinder(
      d1 = b.diameter + head_diameter_clearance,
      d2 = head_dia,
      h = b.head_length
    );
    translate([0, 0, b.head_length])
      cylinder(d = head_dia, head_top_clearance);
  }
}

//
// bolt - generate a bolt positive.
//
// Usage:
//
//     bolt("M3", 25);
//
module bolt (
  options,
  length,
  kind = "headless",
  head_diameter_clearance = DEFAULT_HEAD_DIAMETER_CLEARANCE,
  head_top_clearance = 0,
  countersink = 0
) {
  b = is_string(options) ? bolts[options][kind] : options;

  head_length = is_num(b.head_length) ? b.head_length : 0;
  translate([0, 0, -countersink * head_length]) {
    cylinder(d = b.diameter, h = length);

    if (kind != "headless") {
      translate([0, 0, length]) {
        bolt_head(
          b,
          kind,
          head_diameter_clearance,
          head_top_clearance = max((countersink - 1) * head_length, 0) + head_top_clearance,
        );
      }
    }
  }
}

//
// nutcatch_parallel - generate a parallel (surface) nutcatch positive
//
// Usage:
//
//     nutcatch_parallel("M3");
//
module nutcatch_parallel (options, kind = "hexagon", height_clearance = 0, width_clearance = 0) {
  n = is_string(options) ? nuts[options][kind] : options;
  hexagon(d = hex_inscribed_circle_d(n.width + width_clearance), h = n.thickness + height_clearance);
}

//
// nutcatch_sidecut - generate a sidecut nutcatch
//
// Usage:
//
//     nutcatch_sidecut("M3");
//
module nutcatch_sidecut (options, kind = "hexagon", height_clearance = 0, width_clearance = 0, length = A_LOT) {
  n = is_string(options) ? nuts[options][kind] : options;
  h = n.thickness + height_clearance;
  w = n.width + width_clearance;
  hexagon(d = hex_inscribed_circle_d(w), h = h);
  translate([0, -w / 2, 0]) cube([length, w, h]);
}
