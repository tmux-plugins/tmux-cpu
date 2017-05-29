# Tmux cpu status

Enables displaying cpu percentage and status icon in Tmux status-right.

## Installation
### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @plugin 'tmux-plugins/tmux-cpu'

Hit `prefix + I` to fetch the plugin and source it.

If format strings are added to `status-right`, they should now be visible.

### Manual Installation

Clone the repo:

    $ git clone https://github.com/tmux-plugins/tmux-cpu ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/cpu.tmux

Reload TMUX environment:

    # type this in terminal
    $ tmux source-file ~/.tmux.conf

If format strings are added to `status-right`, they should now be visible.

### Optional requirement (Linux, BSD, OSX)

`iostat` or `sar` are the best way to get an accurate cpu percentage

A fallback is included using `ps -aux` but could be inaccurate.

## Usage

Add `#{cpu_icon}`, `#{cpu_percentage}` `#{cpu_fg_color}`, or
`#{cpu_bg_color}` format strings to existing `status-right` tmux option.
Example:

    # in .tmux.conf
    set -g status-right '#{cpu_bg_color} CPU: #{cpu_icon} #{cpu_percentage} | %a %h-%d %H:%M '


## Examples
CPU usage lower than 30%:<br/>
![low_fg](/screenshots/low_fg.png)
![low_bg](/screenshots/low_bg.png)
![low_icon](/screenshots/low_icon.png)

CPU usage between 30% and 80%:<br/>
![medium_fg](/screenshots/medium_fg.png)
![medium_bg](/screenshots/medium_bg.png)
![medium_icon](/screenshots/medium_icon.png)

CPU usage higher than 80%:<br/>
![high_fg](/screenshots/high_fg.png)
![high_bg](/screenshots/high_bg.png)
![high_icon](/screenshots/high_icon.png)

This is done by introducing 4 new format strings that can be added to
`status-right` option:
- `#{cpu_icon}` - will display a cpu status icon
- `#{cpu_percentage}` - will show cpu percentage
- `#{cpu_bg_color}` - will set the background color of the status bar based on the cpu percentage
- `#{cpu_fg_color}` - will set the foreground color of the status bar based on the cpu percentage

## Changing default

By default, these icons are displayed:

 - low: "="
 - medium: "≡"
 - high: "≣"

And these colors are used:

 - low: `#[fg=green]` `#[bg=green]`
 - medium: `#[fg=yellow]` `#[bg=yellow]`
 - high: `#[fg=red]` `#[bg=red]`

Note that these colors depend on your terminal / X11 config.

You can change these defaults by adding the following to `.tmux.conf`:

```
set -g @cpu_low_icon "ᚋ"
set -g @cpu_medium_icon "ᚌ"
set -g @cpu_high_icon "ᚍ"

set -g @cpu_low_fg_color "#[fg=#00ff00]"
set -g @cpu_medium_fg_color "#[fg=#ffff00]"
set -g @cpu_high_fg_color "#[fg=#ff0000]"

set -g @cpu_low_bg_color "#[bg=#00ff00]"
set -g @cpu_medium_bg_color "#[bg=#ffff00]"
set -g @cpu_high_bg_color "#[bg=#ff0000]"
```


Don't forget to reload tmux environment (`$ tmux source-file ~/.tmux.conf`)
after you do this.

### Tmux Plugins

This plugin is part of the [tmux-plugins](https://github.com/tmux-plugins) organisation. Checkout plugins as [battery](https://github.com/tmux-plugins/tmux-battery), [logging](https://github.com/tmux-plugins/tmux-logging), [online status](https://github.com/tmux-plugins/tmux-online-status), and many more over at the [tmux-plugins](https://github.com/tmux-plugins) organisation page.

You might want to follow [@brunosutic](https://twitter.com/brunosutic) on
twitter if you want to hear about new tmux plugins or feature updates.

### Maintainer

 - [Camille Tjhoa](https://github.com/ctjhoa)

### License

[MIT](LICENSE.md)

