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
    if has('win32') && executable(expand('~/venv/nvim/Scripts/python.exe', 1))
        let g:python3_host_prog = '~/venv/nvim/Scripts/python.exe'
    elseif has('unix') && executable('~/venv/nvim/bin/python')
        let g:python3_host_prog = '~/venv/nvim/bin/python'
    endif
    command -nargs=0 ServerName call ClipboardSend(v:servername) | echo v:servername
endif

if has('nvim') && has('win32')
    let &shell = has('win32') ? 'powershell' : 'pwsh'
    let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    set shellquote= shellxquote=
endif

"}}}

" {{{ options
set langmenu=en_US.UTF-8
language en
" "LC_COLLATE=nb_NO;LC_CTYPE=nb_NO;LC_MONETARY=nb_NO;LC_NUMERIC=C;LC_TIME=nb_NO"
set noswapfile autoread

set encoding=utf-8 fileformats=unix,dos
setglobal fileencoding=utf-8
set timeout ttimeout timeoutlen=1500 ttimeoutlen=10 updatetime=300

set hidden visualbell
set backspace=indent,eol,start virtualedit=block,insert
set wildmode=list:longest wildignore=*.o,*~
set wildignore=NTUSER.DAT*,*.o,*.class,*.pyc,__pycache__/,.git/,*.png,*.jpg,*.jpeg,*.gif,*.exe
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

nnoremap æ :<c-u>echom "Du har norsk tastaturoppsett!"<cr>
nnoremap Æ :<c-u>echom "Du har norsk tastaturoppsett!"<cr>
nnoremap ø :<c-u>echom "Du har norsk tastaturoppsett!"<cr>
nnoremap Ø :<c-u>echom "Du har norsk tastaturoppsett!"<cr>
nnoremap å :<c-u>echom "Du har norsk tastaturoppsett!"<cr>
nnoremap Å :<c-u>echom "Du har norsk tastaturoppsett!"<cr>
nnoremap U :<c-u>echom "Slå av CAPS LOCK!"<cr>

nnoremap ; :
vnoremap ; :
nnoremap s <c-w>

inoremap <c-g><cr> <cr><c-o>O<c-f>
" the opposite of <c-g><cr> is usually va}J

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
inoremap <expr> <cr> pumvisible() ? '<c-y>' : '<c-g>u<cr>'

inoremap <c-^> <esc><c-^>

nnoremap gb :buffers<cr>:b<space>

nnoremap <silent> <c-l> <c-l>:call <sid>ctrl_l()\|nohlsearch<cr>
inoremap <expr> <c-l> <sid>ctrl_l()
function s:ctrl_l()
    silent! call coc#float#close_all()
    if !has('nvim')
        call popup_clear()
    endif
    WindowIdentify
    return ""
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

let s:b64 = [
    \ 'A','B','C','D','E','F','G','H','I','J','K','L','M',
    \ 'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
    \ 'a','b','c','d','e','f','g','h','i','j','k','l','m',
    \ 'n','o','p','q','r','s','t','u','v','w','x','y','z',
    \ '0','1','2','3','4','5','6','7','8','9','+', '*' ]

function! Base64Enc(text)
    let i = 0
    let n = len(a:text)
    let result = ''
    while i < n
        let i1 = char2nr(a:text[i])
        let i2 = (i+1 < n ? char2nr(a:text[i+1]) : 0)
        let i3 = (i+2 < n ? char2nr(a:text[i+2]) : 0)
        let o1 = i1 / 4
        let o2 = or(and(i1, 3) * 16, i2 / 16)
        let o3 = or(and(i2, 15) * 4, i3 / 64)
        let o4 = and(i3, 63)
        let result = result . s:b64[o1] . s:b64[o2] .
            \ (i+1 < n ? s:b64[o3] : '=') .
            \ (i+2 < n ? s:b64[o4] : '=')
        let i += 3
    endwhile
    return result
endfunction

function! Osc52Send(text) range
    silent execute '!echo ' .
        \ shellescape("\e]52;c;" . Base64Enc(a:text) . "\x07")
    redraw!
endfunction

function! WinClipExeSend(text) range
    call system('clip.exe', a:text)
endfunction

function! ClipboardSend(text)
    if g:clipboard_send_method == "clip.exe"
        call WinClipExeSend(a:text)
    else
        call Osc52Send(a:text)
    endif
endfunction

function! ClipboardSend_Op(type, op) abort range
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

let g:clipboard_send_method = "clip.exe"

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
    nnoremap <silent> <F7> :FloatermNew --width=0.9 --height=0.9<CR>
    nnoremap <silent> <s-f7> :FloatermNew --wintype=split --height=0.5<cr>
    tnoremap <silent> <F7> <C-\><C-n>:FloatermNew<CR>
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

