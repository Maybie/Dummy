local LIBRARY_URL = "https://raw.githubusercontent.com/Maybie/Dummy/refs/heads/main/Library/Compkiller.luau"
assert(type(loadstring) == "function", "This example requires loadstring")
local loaded, result = pcall(function()
    return assert(loadstring(game:HttpGet(LIBRARY_URL)))()
end)
assert(loaded, "Failed to load Compkiller: " .. tostring(result))
local UI = result
UI:DefineDependencies({
    DemoMissing = { "__compkiller_example_missing_api__" },
    Hooks = { "hookmetamethod", "newcclosure" },
    Connections = { "getconnections" },
})

local ENV = type(getgenv) == "function" and getgenv() or getfenv()
if ENV.CompkillerExampleWindow and type(ENV.CompkillerExampleWindow.Destroy) == "function" then
    pcall(function() ENV.CompkillerExampleWindow:Destroy() end)
end
local Window = UI.new({ Name = "Compkiller", Keybind = "Insert", Logo = UI.Logo,
    ToggleButton = { Enabled = true, Mode = "Always", Draggable = true } })
ENV.CompkillerExampleWindow = Window
Window.ScreenGui:SetAttribute("CompkillerExample", true)

local notifications = UI.newNotify()
local function tell(title, message)
    notifications.new({ Title = title, Content = tostring(message), Icon = UI.Logo, Duration = 4 })
end
UI.CompatibilityNotifier = function(reason) tell("Unavailable", reason) end
local function changed(name) return function(value) tell(name, value) end end
local function action(name) return function() tell("Action", name) end end

Window:DrawCategory({ Name = "Catalog" })
local home = Window:DrawTab({ Name = "Home", Icon = "house", Type = "Single", EnableScrolling = true })
local welcome = home:DrawSection({ Name = "Example map", Position = "left" })
welcome:AddParagraph({ Title = "Components by tab", Content = "Use the side menu to explore layouts, toggles, buttons, dropdowns, colors, inputs, sorting, settings, and compatibility." })
welcome:AddParagraph({ Title = "Variants", Content = "Each tab shows styles, compact controls, multi-select, and capability guards." })
welcome:AddButton({ Name = "Show notification", Style = "Primary", Icon = "bell", Callback = action("Notification shown") })

local layout = Window:DrawTab({ Name = "Double layout", Icon = "columns-2", Type = "Double", EnableScrolling = true })
layout:DrawSection({ Name = "Left", Position = "left" }):AddParagraph({ Title = "Double", Content = "First column of a double tab." })
layout:DrawSection({ Name = "Right", Position = "right" }):AddParagraph({ Title = "Position", Content = "Sections accept left and right. Home demonstrates a single-column tab." })
local grouped = Window:DrawContainerTab({ Name = "Grouped tabs", Icon = "layers", EnableScrolling = true })
local groupA = grouped:DrawTab({ Name = "Inner tab A", Icon = "circle", Type = "Single", EnableScrolling = true })
groupA:DrawSection({ Name = "Inner single tab", Position = "left" }):AddParagraph({ Title = "Container", Content = "First inner tab." })
local groupB = grouped:DrawTab({ Name = "Inner tab B", Icon = "grid", Type = "Double", EnableScrolling = true })
groupB:DrawSection({ Name = "Left", Position = "left" }):AddButton({ Name = "Inner button", Callback = action("Inner tab B") })
groupB:DrawSection({ Name = "Right", Position = "right" }):AddToggle({ Name = "Inner toggle", Callback = changed("Inner tab B") })

