if !exists('b:did_quickrun')
  let b:did_quickrun = 1

  fu! QuickRun(command)
    if filereadable(expand('%'))
      let s:file = expand('%')
      exe 'rightbelow vsp [' . a:command . ']'
      redr
      call append(0, split(system(a:command . ' ' . s:file), '\n'))
    el
      let codes = getline(1, line("$"))
      let tmpfile = "/tmp/quickrun-vim-tmpfile." . expand('%:e')

      exe 'rightbelow vsp [' . a:command . ']'
      redr
      call writefile(codes, tmpfile)
      call append(0, split(system(a:command . ' ' . tmpfile), '\n'))
      call system('rm ' . tmpfile)
    en

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
endif

" __END__
