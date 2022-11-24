--[[
    Author: Rask/AfraiEda
    Creation Date: 14/11/2022
--]]

--= Root =--
local PetsPressets = { }

PetsPressets.PetsList = {
    ["Adventure Time"] = {
        ["Common"] = {
            ["BMO"] = {["HipHeight"] = 2};
        };
        ["Epic"] = {
            ["BMO"] = {["HipHeight"] = 2};
        };
    }
}

PetsPressets.RarityColor = {
    ["Common"] = Color3.fromRGB(173, 165, 165);
    ["Epic"] = Color3.fromRGB(161, 7, 250);
}

PetsPressets.RarityPercentage = {
    ["Common"] = 5;
    ["Epic"] = 50;
}

PetsPressets.Position = {

}

PetsPressets.ColorPercentage = {
    ["Blue"] = 20;
    ["Pink"] = 30;
    ["Red"] = 20;
    ["White"] = 1;
}

PetsPressets.Color = {
    ["Blue"] = Color3.fromRGB(9, 52, 247);
    ["Pink"] = Color3.fromRGB(247, 9, 215);
    ["Red"] = Color3.fromRGB(252, 6, 6);
    ["White"] = Color3.fromRGB(255, 255, 255);
}


return PetsPressets