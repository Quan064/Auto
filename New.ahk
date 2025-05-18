#Requires AutoHotkey v2.0
CoordMode "Mouse", "Screen"
CoordMode "ToolTip", "Screen"

::@gmail::minhquanthong064@gmail.com@gmail.com

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