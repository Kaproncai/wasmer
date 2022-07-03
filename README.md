
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

For more information on wasm coding check the sample1.wat file.

### Author

It was written by Tamás Kaproncai aka TomCat/Abaddon.

### Contact

E-mail: kapor@dit.hu
GitHub: Kaproncai

### Used references

[p01 Henri's blog](http://www.p01.org/) and the [AssemblyScript examples](https://www.assemblyscript.org/examples.html) helped a lot.

### Files

- wmake.bat - batch file for linking under windows
- sample?.wat - wasm examples
- head.htm - begining part of the output file with some js code
- tail.htm - ending part of the output file with some js code
- bin/wat2wasm.exe - wabt tool for windows
- LICENSE - copyright information
- README.md - this file
