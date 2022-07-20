use <../catchnhole.scad>;

$fn = 50;
a = 50;
b = 25;
h = 25;
nutcatch_side_offset = 7.5;

difference () {
  translate([-a / 2, -b / 2, 0]) cube([a, b, h]);

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
  translate([10, 0, 0]) {
    nutcatch_parallel("M5");
    bolt("M5", 22.2, kind = "countersunk");
  }

  // An M8 nutcatch with a socket head countersunk screw:
  translate([-15, 0, 0]) {
    nutcatch_parallel("M8");
    bolt("M8", h, kind = "socket_head", countersink = 0.5);
  }

  // A sidecut nutcatch:
  translate([a / 2 - nutcatch_side_offset, 0, 4])
    rotate([0, 270, 180]) {
      nutcatch_sidecut("M3");
      bolt("M3", nutcatch_side_offset, kind = "socket_head", countersink = 0.1);
    }
}
