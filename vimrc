" vim files and directories {{{
let g:myvimdir = fnamemodify(split(&runtimepath, ",")[0], ":p")

call mkdir(g:myvimdir, 'p')

call mkdir(g:myvimdir . 'undo', 'p', 0700)
let &undodir = g:myvimdir . 'undo'
set undofile

call mkdir(g:myvimdir . 'backup', 'p', 0700)
let &backupdir = g:myvimdir . 'backup//'
set backup

if has('viminfo')
    execute 'set viminfo+=n' . g:myvimdir . 'viminfo'
endif

if has('nvim')
    if has('win32') && executable(expand('~/venvs/nvim/Scripts/python.exe', 1))
        let g:python3_host_prog = expand('~/venvs/nvim/Scripts/python.exe')
    elseif has('unix') && executable(expand('~/venvs/nvim/bin/python'))
        let g:python3_host_prog = expand('~/venvs/nvim/bin/python')
    endif

    if has('linux') && $WSL_DISTRO_NAME != "" && !executable('win32yank.exe')
        if executable('wslpath') && executable('wslvar')
            let userprofile = trim(system('wslpath $(wslvar USERPROFILE)'))
            let nvim_dir = userprofile . '/scoop/apps/neovim/current/bin'
            let win32yank = nvim_dir . '/win32yank.exe'
            if executable(win32yank)
                let $PATH .= ':' . nvim_dir
            endif
        endif
    endif

    command! -nargs=0 ServerName call ClipboardSend(v:servername) | echo v:servername
endif

" if has('nvim') && has('win32')
"     let &shell = has('win32') ? 'powershell' : 'pwsh'
"     let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
"     let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
"     let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
"     set shellquote= shellxquote=
" endif

"}}}

" {{{ options
language C
set langmenu=en_US.UTF-8
set encoding=utf-8 fileformats=unix,dos
setglobal fileencoding=utf-8

set noswapfile autoread

set timeout ttimeout timeoutlen=1500 ttimeoutlen=10 updatetime=300

set hidden visualbell
set backspace=indent,eol,start virtualedit=block,insert
set mouse=a mousemodel=extend

set wildmode=list:longest

