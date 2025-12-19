CreateThread(function()
	updatePath = "/pyro-scripts/pyrosStorageUnits"
	resourceName = "pyrosStorageUnits ("..GetCurrentResourceName()..")"

	function checkVersion (err, responseText, headers)
		curVersion = LoadResourceFile(GetCurrentResourceName(), "version")

		if curVersion ~= responseText and tonumber(curVersion) < tonumber(responseText) then
			print('==================================================')
			print(resourceName..' is outdated!')
			print('Your Version: '..curVersion)
			print('Current Version: '..responseText)
			print('Update Here: https://github.com'..updatePath..'')
			print('==================================================')
		elseif tonumber(curVersion) > tonumber(responseText) then
			print('==================================================')
			print(resourceName..' is outdated!')
			print('Your Version: '..curVersion)
			print('Current Version: '..responseText)
			print('Update Here: https://github.com'..updatePath..'')
			print('==================================================')
		else
			print(resourceName .. " is up to date!")
		end
	end

	PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/version", checkVersion, "GET")
end)