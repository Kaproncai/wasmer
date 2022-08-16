.\bin\wat2wasm.exe %1.wat -o %1.wasm

IF [%2] == [] (
 copy /b headbin.htm + %1.wasm %1.htm
) else (
 copy /b headbinm.htm + %1.wasm %1.htm
)
 
dir %1.htm
