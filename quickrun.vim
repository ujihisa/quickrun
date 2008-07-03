" quickrun - run a command and show its result quickly
" Author: ujihisa <http://ujihisa.nowa.jp/>
" ModifiedBy: kana <http://whileimautomaton.net/>

if exists('g:loaded_quickrun')
  finish
endif




function! s:quickrun()
  if !exists('b:quickrun_command')
    echoerr 'quickrun is not available for filetype:' string(&l:filetype)
    return
  endif

  if filereadable(expand('%'))
    silent update
    let file = expand('%')
  else
    let file = tempname() . expand('%:e')
    execute 'write' file
  endfor

  call s:open_result_buffer()
  setlocal modifiable
    silent % delete _
    execute 'read !' b:quickrun_command file
    silent 1 delete _
  setlocal nomodifiable

  if filereadable(expand('%'))
    " nop.
  else
    call delete(file)
  endif
endfunc


function! s:open_result_buffer()
  let bufname = printf('[%s]', b:quickrun_command)
  let bufnr = bufnr(bufname)  " FIXME: escape bufname.

  execute g:quickrun_direction 'split'
  if bufnr == -1
    enew
    setlocal bufhidden=unload
    setlocal nobuflisted
    setlocal buftype=nofile
    setlocal nomodifiable
    setlocal noswapfile
    setfiletype quickrun
    silent file `=bufname`

    nnoremap <buffer> <silent> q  <C-w>c
  else
    silent execute bufnr 'buffer'
  endif
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




nnoremap <Plug>(quickrun)  :<<C-u>call s:quickrun()<Return>
silent! nmap <unique> <Leader>r  <Plug>(quickrun)

augroup plugin-quickrun
  autocmd!
  autocmd Filetype awk  call s:set_quickrun_command('awk')
  autocmd Filetype c  call s:set_quickrun_command('function __rungcc__() { gcc $1 && ./a.out } && __rungcc__')
  autocmd Filetype haskell  call s:set_quickrun_command('runghc')
  autocmd Filetype io  call s:set_quickrun_command('io')
  autocmd Filetype javascript  call s:set_quickrun_command('js')
  autocmd Filetype perl  call s:set_quickrun_command('perl')
  autocmd Filetype php  call s:set_quickrun_command('php')
  autocmd Filetype python  call s:set_quickrun_command('python')
  autocmd Filetype ruby  call s:set_quickrun_command('ruby')
  autocmd Filetype scala  call s:set_quickrun_command('scala')
  autocmd Filetype scheme  call s:set_quickrun_command('gosh')
  autocmd Filetype sed  call s:set_quickrun_command('sed')
  autocmd Filetype sh  call s:set_quickrun_command('sh')
augroup END




let g:loaded_quickrun = 1

" __END__
