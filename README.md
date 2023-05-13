# `color-scheme-watcher`

A small script to run various scriplets on change of
`org.gnome.desktop.interface.color-scheme`.

From `color-scheme-watcher.sh --help`:

```txt
Usage: color-scheme-watcher.sh [options]...

Whatch for changes to org.gnome.desktop.interface color-scheme and execute
scriplets.

Scriplets are little programs executed from XDG_DATA_HOME/color-scheme-watcher if
defined, otherwise from ~/.local/share/color-scheme-watcher. They will receive
as input one parameter depending on the value of 'color-scheme': 'light',
'dark' or 'default'.
```
