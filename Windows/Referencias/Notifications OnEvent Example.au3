
#include <Notifications.au3>

Opt("GUIOnEventMode", 1)

_Notifications_Startup()

Global $notificationCounter = 0


GUICreate("Notifications OnEvent Example", 340, 85)
GUISetOnEvent(-3, "_Exit")

GUICtrlCreateLabel("This is the example of the usage of Notifications with GUIOnEventMode activated." & @CRLF & "Click the button to create a new notification:", 10, 10, 320, 40)

GUICtrlCreateButton("Create Notification", 100, 55)
GUICtrlSetOnEvent(-1, "_newNotification")

GUISetState()



While Sleep(1)
WEnd


Func _newNotification()

	$notificationCounter += 1
	_Notifications_Create("Notification #" & $notificationCounter, "This is a notification created using GUIOnEventMode.")

EndFunc

Func _Exit()
	Exit
EndFunc