.wav  and .AD4 (4bit ADPCM) generator from .csv for stock 9x rc transmitter voice module.

download files:
http://open9x-er9x-voice-generator-script.googlecode.com/svn/trunk/
or download section this site




---



This code generate wavs and AD4 from csv on .\ folder.
with default (actual Windows TTS voice)

=PROJECT TESTED with emartee audio board!!!!

option:  AD4    best results

> e      best results

> high   for post production (not upload the emartee)=



REQUIRED:
9x rc transmitter with VOICE-mod
open9x or er9x firmware with voice compile option
windows xp/windows7  (32 bit)
installed Text-to speech voice font your machine



FUNCTIONS:
trimming begin-end audio silent block.
normalize
optional add silent samples to file end.
optional (commented char ' this line on source) A-law output conversion 16Khz/8bit .wav
output conversion 16Khz/16bit .wav
output conversion 32kHz/4bit ADPCM .AD4
if necessary, replace the codec, from vbs file line: ~168

REMARK:
Magic number: (wav output format):
Magic number, possibly voice specific (0 to 68). Detailed info: readme.txt.



---

forum:
http://9xforums.com/forum/viewtopic.php?f=64&t=2342