set wildignore=
set wildignore+=NTUSER.DAT*,*.exe
set wildignore+=*~,#*#
set wildignore+=*.o,*.a,*.so
set wildignore+=*/.git/*
set wildignore+=*.pyc,*/__pycache__/*\,*/*.egg-info/*
set wildignore+=*.class
set wildignore+=*.png,*.jpg,*.jpeg,*.gif

set complete=.,w,b,u,t,i,d,kspell
set completeopt=menuone,longest,preview,noselect

let g:polyglot_disabled = ['autoindent', 'sensible', 'djangohtml', 'jinja2']
filetype plugin indent on
syntax on
set omnifunc=syntaxcomplete#Complete
set expandtab shiftwidth=4 softtabstop=4 tabstop=8
set textwidth=0 formatoptions-=o
set splitbelow splitright
set formatoptions-=o
set ignorecase smartcase

set laststatus=2
set cmdheight=2
set shortmess+=ac
set number nofoldenable
try | set signcolumn=number "has("patch-8.1.1564")
catch | set signcolumn=yes
endtry

execute 'set breakat=\ '
set showbreak=\|>
set breakindentopt=shift:4,sbr
set breakindent
set linebreak
set wrap
" let g:kite_auto_complete=0
" }}}

" {{{ mappings
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

command! -nargs=+ -bang MapCmd call s:mapcmd('<bang>', <f-args>)
function! s:mapcmd(bang, modes, key, ...)
    let mapcmd = a:bang ==# '!' ? 'map' : 'noremap'
    let cmd = join(a:000, ' ')
    for mode in ['n', 'o', 'x', 's', 'c', 'i', 't']
        if stridx(a:modes, mode) !=# -1
            execute mode . mapcmd . ' ' . a:key . ' <cmd>' . cmd . '<cr>'
        endif
    endfor
endfunction

function! Experimental()
    nnoremap h i
    nnoremap j h
    nnoremap k j
    nnoremap i k
endfunction
nnoremap æ :<c-u>echom "Du har norsk tastaturoppsett!"<cr>
nnoremap Æ :<c-u>echom "Du har norsk tastaturoppsett!"<cr>
nnoremap ø :<c-u>echom "Du har norsk tastaturoppsett!"<cr>
nnoremap Ø :<c-u>echom "Du har norsk tastaturoppsett!"<cr>
nnoremap å :<c-u>echom "Du har norsk tastaturoppsett!"<cr>
nnoremap Å :<c-u>echom "Du har norsk tastaturoppsett!"<cr>
nnoremap U :<c-u>echom "Slå av CAPS LOCK!"<cr>

nnoremap ; :
vnoremap ; :
nnoremap : :<c-f>a
vnoremap : :<c-f>a

nnoremap s <c-w>

" insert new line and indent next line
" (the opposite of <c-g><cr> is usually va}J)
inoremap <c-g><cr> <c-g>u<cr><c-o>O<c-f>
" convert current word to dunder
inoremap <c-g>_ <c-g>u<c-o>b__<c-o>e<c-o>a__

vnoremap > >gv
vnoremap < <gv

nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k
nnoremap ^ g^
nnoremap g^ ^
nnoremap 0 g0
nnoremap g0 0
nnoremap $ g$
nnoremap g$ $

nnoremap <f1> <nop>
nnoremap <c-j> <nop>
nnoremap <c-k> <nop>

nnoremap f<cr> ;
nnoremap F<cr> ,
nnoremap t<cr> ;
nnoremap T<cr> ,

nnoremap q <nop>
nnoremap qq q

inoremap jk <esc>
cnoremap jk <c-c><esc>
tnoremap jk <c-\><c-n>

inoremap <expr> <c-n> pumvisible() ? '<down>' : '<c-n>'
inoremap <expr> <c-p> pumvisible() ? '<up>' : '<c-p>'
inoremap <expr> <c-j> pumvisible() ? '<down>' : ''
inoremap <expr> <c-k> pumvisible() ? '<up>' : ''
inoremap <expr> <tab> pumvisible() ? '<c-y>' : '<tab>'
" inoremap <expr> <cr> pumvisible() ? '<c-y>' : '<c-g>u<cr>'
inoremap <cr> <c-g>u<cr>

inoremap <c-^> <esc><c-^>

nnoremap gb :buffers<cr>:b<space>

nnoremap <silent> <c-l> <c-l>:call <sid>ctrl_l()\|nohlsearch<cr>
inoremap <expr> <c-l> <sid>ctrl_l()
function s:ctrl_l()
    silent! call coc#float#close_all()
    silent! call coc#_hide()
    " silent! call coc#float#check_related()
    if !has('nvim')
        call popup_clear()
    endif
    WindowIdentify
    return ""
endfunction

nnoremap g<c-a> :call <sid>showpos()<cr>
function s:showpos()
    let [bufnum, lnum, colnum, offset, curswant] = getcurpos()
    echo "Line: " . lnum . ", Column: " . colnum
endfunction

cabbrev <expr> %% expand('%:p:h')

function! s:ResDot(count)
    execute "normal!" a:count . "."
    if line("'[") <= line("$")
        normal! g`[
    endif
endfunction
nnoremap <silent> . :<C-U>call <sid>ResDot(v:count1)<CR>

nnoremap Y y$

nnoremap <space>~v :tabnew $MYVIMRC<cr>
nnoremap <space>~t :edit ~/.tmux.conf<cr>
nnoremap <space>~p :edit ~/Documents/WindowsPowerShell/profile.ps1<cr>
nnoremap <space>~b :edit ~/.bashrc<cr>

command! -nargs=1 Mkdirp call mkdir(trim(<f-args>), 'p')

function! Echoq(...)
    let args = join(a:000, ' ')
    echo args
endfunction
command! -nargs=* Echoq call Echoq(<q-args>)

command! Rtp Redir echo &rtp|s/,/\r/g

command! -nargs=0 SpellNorsk setlocal spelllang=nb_no spell
command! -nargs=0 SpellEnglish setlocal spelllang=en spell
command! -nargs=0 SpellOff setlocal nospell

function! SecureMode()
    if has('viminfo') | set viminfo= | endif
    if has('shada') | set shada= | endif
    if has('persistent_undo') | set noundofile | endif
    set nobackup noswapfile noshelltemp history=0
    set secure
    silent! LocalVimRCDisable
endfunction
command! -nargs=0 SecureMode call SecureMode()

command! -nargs=* KeepWin call KeepWin(<f-args>)
function! KeepWin(...)
    let cmd = join(a:000, ' ')
    let curwin = win_getid()
    execute cmd
    call win_gotoid(curwin)
endfunction

augroup vimrc-auto-mkdir
    autocmd!
    autocmd BufWritePre * call s:auto_mkdir_for_file(expand('<afile>:p'), v:cmdbang)
augroup END
function! s:auto_mkdir_for_file(file, force)
    let dir = fnamemodify(a:file, ':h')
    if !isdirectory(dir)
        \   && (a:force
        \       || input("'" . dir . "' does not exist. Create? [y/N]") =~? '^y\%[es]$')
        call mkdir(iconv(dir, &encoding, &termencoding), 'p')
    endif
endfunction

if has('win32') && !has('nvim')
    function! s:win32_fix_gf(ctrlw)
        let filename = expand('<cfile>')
        let ctrlw = a:ctrlw ? "\<c-w>" : ''
        let tn = a:ctrlw ? 'tabnew ' : ''
        let filename = substitute(filename, '\\\\', '\\', 'g')
        if filename =~# '^[./\\]' || filename =~? '[a-z]:\\'
            execute tn . 'edit ' . fnameescape(filename)
        else
            let path = split(&path, '[^\\]\zs[, ]')
            for p in path
                let p = substitute(p, '\\\([, \\]\)', '\\1', 'g')
                let p = substitute(p, '[\\/:]$,', '', 'g')
                if p == ''
                    let p = '.'
                elseif p == '.'
                    let p = expand('%:h')
                endif
                let f = p . '\' . filename
                if filereadable(f)
                    execute tn . 'edit ' . fnameescape(f)
                    break
                endif
            endfor
        endif
    endfunction
    nnoremap <silent> gf :call <sid>win32_fix_gf(0)<cr>
    nnoremap <silent> <c-w>gf :call <sid>win32_fix_gf(1)<cr>
endif

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ft=%s ts=%d sw=%d tw=%d %set :",
        \ &filetype, &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>


" }}}

" {{{ Install plugins, etc
command! -nargs=0 Install call Install()

function! Install()
    silent! execute BufName2Nr('vimrc installation progress') . 'bdelete'
    silent! execute BufName2Nr('[minpac progress]') . 'bdelete'
    let progressBuf = bufnr('vimrc installation progress', 1)
    execute 'topleft silent split | ' . progressBuf . 'buffer'
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted ft= nomodifiable
    call s:append(line('$')-1, '## vimrc installation progress ##')
    call BufExe('call DownloadGit(''' . g:myvimdir . 'pack/minpac/opt/minpac''' .
        \ ', ''https://github.com/k-takata/minpac.git'')')
    BufExe packadd minpac
    BufExe call minpac#init({'confirm': v:false})
    call s:append('$', '')
    for cmd in g:installCmds
        call BufExe(cmd)
        call s:append('$', '')
        redraw
    endfor
    BufExe call minpac#clean()
    call s:append(line('$')-1, ':call minpac#update()')
    call minpac#update()
    let winList =  win_findbuf(BufName2Nr('[minpac progress]'))
    if len(winList) > 0
        call win_gotoid(winList[0])
        call s:append(0, getbufline(progressBuf, 1, '$'))
        execute progressBuf . 'bwipe'
    endif
endfunction

function! s:append(lnum, text)
    let lnum = (a:lnum ==# '$' && getline('$') ==# '') ? line('$') - 1 : a:lnum
    let mod = substitute(execute('setlocal modifiable?'), '\A', '', 'g')
    setlocal modifiable
    call append(lnum, a:text)
    execute 'setlocal ' . mod
endfunction

function! BufExe(...)
    let cmd = join(a:000, ' ')
    if cmd[0] ==# '!'
        call s:append('$', cmd)
        silent! let s = systemlist(strpart(cmd, 1))
    else
        call s:append('$', ':' . cmd)
        silent! let s = split(execute(cmd), '\n')
    endif
    call s:append('$', s)
endfunction
command! -nargs=* BufExe call BufExe(<f-args>)

function! BufName2Nr(name)
    let matches = filter(range(1, bufnr('$')), 'bufname(v:val) ==# a:name')
    return len(matches) > 0 ? matches[0] : 0
endfunction

command! -nargs=* AtInstallTime call <sid>atInstallTime(<f-args>)

function! s:atInstallTime(...)
    let command = join(a:000, ' ')
    call add(g:installCmds, command)
endfunction

command! -nargs=* PkgInstall call <sid>pkginstall(<f-args>)

function! s:pkginstall(pkg, ...)
    execute 'AtInstallTime call minpac#add(''' . a:pkg .
        \ (a:0 ? ''', ' . join(a:000, ' ') . ')' : ''')')
endfunction

let g:installCmds = []

function! PkgInstalled(pkg)
    let dirname = substitute(a:pkg, '^.*/', '', '')
    " return &rtp =~# ('[\\/]' . dirname . ',') ||
    return isdirectory(g:myvimdir . 'pack/minpac/start/' . dirname) ||
        \ isdirectory(g:myvimdir . 'pack/minpac/opt/' . dirname)
endfunction

function! DownloadFile(fname, url) abort
    if !executable('curl')
        throw 'Please install `curl`'
    endif
    let result = ''
    " let fname = a:base . '/' . a:name
    if empty(glob(a:fname))
        let dir = fnamemodify(a:fname, ':h')
        call mkdir(dir, 'p')
        call BufExe('!curl -fLo ' . shellescape(a:fname) . ' ' . shellescape(a:url))
    else
        silent echo a:fname . ' is already downloaded.'
    endif
endfunction

function! DownloadGit(dir, url) abort
    if !executable('git')
        throw 'Please install `git`'
    endif
    call mkdir(a:dir, 'p')
    if empty(glob(a:dir . '/.git/HEAD'))
        call BufExe('!git clone ' . shellescape(a:url) . ' ' . shellescape(a:dir))
    else
        call BufExe('!git -C ' . shellescape(a:dir) . ' pull')
    endif
    return !empty(glob(a:dir . '/.git/HEAD'))
