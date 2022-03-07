; Byron Dowling
; CMPS 4553 Agent Based Modeling
; Summer 2 2021 7/7/2021

breed [bugs bug]         ; Turtles breed defined for our bugs
breed [birds bird]       ; Turtles breed defined for our birds
turtles-own [energy]     ; Both breeds will need energy
patches-own [countdown]  ; Timer to assist in grass regrowth


to setup
  clear-all
  setup-patches

  ; Bug definition including shape size color and variables that
  ; are controlled with sliders and a randomized spawn location.
  create-bugs num_bugs
  [
    set shape "bug"
    set color blue
    set size 1.25
    set energy bug-energy
    setxy random-xcor random-ycor
  ]

  ; Bird definition including shape size color and variables that
  ; are controlled with sliders and a randomized spawn location.
  create-birds num_birds
  [
    set shape "bird side"
    set size 1.75
    set color red
    set energy bird-energy
    setxy random-xcor random-ycor
  ]

  ; To show energy levels if switch is enabled
  display-labels
  reset-ticks
end


; Defining patches to start out as green for green grass or crops
to setup-patches
  ask patches [set pcolor green]
end



to go
  if ticks >= 500 [stop]  ; stopping at 500 ticks
  if not any? turtles [user-message "The animals have gone extinct :/ "stop]   ; If all turtles are dead :/

  ; Commenting these out for now but are useful to bring a hard stop to the sim if one species dies
  ; before all the ticks have been used.
  ;;if not any? birds [user-message "The locusts are running rampant!" stop]
  ;;if not any? bugs [user-message "The sparrows have exterminated all of the locusts!" stop]


  ; Have to ask since not in observer mode
  ; Defines the functions specific to Bugs
  ask bugs
  [
    set energy energy - 1
    eat-crops
    check-death
    reproduce
    move
  ]

  ; Have to ask since not in observer mode
  ; Defines the functions specific to Birds
  ask birds
  [
    set energy energy - 1
    eat-bugs
    check-death
    hatch-eggs
    fly
  ]

  ; Check if grass needs to regrow
  regrow-grass
  tick
end


; Bug function for movement
; Random direction and forward one space
to move
  rt random 120
  lt random 120
  forward 1
end


; Bird function for movement
; Random direction and forward by flight speed which can be
; defined by the user with a slider before running the sim.
to fly
  rt random 360
  ;lt random 120
  forward flight-speed
end


; Bug function for eating crops/grass
; Toggle eaten patches to brown since it looks better than
; black patches. Also energy gained is dependant on a slider
; set by the user before running the sim.
to eat-crops
    if pcolor = green [
      set pcolor brown
      set energy energy + (0.5 * bug-energy)
      ]
    ifelse show-energy?
    [set label energy]
    [set label ""]
end


; Bird function for eating bugs
; Checks if a bug is on the patch they are on. If a bug is on
; their patch, that bug will die and energy is gained. Energy is
; defined by the user with a slider before running the sim.
to eat-bugs
  let prey one-of bugs-here
  if prey != nobody  [
    ask prey [ die ]
    set energy energy + (0.5 * bird-energy)
  ]
  ifelse show-energy?
  [set label energy]
  [set label ""]
end


; Bug function for reproducing
; Checks if a bug has enough energy to reproduce and if it does
; it substracts birth energy and hatches an amount of locust eggs.
; The amounts for both birth energy and eggs can be defined by the
; user with sliders before running the sim.
to reproduce
  if energy > birth-energy [
    set energy energy - birth-energy
    hatch locust-eggs [rt random-float 360 fd 1]
  ]
end


; Bird function for reproducing
; Checks if a bird has enough energy to reproduce and if it does
; it substracts birth energy and hatches an amount of bird eggs.
; The amounts for both birth energy and eggs can be defined by the
; user with sliders before running the sim.
to hatch-eggs
  ask birds [
  if energy > birth-energy [
    set energy energy - birth-energy
    hatch bird-eggs [rt random-float 360 fd 1]
    ]
  ]
end


; Turtles function that checks if either breed should die if they
; don't have any energy left.
to check-death
  ; if all energy is exerted, turtles will die
  if energy <= 0 [die]
end


; Called after each tick and if countdown is 0, the grass will regrow.
; If it's not time for the grass to regrow the countdown is reduced.
to regrow-grass
  ask patches [
    ifelse countdown <= 0
    [
      ;if random 100 < 3 [set pcolor green]
      set pcolor green
      set countdown grass-regrow-time
    ]
      [ set countdown countdown - 1 ]

    ]
