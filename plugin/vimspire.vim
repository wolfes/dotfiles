"=====================================================================
" File:        vimspire.vim
" Description: Connect vim with tabspire.
" Author:      Wolfe Styke <vimspire@gmail.com>
" Licence:     ???
" Website:     http://wolfes.github.com/vimspire/
" Version:     0.0.0
" Note:        Connect all the things!
"
" Original taglist copyright notice:
"              Permission is hereby granted to use and distribute this code,
"              with or without modifications, provided that this copyright
"              notice is copied with it. Like anything else that's free,
"              vimspire.vim is provided *as is* and comes with no warranty of
"              any kind, either expressed or implied. In no event will the
"              copyright holder be liable for any damamges resulting from the
"              use of this software.
" ====================================================================

scriptencoding utf-8

" Exit when your app has already been loaded (or "compatible" mode set)
if exists("g:loaded_vimspire") || &cp
  finish
endif

" Set version number
let g:loaded_vimspire = 1
let s:keepcpo = &cpo
set cpo&vim



if !exists('g:vimspire_map_keys')
    let g:vimspire_map_keys = 1
endif

if g:vimspire_map_keys
	nnoremap <leader>d :call <sid>vimspireDelete()<CR>
endif


if !exists('g:vimspire_map_prefix')
    let g:vimspire_map_prefix = '<leader>'
endif

execute "nnoremap"  g:vimspire_map_prefix."d"  ":call <sid>vimspireDelete()<CR>"



" Features (Idea List)
"
" Reload tab:
" - by name.
" - Set default tab name to reload when
"    saving (performing 'save/waf' cmd) for this file.
"


" User Defined Function for saving all tabs
" and rebuilding templates, etc...
function! SaveAndRebuild()
	wa
	" Replace with build templates script.
	silent! exec "r!ping -c 1 www.google.com"
	u
endfunction


function! OpenTabByName(name)
" Sends request to nspire.it to ask the user's
" chrome extension to open a tab by the specified name.
" Saves tabs and rebuilds anything user specifies first.

:	call SaveAndRebuild()

python << EOF
import json, urllib, urllib2, vim

TIMEOUT = 20
CLIENT_ID = "PUT_YOUR_TABSPIRE_CLIENT_ID_HERE" # No '/' allowed.
BASE_URL = "http://cmdsync.com:3000/api/0/"
TABSPIRE_OPEN_URL = "tabspire/" + CLIENT_ID + "/openTabByName"

try:
	# Get the posts and parse the json response
	post_params = {
		'tabName' : vim.eval('a:name')
	}
	params = urllib.urlencode(post_params)
	response = urllib2.urlopen(BASE_URL + TABSPIRE_OPEN_URL, params)
	#json_response = json.loads(response.read())
	# posts = json_response.get("data", "").get("children", "")
	# vim.current.buffer.append(response)

except Exception, e:
    print e

EOF
endfunction

" Create command OpenTabByName that accepts arguments.
command! -nargs=* OpenTabByName call OpenTabByName ( '<args>' )
" TODO(wstyke:11-25-2012) Move this to let the user
" create in user-defined .vimrc file.
noremap <Leader>m :OpenTabByName 


" ====================================================================
let &cpo= s:keepcpo
unlet s:keepcpo
