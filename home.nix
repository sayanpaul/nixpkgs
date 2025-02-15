{
  config,
  pkgs,
  lib,
  nixpkgs-unstable,
  ...
}:
{
  home.stateVersion = "24.11";

  home.packages =
    with pkgs;
    [
      bat
      coreutils
      curl
      delta # Alternative git diff pager
      direnv
      du-dust
      envchain
      eza # Alternative `ls`
      fd # Alternative `find`
      ffmpeg_7-headless
      fzf
      gawk
      git
      go
      gnused
      htop
      jdk
      jq
      nodejs
      parallel
      pandoc
      procps
      pv # Pipe Viewer
      (python312.withPackages (
        p: with p; [
          pandas
          pip
          ipython
          basedpyright
          black
          mypy
        ]
      ))
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
      zellij
    ]
    ++ (with nixpkgs-unstable; [ neovim ]);

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  xdg.configFile."git/globalignore" = {
    enable = true;
    text = ''
      .DS_Store
      .dir-locals.el
      *venv/
      *.vscode/
      spaul_adhoc/
      .envrc
    '';
  };

  programs.git = {
    enable = true;
    userName = "Sayan Paul";
    userEmail = "sayan.paul.us@gmail.com";
    signing = {
      key = "2DA1893F2D59E6A9";
      signByDefault = true;
    };

    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = "auto";
      core = {
        excludesfile = "${config.xdg.configHome}/git/globalignore";
        commentChar = ";";
        untrackedcache = "true";
        fsmonitor = "true";
      };
      pull.ff = "only";
      merge = {
        conflictstyle = "diff3";
        stat = "true";
      };
      rebase.updateRefs = "true";
      rerere.enabled = "true";
      diff.colorMoved = "dimmed-zebra";
      maintenance = {
        auto = false;
        strategy = "incremental";
        # Update with new repos to track.
        repo = [ "${config.xdg.configHome}/nixpkgs" ];
      };
      fetch.writeCommitGraph = true;
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
        option_as_alt = "Both";
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
          "zellij attach --create"
        ];
      };
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      vim = "nvim";
      ls = "eza";
    };
    shellAbbrs = {
      ga = "git add";
      gc = "git commit -v";
      gcam = "git commit -a -v -m";
      "gc!" = "git commit -v --amend --date=now";
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
      set -g fish_key_bindings fish_vi_key_bindings
      starship init fish | source
      direnv hook fish | source

      # Preserve some readline shortcuts in vi mode
      bind -M insert \cF 'forward-char'
      bind -M insert \cA 'beginning-of-line'
      bind -M insert \cE 'end-of-line'
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

  programs.zellij.enable = true;

  # The translation logic in home-manager is not very intuitive
  home.file.".config/zellij/config.kdl".source = ./zellij/config.kdl;

  home.file.".config/ghostty/config".text = ''
    theme = dark:tempus-night,light:tempus-totus
    unfocused-split-opacity = 0.99
    font-size = 14
    font-thicken = true
    window-inherit-working-directory = true
    shell-integration = fish
  '';

  home.file.".config/ghostty/themes/tempus-night".text = ''
    palette = 0=#1a1a1a
    palette = 1=#ff929f
    palette = 2=#5fc940
    palette = 3=#c5b300
    palette = 4=#5fb8ff
    palette = 5=#ef91df
    palette = 6=#1dc5c3
    palette = 7=#c4bdaf
    palette = 8=#242536
    palette = 9=#f69d6a
    palette = 10=#88c400
    palette = 11=#d7ae00
    palette = 12=#8cb4f0
    palette = 13=#de99f0
    palette = 14=#00ca9a
    palette = 15=#e0e0e0
    background = 1a1a1a
    foreground = e0e0e0
    cursor-color = e0e0e0
    selection-background = e0e0e0
    selection-foreground = 1a1a1a
  '';

  home.file.".config/ghostty/themes/tempus-totus".text = ''
    palette = 0=#4a484d
    palette = 1=#a50000
    palette = 2=#005d26
    palette = 3=#714700
    palette = 4=#1d3ccf
    palette = 5=#88267a
    palette = 6=#185570
    palette = 7=#efefef
    palette = 8=#5e4b4f
    palette = 9=#992030
    palette = 10=#4a5500
    palette = 11=#8a3600
    palette = 12=#2d45b0
    palette = 13=#700dc9
    palette = 14=#005289
    palette = 15=#ffffff
    background = ffffff
    foreground = 4a484d
    cursor-color = 4a484d
    selection-foreground = ffffff
    selection-background = 4a484d
  '';

  home.file.".config/nvim" = {
    source = ./nvim;
    recursive = true;
  };

  editorconfig = {
    enable = true;
    settings = {
      "*.sh" = {
        indent_style = "space";
        indent_size = "4";
        binary_next_line = "true";
        switch_case_indent = "true";
        space_redirects = "true";
        keep_padding = "true";
      };
    };
  };
}