endfunction

" FIXME: detect and warn if gzip is not installed
function! InstallVimball(name, url) abort
    packadd vimball
    let archive = 'vimballarchive/' . a:name . (a:url =~ '\.gz$' ? '.gz' : '')
    let dir = g:myvimdir . 'pack/vimball/opt/' . a:name
    silent echo ':DownloadFile(' . g:myvimdir . archive . ', ' .  a:url ')'
    call DownloadFile(g:myvimdir . archive, a:url)
    call mkdir(dir, 'p')
    let oldWin = win_getid()
    execute 'split ' . g:myvimdir . archive
    silent echo ':UseVimball ' . dir
    silent echo 'bufnr() => ' . bufnr()
    silent execute 'UseVimball ' . dir
    wincmd c
    call win_gotoid(oldWin)
endfunction

function! MkSpell()
    for d in glob('~/.vim/spell/*.add', 1, 1)
        if filereadable(d) && (!filereadable(d . '.spl') || getftime(d) > getftime(d . '.spl'))
            exec 'mkspell! ' . fnameescape(d)
        endif
    endfor
endfunction

AtInstallTime call MkSpell()

AtInstallTime call DownloadFile(g:myvimdir . 'plugin/Redir.vim',
    \ 'https://gist.githubusercontent.com/romainl/eae0a260ab9c135390c30cd370c20cd7/raw/407b5abf42a64cef1749f8b73bbe4572868eaa65/redir.vim')

AtInstallTime call InstallVimball('astronaut', 'http://www.drchip.org/astronaut/vim/vbafiles/astronaut.vba.gz')
" }}}

" {{{ Other utility and helper function
command! -nargs=* AfterVimEnter :call <sid>afterVimEnter(<q-args>)

function! s:afterVimEnter(cmd)
    if v:vim_did_enter
        execute a:cmd
    else
        execute 'autocmd VimEnter * ' . a:cmd
    endif
endfunction

if has('win32')
    let s:pathsep = '\'
else
    let s:pathsep = '/'
endif
function! DetectRoot(path, ...)
    let prevpath=expand(a:path, ':p')
    while 1
        let path = fnamemodify(prevpath, ':h')
        if path == prevpath
            return ""
        endif
        let prevpath = path
        for file in a:000
            let test = path . s:pathsep . file
            if filereadable(test) || isdirectory(test)
                return path
            endif
        endfor
    endwhile
endfunction
" }}}

" {{{ osc52

" let s:b64 = [
"     \ 'A','B','C','D','E','F','G','H','I','J','K','L','M',
"     \ 'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
"     \ 'a','b','c','d','e','f','g','h','i','j','k','l','m',
"     \ 'n','o','p','q','r','s','t','u','v','w','x','y','z',
"     \ '0','1','2','3','4','5','6','7','8','9','+', '*' ]

" function! Base64Enc(text)
"     let i = 0
"     let n = len(a:text)
"     let result = ''
"     while i < n
"         let i1 = char2nr(a:text[i])
"         let i2 = (i+1 < n ? char2nr(a:text[i+1]) : 0)
"         let i3 = (i+2 < n ? char2nr(a:text[i+2]) : 0)
"         let o1 = i1 / 4
"         let o2 = or(and(i1, 3) * 16, i2 / 16)
"         let o3 = or(and(i2, 15) * 4, i3 / 64)
"         let o4 = and(i3, 63)
"         let result = result . s:b64[o1] . s:b64[o2] .
"             \ (i+1 < n ? s:b64[o3] : '=') .
"             \ (i+2 < n ? s:b64[o4] : '=')
"         let i += 3
"     endwhile
"     return result
" endfunction

" function! Osc52Send(text)
"     silent execute '!echo ' .
"         \ shellescape("\e]52;c;" . Base64Enc(a:text) . "\x07")
"     redraw!
" endfunction
set pastetoggle=<f2>

if !has('nvim')
    PkgInstall ConradIrwin/vim-bracketed-paste
endif

PkgInstall ojroques/vim-oscyank

function! ClipboardSend(text)
    if $WSL_DISTRO_NAME != ""
        call system('clip.exe', a:text)
        "opposite: powershell.exe -command "Get-Clipboard"x
    elseif $DISPLAY != "" && executable('xclip')
        call system('xclip -selection clipboard -in', a:text)
    elseif $DISPLAY != "" && executable('xsel')
        call system('xsel --clipboard --input', a:text)
    elseif has('win32') && executable('clip.exe')
        call system('clip.exe', a:text)
    elseif has('win32') && executable('win32yank.exe')
        call system('win32yank.exe -i', a:text)
    elseif $WAYLAND_DISPLAY != "" && executable('wl-copy')
        call system('wl-copy', a:text)
    elseif $SSH_CONNECTION != ""
        call OSCYankString(a:text)
    else
        echoerr "Unknown system: don't know how to use clipboard"
    endif
endfunction

function! ClipboardSend_Op(type, op)
    let oldA = getreginfo('a')
    if a:type ==# 'char'
        normal! `[v`]"ay
    elseif a:type ==# 'line'
        normal! `[V`]"ay
    elseif a:type ==# 'block'
        execute "normal! `[\<c-v>`]\"ay"
    elseif a:type ==# 'V'
        normal gv"aY
    elseif a:type ==# 'v' || a:type ==# "\<c-v>"
        execute 'normal! g' . a:type . '"ay'
    else
        return
    endif
    call ClipboardSend(@a)
    call setreg('a', oldA)
endfunction

function! ClipboardDelete(type) range
    call ClipboardSend_Op(a:type, 'd')
endfunction

function! ClipboardYank(type) range
    call ClipboardSend_Op(a:type, 'y')
endfunction

nnoremap <space>y :set operatorfunc=ClipboardYank<cr>g@
nnoremap <space>yy m[m]:call ClipboardYank('line')<cr>
nnoremap <space>Y :set operatorfunc=ClipboardYank<cr>g@$
xnoremap <space>y :call ClipboardYank(visualmode())<cr>
xnoremap <space>Y :call ClipboardYank('V')<cr>
nnoremap <space>p "+p
nnoremap <space>P "+P

if has('nvim') && exists('g:GuiLoaded')
    inoremap <c-s-v> <c-o>"+p
endif
" }}}

" {{{ netrw
let g:netrw_banner = 0
if has('win32')
    let g:netrw_scp_cmd = 'scp'
endif
let g:netrw_sort_sequence = '[\/]$,*'
" }}}

" {{{ MatchTagAlways
if has("python3")
    PkgInstall Valloric/MatchTagAlways { 'type' : 'opt' }

    if PkgInstalled('MatchTagAlways')
        packadd MatchTagAlways
        nnoremap <silent> <space>% :MtaJumpToOtherTag<cr>
    endif
endif
" }}}

" {{{ matchit
if !exists("g:loaded_matchit")
    runtime macros/matchit.vim
endif
" }}}

