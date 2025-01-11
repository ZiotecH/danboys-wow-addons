local DBDT = _G["DBDT"]
local me = DBDT.name
local id = "ItemDataLoadResult_Hook"
local function gds(msg) DBDT:GenDebugString(me,id,msg) end
local sNIL = "|cFFFA8072NIL|r"


local function DebugLogging(_,_,EventData1,EventData2)
    EventData1 = DBDT:Nilcheck(EventData1,sNIL)
    EventData2 = DBDT:Nilcheck(EventData2,sNIL)
    DBDT:Debug(
        {
            ["Event"] = 
            "Item_Data_Load_Result",
            ["EventData1"] = EventData1,
            ["EventData2"]=EventData2
        },
        gds("Item Data:")
    )
end

local EventHook = CreateFrame("frame")
EventHook:SetScript("OnEvent",DebugLogging)
EventHook:RegisterEvent("ITEM_DATA_LOAD_RESULT")
-- EventHook:RegisterEvent("PLAYER_LOGIN")