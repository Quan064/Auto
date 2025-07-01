#Requires AutoHotkey v2
CoordMode "Mouse", "Screen"
CoordMode "ToolTip", "Screen"
#Esc:: ExitApp

^+4:: Run "C:\Users\Hello\OneDrive\Code Tutorial\Python\Auto\Pin\pin.pyw"
^+5:: Run "C:\Users\Hello\OneDrive\Code Tutorial\Python\Auto\Trans\trans.pyw"

isEdgeAction := false

MButton::
{
    global isEdgeAction
    MouseGetPos &x, &y, &winHwnd
    isEdgeAction := x >= 1920 - 5
    if (isEdgeAction)
    {
        Click 1450, 1079, 'L'
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
    if (!GetKeyState("XButton2", "P")) {
        Send("{Alt Up}")
        SetTimer(ReleaseAltTimer, 0)
    }
    MouseGetPos &x, &y
    if (!deleteSent)
    {
        if (x >= 1920 - 5)
        {
            Send("{Delete}")
            deleteSent := true
        }
        else if (x <= 5)
        {
            Send("{Escape}")
            Send("{Alt Up}")
            SetTimer(ReleaseAltTimer, 0)
            deleteSent := true
        }
    }
    else if ((x < 1920 - 5) && (x > 5))
        deleteSent := false
}

XButton2_pressed := false
XButton2_pressed_only := true
LButton::
{
    global XButton2_pressed, XButton2_pressed_only
    if (GetKeyState("XButton2", "P"))
    {
        Send("#t")
        Send("#+t")
        Send("{End}")
        XButton2_pressed := true
        XButton2_pressed_only := false
        MouseGetPos &x, &y
        Loop
        {
            Sleep(10)
            if !GetKeyState("XButton2", "P") {
                Send('+ ')
                break
            }
            if GetKeyState("RButton", "P") {
                Click 1450, 1079, 'L'
                MouseMove x, y
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
    global XButton2_pressed, XButton2_pressed_only
    if (XButton2_pressed)
    {
        XButton2_pressed := false
    }
    else
    {
        Send("{LButton up}")
    }
}

XButton2::
{
    global XButton2_pressed_only
    if XButton2_pressed_only
    {
        Send("{XButton2 down}")
    }
}

XButton2 Up::
{
    global XButton2_pressed_only
    if XButton2_pressed_only
    {
        Send("{XButton2 up}")
    }
    else
    {
        XButton2_pressed_only := true
    }
}

RButton::
{
    global XButton2_pressed
    if !XButton2_pressed
    {
        Send("{RButton down}")
    }
}

RButton Up::
{
    global XButton2_pressed
    if !XButton2_pressed
    {
        Send("{RButton up}")
    }
}