-- SETUP
local DBDT = _G["DBDT"]
local DBDebugTable = _G["DBDebugTable"]
local dt = false
local DB_TIMED_EVENT = false
_G["DB_TIMED_EVENT"] = DB_TIMED_EVENT
local dbdt_timer_status = {["Timer"] = DB_TIMED_EVENT, ["IsCancelled"] = false}
local DB_Dependencies = _G["DB_Dependencies"]

-- VARIABLES

local tDT = DB_Dependencies["DevTool"]
local tWA = DB_Dependencies["WeakAuras"]

local buildInfo = {}
buildInfo["buildVersion"], buildInfo["buildNumber"], buildInfo["buildDate"], buildInfo["interfaceVersion"], buildInfo["localizedVersion"], buildInfo["buildInfo"] = GetBuildInfo()

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

function DBDT:PrintInit()
    DBDT:DBPrint(DB_Dependencies, true, false, "DBDT - Dependencies", false)
    DBDT:DBPrint(DBDebugTable, false, false, "DBDT - Debug Table", false)
    DBDT:DBPrint(buildInfo, false, true, "DBDT - Build Info", false)
end


-- PROCESS
if tWA then DBDT.StartTimer() end
DBDT:PrintInit()