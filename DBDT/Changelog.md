# Comprehensive Changelog

## [2024-08-21] - TBD

* `DBRT.toc`
  * Added `DBRT_TabardInfo.lua`
  * Added `DBDT` as a dependency
  * Updated Interface from `100000` => `110002`

* `DBRT.lua`
  * Added AceLib as libraries
  
  * Set up initialisation as in `DBDT`
  
  * Added shorthands `t`/`f` for `true`/`false`
  
  * Added local aliases `gds` and `full_gds` for `DBDT:GenDebugString`
    * `gds` uses `DBRT` as `object`
    * `full_gds` is unchanged
  
  * Added `DBRT:GetCutOff(Standing)`
    * Takes in `Standing` as a `string` or `number` and checks `DBDT[StringTables]["StandingID"]` for said standing's cutoff value.
    * Returns a number
  
  * Added `DBRT:GetRepColor(Standing)`
    * Takes in `Standing`as a `string` and requests the normalised color from `DBCol:GC`
    * Returns a table
  
  * Added `DBRT:NormaliseReputationValue(InputValue)`
    * Takes in a `number`, adds `42000` and returns the result.
  
  * Added alias `DBRT:p42(n1)` for `DBRT:NormaliseReputationValue`
  
  * Added global alias `p42(n1)` for `DBRT:NormaliseReputationValue`
  
  * Added a call to `DBDT:Report()` to inform it's been loaded.

* `DBRT_TabarInfo.lua`
  * Added `DBRT:SwitchTracked(factionID)`
    * Takes in `factionID` a `number` and supplies it to `C_Reputation.SetWtachedFactionByID(factionID)`
    * If `factionID == 0` the bar will be hidden
  
  * Added `TabardEvent(_,_,SlotID)`
    * Takes in `SlotID` as a `number`
    * Grabs information about which item is equipped in slot 19 (Tabards) and if it's not defaulted to `0` it checks `DBDT["FactionData"]["Tabars"]` for the `itemID` of the equipped tabard
    * If the `itemID` exists it grabs the corresponding `factionID` and checks whether or not the `currentStanding` is below `42k` (not normalised)
    * If `currentStanding >= 42000` it sets `nextFaction` to `0`
    * Passes `nextFaction` along to `DBRT:SwitchTracked`
    * Added a register for the event `PLAYER_EQUIPMENT_CHANGED` to call `TabardEvent`

* `DBDT.toc`
  * Added `DBDT_Data.lua`
  * Updated `Version` to `0.2a`

* `DBDT_Main.lua`
  * Added alias `me` for `DBDT`
  
  * Moved `buildInfo` into `DBDT["DBDebugTable"]["BuildInfo"]`
  
  * Added a check for whether or not `Clique` is marked as loaded
  
  * `DBDT:StartTimer()`
    * Changed `C_Timer.NewTimer` to `C_Timer.NewTicker`
  
  * `DBDT:StopTimer()`
    * Since the timer is now a ticker it simply changes it to `false`
  
  * `DBDT:CheckTimer()`
    * Removed practically everything, now simply updates `DBDT["DB_TIMED_EVENT"]` to be equal to local `DB_TIMED_EVENT` and returns `true`/`false` if it's running or not
  
  * Added `DBDT:FireEvent()`
    * Moved the call to WeakAuras over from `DBDT:StartTimer()` to a separate function to make handling and debugging easier
  
  * `DBDT:PrintInit()`
    * Reworked how it reports operational status after loading
    * It now checks for warnings in `DBDT["DBDebugTable"]["Test Reports"]["DB Global Init"]` and appends to the `ReportString`/table name sent to `DevTool`
    * Now includes more data in the nested report.
  
  * Reworked slash commands
    * Removed `msg = msg:lower()` since it messed up a few things
    * Added `:lower()` to `ml[1]` so command calls are still  case-insensitive
    * Changed the comparisons to use `DBDT:EQ` as it's slightly less typing
    * Changed `ItemInfo` command to sanitise the inputdata as a number
    * Added `QuestComplete` command
  
  * `Init()`
    * Added check for `Clique`
    * If `Clique` is loaded it checks if the profile matches that stored in `DBDT["StringTables"]["ExportStrings"]["Clique"]`
    * If they do not match it automatically applies the stored one
    * Added call to `DBDT:SetDungeonDifficulty(2)` to automatically change all dungeons to `heroic` on login/reload.