augroup EOLWhitespace
    autocmd!
    autocmd Colorscheme *
        \ highlight EOLWhiteSpace ctermbg=red guibg=red
    autocmd WinNew *
        \ if &buftype == '' |
        \ let w:eolwhitespacematch =  matchadd('EOLWhiteSpace', '\s\+$', 10) |
        \ endif
    autocmd InsertEnter *
        \ if &buftype == '' |
        \ silent! call matchdelete(w:eolwhitespacematch) |
        \ silent! call matchadd('EOLWhiteSpace', '\s\+\%#\@<!$', 10, w:eolwhitespacematch) |
        \ endif
    autocmd InsertLeave *
        \ if &buftype == '' |
        \ silent! call matchdelete(w:eolwhitespacematch) |
        \ silent! call matchadd('EOLWhiteSpace', '\s\+$', 10, w:eolwhitespacematch) |
        \ endif
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

command! -count=1 -bar FocusR call Focus(<count>, 'right')
command! -nargs=0 -bar Zoom call Zoom()

function! Focus(ncolumns, where)
    if winnr('$') ==! 1
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
    call PopupClear()
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
imap <f1> <plug>(endoscope-close-pair)

if has('python3')
    PkgInstall SirVer/UltiSnips
    if PkgInstalled('UltiSnips')
        let g:UltiSnipsExpandTrigger="<c-s>"
        let g:UltiSnipsJumpForwardTrigger="<c-j>"
        let g:UltiSnipsJumpBackwardTrigger="<c-k>"
        " let g:UltiSnipsSnippetDirectories=['~/us', 'UltiSnips']
        let g:UltiSnipsSnippetDirectories=['~/us']

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
            \ 'coc-tsserver',
            \ 'coc-json',
            \ 'coc-html',
            \ 'coc-css',
            \ 'coc-emmet',
            \ 'coc-pyright',
            \ 'coc-r-lsp',
            \ 'coc-snippets',
            \ 'coc-rls',
            \ 'coc-powershell',
            \ ]

            " disabled for now
            " \ 'coc-vimlsp',
            " \ 'coc-kite',
            "\ 'coc-pairs'

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
        nmap <space>ca <Plug>(coc-codeaction) " entire buffer
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

        nnoremap <silent><nowait> <space>O  :<C-u>CocList -I symbols<cr>

        command! -nargs=0 OrganizeImports
            \ :<c-u>call CocAction('runCommand', 'editor.action.organizeImport')

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

            call coc#config('suggest.autoTrigger', 'always') " always, trigger, none
            call coc#config('list.insertMappings', { '<c-c>' : 'do:exit' })
            call coc#config('signature.target', 'preview')
            call coc#config('signature.target', 'echo')
            call coc#config('signature.target', 'float')
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

" {{{ indentLine
PkgInstall Yggdroot/indentLine
if has('nvim')
    PkgInstall lukas-reineke/indent-blankline.nvim
    let g:indent_blankline_extra_indent_level = -1
endif
let g:indentLine_fileTypeExclude = ['vimwiki', 'markdown', 'fern']
let g:indentline_setConceal = 0
" }}}

" {{{ localvimrc
let g:localvimrc_persistent = 1
let g:localvimrc_sandbox = 0
PkgInstall embear/vim-localvimrc
" }}}

" {{{ fern
PkgInstall lambdalisue/fern.vim
PkgInstall lambdalisue/fern-git-status.vim
PkgInstall lambdalisue/fern-mapping-git.vim
if has('nvim')
    PkgInstall antoinemadec/FixCursorHold.nvim
endif

nnoremap <silent> <space>e :<c-u>Fern -drawer -toggle -reveal=% .<cr><c-w>=

augroup vimrc_fern
    autocmd!
    autocmd filetype fern call <sid>fernBufferSettings()
augroup END

let g:netrw_banner = 0
if has('win32')
    let g:netrw_scp_cmd = 'scp'
endif
" let g:loaded_netrw = 1
" let g:loaded_netrwPlugin = 1
" let g:loaded_netrwSettings = 1
" let g:loaded_netrwFileHandlers = 1
let g:fern#scheme#file#show_absolute_path_on_root_label = 1
let g:fern#drawer_width = 40
let g:fern#keepalt_on_edit = 1
let g:fern#keepjumps_on_edit = 1
let g:fern#disable_default_mappings = 1
let g:fern#default_exclude = ''

