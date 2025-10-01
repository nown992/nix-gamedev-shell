{ pkgs ? import <nixpkgs> {} }:

  let
    overrides = (builtins.fromTOML (builtins.readFile ./rust-toolchain.toml));
    libPath = with pkgs; lib.makeLibraryPath [
    ];
in
with pkgs;
  
  mkShell rec {
  nativeBuildInputs = [
    pkg-config
  ];

#wayland is seperate as it seems to stop vulkan reading the backend if in LD_LIBRARY_PATH
  waylandInput = [
  wayland
  ];
  buildInputs = [
    wayland.dev
    alsa-lib
    libxkbcommon 
    vulkan-tools
    vulkan-headers
    vulkan-loader
    vulkan-validation-layers
    lld 
    pkg-config 
    cmake
    clang
    systemd
    pkg-configUpstream
    rust-analyzer
    rustup
    rustc
    llvmPackages.bintools
    fontconfig
    mono6
    libxkbcommon
    libGL
    xorg.libXi
    xorg.libXext
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    xorg.libX11
    xorg.libX11.dev
    zlib
    libxkbcommon
    libudev-zero
    udev
    libiconv
    openssl.dev
    rustup
    ];
     LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;
     LIBCLANG_PATH = pkgs.lib.makeLibraryPath [ pkgs.llvmPackages_latest.libclang.lib ];
    
    shellHook = ''
      export PATH=$PATH:''${CARGO_HOME:-~/.cargo}/bin
      export PATH=$PATH:''${RUSTUP_HOME:-~/.rustup}/toolchains/$RUSTC_VERSION-x86_64-unknown-linux-gnu/bin/
      '';
    
    RUSTFLAGS = (builtins.map (a: ''-L ${a}/lib'') [
    ]);
  BINDGEN_EXTRA_CLANG_ARGS =
    (builtins.map (a: ''-I"${a}/include"'') [
      pkgs.glibc.dev
    ])
    ++ [
      ''-I"${pkgs.llvmPackages_latest.libclang.lib}/lib/clang/${pkgs.llvmPackages_latest.libclang.version}/include"''
      ''-I"${pkgs.glib.dev}/include/glib-2.0"''
      ''-I${pkgs.glib.out}/lib/glib-2.0/include/''
    ];

}

