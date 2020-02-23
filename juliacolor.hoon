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
+$  render-type  [r=@ g=@ b=@]
++  genrow 
  |=  [y=@ud dim=@ud]  ^-  tape
  =/  x=@ud  0
  =/  acc  ""
  =/  rainbow=(list render-type)
    :: Derived from Matteo Niccoli's Perceptual Rainbow
    :: http://mycarta.wordpress.com/2013/02/21/perceptual-rainbow-palette-the-method/
    :: from palettable.cubehelix import Cubehelix
    :: palette = Cubehelix.make(start_hue=240, end_hue=-300, min_sat=1,
    ::                          max_sat=2.5, min_light=0.3, max_light=0.8, 
    ::                          gamma=.9, n=100)
    :~  [135 59 97]       [136 59 102]      [138 60 106]      [139 61 110]
        [140 61 115]      [141 62 119]      [142 63 124]      [143 64 129]
        [143 65 133]      [144 67 138]      [144 68 142]      [144 69 147]
        [143 71 152]      [143 72 156]      [142 74 161]      [141 76 165]
        [141 77 169]      [139 79 174]      [138 81 178]      [137 84 182]
        [135 86 186]      [133 88 189]      [131 91 193]      [129 93 196]
        [127 96 200]      [125 99 203]      [122 101 206]     [120 104 209]
        [117 107 211]     [115 110 213]     [112 113 215]     [109 117 217]
        [106 120 219]     [103 123 220]     [100 127 221]     [97 130 222]
        [95 134 223]      [92 137 223]      [89 141 223]      [86 144 223]
        [83 148 223]      [81 151 222]      [78 155 221]      [76 158 220]
        [73 162 218]      [71 166 217]      [69 169 215]      [67 173 213]
        [65 176 211]      [64 179 208]      [62 183 205]      [61 186 202]
        [60 189 199]      [59 192 196]      [59 195 193]      [58 198 189]
        [58 201 185]      [58 204 182]      [59 206 178]      [59 209 174]
        [60 211 170]      [61 213 166]      [63 215 162]      [64 217 157]
        [66 219 153]      [69 221 149]      [71 223 145]      [74 224 141]
        [77 225 137]      [80 226 133]      [83 227 130]      [87 228 126]
        [91 229 122]      [95 230 119]      [99 230 116]      [103 230 113]
        [108 231 110]     [113 231 108]     [118 231 105]     [123 231 103]
        [128 230 101]     [134 230 99]      [139 229 98]      [145 229 97]
        [150 228 96]      [156 227 95]      [162 227 95]      [167 226 95]
        [173 225 95]      [179 224 96]      [185 223 97]      [190 222 98]
        [196 220 99]      [202 219 101]     [207 218 103]     [212 217 105]
        [218 216 107]     [223 215 110]     [228 214 113]     [233 213 117]
      ==
  |-  ^-  tape
  ?:  =(x dim)  acc
  ::=/  col  (iterpt x y dim)
  =/  value  (iterpt x y dim)
  =/  col  (snag value rainbow)
  $(x +(x), acc (weld "{<r.col>} {<g.col>} {<b.col>} " acc))
++  iterpt
  |=  [px=@ py=@ dim=@ud]
  ^-  @ud ::[@ud @ud @ud]
  =+  [range=(sun:rs 3)]
  =/  zx  (sub:rs (mul:rs (div:rs (sun:rs px) (sun:rs dim)) range) (mul:rs .0.5 range))
  =/  zy  (sub:rs (mul:rs (div:rs (sun:rs py) (sun:rs dim)) range) (mul:rs .0.5 range))
  =/  maxiter  100
  =/  it  (iterlp zx zy maxiter)
  it
++  iterlp
  |=  [zx=@rs zy=@rs maxiter=@ud]
  ::=+  [cx=.-7.4543e-1 cy=.1.1391e-1]
  ::=+  [cx=.2.85e-1 cy=.1.0e-2]
  =+  [cx=.-5e-1 cy=.1.0e-2]
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
