(memory (export "m") 4)            ;; 4 x 65536 bytes memory reserved

(global $s (mut f32)(f32.const 0)) ;; s like sinus
(global $c (mut f32)(f32.const 2.5));;c like cosinus
(global $x (mut i32)(i32.const 0)) ;; x coordinate
(global $y (mut i32)(i32.const 0)) ;; y coordinate
(global $z (mut i32)(i32.const 0)) ;; z buffer
(global $p (mut i32)(i32.const 0)) ;; p the pixel value (bgr)

(func $accum
  (param $lum f32)
  (param $r i32)
  (param $g i32)
  (param $b i32)

  global.get $y
  i32.const 1
  i32.and
  i32.const 12
  i32.shl
  i32.const -4096;;57344
  i32.xor

  local.get $b
  f32.convert_i32_s
  local.get $lum
  f32.mul
  i32.trunc_f32_s  
  i32.add
  i32.const 8
  i32.shl

  local.get $g
  f32.convert_i32_s
  local.get $lum
  f32.mul
  i32.trunc_f32_s  
  i32.add
  i32.const 8
  i32.shl

  local.get $r
  f32.convert_i32_s
  local.get $lum
  f32.mul
  i32.trunc_f32_s  
  i32.add
  global.set $p
)

(func $sphere
  (param $x f32)
  (param $y f32)
  (param $z f32)
  (param $radius f32)
  (param $r i32)
  (param $g i32)
  (param $b i32)
  (local $a f32)
  (local $d f32)

  local.get $radius
  local.get $radius
  f32.mul                          ;; r2

  local.get $x
  global.get $x
  f32.convert_i32_s
  f32.sub                          ;; dx
  local.tee $x
  local.get $x
  f32.mul                          ;; dx2
  f32.sub                          ;; r2-dx2

  local.get $y
  global.get $y
  f32.convert_i32_s
  f32.sub
  local.tee $y                     ;; dy
  local.get $y
  f32.mul                          ;; dy2
  f32.sub                          ;; r2-dx2-dy2
  local.tee $d

  i32.const 0
  f32.convert_i32_s
  f32.gt
  if
    local.get $z
    local.get $d
    f32.sqrt
    local.tee $d
    f32.sub
    local.tee $z
    global.get $z
    f32.convert_i32_s
    f32.lt
    if
      local.get $z
      i32.trunc_f32_s  
      global.set $z

      local.get $d
      local.get $x
      f32.add    
      local.get $y
      f32.add    
      i32.const 0
      f32.convert_i32_s
      f32.max
      local.tee $z
      local.get $radius
      f32.div                      ;; diffuse
      f32.const 0.6                ;; ambient
      f32.add
      local.set $a

      local.get $z
      local.get $d
      f32.add
      local.get $radius
      f32.const 2.44
      f32.mul
      f32.gt
      (if (result f32)
        (then i32.const 4
        f32.convert_i32_u)
        (else local.get $a)
      )
      local.get $r
      local.get $g
      local.get $b
      call $accum
    end
  end
)

(func (export "u")                 ;; u -> update function called by javascript code
  (local $i i32)                   ;; i the pixel index
  (local $j i32)                   ;; j the 2nd loop counter
  (local $k i32)                   ;; k the 3rd loop counter
  (local $a f32)                   ;; a the accumulator - a temporary variable

  (loop $pixels                    ;; default resolution of canvas: 300 x 150 pixels
    local.get $i                   ;; get the pixel index
    i32.const 2                    ;; multiple by 4
    i32.shl                        ;; we get the memory offset for putpixel

    local.get $i                   ;; get the pixel index
    i32.const 300                  ;; divided by line length
    i32.rem_s                      ;; reminder the x coordinate
    i32.const 160                  ;; ~centered
    i32.sub
    global.set $x
    local.get $i                   ;; get the pixel index
    i32.const 300                  ;; divided by line length
    i32.div_s                      ;; gives the y coordinate
    i32.const 55                   ;; ~centered
    i32.sub
    global.set $y

    i32.const 63
    global.set $z

    global.get $y
    f32.convert_i32_s
    f32.neg
    i32.const 75
    f32.convert_i32_s
    f32.div
    local.tee $a
    local.get $a
    f32.mul
    i32.const 27;;38;;19
    i32.const 63;;90;;45
    i32.const 81;;116;;58
    call $accum

    i32.const 42
    f32.convert_i32_s
    global.get $s
    i32.const 10
    f32.convert_i32_s
    f32.mul
    i32.const -5
    f32.convert_i32_s
    i32.const 20
    f32.convert_i32_s
    i32.const 21
    i32.const 38
    i32.const 44
    call $sphere

    global.get $s
    i32.const 15
    f32.convert_i32_s
    f32.mul
    i32.const 25
    f32.convert_i32_s
    i32.const -35
    f32.convert_i32_s
    i32.const 8
    f32.convert_i32_s
    i32.const 45
    i32.const 26
    i32.const 13
    call $sphere

    i32.const 0
    f32.convert_i32_s
    i32.const 0
    f32.convert_i32_s
    global.get $c
    i32.const 18
    f32.convert_i32_s
    f32.mul
    local.tee $a
    i32.const 250
    f32.convert_i32_s
    local.get $a
    f32.sub
    i32.const 250
    f32.convert_i32_s
    f32.div    
    i32.const 30
    f32.convert_i32_s
    f32.mul
    i32.const 38
    i32.const 45
    i32.const 29
    call $sphere

    global.get $p
    i32.store                      ;; putpixel

    local.get $i
    i32.const 1                    ;; step to the next pixel
    i32.add
    local.tee $i
    i32.const 45000                ;; eos = 300 x 150
    i32.lt_s
  br_if $pixels)

  i32.const 24199
  local.set $i
  (loop $mirrorh
    local.get $i
    i32.const -23360
    i32.add
    local.set $k

    local.get $i
    i64.const 0
    i64.store offset=1193;;2

    i32.const 51
    local.set $j
    (loop $mirrorw

      local.get $i
      local.get $k
      i32.load
      i32.const 0x3f
      i32.or
      i32.store

      local.get $j
      i32.const 7
      i32.and
      (if (result i32)
        (then i32.const 4)
        (else i32.const 1204)
      )
      local.get $i
      i32.add
      local.set $i

      local.get $k
      i32.const 8
      i32.sub
      local.set $k

      local.get $j
      i32.const 1
      i32.sub
      local.tee $j
    br_if $mirrorw)
    
    local.get $i
    i32.const 0
    i32.store8

    local.get $i
    i32.const -6204                 ;; step to the next pixel
    i32.add
    local.tee $i
    i32.const 180000               ;; eos = 300 x 150 x 4
    i32.lt_s
  br_if $mirrorh)

  global.get $s                    ;; s = s + c/63
  global.get $c
  i32.const 63
  f32.convert_i32_s
  f32.div
  f32.add
  global.set $s
  global.get $c                    ;; c = c - s/63
  global.get $s
  i32.const 63
  f32.convert_i32_s
  f32.div
  f32.sub
  global.set $c
)