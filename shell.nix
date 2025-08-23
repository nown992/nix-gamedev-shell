{ pkgs ? import <nixpkgs> {} }:
  
  let
    overrides = (builtins.fromTOML (builtins.readFile ./rust-toolchain.toml));
    libPath = with pkgs; lib.makeLibraryPath [
    ];
in
  pkgs.mkShell rec {
    buildInputs = with pkgs; [
    alsa-lib.dev
    alsa-lib
    pkg-configUpstream
    rust-analyzer
    rustup
    rustc
    clang
    llvmPackages.bintools
    fontconfig
    mono6
    cmake
    xorg.libXi
    xorg.libXext
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    xorg.libX11
    xorg.libX11.dev
    libGL
    zlib
    libiconv
    openssl.dev
    rustup
    wayland
    ];
    
    LIBCLANG_PATH = pkgs.lib.makeLibraryPath [ pkgs.llvmPackages_latest.libclang.lib ];
    
    shellHook = ''
      export PATH=$PATH:''${CARGO_HOME:-~/.cargo}/bin
      export PATH=$PATH:''${RUSTUP_HOME:-~/.rustup}/toolchains/$RUSTC_VERSION-x86_64-unknown-linux-gnu/bin/
      '';
    
    RUSTFLAGS = (builtins.map (a: ''-L ${a}/lib'') [
    ]);
    
    LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${ with pkgs; lib.makeLibraryPath [
    wayland
    libxkbcommon
    fontconfig
    vulkan-loader
    libGL
    libGLU
    alsa-lib.dev
    alsa-lib
    xorg.libXi
    xorg.libXext
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    xorg.libX11
    xorg.libX11.dev
    libGL
 
    ] }";


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
