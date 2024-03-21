# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
#      ./vfio.nix
      #inputs.home-manager.nixosModules.home-manager
    ];
 #home-manager = {
# 	extraSpecialArgs = { inherit inputs; };
#	users = {
#		raysamram = import ./home.nix;
#	};
# };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable the X11 windowing system.
  fonts.packages = with pkgs; [
  (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    font-awesome
  powerline-fonts
  powerline-symbols
];

  # Enable the KDE Plasma Desktop Environment.
services.xserver.enable = true;
services.xserver.displayManager.sddm.wayland.enable = true;  
services.xserver.displayManager.sddm.enable = true;
    
services.xserver.desktopManager.plasma5.enable = true;
  programs.hyprland = {
  	enable = true;
	nvidiaPatches = true;
	xwayland.enable = true;
 	};
  environment.sessionVariables = {
  	WLR_NO_HARDWARE_CURSORS = "1";
	NIXOS_OZONE_WL = "1";
	};
  hardware = {
  	opengl.enable = true;
# NVIDIA
	    opengl.driSupport = true;
    opengl.driSupport32Bit = true;
	};
hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
];
  hardware.enableAllFirmware = true; 
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    videoDrivers =[ "nvidia"]; #  "amdgpu" ];  #["nvidia"];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  security.rtkit.enable = true;

  # rtkit is optional but recommended
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  #jack.enable = true;
};


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.raysamram = {
    isNormalUser = true;
    description = "raysamram";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kate
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  #services.xserver.displayManager.autoLogin.enable = true;
  #services.xserver.displayManager.autoLogin.user = "raysamram";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  programs.zsh = {
  	enable = true;
	enableCompletion = true;
	enableAutosuggestions = true;
	syntaxHighlighting.enable = true;
	oh-my-zsh = {
	    enable = true;
	    plugins = [ "git" "thefuck" "fzf-tab" "poetry" "poetry"];
	  #  theme = "powerlevel10k/powerlevel10k";
	  };
      promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    # enable powerlevel10k
#    dotDir = ".config/zsh";  
  };
  users.defaultUserShell = pkgs.zsh;


environment.interactiveShellInit= ''
bindkey -s ^e 'selected_entry=$(find $HOME/Downloads $HOME/Documents -maxdepth 8 -type f -o -type d | fzf); [ -n "$selected_entry" ] && { [ -d "$selected_entry" ] && cd "$selected_entry" || vim "$selected_entry"; }\n'
bindkey -s ^f 'tmux-sessionizer\n'
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
    '';
   programs.steam = {
	enable = true;
	remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
	dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
	};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
	vim
	dunst
	libnotify
	waybar
	(waybar.overrideAttrs (oldAttrs: {
		mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
	})
	)
	hyprpaper
	swww
	kitty
	alacritty
	rofi-wayland
	discord
	wlr-randr
	way-displays
	git
	stow
	home-manager
    gparted
	btop
	bat
	eza
	feh
	lazygit
        zsh
	nodejs
	poetry
	killall
	pavucontrol
	lutris
	eww
	foot
	vscode
	swaylock
	coreutils
	cliphist
	cmake
	curl
	fuzzel
	rsync
	ripgrep
    tmux
	gojq
	meson
	typescript
	gjs
	dart-sass
	axel
	inotify-tools
	neofetch
	wl-clipboard
	xclip
	conda
	pipx
    zsh-powerlevel10k
	gcc
	qemu
	fzf
    thefuck
    flameshot
    # support both 32- and 64-bit applications
    wineWowPackages.stable

    # support 32-bit only
    wine

    # support 64-bit only
    (wine.override { wineBuild = "wine64"; })

    # support 64-bit only
    wine64

    # wine-staging (version with experimental features)
    wineWowPackages.staging

    # winetricks (all versions)
    winetricks

    # native wayland support (unstable)
    wineWowPackages.waylandFull

  ];
programs.neovim = {
  enable = true;
  defaultEditor = true;
};
environment.variables.XCURSOR_SIZE = "32";
programs.bash.shellAliases = {
    oldvim="\vim";
    vim="nvim";
    vimdiff="nvim -d";
    vi="nvim";
    oldvi="\vi";
    top="bpytop";
    htop="bpytop";
    cat="bat";
    ls="lsd";
};


nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  programs.gamemode.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.copySystemConfiguration = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
