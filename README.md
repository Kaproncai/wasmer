
# WASMER

WAT to HTML framework for sizecoders v2

Let's become a wasmer :)
Write your single-file-intro in pure WebAssembly.

### Requirements

- wat 2 wasm translator like [WABT](https://github.com/WebAssembly/wabt)
- binary 2 base64 text converter
- compressor with deflate-raw option like [ZOPFLI](https://github.com/google/zopfli)

### Usage

Give the name of your wat file to the appropriate maker (without extension)
and it will link together the head and/or tail of html with the wasm binary
in base64-coded or compressed or raw format.

If you give a 2nd parameter as an option (like "math"), then it will include
the whole javascript Math library as an import.

For more information on wasm coding check the sample1.wat file.

### Authors

It was written by Tamás Kaproncai aka TomCat/Abaddon.
Thanks to Mathieu Henri aka p01/Ribbon for some codegolfing.

### Contact

E-mail: kapor@dit.hu
GitHub: Kaproncai

### Used references

- MicroW8 WASM Sizecoding Seminar by Exoticorn/Icebird [https://youtu.be/u-OvsbDqLAY](https://youtu.be/u-OvsbDqLAY)
- p01 Henri's blog [http://www.p01.org/](http://www.p01.org/)
- AssemblyScript examples [https://www.assemblyscript.org/examples.html](https://www.assemblyscript.org/examples.html)
- Ben Smith's Raw WebAssembly Demos [https://github.com/binji/raw-wasm](https://github.com/binji/raw-wasm)
- one-knob-cyberia an interactive HTML demo by 0b5vr [https://www.pouet.net/prod.php?which=91986](https://www.pouet.net/prod.php?which=91986)

### Files

- wmakeall.bat - for linking all samples under windows
- wmakeb64.bat - linking under windows with inline base64 encoded wasm
- wmakebin.bat - linking under windows with raw binary wasm
- wmakedef.bat - linking under windows with compressed stream wasm
- sample1.wat - wasm example #1 bouncing point
- sample2.wat - wasm example #2 rotozoomer with color delay
- sample3.wat - wasm example #3 tunnel (needs JS Math lib!)
- sample4.wat - wasm example #4 mirror 1k
- headb64.htm - begining part of the output file with some js code
- headbin.htm - binary version
- headbinm.htm - binary version with Math import
- headdef.htm - compressed version
- headdefm.htm - compressed version with Math import
- tailb64.htm - ending part of the output file with some js code
- tailb64m.htm - base64 version with Math import
- bin/wat2wasm.exe - wabt tool for windows
- bin/zopfli.exe - zopfli tool for windows-x64
- LICENSE - copyright information
- README.md - this file