local toggles = Window:DrawTab({ Name = "Toggles", Icon = "toggle-right", Type = "Double", EnableScrolling = true })
local toggleLeft = toggles:DrawSection({ Name = "Basics", Position = "left" })
toggleLeft:AddToggle({ Name = "Normal", Flag = "demo_normal", Default = false, Callback = changed("Toggle normal") })
toggleLeft:AddToggle({ Name = "Initially on", Flag = "demo_default_on", Default = true, Callback = changed("Initially on") })
toggleLeft:AddToggle({ Name = "Risky", Risky = true, Default = false, Callback = changed("Risky") })
local disabledToggle = toggleLeft:AddToggle({ Name = "Manually disabled", Disabled = true, Default = false, Callback = changed("Disabled") })
local toggleRight = toggles:DrawSection({ Name = "Requirements and extras", Position = "right" })
local missingToggle = toggleRight:AddToggle({ Name = "Missing API (demo)", Requires = "DemoMissing",
    Default = false, Content = "This control always demonstrates a missing requirement.", Callback = changed("Should not activate") })
toggleRight:AddToggle({ Name = "Requires hook", Requires = "Hooks", Default = false,
    Content = "The on state is refused if the API is missing.", Callback = changed("Hook demo") })
local expandable = toggleRight:AddToggle({ Name = "Compact attachments", Default = false, StackOnOverflow = true, Callback = changed("Toggle with extras") })
expandable.Link:AddHelper({ Text = "Helper text" })
expandable.Link:AddToggle({ Default = false, Callback = changed("Mini toggle") })
expandable.Link:AddKeybind({ Default = "K", Blacklist = { "Insert" }, Callback = changed("Mini keybind") })
expandable.Link:AddColorPicker({ Default = Color3.fromRGB(170, 100, 255), Transparency = 0.2,
    Callback = function(color, opacity) tell("Mini colorpicker", tostring(color) .. " / " .. tostring(opacity)) end })
expandable.Options:AddButton({ Name = "Button inside popup", Callback = action("Expanded option") })
expandable.Options:AddParagraph({ Title = "Options popup", Content = "This popup uses an external sortable trigger. Embedded lists need a full section." })

