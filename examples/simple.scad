use <../catchnhole.scad>;

$fn = 50;
a = 50;
b = 25;
h = 25;
nutcatch_side_offset = 7.5;

difference () {
  translate([-a / 2, -b / 2, 0]) cube([a, b, h]);

  nutcatch_parallel("M3");
  bolt("M3", h);

  translate([10, 0, 0]) {
    nutcatch_parallel("M5");
    bolt("M5", 22.2, kind = "countersunk");
  }

  translate([-15, 0, 0]) {
    nutcatch_parallel("M8");
    bolt("M8", h, kind = "socket_head", countersink = 0.5);
  }

  translate([a / 2 - nutcatch_side_offset, 0, 4])
    rotate([0, 270, 180]) {
      nutcatch_sidecut("M3");
      bolt("M3", nutcatch_side_offset, kind = "socket_head", countersink = 0.1);
    }

  cylinder(d = 3, h = 8, $fn=200);
}
