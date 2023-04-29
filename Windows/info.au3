Global Const $sNotAvailable = "N/A"
Global Const $sBlankIP = "0.0.0.0"
Global Const $sBlankMAC = "00:00:00:00:00:00"

;~ #include <Array.au3>
;~ _ArrayDisplay(_GetListAdaptersInfo("."))

Func _GetListAdaptersInfo($sComputer = ".")
    Local $Cols = 13, $strIndex, $objVAR, $objVARx, $zAdapter, $zAdapterName, $zSpeed, $zIndex, $zInterfaceIndex, $zGetIPType, $zAdapterStatus, $zIP, $zMAC, $zSubNetIP, $zGetwayIP, $zDNS1, $zGetwayMAC, $zDNS2
    Local $aReturn[1][$Cols] = [[0, $Cols]]
    If $sComputer = Default Then $sComputer = @ComputerName
    	Local $sListIndexInterfaceName = _ListIndexInterfaceName()
    	Local $objWMI = ObjGet("winmgmts:\\" & $sComputer & "\root\cimv2")
		Local $objWQLx = $objWMI.ExecQuery("SELECT * FROM Win32_NetworkAdapter WHERE NetConnectionID != NULL", "WQL", 0x30)
		;~  Local $objWQLx = $objWMI.ExecQuery('Select * From Win32_NetworkAdapter', "WQL", 0x30)
    If Not @error And IsObj($objWQLx) Then
        For $objVARx In $objWQLx
            $zAdapterName = $objVARx.NetConnectionID
            If (StringStripWS($zAdapterName, 8) = "") Then ContinueLoop
            $zSpeed = _ByteSuffixRound($objVARx.Speed) ; Vista+
            If Int($zSpeed) <= 0 Then
                For $z = 0 To UBound($sListIndexInterfaceName) - 1
                    If $sListIndexInterfaceName[$z][1] = $zAdapterName Then $zSpeed = _ByteSuffixRound(InterfaceIndexSpeed($sListIndexInterfaceName[$z][0]))
                Next
            EndIf
            $zAdapterStatus = $objVARx.NetConnectionStatus
            Switch $zAdapterStatus
                Case 0, 3
                    $zAdapterStatus = "Disable"
                Case 1, 2
                    $zAdapterStatus = "Connected"
                Case $zAdapterStatus = 7
                    $zAdapterStatus = "unPlugged"
                Case Else
                    $zAdapterStatus = $sNotAvailable
            EndSwitch
            $strIndex = $objVARx.Index
            Local $objWQL = $objWMI.ExecQuery('SELECT * FROM Win32_NetworkAdapterConfiguration WHERE Index=' & $strIndex, "WQL", 0x30)
            If Not @error And IsObj($objWQL) Then
                For $objVAR In $objWQL
                    $zAdapter = $objVAR.Description
                    $aReturn[0][0] += 1
                    $zIndex = $aReturn[0][0]
                    ReDim $aReturn[$zIndex * 2][$aReturn[0][1]]
                    $zInterfaceIndex = $objVAR.InterfaceIndex
                    If Int($zInterfaceIndex) <= 0 Then
                        For $z = 0 To UBound($sListIndexInterfaceName) - 1
                            If $sListIndexInterfaceName[$z][1] = $zAdapterName Then $zInterfaceIndex = $sListIndexInterfaceName[$z][0]
                        Next
                    EndIf
                    $aReturn[$zIndex][0] = $zInterfaceIndex
                    $aReturn[$zIndex][1] = $zAdapter
                    $aReturn[$zIndex][2] = $zAdapterName
                    $aReturn[$zIndex][3] = $zAdapterStatus
                    $zGetIPType = $objVAR.DHCPEnabled
                    If $zGetIPType Then
                        $zGetIPType = "DHCP"
                    Else
                        $zGetIPType = "StaticIP"
                    EndIf
                    $aReturn[$zIndex][4] = $zGetIPType
                    $zIP = $objVAR.IPAddress(0)
                    If StringStripWS($zIP, 8) = "" Then $zIP = $sNotAvailable
                    $aReturn[$zIndex][5] = $zIP
                    $zSubNetIP = $objVAR.IPSubnet(0)
                    If StringStripWS($zSubNetIP, 8) = "" Then $zSubNetIP = $sNotAvailable
                    $aReturn[$zIndex][6] = $zSubNetIP
                    $zMAC = $objVAR.MACAddress
                    If StringStripWS($zMAC, 8) = "" Then $zMAC = $sNotAvailable
                    $aReturn[$zIndex][7] = $zMAC
                    $zGetwayIP = $objVAR.DefaultIPGateway(0)
                    If StringStripWS($zGetwayIP, 8) = "" Then $zGetwayIP = $sNotAvailable
                    $aReturn[$zIndex][8] = $zGetwayIP
                    $zGetwayMAC = $sNotAvailable
                    If $zGetwayIP <> $sNotAvailable Then $zGetwayMAC = _GetMACFromIP($zGetwayIP)
                    $aReturn[$zIndex][9] = $zGetwayMAC
                    $aReturn[$zIndex][10] = $sNotAvailable
                    $aReturn[$zIndex][11] = $sNotAvailable
                    If Number($zSpeed) = 0 Then $zSpeed = $sNotAvailable
                    $aReturn[$zIndex][12] = $zSpeed
                    Local $zDNS = $objVAR.DNSServerSearchOrder()
                    If IsArray($zDNS) Then
                        If (UBound($zDNS) - 1) > 0 Then
                            $aReturn[$zIndex][10] = $zDNS[0]
                            $aReturn[$zIndex][11] = $zDNS[1]
                        Else
                            $aReturn[$zIndex][10] = $zDNS[0]
                        EndIf
                    EndIf
                Next
            EndIf
        Next
        Return $aReturn
    EndIf
    Return SetError(1, 0, "")
