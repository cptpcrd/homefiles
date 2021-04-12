syntax on
filetype indent plugin on
autocmd FileType sh set expandtab autoindent ts=4 sw=4
autocmd FileType zsh set expandtab autoindent ts=4 sw=4
autocmd FileType c set expandtab autoindent ts=4 sw=4
autocmd FileType cpp set expandtab autoindent ts=4 sw=4
autocmd FileType cmake set expandtab autoindent ts=4 sw=4
autocmd FileType python set expandtab autoindent ts=4 sw=4
autocmd FileType java set expandtab autoindent ts=4 sw=4
autocmd FileType vim set expandtab autoindent ts=4 sw=4
autocmd FileType css set expandtab autoindent ts=4 sw=4
autocmd FileType scss set expandtab autoindent ts=4 sw=4
autocmd FileType javascript set expandtab autoindent ts=4 sw=4
autocmd FileType html set expandtab autoindent ts=4 sw=4
autocmd FileType htmldjango set expandtab autoindent ts=4 sw=4 indentexpr=
autocmd FileType conf set expandtab autoindent ts=4 sw=4
autocmd FileType json set expandtab autoindent ts=4 sw=4
autocmd FileType gitcommit set expandtab autoindent ts=4 sw=4
autocmd FileType go set autoindent ts=4 sw=4 sts=4
autocmd FileType yaml setlocal expandtab ts=2 sts=2 sw=2

set hlsearch
set incsearch

map <F2> :noh<CR>
imap <F2> <C-o>:noh<CR>


if &diff
    "vimdiff and desert theme don't mix
    colorscheme torte
else
    colorscheme desert
endif

set hidden

"Custom commands

"Allow accidental holding of the shift key
command! -bang -nargs=* -complete=file W w<bang> <args>
command! -bang -nargs=* -complete=file Wq wq<bang> <args>
command! -bang -nargs=* -complete=file Wqa wqa<bang> <args>
command! -bang Q q<bang>
command! -bang Qa qa<bang>

command! -nargs=* -complete=file Badd badd <args>
command! Bn bn
command! Bp bp

"Write as Sudo
command! Ws w !sudo tee % >/dev/null
command! WS w !sudo tee % >/dev/null

"Quit all
command! -bang WQQ :w | :qa<bang>
command! -bang QQ :qa<bang>

"Re-detect filetype
command! Dct :filetype detect
command! Detect :filetype detect

"Change eXecutable/Change Not eXecutable
command! Cx exec SetExecutable()
command! Cnx exec UnsetExecutable()

function! SetExecutable()
    let output = system("chmod +x " . expand("%"))
    if v:shell_error == 0
        echo "Successfully set executable bits for " . expand("%")
    else
        echo "Error: " . trim(output)
    endif
endfunction

function! UnsetExecutable()
    let output = system("chmod -x " . expand("%"))
    if v:shell_error == 0
        echo "Successfully unset executable bits for " . expand("%")
    else
        echo "Error: " . trim(output)
    endif
endfunction

"Unmappings
map q: <nop>
map Q <nop>


"Action mappings
set pastetoggle=<F3>

map <C-a> :w<CR>
map! <C-a> <C-o>:w<CR>

map r R

map <Tab> >>
map <S-Tab> <<
vmap <Tab> >gv
vmap <S-Tab> <gv

nmap [p oX<C-o>j<C-o>[P<Esc>k"_dd<Esc>

nmap <leader>d "_d
vmap <leader>d "_d
vmap <expr> <leader>p (mode() == "v" ? (col("'>") + 1 >= col("$")) : line("'>") == line("$")) ? "\"_dp" : "\"_dP"

map! <C-u> <C-o>u
map! <C-r> <C-o><C-r>

"Moving around

"Shift+Home and Alt-Home
nmap <S-Home> ^
nmap <M-Home> ^
map! <S-Home> <C-o>^
map! <M-Home> <C-o>^

"Ctrl+Home
map <Esc>[1;5H gg
map! <Esc>[1;5H <C-o>gg
"Ctrl+End
nmap <Esc>[1;5F G$
vmap <Esc>[1;5F G$
xmap <Esc>[1;5F G$
cmap <Esc>[1;5F G
map! <Esc>[1;5F <C-o>G<C-o>$

"Ctrl+Right Arrow
map <Esc>[1;5C w
map! <Esc>[1;5C <C-o>w
"Ctrl+Left Arrow
map <Esc>[1;5D b
map! <Esc>[1;5D <C-o>b
"Ctrl+Up Arrow
map <Esc>[1;5A {
map! <Esc>[1;5A <C-o>{
"Ctrl+Down Arrow
map <Esc>[1;5B }
map! <Esc>[1;5B <C-o>}

nmap d<space> df<space>
exec "map! " . nr2char(8) . " <C-w>"

"D-Ctrl+Right Arrow
nmap d<Esc>[1;5C dw
"D-Ctrl+Left Arrow
nmap d<Esc>[1;5D db
"D-Ctrl+Up Arrow
nmap d<Esc>[1;5A d{
"D-Ctrl+Down Arrow
nmap d<Esc>[1;5B d}


"Cycling tabs and windows

"Ctrl+Page Up/Down
nmap <silent> <Esc>[6;5~ :bnext<CR>
nmap <silent> <Esc>[5;5~ :bprev<CR>
map! <silent> <Esc>[6;5~ <C-o>:bnext<CR>
map! <silent> <Esc>[5;5~ <C-o>:bprev<CR>

"Ctrl+Shift+Page Up/Down
map <silent> <Esc>[6;6~ :tabnext<CR>
map <silent> <Esc>[5;6~ :tabprevious<CR>


"Window management

"Ctrl-w + (optional Ctrl) Page Up/Down
map <silent> <C-w><Esc>[6;5~ :wincmd w<CR>
map <silent> <C-w><Esc>[5;5~ :wincmd W<CR>
map <silent> <C-w><Esc>[6~ :wincmd w<CR>
map <silent> <C-w><Esc>[5~ :wincmd W<CR>

"Ctrl-w + Ctrl+<Arrow>
map <silent> <C-w><C-Up> :resize +5<CR>
map <silent> <C-w><C-Down> :resize -5<CR>
map <silent> <C-w><C-Left> :vert resize +5<CR>
map <silent> <C-w><C-Right> :vert resize -5<CR>


"Make
nmap m<Return> :make!<CR>
nmap mm :!make<BAR><BAR>read<CR><CR>


"Miscellaneous
set nofoldenable
set nofixeol
set noeol

set viminfo='100,<1000,s10,h

if filereadable(expand("~/.vimrc_local"))
    source ~/.vimrc_local
endif
