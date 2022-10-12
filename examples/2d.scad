use <../catchnhole.scad>;

difference () {
  square([20, 80]);
  translate([10, 20]) bolt_2d("M8");
  translate([10, 40]) bolt_2d("M8");
  translate([10, 60]) bolt_2d("M8");
}
