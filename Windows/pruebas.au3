#include <Inet.au3>
$sPagNmap = _INetGetSource("https://nmap.org/dist/")
$aLinkNmap = StringRegExp($sPagNmap,'nmap-[0-9]\.[0-9][0-9]-setup\.exe',1)
$sLinkNmap = "https://nmap.org/dist/" & $aLinkNmap[0]
ConsoleWrite($sLinkNmap & @CRLF)