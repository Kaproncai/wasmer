.\bin\wat2wasm.exe %1.wat -o %1.wasm

certutil -encodehex -f %1.wasm %1.b64 0x40000001

IF [%2] == [] (
 copy /b head.htm + %1.b64 + tail.htm %1.htm
) else (
 copy /b head_min.htm + %1.b64 + tail_min.htm %1.htm
)
 