" File: grep.vim
" Author: Yegappan Lakshmanan  (yegappan AT yahoo DOT com), Lucía Andrea Illanes Albornoz  (lucia AT luciaillanes DOT de)
" Version: 3.11 for Workgroups
" Last Modified: March 6, 2023
" 
" Plugin to integrate grep like utilities with Vim
" Supported utilities are: grep, fgrep, egrep, agrep, findstr, ag, ack,
" ripgrep, git grep, sift, platinum searcher and universal code grep
"
" License: MIT License
" Copyright (c) 2023 Lucía Andrea Illanes Albornoz
" Copyright (c) 2002-2018 Yegappan Lakshmanan
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to
" deal in the Software without restriction, including without limitation the
" rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
" sell copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
" FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
" IN THE SOFTWARE.
" =======================================================================
if exists("loaded_grep")
    finish
endif
let loaded_grep = 1

if v:version < 700
    " Needs vim version 7.0 and above
    finish
endif

" Line continuation used here
let s:cpo_save = &cpo
set cpo&vim

" Define the commands for invoking various grep utilities

" grep commands
command! -nargs=* -complete=customlist,grep#complete Grep
	\ call grep#runGrep('Grep', 'grep', 'set', <q-args>)
command! -nargs=* -complete=customlist,grep#complete Rgrep
	\ call grep#runGrepRecursive('Rgrep', 'grep', 'set', <q-args>)
command! -nargs=* -complete=customlist,grep#complete GrepAdd
	\ call grep#runGrep('GrepAdd', 'grep', 'add', <q-args>)
command! -nargs=* -complete=customlist,grep#complete RgrepAdd
	\ call grep#runGrepRecursive('RgrepAdd', 'grep', 'add', <q-args>)

" fgrep commands
command! -nargs=* -complete=customlist,grep#complete Fgrep
	\ call grep#runGrep('Fgrep', 'fgrep', 'set', <q-args>)
command! -nargs=* -complete=customlist,grep#complete Rfgrep
	\ call grep#runGrepRecursive('Rfgrep', 'fgrep', 'set', <q-args>)
command! -nargs=* -complete=customlist,grep#complete FgrepAdd
	\ call grep#runGrep('FgrepAdd', 'fgrep', 'add', <q-args>)
command! -nargs=* -complete=customlist,grep#complete RfgrepAdd
	\ call grep#runGrepRecursive('RfgrepAdd', 'fgrep', 'add', <q-args>)

" egrep commands
command! -nargs=* -complete=customlist,grep#complete Egrep
	\ call grep#runGrep('Egrep', 'egrep', 'set', <q-args>)
command! -nargs=* -complete=customlist,grep#complete Regrep
	\ call grep#runGrepRecursive('Regrep', 'egrep', 'set', <q-args>)
command! -nargs=* -complete=customlist,grep#complete EgrepAdd
	\ call grep#runGrep('EgrepAdd', 'egrep', 'add', <q-args>)
command! -nargs=* -complete=customlist,grep#complete RegrepAdd
	\ call grep#runGrepRecursive('RegrepAdd', 'egrep', 'add', <q-args>)

" agrep commands
command! -nargs=* -complete=customlist,grep#complete Agrep
	\ call grep#runGrep('Agrep', 'agrep', 'set', <q-args>)
command! -nargs=* -complete=customlist,grep#complete Ragrep
	\ call grep#runGrepRecursive('Ragrep', 'agrep', 'set', <q-args>)
command! -nargs=* -complete=customlist,grep#complete AgrepAdd
	\ call grep#runGrep('AgrepAdd', 'agrep', 'add', <q-args>)
command! -nargs=* -complete=customlist,grep#complete RagrepAdd
	\ call grep#runGrepRecursive('RagrepAdd', 'agrep', 'add', <q-args>)

" Silver Searcher (ag) commands
command! -nargs=* -complete=customlist,grep#complete Ag
	    \ call grep#runGrep('Ag', 'ag', 'set', <q-args>)