* `DBDT_Helpers.lua`
  * Moved `me` further down in the file
  
  * Changed `@class DBDT` to not reference DevTool anymore, oops
  
  * Added `DBDT["DBDebugTable"]["Character Info"] = {}` as a test
  
  * Added a comment to `DBDT["PrintDebug"]` to make it easier to see in the list
  
  * Added `DBDT["StringTables"] = {}`
  
  * Moved `buildInfo` from `DBDT_Main.lua` here, sets `DBDT["BuildInfo"]` to same reference
  
  * Added `DBDebugTable["Console_Enabled"] = false` as a test
  
  * Added `Clique` as an optional depdency
  
  * `DBDT:TDebug()`
    * Changed function to use `DBDT:Not()` instead of doing it as `(not DBDT["PrintDebug"])`, this has more checks and bounds
  
  * `dp()`
    * Changed to report datatype passed into it
  
  * Added `DBDT:InitVars(n1,payload)`
    * Sanitises `n1` to be a number
    * If `n1 == 0` returns `nil`
    * If `n1 == 1` returns `payload`
    * If `n1 > 1` returns `payload` as `n1` separate values
      * e.g. `3,false` => `false,false,false`
  
  * `DBDT:PrintHelp()`
    * Added reminder to update list of functions and their help material
  
  * Added `DBDT:CastHearth()`
    * Added for future use/testing
  
  * Added `DBDT:GetHearths()`
    * Added for future use/testing
  
  * Added `DBDT:Not(payload)`
    * Returns `true` or `false` depending on input
      * If `payload` is a `boolean`, returns opposite
      * If `payload` is `nil`, returns true
      * If `payload` is anything else, returns `false`
  
  * Added `DBDT:Flip(payload)`
    * Takes in any value and tries to revrse it
      * If `payload` is a `boolean`, returns opposite
      * If `payload` is a `number`, returns `number * -1`
      * If `payload` is a `string`, returns `string.reverse(payload)`
      * If `payload` is a `table`, returns the table as is
        * Going to try to figure out how to properly reverse this
      * If `payload` is anything else, returns `true`
  
  * `DBDT:Nilcheck()`
    * Added input `returnValue`, moved `returnType` to third input
    * If `returnValue` is specified it returns `returnValue` when `payload` is `nil`
    * Added `nil` as a `returnType`
    * Added check for if `returnType` is invalid, returns `false` if it is
  
  * `DBDT:Boolcheck()`
    * Added `passthrough` as an input
      * If `passthrough` is `true` returns any `boolean` that is passed as `payload`
      * If `passthrough` is unset returns `true` if a `payload` is of type `boolean`
  
  * `DBDT:Numcheck()`
    * Added `fallback` as an input
      * If `fallback` is set to a `number` it uses it as the return for when `payload` is not a `number`
    * Changed to use `DBDT:EQ`
    * Changed to accept `string`s as input and try to parse it as a `number`
      * If it's a valid number it's returned
    * Fixed accidental change
      * Accidental change: `return fallback` to `return payload`
      * Fixed to: `return fallback`
    * Added nilcheck for `fallback`, defaults to `0`
      * Changed to typecheck, only accepts `number` now
  
  * Added `DBDT:Stringcheck(payload)`
    * If `payload` is a `string`, returns it
    * If `payload` isn't a `string`, returns false
    * Added `fallback` as an input
      * Nilchecks `fallback`, defaults to `false`
      * Changed function to return `fallback` instead of just `false`
    * Changed name from `StringCheck` to `Stringcheck`
      * Camel case was a typo
  
  * Added `DBDT:TableCheck(Table,Parent,Create)`
    * Takes in `Table` as a `string`
    * Takes in `Parent` as a `table`
    * Takes in `Create` as a `boolean`
    * Checks `Parent` for the existance of `Table`
      * If `Table` isn't a `string`; returns `false`
      * If `Parent` isn't a `table`; returns `false`
        * If `Create` is `true` and `Table` does not exist; creates it and returns `true`
      * Returns `DBDT:Boolcheck(Parent[Table])`
  
  * Added `DBDT:TestValue(payload,reverse,ReportFailure,Category)`
    * Takes in `payload` and does a Boolcheck on it
    * Takes in `reverse` as a boolean
      * If `reverse` is `true`; returns the opposite result
    * Takes in `ReportFailure` as a boolean
    * Takes in `Category` as a string
    * If `payload` is interpreted as `false` and;
      * If `DBDT["PrintDebug"] == true`; passes the result into `DBPrint`
      * ~~If `ReportFailure`; saves a report into `DBDT["DBDebugTable"]`~~
    * Returns `payload` interpreted as a `boolean`
    * Added `ValidPayload` as local variable
      * Nilchecks `payload`, defaults to `INVALID_PAYLOAD_INPUT`
      * Changed report to check for `INVALID_PAYLOAD_INPUT` instead of `false`
        * Checking for `false` in a `true`/`false` case was a mistake
  
  * Added `DBDT:Report(Sender,Payload,Category)`
    * Checks if `DBDT["DBDebugTable"]["Reports"]` exists, creates it if `false`
    * Takes in `Category` as a `string`
      * Stringchecked, defaulted to `Misc`
    * Takes in `Sender` as a `string`
      * Stringchecked, defaulted to `Invalid`
    * Takes in `Payload` as anything
      * Nilcheked, defaulted to `Invalid`
    * Checks if `Sender` or `Payload` has been changed
      * If either `Sender` or `Payload` is set to `Invalid` and either have been changed `ValidReport` is set to `false`
      * If not; `ValidReport` is set to `true`
    * If `ValidReport` is `true`
      * Checks `DBDT["DBDebugTable"]["Reports"]` for `Category`
        * If `false`, creates it
      * Sets `Target` to reference of above `table`
      * Inserts a table to `Target` with `Sender`, `Payload` and a timestamp
    * If `ValidReport` is `false`
      * Calls `DBDT:Warn("Reprot","Invalid report!)`
  
  * Added `DBDT:Warn(Sender,Message)`
    * Takes in `Sender` and `Message` as strings
    * Calls `DBDT:DBPrint()` with `" "` as the input and `Message` as title
    * Unfinished, going to work on later
  
  * `DBDT:Clamp()`
    * Restructured Nilchecks
      * Set Nilcheck for `value` to return `0`
      * Set Nilcheck for `vmin` to return `DB_Integers["min"]`
      * Set Nilcheck for `vmax` to return `DB_Integers["max"]`
    * Added debugging messages
      * Disabled debugging messages
    * Added checks for types of all imports
      * If any passed value isn't a `number`; returns `0`
    * Changed `vmin == vmax` to use `EQ`
      * Changed `vmin` to be set to `DB_Integers["min"]`
      * Changed `vmax` to be set to `DB_Integers["max"]`
  
  * `DBDT:SetPrecision()`
    * Added `AsString` as a `boolean` input
      * Boolchecked
    * Added a Numcheck to `value`; defaults to 0
    * Added a Numcheck to `precicion`; defaults to 4
    * Added `local ReturnString` as temporary variable for result
    * Changed `return` to use `ReturnString`
      * If `AsString` is `true`; returns `string`
      * If `AsString` is `false`; returns `number`
  
  * `DBDT:TimeStamp()`
    * Added `StringColor` as an input
      * Stringchecked; defaults to `DarkGray`
    * Added `FFA9A9A9` (DarkGray) as fallback
    * If `StringColor` is a valid color; uses said color for formatting
    * If `StringColor` is an invalid color; uses fallback
  
  * Added `DBDT:TableHasValue(t1,v1)`
    * Takes in `t1` as a `table`
    * Takes in `v1` as anything
    * If `v1 != nil` and `t1` is a `table` then;
      * Loops through `t1` and checks if any of the values are equal to `v1`
  
  * `DBDT:ItemInfo()`
    * Added `DoReturn` as a `boolean` input
    * Added a check for whether or not `itemID` is an existing `itemID`
    * Changed ouput
      * Instead of just returning the base `itemInfo` structure it now returns a table of several values;
        * `ItemData` => `RawData`
        * `Name`: Item name
        * `Strings` = `table`
          * `Bound`: Bindtype of item
          * `itemType`: Item type (e.g. "Armor","Weapon", etc.)
          * `itemSubType`: Item subtype (e.g. "Leather","Main Hand", etc.)
          * `Price`: Item value formatted as gold/silver/copper
          * `Expansion`: The name of which expansion the item is from
          * `Quality`: Item quality (e.g. "Poor","Common", etc.)
        * `Numbers` = `table`
          * `bindID`: Numerical representation of bindtype
          * `classID`: Numerical representation of item class
          * `subclassID`: Numerical representation of item subclass
          * `itemLevel`: Itemlevel of item
          * `expansionID`: Numerical representation of which expansion the item is from
          * `value`: Raw numerical value of item
        * `Booleans` = `table`
          * `Crafting Reagent`: Whether or not the item is flagged as a reagent
          * `Is Set Item`: Whether or not the item is in a set
    * Added check for whether or not `s7` (item name) is returned as `nil`
      * If `s7 != nil`
        * If `doReturn`; returns table of item info
        * If `!doReturn`; prints table of item info into `DevTool`
      * If `s7 == nil`
        * If `doReturn`; returns `false`
        * If `!doReturn`; prints `false` info into `DevTool` with `itemID` in title

  * Added `DBDT:BuffInfo(unitToken,index)`
    * Takes in `unitToken` as anything
      * Nilchecked, defaults to `player`
    * Takes in `index` as a `number`
      * Numchecked, defaults to `0`
    * If `index == 0`
      * Loops through all (de)buffs of `unitToken` and adds to a table
    * If `index != 0`
      Grabs (de)buff of `index` and adds to a table
    * Returns table of buffs and debuffs

  * `DBDT:GenDebugString()`
    * Reworked to Boolcheck `object` instead of Nilcheck, no passthrough
    * Reworked `id`
      * No longer obligatory
      * Boolchecked, no passthrough
      * If valid, adds to string
    * Reworked `message`
      * Boolchecked, passthrough
      * If `true`, adds to string

  * `DBDT:HF()`
    * Changed to use Numcheck

  * `DBDT:ColorHelper()`
    * Added `FriendlyName` as `string` input
      * Stringchecked, defaults to `nil`
    * Added `Category` as `string` input
      * Stringchecked, defaults to `false`
    * Some formatting changes, probably from machine formatting
    * Added `Format()` to generated color
      * Returns a `string` formatted to use the color
    * Added `Example` to color object, formatted to `Example String` using color

  * `DBDT:AddColor()`
    * Added `category` as input

  * `DBDT:TestColor()`
    * Changed printed value to `true`
    * Changed title to `[timestamp] [example text]`

  * `DBDT:Indent()`
    * Changed `n1` to be Numchecked
    * Changed `ret` construction
      * Cleaned up

  * Added `DBDT:Exp(ExpansionID)`
    * Takes in `ExpansionID` as a `number` and returns the name for it

  * Added `DBDT:Qua(QualityID)`
    * Takes in `QualityID` as a `number` and returns the name for it

  * Added `DBDT:Bin(BindID)`
    * Takes in `BindID` as a `number` and returns the description for it

  * Added `DBDT:ItemCheck(ItemInfo)`
    * Returns a blank item for now, probably being removed

  * Added `DBDT:GetSpec(class,spec,DoPrint)`
    * Takes in `DoPrint` as a `boolean`
      * Boolchecked, passthrough
    * Takes in `class` as a string
      * Stringchecked, defaults to `false`
    * Takes in `spec` as a string
      * Stringchecked, defaults to `false`
    * Checks if `class` and `spec` is saved
      * Returns import string for `spec` of `class` if it exists
      * Returns a table of all specs for `class` if `spec` is `false`
      * Returns a table of all specs for all classes if `class` is false
    * If `doPrint` is `true`; prints result to chat window
    * If `doPrint` is `false`; sends result to `DevTool`
  
  * Added `DBDT:SetSpec(class,spec)`
    * Currently does nothing, haven't figured out how to programatically import spec builds
  
  * Added `DBDT:PrintFullBuild(print)`
    * Takes in `print` as a `boolean`
      * Boolchecked, passthrough
    
    * Generates a table of relevant build information
      * `GetBuildInfo`: Standard Build Information
      * `Is64BitClient`: Is the client 64bit?
      * `IsBetaBuild`: Is the client a beta build?
      * `IsLinuxClient`: Is the client built for linux?
      * `IsMacClient`: Is the client built for mac?
      * `IsPublicBuild`: Is the client for public use?
      * `IsWindowsClient`: Is the client built for windows?
      * `SupportsClipCursor`: Does the client support ClipCursor? (???)
    
    * Sets `DBDT["BuildInfo"]` to above table

    * If `doPrint` is `true`; posts table to `DevTool`

  * Added `DBDT:SetDungeonDiffuclty(difficultyID)`
    * Takes in `difficultyID` as a `number` or `string`
      * Typechecked
    
    * If `difficultyID != CurrentDifficultyID`; sets dungeon difficulty
    
    * If `DBDT["PrintDebug"]`; prints debug info to `DevTool`

  * Added `DBDT:SetRaidDifficulty(difficultyID)`
    * Takes in `difficultyID` as a `number` or `string`
      * Typechecked
    
    * If `difficultyID != CurrentDifficultyID`; sets raid difficulty
    
    * If `DBDT["PrintDebug"]`; prints debug info to `DevTool`

  * Added `DBDT:GetNumFactions()`
    * Returns number of faction entries in player reputation book
  
  * Added `DBDT:CloneTable(SourceTable)`
    * Takes in `SourceTable` as a `table`
    
    * Loops through all key-value pairs in `SourceTable` and adds them to a temporary table

    * Returns resulting table
  
  * Added `DBDT:GenerateFactionIndex(FactionTable)`
    * Does nothing, planned for future use
  
  * Added `DBDT:GetAllKnownFactions()`
    * Generates a table of each faction, nested into expansions/groups, the player knows and sends to `DevTool`
  
  * Added `DBDT:QuestComplete(QuestID,DoPrint)`
    * Takes in `QuestID` as a `number`
      * Numchecked, defaults to `0`
    
    * Takes in `DoPrint` as a `boolean`
      * Boolchecked, passthrough
    
    * If `QuestID` isn't `0`; Checks if `QuestID` has been completed
      * If `DoPrint` is `true`; prints information to chat window
      * If `DoPrint` is `false`; adds a report of information
    
    * If `DBDT["PrintDebug"]`; prints debug information to `DevTool`

  * Added `DBDT:QC(QuestID)`
    * Alias for `DBDT:QestComplete(QuestID,true)`

  * Added `DBDT:Dump(src)`
    * Takes in `src` as a `string`
      * Stringchecked, defaults to `nil`
    
    * Generates a table with debug information;
      * `Debug Table`: Full `DBDT["DBDebugTable"]`
      * `Data` = `table`
        * `StringTables`: Full `DBDT["StringTables"]`
        * `FactionData`: Full `DBDT["FactionData"]`
        * `CONSTANTS`: Full `DBDT["CONSTANTS"]`
      * `Booleans` = `table`
        * `PrintDebug`: Value of `DBDT["PrintDebug"]`
        * `Dependencies`: Full `DBDT["DB_Dependencies"]`
      * `BuildInfo`: Full `DBDT["BuildInfo"]`
      * `Integers`: Full `DBDT["Integers"]`
      * `Color Table` = `table`
        * `Full Table`: Full `DBDT["ColorTable"]`
        * `Categorised`: Full `DBCol["ColorTable]`
    
  * Added `DBDT:CallReload(WaitTime)`
    * Takes in `WaitTime` as a `number`
      * Numchecked, defaults to `0.5`
    
    * Calls `ReloadUI()` after `WaitTime` seconds

  * Added `DBDT:GenFactionData(factionID,expansionID,factionName,zoneIDs,allegiance)`
    * Takes in `factionID` as a `number`
      * Numchecked, defaults to `0`
      * Clamped between `0` and `DBDT["DB_Integers"]["max"]`
    
    * Takes in `expansionID` as a `number`
      * Numchecked, defaults to `0`
      * Clamped between `0` and `11`
    
    * Takes in `factionName` as a `string`
      * Nilchecked, defaults to `false`
    
    * Takes in `zoneIDs` as a `table`
      * Nilchecked, defaults to `{}`
    
    * Takes in `allegiance` as a `string`
      * Stringchecked, defaults to `n`
    
    * If `factionID > 0`
      * Fetches faction information for `factionID`
      * Checks if faction is already saved
      * If not already saved
        * Nilchecks fetched information, if `true` adds to saved factions
      * If already saved
        * Prints debug info about it being saved
          * Changing to a report later
      * If fetched information is `false`, returns `false`

  * Added `DBDT:GrabCharInfo(unitToken)`
    * Takes in `unitToken` as a `string`
      * Stringchecked, defaults to `player`
    
    * Grabs `name` and `server` for `unitToken`

    * Tablechecks for `server` in `DBDT["DBDebugTable"]["Character Info"]`, creating it if `false`
    
    * Tablechecks for `name` in `server`
      * Prints debug message if true
      * Adds character information if `false`
        * Adds Name
        * Adds Level
        * Adds Class
        * Adds Race 
    
  * Added `DBDT:ZoneIDHelper(zoneID,checkChildren)`
    * Takes in `zoneID` as a `number`
      * Numchecked, defaults to 1 (Durotar)
    
    * Takes in `checkChildren`
      * Boolchecked, passthrough
    
    * Returns a `table`
      * `zoneID` = `checkChildren`
  
  * Added `DBDT:ToggleConsoleKey(key)`
    * Takes in `key` as a `string`
      * Stringchecked, defaults to `false`

    * If `DBDT["Console_Enabled]` is `true`
      * Sets `ConsoleKey` to `nil`
      * Sets `DBDT["Console_Enabled]` to `false`
    
    * If `DBDT["Console_Enabled]` is `false`
      * If `key` is `true`
        * Sets `ConsoleKey` to `key`
      * If `key` is `false`
        * Sets `ConsoleKey` to `x`
      * Sets `DBDT["Console_Enabled]` to `true`

    * Prints value of `DBDT["Console_Enabled]` to `DevTool`
      * Going to rework into a report later
    
  * Global exports
    * Changed all exports to check for the existance objecs with the same global id
    * Only sets them if nothing exists
    * Added;
      * `Not`
      * `Flip`
      * `Boolcheck`
      * `Tablecheck`
      * `Stringcheck`
      * `Test` as alias for `DBDT:TestValue`
      * `Timestamp`
      * `GetAllKnownFactions`
      * `DDiff` as alias for `DBDT:SetDungeonDifficulty`
      * `RDiff` as alias for `DBDT:SetRaidDifficulty`

