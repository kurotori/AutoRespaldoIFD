
#include <Notifications.au3>

Opt("GUIOnEventMode", 1)


_Notifications_Startup()



;_Notifications_SetAnimationTime(500) ; slower animation?
;_Notifications_SetSound(@WindowsDir & "\Media\Windows Notify Messaging.wav") ; other notification sound?


; #1
_Notifications_Create("This is notification #1", "This is the message of the notification. It appears over two lines if text is longer.", "test")


; #2
_Notifications_SetBorder(True)
_Notifications_Create("This is notification #2", "It has a border." & @CRLF & "Everything else is default.")


; #3
_Notifications_SetTextAlign("left")
_Notifications_SetDateFormat("")
_Notifications_SetTimeFormat("")
_Notifications_Create("This is notification #3", "It has a border. Text is aligned left." & @CRLF & "It has no date or time.")


; #4
_Notifications_SetBorder(False)
_Notifications_SetTextAlign("right")
_Notifications_SetDateFormat("DD.MM.YYYY")
_Notifications_SetTimeFormat("HH:MM:SS")
_Notifications_Create("This is notification #4", "It has no border. Text is aligned right." & @CRLF & "Date and time format changed.")


; #5
_Notifications_SetTextAlign("center") ;you can also use Default for all Set-Functions to go back to the default value
_Notifications_SetButtonText("")
_Notifications_Create("This is notification #5", "It has no border. Text is aligned center." & @CRLF & "No text for closing button.")


; #6
_Notifications_SetDateFormat("MM/DD/YYYY")
_Notifications_SetTimeFormat(Default)
_Notifications_SetButtonText("Delete")
_Notifications_SetColor(0x0D0D0D)
_Notifications_SetBkColor(0xFFFFFF)
_Notifications_SetBorder(True)
_Notifications_Create("This is notification #6", "It has a border, is white, changed date format and text for the button.")


; #7
_Notifications_SetDateFormat("MM\DD")
_Notifications_SetButtonText(Default)
_Notifications_SetBorder(False)
_Notifications_Create("This is notification #7", "It has no border, but changed date format.")


; #8
_Notifications_SetDateFormat(Default)
_Notifications_SetColor(0xFDFDFD)
_Notifications_SetBkColor(0xFF0000)
_Notifications_Create("This is notification #8", "It has no border." & @CRLF & "This notification is red.")


; #9
_Notifications_SetBorder(True)
_Notifications_SetDateFormat("")
_Notifications_SetTimeFormat("")
_Notifications_Create("This is notification #9", "It has a border and is red" & @CRLF & "It has no date or time")


; #10
_Notifications_SetColor(Default)
_Notifications_SetBkColor(Default)
_Notifications_SetDateFormat(Default)
_Notifications_SetTimeFormat(Default)
_Notifications_SetTransparency(255)
_Notifications_Create("This is notification #10", "It has a border." & @CRLF & "This notification is not transparent at all.")


; #11
_Notifications_SetTransparency(140)
_Notifications_Create("This is notification #11", "It has a border." & @CRLF & "This notification is more transparent.")


; #12
_Notifications_SetTransparency(Default)
_Notifications_Create("This is notification #12", "You can click it (area above seperating line). Notification will close on click.", "randomFunc1")


; #13
_Notifications_Create("This is notification #13", "You can click it (area above seperating line). Notification will close on click.", "randomFunc2", False)



While Sleep(1)
WEnd


Func randomFunc1()

	MsgBox(64, "Notification clicked", "The notification that called this function was deleted")

EndFunc

Func randomFunc2()

	MsgBox(64, "Notification clicked", "The notification that called this function is still available and can be clicked again.")

EndFunc
