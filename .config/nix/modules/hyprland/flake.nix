{
  description = "Hyprland module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: {
    nixosModules.default = {
      config,
      lib,
      pkgs,
      ...
    }: let
      cfg = config.my.desktop.hyprland;
    in {
      options.my.desktop.hyprland.enable =
        lib.mkEnableOption "my Hyprland desktop configuration";

      config = lib.mkIf cfg.enable {
        programs.hyprland.enable = true;

        environment.systemPackages = with pkgs; [
          hypridle
          hyprpaper
          hyprpolkitagent
          playerctl
          # ags
          quickshell
          qt6.qt5compat
          # networkmanagerapplet
          hypridle
          gtklock
          rofi
          hyprpicker
          hyprshot
          kdePackages.qt6ct
          libsForQt5.qt5ct
          kdePackages.qqc2-desktop-style
          kdePackages.kirigami
        ];
      };
    };
  };
}