* `DBDT_DBCol.lua`
  * Moved some variables further down
  * Added `t`,`f` as aliases for `true`,`false`
  * Added `me` as alias for `"DBCol"`
  * Added `gds(a1,o1)` as alias for `DBDT:GenDevbugString(me,a1,o1)`
  
  * Added `DBCol:PE(category)`
    * Takes in `category` as a `string`
      * Stringchecked, defaults to `false`
    * Checks for `category` in the categorised color table
      * If found, prints an example string for all colors in `category` to `DevTool`
      * If not found, prints `false` to `DevTool`

    * If `category` is false, prints `false` with the title `Invalid Input`
  
  * `DBCol:Init()`
    * Now resets `DBDT["ColorTable]` and `DBDT["DBDebugTable"]["SavedColors"]` before adding colors
    * Reformatted to be able to hide the long list of colors
    * Added a category to each color
    * Added 23 new colors to the following categories
      * `Reputation Headers`
        * Added `FactionHeader`
        * Added `FactionSubHeader`
        * Added `FactionTitle`
        * Added `FactionSubTitle`
        * Added `EmptyHeader`
      
      * `Standing`
        * Added `Hated`
        * Added `Hostile`
        * Added `Unfriendly`
        * Added `Neutral`
        * Added `Friendly`
        * Added `Honored`
        * Added `Revered`
        * Added `Exalted`
        * Added `Maxed`
      
      * `Quality`
        * Added `Poor`
        * Added `Common`
        * Added `Uncommon`
        * Added `Rare`
        * Added `Epic`
        * Added `Legendary`
        * Added `Artifact`
        * Added `Heirloom`
        * Added `WoW Token`
  
  * `DBDT_Data.lua`
    * Added `StringTables` as a `table`
      * `ExpansionID`: List of all expansion names indexed by expansion ID
      * `QualityID`: List of all quality descriptors indexed by quality ID
      * `DifficultyID` = `table`
        * `Normal` = 1
        * `Heroic` = 2
        * `Mythic` = 3
        * Needs to be reworked for (legacy)raids. Currently only matches dungeon difficulties
      * `BindID`: List of all binding type descriptors indexed by bindtype ID
      * `StandingID`: List of all standing (reaction) descriptors indexed by reaction ID
      * `BlankItem`: Generic item info table
      * `ExportStrings` = `table`
        * `Clique`: Import string for universal keybinds
        * `Specs`: List of saved import strings for each class/spec combo, not filled out yet
      * `ReputationHeaders`: List of headers for use with `GetAllKnownFactions`
    
    * Added `FactionData` as a `table`
      * `Tabards`: List of `factionID`s indexed by their corrosponding tabard's `itemID`
      * `Factions`: List of factions, indexed by their `factionID` as a `table`
        * `Name`: Name of the faction
        * `Expansion`: Table
          * `Name`: Name of the expansion
          * `ID`: ID of the expansion
        * `ZoneIDs`: Table of `booleans` denoting whether to be relevant is child zones, indexed by their `zoneID`
        * `Allegiance`: String representation of allegiance, valid inputs are `Neutral`,`Horde`,`Alliance`
    
    * Added `CONSTANTS` as a `table`
      * `QualityColors`: Table of colors indexed by their `QualityID`
      * `ReputationCutOffs`: Table of cutoff values indexed by their corrosponding `standing` descriptor

    * Added a loop through each `QualityColor` to initialise them
    * Added a check for `CONSTANTS` as a global variable, sets it to `DBDT["CONSTANTS"]` if `false`

