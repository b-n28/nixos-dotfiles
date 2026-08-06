{ config, lib, pkgs, inputs, ... }:

let
  stable = import inputs.nixpkgs-stable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.overlays = [
    (final: prev: { xdg-desktop-portal = stable.xdg-desktop-portal; })
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.mullvad-vpn.enable = true;
  networking.networkmanager.enable = true;
  networking.hostName = "roux";
  time.timeZone = "Australia/Sydney";

  networking.hosts = {
  "192.168.0.129" = [ "vault.bornaja.xyz" ];
  };
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

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment.sessionVariables.GTK_THEME = "Adwaita:dark";
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = stable.hyprland;
  };

  programs.waybar.enable = true;
  programs.firefox.enable = true;
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
	wlrobs
	obs-backgroundremoval
	obs-pipewire-audio-capture
	obs-vaapi
	obs-vkcapture
	obs-gstreamer
	];
  };

  users.users.borna = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
  };

  programs.fzf = {
    keybindings = true;
    fuzzyCompletion = true;
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
	mkdir = "mkdir -pv";
	c = "clear";
	nixclean = "sudo nix-collect-garbage";
	update = "cd /etc/nixos;sudo nix flake update;sudo nixos-rebuild switch --flake; cd -";
	};
  };

  programs.steam = {
  enable = true;
  };

  services.flatpak.enable = true;
  xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = "gtk";
        hyprland.default = [ "hyprland" "gtk" ];
      };
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

  hardware.graphics = {
  enable = true;
  enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    tree
    wget
    glib
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
    libreoffice
    emacs-gtk
    gearlever
    mullvad-vpn
    gnome-themes-extra
    dconf
    supersonic
    thunar-archive-plugin
    thunar-volman
    grim
    slurp
    wl-clipboard
    wl-clip-persist
    papirus-icon-theme
    bibata-cursors
    stremio-linux-shell
    pulseaudio
    prismlauncher
    mullvad-vpn
    lutris
    mpv
    swayimg
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

  systemd.user.services = {
      xdg-desktop-portal = {
        overrideStrategy = "asDropin";
        unitConfig.Requisite = [ "" ];
      };
      xdg-desktop-portal-hyprland = {
        overrideStrategy = "asDropin";
        unitConfig.Requisite = [ "" ];
      };
      xdg-desktop-portal-gtk = {
        overrideStrategy = "asDropin";
        unitConfig.Requisite = [ "" ];
      };
    };

  system.stateVersion = "26.05"; # Did you read the comment?
}
