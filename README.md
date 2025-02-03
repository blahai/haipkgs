# haipkgs

nixos packages and modules for my own use (feel free to steal anyway)

btw if you do steal stuff from here keep in mind I have made a lot of my
own optimizations and tailored these packages for my specific use case

here's a list of what I have done/will do for most of the packages
- remove any darwin code (I don't use or plan to use a mac)
- assume wayland (for example electron wayland flags hard-coded)

and if you do want to use these with the overlay (recommended) add this
to your nixos config
```nix
nixpkgs.overlays = [
  inputs.haipkgs.overlays.default
];
```


as always thank you to these wonderful people for making this possible
- isabelroses for beapkgs
- chaotic-cx team for chaotic-nyx
- NUR for the nix user repository
