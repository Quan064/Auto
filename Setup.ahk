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
    isEdgeAction := x >= A_ScreenWidth - 5
    if (isEdgeAction)
    {
        Send("#t")
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
        exe := WinGetProcessName(hwnd)
        if title ~= "i)(Discord|Zalo|File Explorer)" || exe = "Notion.exe"
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

LHolding := false
LButton::
{
    global LHolding, holdStartTime, hold_start_x, hold_start_y
    Send("{LButton down}")

    MouseGetPos &hold_start_x, &hold_start_y, &hWnd
    WinGetPos(&winX, &winY, &winW, &winH, "ahk_id " hWnd)

    if (hold_start_x > winX && hold_start_x < winX + winW && hold_start_y > winY && hold_start_y < winY + 36) {
        LHolding := true
        holdStartTime := A_TickCount
        SetTimer(CheckHold_Snap, 50)
    }
}

LButton Up::
{
    global LHolding
    Send("{LButton up}")
    LHolding := false
}

CheckHold_Snap()
{
    global LHolding, holdStartTime, hold_start_x, hold_start_y
    if !LHolding
    {
        SetTimer(CheckHold_Snap, 0)
        return
    }

    ; Nếu giữ đủ lâu thì snap
    if (A_TickCount - holdStartTime >= 300)
    {
        MouseGetPos &end_x, &end_y, &hWnd
        WinGetPos(&winX, &winY, &winW, &winH, "ahk_id " hWnd)

        if abs(hold_start_x - end_x) < 5 && abs(hold_start_y - end_y) < 5 {
            SetTimer(CheckHold_Snap, 0)

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
