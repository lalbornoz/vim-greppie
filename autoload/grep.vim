" File: grep.vim
" Author: Yegappan Lakshmanan  (yegappan AT yahoo DOT com), Lucía Andrea Illanes Albornoz  (lucia AT luciaillanes DOT de)
" Version: 3.11
" Last Modified: March 6, 2023
" 
" Plugin to integrate grep like utilities with Vim
" Supported utilities are: grep, fgrep, egrep, agrep, findstr, ag, ack,
" ripgrep, git grep, sift, platinum searcher and universal code grep.
"
" License: MIT License
" Copyright (c) 2023 Lucía Andrea Illanes Albornoz
" Copyright (c) 2002-2020 Yegappan Lakshmanan
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

" Line continuation used here
let s:cpo_save = &cpo
set cpo&vim

" Location of the grep utility
if !exists("Grep_Path")
    let Grep_Path = 'grep'
endif

" Location of the fgrep utility
if !exists("Fgrep_Path")
    let Fgrep_Path = 'fgrep'
endif

" Location of the egrep utility
if !exists("Egrep_Path")
    let Egrep_Path = 'egrep'
endif

" Location of the agrep utility
if !exists("Agrep_Path")
    let Agrep_Path = 'agrep'
endif

" Location of the Silver Searcher (ag) utility
if !exists("Ag_Path")
    let Ag_Path = 'ag'
endif

" Location of the Ripgrep (rg) utility
if !exists("Rg_Path")
    let Rg_Path = 'rg'
endif

" Location of the ack utility
if !exists("Ack_Path")
    let Ack_Path = 'ack'
endif

" Location of the findstr utility
if !exists("Findstr_Path")
    let Findstr_Path = 'findstr.exe'
endif

" Location of the git utility used by the git grep command
if !exists("Git_Path")
    let Git_Path = 'git'
endif

" Location of the sift utility
if !exists("Sift_Path")
    let Sift_Path = 'sift'
endif

" Location of the platinum searcher utility
if !exists("Pt_Path")
    let Pt_Path = 'pt'
endif

" Location of the Universal Code Grep (UCG) utility
if !exists("Ucg_Path")
    let Ucg_Path = 'ucg'
endif

" grep options
if !exists("Grep_Options")
    let Grep_Options = ''
endif

" fgrep options
if !exists("Fgrep_Options")
    let Fgrep_Options = ''
endif

" egrep options
if !exists("Egrep_Options")
    let Egrep_Options = ''
endif

" agrep options
if !exists("Agrep_Options")
    let Agrep_Options = ''
endif

" ag options
if !exists("Ag_Options")
    let Ag_Options = ''
endif

" ripgrep options
if !exists("Rg_Options")
    let Rg_Options = ''
endif

" ack options
if !exists("Ack_Options")
    let Ack_Options = ''
endif

" findstr options
if !exists("Findstr_Options")
    let Findstr_Options = ''
endif

" git grep options
if !exists("Gitgrep_Options")
    let Gitgrep_Options = ''
endif

" sift options
if !exists("Sift_Options")
    let Sift_Options = ''
endif

" pt options
if !exists("Pt_Options")
    let Pt_Options = ''
endif

" ucg options
if !exists("Ucg_Options")
    let Ucg_Options = ''
endif

" Open the Grep output window.  Set this variable to zero, to not open
" the Grep output window by default.  You can open it manually by using
" the :cwindow command.
if !exists("Grep_OpenQuickfixWindow")
    let Grep_OpenQuickfixWindow = 1
endif

" NULL device name to supply to grep.  We need this because, grep will not
" print the name of the file, if only one filename is supplied. We need the
" filename for Vim quickfix processing.
if !exists("Grep_Null_Device")
    if has('win32')
	let Grep_Null_Device = 'NUL'
    else
	let Grep_Null_Device = '/dev/null'
    endif
endif

" The list of directories to skip while searching for a pattern. Set this
" variable to '', if you don't want to skip directories.
if !exists("Grep_Skip_Dirs")
    let Grep_Skip_Dirs = 'RCS CVS SCCS'
endif

" The list of files to skip while searching for a pattern. Set this variable
" to '', if you don't want to skip any files.
if !exists("Grep_Skip_Files")
    let Grep_Skip_Files = '*~ *,v s.*'
endif

