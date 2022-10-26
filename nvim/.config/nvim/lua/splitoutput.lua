local async = require("neotest.async")
local lib = require("neotest.lib")
local config = require("neotest.config")

-- local win, short_opened
local buf, win

local function extract_dir(filename)
	local parts = vim.split(filename, "/")
	parts[#parts] = nil
	return table.concat(parts, "/")
end

local function create_buffer(cur_name, cur_win, output)
	local new_buf = vim.api.nvim_create_buf(false, true)
	local temp_win = async.api.nvim_open_win(new_buf, true, {
		relative = "editor",
		width = vim.api.nvim_get_option("columns"),
		height = vim.api.nvim_get_option("lines"),
		row = 0,
		col = 0,
	})
	local chan = vim.api.nvim_open_term(new_buf, {})

	-- See https://github.com/neovim/neovim/issues/14557
	local dos_newlines = string.find(output, "\r\n") ~= nil
	vim.api.nvim_chan_send(chan, dos_newlines and output or output:gsub("\n", "\r\n"))

	--TODO: For some reason, NeoVim fills the buffer with empty lines
	vim.api.nvim_buf_set_option(new_buf, "modifiable", true)
	vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, {})
	vim.api.nvim_buf_set_option(new_buf, "modifiable", false)

	vim.api.nvim_win_close(temp_win, true)
	-- vim.api.nvim_buf_set_name(buf, "neotest output")
	vim.api.nvim_buf_set_keymap(new_buf, "n", "q", "", {
		noremap = true,
		silent = true,
		callback = function()
			pcall(vim.api.nvim_win_close, win, true)
		end,
	})

	vim.api.nvim_buf_set_keymap(new_buf, "n", "<cr>", "", {
		noremap = true,
		silent = true,
		callback = function()
			local cur_dir = extract_dir(cur_name)
			local pattern = "%s%s%s%s(.+%.go):(%d+):"
			local line = vim.api.nvim_get_current_line()
			local file, linenumber = line:gmatch(pattern)()
			if file and linenumber then
				file = cur_dir .. "/" .. file
				linenumber = tonumber(linenumber)
				if file == cur_name then
					vim.api.nvim_win_set_cursor(cur_win, { linenumber, 0 })
					vim.api.nvim_set_current_win(cur_win)
				end
			end
		end,
	})
	return new_buf
end

local function open_output(output, opts)
	local cur_win = vim.api.nvim_get_current_win()
	local cur_name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
	if not output then
		if not opts.quiet then
			lib.notify("no output", "warn")
		end
		return
	end

	local new_buf = create_buffer(cur_name, cur_win, output)
	if not win or not vim.api.nvim_win_is_valid(win) then
		vim.cmd("bel sb" .. new_buf)
		win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_height(win, 10)
	else
		vim.api.nvim_win_set_buf(win, new_buf)
		vim.api.nvim_buf_delete(buf, { force = true })
	end
	buf = new_buf

	if opts.enter then
		vim.api.nvim_set_current_win(win)
	else
		vim.api.nvim_set_current_win(cur_win)
	end
end

local neotest = {}

---@toc_entry Split Output Consumer
---@text
--- A consumer that displays the output of test results in a split
neotest.splitoutput = {}

---@private
---@type neotest.Client
local client

local init = function()
	if config.splitoutput.open_on_run then
		client.listeners.results = function(_, results)
			lib.notify("listeners.results()")
			-- lib.notify(vim.inspect(results))
			-- local cur_pos = async.fn.getpos(".")
			-- local line = cur_pos[2] - 1
			-- local buf_path = vim.fn.expand("%:p", _, _)
			-- local positions = client:get_position(buf_path)
			-- if not positions then
			-- 	return
			-- end
			-- for _, pos in positions:iter() do
			-- 	if
			-- 		pos.type == "test"
			-- 		and results[pos.id]
			-- 		-- and results[pos.id].status == "failed"
			-- 		and pos.range[1] <= line
			-- 		and pos.range[3] >= line
			-- 	then
			-- 		open_output(results[pos.id], {
			-- 			short = config.splitoutput.open_on_run == "short",
			-- 			enter = false,
			-- 			quiet = true,
			-- 		})
			-- 	end
			-- end
			-- local output_file = results["root"].output
			-- if not output_file then
			-- 	lib.notify("no output file")
			-- 	return
			-- end
			-- lib.notify("output file: " .. output_file)

			-- local output = vim.fn.readfile(output_file)
			-- lib.notify(vim.inspect(output))

			-- local success, output = pcall(lib.files.read, output_file)
			-- if not success then
			-- 	lib.notify("could not read output file " .. output_file .. ": " .. output)
			-- 	return
			-- end
			open_output(results["root"].short, { enter = false, quiet = true })
		end
	end
end

local function open_under_cursor(adapter_id, tree, opts)
	local result = client:get_results(adapter_id)[tree:data().id]
	if not result then
		lib.notify("No output for " .. tree:data().name)
		return
	end
	open_output(result.short, opts)
end

local function open_all_output(adapter_id, opts)
	local results = client:get_results(adapter_id)
	local all_outputs = ""
	for _, result in pairs(results) do
		all_outputs = all_outputs .. result.short
	end
	open_output(all_outputs, opts)
end

--- Open the output of a test result
--- >
---   lua require("neotest").output.open({ enter = true })
--- <
---@param opts table?
---@field open_win function Function that takes a table with width and height keys
--- and opens a window for the output. If a window ID is not returned, the current
--- window will be used
---@field short boolean Show shortened output
---@field enter boolean Enter output window
---@field quiet boolean Suppress warnings of no output
---@field position_id string Open output for position with this ID, opens nearest
--- position if not given
---@field adapter string Adapter ID, defaults to first found with matching position
function neotest.splitoutput.open(opts)
	opts = opts or {}
	async.run(function()
		local tree, adapter_id
		if not opts.position_id then
			local file_path = vim.fn.expand("%:p")
			local row = vim.fn.getbufinfo(file_path)[1].lnum - 1
			tree, adapter_id = client:get_nearest(file_path, row, opts)
		else
			tree, adapter_id = client:get_position(opts.position_id, opts)
		end
		if not tree then
			lib.notify("No tests found in file", "warn")
			return
		end
		-- open_all_output(adapter_id, opts)
		open_under_cursor(adapter_id, tree, opts)
	end)
end

neotest.splitoutput = setmetatable(neotest.splitoutput, {
	__call = function(_, client_)
		client = client_
		init()
		return neotest.splitoutput
	end,
})

return neotest.splitoutput
