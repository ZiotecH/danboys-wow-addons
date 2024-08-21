local DBRT = _G["DBRT"]
local me = DBRT.name

function DBRT:SwitchTracked(factionID)
    C_Reputation.SetWatchedFactionByID(factionID)
end

local function TabardEvent(_,_,SlotID)
    local ItemLocation = DBDT:Nilcheck(ItemLocation:CreateFromEquipmentSlot(19))
    local equippedTabard = 0
    local currentlyWached = false
    local nextFaction = 0
    local nextFactionData = {}

    if EQ(SlotID,19) and NE(ItemLocation,false) then
        equippedTabard = DBDT:Nilcheck(C_Item.GetItemID(ItemLocation))
        currentlyWached = DBDT:Nilcheck(C_Reputation.GetWatchedFactionData())
        if equippedTabard then nextFaction = DBDT["FactionData"]["Tabards"][equippedTabard] end
        if NE(DBDT:Nilcheck(nextFaction,0),0) then
            nextFactionData = C_Reputation.GetFactionDataByID(nextFaction)
            if nextFactionData["currentStanding"] >= 42000 then nextFaction = 0 end
        end
    end

    DBRT:SwitchTracked(nextFaction)
end





local f = CreateFrame("Frame")
f:SetScript("OnEvent",TabardEvent);
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")