" {{{ floaterm
if has('nvim') || (exists(':terminal') && exists('*popup_create'))
    PkgInstall voldikss/vim-floaterm
    let g:floaterm_wintype='split'
    nnoremap <silent> <f7> :FloatermNew<cr>
    nnoremap <silent> <F8> :FloatermPrev<CR>
    tnoremap <silent> <F8> <C-\><C-n>:FloatermPrev<CR>
    nnoremap <silent> <F9> :FloatermNext<CR>
    tnoremap <silent> <F9> <C-\><C-n>:FloatermNext<CR>
    nnoremap <silent> <F12> :FloatermToggle<CR>
    tnoremap <silent> <F12> <C-\><C-n>:FloatermToggle<CR>
    nnoremap <space>s :FloatermSend<cr>
    xnoremap <space>s :FloatermSend<cr>

    " FIXME: when using unix text files (LF) FloatermSend won't work on windows (CRLF)
    " command! -nargs=? -range   -bang -complete=customlist,floaterm#cmdline#complete_names2
    "     \ FloatermSend2 call floaterm#send(<bang>0, visualmode(), <range>, <line1>, <line2>, <q-args>)
    " function s:floatermsend2(bang, visualmode, range, line1, line2, argstr) abort

endif
" }}}

" {{{ Whitespace at end of line

" (Always) highlight whitespace at end of line
highlight EOLWhiteSpace ctermbg=red guibg=red
let w:eolwhitespacematch = matchadd('EOLWhiteSpace', '\s\+\%#\@<!$')
let g:eolwhitespacematch_omit_ft = ['dbout']

function! s:eolwhitespacematch_update_win(activate)
    if &buftype ==# ''
        if index(g:eolwhitespacematch_omit_ft, &filetype) ==# -1
            if exists('w:eolwhitespacematch') && !a:activate
                call matchdelete(w:eolwhitespacematch)
                unlet w:eolwhitespacematch
            elseif !exists('w:eolwhitespacematch') && a:activate
                let w:eolwhitespacematch = matchadd('EOLWhitespace', '\s\+$', 10)
            endif
        endif
    endif
endfunction

augroup EOLWhitespace
    autocmd!
    autocmd Colorscheme *
        \ highlight EOLWhiteSpace ctermbg=red guibg=red
    autocmd WinNew *
        \ call s:eolwhitespacematch_update_win(1)
    autocmd FileType *
        \ call s:eolwhitespacematch_update_win(1)
    autocmd InsertEnter *
        \ call s:eolwhitespacematch_update_win(0)
    autocmd InsertLeave *
        \ call s:eolwhitespacematch_update_win(1)
augroup END

" command Trim: trim whitespace at end of line
command! -nargs=0 -range=% -bar Trim call s:trim(<line1>, <line2>)
command! -nargs=0 -range=% -bar Trimoff silent! unlet b:autotrim
command! -nargs=0 -range=% -bar Trimon let b:autotrim=1
command! -nargs=0 -range=% -bar Trimtoggle call <sid>autotrim_toggle()
command! -nargs=0 -range=% -bar Trimstatus echo "Autotrim is " . (exists("b:autotrim") && b:autotrim ? "on" :"off")

function! s:trim(firstLine, lastLine)
    if &buftype ==# ''
        let oldview = winsaveview()
        execute a:firstLine . ',' . a:lastLine . ' s/\s\+$//e'
        call winrestview(oldview)
    endif
endfunction

function! s:autotrim_toggle()
    if exists('b:autotrim') && b:autotrim
        unlet b:autotrim
    else
        let b:autotrim = 1
    endif
endfunction

" For all files except files except those already containing whitespace at end of lines,
" or markdown files, automatically remove whitespace at end of lines when saving.
function! s:autotrim_enable_if_safe()
    if exists('b:autotrim')
        return
    endif
    if &buftype == '' && execute('%s/\s\+$//ne') ==# '' && &filetype != 'markdown'
        let b:autotrim = 1
    endif
endfunction

augroup AutoTrim
    autocmd!
    autocmd BufWinEnter * call <sid>autotrim_enable_if_safe()
    autocmd BufWritePre * if get(b:, 'autotrim', 0) | %Trim | endif
augroup END
" }}}

" {{{ window manipulation
nnoremap qs :<c-u>call Grid(v:count, 'vertical')<cr>
nnoremap qv :<c-u>call Grid(v:count, 'horizontal')<cr>
nnoremap qa :<c-u>call Grid(2, 'vertical')<cr>

nnoremap qf :<c-u>call Focus(v:count, 'left')<cr>
nnoremap qF :<c-u>call Focus(v:count, 'right')<cr>

nnoremap qz :<c-u>Zoom<cr>

nnoremap qh :<c-u>call SwapWin('h')<cr>
nnoremap qj :<c-u>call SwapWin('j')<cr>
nnoremap qk :<c-u>call SwapWin('k')<cr>
nnoremap ql :<c-u>call SwapWin('l')<cr>

command! -count=1 -bar Focus call Focus(<count>, 'left')
command! -count=1 -bar FocusR call Focus(<count>, 'right')
command! -nargs=0 -bar Zoom call Zoom()

function! Focus(ncolumns, where)
    if winnr('$') ==# 1
        return
    elseif a:where ==# 'left'
        let splitcmd = 'topleft vsplit'
    elseif a:where ==# 'right'
        let splitcmd = 'botright vsplit'
    else
        return
    endif
    let buffer = bufnr()
    let saveview = winsaveview()
    hide
    call Grid(a:ncolumns, 'vertical')
    execute splitcmd
    execute buffer . 'buffer'
    call winrestview(saveview)
endfunction

function! Zoom() abort
    if winnr('$') > 1
        let lst = win_findbuf(bufnr())
        call filter(lst, "tabpagewinnr(win_id2tabwin(v:val)[0], '$') == 1")
        if len(lst) >=# 1
            call win_gotoid(lst[0])
        else
            tab split
        endif
    else
        let lst = win_findbuf(bufnr())
        call filter(lst, "v:val !=# " . win_getid())
        if len(lst) >=# 1
            wincmd c
            call win_gotoid(lst[0])
        endif
    endif
endfunction

function! SwapWin(to) abort
    if strlen(a:to) !=# 1 || stridx('hjkl', a:to) ==# -1
        return
    endif
    let a_winid = win_getid()
    let a_buffer = bufnr()
    let a_saveview = winsaveview()
    execute 'wincmd ' a:to
    let b_winid = win_getid()
    if a_winid ==# b_winid
        execute 'wincmd ' . toupper(a:to)
        return
    endif
    let b_buffer = bufnr()
    let b_saveview = winsaveview()
    execute 'hide' . a_buffer . 'buffer'
    call winrestview(a_saveview)
    call win_gotoid(a_winid)
    execute 'hide' . b_buffer . 'buffer'
    call winrestview(b_saveview)
    call win_gotoid(b_winid)
endfunction

