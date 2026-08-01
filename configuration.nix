{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.mullvad-vpn.enable = true;
  networking.networkmanager.enable = true;
  networking.hostName = "roux";
  time.timeZone = "Australia/Sydney";

  # environment variables
  environment.sessionVariables = {
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.displayManager.ly.enable = true;
  security.pam.services.ly.enableGnomeKeyring = true;

  programs.appimage = {
  enable = true;
  binfmt = true;
  package = pkgs.appimage-run.override {
    extraPkgs = pkgs: with pkgs; [ icu ];
    };
  };

  programs.dconf = {
    enable = true;
    profiles.user.databases = [{
      settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Adwaita-dark";
      };
    }];
  };

  environment.sessionVariables.GTK_THEME = "Adwaita:dark";
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.waybar.enable = true;
  programs.firefox.enable = true;

  users.users.borna = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
  };

  programs.bash = {
    enableLsColors = true;
    completion.enable = true;
    promptInit = ''
  if [ "$UID" -eq 0 ]; then
    PS1="\[\e[1;31m\]\w\[\e[0m\] # "
  else
    PS1="\[\e[1;32m\]\w\[\e[0m\] \$ "
  fi
'';
    shellAliases = {
	rebuild = "sudo nixos-rebuild switch";
	nixedit = "sudoedit /etc/nixos/configuration.nix";
	ff = "clear;echo;fastfetch";
	c = "clear";
	nixclean = "sudo nix-collect-garbage";
	update = "cd /etc/nixos;sudo nix flake update;sudo nixos-rebuild switch --flake; cd -";
	};
  };

  programs.steam = {
  enable = true;
  };
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "gtk";
  };

  # thunar config
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # neovim config
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
  ];
  
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wget
    git
    fastfetch
    qbittorrent
    rofi
    alacritty
    swaybg
    pywal16
    pavucontrol
    htop
    wayfreeze
    filezilla
    emacs-gtk
    gearlever
    mullvad-vpn
    gnome-themes-extra
    dconf
    supersonic
    thunar-archive-plugin
    tree
    thunar-volman
    grim
    slurp
    wl-clipboard
    wl-clip-persist
    papirus-icon-theme
    bibata-cursors
    pulseaudio
    prismlauncher
    mullvad-vpn
  ];

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  system.stateVersion = "26.05"; # Did you read the comment?
}
