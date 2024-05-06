<h1>Snek</h1>
<p>Snake game written in 8086 assembly</p>
<p align="center">
  <img style="width:500px" src="https://github.com/chaotic-braindead/snake-8086-asm/blob/main/demo.gif?raw=true" alt="snek demo">
</p>
<ul>
  <h2>NOTES</h2>
  <li>DOSBOX only</li>
  <li>probably very inefficient idk</li>
  <li>fix flickering screen by setting cpu cycles to max on dosbox options</li>
  <li>works on both TASM and MASM</li>
  <li>press esc key to exit game</li>
  <li>w, a, s, d to move</li>
</ul>
<ul>
  <h2>TODOs/bugs</h2>
  <li>flickering graphics on lower cpu cycles which becomes more noticeable as snake gets longer </li>
  <li>food collision does not work on randomly generated food_pos, possibly due to overflow; only works on static coordinates</li>
</ul>
