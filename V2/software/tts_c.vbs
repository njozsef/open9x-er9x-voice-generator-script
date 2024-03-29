'******************************************
'*   wroted by Jozsef Nagy                *
'* All code-part is ctrl+c and ctrl+v     *
'* from the google.com   :-)              *
'*                                        *
'      COMPACT (sd-card) version          *
'******************************************

'need tools:  sox, pkzip, AD4CONVERTER
'sox path ".\tool\sox.exe"
'pkzip.exe copy this folder

'parameters
dim SourceFile, DestZipFile, Volume, Rate, CodecFlag, AddSilentMsec
Dim arrFileLines()

'main
if WScript.Arguments.Count =0 then
    WScript.Echo "Missing parameters. ""--help"" to detailed list. Please use by commandline.": WScript.Quit
end if

if WScript.Arguments(0) = "--help" then
	WScript.Echo "           parameters:  tts.vbs source.csv  volume rate [codec]     [AddSilentMsec]"
	WScript.Echo "                                               |      |    |                     | " 
	WScript.Echo "                                              0-100  0-5   |                     |"
	WScript.Echo "                                                           |                     |"
	WScript.Echo "     codec: e=ematree(default) high=16Khz 16bit ad4=emartee ad4 format(not tested)"
	WScript.Echo "                                                     Silent block the samples end"
	WScript.Quit
end if


'***************************
'csv format
'0000;START ENGINE;;
'0001.wav;;
'0002
'0003;flap on
'***************************

SourceFile = Wscript.Arguments.Item(0)
Volume = Wscript.Arguments.Item(1)
Rate = Wscript.Arguments.Item(2)
CodecFlag = Wscript.Arguments.Item(3)


Dim SilentSec 
if WScript.Arguments.Count = 4 then
	'defualt 
	AddSilentMsec=0
else
	AddSilentMsec=Wscript.Arguments.Item(4)
End if



'**************************************
'e= ematree 8Khz 8bit a-law mono
'high = 16Khz 16bit PCM mono
'ad4 = 4bit 32Khz ADPCM mono a-law
'**************************************
if len(CodecFlag)=0 then
	CodecFlag="e"
end if

WScript.Echo SourceFile, Volume,Rate & vbcrlf

Set oFSO = CreateObject("Scripting.FileSystemObject")
 If (oFSO.FolderExists(".\temp")) Then
      oFSO.DeleteFile".\temp\*.*"
 End If
 
 
 If(Not(oFSO.FolderExists(".\temp"))) Then
      oFSO.CreateFolder(".\temp")
 End If
Set oFSO = Nothing

'read text, parse, speak, convert, save
ReadTextFile(SourceFile)



