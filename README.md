# `color-scheme-watcher`

A small script to run various scriplets on change of
`org.gnome.desktop.interface.color-scheme`.

From `color-scheme-watcher.sh --help`:

```txt
Usage: color-scheme-watcher.sh [options]...

Watch for changes to org.gnome.desktop.interface color-scheme and execute
scriplets.

Scriplets are little programs executed from XDG_DATA_HOME/color-scheme-watcher if
defined, otherwise from ~/.local/share/color-scheme-watcher. They will receive
as input one parameter depending on the value of 'color-scheme': 'light',
'dark' or 'default'.
```

## Using it

To install it, run:

```sh
make DESTDIR=~ install
```

By default, it will install into `~/.local/bin`. If you want to override this
prefix, run:

```sh
make DESTDIR=my/install/root BIN=/my/bin/ install
```


### Using the systemd user unit

To start the daemon at graphical login, I wrote a little systemd user service as
a starting point. To install it, just run:

```sh
make DESTDIR=~ systemd-install
systemctl daemon-reload --user
systemctl --user enable --now color-scheme-watcher.service
```

By default it will install into `~/.config/systemd/user`. Like for the
installation, you can install the unit using a different install root by running:

```sh
make DESTDIR=/my/install/root SYSTEMD=/my/systemd/user/dir systemd-install
```

## Removing it

Run:

```sh
# Necessary if you have installed the systemd unit
systemctl --user disable --now color-scheme-watcher.service
systemctl daemon-reload --user
make DESTDIR=~ uninstall
```

If you used a different `DESTDIR` and `SYSTEMD` variables, make sure to specify
them.
