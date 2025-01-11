local lookup = DBDT["FactionData"]["Lookup"]

local function FireReputationEvent(_,_,InputText)
    -- Todo: Add handler for input text and only fire updates for the ones that are relevant
    local factionID = 0
    local event_splitString = ""
    event_splitString = DBDT:Split(InputText, "+")
    event_splitString[1] = string.gsub(tostring(DBDT:Nilcheck(event_splitString[1])),"%s+$","")
    event_splitString[2] = string.gsub(tostring(DBDT:Nilcheck(event_splitString[2])),"^%s+","")
    factionID = DBDT:Numcheck(lookup[event_splitString[1]])
    --dp({InputText,event_splitString[1],event_splitString[2],factionID,"DB_REP_EVENT_"..tostring(factionID)})
    if DBDT:NE(factionID,0) then
        WeakAuras.ScanEvents("DB_REP_EVENT_"..tostring(factionID))
    else
        -- Maybe make a report or something?
    end
end


if DBDT["DB_Dependencies"]["WeakAuras"] then
    local ReputationEventFrame = CreateFrame("Frame")
    ReputationEventFrame:SetScript("OnEvent",FireReputationEvent);
    ReputationEventFrame:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
end