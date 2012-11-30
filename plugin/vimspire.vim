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
	" Let vimspire map commands to keys with noremap.
	let g:vimspire_map_keys = 1
endif


if !exists("g:tabspire_client_id")
	" Your tabspire client id, which you set from tabspire.
    let g:tabspire_client_id = "PUT_YOUR_TABSPIRE_CLIENT_ID_HERE"
endif

if !exists("g:cmdsync_url")
	" The server to use to sync commands to Tabspire.
	let g:cmdsync_url = "http://cmdsync.com:3000/api/0/"
	"let g:cmdsync_url = "http://localhost:3000/api/0/"
endif

if !exists('g:vimspire_map_prefix')
	" Unused, example of how to map commands to plugin-prefix.
    let g:vimspire_map_prefix = '<Leader>'
endif
" execute "nnoremap"  g:vimspire_map_prefix."d"  ":call <sid>vimspireDelete()<CR>"

" Features (Idea List)
"
" Reload tab:
" - by name.
" - Set default tab name to reload when
"    saving (performing 'save/waf' cmd) for this file.

function! SaveAndRebuild()
	wa
	" Replace with build templates script.
	" silent! exec "r!ping -c 1 www.google.com"
	" u
endfunction

function! OpenTabByName(name)
" Sends request to nspire.it to ask the user's
" chrome extension to open a tab by the specified name.
" Saves tabs and rebuilds anything user specifies first.

:	call SaveAndRebuild()

python << EOF
import urllib, urllib2, vim

request_url = (vim.eval('g:cmdsync_url') + "tabspire/" +
		vim.eval('g:tabspire_client_id') + "/openTabByName")

try:
	params = urllib.urlencode({
		'tabName' : vim.eval('a:name')
	})
	response = urllib2.urlopen(request_url, params)

except Exception, e:
    print e

EOF
endfunction

function! OpenGoogleSearch(query)
" Sends request to tabspire thru cmdSync
" to open a google search for the query.

python << EOF
import urllib, urllib2, vim
request_url = (vim.eval('g:cmdsync_url') + "tabspire/" +
		vim.eval('g:tabspire_client_id') + "/openGoogleSearch")
try:
	params = urllib.urlencode({
		'query' : vim.eval('a:query')
	})
	response = urllib2.urlopen(request_url, params)
except Exception, e:
    print e
EOF
endfunction

function! OpenURL(url)
" Sends request to Tabspire thru cmdSync
" to open a url in a new tab.

:	call SaveAndRebuild()

python << EOF
import urllib, urllib2, vim
request_url = (vim.eval('g:cmdsync_url') + "tabspire/" +
		vim.eval('g:tabspire_client_id') + "/openURL")
try:
	params = urllib.urlencode({
		'url' : vim.eval('a:url')
	})
	resp_loc = urllib2.urlopen(request_url, params)
except Exception, e:
    print e
EOF
endfunction


function! OpenSelectedURL()
" Sends req to Tabspire thru cmdSync
" to open the current buffer's selected line as a url.

python << EOF
import urllib, urllib2, vim
request_url = (vim.eval('g:cmdsync_url') + "tabspire/" +
		vim.eval('g:tabspire_client_id') + "/openURL")
try:
	params = urllib.urlencode({
		'url' : vim.current.line
	})
	resp_cmd = urllib2.urlopen(request_url, params)
except Exception, e:
    print e
EOF
endfunction


function! OpenPB() range
" Sends req to Tabspire thru cmdSync
" to open the current buffer's selected line as a url.

:'<,'> !pb

python << EOF
import urllib, urllib2, vim
request_url = (vim.eval('g:cmdsync_url') + "tabspire/" +
		vim.eval('g:tabspire_client_id') + "/openURL")
try:
	params = urllib.urlencode({
		'url' : vim.current.line
	})
	resp_cmd = urllib2.urlopen(request_url, params)
except Exception, e:
    print e
EOF
" Undo pastebin insertion of url.
:	normal! u
endfunction


" Create command OpenTabByName: exactly 1 tabname.
command! -nargs=1 OpenTabByName call OpenTabByName ( '<args>' )

" Create command OpenGoogleSearch: 1+ search terms.
command! -nargs=+ OpenGoogleSearch call OpenGoogleSearch ( '<args>' )

" Create command OpenURL: exactly 1 url.
command! -nargs=1 OpenURL call OpenURL ( '<args>' )

" Create command OpenSelectedURL: no args.
command! -nargs=0 OpenSelectedURL call OpenSelectedURL ( )

" Create command OpenPB: no args.
"command! OpenPB call OpenPB ( )

if g:vimspire_map_keys
	nnoremap <leader>d :call <sid>vimspireDelete()<CR>

	noremap <Leader>m :OpenTabByName 
	noremap <Leader>k :OpenGoogleSearch 
	noremap <Leader>u :OpenURL 
	noremap <Leader>U :OpenSelectedURL<CR>
	vnoremap <Leader>p :call OpenPB()<CR>

endif


" ====================================================================
let &cpo= s:keepcpo
unlet s:keepcpo
