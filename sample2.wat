(memory (export "m") 4)            ;; 4 x 65536 bytes memory reserved

(global $t (mut i32)(i32.const 99));; t like time - counter in 16 milliseconds
(global $s (mut i32)(i32.const 0)) ;; s like sinus
(global $c (mut i32)(i32.const 512));; c like cosinus

(func $n                           ;; next step
  global.get $t                    ;; t = t + 1
  i32.const 1
  i32.add
  global.set $t

  global.get $s                    ;; s = s + c/128
  global.get $c
  i32.const 7
  i32.shr_s
  i32.add
  global.set $s

  global.get $c                    ;; c = c - s/128
  global.get $s
  i32.const 7
  i32.shr_s
  i32.sub
  global.set $c
)

(func (export "u")                 ;; u -> update function called by javascript code

  (local $a i32)                   ;; a like accumulator - a temporary variable
  (local $i i32)                   ;; i like index - the pixel index or rather memory offset
  (local $j i32)                   ;; j - the 2nd loop counter for color channels
  (local $x i32)                   ;; x coordinate
  (local $y i32)                   ;; y coordinate

  (loop $pixels                    ;; default resolution of canvas: 300 x 150 pixels
    global.get $t                  ;; backup t,s,c counters
    global.get $s
    global.get $c

    local.get $i                   ;; get the memory offset for putpixel

    i32.const 3
    local.set $j
    i32.const 255                  ;; abgr pixel value (out)
    (loop $channels (param i32)(result i32)   ;; blue, green, red color channels
      i32.const 8
      i32.shl
        
      local.get $i                 ;; get the memory offset
      i32.const 2                  ;; divided by 4
      i32.shr_u                    ;; we get the real pixel index
      i32.const 300                ;; the reminder of linelength
      i32.rem_s                    ;; gives the x coordinate
      i32.const 150
      i32.sub

      i32.const 16383
      global.get $t                ;; get t
      local.get $j
      i32.sub
      i32.const 255                ;; period is about 2 secs
      i32.and
      i32.const -128               ;; -128 ... +127 msecs
      i32.add
      local.tee $a
      local.get $a
      i32.mul                      ;; t*t*128*128
      i32.sub
      local.tee $a
      i32.mul
      i32.const -32768             ;; 128*128*4
      i32.sub
      local.tee $x
      global.get $c
      i32.mul

      local.get $i                 ;; get the memory offset for putpixel
      i32.const 1200               ;; divided by 4*linelength
      i32.div_s                    ;; gives the y coordinate
      i32.const 75
      i32.sub
      local.get $a
      i32.mul
      i32.const -32768             ;; 128*128*4
      i32.sub
      local.tee $y
      global.get $s
      i32.mul
      i32.sub                      ;; rotated x

      local.get $x
      global.get $s
      i32.mul
      local.get $y
      global.get $c
      i32.mul
      i32.add                      ;; rotated y

      i32.xor
      i32.const 23                 ;; t*t*128*128 >> 14+9
      i32.shr_s                    ;; t*t on [-1..+1] * 150
      i32.const 4
      i32.and
      i32.const 63
      i32.mul

      i32.add                      ;; merge color channels
      call $n

      local.get $j
      i32.const 1                  ;; offset step to the next pixel
      i32.sub
      local.tee $j
    br_if $channels)

    i32.store                      ;; putpixel

    global.set $c                  ;; restore t,s,c counters
    global.set $s
    global.set $t

    local.get $i
    i32.const 4                    ;; offset step to the next pixel
    i32.add
    local.tee $i
    i32.const 180000               ;; eos = 300 x 100 x 4
    i32.lt_s
  br_if $pixels)

  call $n
)
