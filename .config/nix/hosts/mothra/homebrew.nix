{pkgs, ...}: {
  homebrew = {
    enable = true;

    # Global flags passed to `brew install --cask`
    caskArgs = {
      appdir = "/Applications";
      # Automatically overwrite pre-existing manual downloads in /Applications
      # force = true;
    };

    # Activation behavior when running `darwin-rebuild switch`
    onActivation = {
      # Fetch the latest Homebrew formulae/casks index during rebuilds
      autoUpdate = true;

      # Upgrade outdated casks and formulae during rebuilds
      upgrade = true;

      # Declarative enforcement: removes any brew package NOT listed in this file
      # Options: "none" | "uninstall" | "zap"
      #  - "uninstall": Removes the .app / package
      #  - "zap": Removes the package AND its preferences/cache (~/Library)
      cleanup = "uninstall";
    };

    # Extra Homebrew Taps (repositories)
    taps = [
      "homebrew/services"
      "jesseduffield/lazygit"
      "rsteube/tap"
      "spicetify/tap"
      {
        name = "acsandmann/tap";
        trusted = true;
      }
      {
        name = "asmvik/formulae";
        trusted = true;
      }
      {
        name = "felixkratz/formulae";
        trusted = true;
      }
    ];

    # Command-Line Tools (Prefer installing via Nix / Home-Manager instead)
    brews = [
      "rift"
      "yabai"
      "skhd"
      "sketchybar"
      "lua"
    ];

    # GUI Applications (.app bundles)
    casks = [
      "font-hermit"
      "font-sf-pro"
      "font-sketchybar-app-font"
      # "font-space-mono-nerd-font"
      # "font-ubuntu-mono-nerd-font"
      "linearmouse"
      "localsend"
      "mac-mouse-fix"
      "proton-drive"
      "proton-pass"
      "raycast"
      "sf-symbols"
      "wezterm"

      "beeper"
      "chatgpt"
      "commander-one"
      "discord"
      "ferdium"
      "google-chrome"
      "google-drive"
      "kobo"
      "obsidian"
      "readest"
      "spotify"
      "tailscale-app"
      "trilium-notes"
      "vlc"
      "whatsapp"
      "zen"
      "zoom"
    ];

    # Mac App Store Applications (Requires `mas` CLI tool in brews)
    # masApps = {
    #   "Xcode" = 497799835;
    #   "Amphetamine" = 937984708;
    # };
  };
}
