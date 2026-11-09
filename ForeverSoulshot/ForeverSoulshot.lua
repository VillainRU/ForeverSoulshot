local addonName = ...
local titleText = "Forever Soulshot"
ForeverSoulshotDB = type(ForeverSoulshotDB) == "table" and ForeverSoulshotDB or {}
local settings = ForeverSoulshotDB
settings.critical = nil
local soundOptions = {
    { key = "autoAttack", label = "Soulshot с автоатакой" },
    { key = "abilities", label = "Soulshot с атакующими умениями" },
}
for _, option in ipairs(soundOptions) do
    if settings[option.key] == nil then settings[option.key] = true end
end
local soundPath = "Interface\\AddOns\\" .. addonName .. "\\Sounds\\"
local weapon = Enum.ItemWeaponSubclass
local meleeSounds = {
    [weapon.Sword2H] = "greatsword",
    [weapon.Mace1H] = "mace",
    [weapon.Mace2H] = "mace",
    [weapon.Dagger] = "dagger",
}
local previews = {
    { sound = "greatsword", label = "Двуручный меч" },
    { sound = "mace", label = "Булава" },
    { sound = "dagger", label = "Кинжал" },
    { sound = "bow", label = "Лук" },
}
local swing = Enum.PlayerSwingType
local swingSlots = {
    [swing.MainHand] = 16,
    [swing.OffHand] = 17,
    [swing.Ranged] = 18,
}

local function spellNames(ids)
    local names = {}
    for _, id in ipairs(ids) do
        local name = C_Spell.GetSpellName(id)
        if name then names[name] = true end
    end
    return names
end

-- Spell names match ranked versions on localized clients.
local autoAttacks = spellNames({ 6603, 75, 5019 }) -- Attack, Auto Shot, Shoot
local nextSwingAttacks = spellNames({ 78, 845, 2973, 6807 }) -- Heroic Strike, Cleave, Raptor Strike, Maul
local areaAttacks = spellNames({ 6343, 1680 }) -- Thunder Clap, Whirlwind
local _, playerClass = UnitClass("player")

local function say(message)
    print(titleText .. ": " .. message)
end

local function play(sound)
    return PlaySoundFile(soundPath .. sound .. ".ogg", "SFX")
end

local function weaponSubclass(slot)
    local itemID = GetInventoryItemID("player", slot)
    if issecretvalue(itemID) or not itemID then return end
    local _, _, _, _, _, classID, subclassID = C_Item.GetItemInfoInstant(itemID)
    if not issecretvalue(classID) and not issecretvalue(subclassID) and classID == Enum.ItemClass.Weapon then
        return subclassID
    end
end

local function playAbility(spellID)
    if not settings.abilities or issecretvalue(spellID) or not spellID then return end
    local known = C_SpellBook.IsSpellKnownOrInSpellBook(spellID)
    if issecretvalue(known) or not known then return end

    local info = C_Spell.GetSpellInfo(spellID)
    if not info or autoAttacks[info.name] then return end
    local harmful = C_Spell.IsSpellHarmful(spellID)
    if (issecretvalue(harmful) or not harmful) and not areaAttacks[info.name] then return end

    local ranged = info.maxRange >= 20

    local sound = meleeSounds[weaponSubclass(swingSlots[swing.MainHand])]
    if nextSwingAttacks[info.name] and sound and settings.autoAttack then return end
    if playerClass == "HUNTER" and ranged and weaponSubclass(swingSlots[swing.Ranged]) == weapon.Bows then
        sound = "bow"
    end
    play(sound or "soulshot")
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_SWING")
frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
frame:SetScript("OnEvent", function(_, event, _, swingType, spellID)
    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        playAbility(spellID)
        return
    end
    if issecretvalue(swingType) then return end
    local slot = swingSlots[swingType]
    if not slot then return end
    if not settings.autoAttack then return end

    local subclass = weaponSubclass(slot)
    if swingType == swing.Ranged then
        if subclass == weapon.Bows then play("bow") end
    else
        local sound = meleeSounds[subclass]
        if sound then play(sound) end
    end
end)

local function preview(sound)
    if not play(sound) then
        say("Не удалось проиграть звук. Проверьте файлы аддона и громкость звуковых эффектов.")
    end
end

local function registerSettings()
    if not (Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory) then return end

    local panel = CreateFrame("Frame")
    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(titleText)

    local instructions = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    instructions:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
    instructions:SetWidth(420)
    instructions:SetJustifyH("LEFT")
    instructions:SetText("Выберите, когда проигрывать звуки Soulshot.")

    local lastOption = instructions
    for _, option in ipairs(soundOptions) do
        local key = option.key
        local check = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
        check:SetPoint("TOPLEFT", lastOption, "BOTTOMLEFT", 0, -4)
        check:SetSize(26, 26)
        check:SetChecked(settings[key])
        check:SetScript("OnClick", function(self)
            settings[key] = not not self:GetChecked()
        end)
        local label = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        label:SetPoint("LEFT", check, "RIGHT", 4, 0)
        label:SetText(option.label)
        lastOption = check
    end

    local function addButton(anchor, label, onClick)
        local button = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
        button:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -8)
        button:SetSize(210, 26)
        button:SetText(label)
        button:SetScript("OnClick", onClick)
        return button
    end

    local previewTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    previewTitle:SetPoint("TOPLEFT", lastOption, "BOTTOMLEFT", 0, -24)
    previewTitle:SetText("Проверка звуков")

    local anchor = previewTitle
    for _, entry in ipairs(previews) do
        local sound = entry.sound
        anchor = addButton(anchor, entry.label, function() preview(sound) end)
    end

    local category = Settings.RegisterCanvasLayoutCategory(panel, titleText)
    Settings.RegisterAddOnCategory(category)
    return category
end

local category = registerSettings()

SLASH_FOREVERSOULSHOT1 = "/soulshot"
SlashCmdList.FOREVERSOULSHOT = function(input)
    local command, argument = input:lower():match("^%s*(%S*)%s*(.-)%s*$")
    if command == "setup" then
        say("Для выбора и прослушивания звуков откройте /soulshot.")
        return
    elseif (command == "" or command == "options") and category and Settings.OpenToCategory then
        Settings.OpenToCategory(category:GetID())
        return
    elseif command == "test" then
        for _, entry in ipairs(previews) do
            if argument == entry.sound then
                preview(entry.sound)
                return
            end
        end
    end
    say("/soulshot options | /soulshot test greatsword, mace, dagger или bow")
end