command! -nargs=* -complete=customlist,grep#complete AgAdd
	\ call grep#runGrep('AgAdd', 'ag', 'add', <q-args>)

" Ripgrep (rg) commands
command! -nargs=* -complete=customlist,grep#complete Rg
	    \ call grep#runGrep('Rg', 'rg', 'set', <q-args>)
command! -nargs=* -complete=customlist,grep#complete RgAdd
	\ call grep#runGrep('RgAdd', 'rg', 'add', <q-args>)

" ack commands
command! -nargs=* -complete=customlist,grep#complete Ack
	    \ call grep#runGrep('Ack', 'ack', 'set', <q-args>)
command! -nargs=* -complete=customlist,grep#complete AckAdd
	\ call grep#runGrep('AckAdd', 'ack', 'add', <q-args>)

" git grep commands
command! -nargs=* -complete=customlist,grep#complete Gitgrep
	    \ call grep#runGrep('Gitgrep', 'git', 'set', <q-args>)
command! -nargs=* -complete=customlist,grep#complete GitgrepAdd
	\ call grep#runGrep('GitgrepAdd', 'git', 'add', <q-args>)

" sift commands
command! -nargs=* -complete=customlist,grep#complete Sift
	    \ call grep#runGrep('Sift', 'sift', 'set', <q-args>)
command! -nargs=* -complete=customlist,grep#complete SiftAdd
	\ call grep#runGrep('SiftAdd', 'sift', 'add', <q-args>)

" Platinum Searcher commands
command! -nargs=* -complete=customlist,grep#complete Ptgrep
	    \ call grep#runGrep('Ptgrep', 'pt', 'set', <q-args>)
command! -nargs=* -complete=customlist,grep#complete PtgrepAdd
	\ call grep#runGrep('PtgrepAdd', 'pt', 'add', <q-args>)

" Universal Code Grep commands
command! -nargs=* -complete=customlist,grep#complete Ucgrep
	    \ call grep#runGrep('Ucgrep', 'ucg', 'set', <q-args>)
command! -nargs=* -complete=customlist,grep#complete UcgrepAdd
	\ call grep#runGrep('UcgrepAdd', 'ucg', 'add', <q-args>)


" findstr commands
if has('win32')
    command! -nargs=* -complete=customlist,grep#complete Findstr
		\ call grep#runGrep('Findstr', 'findstr', 'set', <q-args>)
    command! -nargs=* -complete=customlist,grep#complete FindstrAdd
	    \ call grep#runGrep('FindstrAdd', 'findstr', 'add', <q-args>)
endif

" Buffer list grep commands
command! -nargs=* GrepBuffer
	\ call grep#runGrepSpecial('GrepBuffer', 'buffer', 'set', <q-args>)
command! -nargs=* Bgrep
	\ call grep#runGrepSpecial('Bgrep', 'buffer', 'set', <q-args>)
command! -nargs=* GrepBufferAdd
	\ call grep#runGrepSpecial('GrepBufferAdd', 'buffer', 'add', <q-args>)
command! -nargs=* BgrepAdd
	\ call grep#runGrepSpecial('BgrepAdd', 'buffer', 'add', <q-args>)

" Argument list grep commands
command! -nargs=* GrepArgs
	\ call grep#runGrepSpecial('GrepArgs', 'args', 'set', <q-args>)
command! -nargs=* GrepArgsAdd
	\ call grep#runGrepSpecial('GrepArgsAdd', 'args', 'add', <q-args>)

" Add the Tools->Search Files menu
if has('gui_running')
    anoremenu <silent> Tools.Search.Current\ Directory<Tab>:Grep
                \ :Grep<CR>
    anoremenu <silent> Tools.Search.Recursively<Tab>:Rgrep
                \ :Rgrep<CR>
    anoremenu <silent> Tools.Search.Buffer\ List<Tab>:Bgrep
                \ :Bgrep<CR>
    anoremenu <silent> Tools.Search.Argument\ List<Tab>:GrepArgs
                \ :GrepArgs<CR>
endif

" restore 'cpo'
let &cpo = s:cpo_save
unlet s:cpo_save