function! s:fernBufferSettings()
    setlocal nonumber
    nmap <buffer> <f1> <plug>(fern-action-help)
    nmap <buffer> h <plug>(fern-action-collapse)
    nmap <buffer> l <plug>(fern-action-expand)

    " nmap <buffer> V V<plug>(fern-action-mark:set):normal! gv<cr>
    " vmap <buffer> <nowait> <space> V
    " vmap <buffer> j j<plug>(fern-action-mark:set):normal! gv<cr>
    " vmap <buffer> k k<plug>(fern-action-mark:set):normal! gv<cr>
    nmap <buffer> <nowait> m <plug>(fern-action-mark:toggle)
    vmap <buffer> <nowait> m <plug>(fern-action-mark:toggle)
    nmap <buffer> u <plug>(fern-action-mark:clear)
    vmap <buffer> u V<plug>(fern-action-mark:clear)

    nmap <buffer> - <plug>(fern-action-leave)
    nmap <buffer> + <plug>(fern-action-enter)
    nmap <silent> <buffer> <cr> <plug>(fern-action-open:edit):KeepWin FernDo close<cr>
    nmap <silent> <buffer> oo <plug>(fern-action-open:edit):KeepWin FernDo close<cr>
    nmap <silent> <buffer> <nowait> O <plug>(fern-action-open:select):KeepWin FernDo close<cr>
    nmap <silent> <buffer> os <plug>(fern-action-open:split):KeepWin FernDo close<cr>
    nmap <silent> <buffer> ov <plug>(fern-action-open:vsplit):KeepWin FernDo close<cr>
    nmap <silent> <buffer> <nowait> t <plug>(fern-action-open:tabedit):KeepWin FernDo close<cr>
    nnoremap <silent> <buffer> <expr> n v:searchforward ? ":\<c-u>normal! $n\<cr>" : 'n'
    nnoremap <silent> <buffer> <expr> N v:searchforward ? 'N' : ":\<c-u>normal! $N\<cr>"
    nmap <buffer> <nowait> H <Plug>(fern-action-hidden:toggle)
    nmap <buffer> r <Plug>(fern-action-reload:all)
    nmap <buffer> <nowait> f <plug>(fern-action-new-path)
    nmap <buffer> D <plug>(fern-action-remove)
    nmap <buffer> M <plug>(fern-action-move)
    nmap <buffer> C <plug>(fern-action-copy)
    nmap <buffer> R <plug>(fern-action-rename)
    nmap <buffer> y <plug>(fern-action-clipboard-copy)
    nmap <buffer> Y <plug>(fern-action-yank:path)
    nmap <buffer> <nowait> d <plug>(fern-action-clipboard-move)
    nmap <buffer> p <plug>(fern-action-clipboard-paste)
    nmap <buffer> i <plug>(fern-action-include)
    nmap <buffer> x <plug>(fern-action-exclude)
    nmap <buffer> <nowait> g <plug>(fern-action-grep)
    nmap <buffer> T <plug>(fern-action-terminal:split)
    nmap <buffer> z <plug>(fern-action-zoom:full)
    nmap <buffer> < <plug>(fern-action-git-stage)
    nmap <buffer> > <plug>(fern-action-git-unstage)
    nnoremap <silent> <buffer> <nowait> q :<c-u>FernDo close<cr>
endfunction
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
PkgInstall AndrewRadev/tagalong.vim
PkgInstall honza/vim-snippets
" PkgInstall jototland/filterops.vim
PkgInstall jototland/trivial-text-objects.vim
PkgInstall junegunn/goyo.vim
PkgInstall junegunn/gv.vim
PkgInstall michaeljsmith/vim-indent-object
PkgInstall neoclide/jsonc.vim
PkgInstall sgur/vim-editorconfig
PkgInstall tommcdo/vim-lion
PkgInstall tommcdo/vim-exchange
PkgInstall tpope/vim-commentary
PkgInstall tpope/vim-dadbod
PkgInstall tpope/vim-eunuch
PkgInstall tpope/vim-repeat
PkgInstall tpope/vim-fugitive
PkgInstall tpope/vim-scriptease
PkgInstall tpope/vim-surround
PkgInstall tpope/vim-unimpaired

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
    let g:nv_search_paths = ['~/Onedrive/markdown-notes']
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
    let g:vimwiki_auto_chdir = 1
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

function! SwapText(mode) abort
    let old = getreg(v:register, 1, 1)
    let oldT = getregtype(v:register)
    if a:mode ==? 'v' || a:mode ==# "\<c-v>"
        normal! gvy
    elseif a:mode ==# "char"
        normal! `[v`]y
    elseif a:mode ==# "line"
        normal! `[V`]y
    elseif a:mode ==# "block"
        execute "normal! `[\<c-v>`]y"
    endif
    let new = getreg(v:register, 1, 1)
    let newT = getregtype(v:register)
    call setreg(v:register, old, oldT)
    normal! gvp
    call setreg(v:register, new, newT)
endfunction
nnoremap <space>x :set operatorfunc=SwapText<cr>g@
vnoremap <space>x :<c-u>call SwapText(visualmode())<cr>

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
