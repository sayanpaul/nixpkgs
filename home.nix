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
      dust
      duckdb
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
      zoxide
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
    signing = {
      key = "2DA1893F2D59E6A9";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "Sayan Paul";
        email = "sayan.paul.us@gmail.com";
      };
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
      zoxide init fish | source

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

  home.file.".config/ghostty" = {
    source = ./ghostty;
    recursive = true;
  };

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
