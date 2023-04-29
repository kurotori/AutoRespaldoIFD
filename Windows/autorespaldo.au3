#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author:         Luis Sebastián de los Ángeles

 Script Function:
	Ubica el servidor de respaldos en la red local, crea un respaldo incremental
	y carga el mismo en el servidor en una carpeta específica.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Constants.au3>
#include <MsgBoxConstants.au3>
#include <GUIConstants.au3>
#include <AutoItConstants.au3>

#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <WindowsConstants.au3>

#Region ### START Koda GUI section ### Form=E:\MEGA\GitHub\buscarMV\Windows\Ventana1.kxf
$Form1 = GUICreate("AutoRespaldo", 641, 481, 192, 124)
GUISetBkColor(0xFFFFFF)
$StatusBar1 = _GUICtrlStatusBar_Create($Form1)
_GUICtrlStatusBar_SetMinHeight($StatusBar1, 25)
$Edit1 = GUICtrlCreateEdit("", 16, 16, 601, 377)
GUICtrlSetData(-1, "")
$BtnIniciar = GUICtrlCreateButton("Iniciar", 16, 400, 89, 33)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1

	

	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $BtnIniciar
			Local $IdUnica = GenerarID()
			AgregarDatosAControl($Edit1, $IdUnica)

			;; Consulta a WMI.
			;; Fuentes: https://www.autoitscript.com/forum/files/file/396-network-adapters-info/
			;; 			https://learn.microsoft.com/en-us/windows/win32/wmisdk/wmi-tasks--networking
			
			Local $sComputer = "."
			Local $objWMI = ObjGet("winmgmts:\\" & $sComputer & "\root\cimv2")
			Local $objWQLx = $objWMI.ExecQuery("SELECT * FROM Win32_NetworkAdapter WHERE NetConnectionID != NULL", "WQL", 0x30)
			For $objVARx In $objWQLx
				;ConsoleWrite($objVARx.NetConnectionID & @CRLF)
				$datosConn=$objVARx.NetConnectionID & "-" & $objVARx.MACAddress

				#cs
 				For $IPadd In $objVARx.IPAddress
					ConsoleWrite($IPadd)
				Next 
				#ce

				AgregarDatosAControl($Edit1, $datosConn)
			Next
			Local $objWQLx2 = $objWMI.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration")


			For $DatosIP In $objWQLx2
				$NumIps = UBound($DatosIP.IPAddress)

				If ($NumIps > 0) Then
					ConsoleWrite($DatosIP.Description & @CRLF)
					ConsoleWrite(" - IPs:"& UBound($DatosIP.IPAddress) & @CRLF)
					For $Ip In $DatosIP.IPAddress
						ConsoleWrite(@TAB & $Ip & @CRLF)
					Next
				EndIf				
				
				
				
			Next


		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd


;MsgBox($MB_ICONINFORMATION,"info","Probando")

;Local $p = GenerarID()
;ConsoleWrite($p)

;Local $arp = RunWait(@ComSpec & " /c " & "arp -a",@SW_HIDE, $STDOUT_CHILD)
;Local $arp = _getDOSOutput('ipconfig') & @CRLF 
;ConsoleWrite($arp)

#cs 
	Permite detectar y escanear los dispositivos de la red local. 
	Puede tardar bastante ya que es un escaneo a la fuerza
#ce
Func EscanearRed()
	


	Return True
EndFunc




;Función para crear IDs de respaldo, basada en el código del usuario garyfrost, 
; obtenido de https://www.autoitscript.com/wiki/Snippets_(_Windows_Settings_)#UUID_Generator
Func GenerarID()
	
	Const $ERROR_SUCCESS = 0
	Const $RPC_S_OK = $ERROR_SUCCESS
	Const $RPC_S_UUID_LOCAL_ONLY = 1824
	Const $RPC_S_UUID_NO_ADDRESS = 1739

	Local $_GUID = DllStructCreate("uint;ushort;ushort;ubyte[8]")
	If @error Then Exit

	Local $ret = DllCall("Rpcrt4.dll", "ptr", "UuidCreate", "ptr", DllStructGetPtr($_GUID))
	Local $uuid
	If Not @error Then
		If $ret[0] = $ERROR_SUCCESS Then
			$uuid = Hex(DllStructGetData($_GUID, 1), 8) & "-" & _
				Hex(DllStructGetData($_GUID, 2), 4) & "-" & _
				Hex(DllStructGetData($_GUID, 3), 4) & "-" & _
				Hex(DllStructGetData($_GUID, 4, 1), 2) & Hex(DllStructGetData($_GUID, 4, 2), 2) & "-"
			For $x = 3 To 8
			$uuid = $uuid & Hex(DllStructGetData($_GUID, 4, $x), 2)
			Next
		EndIf
	EndIf
	$_GUID = 0


	Return $uuid
EndFunc

#cs 
	Función para obtener el resultado de un comando ejecutado en la terminal de Windows
	Tomado del código compartido por Xenobiologist en https://stackoverflow.com/questions/71068339/how-to-run-wsl-programs-within-autoit
#ce
Func _getDOSOutput($command)
    Local $text = '', $Pid = Run('"' & @ComSpec & '" /c ' & $command, '', @SW_HIDE, 2 + 4)
    While 1
        $text &= StdoutRead($Pid, False, False)
        If @error Then ExitLoop
        Sleep(10)
    WEnd
    Return $text
EndFunc

Func AgregarDatosAControl($Control, $datos)
	GUICtrlSetData($Control, GUICtrlRead($Control) & @CRLF & $datos)
EndFunc