" Run the grep commands asynchronously and update the quickfix list with the
" results in the background. Needs Vim version 8.0 and above.
if !exists('Grep_Run_Async')
    " Check whether we can run the grep command asynchronously.
    if v:version >= 800
	let Grep_Run_Async = 1
	" Check whether we can use the quickfix identifier to add the grep
	" output to a specific quickfix list.
	if v:version >= 801 || has('patch-8.0.1023')
	    let s:Grep_Use_QfID = 1
	else
	    let s:Grep_Use_QfID = 0
	endif
    else
	let Grep_Run_Async = 0
    endif
endif

" Table containing information about various grep commands.
"   command path, option prefix character, command options and the search
"   pattern expression option
let s:cmdTable = {
	    \   'grep' : {
	    \     'cmdpath' : g:Grep_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '-s -n',
	    \     'opts' : g:Grep_Options,
	    \     'expropt' : '',
	    \     'nulldev' : g:Grep_Null_Device
	    \   },
	    \   'fgrep' : {
	    \     'cmdpath' : g:Fgrep_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '-s -n',
	    \     'opts' : g:Fgrep_Options,
	    \     'expropt' : '',
	    \     'nulldev' : g:Grep_Null_Device
	    \   },
	    \   'egrep' : {
	    \     'cmdpath' : g:Egrep_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '-s -n',
	    \     'opts' : g:Egrep_Options,
	    \     'expropt' : '',
	    \     'nulldev' : g:Grep_Null_Device
	    \   },
	    \   'agrep' : {
	    \     'cmdpath' : g:Agrep_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '-n',
	    \     'opts' : g:Agrep_Options,
	    \     'expropt' : '',
	    \     'nulldev' : g:Grep_Null_Device
	    \   },
	    \   'ag' : {
	    \     'cmdpath' : g:Ag_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '--vimgrep',
	    \     'opts' : g:Ag_Options,
	    \     'expropt' : '',
	    \     'nulldev' : ''
	    \   },
	    \   'rg' : {
	    \     'cmdpath' : g:Rg_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '--vimgrep',
	    \     'opts' : g:Rg_Options,
	    \     'expropt' : '-e',
	    \     'nulldev' : ''
	    \   },
	    \   'ack' : {
	    \     'cmdpath' : g:Ack_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '-H --column --nofilter --nocolor --nogroup',
	    \     'opts' : g:Ack_Options,
	    \     'expropt' : '--match',
	    \     'nulldev' : ''
	    \   },
	    \   'findstr' : {
	    \     'cmdpath' : g:Findstr_Path,
	    \     'optprefix' : '/',
	    \     'defopts' : '/N',
	    \     'opts' : g:Findstr_Options,
	    \     'expropt' : '',
	    \     'nulldev' : ''
	    \   },
	    \   'git' : {
	    \     'cmdpath' : g:Git_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : 'grep --no-color -n',
	    \     'opts' : g:Gitgrep_Options,
	    \     'expropt' : '-e',
	    \     'nulldev' : ''
	    \   },
	    \   'sift' : {
	    \     'cmdpath' : g:Sift_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '--no-color -n --filename --binary-skip',
	    \     'opts' : g:Sift_Options,
	    \     'expropt' : '-e',
	    \     'nulldev' : ''
	    \   },
	    \   'pt' : {
	    \     'cmdpath' : g:Pt_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '--nocolor --nogroup',
	    \     'opts' : g:Pt_Options,
	    \     'expropt' : '',
	    \     'nulldev' : ''
	    \   },
	    \   'ucg' : {
	    \     'cmdpath' : g:Ucg_Path,
	    \     'optprefix' : '-',
	    \     'defopts' : '--nocolor',
	    \     'opts' : g:Ucg_Options,
	    \     'expropt' : '',
	    \     'nulldev' : ''
	    \   }
	    \ }

" warnMsg
" Display a warning message
func! s:warnMsg(msg) abort
    echohl WarningMsg | echomsg a:msg | echohl None
endfunc

let s:grep_cmd_job = 0
let s:grep_tempfile = ''

" deleteTempFile()
" Delete the temporary file created on MS-Windows to run the grep command
func! s:deleteTempFile() abort
    if has('win32') && !has('win32unix') && (&shell =~ 'cmd.exe')
	if exists('s:grep_tempfile') && s:grep_tempfile != ''
	    " Delete the temporary cmd file created on MS-Windows
	    call delete(s:grep_tempfile)
	    let s:grep_tempfile = ''
	endif
    endif
