{
  config,
  pkgs,
  lib,
  ...
}: {
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    bat
    coreutils
    curl
    delta # Alternative git diff pager
    du-dust
    envchain
    eza # Alternative `ls`
    fd # Alternative `find`
    fzf
    gawk
    git
    go
    gnused
    htop
    jdk
    jq
    neovim
    nodejs
    parallel
    pandoc
    procps
    pv # Pipe Viewer
    (python311.withPackages (p: with p; [pandas ipython black mypy pyright]))
    ripgrep
    shellcheck
    shfmt
    starship
    texlive.combined.scheme-full
    tmux
    tree-sitter
    watchman
    yq-go
    zig
  ];

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  programs.git = {
    enable = true;
    userName = "Sayan Paul";
    userEmail = "sayan.paul.us@gmail.com";
    signing = {
      key = "2DA1893F2D59E6A9";
      signByDefault = true;
    };

    delta.enable = true;

    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = "auto";
      pull.ff = "only";
      merge = {
        conflictstyle = "diff3";
        stat = "true";
      };
      diff.colorMoved = "dimmed-zebra";
      delta = {
        syntax-theme = "GitHub";
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
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Bold Italic";
        };
        size = 14;
        offset = {
          x = 0;
          y = 0;
        };
      };
      #--- Light Mode
      colors = {
        primary = {
          foreground = "0x4a484d";
          background = "0xffffff";
        };
        cursor = {
          text = "0xffffff";
          cursor = "0x4a484d";
        };
        selection = {
          text = "0xffffff";
          background = "0x4a484d";
        };
        normal = {
          black = "0x4a484d";
          red = "0xa50000";
          green = "0x005d26";
          yellow = "0x714700";
          blue = "0x1d3ccf";
          magenta = "0x88267a";
          cyan = "0x185570";
          white = "0xefefef";
        };
        bright = {
          black = "0x5e4b4f";
          red = "0x992030";
          green = "0x4a5500";
          yellow = "0x8a3600";
          blue = "0x2d45b0";
          magenta = "0x700dc9";
          cyan = "0x005289";
          white = "0xffffff";
        };
      };
      # --- Dark Mode
      # colors = {
      #   primary = {
      #     background = "0x1c1c1c";
      #     foreground = "0xf8f8f2";
      #   };
      #   cursor = {
      #     text = "CellBackground";
      #     cursor = "CellForeground";
      #   };
      #   vi_mode_cursor = {
      #     text = "CellBackground";
      #     cursor = "CellForeground";
      #   };
      #   search = {
      #     matches = {
      #       foreground = "0x44475a";
      #       background = "0x50fa7b";
      #     };
      #     focused_match = {
      #       foreground = "0x44475a";
      #       background = "0xffb86c";
      #     };
      #   };
      #   footer_bar = {
      #     background = "0x282a36";
      #     foreground = "0xf8f8f2";
      #   };
      #   line_indicator = {
      #     foreground = "None";
      #     background = "None";
      #   };
      #   selection = {
      #     text = "CellForeground";
      #     background = "0x44475a";
      #   };
      #   normal = {
      #     black = "0x000000";
      #     red = "0xff5555";
      #     green = "0x50fa7b";
      #     yellow = "0xf1fa8c";
      #     blue = "0xbd93f9";
      #     magenta = "0xff79c6";
      #     cyan = "0x8be9fd";
      #     white = "0xbfbfbf";
      #   };
      #   bright = {
      #     black = "0x4d4d4d";
      #     red = "0xff6e67";
      #     green = "0x5af78e";
      #     yellow = "0xf4f99d";
      #     blue = "0xcaa9fa";
      #     magenta = "0xff92d0";
      #     cyan = "0x9aedfe";
      #     white = "0xe6e6e6";
      #   };
      #   dim = {
      #     black = "0x14151b";
      #     red = "0xff2222";
      #     green = "0x1ef956";
      #     yellow = "0xebf85b";
      #     blue = "0x4d5b86";
      #     magenta = "0xff46b0";
      #     cyan = "0x59dffc";
      #     white = "0xe6e6d1";
      #   };
      # };
      keyboard = {
        bindings = [
          {
            key = "T";
            mods = "Command";
            chars = "\\u0002c";
          }
        ];
      };
      shell = {
        program = "${pkgs.fish}/bin/fish";
        args = [
          "-l"
          "-c"
          "tmux attach || tmux"
        ];
      };
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      vim = "nvim";
      ls = "exa";
    };
    shellAbbrs = {
      ga = "git add";
      gc = "git commit -v";
      gcam = "git commit -a -v -m";
      "gcn!" = "git commit -v --no-edit --amend --date=now";
      gd = "git diff";
      glo = "git log --oneline --decorate --color";
      glog = "git log --oneline --decorate --color --graph";
      gloo = "git log --pretty=format:'%C(yellow)%h %C(cyan)%ad %Cblue%an%Cgreen%d %Creset%s' --date=short";
      grbc = "git rebase --continue";
      grbi = "git rebase --interactive";
      gst = "git status";
      gco = "git checkout";
      gp = "git push origin \(git branch --show-current\)";
      gpf = "git push --force-with-lease origin \(git branch --show-current\)";
    };
    interactiveShellInit = ''
      starship init fish | source
      eval "$(/opt/homebrew/bin/brew shellenv)"
      direnv hook fish | source
      if type -q uv
        uv generate-shell-completion fish | source
      end
    '';
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    terminal = "xterm-256color";
    extraConfig = ''
      set-option -sa terminal-overrides ',xterm-256color:Tc'
      set-option -sg escape-time 10

      set-option -g status-position bottom
      set -g status-justify left
      set -g status-style "fg=#4c4c4b bg=#eeeeed bold"

      set-window-option -g mode-style "fg=#eeeeed bg=#0087af"

      set -g status-left ""
      set -g status-left-length 10

      set -g status-right "#[bg=#005f87 fg=#e4e4e4]  #S  "
      set -g status-right-length 40

      set -g window-status-current-style "fg=#e4e4e4 bg=#005f87"
      set -g window-status-style "fg=#444444 bg=#d0d0d0"
      set -g window-status-format "  #{window_name}  "
      set -g window-status-current-format "  #{window_name}  "
      set -g window-status-separator " "

      set -g message-style "fg=#4c4c4b bg=#eeeeed"

      set -g pane-active-border-style "fg=#4c4c4b bg=#eeeeed"
      set -g pane-border-style "fg=#4c4c4b bg=#eeeeed"

      # Inhibit the default styling for windows with unseen activity, which
      # looks blatantly incorrect with the "powerline" theme we are trying to
      # emulate.
      set-window-option -g window-status-activity-style none
      set-window-option -g window-status-activity-style none

      # Update the status bar every second, instead of the default 15(!)
      # seconds. It doesn't look like it's possible to update more than
      # once per second, unfortunately.
      set-option -g status-interval 1

      bind -n C-S-Left previous-window
      bind -n C-S-Right next-window

      # Open new windows and splits in the same directory as the current pane.
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind-key c new-window -c "#{pane_current_path}"
    '';
  };
}
