local neogit = require("neogit")

neogit.setup({
	-- disable_signs = false,
	-- disable_context_highlighting = false,
	disable_commit_confirmation = true,
	commit_popup = {
		kind = "split_above",
	},
	-- -- customize displayed signs
	-- signs = {
	--   -- { CLOSED, OPENED }
	--   section = { ">", "v" },
	--   item = { ">", "v" },
	--   hunk = { "", "" },
	-- },
	integrations = {
		diffview = true,
	},
	-- override/add mappings
	mappings = {
		-- modify status buffer mappings
		status = {
			-- Adds a mapping with "B" as key that does the "BranchPopup" command
			["B"] = "BranchPopup",
			-- Removes the default mapping of "s"
			-- ["s"] = "",
		},
	},
})

require("mappings").neogit()
