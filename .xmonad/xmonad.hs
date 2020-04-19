import XMonad
import XMonad.Config.Desktop

main = xmonad desktopConfig
  { terminal = "alacritty"
  , borderWidth = 3
  , modMask = mod4Mask
  }
