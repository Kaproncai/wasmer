.\bin\wat2wasm.exe %1.wat -o %1.wasm

.\bin\zopfli.exe -v --deflate %1.wasm

IF [%2] == [] (
 copy /b headdef.htm + %1.wasm.deflate %1.htm
) else (
 copy /b headdefm.htm + %1.wasm.deflate %1.htm
)
 
dir %1.htm
