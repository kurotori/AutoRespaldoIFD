;UUID Generator

Const $ERROR_SUCCESS = 0
Const $RPC_S_OK = $ERROR_SUCCESS
Const $RPC_S_UUID_LOCAL_ONLY = 1824
Const $RPC_S_UUID_NO_ADDRESS = 1739

;~ typedef struct _GUID {
;~ unsigned long Data1;
;~ unsigned short Data2;
;~ unsigned short Data3;
;~ unsigned char Data4[8];
;~ } GUID, UUID;
;~ Data1
;~ Specifies the first 8 hexadecimal digits of the UUID.
;~ Data2
;~ Specifies the first group of 4 hexadecimal digits of the UUID.
;~ Data3
;~ Specifies the second group of 4 hexadecimal digits of the UUID.
;~ Data4
;~ Array of eight elements. The first two elements contain the third group of 4 hexadecimal digits of the UUID.
;~ The remaining six elements contain the final 12 hexadecimal digits of the UUID.

Local $_GUID = DllStructCreate("uint;ushort;ushort;ubyte[8]")
If @error Then Exit

;~ RPC_STATUS RPC_ENTRY UuidCreate(
;~ UUID __RPC_FAR* Uuid
;~ );

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
  MsgBox(0,"UUID", $uuid & @LF & @LF & "Note:" & @LF & _
   "In Windows NT 4.0, Windows Me/98, and Windows 95 DCOM release," & @LF & _
   "UuidCreate returns RPC_S_UUID_LOCAL_ONLY when the originating computer" & @LF & _
   "does not have an ethernet/token ring (IEEE 802.x) address." & @LF & _
   "In this case, the generated UUID is a valid identifier, and is" & @LF & _
   "guaranteed to be unique among all UUIDs generated on the computer." & @LF & @LF & _
   "However, the possibility exists that another computer without an" & @LF & _
   "ethernet/token ring address generated the identical UUID." & @LF & @LF & _
   "Therefore you should never use this UUID to identify an object" & @LF & _
   "that is not strictly local to your computer." & @LF & @LF & _
   "Computers with ethernet/token ring addresses generate UUIDs that" & @LF & _
   "are guaranteed to be globally unique.")
EndIf
EndIf
$_GUID = 0