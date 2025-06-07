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
        Click 0, 0, 'L'
        MouseMove x, y
        Sleep(300)
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

global deleteSent := false
ReleaseAltTimer() {
    global deleteSent
    if (GetKeyState("RButton", "P") && !deleteSent) {
        Send("{Delete}")
        deleteSent := true
    }
    if (!GetKeyState("RButton", "P") && deleteSent) {
        deleteSent := false
    }
    if (!GetKeyState("XButton2", "P")) {
        Send("{Alt Up}")
        SetTimer(ReleaseAltTimer, 0)
    }
}

#Esc:: ExitApp
XButton2_pressed := false
LButton::
{
    global XButton2_pressed
    if (GetKeyState("XButton2", "P"))
    {
        Send("#t")
        Send("#+t")
        XButton2_pressed := true
        MouseGetPos &x
        Loop
        {
            Sleep(10)
            if !GetKeyState("XButton2", "P") {
                Send('+ ')
                break
            }

            MouseGetPos &xNow
            deltaX := xNow - x

            if Abs(deltaX) > 20
            {
                if deltaX > 0
                {
                    x := x + 20
                    Send("#t")
                }
                else
                {
                    x := x - 20
                    Send("#+t")
                }
            }
        }
    }
    else
    {
        Send("{LButton down}")
    }
}

LButton Up::
{
    global XButton2_pressed
    if (XButton2_pressed)
    {
        XButton2_pressed := false
    }
    else
    {
        Send("{LButton up}")
    }
}
