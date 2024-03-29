use <../catchnhole.scad>;

$fn = 50;
a = 50;
b = 25;
h = 25;
nutcatch_side_offset = 7.5;

difference () {
  // Reduce the height a little bit to drop the visual artifacts from the
  // `difference`s on a single surface. In practice, you wouldn't do this, since
  // the artifacts don't affect slicing, etc.
  translate([-a / 2, -b / 2, 0]) cube([a, b, h - 0.01]);

  // A lock nutcatch on the bottom:
  nutcatch_parallel("M3", kind = "hexagon_lock");
  bolt("M3", h);

  // Get one on the top as well:
  translate([0, -b / 4, h]) {
    mirror([0, 0, 1]) {
      nutcatch_parallel("M3");
      bolt("M3", h);
    }
  }


  // An M5 nutcatch with a countersunk screw:
  translate([10, b * 1/4, 0]) {
    nutcatch_parallel("M5");
    bolt("M5", h, kind = "countersunk");
  }

  // And just a countersunk M5 with a countersunk screw:
  translate([10, -b / 4, 0]) {
    bolt("M5", h, kind = "countersunk", countersink = 1);
  }

  // An M8 nutcatch with a socket head countersunk screw:
  translate([-15, 0, 0]) {
    nutcatch_parallel("M8");
    bolt("M8", h, kind = "socket_head", countersink = 0.5);
  }

  // A sidecut nutcatch:
  translate([a / 2 - nutcatch_side_offset, 5, 4])
    rotate([0, 270, 180]) {
      nutcatch_sidecut("M3");
      bolt("M3", nutcatch_side_offset, kind = "socket_head", countersink = 0.1);
    }

  // A sidecut locknut catch:
  translate([a / 2 - nutcatch_side_offset, -5, 4])
    rotate([0, 270, 180]) {
      nutcatch_sidecut("M3", kind = "hexagon_lock");
      bolt("M3", nutcatch_side_offset, kind = "socket_head", countersink = 0.1, length_clearance = 4);
    }
}
