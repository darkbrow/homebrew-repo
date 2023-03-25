# homebrew-repo
add some build options to homebrew formulae

download formula and execute command in terminal

```
brew install --build-from-source /path/to/downloaded/formula
```

## ffmpeg.rb
- enable libfdk-aac option (removed on homebrew-core formula due to incompatible license).
- enable libcaca option.
- enable nonfree option.

## gnuplot.rb
- add some terminals (sixel, caca, bitmap-terminals).
- add gd, pango support.

## libcaca.rb
- add ncurses, slang to CACA_DRIVER.

## libsixel.rb
- new formula (doesn't exist on homebrew due to incompatible license).
- add png, gd, python support.

## macvim.rb
- use homebrew's tcl

## mpv.rb
- disable debug-build option.
- enable libcaca output.

## sc-im.rb
- add libxls support.

## unrar.rb
- remove deprecation warning.

## w3m.rb
- add image support (libsixel, iTerm 2.9+ required).