## [2024-08-15](71b775be17b1db24d7cce7ede602cfd4a76d6291)

* `DBDT.toc`
  * Updated Interface to `110002`
  * Changed version from `0.1a` to `0.1b`
  * Added OptionalDep `!BugGrabber`
  * Added `DBDT_Col.lua`

* `DBDT_Main.lua`
  * Added shorthands `t,f` for `true,false`
  * Added alias `gds` for `DBDT:GenDebugString()`
  * `DBDT:PrintInit()`
    * Added check for `DevTool` and clumped all debug data into one table if so
    * Removed bloat from fallback mode
  * Added check for `global_bools`
  * Added `SlashCmdList`
    * Added `/db` as `SLASH_DBDT1`
    * Added command for `dp(a1)`
    * Added command for `DBDT:TDebug()`
    * Added command for `DBDT:ItemInfo(n1)`
    * Added fallback for invalid commands
  * Added function `Init()`
    * Moved `DBDT:PrintInit()` here
    * Added a call for `DBCol:Init()`
  * Changed init section to call `Init()`

* `DBDT_Helpers.lua`
  * Added `me` as alias for `"DBDT"`
  * Added `"Saved Colors"` to `DBDT["DBDebugTable"]`
  * Removed `"Count"` from `DBDT["ColorTable]`
  * Moved `sindent` to `DBDT["sindent"]`, removed whitespace.
  * Added `si` as alias for `DBDT["sindent"]`
  * Added shorthands `t,f` for `true,false`
  * Added `["!BugGrabber"]` to `DB_Dependencies`

  * `DBDT:TDebug()`
     * Removed local copy of `DBDT["PrintDebug"]`
     * Changed `DBPrint()` call to match.

  * Added global function `dp(InputData)`
     * Function prints whatever is passed via `DBDT:DBPrint()` with "Console" as the ID.

  * Added `DBDT:Boolcheck(payload)`
     * Returns `false` if `payload` is `nil` or `false`
     * Returns `true` otherwise

  * Added `DBDT:Timestamp()`
     * Returns a timestamp in the format `[00:00:00]` with the color `DarkGray`
   
  * Added `DBDT:PadSpace(v1)`
     * Returns `v1` many blank spaces

  * `DBDT:GenDebugString()`
     * Changed `correctformat` from `(object and id)` to just `(object and true)`
     * Added a timestamp to the generated string

  * Added `gds` as alias for `DBDT:GenDebugString()`

  * `DBDT:ColorHelper()`
     * Added functions to resulting table
       * `GetHex()` returns `["hex"]["argb"]`
       * `GetNorm()` returns each value of `["normalised"]`
       * `GetRGB()` returns each value of `["rgba"]`
       * `Get()` returns `["hex"]["argb]`
    
  * Added `DBDT:AddColor(r,g,b,a)`
    * Adds the specified color to the `DBDT["ColorTable]`
    * Updates `DBDT["DBDebugTable]["Saved Colors"]`
  
  * Added `DBDT:TestColor(name)`
    * Prints a line with the specified color if it exists
    * Displays all existing colors if no name is passed
  
  * Added `DBDT:TestFont(font)`
    * Changes `DevTool`'s font to the specified one and prints lines with the indent
  
  * Added `DBDT:CountChildren(t1)`
    * If `t1` is a table it returns the number of elements.
    * Does _NOT_ recurse.

  * Added `DBDT:Increment(n1,n2)`
    * Checks if passed values exist, else sets to `0`
    * Adds `n1` to `n2` and returns the result.

  * Added `DBDT:Indent(n1,ts)`
    * Checks if `n1` is a Number, returns `0` if not
    * Clamps `n1` to `minVal` and `maxVal` if `inf`
    * Checks if `t1` is a bool
    * Adds a trailing space if `ts` is `true`
    * Returns the `DBDT["sindent"]` with `v1` padding

  * Added global aliases for some functions
    * `Nilcheck()` = `DBDT:Nilcheck()`
    * `Typecheck()` = `DBDT:Typecheck()`
    * `Numcheck()` = `DBDT:Numcheck()`
    * `Boolcheck()` = `DBDT:Boolcheck()`
    * `SetPrecision()` = `DBDT:SetPrecision()`
    * `Split()` = `DBDT:Split()`
    * `SetPower()` = `DBDT:SetPower()`
    * `GetPercent()` = `DBDT:GetPercent()`
    * `RTC()` = `DBDT:RTC()`
    * `EQ()` = `DBDT:EQ()`
    * `NE()` = `DBDT:NE()`
    * `inc()` = `DBDT:Increment()`

  * Added call to `DBDT:FindMinMax(5000)["value"]` to set `DB_Integers` accordingly.
  * Added `_G["dbdt_loaded"] = true` to announce to other AddOns that we're up and running

  * Moved all color-related things to `DBDT_DBCol.lua`

* `DBDT_DBCol.lua`
  * Created file
  * Added `bDebug = false` for potential future use
  * Added local alias `colTable` for `DBDT["ColorTable"]`
  * Added local alias `dbTable` for `DBDT["DBDebugTable]`
  * Added function `cDebug()` to update `bDebug`
  * Added shorthands `t,f` for `true,false`
  * Added local alias `gds` for `DBDT:GenDebugString`
  * Added function `DBCol:Init()`
    * Clears `DBDT["ColorTable]`
    * Resets `DBDT["DBDebugTable]["Saved Colors"]` to `0`
    * Moved all `DBDT:AddColor` calls into `DBCol:Init()`
    * Updates `DBCol["ColorTable"]` to match `DBDT["ColorTable"]`
    * Calls `cDebug()`
    * Prints `DBDT["ColorTable"]` if `bDebug` is `true`