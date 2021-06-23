--Set statusbar
-- vim.g.lightline = { colorscheme = 'onedark';
vim.g.lightline = { colorscheme = 'one';
      active = { left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'filename', 'modified' } } };
      component_function = { gitbranch = 'fugitive#head', };
}
