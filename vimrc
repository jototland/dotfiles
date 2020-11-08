" This file can be placed in
" Unix vim => ~/.vim/vimrc
" Unix neovim => ~/.config/nvim/init.vim
" Windows vim => ~/.vim/vimrc
" Windows neovim => ~/.config/nvim/init.vim
" Author: Jo Totland
let g:loaded_strip_trailing_whitespace = 1

set nobackup noswapfile noundofile autoread
if has("viminfo") | set viminfo=
elseif has ("shada") | set shada= | endif
set secure
set hidden
set encoding=utf-8
setglobal fileencoding=utf-8
set fileformats=unix,dos
set visualbell
set backspace=indent,eol,start
set virtualedit=block,insert
set wildmode=list:longest wildignore=*.o,*~
set complete=.,w,b,u,t,i,d,kspell completeopt=menu,longest,preview
set confirm
set termguicolors
colorscheme darkblue
set number
try
    set signcolumn=number "has("patch-8.1.1564")
catch
    set signcolumn=yes
endtry
set cmdheight=2
set shortmess+=ac
if has("gui_running")
    set lines=50 columns=130
    set guioptions=cdk
    if has("win32")
        set guifont=Lucida_Sans_Typewriter:h10
    endif
endif
filetype plugin indent on
syntax on
set omnifunc=syntaxcomplete#Complete
set expandtab shiftwidth=4 softtabstop=4 tabstop=8
set textwidth=0 formatoptions-=o
set splitbelow splitright
set formatoptions-=o

let g:polyglot_disabled = ['autoindent']
let g:vim_indent_cont = 4
let g:vim_json_conceal = 0
if has("win32") || !has("nvim")
    let g:fzf_preview_window = ''
endif
let g:localvimrc_persistent = 1
let g:indentline_setConceal = 0
let g:UltiSnipsExpandTrigger="<c-s>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"
let g:XkbSwitchNLayout = 'us'
let g:coc_global_extensions = [
    \ 'coc-explorer',
    \ 'coc-tsserver',
    \ 'coc-json',
    \ 'coc-html',
    \ 'coc-css',
    \ 'coc-python',
    \ 'coc-r-lsp',
    \ 'coc-vimlsp',
    \ 'coc-snippets' ]
let g:coc_snippet_next = '<c-j>'
let g:coc_snippet_prev = '<c-k>'
let g:nuake_size = 0.6
let g:nuake_per_tab = 1
" let g:user_emmet_install_global = 0
let g:user_emmet_leader_key = "<c-space>e"
if !has("python3")
    let did_plugin_ultisnips = "missing python3"
    let did_after_plugin_ultisnips_after = "missing python3"
    let loaded_matchtagalways = "missing python3"
endif
if !executable("node")
    let did_coc_loaded = "missing node"
endif

if !exists("g:loaded_matchit")
    runtime macros/matchit.vim
endif

nnoremap ; :
vnoremap ; :

inoremap jk <esc>
cnoremap jk <c-c>
inoremap <expr> jk pumvisible()? '<c-e>' : '<esc>'