end


; Shows energy levels of all turtles
to display-labels
  ask turtles [ set label "" ]
  if show-energy? [
    ask birds [ set label round energy ]
    ask bugs [ set label round energy ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
236
36
983
543
-1
-1
15.1
1
10
1
1
1
0
1
1
1
-24
24
-16
16
0
0
1
ticks
30.0

BUTTON
11
15
75
48
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
147
16
210
49
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
37
81
209
114
num_bugs
num_bugs
0
250
118.0
1
1
NIL
HORIZONTAL

SLIDER
38
126
210
159
num_birds
num_birds
0
250
49.0
1
1
NIL
HORIZONTAL

MONITOR
82
336
210
381
Current # of Locusts
count bugs
17
1
11

MONITOR
1002
332
1129
377
Current # of Sparrows
count birds
17
1
11

SWITCH
78
268
212
301
show-energy?
show-energy?
1
1
-1000

SLIDER
38
173
210
206
birth-energy
birth-energy
0
100
18.0
1
1
NIL
HORIZONTAL

SLIDER
39
219
211
252
grass-regrow-time
grass-regrow-time
0
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
998
241
1170
274
bird-eggs
bird-eggs
0
10
4.0
1
1
NIL
HORIZONTAL

SLIDER
995
70
1167
103
bug-energy
bug-energy
0
25
5.0
1
1
NIL
HORIZONTAL

SLIDER
998
201
1170
234
bird-energy
bird-energy
0
50
25.0
1
1
NIL
HORIZONTAL

TEXTBOX
66
59
216
77
Starting Parameters
13
0.0
1

SLIDER
997
115
1169
148
locust-eggs
locust-eggs
0
10
2.0
1
1
NIL
HORIZONTAL

TEXTBOX
996
29
1146
61
Locust-Specific Parameters
13
0.0
1

TEXTBOX
1000
166
1150
198
Sparrow-Specific\n Parameters
13
0.0
1

PLOT
1004
391
1204
541
Sparrow Population
NIL
NIL
0.0
10.0
0.0
250.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count birds"

PLOT
11
390
211
540
Locust Population
NIL
NIL
0.0
10.0
0.0
250.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count bugs"

SLIDER
998
282
1170
315
flight-speed
flight-speed
0
15
8.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

This project depicts the food chain as it pertains to bugs, birds, and grass. Grass is a food resource for the bugs, and the bugs are a food source for the birds. The model allows us to tweak the number of agents to examine the relationships between these species.

## HOW IT WORKS

Bugs will eat the grass and gain energy from eating, birds will seek out and eat the bugs and gain energy from eating, and the grass will eventually regenerate after being eaten. In addition to gaining energy from food, energy is expended from movement and checks are in place so that if agents run out of "energy" they will die and be removed from the population. 


## THINGS TO NOTICE

It's an uphill battle to get the sparrows to survive since they have to seek out their food source whereas there is a food source readily available for the locusts. However despite this, the parameters can be tweaked to where the sparrows will wipe out the locusts before they ultimately die of starvation from a lack of food source.

## THINGS TO TRY

- Try toggling the number of eggs that are hatched when a bird or bug reproduces
- See what happens when one breed starts out at a significant number advantage
- Toggle the grass regrowth and see how it affects the locusts.
- Experiment with the "flight" of the sparrows and see what different levels yield.

## EXTENDING THE MODEL

- Add patches with grain to simulate the bugs eating "crops"
- Add a human population count that is correlated to the "crop" levels
- The crop levels can be used to model the "Four Pests Campaign" that was an ecological disaster that was initiated by Mao Zedong in 1958
- https://www.ozy.com/true-and-stories/the-enemy-chairman-mao-could-not-defeat/95332/ 
- https://en.wikipedia.org/wiki/Four_Pests_campaign


## RELATED MODELS

- Wolf Sheep Predation model from the Biology section
- Wilensky, U. (1997). NetLogo Wolf Sheep Predation model. http://ccl.northwestern.edu/netlogo/models/WolfSheepPredation. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## CREDITS AND REFERENCES

- Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bird side
false
0
Polygon -7500403 true true 0 120 45 90 75 90 105 120 150 120 240 135 285 120 285 135 300 150 240 150 195 165 255 195 210 195 150 210 90 195 60 180 45 135
Circle -16777216 true false 38 98 14

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