local buttons = Window:DrawTab({ Name = "Buttons", Icon = "mouse-pointer", Type = "Double", EnableScrolling = true })
local buttonLeft = buttons:DrawSection({ Name = "Styles", Position = "left" })
buttonLeft:AddButton({ Name = "Primary", Style = "Primary", Callback = action("Primary") })
buttonLeft:AddButton({ Name = "Secondary", Style = "Secondary", Callback = action("Secondary") })
buttonLeft:AddButton({ Name = "Ghost", Style = "Ghost", Callback = action("Ghost") })
buttonLeft:AddButton({ Name = "Risky", Style = "Risky", Callback = action("Risky") })
buttonLeft:AddButton({ Name = "Danger", Style = "Danger", Callback = action("Danger") })
buttonLeft:AddButton({ Name = "Icon + badge", Icon = "star", Badge = "NEW", Description = "The description remains inside the card.", Callback = action("Detailed button") })
local buttonRight = buttons:DrawSection({ Name = "States and groups", Position = "right" })
buttonRight:AddButton({ Name = "Disabled", Disabled = true, Callback = action("Should not run") })
buttonRight:AddButton({ Name = "Missing API (demo)", Requires = "DemoMissing", Callback = action("Should not run") })
buttonRight:AddButton({ Name = "Requires getconnections", Requires = "Connections", Callback = action("getconnections available") })
buttonRight:AddButtonGroup({ Buttons = {
    { Name = "One", Style = "Primary", Callback = action("Group 1") },
    { Name = "Two", Style = "Secondary", Callback = action("Group 2") },
    { Name = "Three", Style = "Ghost", Callback = action("Group 3") },
    { Name = "Four", Disabled = true, Callback = action("Group 4") },
} })
buttonRight:AddButtonRow({ Buttons = {
    { Name = "A", Color = "Highlight", Callback = action("Row A") },
    { Name = "B", HoverText = "Hover", Callback = action("Row B") },
} })
UI:CreateSortableList({ Title = "Editor trigger", Mode = "External", Section = buttonRight,
    Trigger = { Name = "Open editor", Description = "This trigger opens a working editor", Icon = "list-tree" },
    Items = { "A", "B", "C" }, Flag = "demo_editor_trigger", OnDone = function(value) tell("Editor order", #value) end })

local dropdowns = Window:DrawTab({ Name = "Dropdowns", Icon = "chevron-down", Type = "Double", EnableScrolling = true })
local dropdownLeft = dropdowns:DrawSection({ Name = "Single select", Position = "left" })
dropdownLeft:AddDropdown({ Name = "Normal", Values = { "A", "B", "C" }, Default = "A", Multi = false, Callback = changed("Single dropdown") })
local dynamic = dropdownLeft:AddDropdown({ Name = "Dynamic list", Values = { "Blue", "Purple" }, Default = "Purple", Callback = changed("Dynamic") })
dropdownLeft:AddButton({ Name = "Replace list values", Callback = function() dynamic:SetValues({ "Red", "Green", "Yellow" }, "Green") end })
local dropdownRight = dropdowns:DrawSection({ Name = "Multi select", Position = "right" })
dropdownRight:AddDropdown({ Name = "Multi from list", Values = { "A", "B", "C" }, Default = { "A", "C" }, Multi = true, Callback = changed("Multi list") })
dropdownRight:AddDropdown({ Name = "Multi from map", Values = { "One", "Two", "Three" }, Default = { One = true, Three = true }, Multi = true, Callback = changed("Multi map") })
dropdownRight:AddParagraph({ Title = "Callback value", Content = "Multi callbacks receive a table of selected values." })

local colors = Window:DrawTab({ Name = "Colorpickers", Icon = "palette", Type = "Double", EnableScrolling = true })
local colorsLeft = colors:DrawSection({ Name = "Opaque", Position = "left" })
colorsLeft:AddParagraph({ Title = "Color only", Content = "Transparency is zero, so the preview is fully opaque." })
colorsLeft:AddColorPicker({ Name = "Opaque purple (0%)", Default = Color3.fromRGB(157, 93, 255), Transparency = 0,
    Callback = function(color) tell("Opaque color", color) end })
local colorsRight = colors:DrawSection({ Name = "Transparent", Position = "right" })
colorsRight:AddParagraph({ Title = "Color with alpha", Content = "Transparency starts at 65%, making the preview visibly lighter." })
colorsRight:AddColorPicker({ Name = "Transparent purple (65%)", Default = Color3.fromRGB(157, 93, 255), Transparency = 0.65,
    Callback = function(color, transparency) tell("Color and opacity", tostring(color) .. " / " .. tostring(transparency)) end })
colorsRight:AddParagraph({ Title = "Mini colorpicker", Content = "The compact picker is in the Compact attachments popup on the Toggles tab." })

local inputs = Window:DrawTab({ Name = "Inputs", Icon = "keyboard", Type = "Double", EnableScrolling = true })
local inputsLeft = inputs:DrawSection({ Name = "Sliders", Position = "left" })
inputsLeft:AddSlider({ Name = "Integer", Min = 0, Max = 100, Default = 50, Type = "%", Round = 0, Callback = changed("Integer") })
inputsLeft:AddSlider({ Name = "Decimal", Min = 0, Max = 2, Default = 0.2, Type = "x", Round = 2, Callback = changed("Decimal") })
local inputsRight = inputs:DrawSection({ Name = "Text and keys", Position = "right" })
inputsRight:AddTextBox({ Name = "Free text", Default = "", Placeholder = "Type here", Numeric = false, Callback = changed("Text") })
inputsRight:AddTextBox({ Name = "Numbers only", Default = "10", Placeholder = "0-9", Numeric = true, Callback = changed("Number") })
inputsRight:AddKeybind({ Name = "Keybind", Default = "J", Blacklist = { "Insert" }, Callback = changed("Keybind") })

local extras = Window:DrawTab({ Name = "Extras", Icon = "box", Type = "Double", EnableScrolling = true })
local extrasLeft = extras:DrawSection({ Name = "Content", Position = "left" })
extrasLeft:AddParagraph({ Title = "Paragraph", Content = "A title and body text." })
extrasLeft:AddEmptyState({ Title = "EmptyState", Description = "Shown when there are no items.", Icon = "inbox" })
local extrasRight = extras:DrawSection({ Name = "Window actions", Position = "right" })
extrasRight:AddButton({ Name = "Notification", Callback = action("Notification example") })
extrasRight:AddParagraph({ Title = "Startup loader", Content = "The animation runs when the library loads. Set getgenv().CompkillerAutoLoader = false before loading to disable it." })
extrasRight:AddButton({ Name = "Light purple accent", Callback = function() UI:ChangeHighlightColor(Color3.fromRGB(192, 134, 255)) end })

Window:DrawCategory({ Name = "System" })
local appearance = Window:DrawTab({ Name = "Appearance", Icon = "paintbrush", Type = "Double", EnableScrolling = true })
Window:DrawUISettings(appearance, { FlagPrefix = "example_ui" })
local orderTab = Window:DrawTab({ Name = "Sorting", Icon = "list", Type = "Double", EnableScrolling = true })
local internal = orderTab:DrawSection({ Name = "Embedded", Position = "left" })
UI:CreateSortableList({ Title = "Embedded list", Mode = "Internal", AttachedTo = internal, Section = internal,
    Items = { { Id = "a", Name = "A" }, { Id = "b", Name = "B" }, { Id = "c", Name = "C" } },
    Flag = "demo_order_internal", OnDone = function(value) tell("Embedded order", #value) end })
internal:AddParagraph({ Title = "Embedded in a double tab", Content = "The list follows the left column width. Long row labels are shortened within the row." })
local external = orderTab:DrawSection({ Name = "External modal", Position = "right" })
UI:CreateSortableList({ Title = "External list", Mode = "External", Section = external,
    Trigger = { Name = "Open editor", Description = "Drag to reorder", Icon = "list-tree" },
    Items = { "First", "Second", "Third" }, Flag = "demo_order_external",
    OnChanged = function(value) tell("External order", #value) end })

external:AddParagraph({ Title = "External modal", Content = "This editor opens a separate modal and does not use the column width." })
UI:CreateSortableList({ Title = "Popup list", Mode = "External", Section = expandable.Options,
    Trigger = { Name = "Open sortable popup", Description = "A sortable trigger inside AddOption" },
    Items = { "Alpha", "Beta", "Gamma" }, Flag = "demo_order_popup" })

local config, configReason = UI:ConfigManager({ Directory = "CompkillerExample", Config = "Demo" })
if config then
    Window:DrawConfig({ Name = "Config", Icon = "folder", Config = config }):Init()
else
    local configTab = Window:DrawTab({ Name = "Config", Icon = "folder", Type = "Single" })
    configTab:DrawSection({ Name = "No file API", Position = "left" }):AddParagraph({ Title = "Config unavailable", Content = configReason })
end
local statusTab = Window:DrawTab({ Name = "Compatibility", Icon = "shield", Type = "Single", EnableScrolling = true })
local status = statusTab:DrawSection({ Name = "Executor functions", Position = "left" })
for _, capability in ipairs({ "loadstring", "readfile", "writefile", "isfile", "listfiles", "hookmetamethod", "newcclosure", "getconnections", "cloneref" }) do
    local available = UI:CheckRequirements({ capability })
    status:AddParagraph({ Title = capability, Content = available and "Available" or "Missing" })
end
status:AddParagraph({ Title = "Reading this status", Content = "Available means the function exists. Real modules must validate its behavior before use." })

ENV.CompkillerExampleControls = { DisabledToggle = disabledToggle, MissingToggle = missingToggle, DynamicDropdown = dynamic }
print("COMPKILLER_EXAMPLE_READY", "WindowTabs", #Window.Tabs)
tell("Example loaded", "Use the side menu to explore every component.")
