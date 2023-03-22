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
    du-dust
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
    neovim
    nodejs
    parallel
    pv # Pipe Viewer
    (python310.withPackages (p: with p; [pandas ipython black mypy pyright]))
    ripgrep
    shellcheck
    shfmt
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
          chars = "\\u0002c";
        }
      ];
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
    interactiveShellInit = "starship init fish | source";
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    terminal = "xterm-256color";
    extraConfig = ''
      set-option -sa terminal-overrides ',xterm-256color:Tc'

      ## Status bar

      # The following code is adapted from:
      # https://coderwall.com/p/trgyrq/make-your-tmux-status-bar-responsive
      # It provides the same appearance as https://github.com/powerline/powerline,
      # but sidesteps the environment/configuration hell which that project
      # introduces.

      # Format to display on the left-hand side of the status bar.
      # Note that the conditional #{?cond,true,false} operator does not do any
      # fancy parsing, so you can't have literal commas in the conditions --
      # this will cause the conditions to be split up. So we have to use multiple
      # style #[attr=value] directives.
      set-option -g status-left '\
      #{?client_prefix,\
      #[fg=colour254]#[bg=colour31],\
      #[fg=colour16]#[bg=colour254]#[bold]}\
       #{=80:session_name}\
       #{?client_prefix,\
      #[fg=colour31],\
      #[fg=colour254]}\
      #[bg=colour234,nobold] '

      # Maximum length of the format displayed on the left-hand side.
      # Since the maximum length of the session name is limited in the above
      # format string, this number is unimportant -- it just needs to be a
      # bit larger than what is allocated for the session name, to allow for
      # the surrounding characters.
      set-option -g status-left-length 90

      # Format to display on the right-hand side of the status bar.
      set-option -g status-right \'\'

      # Format to display for the current window.
      #set-option -g window-status-current-format "\
      #[fg=colour117,bg=colour31] #{window_index}#{window_flags} \
      #[fg=colour231,bold]#{window_name} #[fg=colour31,bg=colour234,nobold] "
      set-option -g window-status-current-format "\
      #[fg=colour147,bg=colour135] #{window_index}#{window_flags} \
      #[fg=colour231,bold]#{window_name} #[fg=colour31,bg=colour234,nobold] "

      # Format to display for other windows.
      set-option -g window-status-format "\
      #[fg=colour244,bg=colour234]#{window_index}#{window_flags} \
      #[fg=colour249]#{window_name} "

      # Background color for parts of the status bar not specified by the above
      # formats. For instance, the empty space to the right, and the single
      # spaces between instances of window-status-format.
      set-option -g status-bg colour234

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
