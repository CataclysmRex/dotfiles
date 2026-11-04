# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # services.gnome.gnome-keyring.enable = true; # or hyprpolkitagent/kwallet depending on your WM

  nix.settings.experimental-features = ["nix-command" "flakes"];

  my.desktop.hyprland.enable = true;

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    maxGenerations = 5;
    extraConfig = ''
      remember_last_entry: yes
    '';
    extraEntries = ''
      /Windows
          protocol: efi
          path: uuid(fefe821b-f46c-4f4e-8645-6b1a6727dfdd):/EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  environment.etc.crypttab = {
    mode = "0600";
    text = ''
      veracrypt-data PARTUUID=ba32e70d-d279-4ed3-b935-9b8dc48e61aa /dev/null tcrypt-veracrypt,tcrypt-keyfile=/root/veracrypt-data.key
    '';
  };

  fileSystems."/mnt/Kash" = {
    device = "/dev/mapper/veracrypt-data";
    fsType = "ntfs";
  };

  # Ensure storage mounting services are enabled
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  networking.hostName = "gojira"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ogre = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    git
    unzip
    zip
    wezterm
    zsh
    clang
    obsidian
    trilium-desktop
    floorp-bin
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    proton-vpn
    protonmail-desktop
    calibre
    sigil
    spotify
    # Use kdePackages.qtstyleplugin-kvantum for Qt6 / Plasma 6
    # Use libsForQt5.qtstyleplugin-kvantum for Qt5
    kdePackages.qtstyleplugin-kvantum
    # kvantummanager
    openrgb
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.flatpak = {
    enable = true;
    packages = [
      "org.ferdium.Ferdium"
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.tailscale.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nixpkgs.config.allowUnfree = true;

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;

  programs.zsh.enable = true;

  services = {
    desktopManager.plasma6.enable = true;

    displayManager.plasma-login-manager.enable = false;
  };

  services.displayManager.sddm = {
    enable = true;

    # Enables experimental Wayland support
    wayland.enable = true;
  };

  services.hardware.openrgb.enable = true;

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.symbols-only
      hermit
      material-symbols
      paratype-pt-sans
      lexend
      scientifica
    ];
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    glibc
    # Add other common libraries required by your LSPs here
  ];

  services.syncthing = {
    enable = true;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}
