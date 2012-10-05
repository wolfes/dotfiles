set nocompatible

" ---------- plugins ---------

call pathogen#infect()

" Syntastic
let g:syntastic_auto_loc_list=1

" Tagbar
let g:tagbar_sort = 0
let g:tagbar_compact = 1
let g:tagbar_autofocus = 1

" Ropevim
if(filereadable(expand('~/.vim/plugin/ropevim.vim')))
	let ropevim_vim_completion=1 "Replace vim's complete function with ropevim
	let ropevim_extended_complete=1
endif

" Command-T
let g:CommandTMaxFiles=999999

" ---------- settings ---------

let mapleader = ","
set mouse=a

" Filetype highlighting
filetype plugin indent on
syntax on

" Show what you are typing mid-command
set showcmd

" Indentation/tabs
set autoindent
set noexpandtab " in python, use real tabs

" 4 spaces by default
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Except HTML - 2 spaces
autocmd BufWinEnter *.html setlocal tabstop=2
autocmd BufWinEnter *.html setlocal expandtab
autocmd BufWinEnter *.html setlocal shiftwidth=2
autocmd BufWinEnter *.html setlocal expandtab

" highlight trailing whitespace and non-tab indents
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter *.* match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Color scheme and font
colorscheme xoria256
set guifont=Monaco:h12

" Highlight current line
set cursorline

" Statusline
set laststatus=2 " Show statusline even when there is a single window
set statusline=%F%m%r%h%w%{fugitive#statusline()}
set statusline+=[%l,%v][%p%%]

" Maintain more text around the cursor
set scrolloff=3

" Show line numbers
set number

" More intelligent backspace and left/right movement
set backspace=eol,start,indent
set whichwrap=b,s,h,l,<,>,[,]

" Hidden buffer support
set hidden

" Disable annoying messages, swap file already exists
set autoread
set shortmess+=IA

" Longer history
set history=1000

" Case-smart searching (case-sensitive only if capital letter in search)
set ignorecase
set smartcase

" Incremental search
set incsearch

" Tab completion
set wildmode=longest,list
set wildignore=*.pyc

" Visual bell instead of beep
set visualbell

" keep backups and temp files in ~.vim/
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

" set default split opening position to be below and to the right of currently active split
set splitbelow
set splitright

" Tags - recursively check parent directories for tags file
set tags+=./.tags,.tags,../.tags,../../.tags

" Filetypes
autocmd BufEnter *.mako setlocal filetype=html

" ---------- mappings ---------

" Typos and things I don't want to do
nmap Q <ESC>
nmap :Q :q
nmap :W :w
nmap :WQ :wq

" Windows
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

" Function key shortcuts
map <F1> <nop>
map <F3> :set hlsearch! hlsearch?<CR>
map <F6> :NERDTreeClose<CR>
map <F7> :NERDTreeFind<CR> "TODO combine with F6 to make toggle
map <F8> :TagbarToggle<cr>
map <F9> :!/usr/bin/ctags -L <(find . -name '*.py') --fields=+iaS --python-kinds=-i --sort=yes --extra=+q<cr>

" Leader shortcuts
map <Leader>v :tabe ~/.vimrc<CR>
map <Leader>e :tabe 
map <Leader>E :e <C-R>=expand('%:p:h') . '/'<CR>
" open current buffer in new tab
map <Leader>s :tab split<CR>
map <Leader>n :tabnew<CR>
map <Leader>Q :tabc<CR>
map <Leader>m :tabm
map <Leader>w :w<CR>
map <Leader>q :q<CR>
map <Leader>l :lclose<CR>
map <Leader>L :lopen<CR>
map <Leader>c :copen<CR>
map <Leader>C :cclose<CR>
map <Leader>z :cp<CR>
map <Leader>x :cn<CR>
" git diff in new tab
map <Leader>f :tab split<CR>:Gdiff canon/master<CR>
map <Leader>g :tab split<CR>:Ggrep 
" commit log for current file
map <Leader>o :Glog -- %<CR>:copen<CR>
map <Leader>i Oimport pdb; pdb.set_trace()<ESC>
map <Leader>I Oimport pudb; pudb.set_trace()<ESC>
" these are already set by Command-T, but let's be explicit
map <Leader>t :CommandT<CR>
map <Leader>b :CommandTBuffer<CR>

" ---------- yelp stuff ---------

if(match(hostname(), 'dev20') >= 0)
	map <Leader>r :!cd ~/pg/yelp-main/templates && make && cd ~/pg/yelp-main/mobile_templates && make -f ../templates/Makefile<CR>
	set wildignore+=build/**,templates/*.py*,mobile_templates/*.py*,biz_templates/*.py*,admin_templates/*.py*,lite_templates/*.py*
	autocmd BufEnter *.css.tmpl setlocal filetype=css
	autocmd BufEnter *.js.tmpl setlocal filetype=javascript
endif
