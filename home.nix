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
      cloc
      coreutils
      curl
      difftastic
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
      jdk
      jq
      nixfmt-rfc-style
      nodejs
      parallel
      pandoc
      procps
      pv # Pipe Viewer
      ripgrep
      shellcheck
      shfmt
      starship
      stylua
      texlive.combined.scheme-full
      tmux
      tree-sitter
      watchman
      yq-go
      zig
      zoxide
    ]
    ++ (with nixpkgs-unstable; [
      deno
      jujutsu
      neovim
      uv
    ]);

  xdg.enable = true;

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
      format = "ssh";
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "Sayan Paul";
        email = "sayan.paul.us@gmail.com";
      };
      init.defaultBranch = "main";
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
      alias = {
        dl = "-c diff.external=difft log -p --ext-diff";
        ds = "-c diff.external=difft show --ext-diff";
        dft = "-c diff.external=difft diff";
      };
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      vim = "nvim";
      ls = "eza";
    };
    plugins = [
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
    shellAbbrs = {
      ga = "git add";
      gc = "git commit -v";
      gcam = "git commit -a -v -m";
      "gc!" = "git commit -v --amend --date=now";
      "gcn!" = "git commit -v --no-edit --amend --date=now";
      gd = "git dft";
      gds = "git ds";
      gdl = "git dl";
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

      # Inline the output of /opt/homebrew/bin/brew shellenv
      set --global --export HOMEBREW_PREFIX "/opt/homebrew";
      set --global --export HOMEBREW_CELLAR "/opt/homebrew/Cellar";
      set --global --export HOMEBREW_REPOSITORY "/opt/homebrew";
      fish_add_path --global --move --path "/opt/homebrew/bin" "/opt/homebrew/sbin";
      if test -n "$MANPATH[1]"; set --global --export MANPATH \'\' $MANPATH; end;
      if not contains "/opt/homebrew/share/info" $INFOPATH; set --global --export INFOPATH "/opt/homebrew/share/info" $INFOPATH; end;

      fish_add_path --path ~/.local/bin
    '';
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Sayan Paul";
        email = "sayan.paul.us@gmail.com";
      };
      ui.diff-formatter = [
        "${pkgs.difftastic}/bin/difft"
        "--color=always"
        "$left"
        "$right"
      ];
      signing = {
        behavior = "own";
        sign-all = true;
        backend = "ssh";
        key = "~/.ssh/id_ed25519.pub";
      };
    };
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
