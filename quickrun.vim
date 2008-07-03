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




if !exists('g:quickrun_direction')
  let g:quickrun_direction = 'rightbelow'
endif




nnoremap <Plug>(quickrun)  :<<C-u>call s:quickrun()<Return>
silent! nmap <unique> <Leader>r  <Plug>(quickrun)

augroup plugin-quickrun
  autocmd!
  autocmd Filetype awk  let b:quickrun_command = 'awk'
  autocmd Filetype c  let b:quickrun_command = 'function __rungcc__() { gcc $1 && ./a.out } && __rungcc__'
  autocmd Filetype haskell  let b:quickrun_command = 'runghc'
  autocmd Filetype io  let b:quickrun_command = 'io'
  autocmd Filetype javascript  let b:quickrun_command = 'js'
  autocmd Filetype perl  let b:quickrun_command = 'perl'
  autocmd Filetype php  let b:quickrun_command = 'php'
  autocmd Filetype python  let b:quickrun_command = 'python'
  autocmd Filetype ruby  let b:quickrun_command = 'ruby'
  autocmd Filetype scala  let b:quickrun_command = 'scala'
  autocmd Filetype scheme  let b:quickrun_command = 'gosh'
  autocmd Filetype sed  let b:quickrun_command = 'sed'
  autocmd Filetype sh  let b:quickrun_command = 'sh'
augroup END




let g:loaded_quickrun = 1

" __END__