endfunc

" grep#cmd_output_cb()
" Add output (single line) from a grep command to the quickfix list
func! grep#cmd_output_cb(qf_id, channel, msg) abort
    let job = ch_getjob(a:channel)
    if job_status(job) == 'fail'
	call s:warnMsg('Error: Job not found in grep command output callback')
	return
    endif

    " Check whether the quickfix list is still present
    if s:Grep_Use_QfID
	let l = getqflist({'id' : a:qf_id})
	if !has_key(l, 'id') || l.id == 0
	    " Quickfix list is not present. Stop the search.
	    call job_stop(job)
	    return
	endif

	call setqflist([], 'a', {'id' : a:qf_id,
		    \ 'efm' : '%f:%\s%#%l:%m',
		    \ 'lines' : [a:msg]})
    else
	let old_efm = &efm
	set efm=%f:%\\s%#%l:%m
	caddexpr a:msg . "\n"
	let &efm = old_efm
    endif
endfunc

" grep#chan_close_cb
" Close callback for the grep command channel. No more grep output is
" available.
func! grep#chan_close_cb(qf_id, channel) abort
    let job = ch_getjob(a:channel)
    if job_status(job) == 'fail'
	call s:warnMsg('Error: Job not found in grep channel close callback')
	return
    endif
    let emsg = '[Search command exited with status ' . job_info(job).exitval . ']'

    " Check whether the quickfix list is still present
    if s:Grep_Use_QfID
	let l = getqflist({'id' : a:qf_id})
	if has_key(l, 'id') && l.id == a:qf_id
	    call setqflist([], 'a', {'id' : a:qf_id,
			\ 'efm' : '%f:%\s%#%l:%m',
			\ 'lines' : [emsg]})
	endif
    else
	caddexpr emsg
    endif
endfunc

" grep#cmd_exit_cb()
" grep command exit handler
func! grep#cmd_exit_cb(qf_id, job, exit_status) abort
    " Process the exit status only if the grep cmd is not interrupted
    " by another grep invocation
    if s:grep_cmd_job == a:job
	let s:grep_cmd_job = 0
	call s:deleteTempFile()
    endif
endfunc

" runGrepCmdAsync()
" Run the grep command asynchronously
func! s:runGrepCmdAsync(cmd_name, cmdline, action) abort
    if s:grep_cmd_job isnot 0
	" If the job is already running for some other search, stop it.
	call job_stop(s:grep_cmd_job)
	caddexpr '[Search command interrupted]'
    endif

    let title = '[Search results for ' . a:cmdline . ']'
    if a:action == 'add'
	caddexpr title . "\n"
    else
	cgetexpr title . "\n"
    endif
    "caddexpr 'Search cmd: "' . a:cmdline . '"'
    call setqflist([], 'a', {'title' : title})
    " Save the quickfix list id, so that the grep output can be added to
    " the correct quickfix list
    let l = getqflist({'id' : 0})
    if has_key(l, 'id')
	let qf_id = l.id
    else
	let qf_id = -1
    endif

    if has('win32') && !has('win32unix') && (&shell =~ 'cmd.exe')
	let cmd_list = [a:cmdline]
    else
	let cmd_list = [&shell, &shellcmdflag, a:cmdline]
    endif
    let s:grep_cmd_job = job_start(cmd_list,
		\ {'callback' : function('grep#cmd_output_cb', [qf_id]),
		\ 'close_cb' : function('grep#chan_close_cb', [qf_id]),
		\ 'exit_cb' : function('grep#cmd_exit_cb', [qf_id]),
		\ 'in_io' : 'pipe'})

    if job_status(s:grep_cmd_job) == 'fail'
	let s:grep_cmd_job = 0
	call s:warnMsg('Error: Failed to start the grep command')
	call s:deleteTempFile()
	return
    endif

    " Open the grep output window
    if g:Grep_OpenQuickfixWindow == 1
	" Open the quickfix window below the current window
	botright copen
        call s:mapBufferKeys()
    endif
endfunc

