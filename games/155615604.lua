local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Remotes = ReplicatedStorage:WaitForChild('Remotes')
local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local vape = shared.vape
local targetinfo = vape.Libraries.targetinfo
local entitylib = loadstring(downloadFile('newvape/libraries/entity.lua'), 'entitylibrary')()
local WeaponModifier
local WeaponModifierAutofire
local WeaponModifierFirerate
local WeaponModifierSpread

WeaponModifier = vape.Categories.Blatant:CreateModule({
    Name = 'Weapon Modifier',
    Function = function(callback)
        repeat
            if LocalPlayer.Backpack then
                for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if v:IsA('Tool') and v:GetAttribute('AutoFire') and v:GetAttribute('FireRate') and v:GetAttribute('SpreadRadius') then
                        v:SetAttribute('AutoFire', WeaponModifierAutofire.Enabled)
                        v:SetAttribute('FireRate', WeaponModifierFirerate.Value)
                        v:SetAttribute('SpreadRadius', WeaponModifierSpread.Value)
                    end
                end
            end
            task.wait(0.03)
        until (not WeaponModifier.Enabled)
    end,
    Tooltip = 'Modifies Weapon Propertys',
})
WeaponModifierAutofire = WeaponModifier:CreateToggle({
    Name = 'Autofire',
    Default = true,
})
WeaponModifierFirerate = WeaponModifier:CreateSlider({
    Name = 'Firerate',
    Min = 0,
    Max = 150,
    Default = 0,
    Suffix = function(val)
        return val == 1 and 'stud' or 'studs'
    end,
})
WeaponModifierSpread = WeaponModifier:CreateSlider({
    Name = 'Spread',
    Min = 0,
    Max = 150,
    Default = 0,
    Suffix = function(val)
        return val == 1 and 'stud' or 'studs'
    end,
})