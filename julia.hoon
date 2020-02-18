!:
::  Julia set generator
::  
::  By ~lagrev-nocfep (Neal Davis)
::
::  Inspired by (and drawing from) Matt Newport's planetppm raytracer.
::
|=  dim=@ud  ^-  (list @t)
=<  (genppm dim)
|%
++  genppm
  |=  dim=@ud
  ^-  (list @t)
  =/  header  ~['P3' (crip "{<dim>} {<dim>}") '255']
  (weld header (genimg dim))
++  genimg
  |=  dim=@ud  ^-  (list @t)
  =/  y=@ud  0
  =/  acc=(list @t)  ~
  |-  ^-  (list @t)
  ?:  =(y dim)  acc
  ~&  "Row: {<y>}"
  =/  row  `@t`(crip (genrow y dim))
  $(y +(y), acc [row acc])
++  genrow 
  |=  [y=@ud dim=@ud]  ^-  tape
  =/  x=@ud  0
  =/  acc  ""
  |-  ^-  tape
  ?:  =(x dim)  acc
  =/  col  (iterpt x y dim)
  $(x +(x), acc (weld "{<-:col>} {<+<:col>} {<+>:col>} " acc))
++  iterpt
  |=  [px=@ py=@ dim=@ud]
  ^-  [@ud @ud @ud]
  =+  [range=(sun:rs 3)]
  =/  zx  (sub:rs (mul:rs (div:rs (sun:rs px) (sun:rs dim)) range) (mul:rs .0.5 range))
  =/  zy  (sub:rs (mul:rs (div:rs (sun:rs py) (sun:rs dim)) range) (mul:rs .0.5 range))
  =/  maxiter  100
  =/  it  (iterlp zx zy maxiter)
  =/  c  [(div:rs (sun:rs it) (sun:rs maxiter)) (div:rs (sun:rs it) (sun:rs maxiter)) (div:rs (sun:rs it) (sun:rs maxiter))]
  ::~&  [px py zx zy it]
  [(rs-to-byte -:c) (rs-to-byte +<:c) (rs-to-byte +>:c)]
++  iterlp
  |=  [zx=@rs zy=@rs maxiter=@ud]
  =+  [cx=.-7.4543e-1 cy=.1.1391e-1]
  =+  [iter=1]
  =+  [n=.10.0]
  |-
  ?:  =(iter maxiter)
    0
  ?.  (lth:rs (add:rs (mul:rs zx zx) (mul:rs zy zy)) (mul:rs n n))
    iter
  =/  zxt  (sub:rs (mul:rs zx zx) (mul:rs zy zy))
  $(zx (add:rs zxt cx), zy (add:rs (mul:rs .2.0 (mul:rs zx zy)) cy), iter +(iter))
++  rs-to-byte
  |=  x=@rs  ^-  @ud
  `@ud`(abs:si (fall (toi:rs (mul:rs (saturate x) .255)) --0))
++  min
  |=  [x=@rs y=@rs]  ^-  @rs
  ?:  (lth:rs x y)  x  y
++  max
  |=  [x=@rs y=@rs]  ^-  @rs
  ?:  (lth:rs x y)  y  x
++  clamp
  |=  [x=@rs a=@rs b=@rs]  ^-  @rs
  (min (max x a) b)
++  saturate
  |=  x=@rs  ^-  @rs
  (clamp x .0 .1)
--
