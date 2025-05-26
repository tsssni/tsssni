{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tsssni;
in
{
  options.tsssni =
    let
      mkBool = desc: lib.mkEnableOption ("whether tsssni is using " + desc);
    in
    {
      systemSupport = mkBool "current system";
      languagesSupport = mkBool "languages supported by launched treesitters";
      editorSupport = mkBool "specific code editor";
      riceSupport = mkBool "specific programs for unix ricing";
      graphicsSupport =
        let
          apisOptions = apiLists: lib.mapListsToAttrs apiLists (api: mkBool api);
        in
        { }
        ++ (apisOptions [
          "vulkan"
          "opengl"
          "d3d12"
          "d3d11"
          "d3d9"
          "metal"
        ]);
    };

  config.tsssni = lib.mkIf cfg.enable (
    let
      anyPackageIn = pkgsList: list: (builtins.any (p: builtins.elem p list) pkgsList);
      anyEnabled = attrsList: (builtins.any (attrs: attrs.enable) attrsList);
    in
    with pkgs;
    {
      systemSupport =
        let
          system = stdenv.hostPlatform;
        in
        false || (system.isLinux && system.isx86_64) || (system.isDarwin && system.isAaarch64);

      languageSupport = anyPackageIn (with vimPlugins.nvim-treesitter.builtGrammars; [
        c
        cpp
        cmake
        glsl
        hlsl
        slang
        nix
      ]) config.nixvim.plugins.treesittter.grammarPackages;

      graphicsSupport = {
        vulkan = true;
        opengl = true;
        d3d12 = true;
      };

      editorSupport = config.nixvim.defaultEditor;

      riceSupport = anyEnabled (
        with config.programs;
        [
          hyprland
          ags
        ]
      );
    }
  );
}
