local function HideDefaultHUD(name)
    local hidden = {
        ["CHudHealth"] = true,
        ["CHudBattery"] = true,
        ["CHudAmmo"] = true,
        ["CHudSecondaryAmmo"] = true
    }

    if hidden[name] then return false end
end

local menuColor = nil

surface.CreateFont("DermaDefault_Large", {
    font = "DermaDefault",
    size = 42,
    weight = 800,
    antialias = true
})

local color_bg = Color(20, 20, 20, 220)
local color_ac = Color(0, 160, 255, 255)

hook.Add("HUDShouldDraw", "HideDefaultHUD", HideDefaultHUD)

hook.Add("HUDPaint", "MainHUD", function ()
    local player = LocalPlayer()

    local health = player:Health()
    local armor = player:Armor()

    local x, y = 30, ScrH() - 100
    local w, h = 260, 70

    surface.SetDrawColor(color_bg)
    surface.DrawRect(x, y, w, h)

    surface.SetDrawColor(color_ac)
    surface.DrawRect(x, y, 4, h)

    draw.SimpleText("Health: " ..health, "DermaDefaultBold", x + 16, y + 15, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    surface.SetDrawColor(50, 50, 50, 255)
    surface.DrawRect(x + 16, y + 30, 220, 8)

    local healthWidth = math.Clamp(health, 0, 100) * 2.2

    surface.SetDrawColor(0, 220, 100, 255)
    surface.DrawRect(x + 16, y + 30, healthWidth, 8)

    if armor > 0 then
        draw.SimpleText("Armor: " ..armor, "DermaDefaultBold", x + 100, y + 15, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(50, 50, 50, 255)
        surface.DrawRect(x + 16, y + 47, 220, 8)

        local armorWidth = math.Clamp(armor, 0, 100) * 2.2

        surface.SetDrawColor(0, 160, 255, 255)
        surface.DrawRect(x + 16, y + 47, armorWidth, 8)
    end

    surface.SetDrawColor(color_bg)
    surface.DrawRect(x + 1600, y, w, h)

    surface.SetDrawColor(color_ac)
    surface.DrawRect(x + 1860, y, 4, h)

    local wep = player:GetActiveWeapon()

    if !IsValid(wep) then return end

    local clip = wep:Clip1()
    local ammoType = wep:GetPrimaryAmmoType()
    local reserve = player:GetAmmoCount(ammoType)
    local wepName = wep:GetPrintName() or "Weapon"

    if clip == -1 and reserve == 0 and ammoType == -1 then
        draw.SimpleText("None", "DermaDefaultBold", x + 1610, y + 10)
        
        return
    end

    draw.SimpleText(string.upper(wepName), "DermaDefaultBold", x + 1610, y + 10)

    if clip ~= -1 then
        local clipText = tostring(clip)

        draw.SimpleText(clipText, "DermaDefault_Large", x + 1705, y + 20, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        local clipWidth, _ = surface.GetTextSize(clipText)

        surface.SetFont("DermaDefault_Large")

        local tw, _ = surface.GetTextSize(clipText)

        draw.SimpleText("/", "DermaDefault_Large", x + 1755, y + 20, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(tostring(reserve), "DermaDefault_Large", x + 1780, y + 20, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    else
        draw.SimpleText(tostring(reserve), "DermaDefault_Large", x + 1720, y  + 20, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
end)

local function changeColor()
    local frame = vgui.Create("DFrame")

    frame:SetSize(300, 350)
    frame:Center()
    frame:SetTitle("Color settings")
    frame:MakePopup()

    local mixer = vgui.Create("DColorMixer", frame)

    mixer:Dock(FILL)
    mixer:DockMargin(0, 0, 0, 40)
    mixer:SetColor(color_ac)

    local button = vgui.Create("DButton", frame)

    button:Dock(BOTTOM)
    button:DockMargin(0, 10, 0, 0)
    button:SetText("Save color")

    button.DoClick = function ()
        color_ac = mixer:GetColor()
        frame:Close()
    end
end

hook.Add("AddToolMenuCategories", "CustomCategory", function ()
    spawnmenu.AddToolCategory("Utilities", "Stuff", "#Stuff")
end)

hook.Add("PopulateToolMenu", "CustomMenuSettings", function ()
    spawnmenu.AddToolMenuOption("Utilities", "Stuff", "HUD Color", "#HUD Color", "", "", function (panel)
        local mixer = vgui.Create("DColorMixer", panel)

        mixer:SetPos(0, 20)

        local button = vgui.Create("DButton", panel)

        button:SetText("Save")
        button:SetPos(100, 260)

        button.DoClick = function ()
            color_ac = mixer:GetColor()
        end
    end)
end)

concommand.Add("open_menu", changeColor)
