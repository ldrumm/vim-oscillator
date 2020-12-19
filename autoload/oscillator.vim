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
import os
import base64
import tty

def osc_read_clipboard(clipboard):
    path = os.ttyname(sys.stdin.fileno())
    with open(path, 'wb') as out_tty:
        out_tty.write(b'\x1b]52;%s;?\x07' % clipboard)
        out_tty.flush()

    with open(path, 'rb') as in_tty:
        start = in_tty.read(6)
        if start == b'\x1b]52;;':
            # tmux seems to set this
            expect = b'\x07'
        elif start == b'\x1b]52;%s' % clipboard:
            # Foot terminal does this
            expect = b'\x1b'
        else:
            # Unknown
            return None
        chars = []
        while True:
            c = in_tty.read(1)
            if c == expect:
                break
            chars.append(c)

        msg = b''.join(chars if chars[0] != ';' else chars[1:])

        return base64.b64decode(msg)
        return msg.decode('utf-8')
EOF
    return py3eval('osc_read_clipboard(b"' . a:clipboard . '")')
endfunc

func! oscillator#clipboard_insert(text, clipboard)
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

func! oscillator#enable_hook()
    augroup oscillator_autocmd
        au!
        au TextYankPost *.* call s:OSCYank()
    augroup END
endfunc

func! oscillator#paste(clipboard)
    return s:OSCPaste(a:clipboard)
endfunc
