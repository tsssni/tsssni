![plana](./plana.gif)

GIF from [五臓六腑七](https://x.com/5zou6pu7/status/1778713263058063412)

# tsssni.nix

```nix
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
```

# tsssni.github-stats


![](https://github-readme-stats.vercel.app/api/top-langs/?username=tsssni&title_color=645e8c&text_color=bebad9&icon_color=f26dab&border_color=645e8c&bg_color=303446&show_icons=true&layout=compact&hide_title=true&hide_border=false&langs_count=20&count_private=false)

![](https://github-readme-stats.vercel.app/api?username=tsssni&title_color=645e8c&text_color=bebad9&icon_color=f26dab&border_color=645e8c&bg_color=303446&show_icons=true&hide_title=true&hide_border=false&include_all_commits=false&count_private=false)
