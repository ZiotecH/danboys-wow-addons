-- SETUP
local DBDT = _G["DBDT"]
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
-- VARIABLES

local tDT = DB_Dependencies["DevTool"]
local tWA = DB_Dependencies["WeakAuras"]
local tBG = DB_Dependencies["BugGrabber"]

local buildInfo = {}
buildInfo["buildVersion"], buildInfo["buildNumber"], buildInfo["buildDate"], buildInfo["interfaceVersion"], buildInfo["localizedVersion"], buildInfo["buildInfo"] = GetBuildInfo()
DBDT["buildInfo"] = buildInfo

-- ALIASED HELPER FUNCTIONS
local Nilcheck = DBDT.Nilcheck --(payload,"type")
local Typecheck = DBDT.Typecheck --(payload,"type")
local DBPrint = DBDT.DBPrint --(payload, printStart, printEnd, message, multi)

-- MAIN FUNCTIONS
function DBDT:StartTimer()
    if (DBDT:CheckTimer(true) == false) then
        DB_TIMED_EVENT = C_Timer.NewTimer(0.5, function()
            if tWA then
                WeakAuras.ScanEvents("DB_TIMED_EVENT");
            end
            DBDT.StartTimer()
        end,
        1)
    end
    DBDT:CheckTimer()
end

function DBDT:StopTimer()
    if (DBDT:CheckTimer(true) == true) then
        DB_TIMED_EVENT:Cancel()
    end
    DBDT:CheckTimer()
end

function DBDT:CheckTimer(internal)
    internal = DBDT:Nilcheck(internal)
    dbdt_timer_status["Timer"] = ((DB_TIMED_EVENT == false) or type(DB_TIMED_EVENT))
    if DB_TIMED_EVENT ~= false then
        dbdt_timer_status["IsCancelled"] = ((DB_TIMED_EVENT:IsCancelled() and true) or false)
    else
        dbdt_timer_status["IsCancelled"] = false
    end
    if (internal == false) and (DB_TIMED_EVENT ~= false) then
        DBDT:DBPrint(dbdt_timer_status,true,true,"DBDT - CheckTimer",false)
    end
    return ((DB_TIMED_EVENT ~= false and true) or false)
end

-------------------------------------------------
--                  INIT FUNC                  --
-------------------------------------------------
function DBDT:PrintInit()
    if tDT then
        DBDT:DBPrint({DB_Dependencies,DBDebugTable,buildInfo},f,f,gds("DBDT","INIT"),f)
    else
        DBDT:DBPrint(DB_Dependencies, t)
        DBDT:DBPrint(DBDebugTable, f, f)
        DBDT:DBPrint(buildInfo, f, t)
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
    	msg = msg:lower()
        local ml = DBDT:Split(msg," ")
        local m1 = ml[1]
        local dodb = (m1 == "debug")
        local dodp = (m1 == "dp")
        local dotd = (m1 == "tdebug")
        local doii = (m1 == "item")

        if dodb then
            DBDT:DBPrint(DBDT["DBDebugTable"],true,true,gds("DBDT","Console","Debug"))
        elseif dodp then
            dp(ml[2])
        elseif dotd then
            DBDT:TDebug()
        elseif doii then
            DBDT:ItemInfo(ml[2]) 
        else
            DBDT:DBPrint(
                {
                    ["Full Request"] = msg,
                    ["Split List"] = ml,
                },_,_,
                gds("Received invalid /db command")
            )
    	end
    end
    SLASH_DBDT1 = "/db"
end

-- Init function
local function Init()
    DBCol:Init()
    DBDT:PrintInit()
end

-- Call init() scripts
Init()