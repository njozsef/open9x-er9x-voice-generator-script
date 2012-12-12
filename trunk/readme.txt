USAGE (COMMANDLINE):
c:\> cscript.exe tts.vbs en-stock_open9x.csv en-stock.zip 100 0  [codec] [AddSilentMsec]
 parameter1= volume (0-100)
 parameter2= speed (0~5)
[ parameter3= [e] | ad4 | high ]   (e=emartee 8khz 8bit pcm)
[ end silent in msec]

 or doube click en-stock_open9x_emartee.cmd
 
 or doube click en-stock_open9x.cmd

This code generate wavs and AD4 from csv on .\temp folder and .\ folder zip file
with default (actual TTS voice)

PROJECT TESTED with emartee audio board!!!!

option: AD4	best results
	e	best results
	high	for post production (not upload the emartee)

REQUIRED:
9x rc transmitter with VOICE-mod
open9x or er9x firmware with voice compile option
windows xp/window7  (32 bit)
installed Text-to speech voice font your machine

TOOLS:
Sox.exe (recommended path: c:\sox\)
http://sourceforge.net/projects/sox/

Pkzip.exe (commandline addon. recommended path: .\ )
http://www.pkware.com/

CSV FORMAT:
0000.wav;speaktext
or
0001;speaktext;;
0002;
0003;;
or combinations.
skipped row if no speaktext.


FUNCTIONS:
trimming output audio silent block.
normalize
optional (commented char ' this line on source) A-law output conversion 16Khz/8bit .wav
output conversion 16Khz/16bit .wav
output conversion 32kHz/4bit ADPCM .AD4
if necessary, replace the codec, from vbs file line: ~168

REMARK:
Magic number: (wav output format):
Magic number, possibly voice specific (0 to 64) please decrement if generate wrong wavs.
best results for native speak engine settings (usually 22khz 16 bit mono)


----------------------------------------------------------------------------------------------------

http://msdn.microsoft.com/en-us/library/ms720595(v=vs.85).aspx

SpeechAudioFormatType (SAPI 5.3)
Speech API 5.3 0 out of 2 rated this helpful - Rate this topic
Microsoft Speech API 5.3
SpeechAudioFormatType Enum
The SpeechAudioFormatType enumeration lists the supported stream formats.

These enumeration elements are all common audio formats ranging from the uncompressed PCM formats to highly compressed formats. They are available as standard formats on the Windows operating systems and are supported by SAPI 5.


Definition

Enum SpeechAudioFormatType
    SAFTDefault = -1
    SAFTNoAssignedFormat = 0
    SAFTText = 1
    SAFTNonStandardFormat = 2
    SAFTExtendedAudioFormat = 3

    // Standard PCM wave formats
    SAFT8kHz8BitMono = 4
    SAFT8kHz8BitStereo = 5
    SAFT8kHz16BitMono = 6
    SAFT8kHz16BitStereo = 7
    SAFT11kHz8BitMono = 8
    SAFT11kHz8BitStereo = 9
    SAFT11kHz16BitMono = 10
    SAFT11kHz16BitStereo = 11
    SAFT12kHz8BitMono = 12
    SAFT12kHz8BitStereo = 13
    SAFT12kHz16BitMono = 14
    SAFT12kHz16BitStereo = 15
    SAFT16kHz8BitMono = 16
    SAFT16kHz8BitStereo = 17
    SAFT16kHz16BitMono = 18
    SAFT16kHz16BitStereo = 19
    SAFT22kHz8BitMono = 20
    SAFT22kHz8BitStereo = 21
    SAFT22kHz16BitMono = 22
    SAFT22kHz16BitStereo = 23
    SAFT24kHz8BitMono = 24
    SAFT24kHz8BitStereo = 25
    SAFT24kHz16BitMono = 26
    SAFT24kHz16BitStereo = 27
    SAFT32kHz8BitMono = 28
    SAFT32kHz8BitStereo = 29
    SAFT32kHz16BitMono = 30
    SAFT32kHz16BitStereo = 31
    SAFT44kHz8BitMono = 32
    SAFT44kHz8BitStereo = 33
    SAFT44kHz16BitMono = 34
    SAFT44kHz16BitStereo = 35
    SAFT48kHz8BitMono = 36
    SAFT48kHz8BitStereo = 37
    SAFT48kHz16BitMono = 38
    SAFT48kHz16BitStereo = 39

    // TrueSpeech format
    SAFTTrueSpeech_8kHz1BitMono = 40

    // A-Law formats
    SAFTCCITT_ALaw_8kHzMono = 41
    SAFTCCITT_ALaw_8kHzStereo = 42
    SAFTCCITT_ALaw_11kHzMono = 43
    SAFTCCITT_ALaw_11kHzStereo = 4
    SAFTCCITT_ALaw_22kHzMono = 44
    SAFTCCITT_ALaw_22kHzStereo = 45
    SAFTCCITT_ALaw_44kHzMono = 46
    SAFTCCITT_ALaw_44kHzStereo = 47

    // u-Law formats
    SAFTCCITT_uLaw_8kHzMono = 48
    SAFTCCITT_uLaw_8kHzStereo = 49
    SAFTCCITT_uLaw_11kHzMono = 50
    SAFTCCITT_uLaw_11kHzStereo = 51
    SAFTCCITT_uLaw_22kHzMono = 52
    SAFTCCITT_uLaw_22kHzStereo = 53
    SAFTCCITT_uLaw_44kHzMono = 54
    SAFTCCITT_uLaw_44kHzStereo = 55
    SAFTADPCM_8kHzMono = 56
    SAFTADPCM_8kHzStereo = 57
    SAFTADPCM_11kHzMono = 58
    SAFTADPCM_11kHzStereo = 59
    SAFTADPCM_22kHzMono = 60
    SAFTADPCM_22kHzStereo = 61
    SAFTADPCM_44kHzMono = 62
    SAFTADPCM_44kHzStereo = 63

    // GSM 6.10 formats
    SAFTGSM610_8kHzMono = 64
    SAFTGSM610_11kHzMono = 65
    SAFTGSM610_22kHzMono = 66
    SAFTGSM610_44kHzMono = 67

    // Other formats
    SAFTNUM_FORMATS = 68
End Enum
Remarks

SAFTNonStandardFormat
SAFTNonStandardFormat is a non-SAPI 5 standard format without a WAVEFORMATEX description.
SAFTExtendedAudioFormat
SAFTExtendedAudioFormat is a non-SAPI 5 standard format but has WAVEFORMATEX description.
