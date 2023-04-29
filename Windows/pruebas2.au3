#include <Inet.au3>
$sPag = _INetGetSource("https://npcap.com/dist/")
$aLink = StringRegExp($sPag,'npcap-[0-9]\.[0-9][0-9]\.exe',1)
$sLinkNpcap = "https://npcap.com/dist/" & $aLink[0]
$iDescargaNpcapTotal = InetGetSize($sLinkNpcap)
ConsoleWrite ("Descargando " & $iDescargaNpcapTotal & " bytes")
$oDescargaNpcap = InetGet($sLinkNpcap,$aLink[0],8,1)

Do
    Sleep(50)
	$iPorc = (InetGetInfo($oDescargaNpcap,0) / $iDescargaNpcapTotal * 100)
	ConsoleWrite(InetGetInfo($oDescargaNpcap,0) & "(" & $iPorc & "%)" & @CRLF)
Until InetGetInfo($oDescargaNpcap, $INET_DOWNLOADCOMPLETE)

InetClose($oDescargaNpcap)