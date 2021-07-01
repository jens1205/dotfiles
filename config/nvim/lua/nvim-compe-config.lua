-- Compe setup
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    spell = true;
    calc = false;
    omni = false;
    emoji = true;
    
    nvim_lsp = true;
    nvim_lua = true;
    ultisnips = true;
    vsnip = false;
    nvim_treesitter = true;
  };
}


local is_prior_char_whitespace = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end
_G.tab_complete = function()
    print("entered tab_complete")

    if vim.fn.pumvisible() == 1 then
        print("popup menu visible")
        return vim.api.nvim_replace_termcodes("<C-n>", true, true, true)

      elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 or vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
        print("ultisnips can expand snippet or can jump forward")
        return vim.api.nvim_replace_termcodes("<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>", true, true, true)

      elseif is_prior_char_whitespace() then
        print("whitespace detected")
        return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)

      else
        print("default for tab")
        return vim.fn['compe#complete']()
      end
end
_G.s_tab_complete = function()
    print("entered s_tab_complete")

    if vim.fn.pumvisible() == 1 then
        print("popup menu visible")
        return vim.api.nvim_replace_termcodes("<C-p>", true, true, true)

    elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
        print("Ultisnis can jump backwards")
        return vim.api.nvim_replace_termcodes("<C-R>=UltiSnips#JumpBackwards()<CR>", true, true, true)

    else
        print("default for s-tab")
        return vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true)
    end
end

-- start adoption of https://github.com/windwp/nvim-autopairs
local npairs = require('nvim-autopairs')

-- skip it, if you use another global object
_G.MUtils= {}

vim.g.completion_confirm_key = ""
MUtils.completion_confirm=function()
  if vim.fn.pumvisible() ~= 0  then
    if vim.fn.complete_info()["selected"] ~= -1 then
      return vim.fn["compe#confirm"](npairs.esc("<cr>"))
    else
      return npairs.esc("<cr>")
    end
  else
    return npairs.autopairs_cr()
  end
end

vim.api.nvim_set_keymap('i' ,"<CR>", 'v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})
-- stop adoption of https://github.com/windwp/nvim-autopairs

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true, noremap = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true, noremap = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true, noremap = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true, noremap = true})
vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", {expr = true, noremap = true, silent = true })
-- vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", {expr = true, noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-e>", "compe#close('<C-e>')", {expr = true, noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-f>", "compe#scroll({ 'delta': +4 })", {expr = true, noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-d>", "compe#scroll({ 'delta': -4 })", {expr = true, noremap = true, silent = true })


