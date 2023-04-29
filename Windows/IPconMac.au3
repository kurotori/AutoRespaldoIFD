#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>

Local $sComputer = "."
Local $objWMI = ObjGet("winmgmts:\\" & $sComputer & "\root\cimv2")
Local $objW32_NetAd = $objWMI.ExecQuery("SELECT * FROM Win32_NetworkAdapter WHERE NetConnectionID != NULL", "WQL", 0x30)
Local $objW32_NetAdConf = $objWMI.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration")


Local $iEstadoOK = 0

;Búsqueda e instalación de NMAP
If (FileExists("./nmap")) Then
	;ConsoleWrite("nmap instalado")
	$iEstadoOK = 1
Else
	;ConsoleWrite("nmap no instalado")
	$iInstalarNmap = MsgBox(20,"NMap no Instalado","No se ha detectado NMap" & @CRLF &"¿Descargar e Instalar?")
	If ($iInstalarNmap == 7) Then
		MsgBox($MB_ICONERROR, "No se puede continuar", "Se requiere NMap para continuar")
	Else

	EndIf
EndIf

If ($iEstadoOK == 1) Then
		
	#Region ### START Koda GUI section ### Form=E:\MEGA\GitHub\buscarMV\Windows\VentanaV2.kxf
	$frmBusqIPxMAC = GUICreate("Búsqueda de IP por MAC", 465, 450, 317, 134)
	$cmbSelIntfRed = GUICtrlCreateCombo("cmbSelIntfRed", 16, 48, 321, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
	$lblSecIntfRed = GUICtrlCreateLabel("Interfáz de Red", 16, 16, 115, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$Group1 = GUICtrlCreateGroup("Datos de la Interfáz", 16, 88, 440, 153)
	$lblEstado = GUICtrlCreateLabel("Estado:", 24, 168, 57, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$lblIPv4 = GUICtrlCreateLabel("IPv4:", 24, 192, 38, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$lblIPv6 = GUICtrlCreateLabel("IPv6:", 24, 216, 38, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$lblMAC = GUICtrlCreateLabel("MAC:", 24, 144, 40, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$lblMACe = GUICtrlCreateLabel(". . . . . .", 88, 144, 360, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$lblEstadoE = GUICtrlCreateLabel(". . . . . . ", 88, 168, 360, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$lblIPv4e = GUICtrlCreateLabel(". . . . .", 88, 192, 360, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$lblIPv6e = GUICtrlCreateLabel(". . . . .", 88, 216, 360, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$lblNombreIntf = GUICtrlCreateLabel("....", 24, 120, 420, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Label1 = GUICtrlCreateLabel("MAC a Buscar:", 24, 256, 123, 24)
	GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
	$inptMacABuscar = GUICtrlCreateInput("", 24, 280, 425, 21)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$Label2 = GUICtrlCreateLabel("IP o Resultado:", 24, 376, 128, 24)
	GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
	$inptIPResultado = GUICtrlCreateInput("", 24, 400, 425, 21)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$btnBuscar = GUICtrlCreateButton("Buscar", 192, 312, 97, 33)
	GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
	$Progress1 = GUICtrlCreateProgress(24, 352, 425, 17)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	;; Consultas a WMI.
	;; Fuentes: https://www.autoitscript.com/forum/files/file/396-network-adapters-info/
	;; 			https://learn.microsoft.com/en-us/windows/win32/wmisdk/wmi-tasks--networking

	Local $sComputer = "."
	Local $objWMI = ObjGet("winmgmts:\\" & $sComputer & "\root\cimv2")
	Local $objW32_NetAd = $objWMI.ExecQuery("SELECT * FROM Win32_NetworkAdapter WHERE NetConnectionID != NULL", "WQL", 0x30)
	Local $objW32_NetAdConf = $objWMI.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration")

	;Funciones Auxiliares: 
	Local $sIpV4Adaptador = ""
	Local $sIpV6Adaptador = ""
	Local $sMascaraRedV4 = ""
	Local $sMascaraRedV6 = ""
	Local $sRangoIP = ""

	; Cantidad de Adaptadores de Red
	Local $iCantNetAd = 0
	Local $sDatosConn = ""
	Local $sDatosCombo = ""

	Local $aIntfSeleccionada = ""

	For $objNC In $objW32_NetAd
		$sDatosCombo = $sDatosCombo & $objNC.NetConnectionID & " (" & $objNC.MACAddress &")|"
		$sDatosConn=$sDatosConn & $objNC.NetConnectionID & ";" & $objNC.Description & ";" & $objNC.MACAddress & ";" & $objNC.NetConnectionStatus & "%"
		$iCantNetAd += 1
	Next

	$sDatosCombo = StringTrimRight($sDatosCombo,1)
	$sDatosConn = StringTrimRight($sDatosConn,1)
	;ConsoleWrite($sDatosConn)


	GUICtrlSetData($cmbSelIntfRed,$sDatosCombo)
	$aInterfacesRed = StringSplit($sDatosConn,"%")

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $cmbSelIntfRed
				$sDato=GUICtrlRead($cmbSelIntfRed)

				;Se toma el dato del combobox (Descripcion + MAC), se extrae el MAC y se remueven los paréntesis. Queda solo el MAC
				$sDato = StringSplit($sdato,"(")
				
				;Si en la posición 0 encontramos un valor mayor a 1, continuamos (StringSplit coloca ahí el número de elementos del array obtenido al realizar el split)
				If ($sDato[0]>1) Then
					$sMACSel = StringTrimRight( $sDato[2], 1)

					;Recorremos el array con los datos generales buscando la MAC de la interfáz
					For $sIntf In $aInterfacesRed

						;Al encontrar la correspondiente, se agregan sus datos a la ventana
						If (StringInStr($sIntf,$sMACSel)) Then
							$aIntfSeleccionada = StringSplit($sIntf,";")
		
							GUICtrlSetData($lblNombreIntf, $aIntfSeleccionada[1] & " (" & $aIntfSeleccionada[2] & ")")
							GUICtrlSetData($lblMACe,$aIntfSeleccionada[3])
							
							;Análisis del estado de la conexión
							Local $sIntfEstado = ""
							Switch ($aIntfSeleccionada[4])
								Case 0
									$sIntfEstado = "Desconectado"
									GUICtrlSetState($inptMacABuscar,$GUI_DISABLE)
								Case 1
									$sIntfEstado = "Conectándose"
									GUICtrlSetState($inptMacABuscar,$GUI_DISABLE)
								Case 2
									$sIntfEstado = "Conectado"
									GUICtrlSetState($inptMacABuscar,$GUI_ENABLE)
								Case 3
									$sIntfEstado = "Desconectándose"
									GUICtrlSetState($inptMacABuscar,$GUI_DISABLE)
								Case 4
									$sIntfEstado = "Hardware no presente"
									GUICtrlSetState($inptMacABuscar,$GUI_DISABLE)
								Case 5
									$sIntfEstado = "Hardware no presente"
									GUICtrlSetState($inptMacABuscar,$GUI_DISABLE)
								Case 6
									$sIntfEstado = "Malfuncionamiento del hardware"
									GUICtrlSetState($inptMacABuscar,$GUI_DISABLE)
								Case 7
									$sIntfEstado = "Medios desconectados"
									GUICtrlSetState($inptMacABuscar,$GUI_DISABLE)
								Case 8
									$sIntfEstado = "Autenticando"
									GUICtrlSetState($inptMacABuscar,$GUI_DISABLE)
								Case 9
									$sIntfEstado = "Autenticación exitosa"
									GUICtrlSetState($inptMacABuscar,$GUI_DISABLE)
								Case 10
									$sIntfEstado = "Fallo de autenticación"
									GUICtrlSetState($inptMacABuscar,$GUI_DISABLE)
								Case 11
									$sIntfEstado = "Dirección no válida"
									GUICtrlSetState($inptMacABuscar,$GUI_DISABLE)
								Case 12
									$sIntfEstado = "Se requieren credenciales"
									GUICtrlSetState($inptMacABuscar,$GUI_DISABLE)
								Case Else
									$sIntfEstado = "...."
									GUICtrlSetState($inptMacABuscar,$GUI_DISABLE)
							EndSwitch
		
							GUICtrlSetData($lblEstadoE,$sIntfEstado)

							;Obtención de los datos de configuración y conexión
							$objConsultaConfig = $objWMI.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration")
							$aDatosIP = ""

							;$aIntfSeleccionada[3] --> MAC de la interfáz

							;Proceso de datos de configuración y conexión
							For $objDatosIP In $objConsultaConfig

								;Búsqueda del MAC en los datos
								If (StringInStr($objDatosIP.MACAddress, $aIntfSeleccionada[3])) Then
									
									;Detección y Muestra de la IP en la GUI
									;Si hay al menos una IP en el array IPAddress, esta se procesa y muestra
									$iNumIps = UBound($objDatosIP.IPAddress)
									If ($iNumIps > 0) Then
										For $sIp In $objDatosIP.IPAddress
											;RegExp para detectar IPv4
											If (StringRegExp($sIp,"^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$")) Then
												$sIpV4Adaptador = $sIP
												
											Else
												$sIpV6Adaptador = $sIp
												
											EndIf

										Next
									Else
										$sIpV4Adaptador = "...."
										$sIpV6Adaptador = "...."
									EndIf
									
									;Proceso de las Máscaras de Red
									$iNumMascRed = UBound($objDatosIP.IPSubnet)
									If ($iNumMascRed > 0) Then 
										For $sMasc In $objDatosIP.IPSubnet
											;ConsoleWrite($sMasc & @CRLF)
											;RegExp para detectar IPv4
											If (StringRegExp($sMasc,"^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$")) Then
												$sIpV4Adaptador = $sIpV4Adaptador & "\" & $sMasc
												
											Else
												$sIpV6Adaptador = $sIpV6Adaptador & "\" & $sMasc
												
											EndIf
										Next
									EndIf	
								EndIf
									GUICtrlSetData($lblIPv4e,$sIpV4Adaptador)
									GUICtrlSetData($lblIPv6e,$sIpV6Adaptador)
							Next
						EndIf
					Next
				Else
					GUICtrlSetData($lblNombreIntf, "....")
					GUICtrlSetData($lblMACe,"....")
					GUICtrlSetData($lblEstadoE,"....")
				EndIf

				

			Case $GUI_EVENT_CLOSE
				Exit

		EndSwitch
	WEnd
EndIf



