local dap = require("dap")

dap.adapters.go = function(callback, config)
	local handle, pid_or_err, port = nil, nil, 12346

	handle, pid_or_err = vim.loop.spawn(
		"dlv",
		{
			args = { "dap", "-l", "127.0.0.1:" .. port },
			detached = true,
			cwd = vim.loop.cwd(),
		},
		vim.schedule_wrap(function(code)
			handle:close()
			if code ~= 0 then
				print("Delve has exited with: " .. code)
			end
		end)
	)

	if not handle then
		error("FAILED:", pid_or_err)
	end

	vim.defer_fn(function()
		callback({ type = "server", host = "127.0.0.1", port = port })
	end, 100)
end

dap.configurations.go = {
	{
		type = "go",
		name = "Debug",
		request = "launch",
		showLog = true,
		program = "${file}",
		-- console = "externalTerminal",
		dlvToolPath = vim.fn.exepath("dlv"),
	},
	{
		type = "go",
		name = "Test-debug current package",
		request = "launch",
		showLog = true,
		mode = "test",
		-- program = ".",
		-- program = "${file}",
		-- program = "${fileDirname}",
		program = "./${relativeFileDirname}",

		dlvToolPath = vim.fn.exepath("dlv"),
	},
}

--[[
--old configuration
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
--]]
