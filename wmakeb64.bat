.\bin\wat2wasm.exe %1.wat -o %1.wasm

certutil -encodehex -f %1.wasm %1.b64 0x40000001

IF [%2] == [] (
 copy /b headb64.htm + %1.b64 + tailb64.htm %1.htm
) else (
 copy /b headb64.htm + %1.b64 + tailb64m.htm %1.htm
)
 
dir %1.htm
