rem p�lda, hogyan kell csin�lni k�tegelt feldolgoz�s SoX MS-Windows.
rem
rem Helyezze ezt a f�jlt ugyanabba a mapp�ba, mint sox.exe (�s nevezze meg a megfelel�t).
rem Ezut�n fogd �s vidd v�logatott f�jlokat a batch f�jlt (vagy
rem r� a `short-cut" van).
rem
rem Ebben a p�ld�ban a konvert�lt f�jlokat a v�g�n 'converted' nev� mapp�ba
rem de ez term�szetesen lehet v�ltoztatni, valamint tartalmazza a param�tereket a sox
rem parancsot.



mkdir trimmedwav
FOR %%A IN (%*) DO c:\sox\sox.exe %%A "trimmedwav\%%~nxA" silence 1 0.05 0.5%% reverse silence 1 0.05 0.5%% reverse
pause
