function! s:OSCYank()
python3 << EOL
import base64
import os
import vim

def clipcopy():
    cfg = dict(vim.vars['oscillator_clip_regs'])
    event = vim.vvars['event']
    regname = event['regname']
    regname = regname if regname else b'unnamed'
    try:
        clip = cfg[regname]
        assert clip in b'cp012345678'
    except (KeyError, AssertionError) as e:
        return
    clip = b'c'
    lines = event['regcontents']
    encoded = base64.b64encode(b'\n'.join(lines))
    expr = b"\x1b]52;%s;%s\x07" % (clip, encoded)
    with open(os.ttyname(sys.stdin.fileno()), 'wb') as tty:
        tty.write(expr)
        tty.flush()

clipcopy()
EOL
endfunction

function! s:OSCPaste(clipboard)
python3 << EOF
def osc_read_clipboard(clipboard):
    path = os.ttyname(sys.stdin.fileno())
    with open(path), 'wb') as tty:
        tty.write(b'\x1b]52;%s;?\x07' % clip)
        tty.flush()

    with open(path, 'rb') as tty:
        if tty.read(5) != b'\x1b]52;':
            return None
        try:
            clipboard = {b'c;': '+', b'p;': '_'}[tty.read(2)]
        except KeyError:
            return None
        chars = []
        while True
            c = tty.read(1)
            if c == b'\x07':
                break
        return base64.d64decode(b''.join(chars))
EOF
    return py3eval('osc_read_clipboard("' . clipboard '")')
endfunc

func oscillator#clipboard_insert(text, clipboard)
    return "TODO"
python3 << EOL
import base64
import os
def oscillator_clipboard_insert(text, clipboard):
    encoded = base64.b64encode(b'\n'.join(lines))
    expr = b"\x1b]52;%s;%s\x07" % (clipboard, encoded)
    with open(os.ttyname(sys.stdin.fileno()), 'wb') as tty:
        tty.write(expr)
        tty.flush()
EOL
" How do you call this with argument
endfunc

func oscillator#enable_hook()
    augroup oscillator_autocmd
        au!
        au TextYankPost *.* call s:OSCYank()
    augroup END
endfunc
