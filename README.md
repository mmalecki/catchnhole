# catchnhole
Because `nutsnbolts` was taken.

An ergonomic way to create nutcatches, screw holes and countersinks in OpenSCAD.

![Nutcatches, screw holes and countersinks](examples/simple.png).

## Requirements and installation
`catchnhole` uses OpenSCAD's JSON import, which is only present in the nightly
build, and must be enabled.

Add a git submodule to your project:

```sh
git submodule add https://github.com/mmalecki/catchnhole catchnhole
```

## Usage
```openscad
use <catchnhole/catchnhole.scad>;
```

## Acknowledgements
* The [authors](https://github.com/boltsparts/BOLTS/graphs/contributors) of the [BOLTS](https://github.com/boltsparts/BOLTS) library
