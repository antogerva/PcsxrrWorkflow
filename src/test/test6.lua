
ID_DIRPICKER1  = 3001
ID_DIRPICKER2  = 3002
ID_DIRPICKER3  = 3003
ID_DIRPICKER4  = 3004

ID_FILEPICKER1 = 4001
ID_FILEPICKER2 = 4002
ID_FILEPICKER3 = 4003
ID_FILEPICKER4 = 4004
ID_FILEPICKER5 = 4005


-- ---------------------------------------------------------------------------
-- Gather up all of the wxEVT_XXX names and hash by their value
-- ---------------------------------------------------------------------------
wxEVT_Names = {}
for k, v in pairs(wx) do
    if string.find(k, "wxEVT_", 1, 1) == 1 then
        wxEVT_Names[v] = k
    end
end

-- ---------------------------------------------------------------------------
-- Handle all wxFileDirPickerEvents
-- ---------------------------------------------------------------------------
function OnFileDirPicker(event)
    local evt_type = event:GetEventType()
    local val = event:GetPath()
    

    local s = string.format("%s wxFileDirPickerEvent type: %s=%d id: %d GetPath = '%s'\n\n", wx.wxNow(), wxEVT_Names[evt_type], evt_type, event:GetId(), val)
    --textCtrl:AppendText(s)
    
    iup.Message("title", val)
end


-- ---------------------------------------------------------------------------
-- Create the window with the picker controls
-- ---------------------------------------------------------------------------
function CreatePickerWindow(parent)

    local scrollWin = wx.wxScrolledWindow(parent, wx.wxID_ANY,
                                    wx.wxDefaultPosition, wx.wxDefaultSize,
                                    wx.wxHSCROLL + wx.wxVSCROLL)
    -- Give the scrollwindow enough size so sizer works when calling Fit()
    scrollWin:SetScrollbars(15, 15, 400, 600, 0, 0, false)

    local mainSizer = wx.wxBoxSizer(wx.wxVERTICAL)
    local flexSizer = wx.wxFlexGridSizer(0, 2, 5, 5)
    flexSizer:AddGrowableCol(1)

    local statText = nil -- not used outside of this function
   
    -- -----------------------------------------------------------------------
    flexSizer:Add(wx.wxStaticLine(scrollWin, wx.wxID_ANY), 1, wx.wxEXPAND)
    flexSizer:Add(wx.wxStaticLine(scrollWin, wx.wxID_ANY), 1, wx.wxEXPAND)

    local dirPicker = nil -- not used outside of this function

    statText = wx.wxStaticText(scrollWin, wx.wxID_ANY, "wxDirPickerCtrl +  wxDIRP_DEFAULT_STYLE")
    dirPicker = wx.wxDirPickerCtrl(scrollWin, ID_DIRPICKER1, wx.wxGetCwd(), wx.wxDirSelectorPromptStr,
                                         wx.wxDefaultPosition, wx.wxDefaultSize,
                                         wx.wxDIRP_DEFAULT_STYLE)
    flexSizer:Add(statText, 1, wx.wxALIGN_CENTER_VERTICAL)
    flexSizer:Add(dirPicker, 1, wx.wxEXPAND)
	
    -- central event handler for all wxDirPickerCtrl
    scrollWin:Connect(wx.wxID_ANY, wx.wxEVT_COMMAND_DIRPICKER_CHANGED, OnFileDirPicker)

	
    -- -----------------------------------------------------------------------
    flexSizer:Add(wx.wxStaticLine(scrollWin, wx.wxID_ANY), 1, wx.wxEXPAND)
    flexSizer:Add(wx.wxStaticLine(scrollWin, wx.wxID_ANY), 1, wx.wxEXPAND)

    local filePicker = nil -- not used outside of this function

    statText = wx.wxStaticText(scrollWin, wx.wxID_ANY, "wxFilePickerCtrl +  wxFLP_DEFAULT_STYLE")
    filePicker = wx.wxFilePickerCtrl(scrollWin, ID_FILEPICKER1, wx.wxGetCwd(), "I'm the message parameter", "*",
                                         wx.wxDefaultPosition, wx.wxDefaultSize,
                                         wx.wxFLP_DEFAULT_STYLE)
    flexSizer:Add(statText, 1, wx.wxALIGN_CENTER_VERTICAL)
    flexSizer:Add(filePicker, 1, wx.wxEXPAND)

    -- central event handler for all wxDirPickerCtrl
    scrollWin:Connect(wx.wxID_ANY, wx.wxEVT_COMMAND_FILEPICKER_CHANGED, OnFileDirPicker)
    -- -----------------------------------------------------------------------

    mainSizer:Add(flexSizer, 1, wx.wxEXPAND)
    scrollWin:SetSizer(mainSizer)
    mainSizer:Fit(scrollWin)

    return scrollWin
end

-- ---------------------------------------------------------------------------
-- Main function of the program
-- ---------------------------------------------------------------------------
function main()

    frame = wx.wxFrame( wx.NULL,              -- no parent needed for toplevel windows
                        wx.wxID_ANY,          -- don't need a wxWindow ID
                        "wxLua Picker Demo",  -- caption on the frame
                        wx.wxDefaultPosition, -- let system place the frame
                        wx.wxSize(550, 450),  -- set the size of the frame
                        wx.wxDEFAULT_FRAME_STYLE ) -- use default frame styles

    local fileMenu = wx.wxMenu()
    fileMenu:Append(wx.wxID_EXIT, "E&xit", "Quit the program")

    local helpMenu = wx.wxMenu()
    helpMenu:Append(wx.wxID_ABOUT, "&About", "About the wxLua Picker Application")

    local menuBar = wx.wxMenuBar()
    menuBar:Append(fileMenu, "&File")
    menuBar:Append(helpMenu, "&Help")
    frame:SetMenuBar(menuBar)

    frame:CreateStatusBar(1)
    frame:SetStatusText("Welcome to wxLua.")

    -- connect the selection event of the exit menu item to an
    -- event handler that closes the window
    frame:Connect(wx.wxID_EXIT, wx.wxEVT_COMMAND_MENU_SELECTED,
                  function (event) frame:Close(true) end )

    -- connect the selection event of the about menu item
    frame:Connect(wx.wxID_ABOUT, wx.wxEVT_COMMAND_MENU_SELECTED,
        function (event)
            wx.wxMessageBox('This is the "About" dialog of the Picker wxLua sample.\n'..
                            wxlua.wxLUA_VERSION_STRING.." built with "..wx.wxVERSION_STRING,
                            "About wxLua",
                            wx.wxOK + wx.wxICON_INFORMATION,
                            frame)
        end )

    -- -----------------------------------------------------------------------

    --pickerWin = CreatePickerWindow(frame)
	--pickerWin:Fit(frame)



	--wx.wxDirPickerCtrl(frame, ID_DIRPICKER1, wx.wxGetCwd(), wx.wxDirSelectorPromptStr,wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxDIRP_DEFAULT_STYLE)
    wx.wxFilePickerCtrl(frame, ID_FILEPICKER1, wx.wxGetCwd(), "I'm the message parameter", "*",wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxFLP_DEFAULT_STYLE)


    frame:Connect(wx.wxID_ANY, wx.wxEVT_COMMAND_FILEPICKER_CHANGED, OnFileDirPicker)
    
    
 	--wx.wxFileDirPickerEvent(ID_FILEPICKER1, frame, ID_DIRPICKER1, wx.wxGetCwd())
    -- -----------------------------------------------------------------------

    frame:Show(true) -- show the frame window
end