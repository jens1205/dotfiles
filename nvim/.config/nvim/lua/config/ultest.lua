vim.g.ultest_use_pty = 1
vim.g.ultest_output_on_run = 0
vim.g.ultest_output_on_line = 0
vim.g.ultest_virtual_text = 1

local builders = {
    ["go#gotest"] = function(cmd)
        local args = {}

        for i = 3, #cmd, 1 do
            local arg = cmd[i]
            if vim.startswith(arg, "-") then
                arg = "-test." .. string.sub(arg, 2)
            end
            args[#args + 1] = arg
        end
        return {
            dap = {
                type = "go",
                request = "launch",
                mode = "test",
                -- program = "${workspaceFolder}",
                -- program = "${file}",
                program = "${fileDirname}",
                dlvToolPath = vim.fn.exepath("dlv"),
                args = args
            },
            parse_result = function(lines)
                return lines[#lines] == "FAIL" and 1 or 0
            end
        }
    end
}
require("ultest").setup({builders = builders})

