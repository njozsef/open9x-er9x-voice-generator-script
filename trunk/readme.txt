usage (commandline):
c:\> cscript.exe vbs_wav_open9x.vbs en-stock_open9x.csv en-stock.zip 100 0
 parameter1= volume (0-100)
 parameter2= speed (0~5)
 
 or doube click en-stock_open9x.cmd

This code generate wavs from csv on .\temp folder and .\ folder zip file
with default (actual TTS voice)




required:
9x rc transmitter with VOICE-mod
open9x or er9x firmware with voice compile option
windows xp/window7  (32 bit)
installed Text-to speech voice font your machine

tools:
Sox.exe (recommended path: c:\voice)
Pkzip.exe (recommended path: .\ )


csv format:
0000.wav;speaktext
or
0001;speaktext;;
0002;
0003;;
or combinations.
skipped row if no speaktext.


functions:
trimming output audio silent block.
normalize
A-law output conversion 16Khz/8bit

if necessary, replace the codec to vbs file line: 168


Magic number: (wav output format):
Magic number, possibly voice specific (0 to 64)



