use <../catchnhole.scad>;

echo(str("M3 diameter: ", bolt_diameter("M3")));
echo(str("M3 nut width across corners: ", nut_width_across_corners("M3")));
echo(str("M4 nut height: ", nut_height("M4")));
echo(str("M4 locknut height: ", nut_height("M4", kind = "hexagon_lock")));
echo(str("M8 bolt head length: ", bolt_head_length("M8", kind = "socket_head")));
echo("bolt data:");
echo(bolt_data());
