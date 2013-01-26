" VIMRC - Vim Customizations.
" Many thanks to: mwilson and Buck.

set nocompatible

" ---------- plugins ---------

call pathogen#infect()

" Syntastic
let g:syntastic_auto_loc_list=1
let g:syntastic_auto_jump=1

" Tagbar
let g:tagbar_width = 60
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

if filereadable($HOME . "/.vimrc.extra")
    source $HOME/.vimrc.extra
endif

if filereadable($HOME . "/.vimrc.private")
    source $HOME/.vimrc.private
endif

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

" Fold Settings
set foldmethod=indent
set foldnestmax=1

augroup foldtype
  autocmd BufReadPre * setlocal foldmethod=marker
  autocmd BufReadPre * setlocal foldmethod=indent
  "Set foldnestmax to 2 to fold classes and their functions in python.
  autocmd BufReadPre *.py setlocal foldnestmax=2
augroup END

" Except HTML - 2 spaces
augroup htmlLocal
	autocmd BufWinEnter *.html setlocal tabstop=2
	autocmd BufWinEnter *.html setlocal expandtab
	autocmd BufWinEnter *.html setlocal shiftwidth=2
augroup END

" highlight trailing whitespace and non-tab indents
augroup highlights
	autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
	autocmd BufWinEnter *.* match ExtraWhitespace /\s\+$/
	autocmd BufWinLeave * call clearmatches()
augroup END

" Except JS - 2 spaces
augroup jsLocal
	autocmd BufWinEnter *.js setlocal expandtab
augroup END

" Highlight trailing whitespace and non-tab indents.
augroup highlights
	autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
	autocmd BufWinEnter *.* match ExtraWhitespace /\s\+$/
	autocmd BufWinLeave * call clearmatches()
augroup END

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
augroup makoLocal
	autocmd BufEnter *.mako setlocal filetype=html
augroup END

" ---------- mappings ---------

nnoremap - ddp
nnoremap _ ddkP
nnoremap <Space> i_<Esc>r

" Source .vimrc / .bash_profile
nnoremap <Leader>sv :so $MYVIMRC<CR>
nnoremap <Leader>sp :execute ":!source " . expand("~/.bash_profile")<CR><CR>

" Typos and things I don't want to do
nnoremap Q <ESC>
nnoremap :Q :q
nnoremap :W :w
nnoremap :WQ :wq

" Windows
noremap <C-J> <C-W>j
noremap <C-K> <C-W>k
noremap <C-H> <C-W>h
noremap <C-L> <C-W>l

" Function key shortcuts
noremap <F1> <nop>
noremap <F3> :set hlsearch! hlsearch?<CR>
noremap <F6> :NERDTreeClose<CR>
noremap <F7> :NERDTreeFind<CR> "TODO combine with F6 to make toggle
noremap <F8> :TagbarToggle<cr>
noremap <F9> :!/usr/bin/ctags -L <(find . -name '*.py') --fields=+iaS --python-kinds=-i --sort=yes --extra=+q<cr>

" Double Shortcuts
noremap tt :TagbarToggle<cr>
" Vertical Split Window
noremap <silent> vv <C-w>v

" Leader shortcuts

" Fast Tab Switching!
noremap <Leader>1 :tabnext 1<CR>
noremap <Leader>2 :tabnext 2<CR>
noremap <Leader>3 :tabnext 3<CR>
noremap <Leader>4 :tabnext 4<CR>
noremap <Leader>5 :tabnext 5<CR>
noremap <Leader>6 :tabnext 6<CR>
noremap <Leader>7 :tabnext 7<CR>
noremap <Leader>8 :tabnext 8<CR>
noremap <Leader>9 :tabnext 9<CR>

" Quickly Open Vim, Bash/Tmux Settings!
noremap <Leader>v :tabe ~/.vimrc<CR>
noremap <Leader>V :tabe ~/.bash_profile<CR><Bar>:tabe ~/.tmux.conf<CR>

noremap <Leader>e :tabe
noremap <Leader>E :e <C-R>=expand('%:p:h') . '/'<CR>
" Open current buffer in new tab.
noremap <Leader>s :tab split<CR>
noremap <Leader>n :tabnew<CR>
noremap <Leader>Q :tabc<CR>
noremap <Leader>m :tabm
noremap <Leader>w :w<CR>
noremap <Leader>q :q<CR>
noremap <Leader>l :lclose<CR>
noremap <Leader>L :lopen<CR>
noremap <Leader>c :copen<CR>
noremap <Leader>C :cclose<CR>
noremap <Leader>z :cp<CR>
noremap <Leader>x :cn<CR>
" Git diff in new tab.
noremap <Leader>f :tab split<CR>:Gdiff canon/master<CR>
noremap <Leader>g :tab split<CR>:Ggrep
" Commit log for current file.
noremap <Leader>o :Glog -- %<CR>:copen<CR>
noremap <Leader>i Oimport ipdb; ipdb.set_trace()<ESC>
noremap <Leader>I Oimport pudb; pudb.set_trace()<ESC>
" Open CommandT in new tab.
noremap <Leader>T :tabnew<CR>:CommandT<CR>
" Already set by Command-T, but let's be explicit.
noremap <Leader>t :CommandT<CR>
noremap <Leader>b :CommandTBuffer<CR>

" Search Improvements
noremap <Leader>y :let @/=expand("<cword>")<Bar>normal n<CR>
noremap <Leader>Y :let @/=expand("<cword>")<Bar>split<Bar>normal n<CR>

" Fold commands are usually z{char}, fixed!
nnoremap z[ [z
nnoremap z] ]z

" Improved [I  -- Asks for line number of match to jump to.
nnoremap <silent> [I [I:let nr = input("Item: ")<Bar>if nr != ''<Bar>exe "normal " . nr ."[\t"<Bar>endif<CR>

" ---------- yelp stuff ---------

if(match(hostname(), 'dev26') >= 0)
	" Yelping in the desert.
	colorscheme desert

	set wildignore+=build/**,templates/*.py*,mobile_templates/*.py*,biz_templates/*.py*,admin_templates/*.py*,lite_templates/*.py*
	autocmd BufEnter *.css.tmpl setlocal filetype=css
	autocmd BufEnter *.js.tmpl setlocal filetype=javascript

	noremap <Leader>m :!tools/db

	" Wafit - Save, Waf, Reload Browser Tab.
	noremap <Leader>r :write <Bar> !wafit<CR><CR>
endif