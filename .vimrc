" VIMRC - Vim Customizations.
" Many thanks to: mwilson and Buck.

set nocompatible

augroup SourceOnSave
	autocmd!
	" Auto-Reload vimrc on save.
	autocmd BufWritePost .vimrc source %
	autocmd BufWritePost .bash_profile :execute "!source %"
	autocmd BufWritePost .bashrc :execute "!source %"
augroup END


" ---- Plugin Setup ----

call pathogen#infect()

" Vim-Powerline
set rtp+=expand('~/.vim/bundle/powerline/powerline/bindings/vim')
let g:Powerline_symbols = 'fancy'

" Snipmate v2.0
" Snipmate Options

" Syntastic
let g:syntastic_auto_loc_list=1
let g:syntastic_auto_jump=1

" Tagbar
let g:tagbar_width = 80
let g:tagbar_sort = 0
let g:tagbar_compact = 1
let g:tagbar_autofocus = 1

" Ropevim
if(filereadable(expand('~/.vim/plugin/ropevim.vim')))
	"Replace vim's complete function with ropevim
	let ropevim_vim_completion=1 
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

let $XIKI_DIR = "/Library/Ruby/Gems/1.8/gems/xiki-0.6.5/etc/vim"
if filereadable($XIKI_DIR . "/etc/vim/xiki.vim")
	source $XIKI_DIR/etc/vim/xiki.vim
endif

" ---- Color Customization ----

" Color scheme and font
colorscheme xoria256
colorscheme desert
set guifont=Monaco:h12

augroup highlights
	" Highlight trailing whitespace and non-tab indents.
	autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
	autocmd BufWinEnter *.* match ExtraWhitespace /\s\+$/
	autocmd BufWinLeave * call clearmatches()
augroup END


" ---- Settings: MISC ---

let mapleader = ","	" The <Leader> binding.
set mouse=a			" Enabled for all modes.
"
" Filetype Highlighting.
filetype plugin indent on
syntax on

highlight LineNr	ctermfg=darkgrey guifg=darkgrey
highlight OverLength ctermbg=black ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

set showcmd			" Show (partial) cmd in last line of screen.
set autoindent		" Copy indent from curr line when creating new line.

" Tab => 4 spaces by default.
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab

" Fold Settings
set foldnestmax=1

augroup foldtype
  "foldnestmax=(Py:2, JS:1).
  autocmd BufReadPre *.py setlocal foldnestmax=2
  autocmd BufReadPre *.js setlocal foldnestmax=1
  autocmd BufReadPre *.tmpl setlocal foldnestmax=1
  " Fold markers, then use indent folding.
  autocmd BufReadPre * setlocal foldmethod=marker
  autocmd BufReadPre * setlocal foldmethod=indent
augroup END

augroup makoLocal
	autocmd BufEnter *.mako setlocal filetype=html
augroup END

set cursorline		" Highlight current line
set number			" Show line numbers.
set scrolloff=3		" Show 3 lines above/below cursor, ie: zt & zb.

