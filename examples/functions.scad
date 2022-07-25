use <../catchnhole.scad>;


echo(str("M8 bolt head length: ", bolt_head_length("M8", kind = "socket_head")));
echo(str("M5 locknut height: ", nut_height("M5", kind = "hexagon_lock")));
