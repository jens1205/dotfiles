--Set statusbar
-- vim.g.lightline = { colorscheme = 'onedark';
vim.cmd([[
function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction
]])
vim.g.lightline = {
	-- colorscheme = "one",
	colorscheme = "tokyonight",
	active = { left = { { "mode", "paste" }, { "gitbranch", "readonly", "filename", "modified" } } },
	component_function = {
		gitbranch = "FugitiveHead",
		filename = "LightlineFilename",
	},
}
