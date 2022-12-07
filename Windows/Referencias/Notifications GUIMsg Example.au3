
#include <Notifications.au3>


_Notifications_Startup()

Global $notificationCounter = 0


GUICreate("Notifications GUIMsg Example", 340, 85)

GUICtrlCreateLabel("This is the example of the usage of Notifications with GUIOnEventMode deactivated." & @CRLF & "Click the button to create a new notification:", 10, 10, 320, 40)

$hButton = GUICtrlCreateButton("Create Notification", 100, 55)

GUISetState()


While Sleep(1)

	$GUIMsg = GUIGetMsg()

	Switch $GUIMsg

		Case -3
			Exit
		Case $hButton
			_newNotification()

	EndSwitch

	_Notifications_CheckGUIMsg($GUIMsg)

WEnd


Func _newNotification()

	$notificationCounter += 1
	_Notifications_Create("Notification #" & $notificationCounter, "This is a notification created using GUIMsgMode")

EndFunc