" mapBufferKeys()
" Maps key sequences in current buffer
func! s:mapBufferKeys() abort
    noremap <buffer> <Plug>(OpenGrepResult) :<C-U>call <SID>openInWindow(0, 1, 0)<CR>
    noremap <buffer> <Plug>(OpenGrepResultCloseQuickfix) :<C-U>call <SID>openInWindow(1, 1, 0)<CR>
    noremap <buffer> <Plug>(OpenGrepResultSplit) :<C-U>call <SID>openInWindow(0, 0, 0)<CR>
    noremap <buffer> <Plug>(OpenGrepResultSplitCloseQuickfix) :<C-U>call <SID>openInWindow(1, 0, 0)<CR>
    noremap <buffer> <Plug>(OpenGrepResultVSplit) :<C-U>call <SID>openInWindow(0, 0, 1)<CR>
    noremap <buffer> <Plug>(OpenGrepResultVSplitCloseQuickfix) :<C-U>call <SID>openInWindow(1, 0, 1)<CR>
endfunc

" openInWindow()
" Opens file at line number from current line in grep output window w/ optional
" auto-close of the same (closefl=1) and in current window (currentfl=1) or a new
" split window (verticalfl=0) or vertical split window (verticalfl=1)
func! s:openInWindow(closefl, currentfl, verticalfl) abort
    let linenr = line(".")
    let item = getqflist({'id': 0, 'items': 0}).items[linenr - 1]
    let fname = bufname(item['bufnr'])

    if a:currentfl
        execute("wincmd k")
    else
        if a:verticalfl
            vnew
        else
            new
        endif
    endif

    execute("e! " . fname)
    execute("normal! " . item['lnum'] . "G")
    execute("normal! zt")

    if a:closefl
        cclose
    endif
endfunc

" runGrepCmd()
" Run the specified grep command line w/ system()
func! s:runGrepCmd(cmd_name, cmd, cmd_args, action) abort
    let cmdline = s:formFullCmd(a:cmd, a:cmd_args)

    if has('win32') && !has('win32unix') && (&shell =~ 'cmd.exe')
	" Windows does not correctly deal with commands that have more than 1
	" set of double quotes.  It will strip them all resulting in:
	" 'C:\Program' is not recognized as an internal or external command
	" operable program or batch file.  To work around this, place the
	" command inside a batch file and call the batch file.
	" Do this only on Win2K, WinXP and above.
	let s:grep_tempfile = fnamemodify(tempname(), ':h:8') . '\mygrep.cmd'
	call writefile(['@echo off', cmdline], s:grep_tempfile)

	if g:Grep_Run_Async
	    call s:runGrepCmdAsync(a:cmd_name, s:grep_tempfile,  a:action)
	    return
	endif
	let cmd_output = system('"' . s:grep_tempfile . '"')

	if exists('s:grep_tempfile')
	    " Delete the temporary cmd file created on MS-Windows
	    call delete(s:grep_tempfile)
	endif
    else
	if g:Grep_Run_Async
	    return s:runGrepCmdAsync(a:cmd_name, cmdline, a:action)
	endif
	let cmd_output = system(cmdline)
    endif

    " Do not check for the shell_error (return code from the command).
    " Even if there are valid matches, grep returns error codes if there
    " are problems with a few input files.

    if cmd_output == ''
	call s:warnMsg('Error: No search results')
	return
    endif

    let tmpfile = tempname()

    let old_verbose = &verbose
    set verbose&vim

    exe 'redir! > ' . tmpfile
    silent echon '[Search results for ' . a:cmd . "]\n"
    silent echon cmd_output
    redir END

    let &verbose = old_verbose

    let old_efm = &efm
    set efm=%f:%\\s%#%l:%c:%m,%f:%\\s%#%l:%m

    if a:action == 'add'
	execute 'silent! caddfile ' . tmpfile
    else
	execute 'silent! cgetfile ' . tmpfile
    endif

    let &efm = old_efm

    " Open the grep output window
    if g:Grep_OpenQuickfixWindow == 1
	" Open the quickfix window below the current window
	botright copen
    endif

    call delete(tmpfile)
endfunc

