let $PATH = "~/.pyenv/shims:".$PATH

let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" fetch dein.vim if not found
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let g:rc_dir    = expand('~/.vim')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " load and cache
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

if has('vim_starting')
  set encoding=utf-8
  scriptencoding utf-8

  if !has('gui_running')
        \ && exists('&termguicolors')
        \ && $COLORTERM ==# 'truecolor'
    if !has('nvim')
      let &t_8f = "\e[38;2;%lu;%lu;%lum"
      let &t_8b = "\e[48;2;%lu;%lu;%lum"
    endif
    set termguicolors       " use truecolor in term
  endif
endif

if &compatible
  set nocompatible
endif

inoremap <silent> jj <ESC>

nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk

nnoremap gj j
nnoremap gk k

nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sn gt
nnoremap sp gT
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sw <C-w>w
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap sT :<C-u>Unite tab<CR>
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>
nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>

nnoremap Y y$

nnoremap + <C-a>
nnoremap - <C-x>

vnoremap gy :w !pbcopy<CR><CR>
nnoremap gp :r !pbpaste<CR><CR>

nnoremap [q :cprevious<CR>   " 前へ
nnoremap ]q :cnext<CR>       " 次へ
nnoremap [Q :<C-u>cfirst<CR> " 最初へ
nnoremap ]Q :<C-u>clast<CR>  " 最後へ

nnoremap qn :CoqNext<CR>
nnoremap qp :CoqUndo<CR>
nnoremap qc :CoqToCursor<CR>

autocmd FileType coq setlocal commentstring=(*\ %s\ *)

nnoremap tr :NERDTree<CR>
let NERDTreeShowHidden=1

call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')

syntax on
filetype indent plugin on

autocmd FileType vue syntax sync fromstart

set number
set display=lastline

set cursorline
hi CursorLine cterm=bold ctermbg=darkblue ctermfg=white

set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

set wrapscan
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>

set showmatch
set matchtime=1

set backupcopy=yes

set background=dark

set shell=/bin/bash\ -i

if has('win32') || has('win64') || has('mac')
  set clipboard=unnamed
else
  set clipboard=unnamed,unnamedplus
endif

set secure
