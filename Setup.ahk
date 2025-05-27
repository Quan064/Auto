#Requires AutoHotkey v2
CoordMode "Mouse", "Screen"
CoordMode "ToolTip", "Screen"

isEdgeAction := false

MButton::
{
    global isEdgeAction
    MouseGetPos &x, &y, &winHwnd
    isEdgeAction := x >= 1920 - 5
    if (isEdgeAction)
    {
        Send("#n")
        Sleep(100)
        Send("{Tab}")
        Sleep(100)
        Send("{Tab}")
        Sleep(100)
        Send("{Space}")
        Sleep(100)
        Send("#n")
    }
    else
    {
        Send("{MButton down}")
        Sleep 500
        if !GetKeyState("MButton", "P")
            return

        hwnd := WinExist("A")
        title := WinGetTitle(hwnd)
        if title ~= "i)(Discord|Zalo|File Explorer)"
            WinClose hwnd
    }
}

MButton Up::
{
    global isEdgeAction
    if (isEdgeAction)
    {
        isEdgeAction := false
    }
    else
    {
        Send("{MButton up}")
    }
}

XButton2 & WheelUp::
{
    Send("{Alt Down}{Tab}")
    SetTimer(ReleaseAltTimer, 10)
}

XButton2 & WheelDown::
{
    Send("{Alt Down}{Shift Down}{Tab}{Shift Up}")
    SetTimer(ReleaseAltTimer, 10)
}

ReleaseAltTimer() {
    if (!GetKeyState("XButton2", "P")) {
        Send("{Alt Up}")
        SetTimer(ReleaseAltTimer, 0)
    }
}

XButton2::
{
    if (A_PriorHotkey = "XButton2 & WheelUp" || A_PriorHotkey = "XButton2 & WheelDown") {
        return
    }
    Send("{XButton2}")
}
