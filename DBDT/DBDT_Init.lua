-- I guess I'm putting init stuff here now.
-- Stolen from DevTool, thanks guys. :)
local _, addonTable = ... -- make use of the default addon namespace

---@class DBDT : AceAddon-3.0 @define DBDT_Main
addonTable.DBDT = LibStub("AceAddon-3.0"):NewAddon("DBDT")
local DBDT = addonTable.DBDT

-- add global reference to the addon object
_G["DBDT"] = addonTable.DBDT
local me = DBDT["name"]
local DBDebugTable = {}
DBDT["DBDebugTable"] = DBDebugTable
DBDT["DBDebugTable"]["Saved Colors"] = 0
DBDT["DBDebugTable"]["Character Info"] = {}
local fontList = {}
local SharedMedia = false
DBDT["PrintDebug"] = false                           --? <- PRINTDEBUG IS HERE :)
DBDT["QuickItemInfo"] = true
DBDT["ColorTable"] = {}
DBDT["StringTables"] = {}
DBDT["sindent"] = "▸"
DBDT["ListOfHearthstones"] = {}
DBDT["BuildInfo"] = {}
DBDT["Dynamic"] = {
    ["AverageItemLevel"] = 0
}
DBDT["RaceTime"] = 65
DBDebugTable["Console_Enabled"] = false

if LibStub then
    SharedMedia = LibStub("LibSharedMedia-3.0");
    fontList = {
        ["camb"] = SharedMedia:Fetch("font", "cambria"),
        ["math"] = SharedMedia:Fetch("font", "DejaVuMathTeXGyre"),
        ["dsans"] = SharedMedia:Fetch("font", "DejaVuSans"),
        ["code"] = SharedMedia:Fetch("font", "DejaVuSansCode"),
        ["dmono"] = SharedMedia:Fetch("font", "DejaVuSansMono"),
        ["mei"] = SharedMedia:Fetch("font", "meiryo"),
        ["noto"] = SharedMedia:Fetch("font", "NotoSans"),
        ["nmono"] = SharedMedia:Fetch("font", "NotoSansMono"),
        ["rmono"] = SharedMedia:Fetch("font", "RobotoMono"),
        ["seg"] = SharedMedia:Fetch("font", "segoeui"),
        ["ubun"] = SharedMedia:Fetch("font", "Ubuntu"),
        ["umono"] = SharedMedia:Fetch("font", "UbuntuMono"),
    }
end

DBDebugTable["SharedMedia"] = SharedMedia

-- DB_Dependencies setup
local DB_Dependencies = {
    ["DevTool"] = false,
    ["WeakAuras"] = false,
    ["!BugGrabber"] = false,
    ["Clique"] = false,
    ["Auctionator"] = false,
}

for key, value in pairs(DB_Dependencies) do
    DB_Dependencies[key] = (C_AddOns.IsAddOnLoaded(key) or false)
end

DBDT["DB_Dependencies"] = DB_Dependencies



-- Set min/max to known good numbers
DBDT["DBIntegers"] = {["min"] = -1e15,["max"] = 1e15} 


-- Some global variable stuff
DBDT["bCT"] = {
    [true] = 1,
    [false] = 0,
}