" formFullCmd()
" Generate the full command to run based on the user supplied command name,
" command line, and default options.
func! s:formFullCmd(cmd_name, args) abort
    if !has_key(s:cmdTable, a:cmd_name)
	call s:warnMsg('Error: Unsupported command ' . a:cmd_name)
	return ''
    endif

    if has('win32')
	" On MS-Windows, convert the program pathname to 8.3 style pathname.
	" Otherwise, using a path with space characters causes problems.
	let s:cmdTable[a:cmd_name].cmdpath =
		    \ fnamemodify(s:cmdTable[a:cmd_name].cmdpath, ':8')
    endif

    let cmdopt = s:cmdTable[a:cmd_name].defopts
    if s:cmdTable[a:cmd_name].opts != ''
	let cmdopt = cmdopt . ' ' . s:cmdTable[a:cmd_name].opts
    endif
    if s:cmdTable[a:cmd_name].expropt != ''
	let cmdopt = cmdopt . ' ' . s:cmdTable[a:cmd_name].expropt
    endif

    if has_key({'grep': 0, 'egrep': 0, 'fgrep': 0}, a:cmd_name)
        let fullcmd = s:cmdTable[a:cmd_name].cmdpath . ' ' .
		    \ cmdopt . ' ' .
		    \ a:args 
    else
        let fullcmd = s:cmdTable[a:cmd_name].cmdpath . ' ' .
		    \ a:args
    endif

    if s:cmdTable[a:cmd_name].nulldev != ''
	let fullcmd = fullcmd . ' ' . s:cmdTable[a:cmd_name].nulldev
    endif

    return fullcmd
endfunc

" getListOfBufferNames()
" Get the file names of all the listed and valid buffer names 
func! s:getListOfBufferNames() abort
    let filenames = ''

    " Get a list of all the buffer names
    for i in range(1, bufnr("$"))
	if bufexists(i) && buflisted(i)
	    let fullpath = fnamemodify(bufname(i), ':p:S')
	    let filenames = filenames . ' ' . fullpath
	endif
    endfor

    return filenames
endfunc

" getListOfArgFiles()
" Get the names of all the files in the argument list
func! s:getListOfArgFiles() abort
    let filenames = ''

    let arg_cnt = argc()
    if arg_cnt != 0
	for i in range(0, arg_cnt - 1)
	    let filenames = filenames . ' ' . shellescape(argv(i))
	endfor
    endif

    return filenames
endfunc

" grep#runGrepRecursive()
" Run specified grep command recursively
func! grep#runGrepRecursive(cmd_name, grep_cmd, action, ...) abort
    let grep_cmd = a:grep_cmd

    if g:Grep_Skip_Dirs != ''
	for one_dir in split(g:Grep_Skip_Dirs, ' ')
	    let grep_cmd = "--exclude-dir=" . shellescape(one_dir) . " " . grep_cmd
	endfor
    endif

    if g:Grep_Skip_Files != ''
	for one_file in split(g:Grep_Skip_Files, ' ')
	    let grep_cmd = "--exclude=" . shellescape(one_file) . " " . grep_cmd
	endfor
    endif

    call s:runGrepCmd(a:cmd_name, grep_cmd, a:000[0], a:action)
endfunc

" grep#runGrepSpecial()
" Search in all the opened buffers or filenames in the argument list
func! grep#runGrepSpecial(cmd_name, which, action, ...) abort
    let grep_args = a:000[0]

    " Search in all the Vim buffers
    if a:which == 'buffer'
	let filenames = s:getListOfBufferNames()
	" No buffers
	if filenames == ''
	    call s:warnMsg('Error: Buffer list is empty')
	    return
	endif
	let grep_args = grep_args . ' ' . filenames
    elseif a:which == 'args'
	" Search in all the filenames in the argument list
	let filenames = s:getListOfArgFiles()
	" No arguments
	if filenames == ''
	    call s:warnMsg('Error: Argument list is empty')
	    return
	endif
	let grep_args = grep_args . ' ' . filenames
    endif

    if has('win32') && !has('win32unix')
	" On Windows-like systems, use 'findstr' to search in buffers/arglist
	let grep_cmd = 'findstr'
    else
	" On all other systems, use 'grep' to search in buffers/arglist
	let grep_cmd = 'grep'
    endif

    call s:runGrepCmd(a:cmd_name, grep_cmd, grep_args, a:action)
endfunc

" grep#runGrep()
" Run the specified grep command
func! grep#runGrep(cmd_name, grep_cmd, action, ...) abort
    call s:runGrepCmd(a:cmd_name, a:grep_cmd, a:000[0], a:action)
endfunc

" restore 'cpo'
let &cpo = s:cpo_save
unlet s:cpo_save
