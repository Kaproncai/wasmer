(memory (export "m") 4)            ;; 4 x 65536 bytes memory reserved

(global $s (mut f32)(f32.const 0)) ;; s like sinus
(global $c (mut f32)(f32.const 2.5));;c like cosinus
(global $x (mut f32)(f32.const 0)) ;; x coordinate
(global $y (mut f32)(f32.const 0)) ;; y coordinate
(global $z (mut f32)(f32.const 0)) ;; z buffer
(global $r (mut f32)(f32.const 0)) ;; r like red component
(global $g (mut f32)(f32.const 0)) ;; g like green component
(global $b (mut f32)(f32.const 0)) ;; b like blue component

(func $accum
  (param $lum f32)
  (param $r i32)
  (param $g i32)
  (param $b i32)

  local.get $lum
  i32.const 0
  f32.convert_i32_s
  f32.gt
  if
    local.get $r
    f32.convert_i32_s
    local.get $lum
    f32.mul
    global.set $r

    local.get $g
    f32.convert_i32_s
    local.get $lum
    f32.mul
    global.set $g

    local.get $b
    f32.convert_i32_s
    local.get $lum
    f32.mul
    global.set $b
  end
)

(func $col
  (param $p i32)
  (param $c f32)
  (result i32)

  local.get $p
  i32.const 8
  i32.shl
  local.get $c
  i32.const 255
  f32.convert_i32_s
  f32.min
  i32.trunc_f32_s    
  i32.add
)

(func $sphere
  (param $x f32)
  (param $y f32)
  (param $z f32)
  (param $radius f32)
  (result f32)
  (local $a f32)
  (local $d f32)

  local.get $radius
  local.get $radius
  f32.mul                          ;; r2

  local.get $x
  global.get $x
  f32.sub                          ;; dx
  local.tee $x
  local.get $x
  f32.mul                          ;; dx2
  f32.sub                          ;; r2-dx2

  local.get $y
  global.get $y
  f32.sub
  local.tee $y                     ;; dy
  local.get $y
  f32.mul                          ;; dy2
  f32.sub                          ;; r2-dx2-dy2

  i32.const 0
  f32.convert_i32_s
  local.tee $a
  f32.max
  local.tee $d
  i32.trunc_f32_s
  if
    local.get $z
    local.get $d
    f32.sqrt
    local.tee $d
    f32.sub
    local.tee $z
    global.get $z
    f32.lt
    if
      local.get $z
      global.set $z

      local.get $d
      local.get $x
      f32.add    
      local.get $y
      f32.add    
      i32.const 0
      f32.convert_i32_s
      f32.max
      local.get $radius
      f32.div                      ;; diffuse
      f32.const 0.6                ;; ambient
      f32.add

      local.set $a
    end
  end
  local.get $a
)

(func (export "u")                 ;; u -> update function called by javascript code
  (local $i i32)                   ;; i the pixel index
  (local $a f32)

  (loop $pixels                    ;; default resolution of canvas: 300 x 150 pixels
    local.get $i                   ;; get the pixel index
    i32.const 2                    ;; multiple by 4
    i32.shl                        ;; we get the memory offset for putpixel

    local.get $i                   ;; get the pixel index
    i32.const 300                  ;; divided by line length
    i32.rem_s                      ;; reminder the x coordinate
    i32.const 150                  ;; centered
    i32.sub
    f32.convert_i32_s
    global.set $x
    local.get $i                   ;; get the pixel index
    i32.const 300                  ;; divided by line length
    i32.div_s                      ;; gives the y coordinate
    i32.const 55                   ;; ~centered
    i32.sub
    f32.convert_i32_s
    global.set $y

    i32.const -1
    f32.convert_i32_u
    global.set $z

    global.get $y
    i32.trunc_f32_s    
    (if (result f32)
      (then
        global.get $y)
      (else
        i32.const 1
        f32.convert_i32_s)
    )
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

    i32.const 45
    f32.convert_i32_s
    global.get $s
    i32.const 10
    f32.convert_i32_s
    f32.mul
    i32.const -5
    f32.convert_i32_s
    i32.const 20
    f32.convert_i32_s
    call $sphere
    i32.const 21
    i32.const 38
    i32.const 44
    call $accum

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
    call $sphere
    i32.const 45
    i32.const 26
    i32.const 13
    call $accum

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
    call $sphere
    i32.const 38
    i32.const 45
    i32.const 29
    call $accum

    i32.const 255
    global.get $b
    call $col
    global.get $g
    call $col
    global.get $r
    call $col
    i32.store                      ;; putpixel

    local.get $i
    i32.const 1                    ;; step to the next pixel
    i32.add
    local.tee $i
    i32.const 45000                ;; eos = 300 x 150
    i32.lt_s
  br_if $pixels)

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
