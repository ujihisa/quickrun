" quickrun - run a command and show its result quickly
" Author: ujihisa <http://ujihisa.nowa.jp/>
" ModifiedBy: kana <http://whileimautomaton.net/>

if exists('g:loaded_quickrun')
  finish
endif




function! QuickRun(command)
  if filereadable(expand('%'))
    write
    let s:file = expand('%')
    execute 'rightbelow vsp [' . a:command . ']'
    redraw
    call append(0, split(system(a:command . ' ' . s:file), '\n'))
  else
    let codes = getline(1, line("$"))
    let tmpfile = "/tmp/quickrun-vim-tmpfile." . expand('%:e')

    execute 'rightbelow vsp [' . a:command . ']'
    redraw
    call writefile(codes, tmpfile)
    call append(0, split(system(a:command . ' ' . tmpfile), '\n'))
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

autocmd Filetype ruby        nnoremap <buffer><leader>r :call QuickRun('ruby')<Return>
autocmd Filetype haskell     nnoremap <buffer><leader>r :call QuickRun('runghc')<Return>
autocmd Filetype python      nnoremap <buffer><leader>r :call QuickRun('python')<Return>
autocmd Filetype javascript  nnoremap <buffer><leader>r :call QuickRun('js')<Return>
autocmd Filetype scheme      nnoremap <buffer><leader>r :call QuickRun('gosh')<Return>
autocmd Filetype sh          nnoremap <buffer><leader>r :call QuickRun('sh')<Return>
autocmd Filetype awk         nnoremap <buffer><leader>r :call QuickRun('awk')<Return>
autocmd Filetype sed         nnoremap <buffer><leader>r :call QuickRun('sed')<Return>
autocmd Filetype scala       nnoremap <buffer><leader>r :call QuickRun('scala')<Return>
autocmd Filetype perl        nnoremap <buffer><leader>r :call QuickRun('perl')<Return>
autocmd Filetype php         nnoremap <buffer><leader>r :call QuickRun('php')<Return>
autocmd Filetype io          nnoremap <buffer><leader>r :call QuickRun('io')<Return>
autocmd Filetype c           nnoremap <buffer><leader>r :call QuickRun('function __rungcc__() { gcc $1 && ./a.out } && __rungcc__')<Return>




let g:loaded_quickrun = 1

" __END__
