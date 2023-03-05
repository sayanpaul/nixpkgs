1. Install and setup Nix
    ```console
    $ curl -L https://nixos.org/nix/install | sh
    $ nix-shell -p nix-info --run "nix-info -m"
    $ mkdir -p ~/.config/nix
    $ echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
    ```
1. Clone this repo to `~/.config`
    ```console
    $ cd ~/.config
    $ git clone git@github.com:sayanpaul/nixpkgs.git
    ```
1. Install Homebrew for `nix-darwin`-managed casks
1. Install configuration 
    ```console
    $ sudo mv /etc/nix/nix.conf /etc/nix/.nix-darwin.bkp.nix.conf
    $ nix build .\#darwinConfigurations."Sayans-MacBook-Pro".system
    $ ./result/sw/bin/darwin-rebuild switch --flake .
    ```
