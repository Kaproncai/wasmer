(import "" "atan2" (func $atan2 (param f32 f32)(result f32)))

(memory (export "m") 4)            ;; 4 x 65536 bytes memory reserved

(global $t (mut i32)(i32.const 0)) ;; t like time - counter in 16 milliseconds

(func (export "u")                 ;; u -> update function called by javascript code

  (local $i i32)                   ;; i like index - the pixel index or rather memory offset
  (local $x i32)                   ;; x coordinate
  (local $y i32)                   ;; y coordinate
  (local $a f32)                   ;; a for alpha

  (loop $pixels                    ;; default resolution of canvas: 300 x 150 pixels
    local.get $i                   ;; get the memory offset for putpixel

    i32.const 40000
    f32.convert_i32_s

    local.get $i                   ;; get the memory offset
    i32.const 2                    ;; divided by 4
    i32.shr_u                      ;; we get the real pixel index
    i32.const 300
    i32.rem_s
    i32.const 150
    i32.sub
    local.tee $x
    local.get $x
    i32.mul
    local.get $i                   ;; get the memory offset for putpixel
    i32.const 1200                 ;; divided by 4*linelength
    i32.div_s                      ;; gives the y coordinate
    i32.const 75
    i32.sub
    local.tee $y
    local.get $y
    i32.mul
    i32.add
    f32.convert_i32_s
    f32.sqrt
    local.tee $a
    f32.div
    global.get $t
    f32.convert_i32_s
    i32.const 1000
    f32.convert_i32_s
    f32.div  
    i32.const 126
    f32.convert_i32_s
    f32.mul
    f32.add
    i32.trunc_sat_f32_s

    local.get $x
    f32.convert_i32_s
    local.get $y
    f32.convert_i32_s
    call $atan2
    f32.const 163.0054168701172
    f32.mul
    global.get $t
    f32.convert_i32_s
    i32.const 1000
    f32.convert_i32_s
    f32.div  
    i32.const 63
    f32.convert_i32_s
    f32.mul
    f32.add
    i32.trunc_f32_s    

    i32.xor
    i32.const 4
    i32.shr_s
    i32.const 15
    i32.and

    i32.const 0x000F0D07           ;; distribute the same value for bgr and alpha channels
    i32.mul
    local.get $a
    f32.const 1.5
    f32.mul
    i32.trunc_f32_s    
    i32.const 24
    i32.shl
    i32.add
    i32.store                      ;; putpixel

    local.get $i
    i32.const 4                    ;; offset step to the next pixel
    i32.add
    local.tee $i
    i32.const 180000               ;; eos = 300 x 100 x 4
    i32.lt_s
  br_if $pixels)

  global.get $t                    ;; t = t + 1
  i32.const 16
  i32.add
  global.set $t
)