EndFunc   ;==>_GetListAdaptersInfo

Func _ListIndexInterfaceName()
    Local Const $tagIP_ADAPTER_ADDRESSES = "ulong Length;dword IfIndex;ptr Next;ptr AdapterName;ptr FirstUnicastAddress;" & "ptr FirstAnycastAddress;ptr FirstMulticastAddress;ptr FirstDnsServerAddress;ptr DnsSuffix;ptr Description;" & "ptr FriendlyName;byte PhysicalAddress[8];dword PhysicalAddressLength;dword Flags;dword Mtu;dword IfType;int OperStatus;" & "dword Ipv6IfIndex;dword ZoneIndices[16];ptr FirstPrefix;" & "uint64 TransmitLinkSpeed;uint64 ReceiveLinkSpeed;ptr FirstWinsServerAddress;ptr FirstGatewayAddress;" & "ulong Ipv4Metric;ulong Ipv6Metric;uint64 Luid;STRUCT;ptr Dhcpv4ServerSockAddr;int Dhcpv4ServerSockAddrLen;ENDSTRUCT;" & "ulong CompartmentId;STRUCT;ulong NetworkGuidData1;word NetworkGuidData2;word NetworkGuidData3;byte NetworkGuidData4[8];ENDSTRUCT;" & "int ConnectionType;int TunnelType;STRUCT;ptr Dhcpv6ServerSockAddr;int Dhcpv6ServerSockAddrLen;ENDSTRUCT;byte Dhcpv6ClientDuid[130];" & "ulong Dhcpv6ClientDuidLength;ulong Dhcpv6Iaid;ptr FirstDnsSuffix;"
    Local $aRet, $nBufSize, $stBuffer, $stIP_ADAPTER_ADDRESSES, $pIPAAStruct, $nIPAAStSize
    Local $pTemp, $nTemp, $nEntries, $aIndexEntries
    $aRet = DllCall("iphlpapi.dll", "ulong", "GetAdaptersAddresses", "ulong", 0, "ulong", 0x86, "ptr", 0, "ptr", 0, "ulong*", 0)
    If @error Then Return SetError(1, @error, "")
    If $aRet[0] Then
        If $aRet[0] <> 111 Or Not $aRet[5] Then Return SetError(2, $aRet[0], "")
    EndIf
    $nBufSize = $aRet[5]
    $stBuffer = DllStructCreate("int64;byte [" & $nBufSize & "];")
    $aRet = DllCall("iphlpapi.dll", "ulong", "GetAdaptersAddresses", "ulong", 0, "ulong", 0x86, "ptr", 0, "ptr", DllStructGetPtr($stBuffer), "ulong*", $nBufSize)
    If @error Then Return SetError(1, @error, "")
    If $aRet[0] Then Return SetError(2, $aRet[0], "")
    Dim $aIndexEntries[Floor($nBufSize / 72)][2]
    $nEntries = 0
    $pIPAAStruct = DllStructGetPtr($stBuffer)
    While $pIPAAStruct <> 0
        $stIP_ADAPTER_ADDRESSES = DllStructCreate($tagIP_ADAPTER_ADDRESSES, $pIPAAStruct)
        $nIPAAStSize = DllStructGetData($stIP_ADAPTER_ADDRESSES, "Length")
        $nTemp = DllStructGetData($stIP_ADAPTER_ADDRESSES, "OperStatus")
        If ($nTemp = 2 And Not False) Or DllStructGetData($stIP_ADAPTER_ADDRESSES, "IfType") = 24 Then
        Else
            $pTemp = DllStructGetData($stIP_ADAPTER_ADDRESSES, "FirstUnicastAddress")
            If $pTemp <> 0 Then
                $aIndexEntries[$nEntries][0] = DllStructGetData($stIP_ADAPTER_ADDRESSES, "IfIndex")
                $aIndexEntries[$nEntries][1] = _GetStringW_FromPtr(DllStructGetData($stIP_ADAPTER_ADDRESSES, "FriendlyName"))
                $nEntries += 1
            EndIf
        EndIf
        $pIPAAStruct = DllStructGetData($stIP_ADAPTER_ADDRESSES, "Next")
    WEnd
    If $nEntries = 0 Then Return SetError(-1, 0, "")
    ReDim $aIndexEntries[$nEntries][2]
    Return SetExtended($nEntries, $aIndexEntries)