if has("nvim")
    tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"
    tnoremap <expr> jk (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"
    tnoremap <expr> <c-^> (&filetype == "fzf") ? "<c-^>" : "<c-\><c-n><c-^>"
    tnoremap <expr> <c-w> (&filetype == "fzf") ? "<c-w>" : "<c-\><c-n><c-w>"
end

nnoremap <silent> <c-l> :<c-u>nohlsearch<cr><c-l>

inoremap <expr> <c-j> pumvisible()? '<down>' : '<c-j>'
inoremap <expr> <c-k> pumvisible()? '<up>' : '<c-k>'
inoremap <expr> <esc> pumvisible()? '<c-e>' : '<esc>'
inoremap <expr> <cr> pumvisible()? '<c-y>' : '<cr>'

inoremap <c-w> <esc><c-w>

cabbrev <expr> %% expand('%:p:h')

function! s:ResDot(count)
    execute "normal!" a:count . "."
    if line("'[") <= line("$")
        normal! g`[
    endif
endfunction
nnoremap <silent> . :<C-U>call <sid>ResDot(v:count1)<CR>

nnoremap Y y$

nnoremap <silent> [oq :copen<cr>
nnoremap <silent> ]oq :cclose<cr>

abbrev :now: <c-r>=strftime("%Y-%m-%d %T")<CR>

nnoremap <silent> <space>q :BdeleteNotClose<cr>
nnoremap <silent> <space>fa :Ag<cr>
nnoremap <silent> <space>fb :Buffers<cr>
nnoremap <silent> <space>fC :Colors<cr>
nnoremap <silent> <space>fc :Commands<cr>
nnoremap <silent> <space>ff :Files<cr>
nnoremap <silent> <space>fg GFiles<cr>
nnoremap <silent> <space>fG GFiles?<cr>
nnoremap <silent> <space>fh :Helptags<cr>
nnoremap <silent> <space>fl :Blines<cr>
nnoremap <silent> <space>fL :Lines<cr>
nnoremap <silent> <space>fm :Marks<cr>
nnoremap <silent> <space>fM :Maps<cr>
nnoremap <silent> <space>fo :BCommits<cr>
nnoremap <silent> <space>fO :Commits<cr>
nnoremap <silent> <space>fw :Windows<cr>
nnoremap <silent> <space>f/ :History/<cr>
nnoremap <silent> <space>f: :History<cr>
nnoremap <silent> <space>fs :Snippets<cr>
nnoremap <silent> <space>u :<c-u>UndotreeToggle<cr>
nnoremap <silent> <space>v :Vifm<cr>
nnoremap <silent> <space>% :MtaJumpToOtherTag<cr>
nnoremap <F12> :Nuake<CR>
inoremap <F12> <C-\><C-n>:Nuake<CR>
tnoremap <F12> <C-\><C-n>:Nuake<CR>
nnoremap <F2> :Nuake<CR>
inoremap <F2> <C-\><C-n>:Nuake<CR>
tnoremap <F2> <C-\><C-n>:Nuake<CR>

nnoremap <space>~v :edit $MYVIMRC<cr>
nnoremap <space>~p :edit ~/Documents/WindowsPowerShell/profile.ps1<cr>
nnoremap <space>~b :edit ~/.bashrc<cr>
nnoremap <space>8 /.\{80,\}/e<cr>

imap <C-l> <Plug>(coc-snippets-expand)
vmap <C-j> <Plug>(coc-snippets-select)
imap <C-j> <Plug>(coc-snippets-expand-jump)
xmap <leader>x  <Plug>(coc-convert-snippet)

nmap [g <Plug>(coc-diagnostic-prev)
nmap ]g <Plug>(coc-diagnostic-next)
nnoremap <silent> [og :CocDiagnostics<cr>
nnoremap <silent> ]og :lclose<cr>

nmap gd <Plug>(coc-definition)
nmap gy <Plug>(coc-type-definition)
nmap gi <Plug>(coc-implementation)
nmap gr <Plug>(coc-references)
nnoremap <silent> <space>K :call CocAction('doHover')<cr>
nmap <space>e :CocCommand explorer<cr>
nmap <space>R <Plug>(coc-rename)
xmap <space>a <Plug>(coc-codeaction-selected)
nmap <space>a <Plug>(coc-codeaction-selected)
nmap <space>A <Plug>(coc-codeaction) " entire buffer
nmap <space>x <Plug>(coc-fix-current)
xmap <space>= <Plug>(coc-format-selected)
nmap <space>= <Plug>(coc-format-selected)

xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

nmap <space>r <Plug>(coc-range-select)
xmap <space>r <Plug>(coc-range-select)

nnoremap <silent><nowait> <space>O  :<C-u>CocList -I symbols<cr>

command! -nargs=0 OrganizeImports :<c-u>call CocAction('runCommand', 'editor.action.organizeImport')

for x in split("hjklHJKLcosv<>+-", '\zs')
    execute "noremap <a-" . x . "> <c-w>" . x
    execute "inoremap <a-" . x . "> <esc><c-w>" . x
    if has("nvim")
        execute "tnoremap <a-" . x . '> <c-\><c-n><c-w>' . x
    else
        execute "tnoremap <a-" . x . "> <c-w>" . x
    endif
endfor

if has("win32") && !has("gui_running")
    cabbrev suspend echo "suspend does not work on windows"
    cabbrev stop echo "stop does not work on windows"
    nnoremap <silent> <c-z> :echo '<lt>c-z> does not work on windows'<cr>
endif

augroup vimrc
    autocmd!
    autocmd filetype help nnoremap <buffer> q :helpclose<cr>
augroup END

" g:MyVimDir is the directory where vimrc is stored
let g:MyVimDir = fnamemodify(split(&runtimepath, ",")[0], ":p")

function! DownloadFile(base, name, url) abort
    if executable("curl")
        let fname = a:base . '/' . a:name
        let dir = fnamemodify(fname, ':h')
        call mkdir(dir, 'p')
        if empty(glob(fname))
            execute "!curl -fLo " . fname . ' ' . a:url
        endif
    endif
endfunction

function! DownloadGit(base, name, url) abort
    let dir = a:base . '/' . a:name
    call mkdir(dir, 'p')
    if empty(glob(dir . '/.git/HEAD')) && executable("git")
        execute '!git clone ' . a:url . ' ' . dir
    endif
    return !empty(glob(dir . '/.git/HEAD'))
endfunction

command! -nargs=* AfterVimEnter :call <sid>afterVimEnter(<q-args>)
function! s:afterVimEnter(cmd)
    if v:vim_did_enter
        execute a:cmd
    else
        execute 'autocmd VimEnter * ' . a:cmd
    endif
endfunction

command! Rtp Redir echo &rtp|s/,/\r/g

function! s:xkbswitchSettings(install)
    if has("win64")
        let nn = "64"
    elseif has("win32")
        let nn = "32"
    else
        return
    endif
    let dll = 'libxkbswitch' . nn . '.dll'
    let url = 'https://github.com/DeXP/xkb-switch-win/raw/master/bin/' . dll
    if a:install == "install"
        call DownloadFile(g:MyVimDir, dll, url)
    endif
    if filereadable(g:MyVimDir . '/' . dll)
        let g:XkbSwitchLib = g:MyVimDir . '/' . dll
        let g:XkbSwitchEnabled = 1
    endif
endfunction
call s:xkbswitchSettings(0)

function! s:cocSettings()
    if !exists('g:did_coc_loaded')
        return
    endif

    inoremap <silent><expr> <TAB>
        \ pumvisible() ? coc#_select_confirm() :
        \ coc#expandableOrJumpable() ?
        \     "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
        \     <SID>check_back_space() ?
        \         "\<TAB>" :
        \         coc#refresh()

    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    call coc#config("suggest.autoTrigger", "none")
    call coc#config("explorer.position", "floating")

    augroup vimrc_coc
        autocmd!
        autocmd CursorHold * silent call CocActionAsync('highlight')
    augroup END
endfunction

AfterVimEnter call s:cocSettings()

function! PackInit()
    call DownloadGit(g:MyVimDir, 'pack/minpac/opt/minpac',
        \'https://github.com/k-takata/minpac.git')
    packadd minpac
    call minpac#init()

    call DownloadFile(g:MyVimDir, 'plugin/Redir.vim',
        \ 'https://gist.githubusercontent.com/romainl/eae0a260ab9c135390c30cd370c20cd7/raw/407b5abf42a64cef1749f8b73bbe4572868eaa65/redir.vim')

    call minpac#add('AndrewRadev/tagalong.vim')
    if has("nvim") || has("lua") || has("patch-8.2.1908")
        \ || match(execute("version"), "+lua/dyn") ==# -1
        call minpac#add('axelf4/vim-strip-trailing-whitespace')
    endif
    call minpac#add('embear/vim-localvimrc')
    call minpac#add('honza/vim-snippets')
    call minpac#add('itchyny/lightline.vim')
    call minpac#add('jototland/bdelete_not_close.vim')
    call minpac#add('jototland/filterops.vim')
    call minpac#add('jototland/trivial-text-objects.vim')
    if executable('fzf')
        call minpac#add('junegunn/fzf')
        call minpac#add('junegunn/fzf.vim')
    endif
    call minpac#add('Lenovsky/nuake')
    call s:xkbswitchSettings("install")
    if ((has("win32") || has("win64")) && filereadable(g:XkbSwitchLib))
        \ || (exists("$DISPLAY") && executable("xkb-switch"))
        call minpac#add('lyokha/vim-xkbswitch')
    endif
    call minpac#add('mattn/emmet-vim')
    call minpac#add('mbbill/undotree')
    call minpac#add('michaeljsmith/vim-indent-object')
    if executable('node') && (!has("win32") || has("nvim") || has("gui_running"))
        call minpac#add('neoclide/coc.nvim', {'branch': 'release'})
    endif
    call minpac#add('neoclide/jsonc.vim')
    call minpac#add('sgur/vim-editorconfig')
    call minpac#add('sheerun/vim-polyglot')
    if has("python3")
        call minpac#add('SirVer/ultisnips')
    endif
    call minpac#add('tpope/vim-commentary')
    call minpac#add('tpope/vim-eunuch')
    call minpac#add('tpope/vim-repeat')
    call minpac#add('tpope/vim-rsi')
    call minpac#add('tpope/vim-scriptease')
    call minpac#add('tpope/vim-sleuth')
    call minpac#add('tpope/vim-surround')
    call minpac#add('tpope/vim-unimpaired')
    if has("python3")
        call minpac#add('Valloric/MatchTagAlways')
    endif
    if executable("vifm")
        call minpac#add('vifm/vifm.vim')
    endif
    call minpac#add('wincent/terminus')
    call minpac#add('Yggdroot/indentLine')

endfunction

command! PackUpdate source $MYVIMRC | call PackInit() | call minpac#update()
command! PackClean  source $MYVIMRC | call PackInit() | call minpac#clean()
command! PackStatus source $MYVIMRC | call PackInit() | call minpac#status()
