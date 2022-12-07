#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Constants.au3>
#include <WinAPIFiles.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 615, 437, 192, 124)
$Edit1 = GUICtrlCreateEdit("", 24, 16, 569, 385)
GUICtrlSetData(-1, "")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()


    

	Switch $nMsg

		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd


; Open the file for read/write access.
Local Const $sFilePath = @ScriptDir & "\prueba.txt"



FileDelete($sFilePath)
Sleep(2000)
Local $hFileOpen = FileOpen($sFilePath, $FO_READ + $FO_OVERWRITE)
If $hFileOpen = -1 Then
    MsgBox($MB_SYSTEMMODAL, "", "An error occurred when reading/writing the file.")
EndIf

;ConsoleWrite( _getDOSOutput('nmap-7.91\nmap.exe -sP 192.168.2.0/24') & @CRLF)





Func _getDOSOutput($command)
    Local $text = '', $Pid = Run('"' & @ComSpec & '" /c ' & $command, '', @SW_HIDE, 2 + 4)
    While 1
        $text &= StdoutRead($Pid, False, False)
        If @error Then ExitLoop
        Sleep(10)
    WEnd
    Return $text
EndFunc   ;==>_getDOSOutput