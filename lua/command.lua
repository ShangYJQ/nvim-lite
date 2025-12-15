vim.api.nvim_create_user_command("UpdateConfig", function()
	local config_dir = vim.fn.stdpath("config")
	vim.notify("正在从远程仓库拉取配置...", vim.log.levels.INFO)

	-- 异步执行 git pull
	vim.fn.jobstart({ "git", "-C", config_dir, "pull" }, {
		on_stdout = function(_, data)
			if data then
				-- 打印 git 的输出信息
				for _, line in ipairs(data) do
					if line ~= "" then
						print(line)
					end
				end
			end
		end,
		on_stderr = function(_, data)
			if data then
				for _, line in ipairs(data) do
					if line ~= "" then
						vim.notify(line, vim.log.levels.ERROR)
					end
				end
			end
		end,
		on_exit = function(_, code)
			-- 必须使用 vim.schedule 回到主线程操作 UI
			vim.schedule(function()
				if code == 0 then
					-- 弹出确认框 (1=Yes, 2=No)
					local choice = vim.fn.confirm(
						"配置更新成功！需要重启生效。\n是否现在退出 Neovim？",
						"&Yes\n&No",
						1
					)
					if choice == 1 then
						vim.cmd("qa") -- 退出所有窗口
					end
				else
					vim.notify("Git pull 失败，请检查网络或手动解决冲突。", vim.log.levels.ERROR)
				end
			end)
		end,
	})
end, {})
