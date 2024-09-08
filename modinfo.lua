-- modinfo.lua

local language = "zh" -- "zh" for Chinese, "en" for English

local modinfo = {
    zh = {
        name = "快速切换武器和手杖",
        description = [[

一个允许玩家按下R键快速切换到背包中的任意武器，并按下X键切换到步行手杖、吴迪的木手杖或懒人魔杖的模组。
更懂你的需求，切换到手上的武器再按一下R键就能快速切换到背包中的其他武器，手杖也是同理，会自动向伤害更高，移速更快的手杖切换。
为你保留了两个记忆数，你可以让两个背包里最高伤武器和高移速手杖指定切换，只需要按R和X配合你需要的武器或手杖切换就能自动形成记忆键。
不会失误！武器就是武器，手杖就是手杖，不会切手杖切成带移速的武器，不会切武器切成有伤害的手杖，当然你可以进行配置调整。
R键X键按的不舒服？没关系！这个模组为你设置了超多自定义按键，基本上你能想到的他全都有，冲突也能强制为你切换手杖和武器哦~

]],
        switchkey_label = "切换武器快捷键",
        switchkey_hover = "按下此键切换到背包中的任意武器",
        summonkey_label = "召唤物品快捷键",
        summonkey_hover = "按下此键召唤步行手杖、吴迪的木手杖或懒人魔杖到手上",
    },
    en = {
        name = "Quickly switch sticks and weapons",
        description = [[

A mod that allows players to quickly switch to any weapon in their backpack by pressing the R key, and switch to a walking cane, Woody's wooden cane, or Lazy Explorer by pressing the X key.
Understand your needs better, switch to the weapon in your hand and press the R key again to quickly switch to other weapons in the backpack, the same goes for the cane, it will automatically switch to the cane with higher damage and faster movement speed.
Two memory slots are reserved for you, you can specify the highest damage weapon and the fastest cane in the backpack to switch, just press R and X to switch the weapon or cane you need to automatically form a memory key.
No mistakes! Weapons are weapons, canes are canes, you won't switch a cane to a weapon with movement speed, and you won't switch a weapon to a cane with damage, of course you can adjust the configuration.
R key and X key are uncomfortable to press? No problem! This mod provides you with a lot of customizable keys, basically everything you can think of, and conflicts can also force you to switch canes and weapons~

]],
        switchkey_label = "Switch Weapon Hotkey",
        switchkey_hover = "Press this key to switch to any weapon in the backpack",
        summonkey_label = "Summon Item Hotkey",
        summonkey_hover = "Press this key to summon a walking cane, Woody's wooden cane, or Lazy Explorer to your hand",
    }
}

local selected_language = modinfo[language]

name = selected_language.name
description = selected_language.description
author = "Your Name"
version = "1.0"
forumthread = "/"
icon_atlas = "modicon.xml"
icon = "modicon.tex"
client_only_mod = true
all_clients_require_mod = false
server_only_mod = false
dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true
api_version = 10

local keys = {
    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
    "LSHIFT","LALT","LCTRL","TAB","BACKSPACE","PERIOD","SLASH","TILDE",
}

configuration_options = {
    {
        name = "switchkey",
        label = selected_language.switchkey_label,
        hover = selected_language.switchkey_hover,
        options = {
            --稍后填充
        },
        default = "R",
    },
    {
        name = "summonkey",
        label = selected_language.summonkey_label,
        hover = selected_language.summonkey_hover,
        options = {
            --稍后填充
        },
        default = "X",
    },
}

local function filltable(tbl)
    for i = 1, #keys do
        tbl[i] = {description = keys[i], data = keys[i]}
    end
end

filltable(configuration_options[1].options)
filltable(configuration_options[2].options)