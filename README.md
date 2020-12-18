# Oscillator ; do a clipboard via OSC-52 control sequences

## configuration
    `g:oscillator_auto_enable`: when set, hooks vim's autocommand which is
    called everytime a `yank` operation happens.

    `g:oscillator_clip_regs`: a dictionary mapping vim yank registers to the
    OSC52 clipboard code. Valid values are the set [cp0-9]

    `g:oscillator_osc52_fmt_string`: The python `%` format string. Must have 2
    `%s` format specifiers. Don't set this unless your terminal is weird. The
    default should work.
