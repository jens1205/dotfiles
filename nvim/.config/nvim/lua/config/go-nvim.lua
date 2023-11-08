vim.cmd([[

autocmd FileType go nmap <Leader>c :GoCoverage -t<CR>
autocmd FileType go nmap <leader>ta :GoTest<CR>
autocmd FileType go nmap <leader>tf :GoTestFile<CR>
autocmd FileType go nmap <leader>tp :GoTestPackage<CR>
autocmd FileType go nmap <leader>tt :GoTestFunc<CR>

autocmd Filetype go command! -bang A :GoAlt

]])
