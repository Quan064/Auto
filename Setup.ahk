#Requires AutoHotkey v2
#SingleInstance Force
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
    if (!deleteSent) {
        if GetKeyState("RButton", "P") {
            Send("{Delete}")
            deleteSent := true
        }
    }
    else {
        if !GetKeyState("RButton", "P") {
            deleteSent := false
        }
    }
}

XButton2_pressed := false
XButton2_pressed_only := true
LButton::
{
    global XButton2_pressed, XButton2_pressed_only, LHolding, holdStartTime, hold_start_x, hold_start_y
    if (GetKeyState("XButton2", "P"))
    {
        Send("{LWin down}t{LWin up}")
        Send("{End}")
        XButton2_pressed := true
        XButton2_pressed_only := false
        MouseGetPos &x, &y
        Loop
        {
            Sleep(10)
            if !GetKeyState("XButton2", "P") {
                Send('+ ')
                Sleep 1000
                hWnd := WinExist("A")
                if !hWnd {
                    Send("{LButton up}")
                    break
                }
                WinGetPos(&winX, &winY, &winW, &winH, "ahk_id " hWnd)
                WinMove(winX + 10, winY + 10, winW, winH, "A")
                if winX + 7 < 960 {
                    Send("#{Left}")
                }
                else {
                    Send("#{Right}")
                }
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

        MouseGetPos &hold_start_x, &hold_start_y, &hWnd
        WinGetPos(&winX, &winY, &winW, &winH, "ahk_id " hWnd)

        if (hold_start_x >= winX && hold_start_x <= winX + winW && hold_start_y >= winY && hold_start_y <= winY + 36) {
            LHolding := true
            holdStartTime := A_TickCount
            SetTimer(CheckHold, 50)
        }
    }
}

LButton Up::
{
    global XButton2_pressed, XButton2_pressed_only, LHolding
    if (XButton2_pressed)
    {
        XButton2_pressed := false
    }
    else
    {
        Send("{LButton up}")
        LHolding := false
    }
}

CheckHold()
{
    global LHolding, holdStartTime, hold_start_x, hold_start_y
    if !LHolding
    {
        SetTimer(CheckHold, 0)
        return
    }

    ; Nếu giữ đủ lâu thì snap
    if (A_TickCount - holdStartTime >= 300)
    {
        MouseGetPos &end_x, &end_y, &hWnd
        WinGetPos(&winX, &winY, &winW, &winH, "ahk_id " hWnd)

        if abs(hold_start_x - end_x) < 5 && abs(hold_start_y - end_y) < 5 {
            SetTimer(CheckHold, 0)

            WinMove(winX + 10, winY + 10, winW, winH, "A")
            if end_x <= winW / 2 + winX {
                Send("#{Left}")
            }
            else {
                Send("#{Right}")
            }

            ; Reset trạng thái
            isMouseHolding := false
        }
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