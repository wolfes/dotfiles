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


" User Defined Function

function! UserDefined()
	"wa
	silent! exec "r!ping -c 1 www.google.com"
	u
endfunction



" Vim comments start with a double quote.
" Function definition is VimL. We can mix VimL and Python in
" function definition.
function! OpenTabByName(name)
:	call UserDefined()

" We start the python code like the next line.

python << EOF
# the vim module contains everything we need to interface with vim from
# python. We need urllib2 for the web service consumer.
import vim, urllib, urllib2
# we need json for parsing the response
import json

# we define a timeout that we'll use in the API call. We don't want
# users to wait much.
TIMEOUT = 20
#URL = "http://localhost:3000/api/0/tabspire/thespicemustflow/openTabByName"
URL = "http://192.155.82.253:3000/api/0/tabspire/thespicemustflow/openTabByName"

try:
	# Get the posts and parse the json response
	#response = urllib2.urlopen(URL, None, TIMEOUT).read()
	#json_response = json.loads(response)

	post_params = {
		'tabName' : vim.eval('a:name')
	}
	params = urllib.urlencode(post_params)
	response = urllib2.urlopen(URL, params)
	#json_response = json.loads(response.read())

	# posts = json_response.get("data", "").get("children", "")

    # vim.current.buffer is the current buffer. It's list-like object.
    # each line is an item in the list. We can loop through them delete
    # them, alter them etc.
    # Here we delete all lines in the current buffer
	#del vim.current.buffer[:]
    # Here we append some lines above. Aesthetics.
	#vim.current.buffer[0] = 80*"-"
	#	vim.current.buffer.append(response)

except Exception, e:
    print e

EOF
" Here the python code is closed. We can continue writing VimL or python again.
endfunction

command! -nargs=* OpenTabByName call OpenTabByName ( '<args>' )
map <Leader>m :OpenTabByName
"command C -nargs=* call F ( <f-args> )



" ====================================================================
let &cpo= s:keepcpo
unlet s:keepcpo
