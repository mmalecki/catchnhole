// catchnhole: because nutsnbolts was taken
// Purpose: an ergonomic way to create nutcatches and screw holes.

// License: MIT

A_LOT = 200;

bolts = import("bolts.json");
nuts = import("nuts.json");

DEFAULT_HEAD_DIAMETER_CLEARANCE = 0.1;
DEFAULT_BOLT_KIND = "headless";
DEFAULT_NUT_KIND = "hexagon";

function hex_inscribed_circle_d (w) = 2 * w / sqrt(3);

function bolt_data (options = undef, kind = DEFAULT_BOLT_KIND) = 
  is_undef(options) ? bolts : (is_string(options) ? bolts[options][kind] : options);

function nut_data (options = undef, kind = DEFAULT_NUT_KIND) =
  is_undef(options) ? nuts : (is_string(options) ? nuts[options][kind] : options);

function bolt_head_length (options, kind = DEFAULT_BOLT_KIND) =
  let (h = bolt_data(options, kind).head_length)
    is_undef(h) ? 0 : h;

function nut_height (options, kind = DEFAULT_NUT_KIND) =
  let (h = nut_data(options, kind).thickness)
    is_undef(h) ? 0 : h;

function nut_width_across_corners (options) =
  let (h = nut_data(options).width)
    is_undef(h) ? 0 : hex_inscribed_circle_d(h);

// Get maximum width of a nut.
// Aliased to `nut_width_across_corners` for now, but may change when, for example,
// flanged nuts are introduced.
function nut_max_width (options, kind = DEFAULT_NUT_KIND) = nut_width_across_corners(options);

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
  b = bolt_data(options, kind);

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
// bolt - generate a 2D bolt hole positive. Most commonly used because you're
// too lazy to turn that metric bolt size into a diameter.
//
// Usage:
//
//     bolt_2d("M3");
//
module bolt_2d (
  options
) {
  b = bolt_data(options, DEFAULT_BOLT_KIND);
  circle(d = b.diameter);
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
  kind = DEFAULT_BOLT_KIND,
  head_diameter_clearance = DEFAULT_HEAD_DIAMETER_CLEARANCE,
  head_top_clearance = 0,
  length_clearance = 0,
  countersink = 0
) {
  b = bolt_data(options, kind);

  head_length = is_num(b.head_length) ? b.head_length : 0;
  translate([0, 0, -countersink * head_length]) {
    translate([0, 0, -length_clearance]) {
      // If the bolt is headless, we consider the `head_top_clearance` an
      // extension of the bolt itself. Despite the kind name, the concept
      // of hiding a bolt beneath material and needing to expose its "head"
      // still applies.
      cylinder(d = b.diameter, h = length + length_clearance + (kind == "headless" ? head_top_clearance : 0));
    }

    if (kind != "headless") {
      // The "countersunk" bolt's (ISO 10642) head is part of the bolt length,
      // as opposed to any other case we handle/I can think of.
      translate([0, 0,  length - (kind == "countersunk" ? head_length : 0)]) {
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

module _nut (
  options,
  kind = "hexagon",
  height_clearance = 0,
  width_clearance = 0
) {
  n = nut_data(options, kind);
  thickness = kind == "hexagon_lock" ? n.nut_thickness : n.thickness;
  h = thickness + height_clearance;

  if (kind == "hexagon_lock") {
    lock_h = n.thickness - n.nut_thickness;
    cylinder(d = n.width + width_clearance, h = lock_h + height_clearance);
    translate([0, 0, lock_h]) {
      hexagon(d = hex_inscribed_circle_d(n.width + width_clearance), h = h);
    }
  }
  else {
    hexagon(d = hex_inscribed_circle_d(n.width + width_clearance), h = h);
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
  n = nut_data(options, kind);

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
  n = nut_data(options, kind);
  h = n.thickness + height_clearance;
  w = n.width + width_clearance;

  _nut(options, kind, height_clearance, width_clearance);
  translate([0, -w / 2]) {
    cube([length, w, h]);
  }
}
