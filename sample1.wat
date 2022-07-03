(module                              ;; wasm source file by TomCat/Abaddon
  (memory (export "m") 4)            ;; 4 x 65536 bytes memory reserved
  (global $t (mut i32) (i32.const 0));; t like time - counter in milliseconds
  (func
    (export "u")                     ;; u -> update function called by js function setTimeout
    (local $a i32)                   ;; a like accumulator - a temporary variable
    (local $i i32)                   ;; i like index - the pixel index or rather memory offset
    (loop $pixels                    ;; the default resolution of canvas: 300 x 150 pixels
      local.get $i                   ;; get the memory offset for putpixel

      local.get $i                   ;; get the memory offset for putpixel
      i32.const 2                    ;; divided by 4
      i32.shr_u                      ;; we get the real pixel index
      i32.const 300                  ;; the reminder of linelength
      i32.rem_s                      ;; gives the x coordinate

      i32.const 150                  ;; centering the x coordinate
      i32.sub
      local.tee $a                   ;; computing x*x
      local.get $a
      i32.mul

      local.get $i                   ;; get the memory offset for putpixel
      i32.const 1200                 ;; divided by 4*linelength
      i32.div_s                      ;; gives the y coordinate

      global.get $t                  ;; get t
      i32.const 127                  ;; period is about 2 secs
      i32.and
      i32.const -64                  ;; -64 ... +63 msecs
      i32.add
      local.tee $a
      local.get $a
      i32.mul                        ;; t*t*64*64
      i32.const 150
      i32.mul                        ;; 150*t*t*64*64
      i32.const 12                   ;; 150*t*t*64*64>>12
      i32.shr_s                      ;; t*t on [-1..+1] * 150

      i32.sub                        ;; moving the center verticaly
      local.tee $a
      local.get $a
      i32.mul                        ;; computing y*y

      i32.add                        ;; x*x+y*y
      f32.convert_i32_s
      f32.sqrt                       ;; length from center
      f32.neg                        ;; inverting the distance for inverse shading
      i32.trunc_sat_f32_s
      i32.const 0xff                 ;; get the lsb
      i32.and

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