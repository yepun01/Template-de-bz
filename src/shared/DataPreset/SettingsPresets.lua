--[[
    SettingsPresets.lua
    Rask/AfraiEda
    Created on 07/05/2022 @ 16:53:28

    Description:
        No description provided.

    Documentation:
        No documentation provided.
--]]

--= Root =--
local SettingsPresets = { }


--= Base Settings =--

function SettingsPresets:ConvertData()
    local Data = {["Keybinds"] = {};
                  ["General"] = {}}

    for i,v in pairs(SettingsPresets.Settings) do
        if (i == "Keybinds") then
            for _,t in pairs(v) do
                for e,u in pairs(t) do
                    Data["Keybinds"][e] = u.Params.BasedKey
                end
            end
        else
            for _,t in pairs(v) do
                for e,u in pairs(t) do
                    Data["General"][e] = u.Params.BasedValue
                end
            end
        end
    end
    return (Data)
end

SettingsPresets.Settings = {
    ["Keybinds"] = {
        ["Movements"] = {
            ["Sprint"] =  {
                ["Type"] = "KeySelection",
                ["Params"] = {["BasedKey"] = "Shift", ["UIDisplay"] = {}}
            };
        },
        ["Training"] = {
            ["Control"] =  {
                ["Type"] = "KeySelection",
                ["Params"] = {["BasedKey"] = "One", ["UIDisplay"] = {}}
            };
            ["Strength"] =  {
                ["Type"] = "KeySelection",
                ["Params"] = {["BasedKey"] = "Two", ["UIDisplay"] = {}}
            };
            ["Endurance"] =  {
                ["Type"] = "KeySelection",
                ["Params"] = {["BasedKey"] = "Three", ["UIDisplay"] = {}}
            };
        }
    };
    ["General"] = {
        ["Sound"] = {
            ["SFX"] =  {
                ["Type"] = "Slider",
                ["Params"] = {["BasedValue"] = 0.5, ["Values"] = {["Min"] = 0, ["Max"] = 1}, ["Convert"] = {["Min"] = 0, ["Max"] = 1}}
            };
            ["Music"] =  {
                ["Type"] = "Slider",
                ["Params"] = {["BasedValue"] = 0.5, ["Values"] = {["Min"] = 0, ["Max"] = 1}, ["Convert"] = {["Min"] = 0, ["Max"] = 1}}
            }
        },
        ["Gameplay"] = {
        }
    };
}

SettingsPresets.SelectColor = {
    ["Hover"] = Color3.fromRGB(103, 4, 128);
    ["UnSelected"] = Color3.fromRGB(0, 0, 0);
}

SettingsPresets.Color = {
    Color3.fromRGB(36, 39, 48),
    Color3.fromRGB(200, 203, 214)
}
--= Accepted input =--

SettingsPresets.DisplayCode = {
    ["One"] = "1";
    ["Two"] = "2";
    ['Three'] = "3";
    ["Four"] = "4";
    ["Five"] = "5";
    ["Six"] = "6";
    ["Seven"] = "7";
    ["Eight"] = "8";
    ["Nine"] = "9";
    ["Zero"] = "0";
    ["MouseButton1"] = "Mouse (Left)";
    ["MouseButton2"] = "Mouse (Right)";
    ["MouseButton3"] = "Mouse (Middle)";
}

SettingsPresets.ImageDisplay = {
    ["MouseButton1"] = "rbxassetid://11304137711",
    ["MouseButton2"] = "rbxassetid://11304137497",
    ["MouseButton3"] = "rbxassetid://11304137595",
}

SettingsPresets.PossibleKey = {
"A","Z","E","R","T","Y","U","I","O","P",
"Q","S","D","F","G","H","J","K","L","M",
"W","X","C","V","B","N",",",
"One","Two","Three","Four","Five",
"Six","Seven","Eight","Nine","Zero",
}

SettingsPresets.PossibleInput = {
"MouseButton1",
"MouseButton2",
"MouseButton3",
}

SettingsPresets.ConvertCode = {
    ["&"] = "One";
    ["É"] = "Two";
    ['"'] = "Three";
    ["'"] = "Four";
    ["("] = "Five";
    ["-"] = "Six";
    ["È"] = "Seven";
    ["_"] = "Eight";
    ["Ç"] = "Nine";
    ["À"] = "Zero";
    [")"] = "LeftParenthesis";
    ["="] = "Equals";
}

return SettingsPresets