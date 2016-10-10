# Tmux cpu status

Enables displaying cpu percentage and status icon in Tmux status-right.

CPU:<br/>
`CPU: ❏ 8.7%`

This is done by introducing 2 new format strings that can be added to
`status-right` option:
- `#{cpu_icon}` - will display a cpu status icon
- `#{cpu_percentage}` - will show cpu percentage

### Usage

Add `#{cpu_icon}` or `#{cpu_percentage}` format strings to existing
`status-right` Tmux option. Example:

    # in .tmux.conf
    set -g status-right "CPU: #{cpu_icon} #{cpu_percentage} | %a %h-%d %H:%M "

### Optional requirement (Linux, BSD, OSX)

`iostat` or `sar` are the best way to get an accurate cpu percentage

A fallback is included using `ps -aux` but could be inaccurate.

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

### Changing icons

By default, these icons are displayed:

 - cpu: "❏"

You can change these defaults by adding the following to `.tmux.conf` (the
following lines are not in the code block so that emojis can be seen):

 - set-option -g @cpu_icon ":sunglasses:"

Don't forget to reload TMUX environment (`$ tmux source-file ~/.tmux.conf`)
after you do this.

### Limitations

- CPU change most likely won't be instant.<br/>
  It will take some time (15 - 60 seconds) for the value to change.
  This depends on the `status-interval` TMUX option.

### Other plugins

You might also find these useful:

- [battery](https://github.com/tmux-plugins/tmux-battery) - Plug and play battery percentage and icon indicator for Tmux.
- [online status](https://github.com/tmux-plugins/tmux-online-status) - online status
  indicator in Tmux `status-right`. Useful when on flaky connection to see if
  you're online.

### License

[MIT](LICENSE)
