-- vim-go
vim.g.go_doc_keywordprg_enabled = 0
vim.g.go_def_mapping_enabled = 0
vim.g.go_echo_go_info = 0
vim.g.go_version_warning = 1
vim.g.go_code_completion_enabled = 0 -- use nvim-compe instead
vim.g.go_test_show_name = 1
vim.g.go_fmt_autosave = 0 -- using nvim-lsp
vim.g.go_imports_autosave = 0 -- already used nvim-lsp
vim.g.go_mod_fmt_autosave = 0 -- use nvim-lsp instead
vim.g.go_def_mapping_enabled = 0
vim.g.go_gopls_enabled = 0
vim.g.go_highlight_string_spellcheck = 0
vim.g.go_highlight_format_strings = 0
vim.g.go_highlight_diagnostic_errors = 0
vim.g.go_highlight_diagnostic_warnings = 0
vim.g.go_metalinter_command = "golangci-lint"
vim.g.go_metalinter_autosave = 0
-- vim.g.go_fmt_command="goimports" -- automatically format and rewrite imports
vim.g.go_list_type = "quickfix" -- error lista are of type quickfix
-- function should be script-scoped - but lua reports an error, so we change it to a normal function
vim.cmd([[
" run :GoBuild or :GoTestCompile based on the go file
function! ZZZ_Build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call ZZZ_Build_go_files()<CR>
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
autocmd FileType go nmap <leader>ta <Plug>(go-test)
autocmd FileType go nmap <leader>tt <Plug>(go-test-func)

]])