EndFunc   ;==>_ListIndexInterfaceName

Func InterfaceIndexSpeed($IfIndex)
    Local $tBuffer, $pBuffer, $iResult, $iSpeed
    $tBuffer = DllStructCreate("wchar[256];dword[5];byte[8];dword[16];char[256]")
    $pBuffer = DllStructGetPtr($tBuffer)
    DllStructSetData($tBuffer, 2, $IfIndex, 1)
    $iResult = DllCall("iphlpapi.dll", "long", "GetIfEntry", "ptr", $pBuffer)
    If @error Then Return SetError(@error, @extended, 0)
    $iSpeed = DllStructGetData($tBuffer, 2, 4)
;~  $sDescr = DllStructGetData($tBuffer, 5)
    $tBuffer = 0
    Return SetError($iResult[0], $iSpeed / 1000 / 1000, $iSpeed)
EndFunc   ;==>InterfaceIndexSpeed
Func _GetStringW_FromPtr($pStr)
    If Not IsPtr($pStr) Or $pStr = 0 Then Return SetError(1, 0, "")
    Local $aRet = DllCall("kernel32.dll", "ptr", "lstrcpynW", "wstr", "", "ptr", $pStr, "int", 32767)
    If @error Or Not $aRet[0] Then Return SetError(@error, 0, "")
    Return $aRet[1]
EndFunc   ;==>_GetStringW_FromPtr

Func _GetMACFromIP($rMAC)
    If ($rMAC = "") Or ($rMAC = $sNotAvailable) Then Return $sNotAvailable
    Local $sbMAC = DllStructCreate("byte[6]")
    Local $siMAC = DllStructCreate("int")
    DllStructSetData($siMAC, 1, 6)
    Local $rHexMAC = DllCall("Ws2_32.dll", "int", "inet_addr", "str", $rMAC)
    $rMAC = $rHexMAC[0]
    $rHexMAC = DllCall("iphlpapi.dll", "int", "SendARP", "int", $rMAC, "int", 0, "ptr", DllStructGetPtr($sbMAC), "ptr", DllStructGetPtr($siMAC))
    $rMAC = ""
    For $i = 0 To 5
        If $i Then $rMAC &= ":"
        $rMAC = $rMAC & Hex(DllStructGetData($sbMAC, 1, $i + 1), 2)
    Next
    If ($rMAC = "") Or ($rMAC = $sBlankMAC) Or ($rMAC = $sNotAvailable) Then Return $sNotAvailable
    Return $rMAC
EndFunc   ;==>_GetMACFromIP

Func _ByteSuffixRound($iBytes, $iRound = 2)
    $iBytes = Number($iBytes)
    If $iBytes > 1000000000 Then Return $sNotAvailable
    Local $A, $aArray[5] = ["Bps", "Kbps", "Mbps", "Gbps", "Tbps"]
    While $iBytes > 999
        $A += 1
        If $A > 3 Then ExitLoop
        $iBytes /= 1000
    WEnd
    Return Round($iBytes, $iRound) & " " & $aArray[$A]
EndFunc   ;==>_ByteSuffixRound
;==>CreateContentCSV5

_GetListAdaptersInfo()