function! Grid(n_outer, inner_direction)
    if a:inner_direction ==# 'vertical'
        let outer_split = 'botright vsplit'
        let inner_split = 'belowright split'
    elseif a:inner_direction ==# 'horizontal'
        let outer_split = 'botright split'
        let inner_split = 'belowright vsplit'
    else
        return
    endif
    if !has('nvim')
        call PopupClear()
    endif
    let n = winnr('$')
    let winlist = []
    let buf = bufnr()
    for i in range(1, n)
        execute i . 'wincmd w'
        if &bufhidden ==# 'hide' || &bufhidden == ''
            call add(winlist, [bufnr(), winsaveview()])
        else
            let n -= 1
        endif
    endfor
    silent! wincmd o
    let n_outer = min([n, a:n_outer < 1 ? 1 : a:n_outer])
    let n_inner = n / n_outer
    let outer_counter = 0
    let inner_counter = 0
    for i in range(n)
        if i ==# 0
        elseif inner_counter ==# n_inner
            let outer_counter += 1
            let inner_counter = 0
            let n_inner = (n-i) / (n_outer - outer_counter)
            execute outer_split
        else
            execute inner_split
        endif
        execute winlist[i][0] . 'buffer'
        call winrestview(winlist[i][1])
        let inner_counter += 1
    endfor
    1wincmd w
    silent! call win_gotoid(win_findbuf(buf)[0])
endfunction

function! WindowIdentify(...)
    let cursorcolumn = &cursorcolumn
    let cursorline = &cursorline
    let colorcolumn = &colorcolumn
    let cmd = join(a:000, ' ')
    set cursorcolumn cursorline
    " let &colorcolumn=join(range(1,200), ',')
    redraw
    execute cmd
    sleep 300m
    let &cursorcolumn=cursorcolumn
    let &cursorline=cursorline
    let &colorcolumn=colorcolumn
endfunction
command! -nargs=* WindowIdentify call WindowIdentify(<f-args>)

nnoremap qr :<c-u>call Resize()<cr>
let g:resize_step = 5
function! Resize()
    while 1
        echo "resize mode [<esc> q hjkl HJKL] "
        let n=getchar()
        let c=nr2char(n)
        redraw
        if c ==# "\<esc>" || c ==# "q"
            break
        elseif c ==# 'h'
            execute "normal! \<c-w><"
        elseif c ==# 'j'
            execute "normal! \<c-w>-"
        elseif c ==# 'k'
            execute "normal! \<c-w>+"
        elseif c ==# 'l'
            execute "normal! \<c-w>>"
        elseif c ==# 'H'
            execute "normal! " . g:resize_step . "\<c-w><"
        elseif c ==# 'J'
            execute "normal! " . g:resize_step . "\<c-w>-"
        elseif c ==# 'K'
            execute "normal! " . g:resize_step . "\<c-w>+"
        elseif c ==# 'L'
            execute "normal! " . g:resize_step . "\<c-w>>"
        endif
    endwhile
    echo ""
endfunction
" }}}

" {{{ UltiSnips
PkgInstall idbrii/vim-endoscope
imap <c-g><space> <plug>(endoscope-close-pair)

if has('python3')
    PkgInstall SirVer/UltiSnips
    if PkgInstalled('UltiSnips')
        let g:UltiSnipsExpandTrigger="<c-s>"
        let g:UltiSnipsJumpForwardTrigger="<c-j>"
        let g:UltiSnipsJumpBackwardTrigger="<c-k>"
        " let g:UltiSnipsSnippetDirectories=['~/us', 'UltiSnips']
        " let g:UltiSnipsSnippetDirectories=['~/us']
        let g:UltiSnipsSnippetDirectories=['~/Onedrive/dotfiles/UltiSnips']

        " If you want :UltiSnipsEdit to split your window.
        " let g:UltiSnipsEditSplit="vertical"
        nnoremap <c-s> :<c-u>split <bar> UltiSnipsEdit<cr>
        augroup vimrc_ultisnips
            autocmd!
            autocmd BufWritePost * :call UltiSnips#RefreshSnippets()
        augroup END
        function CommentStart(...)
            let commentmarkers = split(&commentstring, '%s')
            return commentmarkers[0] . (a:0 > 0 ? ' ' : '')
        endfunction

        function CommentEnd(...)
            let commentmarkers = split(&commentstring, '%s')
            return (a:0 > 0 ? ' ' : '') . (len(commentmarkers)==1 ? '' : commentmarkers[1])
        endfunction
    endif
endif
" }}}

" {{{ coc
if executable('node') && (!has("win32") || has("nvim") || has("gui_running"))
    PkgInstall neoclide/coc.nvim {'branch': 'release', 'type': 'opt'}

    if PkgInstalled('coc.nvim')
        packadd coc.nvim
        AtInstallTime CocUpdate

        let g:coc_filetype_map = {
            \ 'htmldjango' : 'html'
            \ }

        let g:coc_global_extensions = [
            \ 'coc-explorer',
            \ 'coc-tsserver',
            \ 'coc-json',
            \ 'coc-html',
            \ 'coc-css',
            \ 'coc-emmet',
            \ 'coc-pyright',
            \ 'coc-r-lsp',
            \ 'coc-omnisharp',
            \ 'coc-vimlsp',
            \ 'coc-snippets',
            \ 'coc-rls',
            \ 'coc-powershell',
            \ 'coc-db',
            \ 'coc-julia',
            \ 'coc-bootstrap-classname'
            \ ]

            " disabled for now
            " \ 'coc-kite',
            "\ 'coc-pairs'

        nnoremap <silent> <space>e :<c-u>CocCommand explorer<cr>
        nnoremap <space>cc :CocCommand<space>

        imap <f2> <plug>(coc-snippets-expand)
        xmap <s-f2> <plug>(coc-convert-snippet)
        let g:coc_snippets_next = '<c-j>'
        let g:coc_snippets_prev = '<c-k>'

        set updatetime=300
        nmap [g <Plug>(coc-diagnostic-prev)
        nmap ]g <Plug>(coc-diagnostic-next)
        nnoremap <silent> [og :CocDiagnostics<cr>
        nnoremap <silent> ]og :lclose<cr>

        nmap gd <Plug>(coc-definition)
        nmap gy <Plug>(coc-type-definition)
        nmap gi <Plug>(coc-implementation)
        nmap gr <Plug>(coc-references)
        nnoremap <silent> gK K
        nnoremap <silent> K :call CocAction('doHover')<cr>
        nmap <space>cr <Plug>(coc-rename)
        xmap <space>cA <Plug>(coc-codeaction-selected)
        nmap <space>cA <Plug>(coc-codeaction-selected)
        nmap <space>ca <Plug>(coc-codeaction)
        nmap <space>cf <Plug>(coc-fix-current)
        xmap <space>c= <Pg>(coc-format-selected)
        nmap <space>c= <Plug>(coc-format-selected)
        nmap <space>cR <Plug>(coc-range-select)
        xmap <space>cR <Plug>(coc-range-select)

        xmap if <Plug>(coc-funcobj-i)
        omap if <Plug>(coc-funcobj-i)
        xmap af <Plug>(coc-funcobj-a)
        omap af <Plug>(coc-funcobj-a)
        xmap ic <Plug>(coc-classobj-i)
        omap ic <Plug>(coc-classobj-i)
        xmap ac <Plug>(coc-classobj-a)
        omap ac <Plug>(coc-classobj-a)
        if has('nvim-0.4.3') || has('patch-8.2.0750')
            nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<c-f>"
            nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<c-b>"
            inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<c-f>"
            inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<c-b>"
        endif

        nnoremap <silent><nowait> <space>O  :<C-u>CocList -I symbols<cr>

        function! s:cocSettings()
            if !exists('g:did_coc_loaded')
                return
            endif

            " inoremap <silent> <expr> <tab>
            "     \ pumvisible() ? "\<c-y>" :
            "     \ <SID>check_back_space() ? "\<tab>" :
            "     \ coc#refresh()

            inoremap <silent><expr> <TAB>
                \ pumvisible() ? coc#_select_confirm() :
                \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ coc#refresh()

            call coc#config('explorer.quitOnOpen', 'true')
            call coc#config('explorer.keyMappings.global', {
                \ 'e': 'noop',
                \ 'ee': 'open',
                \ 'es': 'open:split',
                \ 'ev': 'open:vsplit',
                \ 'et': 'open:tab',
                \ 's': v:false,
                \ })
            call coc#config('suggest.autoTrigger', 'always') " always, trigger, none
            call coc#config('list.insertMappings', { '<c-c>' : 'do:exit' })
            call coc#config('signature.target', 'preview')
            " call coc#config('signature.target', 'echo')
            " call coc#config('signature.target', 'float')
            call coc#config('signature.preferShownAbove', 'false')
            " call coc#config('signature.target', 'preview')
            call coc#config('python.jediEnabled', 'false')
            call coc#config('python.linting.pylintArgs', [
                \ "--load-plugins=pylint_django",
                \ "--load-plugins=pylint_django.checkers.migrations",
                \ "--errors-only",
                \ ])
            " call coc#config('diagnostic.messageTarget', 'echo')
            " call coc#config('snippets.extends', {
            "     \ 'htmldjango' : ['html']
            "     \ })
            " call coc#config('snippets.textmateSnippetsRoots', [
            "     \ g:myvimdir . 'vsnip'
            "     \ ])

            augroup vimrc_coc
                autocmd!
                autocmd CursorHold * silent call CocActionAsync('highlight')
                autocmd ColorScheme * highlight CocUnusedHighlight ctermbg=NONE guibg=NONE guifg=#808080
                " autocmd User CocOpenFloat call nvim_win_set_config(g:coc_last_float_win, {'relative': 'editor', 'row': 0, 'col': 0})
                " autocmd User CocOpenFloat call nvim_win_set_width(g:coc_last_float_win, 9999)
            augroup END
        endfunction

        AfterVimEnter call s:cocSettings()
    endif
