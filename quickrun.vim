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
    write
    execute 'rightbelow vsp [' . b:quickrun_command . ']'
    redraw
    call append(0, split(system(b:quickrun_command . ' ' . expand('%')), '\n'))
  else
    let codes = getline(1, line("$"))
    let tmpfile = "/tmp/quickrun-vim-tmpfile." . expand('%:e')

    execute 'rightbelow vsp [' . b:quickrun_command . ']'
    redraw
    call writefile(codes, tmpfile)
    call append(0, split(system(b:quickrun_command . ' ' . tmpfile), '\n'))
    call system('rm ' . tmpfile)
  endfor

  setlocal nomodifiable
  setlocal nobuflisted
  setlocal nonumber
  setlocal noswapfile
  setlocal buftype=nofile
  setlocal bufhidden=delete
  setlocal noshowcmd
  setlocal wrap
  noremap <buffer> <silent> q :close<cr>
endfunc




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
