# Tmux CPU and GPU status

Enables displaying CPU and GPU information in Tmux `status-right` and `status-left`.
Configurable percentage and icon display.

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

`iostat` or `sar` are the best way to get an accurate CPU percentage.
A fallback is included using `ps -aux` but could be inaccurate.
`nvidia-smi` is required for GPU information.
For OSX, `cuda-smi` is required instead (but only shows GPU memory use rather
than load).

## Usage

Add any of the supported format strings (see below) to the existing `status-right` tmux option.
Example:

    # in .tmux.conf
    set -g status-right '#{cpu_bg_color} CPU: #{cpu_icon} #{cpu_percentage} | %a %h-%d %H:%M '

### Supported Options

This is done by introducing 8 new format strings that can be added to
`status-right` option:

 - `#{cpu_icon}` - will display a CPU status icon
 - `#{cpu_percentage}` - will show CPU percentage (averaged across cores)
 - `#{cpu_bg_color}` - will change the background color based on the CPU percentage
 - `#{cpu_fg_color}` - will change the foreground color based on the CPU percentage

GPU equivalents also exist:

 - `#{gpu_icon}` - will display a GPU status icon
 - `#{gpu_percentage}` - will show GPU percentage (averaged across devices)
 - `#{gpu_bg_color}` - will change the background color based on the GPU percentage
 - `#{gpu_fg_color}` - will change the foreground color based on the GPU percentage

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

### Maintainer

 - [Camille Tjhoa](https://github.com/ctjhoa)

### License

[MIT](LICENSE.md)