endif
" }}}

" {{{ fzf
if has("unix")
    PkgInstall junegunn/fzf { 'do': 'BufExe !./install --bin' }
    PkgInstall junegunn/fzf.vim
elseif has("win32")
    PkgInstall junegunn/fzf { 'do': 'BufExe !powershell .\install.ps1' }
    PkgInstall junegunn/fzf.vim
endif
if PkgInstalled('fzf')
    let g:fzf_layout = { 'down': '~70%' }
    function! FZFff()
        if &buftype ==# '' && DetectRoot('%', '.git') !=# ''
        elseif isdirectory ('./.git')
            GFiles --exclude-standard --others --cached
        else
            Files
        endif
    endfunction

    nnoremap <space>f :Files<cr>
    nnoremap <space>b :Buffers<cr>

    augroup vimrc_fzf
        autocmd!
        autocmd filetype fzf tnoremap <c-j> <c-n>
        autocmd filetype fzf tnoremap <c-k> <c-p>
        autocmd filetype fzf tnoremap <buffer> jk <esc>
    augroup END
    if has("win32")
        let g:fzf_preview_window = ''
    endif
    nnoremap <silent> qb :Buffers<cr>
    nnoremap <expr> <silent> ,f isdirectory('.git') ?
        \ ":GFiles --exclude-standard --others --cached\<cr>" :
        \ ":Files\<cr>"
endif
" }}}

" {{{ polyglot
PkgInstall Glench/Vim-Jinja2-Syntax
PkgInstall sheerun/vim-polyglot
" }}}

" {{{ SimpylFold
PkgInstall tmhedberg/SimpylFold
augroup vimrc_python_fold
    autocmd!
    if PkgInstalled('SimpylFold')
        let g:SimpylFold_docstring_preview=1
        autocmd filetype python setlocal foldcolumn=2
    else
        autocmd filetype python setlocal foldmethod=indent foldcolumn=2
    endif
augroup END
" }}}

" {{{ emmet
PkgInstall mattn/emmet-vim
let g:user_emmet_leader_key = '<c-y>'
augroup vimrc_emmet
    autocmd!
    autocmd filetype html,htmldjango,jinja2,jinja.html EmmetInstall
augroup END
" }}}

" vim-cycle, vim-speeddating: <c-x> / <c-a> manipulation {{{
PkgInstall tpope/vim-speeddating
PkgInstall bootleq/vim-cycle
let g:cycle_no_mappings = 1
nmap <Plug>SpeedDatingFallbackUp   <Plug>CycleNext
nmap <Plug>SpeedDatingFallbackDown <Plug>CyclePrev
let g:cycle_default_groups = []
let g:cycle_default_groups = [['true','false'],['on','off'],['yes','no'],['asc','desc']]
let g:cycle_default_groups += [[['h1','h2','h3','h4','h5','h6'],'sub_tag']]
" let g:cycle_default_groups += [['α','β','γ','δ','ε','ζ','η','θ','ι','κ','λ','μ','ν','ξ','ο','π','σ','τ','ν']]
" let g:cycle_default_groups += [['Α','Β','Γ','Δ','Ε','Ζ','Η','Θ','Ι','Κ','Λ','Μ','Ν','Ξ','Ο','Π','Σ','Τ','Ν']]
" let g:cycle_default_groups += [['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']]
" let g:cycle_default_groups += [['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']]
" }}}

" {{{ localvimrc
let g:localvimrc_persistent = 1
let g:localvimrc_sandbox = 0
PkgInstall embear/vim-localvimrc
" }}}

" {{{ xkbswitch
AtInstallTime call DownloadGit(g:myvimdir . 'xkb-switch-win',
    \ 'https://github.com/DeXP/xkb-switch-win')
PkgInstall lyokha/vim-xkbswitch { 'type' : 'opt' }

if PkgInstalled('vim-xkbswitch')
    let g:XkbSwitchNLayout = 'us'
    let g:XkbSwitchEnabled = 1

    if has('win32')
        let g:XkbSwitchLib = g:myvimdir . 'xkb-switch-win\bin\libxkbswitch' .
            \ (has('win64') ? '64' : '32') . '.dll'
        if filereadable(g:XkbSwitchLib)
            packadd vim-xkbswitch
        endif
    endif

    if exists('$DISPLAY') && executable('xkb-switch')
        packadd vim-xkbswitch
    endif
endif
" }}}

" {{{ vim-wordmotion
PkgInstall chaoren/vim-wordmotion
let g:wordmotion_prefix = ","
" }}}

