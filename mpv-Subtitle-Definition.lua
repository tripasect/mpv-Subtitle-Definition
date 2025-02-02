local mp = require 'mp'

-- Function to fetch and process subtitles
local function send_current_subtitle()
    local subtitle = mp.get_property("sub-text")

    if not subtitle or subtitle == "" then
        mp.osd_message("No subtitle currently displayed.", 3)
        print("No subtitle currently displayed.")
        return
    end

    subtitle = subtitle:gsub('"', '\\"')

    local function get_script_dir()
        local source = debug.getinfo(1, 'S').source
        if source:sub(1, 1) == "@" then
            source = source:sub(2)
        end
        return source:match("(.+[\\/])") or "."
    end

    local script_dir = get_script_dir()
    local python_path = script_dir .. "mpv-Subtitle-Definition/.venv/bin/python3"
    local script_path = script_dir .. "mpv-Subtitle-Definition/script.py"

    local command = string.format('%s %s "%s"', python_path, script_path, subtitle)
    
    print(command)

    local handle = io.popen(command)
    if not handle then
        print("Error: Failed to execute command")
        return
    end

    local response = handle:read("*a") or ""
    handle:close()

    response = response:gsub("^%s*(.-)%s*$", "%1")
    print("ChatGPT Response:", response)

    if response and response ~= "" then
        if response == "KNOWN" then
            mp.set_property_bool("pause", false)
            mp.osd_message("You know all these words!", 2)
        else
            mp.osd_message(response, 999)
        end
    end
end

mp.add_key_binding("SPACE", "clear_osd", function()
    mp.osd_message("", 0)
    local paused = mp.get_property_bool("pause")
    mp.set_property_bool("pause", not paused)
end)

mp.add_key_binding("ENTER", "fetch_subtitle1", function()
    mp.set_property_bool("pause", true)
    mp.osd_message("Processing...", 999)
    send_current_subtitle()
end)

mp.add_key_binding("TAB", "fetch_subtitle2", function()
    mp.set_property_bool("pause", true)
    mp.osd_message("Processing...", 999)
    send_current_subtitle()
end)