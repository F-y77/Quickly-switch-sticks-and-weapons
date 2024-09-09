-- modmain.lua
 
local G = GLOBAL
local keybind_switch = G["KEY_"..GetModConfigData("switchkey")]
local keybind_summon = G["KEY_"..GetModConfigData("summonkey")]
 
local original_slot = nil
local summon_items = { "cane", "walking_stick", "orangestaff" }
 
if G.TheNet:GetIsServer() then  -- 确保只在服务器运行
    -- 检查是否在游戏内
    local function IsInGameplay()
        return G.ThePlayer ~= nil and G.TheFrontEnd:GetActiveScreen().name == "HUD"
    end
 
    -- 检查玩家是否可以切换物品
    local function CanSwitchItem(player)
        return IsInGameplay() and not player.replica.inventory:GetActiveItem()
    end
 
    -- 装备下一个武器
    local function EquipNextWeapon(player)
        if player.components.inventory then
            local weapons = player.components.inventory:FindItems(function(item)
                return item.components.weapon ~= nil and not G.table.contains(summon_items, item.prefab)
            end)
            if #weapons > 1 then -- 确保有超过一个武器
                local hand = player.replica.inventory:GetEquippedItem(G.EQUIPSLOTS.HANDS)
                local next_weapon = nil
                if hand then
                    for i, weapon in ipairs(weapons) do
                        if weapon == hand and i < #weapons then
                            next_weapon = weapons[i + 1]
                            break
                        end
                    end
                    if not next_weapon then
                        next_weapon = weapons[1]
                    end
                else
                    next_weapon = weapons[1]
                end
                original_slot = player.components.inventory:GetItemSlot(next_weapon)
                player.components.inventory:Equip(next_weapon)
                print("Equipped weapon:", next_weapon.prefab)
            else
                print("No weapon found in inventory or only one weapon available.")
            end
        end
    end
 
    -- 召唤物品
    local function SummonItem(player)
        if player.components.inventory then
            local item = player.components.inventory:FindItem(function(item)
                return G.table.contains(summon_items, item.prefab)
            end)
            if item then
                player.components.inventory:Equip(item)
                print("Equipped item:", item.prefab)
                -- 这里可以添加逻辑来处理召唤物品的效果
            else
                print("No summonable item found in inventory.")
            end
        end
    end
 
    -- 处理玩家输入
    G.TheInput:AddKeyDownHandler(keybind_switch, function()
        local player = G.ThePlayer
        if not CanSwitchItem(player) then return end
        EquipNextWeapon(player)
    end)
 
    G.TheInput:AddKeyDownHandler(keybind_summon, function()
        local player = G.ThePlayer
        if not CanSwitchItem(player) then return end
        SummonItem(player)
    end)
end