{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "timofey";
  home.homeDirectory = "/home/timofey";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # cli tools
    pkgs.vim
    pkgs.bat
    pkgs.pfetch
    pkgs.lazygit

    # security
    pkgs.keepassxc

    # utils
    pkgs.wofi

    # internet
    pkgs.firefox
    pkgs.telegram-desktop

    # fonts
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    pkgs.font-awesome
    pkgs.jetbrains-mono

    # pkgs.wezterm # ne mogu ponyat v chem problema. ustanovlyu cherez defoltniy manager paketov
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/lsd".source = ../../lsd;
    ".config/wezterm".source = ../../wezterm;
    ".vimrc".source = ../../vim/vimrc;
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/timofey/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs = {
    fish = {
      enable = true;
      shellAliases = { mkdir = "mkdir -p"; };
      functions = {
        fish_greeting = { body = "clear; pfetch"; };
        mkcd = { body = "mkdir -p $argv[1]; and cd $argv[1]"; };
      };
    };

    starship.enable = true;

    lsd = {
      enable = true;
      enableAliases = true;
    };

    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };

    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      shell = "${pkgs.fish}/bin/fish";
      extraConfig = ''set -ag terminal-overrides ",xterm*:Tc"''; # Set true color
      plugins = [ {
        plugin = pkgs.tmuxPlugins.dracula;
        extraConfig = ''
          set -g @dracula-show-powerline true
          set -g @dracula-show-left-icon session
          set -g @dracula-plugins "cpu-usage ram-usage"
        '';
      } ];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
