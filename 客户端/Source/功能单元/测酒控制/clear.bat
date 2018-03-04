@ECHO OFF

ECHO Cleaning....

del /S    *.~*
del /S    *.dcu
del /S/Q  __history 
rd  /S/Q  __history 
del /S/A  Thumbs.db 
del /S    *.bak  

Pause