{
  config,
  pkgs,
  lib,
  ...
}: {
  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    bat
    coreutils
    curl
    delta # Alternative git diff pager
    envchain
    exa # Alternative `ls`
    fd # Alternative `find`
    fzf
    gawk
    git
    gnused
    htop
    jdk
    jq
    moreutils
    neovim
    pv # Pipe Viewer
    python311
    ripgrep
    starship
    texlive.combined.scheme-full
    tmux
    tree-sitter
    watchman
  ];

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  programs.git = {
    enable = true;
    userName = "Sayan Paul";
    userEmail = "sayan.paul.us@gmail.com";

    delta.enable = true;

    extraConfig = {
      color.ui = "auto";
      pull.ff = "only";
      merge = {
        conflictstyle = "diff3";
        stat = "true";
      };
      diff.colorMoved = "dimmed-zebra";
      delta = {
        syntax-theme = "OneHalfDark";
        navigate = "true";
        line-numbers = "true";
      };
    };
  };
}