set laststatus=2 " Show statusline even when there is a single window
set statusline=%F%m%r%h%w%{fugitive#statusline()}
set statusline+=[%l,%v][%p%%]

" More intelligent backspace and left/right movement
set backspace=eol,start,indent
set whichwrap=b,s,h,l,<,>,[,]

set hidden			" Hidden buffer support.

set autoread		" Auto Read changes to file outside Vim.
set shortmess+=IA	" Disable some messages.

set history=1000	" Longer command history.

set ignorecase		" Search ignores case,
set smartcase		" unless search terms contains capitals.
set incsearch		" Incremental search

" Tab completion
set wildmode=longest,list
set wildignore=*.pyc

set visualbell		" Visual Bell instead of beep.

set backup			" Keep backups/temp files.
set backupdir=~/.vim/backup

set splitbelow " Default split opens below & right of active split.
set splitright

" Tags - recursively check parent directories for tags file
set tags+=./.tags,.tags,../.tags,../../.tags


" ---- Settings: Speed Hacks ----

" noesckeys makes all <ESC> prefixed keys fail in insert mode,
" which is a good thing for arrow keys, but not sure about other effects.
"set noesckeys
"set ttimeout
set ttimeoutlen=1		" Make ESC finish fast.


" ---- Defaults: Macros ----

" NOTE: Filetype specific macros defined in ftplugin/filetypeNAME.vim


" ---- Mappings: Tab Management ----

" Merge a tab into a split in the previous window.
function! MergeTabs()
	if tabpagenr() == 1
		return
	endif
	let bufferName = bufname("%")
	if tabpagenr("$") == tabpagenr()
		close!
	else
		close!
		tabprev
	endif
	split
	execute "buffer " . bufferName
endfunction

function! ExtractBuffer()
	let bufferName = bufname("%")
	close!
	tabnew
	execute "buffer " . bufferName
endfunction

function! CloneBuffer()
	let bufferName = bufname("%")
	tabnew
	execute "buffer " . bufferName
endfunction

nnoremap <C-W>m :call MergeTabs()<CR>
nnoremap <C-W>e :call ExtractBuffer()<CR>
nnoremap <C-W>c :call CloneBuffer()<CR>

" ---- Mappings: Split Management ----

"function! MarkWindowSwap()
"    let g:markedWinNum = winnr()
"endfunction
"
"function! DoWindowSwap()
"	"Mark destination
"	let curNum = winnr()
"	let curBuf = bufnr( "%" )
"	exe g:markedWinNum . "wincmd w"
"	"Switch to source and shuffle dest->source
"	let markedBuf = bufnr( "%" )
"	"Hide and open so that we aren't prompted and keep history
"	exe 'hide buf' curBuf
"	"Switch to dest and shuffle source->dest
"	exe curNum . "wincmd w"
"	"Hide and open so that we aren't prompted and keep history
"	exe 'hide buf' markedBuf
"endfunction
"
"" Mark window to move (source), then mark window to swap (destination).
"nnoremap <Leader>ms :call MarkWindowSwap()<CR>
"nnoremap <Leader>md :call DoWindowSwap()<CR>

function! MarkWindowSwap()
	" marked window number
	let g:markedWinNum = winnr()
	let g:markedBufNum = bufnr("%")
endfunction

function! DoWindowSwap()
	let curWinNum = winnr()
	let curBufNum = bufnr("%")
	" Switch focus to marked window
	exe g:markedWinNum . "wincmd w"

	" Load current buffer on marked window
	exe 'hide buf' curBufNum

	" Switch focus to current window
	exe curWinNum . "wincmd w"

	" Load marked buffer on
	" current window
	exe 'hide buf' g:markedBufNum
endfunction

nnoremap H :call MarkWindowSwap()<CR><C-w>h :call DoWindowSwap()<CR>
nnoremap J :call MarkWindowSwap()<CR><C-w>j :call DoWindowSwap()<CR>
nnoremap K :call MarkWindowSwap()<CR><C-w>k :call DoWindowSwap()<CR>
nnoremap L :call MarkWindowSwap()<CR><C-w>l :call DoWindowSwap()<CR>


" ---- Mappings: Tabs ----

" Fast Tab Switching.
noremap <Leader>[ :tabprev<CR>
noremap <Leader>] :tabnext<CR>
noremap <Leader>1 :tabnext 1<CR>
noremap <Leader>2 :tabnext 2<CR>
noremap <Leader>3 :tabnext 3<CR>
noremap <Leader>4 :tabnext 4<CR>
noremap <Leader>5 :tabnext 5<CR>
noremap <Leader>6 :tabnext 6<CR>
noremap <Leader>7 :tabnext 7<CR>
noremap <Leader>8 :tabnext 8<CR>
noremap <Leader>9 :tabnext 9<CR>
noremap <Leader><Leader>1 :tabnext 10<CR>
noremap <Leader><Leader>2 :tabnext 11<CR>
noremap <Leader><Leader>3 :tabnext 12<CR>
noremap <Leader><Leader>4 :tabnext 13<CR>
noremap <Leader><Leader>5 :tabnext 14<CR>
noremap <Leader><Leader>6 :tabnext 15<CR>
noremap <Leader><Leader>7 :tabnext 16<CR>
noremap <Leader><Leader>8 :tabnext 17<CR>
noremap <Leader><Leader>9 :tabnext 18<CR>

" Open CommandT in new tab / split / vsplit.
noremap <Leader>T :tabnew<CR>:CommandT<CR>
noremap <Leader>ts :split<CR>:CommandT<CR>
noremap <Leader>tv :vsplit<CR>:CommandT<CR>

" Already set by Command-T, but let's be explicit.
noremap <Leader>t :CommandT<CR>
noremap <Leader>b :CommandTBuffer<CR>

" Open New Tab / with filename... / with filename under cursor.
noremap <Leader>n :tabnew<CR>
noremap <Leader>e :tabe
noremap <Leader>E :tabe <cWORD><CR>
""" noremap <Leader>E :e <C-R>=expand('%:p:h') . '/'<CR>

" Open current buffer in new tab.
noremap <Leader>s :tab split<CR>
noremap <Leader>Q :tabc<CR>

" Move tab to index...
noremap <Leader>m :tabm


" ---- Mappings: Open Specific Files ----

" Quickly Open Vim, Bash/Tmux Settings!
noremap <Leader>v :tabe ~/.vimrc<CR>
noremap <Leader>V :tabe ~/.bash_profile<CR><Bar>:tabe ~/.tmux.conf<CR>

noremap <Leader>c :tabe ~/.vim/custom/snippets/javascript.snippets<CR>


" ---- Mappings: Plug-Ins ----

" Double Shortcuts
noremap tt :TagbarToggle<cr>


" ---- Mappings: MISC ----

inoremap <C-j> <ESC>

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

" Vertical Split Window
noremap <silent> vv <C-w>v

" Yank File Path of Current Buffer.
noremap <Leader>P :let @" = expand("%")<CR>

noremap <Leader>w :w<CR>
noremap <Leader>q :q<CR>

"noremap <Leader>l :lclose<CR>
"noremap <Leader>L :lopen<CR>
"noremap <Leader>c :copen<CR>
"noremap <Leader>C :cclose<CR>
"noremap <Leader>z :cp<CR>
"noremap <Leader>x :cn<CR>

" Git diff in new tab.
"noremap <Leader>f :tab split<CR>:Gdiff canon/master<CR>
noremap <Leader>g :tab split<CR>:Ggrep
" Commit log for current file.
noremap <Leader>o :Glog -- %<CR>:copen<CR>
noremap <Leader>i Oimport ipdb; ipdb.set_trace()<ESC>
noremap <Leader>I Oimport pudb; pudb.set_trace()<ESC>

" Search Improvements
noremap <Leader>y :let @/=expand("<cword>")<Bar>normal n<CR>
noremap <Leader>Y :let @/=expand("<cword>")<Bar>split<Bar>normal n<CR>

" Fold commands are usually z{char}, fixed!
nnoremap z[ [z
nnoremap z] ]z

" Improved [I  -- Asks for line number of match to jump to.
nnoremap <silent> [I [I:let nr = input("Item: ")<Bar>if nr != ''<Bar>exe "normal " . nr ."[\t"<Bar>endif<CR>


" ---------- Markdown -----------

noremap <Leader><Leader>m :!pandoc -s -S --toc README.md -c http://localhost/md6.css -o README.html && open README.html<CR><CR>
noremap <Leader><Leader>m :!pandoc -s -S --toc README.md -c http://localhost/swiss.css -o README.html && open README.html<CR><CR>

" ---------- yelp stuff ---------

if(match(hostname(), 'dev26') >= 0)
	" Yelping in the desert!
	colorscheme desert

	" TF / PF for cWORD.
	nnoremap <Leader>f :execute "!tf " . expand('<cword>') <cr>
	nnoremap <Leader>F :execute "!pf " . expand('<cword>') <cr>

	" Wafit - Save, Waf, Reload Browser Tab.
	noremap <Leader>r :write <Bar> !wafit<CR><CR>


	set wildignore+=build/**,templates/*.py*,mobile_templates/*.py*,biz_templates/*.py*,admin_templates/*.py*,lite_templates/*.py*
	augroup jsLocal
		" JS - 4 spaces at Yelp.
		autocmd BufWinEnter *.js setlocal noexpandtab
		autocmd BufWinEnter *.js setlocal tabstop=4
		autocmd BufWinEnter *.js setlocal softtabstop=4
		autocmd BufWinEnter *.js setlocal shiftwidth=4
	augroup END
	augroup templateType
		autocmd BufEnter *.css.tmpl setlocal filetype=css
		autocmd BufEnter *.js.tmpl setlocal filetype=javascript
		autocmd BufEnter *.py setlocal filetype=python
	augroup END

	" Use Tabs @ Yelp :(
	set noexpandtab
	set tabstop=4
	set softtabstop=4
	set shiftwidth=4

endif

if(match(hostname(), 'dev26') == -1)
	" Not @ Yelp

	" FILETYPE Autocmds
	augroup htmlLocal
		" HTML - 2 spaces
		autocmd BufWinEnter *.html setlocal tabstop=2
		autocmd BufWinEnter *.html setlocal expandtab
		autocmd BufWinEnter *.html setlocal shiftwidth=2
	augroup END
	augroup jsLocal
		" JS - 2 spaces
		autocmd BufWinEnter *.js setlocal expandtab
		autocmd BufWinEnter *.js setlocal tabstop=2
		autocmd BufWinEnter *.js setlocal softtabstop=2
		autocmd BufWinEnter *.js setlocal shiftwidth=2
	augroup END

endif
