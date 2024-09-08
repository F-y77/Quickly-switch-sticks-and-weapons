-- modmain.lua

local G = GLOBAL
local keybind_switch = G["KEY_"..GetModConfigData("switchkey")]
local keybind_summon = G["KEY_"..GetModConfigData("summonkey")]

local original_slot = nil
local summon_items = { "cane", "walking_stick", "orangestaff" }

local function IsInGameplay()
    return G.ThePlayer ~= nil and G.TheFrontEnd:GetActiveScreen().name == "HUD"
end

local function CanSwitchItem()
    return IsInGameplay() and not G.ThePlayer.replica.inventory:GetActiveItem()
end

local function MightBeTyping()
    if G.ThePlayer ~= nil and G.ThePlayer.HUD:HasInputFocus() then
        return true
    end

    if (G.TheFrontEnd:GetActiveScreen() and G.TheFrontEnd:GetActiveScreen().name or ""):find("HUD") ~= nil then
        return false
    end

    return true
end

local function EquipNextWeapon()
    if G.ThePlayer.components.inventory then
        local weapons = G.ThePlayer.components.inventory:FindItems(function(item)
            return item.components.weapon ~= nil and not G.table.contains(summon_items, item.prefab)
        end)
        if #weapons > 0 then
            local hand = G.ThePlayer.replica.inventory:GetEquippedItem(G.EQUIPSLOTS.HANDS)
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
            original_slot = G.ThePlayer.components.inventory:GetItemSlot(next_weapon)
            G.ThePlayer.components.inventory:Equip(next_weapon)
            print("Equipped weapon:", next_weapon.prefab)
        else
            print("No weapon found in inventory.")
        end
    end
end

local function SwitchWeapon()
    if not CanSwitchItem() or MightBeTyping() then return end

    EquipNextWeapon()
end

local function SummonItem()
    if G.ThePlayer.components.inventory then
        local item = G.ThePlayer.components.inventory:FindItem(function(item)
            return G.table.contains(summon_items, item.prefab)
        end)
        if item then
            G.ThePlayer.components.inventory:Equip(item)
            print("Equipped item:", item.prefab)
        else
            print("No summonable item found in inventory.")
        end
    end
end

G.TheInput:AddKeyDownHandler(keybind_switch, function()
    SwitchWeapon()
end)

G.TheInput:AddKeyDownHandler(keybind_summon, function()
    if not CanSwitchItem() or MightBeTyping() then return end
    SummonItem()
end)