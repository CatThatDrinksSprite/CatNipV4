local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/CatThatDrinksSprite/CatNipV4/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true)
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
local Killaura
local KillauraTargets
local KillauraAttackRange
local ForceSpawn
local ForceSpawnMonsterType
local Rumble
local RumbleAmount
local RumbleTwitch
local RumbleTwitchAmount

Killaura = vape.Categories.Blatant:CreateModule({
    Name = 'Killaura',
    Function = function(callback)
        repeat
            local plrs = entitylib.AllPosition({
                Range = KillauraAttackRange.Value,
                Wallcheck = KillauraTargets.Walls.Enabled or nil,
                Part = 'RootPart',
                Players = KillauraTargets.Players.Enabled,
                NPCs = KillauraTargets.NPCs.Enabled,
                Limit = 1,
            })
            if #plrs > 0 then
                for _, v in plrs do
                    if LocalPlayer.Character and LocalPlayer.Character:GetAttribute("monsterType") then
                        targetinfo.Targets[v] = tick() + 1
                        Remotes:WaitForChild('sendAttack'):FireServer(unpack({
                            {
                                v.Character
                            },
                            LocalPlayer.Character:GetAttribute('monsterType'),
                        }))
                    end
                end
            end
            task.wait(0.03)
        until (not Killaura.Enabled)
    end,
    Tooltip = 'Attacks every guardian near you',
})
KillauraTargets = Killaura:CreateTargets({
    Players = true,
})
KillauraAttackRange = Killaura:CreateSlider({
    Name = 'Attack Range',
    Min = 1,
    Max = 30,
    Default = 5.3,
    Suffix = function(val)
        return val == 1 and 'stud' or 'studs'
    end,
})

ForceSpawn = vape.Categories.Utility:CreateModule({
    Name = 'Force Spawn',
    Function = function(callback)
        if callback then
            Remotes:WaitForChild("sendCharacterSpawnRequest"):FireServer(unpack({
                ForceSpawnMonsterType.Value
            }))
            ForceSpawn:Toggle()
        end
    end,
    Tooltip = 'Forcefully spawn as a monster even if its locked',
})
ForceSpawnMonsterType = ForceSpawn:CreateDropdown({
    Name = 'Monster Type',
    List = {'TinkyWinky', 'Tank', 'Chainsaw', 'Jaws', 'LaaLaa', 'Po', 'Skintubby', 'SkintubbyRun', 'Crawler', 'Shadow', 'Cave', 'Yeti', 'Arrow', 'Announcer', 'Dollface', 'Overseer', 'Ranger',},
})

local function rumble()
	local state = entitylib.isAlive and entitylib.character.Humanoid:GetState() or nil

	local root = entitylib.character.RootPart
	root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, RumbleAmount.Value, root.AssemblyLinearVelocity.Z)
    if RumbleTwitch.Enabled == true then
        root.CFrame = root.CFrame * CFrame.Angles(0, 0, math.rad(RumbleTwitchAmount.Value))
    end
end
Rumble = vape.Categories.Utility:CreateModule({
    Name = 'Rumble',
    Function = function(callback)
        if callback then
            rumble()
            Rumble:Toggle()
        end
    end,
    Tooltip = 'Only use this when you actually know what you are doing!',
})
RumbleAmount = Rumble:CreateSlider({
    Name = 'Rumble Amount',
    Min = 1,
    Max = 70,
    Default = 50,
    Suffix = function(val)
        return val == 1 and 'stud' or 'studs'
    end,
})
RumbleTwitch = Rumble:CreateToggle({
    Name = 'Twitch',
    Default = true,
})
RumbleTwitchAmount = Rumble:CreateSlider({
    Name = 'Twitch Amount',
    Min = 1,
    Max = 30,
    Default = 15,
    Suffix = function(val)
        return val == 1 and 'stud' or 'studs'
    end,
})