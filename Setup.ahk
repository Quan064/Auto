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
hold_alt_held := false
hold_last_step := 0
rbutton_sent := false
LButton::
{
    global LHolding, holdStartTime, hold_start_x, hold_start_y
    MouseGetPos &hold_start_x, &hold_start_y, &hWnd
    WinGetPos(&winX, &winY, &winW, &winH, "ahk_id " hWnd)

    LHolding := true
    holdStartTime := A_TickCount
    if hold_start_x >= A_ScreenWidth - 5 {
        SetTimer(CheckHold_Window, 50)
    }
    else {
        Send("{LButton down}")

        if (hold_start_x > winX && hold_start_x < winX + winW && hold_start_y > winY && hold_start_y < winY + 36) {
            SetTimer(CheckHold_Snap, 50)
        }
    }
}

LButton Up::
{
    global LHolding, hold_alt_held, hold_last_step
    Send("{LButton up}")
    LHolding := false
    if (hold_alt_held) {
        Send("{Alt up}")
        hold_alt_held := false
        hold_last_step := 0
    }
}

CheckHold_Snap()
{
    global LHolding, holdStartTime, hold_start_x, hold_start_y
    if !LHolding {
        SetTimer(CheckHold_Snap, 0)
        return
    }

    ; Nếu giữ đủ lâu thì snap
    if (A_TickCount - holdStartTime >= 300) {
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

CheckHold_Window()
{
    global LHolding, holdStartTime, hold_start_x, hold_start_y, hold_alt_held, hold_last_step, rbutton_sent
    if !LHolding {
        if (hold_alt_held) {
            Send("{Alt up}")
            hold_alt_held := false
            hold_last_step := 0
        }
        SetTimer(CheckHold_Window, 0)
        return
    }

    MouseGetPos &end_x, &end_y, &hWnd

    ; Nếu giữ 300 giây mà không di chuyển thì bắt đầu Alt+Tab
    if (A_TickCount - holdStartTime >= 300) {
        if (!hold_alt_held) {
            ; Kiểm tra xem chuột có được giữ yên tĩnh không (di chuyển <= 5px)
            if (abs(end_x - hold_start_x) <= 5 && abs(end_y - hold_start_y) <= 5) {
                Send("{Alt down}")
                Sleep 50
                Send("{Tab}")
                hold_alt_held := true
                hold_last_step := 0
            }
            else {
                return
            }
        }
    }

    ; Sau khi đã kích hoạt Alt+Tab, cho phép di chuyển để Tab/Shift+Tab
    if (hold_alt_held) {
        if GetKeyState("RButton", "P") {
            if !rbutton_sent {
                Send("{Delete}")
                rbutton_sent := true
            }
        }
        else {
            if (rbutton_sent) {
                rbutton_sent := false
            }
        }

        delta := hold_start_y - end_y
        if (delta >= 0)
            steps := Floor(delta / 50)
        else
            steps := -Floor((-delta) / 50)

        if (steps > hold_last_step) {
            add := steps - hold_last_step
            Loop add {
                Send("{Tab}")
                Sleep 60
            }
            hold_last_step := steps
        }
        else if (steps < hold_last_step) {
            sub := hold_last_step - steps
            Loop sub {
                Send("+{Tab}")
                Sleep 60
            }
            hold_last_step := steps
        }
    }
}
