if exists('g:oscillator_loaded')
    finish
endif
if ! has('python3')
    echoe "+python3 support needed for osc plugin"
    finish
endif

let g:oscillator_loaded = v:true

let g:oscillator_clip_regs =
            \get(g:, 'oscillator_clip_regs', {'+': 'c', '*': 'p', '"': 'c', 'unnamed': 'c'})

let g:oscillator_osc52_fmt_string = "\x1b]52;%s;%s\x07"
let g:oscillator_auto_enable = get(g:, 'oscillator_auto_enable', v:false)

if g:oscillator_auto_enable
    :call oscillator#enable_hook()
endif
command! OSCillatorInit :call oscillator#enable_hook()

