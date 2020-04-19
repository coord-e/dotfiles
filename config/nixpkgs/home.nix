{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    gnumake
    maim
    dmenu
    mosh
    gitAndTools.hub
    nodejs
    python
    tmux
  ];

  programs.git.enable = true;
  programs.fzf.enable = true;
  programs.direnv.enable = true;
  programs.neovim.enable = true;

  programs.alacritty.enable = true;
  programs.chromium.enable = true;
  programs.vscode.enable = true;

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = haskellPackages: [
      haskellPackages.xmonad-contrib
      haskellPackages.xmonad-extras
      haskellPackages.xmonad
    ];
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "19.09";
}
