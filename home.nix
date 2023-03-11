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
    yq-go
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

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 10;
          y = 10;
        };
        dynamic_padding = true;
        decorations = "buttonless";
        startup_mode = "Windowed";
      };
      scrolling = {
        history = 1000;
        multiplier = 3;
      };
      tabspaces = 4;
      font = {
        normal = {
          family = "JetBrains Mono";
          style = "Regular";
        };
        bold = {
          family = "JetBrains Mono";
          style = "Bold";
        };
        italic = {
          family = "JetBrains Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "JetBrains Mono";
          style = "Bold Italic";
        };
        size = 14;
        offset = {
          x = 0;
          y = 0;
        };
      };
      colors = {
        primary = {
          background = "0x1c1c1c";
          foreground = "0xf8f8f2";
        };
        cursor = {
          text = "CellBackground";
          cursor = "CellForeground";
        };
        vi_mode_cursor = {
          text = "CellBackground";
          cursor = "CellForeground";
        };
        search = {
          matches = {
            foreground = "0x44475a";
            background = "0x50fa7b";
          };
          focused_match = {
            foreground = "0x44475a";
            background = "0xffb86c";
          };
        };
        footer_bar = {
          background = "0x282a36";
          foreground = "0xf8f8f2";
        };
        line_indicator = {
          foreground = "None";
          background = "None";
        };
        selection = {
          text = "CellForeground";
          background = "0x44475a";
        };
        normal = {
          black = "0x000000";
          red = "0xff5555";
          green = "0x50fa7b";
          yellow = "0xf1fa8c";
          blue = "0xbd93f9";
          magenta = "0xff79c6";
          cyan = "0x8be9fd";
          white = "0xbfbfbf";
        };
        bright = {
          black = "0x4d4d4d";
          red = "0xff6e67";
          green = "0x5af78e";
          yellow = "0xf4f99d";
          blue = "0xcaa9fa";
          magenta = "0xff92d0";
          cyan = "0x9aedfe";
          white = "0xe6e6e6";
        };
        dim = {
          black = "0x14151b";
          red = "0xff2222";
          green = "0x1ef956";
          yellow = "0xebf85b";
          blue = "0x4d5b86";
          magenta = "0xff46b0";
          cyan = "0x59dffc";
          white = "0xe6e6d1";
        };
      };
      key_bindings = [
        {
          key = "T";
          mods = "Command";
          chars = "\u0002c";
        }
      ];
      shell = {
        program = "/run/current-system/sw/bin/fish";
        args = [
          "-l"
          "-c"
          "tmux attach || tmux"
        ];
      };
    };
  };
}
