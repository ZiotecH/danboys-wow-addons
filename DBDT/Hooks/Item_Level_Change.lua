local function UpdateStoredILvl(_,_,EventData)
    DBDT:Tablecheck("Dynamic",DBDT,true)
    DBDT:Tablecheck("AverageItemLevel",DBDT["Dynamic"],true)
    DBDT["Dynamic"]["AverageItemLevel"] = GetAverageItemLevel()
    if DBDT["DB_Dependencies"]["WeakAuras"] then
        --WeakAuras.ScanEvents("DB_ILVL_CHANGE")
    end
end

local UpdateFrame = CreateFrame("Frame")
UpdateFrame:SetScript("OnEvent",UpdateStoredILvl)
UpdateFrame:RegisterEvent("PLAYER_AVG_ITEM_LEVEL_UPDATE")
UpdateFrame:RegisterEvent("PLAYER_LOGIN")