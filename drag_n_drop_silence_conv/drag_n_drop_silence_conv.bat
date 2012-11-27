rem példa, hogyan kell csinálni kötegelt feldolgozás SoX MS-Windows.
rem
rem Helyezze ezt a fájlt ugyanabba a mappába, mint sox.exe (és nevezze meg a megfelelõt).
rem Ezután fogd és vidd válogatott fájlokat a batch fájlt (vagy
rem rá a `short-cut" van).
rem
rem Ebben a példában a konvertált fájlokat a végén 'converted' nevû mappába
rem de ez természetesen lehet változtatni, valamint tartalmazza a paramétereket a sox
rem parancsot.



mkdir trimmedwav
FOR %%A IN (%*) DO c:\sox\sox.exe %%A "trimmedwav\%%~nxA" silence 1 0.05 0.5%% reverse silence 1 0.05 0.5%% reverse
pause
