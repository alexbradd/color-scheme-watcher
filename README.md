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
sudo make install
```

By default, it will install into `/usr/local/bin/`. If you want to install in
some other place, you'll need to run:

```sh
make DESTDIR=my/install/root BIN=/my/bin/ install # with sudo if necessary
```

### Using the systemd user unit

To start the daemon at graphical login, I wrote a little systemd user service as
a starting point. To install it, just run:

```sh
sudo make systemd-install
systemctl daemon-reload --user
systemctl --user enable --now color-scheme-watcher.service
```

By default it will install into `/usr/local/lib/systemd/user/` and will expect
the binary to be in the default location.

Like for the installation, you can install the unit using a different place.
However, you'll need to edit it to execute the script from the correct path.

```sh
vim color-scheme-watcher.service # edit the unit with your editor of choice
make DESTDIR=/my/install/root SYSTEMD=/my/systemd/user/dir systemd-install # sudo if necessary
```

## Removing it

Run:

```sh
# Necessary if you have installed the systemd unit
systemctl --user disable --now color-scheme-watcher.service
systemctl daemon-reload --user
sudo make uninstall
```

If you used a different `DESTDIR`, `BIN` or `SYSTEMD` variables, make sure to
specify them.
