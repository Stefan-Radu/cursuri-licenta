<if (0 <= i, i = i + -4; while (0 <= i, { i = i + -4 }), skip), i → 3>
se inlocuieste i
<if (0 <= 3, i = i + -4; while (0 <= i, { i = i + -4 }), skip), i → 3>
evaluezi comparatie
<if (true, i = i + -4; while (0 <= i, { i = i + -4 }), skip), i → 3>
executam if
<i = i + -4; while (0 <= i, { i = i + -4 }), i → 3>
scoate i din env
<i = 3 + -4; while (0 <= i, { i = i + -4 }), i → 3>
calculam
<i = -1; while (0 <= i, { i = i + -4 }), i → 3>
actualizam env
<while (0 <= i, { i = i + -4 }), i → -1>
transformam in if
<if (0 <= i, i = i + -4; while (0 <= i, { i = i + -4 }), skip), i → -1>
se inlocuieste i
<if (0 <= -1, i = i + -4; while (0 <= i, { i = i + -4 }), skip), i → -1>
evaluezi comparatie
<if (false, i = i + -4; while (0 <= i, { i = i + -4 }), skip), i → -1>
executam if
<skip, i → -1>
executam skip
<i → -1>
