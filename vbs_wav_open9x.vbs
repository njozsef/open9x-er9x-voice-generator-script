'******************************************
'*   written by Jozsef nagy               *
'* All code-part is ctrl+c and ctrl+v     *
'* from the google.com   :-)              *
'******************************************

'need ttols:  sox, pkzip
'sox path "c:\sox\sox.exe"
'pkzip.exe copy this folder

'parameters
dim SourceFile, DestZipFile, Volume, Rate
Dim arrFileLines()

'main
if WScript.Arguments.Count < 4 then
    WScript.Echo "Missing parameters. ""help"" to detailed list.": WScript.Quit
end if

if WScript.Arguments(0) = "help" then
       WScript.Echo "parameters:  tts.vbs source-.csv-file dest-.zip-file volume(0-100)  rate(0-16)": WScript.Quit
end if


'csv format
'0000;START ENGINE;;
'0001.wav;;
'0002
'0003;flap on
'
SourceFile = Wscript.Arguments.Item(0)
DestZipFile =  Wscript.Arguments.Item(1)
Volume = Wscript.Arguments.Item(2)
Rate = Wscript.Arguments.Item(3)

WScript.Echo SourceFile, Volume,Rate & vbcrlf

Set oFSO = CreateObject("Scripting.FileSystemObject")
 If(Not(oFSO.FolderExists(".\temp"))) Then
      oFSO.CreateFolder(".\temp")
 End If
Set oFSO = Nothing

'read text, parse, seak, save
ReadTextFile(SourceFile)

'ziping
Dim objResult, objShell
WScript.Echo "zipping..."
WScript.Echo DestZipFile
Set objShell = WScript.CreateObject("WScript.Shell")    
objShell.Run "pkzip.exe" & " " & DestZipFile & " " & "temp\*.wav", 0, True
Set objShell = Nothing
WScript.Quit
'end script


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
	Wscript.Echo "MIssing separate char":WScript.Quit
	end if
	FName=left(arrFileLines(l),pos-1)
	
	'strip .wav"
	SpeakText= trim(right(arrFileLines(l),len(arrFileLines(l))-pos))
	If right(UCase(FName),4)=".WAV" Then FName= Left(FName,Len(FName)-4)  ':Wscript.Echo "debug2 " & FName & "-" & SpeakText

	'find second ; char and cut
	pos=0
	pos=Instr(SpeakText,";")
	If pos>0 then SpeakText= Trim(left(SpeakText,pos-1))
	Wscript.Echo "********************************* " & SpeakText
	If Len(SpeakText)>0 then
		Wscript.Echo FName & "-" & SpeakText
		call generatefile("temp\"& FName,SpeakText)
	End if
Next


end sub

sub generatefile(strFileName,strText)
'.Pause = pause speaking 
'.resume = resume after pause 
'.Rate = speed at which voice speaks 
'.Voice = you can use set and a voice value to change the voice (if multiple exist on machine) 
'.Volume = volume of voice (not system volume, just voice) 
'.WaitUntilDone = wait until done - dont know how else to say that ;) 

'if empty  audio slot
If Len(strText)=0 Then Exit sub

'sapifiletype defined the output wav format: 18=22Khz 16bit mono on "KobaSpeech 2 With Vocalizer Eszter - Hungarian" voice font
'Magic number, possibly voice specific (0 to 64)
Const SapiFileType=31

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
'tune silect cut (begin-end)
objShell.Run "c:\sox\sox.exe " & strFileName & " " & "trimmedtemp.wav" & " " & "silence 1 0.01 0.5% reverse silence 1 0.01 0.5% reverse", 0, True
filesys.DeleteFile strFileName
filesys.MoveFile "trimmedtemp.wav", strFileName

WScript.Echo "Normalize and Convert 16Khz 8bit wav..."
'
'-c 1= number of channels of destination file: 1
'-A = encoding of destination file: a-law
'-t .wav = file format of destination file: WAVE
'-r 16000= sampling rate of destination file: 8kHz
'-b 8= 8 bit audio
'
objShell.Run "c:\sox\sox.exe " & strFileName & " --norm  -c 1 -A -t .wav -b 8 -r 16000  trimmedtemp.wav", 0, True
filesys.DeleteFile strFileName
filesys.MoveFile "trimmedtemp.wav", strFileName


Set objShell = Nothing
Set filesys = Nothing
end sub
