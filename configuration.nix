{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Hack to build on 24.05, some options-db dependency had an invalid XML
  documentation.enable = false;

  users.users.sayanpaul.home = /Users/sayanpaul;

  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    recursive
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  environment = {
    shells = with pkgs; [
      bashInteractive
      fish
      zsh
    ];

    variables = {
      SHELL = "${pkgs.fish}/bin/fish";
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      PAGER = "less -FirSwX";
      # The below are dependent on `nvim` and `bat` being installed by
      # home-manager
      BAT_STYLE = "plain";
      EDITOR = "nvim";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    };
  };

  programs.fish = {
    enable = true;
    useBabelfish = true;
    babelfishPackage = pkgs.babelfish;
    # Needed to address bug where $PATH is not properly set for fish:
    # https://github.com/LnL7/nix-darwin/issues/122
    shellInit = ''
      # Nix
      if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
      source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
      end
      # End Nix
    '';
  };

  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableFzfHistory = true;
    interactiveShellInit = ''
      alias ls=exa
      alias vim=nvim
    '';
  };

  security.pam.enableSudoTouchIdAuth = true;

  system.defaults = {
    CustomUserPreferences = {
      "com.google.Chrome"."ApplePressAndHoldEnabled" = false;
      "com.microsoft.VSCode"."ApplePressAndHoldEnabled" = false;
    };

    NSGlobalDomain = {
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };

    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;
      mru-spaces = false;
      showhidden = true;
      show-recents = false;
      tilesize = 32;
    };

    finder = {
      ShowStatusBar = true;
      ShowPathbar = true;
      FXDefaultSearchScope = "SCcf";
      FXPreferredViewStyle = "Nlsv";
      AppleShowAllExtensions = true;
    };
  };

  system.stateVersion = 4;
}
