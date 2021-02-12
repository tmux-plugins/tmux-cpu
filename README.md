# Tmux CPU and GPU status

Enables displaying CPU and GPU information in Tmux `status-right` and `status-left`.
Configurable percentage and icon display.

## Installation
### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

```shell
set -g @plugin 'tmux-plugins/tmux-cpu'
```

Hit `prefix + I` to fetch the plugin and source it.

If format strings are added to `status-right`, they should now be visible.

### Manual Installation

Clone the repo:

```shell
$ git clone https://github.com/tmux-plugins/tmux-cpu ~/clone/path
```

Add this line to the bottom of `.tmux.conf`:

```shell
run-shell ~/clone/path/cpu.tmux
```

Reload TMUX environment:

```shell
# type this in terminal
$ tmux source-file ~/.tmux.conf
```

If format strings are added to `status-right`, they should now be visible.

### Optional requirements (Linux, BSD, OSX)

- `iostat` or `sar` are the best way to get an accurate CPU percentage.
A fallback is included using `ps -aux` but could be inaccurate.
- `free` is used for obtaining system RAM status.
- `lm-sensors` is used for CPU temperature.
- `nvidia-smi` is required for GPU information.
For OSX, `cuda-smi` is required instead (but only shows GPU memory use rather than load).
If "No GPU" is displayed, it means the script was not able to find `nvidia-smi`/`cuda-smi`.
Please make sure the appropriate command is installed and in the `$PATH`.

## Usage

Add any of the supported format strings (see below) to the existing `status-right` tmux option.
Example:

```shell
# in .tmux.conf
set -g status-right '#{cpu_bg_color} CPU: #{cpu_icon} #{cpu_percentage} | %a %h-%d %H:%M '
```

### Supported Options

This is done by introducing 12 new format strings that can be added to
`status-right` option:

- `#{cpu_icon}` - will display a CPU status icon
- `#{cpu_percentage}` - will show CPU percentage (averaged across cores)
- `#{cpu_bg_color}` - will change the background color based on the CPU percentage
- `#{cpu_fg_color}` - will change the foreground color based on the CPU percentage
- `#{ram_icon}` - will display a RAM status icon
- `#{ram_percentage}` - will show RAM percentage (averaged across cores)
- `#{ram_bg_color}` - will change the background color based on the RAM percentage
- `#{ram_fg_color}` - will change the foreground color based on the RAM percentage
- `#{cpu_temp_icon}` - will display a CPU temperature status icon
- `#{cpu_temp}` - will show CPU temperature (averaged across cores)
- `#{cpu_temp_bg_color}` - will change the background color based on the CPU temperature
- `#{cpu_temp_fg_color}` - will change the foreground color based on the CPU temperature

GPU equivalents also exist:

- `#{gpu_icon}` - will display a GPU status icon
- `#{gpu_percentage}` - will show GPU percentage (averaged across devices)
- `#{gpu_bg_color}` - will change the background color based on the GPU percentage
- `#{gpu_fg_color}` - will change the foreground color based on the GPU percentage
- `#{gram_icon}` - will display a GPU RAM status icon
- `#{gram_percentage}` - will show GPU RAM percentage (total across devices)
- `#{gram_bg_color}` - will change the background color based on the GPU RAM percentage
- `#{gram_fg_color}` - will change the foreground color based on the GPU RAM percentage
- `#{gpu_temp_icon}` - will display a GPU temperature status icon
- `#{gpu_temp}` - will show GPU temperature (average across devices)
- `#{gpu_temp_bg_color}` - will change the background color based on the GPU temperature
- `#{gpu_temp_fg_color}` - will change the foreground color based on the GPU temperature

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

## Customization

Here are all available options with their default values:

```shell
@cpu_low_icon "=" # icon when cpu is low
@cpu_medium_icon "≡" # icon when cpu is medium
@cpu_high_icon "≣" # icon when cpu is high

@cpu_low_fg_color "" # foreground color when cpu is low
@cpu_medium_fg_color "" # foreground color when cpu is medium
@cpu_high_fg_color "" # foreground color when cpu is high

@cpu_low_bg_color "#[bg=green]" # background color when cpu is low
@cpu_medium_bg_color "#[bg=yellow]" # background color when cpu is medium
@cpu_high_bg_color "#[bg=red]" # background color when cpu is high

@cpu_percentage_format "%3.1f%%" # printf format to use to display percentage

@cpu_medium_thresh "30" # medium percentage threshold
@cpu_high_thresh "80" # high percentage threshold

@ram_(low_icon,high_bg_color,etc...) # same defaults as above

@cpu_temp_format "%2.0f" # printf format to use to display temperature
@cpu_temp_unit "C" # supports C & F

@cpu_temp_medium_thresh "80" # medium temperature threshold
@cpu_temp_high_thresh "90" # high temperature threshold

@cpu_temp_(low_icon,high_bg_color,etc...) # same defaults as above
```

All `@cpu_*` options are valid with `@gpu_*` (except `@cpu_*_thresh` which apply to both CPU and GPU). Additionally, `@ram_*` options become `@gram_*` for GPU equivalents.

Note that these colors depend on your terminal / X11 config.

You can can customize each one of these options in your `.tmux.conf`, for example:

```shell
set -g @cpu_low_fg_color "#[fg=#00ff00]"
set -g @cpu_percentage_format "%5.1f%%" # Add left padding
```

Don't forget to reload the tmux environment (`$ tmux source-file ~/.tmux.conf`) after you do this.

### Tmux Plugins

This plugin is part of the [tmux-plugins](https://github.com/tmux-plugins) organisation. Checkout plugins as [battery](https://github.com/tmux-plugins/tmux-battery), [logging](https://github.com/tmux-plugins/tmux-logging), [online status](https://github.com/tmux-plugins/tmux-online-status), and many more over at the [tmux-plugins](https://github.com/tmux-plugins) organisation page.

### Maintainers

- [Camille Tjhoa](https://github.com/ctjhoa)
- [Casper da Costa-Luis](https://github.com/casperdcl)

### License

[MIT](LICENSE.md)
