# haipkgs

nixos packages and modules for my own use (feel free to steal anyway)

btw if you do steal stuff from here keep in mind I have made a lot of my
own optimizations and tailored these packages for my specific use case

here's a list of what I have done/will do for most of the packages
- remove any darwin code (I don't use or plan to use a mac)
- assume wayland (for example electron wayland flags hard-coded)


### oki but how 2 use?!?

just add this to your flake.nix inputs (nix channel users cope)
```nix
  haipkgs = {
    url = "git+https://git.blahai.gay/blahai/haipkgs.git";
    inputs = {
      nixpkgs.follows = "nixpkgs";
    };
  };

```

then add this to your config somewhere
```nix
nixpkgs.overlays = [
  inputs.haipkgs.overlays.default
];
```

and congrats you can now use haipkgs 🎉

#### Cache??

yop

```nix
nix.settings = {
  substituters = [
    "https://haipkgs.cachix.org"
  ];
  trusted-public-keys = [
    "haipkgs.cachix.org-1:AcjMqIafTEQ7dw99RpeTJU2ywNUn1h8yIxz2+zjpK/A="
  ];
};
```
### credits

as always thank you to these wonderful people for making this possible
- isabelroses for beapkgs
- chaotic-cx team for chaotic-nyx
- NUR for the nix user repository
