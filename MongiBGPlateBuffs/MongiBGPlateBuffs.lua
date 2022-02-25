local function print(output)
	DEFAULT_CHAT_FRAME:AddMessage(string.format("|cff00ffff[%s]|r %s", "MongiPlateBuffs", tostring(output)), 1, 1, 1)
end

local UpdateInterval = 1 / 100
local LastUpdate = 0

MongiPlateBuffs = CreateFrame("frame", "MongiPlateBuffs")
MongiPlateBuffs.OnEvent = function()
	this[event](MongiPlateBuffs, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
end

local function IsNamePlate(frame)
    if frame:GetObjectType() ~= "Button" then return nil end
    regions = frame:GetRegions()

    if not regions then return nil end
    if not regions.GetObjectType then return nil end
    if not regions.GetTexture then return nil end
    if regions:GetObjectType() ~= "Texture" then return nil end
    return regions:GetTexture() == "Interface\\Tooltips\\Nameplate-Border" or nil
end

function MongiPlateBuffs:AddBuffs(plate)
	local _, _, name = plate:GetRegions()
	local n = name:GetText()
	for i = 1, 5 do
		local debuff = UnitDebuff("target", i)
		if debuff and n == UnitName("target") then
			
			plate.buffs[i].icon:SetTexture(debuff)
			plate.buffs[i].icon:Show()
		else
			plate.buffs[i].icon:SetTexture("")
			plate.buffs[i].icon:Hide()
		end
	end
end

function MongiPlateBuffs:AddCast(plate)
	
end

function MongiPlateBuffs:CreateCastbar(plate)
	plate.castbar = CreateFrame("StatusBar", nil, plate)
	plate.castbar:SetPoint("CENTER", plate, "CENTER", 0, -22)
	plate.castbar:SetWidth(100)
	plate.castbar:SetHeight(10)
	plate.castbar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	plate.castbar:SetMinMaxValues(0,2)
	plate.castbar:SetValue(1)
	plate.castbar:SetStatusBarColor(1,1,0)
	plate.castbar:SetFrameLevel(1)
	
	plate.castbar.spark = plate.castbar:CreateTexture(nil, "ARTWORK")
	plate.castbar.spark:SetWidth(21)
	plate.castbar.spark:SetHeight(21)
	plate.castbar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
	plate.castbar.spark:SetBlendMode('ADD')
		
	plate.castbar.border = CreateFrame("Frame", nil, plate.castbar)
	plate.castbar.border:SetPoint("TOPLEFT", plate.castbar, "TOPLEFT", -2, 2)
	plate.castbar.border:SetPoint("BOTTOMRIGHT", plate.castbar, "BOTTOMRIGHT", 2, -2)
	plate.castbar.border:SetBackdrop({
		bgFile = "",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = false, tileSize = 10, edgeSize = 11,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	})
	plate.castbar.border:SetBackdropColor(0,0,0)
	plate.castbar.border:SetFrameLevel(2)
end

function MongiPlateBuffs:OnCreate(plate)
	plate.buffs = {}
	for i = 1, 5 do
		local width = 24
		local height = 24
		local xpos = (i-1)*(width +3)
		
		plate.buffs[i] = CreateFrame("frame", nil, plate)
		plate.buffs[i]:SetWidth(width)
		plate.buffs[i]:SetHeight(height)
		plate.buffs[i]:SetPoint("TOPLEFT", plate, "TOPLEFT", xpos, 21)
		plate.buffs[i].icon = plate.buffs[i]:CreateTexture(nil, "ARTWORK")
		plate.buffs[i].icon:SetAllPoints()
	end
	plate.created = true
end

function MongiPlateBuffs:OnUpdate()
	LastUpdate = LastUpdate + arg1
	if (LastUpdate > UpdateInterval) then
		local frames = { WorldFrame:GetChildren() }
		for _, plate in ipairs(frames) do
			if IsNamePlate(plate) and plate:IsVisible() then
				if not plate.created then 
					MongiPlateBuffs:OnCreate(plate)
					--MongiPlateBuffs:CreateCastbar(plate)
				end
				MongiPlateBuffs:AddBuffs(plate)
				--MongiPlateBuffs:AddCast(plate)
			end
		end
	LastUpdate = 0
	end
end

MongiPlateBuffs:SetScript("OnEvent", MongiPlateBuffs.OnEvent)
MongiPlateBuffs:SetScript("OnUpdate", MongiPlateBuffs.OnUpdate)