if !exists('b:did_quickrun')
  let b:did_quickrun = 1

  fu! QuickRun(command)
    let codes = getline(1, line("$"))
    let tmpfile = "/tmp/quickrun-vim-tmpfile." . expand('%:e')

    exe 'bo sp [' . a:command . ']'
    call writefile(codes, tmpfile)
    call append(0, split(system(a:command . ' ' . tmpfile), '\n'))
    call system('rm ' . tmpfile)

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
