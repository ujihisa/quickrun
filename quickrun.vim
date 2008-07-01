if !exists('b:did_quickrun')
  let b:did_quickrun = 1

  fu! QuickRun(command)
    if filereadable(expand('%'))
      w
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

au Filetype ruby        nnoremap <buffer><leader>r :call QuickRun('ruby')<Return>
au Filetype haskell     nnoremap <buffer><leader>r :call QuickRun('runghc')<Return>
au Filetype python      nnoremap <buffer><leader>r :call QuickRun('python')<Return>
au Filetype javascript  nnoremap <buffer><leader>r :call QuickRun('js')<Return>
au Filetype scheme      nnoremap <buffer><leader>r :call QuickRun('gosh')<Return>
au Filetype sh          nnoremap <buffer><leader>r :call QuickRun('sh')<Return>
au Filetype awk         nnoremap <buffer><leader>r :call QuickRun('awk')<Return>
au Filetype sed         nnoremap <buffer><leader>r :call QuickRun('sed')<Return>
au Filetype scala       nnoremap <buffer><leader>r :call QuickRun('scala')<Return>
au Filetype perl        nnoremap <buffer><leader>r :call QuickRun('perl')<Return>
au Filetype php         nnoremap <buffer><leader>r :call QuickRun('php')<Return>
au Filetype io          nnoremap <buffer><leader>r :call QuickRun('io')<Return>
au Filetype c           nnoremap <buffer><leader>r :call QuickRun('function __rungcc__() { gcc $1 && ./a.out } && __rungcc__')<Return>

" __END__
