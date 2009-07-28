" quickrun - run a command and show its result quickly
" Author: ujihisa <http://ujihisa.blogspot.com/>
" ModifiedBy: kana <http://whileimautomaton.net/>
" ModifiedBy: Sixeight <http://d.hatena.ne.jp/Sixeight/>

if exists('g:loaded_quickrun')
  finish
endif


function! s:quicklaunch(no)
  if !exists('g:quicklaunch_commands[a:no]')
    echoerr 'quicklaunch has no such command:' a:no
    return
  endif
  let quicklaunch_command = g:quicklaunch_commands[a:no]
  call s:open_result_buffer(quicklaunch_command)
  if exists('g:VimShell_EnableInteractive') && g:VimShell_EnableInteractive && exists(':InteractiveRead')
      call s:write_result_buffer(':-<', 'InteractiveRead ' . quicklaunch_command)
  else
      call s:write_result_buffer(':-<', 'silent! read !' . quicklaunch_command)
  endif
endfunction


function! s:quicklaunch_list()
  if !exists('g:quicklaunch_commands')
    echo 'no command registered'
    return
  endif
  call s:open_result_buffer('quicklaunch_list')
  " FIXME: use s:write_result_buffer
  silent % delete _
  call append(0, '')
  for i in range(10)
    if exists('g:quicklaunch_commands[i]')
      call append(line('$'), i . ': ' . g:quicklaunch_commands[i])
    else
      call append(line('$'), i . ': <Nop>')
    endif
  endfor
  silent 1 delete _
endfunction


function! s:quickkeywordprg()
  let keyword = expand('<cword>')
  let keywordprg = &keywordprg
  call s:open_result_buffer(keyword)
  if exists('g:VimShell_EnableInteractive') && g:VimShell_EnableInteractive && exists(':InteractiveRead')
      call s:write_result_buffer(':-D', 'InteractiveRead ' . keywordprg . ' ' . keyword)
  else
      call s:write_result_buffer(':-D', 'silent! read ! ' . keywordprg . ' ' . keyword)
  endif
endfunction


function! s:quickrun()
  if !exists('b:quickrun_command')
    echoerr 'quickrun is not available for filetype:' string(&l:filetype)
    return
  endif
  let quickrun_command = s:get_quickrun_command()

  let existent_file_p = filereadable(expand('%'))
  if existent_file_p
    silent update
    let file = expand('%')
  else
    let file = tempname() . expand('%:e')
    let original_bufname = bufname('')
    let original_modified = &l:modified
      silent keepalt write `=file`
      if original_bufname == ''
        " Reset the side effect of ":write {file}" - it sets {file} as the
        " name of the current buffer if it is unnamed buffer.
        silent 0 file
      endif
    let &l:modified = original_modified
  endif

  call s:open_result_buffer(quickrun_command)
  if exists('g:VimShell_EnableInteractive') && g:VimShell_EnableInteractive && exists(':InteractiveRead')
      call s:write_result_buffer(':-)', 'InteractiveRead ' . quickrun_command . ' ' . file)
  else
      call s:write_result_buffer(':-)', 'silent! read !' . quickrun_command . ' ' . file)
  endif

  if existent_file_p
    " nop.
  else
    call delete(file)
  endif
endfunc


function! s:get_quickrun_command()
  let m = matchlist(getline(1), '#!\(.*\)')
  if(len(m) > 2)
    return m[1]
  else
    return b:quickrun_command
  endif
endfunction


function! s:open_result_buffer(quickrun_command)
  let bufname = printf('[quickrun] %s', a:quickrun_command)

  if !bufexists(bufname)
    execute g:quickrun_direction 'new'
    setlocal bufhidden=unload
    setlocal nobuflisted
    setlocal buftype=nofile
    setlocal noswapfile
    setfiletype quickrun
    silent file `=bufname`

    nnoremap <buffer> <silent> q  <C-w>c
  else
    let bufnr = bufnr(bufname)  " FIXME: escape.
    let winnr = bufwinnr(bufnr)
    if winnr == -1
      execute g:quickrun_direction 'split'
      execute bufnr 'buffer'
    else
      execute winnr 'wincmd w'
    endif
  endif
endfunction


function! s:write_result_buffer(loading_message, command)
  silent % delete _
  call append(0, a:loading_message)
  redraw
  silent % delete _
  call append(0, '')
  execute a:command
  silent 1 delete _
endfunction


function! s:set_quickrun_command(command)
  " Use user's settings if they exist.
  if !exists('b:quickrun_command')
    let b:quickrun_command = a:command
  endif
endfunction





if !exists('g:quickrun_direction')
  let g:quickrun_direction = 'rightbelow'
endif




nnoremap <silent> <Plug>(quickrun)  :<C-u>call <SID>quickrun()<Return>
silent! nmap <unique> <Leader>r  <Plug>(quickrun)
for i in range(10)
  execute "nnoremap <silent> <Plug>(quicklaunch-" . i . ") :<C-u>call <SID>quicklaunch(" . i . ")<Return>"
  execute "silent! nmap <unique> <Leader>" . i . "  <Plug>(quicklaunch-" . i . ")"
endfor
nnoremap <silent> <Plug>(quicklaunch-list)  :<C-u>call <SID>quicklaunch_list()<Return>
silent! nmap <unique> <Leader>l  <Plug>(quicklaunch-list)
nnoremap <silent> <buffer> <Plug>(quickkeywordprg) :<C-u>call <SID>quickkeywordprg()<Cr>
silent! nmap <unique> K  <Plug>(quickkeywordprg)


augroup plugin-quickrun
  autocmd!
  autocmd Filetype awk  call s:set_quickrun_command('awk -f')
  autocmd Filetype c  call s:set_quickrun_command('function __rungcc__() { gcc $1 && ./a.out } && __rungcc__')
  autocmd Filetype cpp  call s:set_quickrun_command('function __rungpp__() { g++ $1 && ./a.out } && __rungpp__')
  autocmd Filetype eruby  call s:set_quickrun_command('erb -T -')
  autocmd Filetype gnuplot  call s:set_quickrun_command('gnuplot')
  autocmd Filetype haskell  call s:set_quickrun_command('runghc')
  autocmd Filetype io  call s:set_quickrun_command('io')
  autocmd Filetype javascript  call s:set_quickrun_command('js')
  autocmd Filetype mkd  call s:set_quickrun_command(
  \ 'function __mkd__() { pandoc -f markdown -t html -o /tmp/__markdown.html $1; open /tmp/__markdown.html } && __mkd__')
  autocmd Filetype objc  call s:set_quickrun_command('function __rungcc__() { gcc $1 && ./a.out } && __rungcc__')
  autocmd Filetype perl  call s:set_quickrun_command('perl')
  autocmd Filetype php  call s:set_quickrun_command('php')
  autocmd Filetype python  call s:set_quickrun_command('python')
  autocmd Filetype r  call s:set_quickrun_command('R --no-save --slave <')
  autocmd Filetype ruby  call s:set_quickrun_command('ruby')
  autocmd Filetype scala  call s:set_quickrun_command('scala')
  autocmd Filetype scheme  call s:set_quickrun_command('gosh')
  autocmd Filetype sed  call s:set_quickrun_command('sed')
  autocmd Filetype sh  call s:set_quickrun_command('sh')
augroup END




let g:loaded_quickrun = 1

" __END__
