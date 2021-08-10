local dap = require('dap')

dap.adapters.go = function(callback, config)
local handle
local pid_or_err
local port = 38697
handle, pid_or_err =
  vim.loop.spawn(
  "dlv",
  {
    args = {"dap", "-l", "127.0.0.1:" .. port},
    detached = true
  },
  function(code)
    handle:close()
    print("Delve exited with exit code: " .. code)
  end
)
-- Wait 100ms for delve to start
vim.defer_fn(
  function()
    --dap.repl.open()
    callback({type = "server", host = "127.0.0.1", port = port})
  end,
  100)


--callback({type = "server", host = "127.0.0.1", port = port})
end
-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
    {
      type = "go",
      name = "Debug",
      request = "launch",
      program = "${file}"
    },
    {
      type = "go",
      name = "Debug test", -- configuration for debugging test files
      request = "launch",
      mode = "test",
      program = "${file}"
    },
}


require("dapui").setup({
  icons = {
    expanded = "▾",
    collapsed = "▸"
  },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = {"<CR>", "<2-LeftMouse>"},
    open = "o",
    remove = "d",
    edit = "e",
  },
  sidebar = {
    open_on_start = true,
    elements = {
      -- You can change the order of elements in the sidebar
      "scopes",
      "breakpoints",
      "stacks",
      "watches"
    },
    width = 40,
    position = "left" -- Can be "left" or "right"
  },
  tray = {
    open_on_start = true,
    elements = {
      "repl"
    },
    height = 10,
    position = "bottom" -- Can be "bottom" or "top"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil   -- Floats will be treated as percentage of your screen.
  }
})

dap.defaults.fallback.terminal_win_cmd = '50vsplit new'