'erase all wavs from root folder
on error resume next
Set oFSO = CreateObject("Scripting.FileSystemObject")
 If (oFSO.FolderExists("..\")) Then
      oFSO.DeleteFile"..\*.wav"
      oFSO.DeleteFile"..\*.ad4"
 End If

'move temp to root folder
ofso.MoveFile "temp\*.wav", "..\"
ofso.MoveFile "temp\*.ad4", "..\"
on error goto 0
Set oFSO = Nothing
WScript.Echo
WScript.Echo
WScript.Echo
WScript.Echo "Emartee wav/ad4 files on root folder..."
WScript.Echo "other 30 day demo voices downloadable: http://www.kobaspeech.com/downloads.html"

WScript.Quit
'end script
'*********************************************************************************************

sub ReadTextFile(SourceFile)
'read
i = 0
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile(SourceFile, 1)
Do Until objFile.AtEndOfStream
     Redim Preserve arrFileLines(i)
     arrFileLines(i) = objFile.ReadLine
     i = i + 1
Loop
objFile.Close
set objFSO = Nothing

'parse and write
dim pos
dim FName, SpeakText
For l = Lbound(arrFileLines) to UBound(arrFileLines) Step 1
    
    'Wscript.Echo arrFileLines(l)
	'parse csv ";" char
	pos=0
	pos=Instr(arrFileLines(l),";")
	
	if pos=0 then
		'skipped empty lines
		'Wscript.Echo "MIssing separate char"   ':WScript.Quit
	end if


	if pos>0 then
		FName=left(arrFileLines(l),pos-1)
		
		'strip '.wav' text from csv
		SpeakText= trim(right(arrFileLines(l),len(arrFileLines(l))-pos))
		If right(UCase(FName),4)=".WAV" Then FName= Left(FName,Len(FName)-4)  ':Wscript.Echo "debug2 " & FName & "-" & SpeakText

		'find second ; char and cut
		pos=0
		pos=Instr(SpeakText,";")
		If pos>0 then SpeakText= Trim(left(SpeakText,pos-1))
		Wscript.Echo "************************************************* " & SpeakText
		If Len(SpeakText)>0 then
			Wscript.Echo FName & "-" & SpeakText
			call generatefile("temp\"& FName,SpeakText)
		End if
	end if
Next


end sub

sub generatefile(strFileName,strText)
'***************************************************************************************************
'speak engine options
'.Pause = pause speaking 
'.resume = resume after pause 
'.Rate = speed at which voice speaks 
'.Voice = you can use set and a voice value to change the voice (if multiple exist on machine) 
'.Volume = volume of voice (not system volume, just voice) 
'.WaitUntilDone = wait until done - dont know how else to say that ;) 
'***************************************************************************************************

'if empty  audio slot
If Len(strText)=0 Then Exit sub

'*********************************************************************************************************************************
'sapifiletype defined the output wav format: 18=22Khz 16bit mono on "KobaSpeech 2 With Vocalizer Eszter - Hungarian" voice font
'Magic number, possibly voice specific (0 to 64)
'if destination wav wrong, please decrease the Sapifiletype step -1. Sorry.
'SAFT48kHz16BitMono = 38
'SAFT22kHz16BitMono = 22
'please see readme.txt
'*********************************************************************************************************************************
Const SapiFileType=22

With CreateObject("Scripting.FileSystemObject")
 strFile=.BuildPath(.GetParentFolderName(WScript.ScriptFullName), strFileName & ".wav")
 Wscript.Echo strFile
 If .FileExists(strFile) Then .DeleteFile strFile
End With

With CreateObject("Sapi.SpVoice")
 Set ss=CreateObject("Sapi.SpFileStream")
 ss.Format.Type=SapiFileType
 ss.Open strFile,3,False
 Set .AudioOutputStream=ss
 .Rate = Rate
 .Volume = Volume
 .Speak strText,8
 .waituntildone(-1)
 ss.Close
 Set ss=Nothing
End With

'silent cut and recode
call removesilent(strFile)
end sub


sub removesilent(strFileName)
dim filesys
Set filesys = CreateObject("Scripting.FileSystemObject")

If filesys.FileExists("trimmedtemp.wav") Then
        filesys.DeleteFile "trimmedtemp.wav"
End If

Dim  objShell
Set objShell = WScript.CreateObject("WScript.Shell")    
WScript.Echo "Trim silent..."
'tune silent cut (begin-end)
objShell.Run "tool\sox.exe " & strFileName & " " & "trimmedtemp.wav" & " " & "silence 1 0.01 0.5% reverse silence 1 0.01 0.5% reverse", 0, True
filesys.DeleteFile strFileName
filesys.MoveFile "trimmedtemp.wav", strFileName


if AddSilentMsec>0 Then
	SilentSec=AddSilentMsec/1000
	'optional:add silence all files (20msec)
	'sox.exe  source dest pad 0 0.02 reverse reverse
	'****************************************************************************************************************************
	WScript.Echo "add "& AddSilentMsec &" msec silent..."
	objShell.Run "tool\sox.exe " & strFileName & " " & "trimmedtemp.wav" & " " & " pad 0 "& SilentSec &" reverse reverse", 0, True
	filesys.DeleteFile strFileName
	filesys.MoveFile "trimmedtemp.wav", strFileName
	'****************************************************************************************************************************
End if





'****************** sox opt ************************************
'-c 1 = number of channels of destination file: 1
'-A = encoding of destination file: a-law
'-t .wav = file format of destination file: WAVE
'-r 16000 = sampling rate of destination file: 8kHz
'-b 8 = 8 bit audio
'--norm = normalize
'***************************************************************
if CodecFlag="e" then
  WScript.Echo "Normalize and Convert Emartee 8bit 16kHz wav..."
  objShell.Run "tool\sox.exe " & strFileName & " --norm -c 1 -t .wav -b 8 -r 16000  tempconvert.wav", 0, True
  filesys.DeleteFile strFileName
  filesys.MoveFile "tempconvert.wav", strFileName
  objShell.Run "tool\sox.exe " & strFileName & " tempconvert.wav  gain -6 treble +3 ", 0, True
  filesys.DeleteFile strFileName
  filesys.MoveFile "tempconvert.wav", strFileName
end if






if CodecFlag="high" then
  WScript.Echo "Normalize and Convert high quality 16bit 22kHz mono wav..."
  objShell.Run "tool\sox.exe " & strFileName & " --norm -c 1 -t .wav -b 16 -r 22000  tempconvert.wav", 0, True
  filesys.DeleteFile strFileName
  filesys.MoveFile "tempconvert.wav", strFileName
end if

if CodecFlag="ad4" then
	objShell.Run "tool\sox.exe " & strFileName & " --norm -c 1  -t .wav -b 16 -r 32000  tempconvert.wav", 0, True
	filesys.DeleteFile strFileName
	filesys.MoveFile "tempconvert.wav", strFileName
	WScript.Echo "Generete AD4 32kHz..."
	objShell.Run "tool\sox.exe " & strFileName & " tempconvert.wav  gain -6 treble +3 ", 0, True
	objShell.Run "tool\AD4CONVERTER.EXE -E4 " & "tempconvert.wav " & left(strFileName,len(strFileName)-4) & ".AD4", 0, True
	filesys.DeleteFile "tempconvert.wav"
	filesys.DeleteFile strFileName
end if

Set objShell = Nothing
Set filesys = Nothing
end sub
