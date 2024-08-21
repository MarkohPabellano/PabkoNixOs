# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-ae9d212b-67be-4f38-bae9-0549e074e46d".device = "/dev/disk/by-uuid/ae9d212b-67be-4f38-bae9-0549e074e46d";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable Virtualization
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Nix-Flakes 
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # auto-cpufreq configuration
  programs.auto-cpufreq.enable = true;
    # optionally, you can configure your auto-cpufreq settings, if you have any
    programs.auto-cpufreq.settings = {
    charger = {
      governor = "performance";
      turbo = "auto";
    };

    battery = {
      governor = "powersave";
      turbo = "auto";
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Manila";
  #services.automatic-timezoned.enable = true;


  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Fcitx5
  i18n.inputMethod = {
  enabled = "fcitx5";
  #waylandFrontend = true;
  fcitx5.addons = with pkgs; [
     rime-data
     fcitx5-gtk
     fcitx5-chinese-addons
     fcitx5-rime
   ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  #Enable xdg.portal
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable automatic network printer detection
  services.avahi = {
  enable = true;
  nssmdns = true;
  openFirewall = true;
  };


  # Sound (Pipewire)
  #sound.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  systemd.user.services.pipewire-pulse.path = [ pkgs.pulseaudio ];

  # Bluetooth Stuff
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez;
    powerOnBoot = false;
    settings.general = {
      enable = "Source,Sink,Media,Socket";
    };
  };


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marks = {
    isNormalUser = true;
    description = "marks";
    extraGroups = [ "mlocate" "samba" "libvirtd" "networkmanager" "wheel"];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Enable flatpak
  services.flatpak.enable = true;


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  	wget
	git
	neovim
	pavucontrol
	brave
	fastfetch
	python3
	vscode
	mission-center
	gnome-keyring
	gtk2
	gtk3
	gtk4
	xfce.xfce4-panel-profiles
	xfce.xfce4-whiskermenu-plugin
	xfce.xfce4-pulseaudio-plugin
	xfce.xfce4-clipman-plugin
    (python3.withPackages (subpkgs: with subpkgs; [
        pip
        pygobject3
      ]))
];

fonts.packages = with pkgs; [
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  corefonts
  liberation_ttf
  fira-code
  fira-code-symbols
  mplus-outline-fonts.githubRelease
  dina-font
  proggyfonts
  #vistafonts
	#vistafonts-cht
	#vistafonts-chs
];

services.xserver.excludePackages = with pkgs; [ 
	xterm 
  ];

home-manager = {
   # also pass inputs to home-manager modules
   extraSpecialArgs = { inherit inputs; };
   users = {
   	"marks" = import ./home.nix;
   };
};
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
