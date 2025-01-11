-- SETUP
local DBDT = _G["DBDT"]
local me = DBDT["name"]
local DBDebugTable = DBDT["DBDebugTable"]
local dt = false
local DB_TIMED_EVENT = false
DBDT["DB_TIMED_EVENT"] = DB_TIMED_EVENT
local dbdt_timer_status = {["Timer"] = DB_TIMED_EVENT, ["IsCancelled"] = false}
local DB_Dependencies = DBDT["DB_Dependencies"]
local t = true
local f = false
local function gds(s1,a1,o1)
    return DBDT:GenDebugString(s1,a1,o1)
end
local function qgds(a1,o1)
    return DBDT:GenDebugString(me,a1,o1)
end
-- VARIABLES

local tDT = DB_Dependencies["DevTool"]
local tWA = DB_Dependencies["WeakAuras"]
local tBG = DB_Dependencies["BugGrabber"]
local tCQ = DB_Dependencies["Clique"]

-- ALIASED HELPER FUNCTIONS
local Nilcheck = DBDT.Nilcheck --(payload,"type")
local Typecheck = DBDT.Typecheck --(payload,"type")
local DBPrint = DBDT.DBPrint --(payload, printStart, printEnd, message, multi)

-- MAIN FUNCTIONS
function DBDT:StartTimer()
    if DBDT:Not(DBDT:CheckTimer(true)) then
        DB_TIMED_EVENT = C_Timer.NewTicker(0.5, DBDT.FireEvent)
    end
    DBDT:CheckTimer()
end

function DBDT:StopTimer()
    if DBDT:CheckTimer(true) then DB_TIMED_EVENT = false end
    DBDT:CheckTimer()
end

function DBDT:CheckTimer(internal)
    internal = DBDT:Boolcheck(internal)
    DBDT["DB_TIMED_EVENT"] = DB_TIMED_EVENT
    return DBDT:Boolcheck(DB_TIMED_EVENT)
end

function DBDT:FireEvent()
    if tWA then WeakAuras.ScanEvents("DB_TIMED_EVENT") end
end

-------------------------------------------------
--                  INIT FUNC                  --
-------------------------------------------------
function DBDT:PrintInit()
    local Warnings = 0
    local ReportString = nil
    local WarnColor = DBDT["ColorTable"]["Salmon"]
    if DBDT:Boolcheck(DBDebugTable["Test Reports"]) then
        Warnings = DBDT:CountChildren(DBDebugTable["Test Reports"]["DB Global Init"])
    end
    if Warnings > 0 then ReportString = WarnColor:Format(Warnings) end
    DBDT:PrintFullBuild(false)

    local PT = {
        ["Dependencies"]    = DB_Dependencies,
        ["Debug Table"]     = DBDebugTable,
        ["Build Info"]      = DBDT["BuildInfo"],
        ["Data"] = {
            ["String Tables"]   = DBDT["StringTables"],
            ["Faction Data"]    = DBDT["FactionData"],
            ["Constants"]       = DBDT["CONSTANTS"],
        },
        ["ColorTable"]      = DBDT["ColorTable"],
    }
    if tDT then
        DBDT:DBPrint(PT,f,f,gds(me,"INIT",ReportString),f)
    else
        DBDT:DBPrint(DB_Dependencies, t)
        DBDT:DBPrint(DBDebugTable, f, f)
        DBDT:DBPrint(DBDT["buildInfo"], f, t)
    end
end

-- Tell DevTool to switch font.
if tDT then
    if not DevTool["codefont"] then
        DevTool["codefont"] = DBDT:GetFont("code")
    end
end

-- PROCESS
if tWA then DBDT.StartTimer() end

-- Check final variables
DBDebugTable["global_bools"] = {
    ["dbdt_loaded"] = _G["dbdt_loaded"],
    ["dt_loaded"]  = _G["dt_loaded"],
}

-- Set up slash commands
if SlashCmdList then
    SlashCmdList.DBDT = function(msg)
        local ml = DBDT:Split(msg," ")
        local m1 = ml[1]:lower()
        local dodb = DBDT:EQ(m1,"debug")
        local dodp = DBDT:EQ(m1,"dp")
        local dotd = DBDT:EQ(m1,"tdebug") or DBDT:EQ(m1,"tdb")
        local doii = DBDT:EQ(m1,"item")
        local doqc = DBDT:EQ(m1,"quest")
        local dotqii = DBDT:EQ(m1,"tqii")

        --dp({["ml"]=ml,["m1"]=m1,["dodb"]=dodb,["dodp"]=dodp,["dotd"]=dotd,["doii"]=doii,["doqc"]=doqc})

        if dodb then
            DBDT:DBPrint(DBDT["DBDebugTable"],true,true,qgds("Console","Debug"))
        elseif dodp then
            dp(ml[2])
        elseif dotd then
            DBDT:TDebug()
        elseif doii then
            local IID = DBDT:Numcheck(ml[2])
            DBDT:ItemInfo(IID,nil,false)
        elseif doqc then
            local QID = DBDT:Numcheck(ml[2])
            DBDT:QuestComplete(QID,true)
        elseif dotqii then
            DBDT:TQII()
        else
            DBDT:DBPrint(
                {
                    ["Full Request"] = msg,
                    ["Split List"] = ml,
                },_,_,
                qgds("Slash Commands","Received invalid /db command")
            )
    	end
    end
    SLASH_DBDT1 = "/db"
end

-- Init function
local function Init()
    DBCol:Init()
    DBDT:PrintInit()
    -- Import global bindings, because I'm lazy.
    if tCQ then
        local a,b = DBDT["StringTables"]["ExportStrings"]["Clique"],Clique:GetExportString()
        if DBDT:NE(a,b) then
            DBDT:Report("DBDT [Init]","Updated Clique profile.","Clique")
            Clique:ImportBindings(Clique:DecodeExportString(a))
        end
    end

    for key, value in pairs(DBDT["FactionData"]["Tabards"]) do
        DBDT:Tablecheck(value,DBDT["FactionData"]["Factions"],true)
        DBDT["FactionData"]["Factions"][value] = DBDT:Nilcheck(C_Reputation.GetFactionDataByID(value),false)
    end

    -- Switch to heroic on logon
    DBDT:SetDungeonDifficulty(2)
end

-- Call init() scripts
Init()