" {{{ Fullscreen F11
if has('win32') && has('gui_running')
    AtInstallTime call DownloadGit(g:myvimdir . 'gvimfullScreen_win32',
        \ 'https://github.com/derekmcloughlin/gvimfullScreen_win32')

    let s:fullScreenDLL = g:myvimdir . 'gvimfullScreen_win32\gvimfullScreen'
        \ . (has('win64') ? '_64' : '') . '.dll'

    if filereadable(s:fullScreenDLL)
        function! ToggleFullScreen(...) abort
            let visual = (a:0 >=# 1 && a:1)
            if !exists('s:fullScreen')
                let s:oldPos = [getwinposx(), getwinposy(), &lines, &columns]
            endif
            call libcallnr(s:fullScreenDLL, 'ToggleFullScreen', 0)
            if exists('s:fullScreen')
                execute 'set lines=' . s:oldPos[2] . ' columns=' . s:oldPos[3]
                execute 'winpos ' . s:oldPos[0] . ' ' . s:oldPos[1]
                unlet s:fullScreen
            else
                let s:fullScreen = v:true
            endif
            if visual
                normal! gv
            elseif getcmdtype() !=# ''
                redraw
                return ''
            endif
        endfunction

        nnoremap <f11> :<c-u>call ToggleFullScreen()<cr>
        vnoremap <f11> :<c-u>call ToggleFullScreen(1)<cr>
        inoremap <f11> <c-o>:call ToggleFullScreen()<cr>
        cnoremap <f11> <c-r>=ToggleFullScreen()<cr>
        tnoremap <f11> <c-\><c-n>:call ToggleFullScreen()<cr>i
    endif
else
    map <silent> <F11>
        \ :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>
endif
" }}}

" {{{ vim-bbye
PkgInstall moll/vim-bbye
nnoremap qd :Bwipeout<cr>
nnoremap qD :Bwipeout!<cr>
" }}}

" {{{ undotree
nnoremap <silent> <space>u :<c-u>UndotreeToggle<cr>
PkgInstall mbbill/undotree
" }}}

" {{{ Disable <c-z> on windows
if has("win32") && !has("gui_running")
    cabbrev suspend echo "suspend does not work on windows"
    cabbrev stop echo "stop does not work on windows"
    nnoremap <silent> <c-z> :echo '<lt>c-z> does not work on windows'<cr>
endif
" }}}

" {{{ Various file type settings
let g:vim_indent_cont = 4
let g:vim_json_conceal = 0

augroup vimrc
    autocmd!
    autocmd filetype vim setlocal foldmethod=marker foldcolumn=2 formatoptions-=o
    autocmd filetype jsonc,json5 setlocal commentstring=//%s
    autocmd filetype sql setlocal commentstring=--%s
    " autocmd filetype html if DetectRoot('<afile>', 'manage.py') !=# ''
    "     \ | setlocal filetype=htmldjango
    "     \ | call s:htmldjangoSettings() | endif
    autocmd filetype html,css,htmldjango,jinja.html setlocal shiftwidth=2 softtabstop=2
    autocmd filetype jinja.html call s:htmldjangoSettings()
    autocmd filetype make,snippets setlocal shiftwidth=8 softtabstop=8 noexpandtab
    autocmd filetype autohotkey let &commentstring=';%s'
    autocmd filetype ps1 nnoremap <space>ch :CocCommand powershell.toggleTerminal<cr>
    autocmd filetype ps1 nnoremap <space>cs :CocCommand powershell.evaluateLine<cr>
    autocmd filetype ps1 xnoremap <space>cs :CocCommand powershell.evaluateSelection<cr>
    autocmd filetype markdown unmap <buffer> ge
    autocmd filetype markdown nnoremap <buffer> gX <Plug>Markdown_EditUrlUnderCursor
    autocmd filetype markdown xnoremap <buffer> gX <Plug>Markdown_EditUrlUnderCursor
    autocmd BufNewFile *.ahk set bomb
    " autocmd TextChanged,TextChangedI * call AutoSaveIfVersionControlled() " FIXME: broken?
    autocmd filetype htmldjango call s:htmldjangoSettings()
    autocmd QuickFixCmdPost [^l]* nested cwindow
    autocmd QuickFixCmdPost    l* nested lwindow
    autocmd InsertEnter * set cursorline
    autocmd InsertLeave * set nocursorline
    " autocmd InsertEnter * set cursorline cursorcolumn
    " autocmd InsertLeave * set nocursorline nocursorcolumn
    " autocmd InsertEnter * nested colorscheme industry
    " autocmd InsertLeave * nested colorscheme darkblue
    " autocmd InsertEnter * highlight Normal guibg=#000060
    " autocmd InsertLeave * highlight Normal guibg=#000040
augroup END

nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

function! AutoSaveIfVersionControlled() abort
    if !exists('b:is_version_controlled')
        let b:is_version_controlled = (DetectRoot('%', '.git') !=# "")
    endif
    if b:is_version_controlled
        silent! update
    endif
endfunction

function! s:htmldjangoSettings() abort
    let b:surround_{char2nr("v")} = "{{ \r }}"
    let b:surround_{char2nr("{")} = "{{ \r }}"
    let b:surround_{char2nr("%")} = "{% \r %}"
    let b:surround_{char2nr("b")} = "{% block \1block name: \1 %}\r{% endblock \1\1 %}"
    let b:surround_{char2nr("i")} = "{% if \1condition: \1 %}\r{% endif %}"
    let b:surround_{char2nr("w")} = "{% with \1with: \1 %}\r{% endwith %}"
    let b:surround_{char2nr("f")} = "{% for \1for loop: \1 %}\r{% endfor %}"
    let b:surround_{char2nr("c")} = "{% comment %}\r{% endcomment %}"
endfunction
" }}}

" {{{ More packages
PkgInstall jpalardy/vim-slime
if has('nvim')
    let g:slime_target = "neovim"
elseif has ('vim8')
    let g:slime_target = "vimterminal"
else
    let g:slime_target = "tmux"
endif
xmap <a-c><a-c> <Plug>SlimeRegionSend
nmap <a-c><a-c> <Plug>SlimeParagraphSend
nmap <a-c>v     <Plug>SlimeConfig
PkgInstall AndrewRadev/tagalong.vim
PkgInstall honza/vim-snippets
PkgInstall jototland/trivial-text-objects.vim
PkgInstall junegunn/goyo.vim
PkgInstall junegunn/gv.vim
PkgInstall michaeljsmith/vim-indent-object
PkgInstall neoclide/jsonc.vim
PkgInstall sgur/vim-editorconfig
PkgInstall tommcdo/vim-lion
PkgInstall tommcdo/vim-exchange
PkgInstall tpope/vim-commentary

" {{{ Dadbod
" For sql server, also install `sqlcmd`
PkgInstall tpope/vim-dadbod
PkgInstall kristijanhusak/vim-dadbod-ui
nnoremap <silent> <leader>du :DBUIToggle<CR>
nnoremap <silent> <leader>df :DBUIFindBuffer<CR>
nnoremap <silent> <leader>dr :DBUIRenameBuffer<CR>
nnoremap <silent> <leader>dl :DBUILastQueryInfo<CR>
let g:db_ui_save_location = g:myvimdir . 'db_ui'
let g:sf3 = 'sqlserver://sf3/kcsdbs'
PkgInstall tpope/vim-eunuch
PkgInstall tpope/vim-repeat
PkgInstall tpope/vim-fugitive
PkgInstall tpope/vim-scriptease
PkgInstall tpope/vim-surround
PkgInstall tpope/vim-unimpaired
PkgInstall tpope/vim-projectionist

PkgInstall Konfekt/FastFold
PkgInstall ConradIrwin/vim-bracketed-paste
PkgInstall tmux-plugins/vim-tmux
PkgInstall wellle/targets.vim
PkgInstall wellle/context.vim
let g:context_enabled = 0
PkgInstall wellle/visual-split.vim
PkgInstall AndrewRadev/splitjoin.vim
PkgInstall Chandlercjy/vim-markdown-edit-code-block

" Note taking app NV and vimwiki
if executable('rg')
    let g:nv_search_paths = ['~/OneDrive/markdown-notes']
    " PkgInstall alok/notational-fzf-vim {'type': 'opt' }
    PkgInstall jototland/notational-fzf-vim {'type': 'opt' }
    if PkgInstalled('notational-fzf-vim')
        packadd notational-fzf-vim
    endif
    nnoremap <space>n :<c-u>NV<cr>
    let g:nv_create_note_key = 'ctrl-x'
    let g:nv_create_note_window = 'split'
    PkgInstall vimwiki/vimwiki { 'branch': 'dev' }
    let g:vimwiki_list = [{'path': '~/Onedrive/markdown-notes', 'syntax': 'markdown', 'ext': '.md'}]
    let g:vimwiki_auto_chdir = 0
    let g:vimwiki_create_link = 0
endif

PkgInstall dhruvasagar/vim-table-mode

if executable('ctags-exuberant')
    PkgInstall ludovicchabant/vim-gutentags { 'type': 'opt' }
    if PkgInstalled('vim-gutentags')
        packadd vim-gutentags
    endif
endif

PkgInstall metakirby5/codi.vim
if has('python3')
    PkgInstall puremourning/vimspector { 'type' : 'opt' }
    if PkgInstalled('vimspector')
        packadd vimspector
    endif
endif
" PkgInstall kshenoy/vim-signature
PkgInstall iamcco/markdown-preview.nvim { 'do': 'packloadall! | call mkdp#util#install()' }
PkgInstall morhetz/gruvbox
PkgInstall tpope/vim-vividchalk
PkgInstall xolox/vim-colorscheme-switcher
let g:colorscheme_switcher_define_mappings = 0
nnoremap <leader><f1> :PrevColorScheme<cr>
nnoremap <leader><f2> :NextColorScheme<cr>
PkgInstall xolox/vim-misc
" PkgInstall junegunn/vim-slash
" if has('timers')
"   " Blink 2 times with 50ms interval
"   noremap <expr> <plug>(slash-after) 'zz'.slash#blink(2, 50)
" endif
PkgInstall romainl/vim-cool
nnoremap <silent> <expr> n v:searchforward ? 'n' : 'N'
nnoremap <silent> <expr> N v:searchforward ? 'N' : 'n'
PkgInstall easymotion/vim-easymotion
" }}}


PkgInstall itchyny/lightline.vim
let g:lightline = {}
let g:lightline['colorscheme'] = 'powerlineish'
let g:lightline['active']={}
let g:lightline['active']['left']=[['mode', 'paste'],['readonly', 'filename', 'modified']]
let g:lightline['active']['right']=[['modified'], ['fileformat', 'fileencoding', 'bomb', 'filetype'], ['gitbranch', 'cocstatus']]
let g:lightline['inactive']={}
let g:lightline['inactive']['left']=[['filename']]
let g:lightline['inactive']['right']=[[]]
let g:lightline['component']={}
let g:lightline['component']['filename']='%F'
let g:lightline['component_function'] = {}
let g:lightline['component_function']['gitbranch'] = 'FugitiveHead'
let g:lightline['component_function']['cocstatus'] = 'coc#status'
let g:lightline['component_function']['bomb'] = 'Bomb'

function! Bomb()
    return &bomb ? 'bom' : ''
endfunction

" function! SwapText(mode) abort
"     let old = getreg(v:register, 1, 1)
"     let oldT = getregtype(v:register)
"     if a:mode ==? 'v' || a:mode ==# "\<c-v>"
"         normal! gvy
"     elseif a:mode ==# "char"
"         normal! `[v`]y
"     elseif a:mode ==# "line"
"         normal! `[V`]y
"     elseif a:mode ==# "block"
"         execute "normal! `[\<c-v>`]y"
"     endif
"     let new = getreg(v:register, 1, 1)
"     let newT = getregtype(v:register)
"     call setreg(v:register, old, oldT)
"     normal! gvp
"     call setreg(v:register, new, newT)
" endfunction
" nnoremap <space>x :set operatorfunc=SwapText<cr>g@
" vnoremap <space>x :<c-u>call SwapText(visualmode())<cr>

" let g:vimwiki_conceallevel=0
nnoremap \1 :<c-u>set conceallevel=0<cr>
nnoremap \2 :<c-u>set conceallevel=1<cr>
nnoremap \3 :<c-u>set conceallevel=2<cr>
nnoremap \4 :<c-u>set conceallevel=3<cr>

" {{{ colorscheme, etc
if &term==#'xterm-256color' || &term=='xterm-kitty' || &term==#'win32'
    set termguicolors
    colorscheme darkblue
elseif &term==#'builtin_vtpcon' || &term==#'nvim'
    set termguicolors
    if PkgInstalled('gruvbox')
      colorscheme gruvbox
    else
      colorscheme darkblue
    endif
endif
if has("gui_running")
    colorscheme darkblue
    set lines=50 columns=130
    let g:did_install_default_menus = 1
    let g:did_install_syntax_menu = 1
    set guioptions=cdk
    if has("win32")
        set guifont=Lucida_Sans_Typewriter:h10
    endif
endif
" }}}

command! -range FormatXML <line1>,<line2>! xmllint --format --noent --encode utf-8 --recover - | tail +2
command! -range FormatJSON <line1>,<line2>! python -m json.tool

command! -nargs=0 ToPDF call ToPDF()
function! ToPDF()
    if !executable('ps2pdf')
        echoerr "ToPDF: Please install ps2pdf first!"
        return
    endif
    let file_dir = expand('%:p:h')
    let file_basename = expand('%:t:r')
    let ps_file = tempname()
    let pdf_file = file_dir . '/' . file_basename . '.pdf'
    if filereadable(pdf_file) && input("'" . pdf_file . "' alredy exists. Overwrite? [y/N]") !~? '^y\%[es]$'
        echoerr "ToPDF: not overwriting, exiting"
        return
    endif
    echomsg "Writing '" . pdf_file . "'"
    execute "hardcopy > " . fnameescape(ps_file) . " | !ps2pdf " . fnameescape(ps_file) . ' ' . fnameescape(pdf_file)
    execute '!rm ' . fnameescape(ps_file)
endfunction

PkgInstall vim-ctrlspace/vim-ctrlspace
PkgInstall yegappan/mru
PkgInstall vim-scripts/hexman.vim
if has('nvim')
    PkgInstall github/copilot.vim
endif

command! -nargs=? -complete=file Open call Open(<f-args>)
function Open(...)
    if a:0 ==# 0
        let fn = expand('<cfile>')
    elseif a:0 ==# 1
        let fn = a:1
    else
        echomsg "Open: too many arguments"
        return
    endif
    if filereadable(fn)
        python3 os.startfile(vim.eval('l:fn'))
    else
        echomsg 'Open: file "' . fn . '" doesn''t exist'
    endif
endfunction
