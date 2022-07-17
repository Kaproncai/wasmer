
# WASMER

WAT to HTML framework for sizecoders

Let's become a wasmer :)
Write your single-file-intro in pure WebAssembly.

### Requirements

- wat 2 wasm translator like [WABT](https://github.com/WebAssembly/wabt)
- binary 2 base64 text converter

### Usage

Give the name of your wat file to the maker (without extension) and
it will link together the head&tail of html with the base64 coded wasm binary.

If you give a 2nd parameter as an option (like "min"), then it will
use the minimal versions of head&tail instead of the standard ones.

For more information on wasm coding check the sample1.wat file.

### Author

It was written by Tamás Kaproncai aka TomCat/Abaddon.

### Contact

E-mail: kapor@dit.hu
GitHub: Kaproncai

### Used references

- MicroW8 WASM Sizecoding Seminar by Exoticorn / Icebird [https://youtu.be/u-OvsbDqLAY](https://youtu.be/u-OvsbDqLAY)
- p01 Henri's blog [http://www.p01.org/](http://www.p01.org/)
- AssemblyScript examples [https://www.assemblyscript.org/examples.html](https://www.assemblyscript.org/examples.html)
- Ben Smith's Raw WebAssembly Demos [https://github.com/binji/raw-wasm](https://github.com/binji/raw-wasm)


### Files

- wmake.bat - batch file for linking under windows
- sample1.wat - wasm example #1 bouncing point
- sample2.wat - wasm example #2 rotozoomer with color delay
- sample3.wat - wasm example #3 tunnel
- sample4.wat - wasm example #4 mirror 1k
- head.htm - begining part of the output file with some js code
- tail.htm - ending part of the output file with some js code
- head_min.htm - minimal version
- tail_min.htm - minimal version
- bin/wat2wasm.exe - wabt tool for windows
- LICENSE - copyright information
- README.md - this file
