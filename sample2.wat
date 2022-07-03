(module                              ;; wasm source file by TomCat/Abaddon
  (memory (export "m") 4)            ;; 4 x 65536 bytes memory reserved
  (global $t (mut i32) (i32.const 0));; t like time - counter in milliseconds
  (func
    (export "u")                     ;; u -> update function called by js function setTimeout
    (local $a i32)                   ;; a like accumulator - a temporary variable
    (local $i i32)                   ;; i like index - the pixel index or rather memory offset
    (loop $pixels                    ;; default resolution of canvas: 300 x 150 pixels
      local.get $i                   ;; get the memory offset for putpixel

      local.get $i                   ;; get the memory offset for putpixel
      i32.const 2                    ;; divided by 4
      i32.shr_u                      ;; we get the real pixel index
      i32.const 300                  ;; the reminder of linelength
      i32.rem_s                      ;; gives the x coordinate
      i32.const 150
      i32.sub

      i32.const 16383
      global.get $t                  ;; get t
      i32.const 255                  ;; period is about 2 secs
      i32.and
      i32.const -128                 ;; -128 ... +127 msecs
      i32.add
      local.tee $a
      local.get $a
      i32.mul                        ;; t*t*128*128
      i32.sub
      local.tee $a
      i32.mul
      i32.const -32768               ;; 128*128*4
      i32.sub

      local.get $i                   ;; get the memory offset for putpixel
      i32.const 1200                 ;; divided by 4*linelength
      i32.div_s                      ;; gives the y coordinate
      i32.const 75
      i32.sub
      local.get $a
      i32.mul

      i32.const -32768               ;; 128*128*4
      i32.sub

      i32.xor
      i32.const 14                   ;; 150*t*t*128*128>>14
      i32.shr_s                      ;; t*t on [-1..+1] * 150
      i32.const 4
      i32.and
      i32.const 63
      i32.mul

      i32.const 0x01010101           ;; distribute the same value for bgr and alpha channels
      i32.mul
      i64.extend_i32_s
      i64.store32                    ;; putpixel

      local.get $i
      i32.const 4                    ;; offset step to the next pixel
      i32.add
      local.tee $i
      i32.const 180000               ;; eos = 300 x 100 x 4
      i32.lt_s
    br_if $pixels)
    global.get $t
    i32.const 1
    i32.add
    global.set $t
  )
)