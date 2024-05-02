# SM64-LiveSplit-AutoSplitter-Dackage-Edition

-------------
General Notes
-------------

Wanting to add the ability to use course labels, I looked into making my autosplitter version.

This was built off the aglab2 LiveSplit.SuperMario64.asl autosplitter
	https://github.com/aglab2/LiveSplitAutoSplitters

Changes
- the code for the split handling was restructured, allowing for multiple split conditions. Also
	conditions can be anywhere in the split instead of only the end
- there's now support for course labels (e.g. [C1] or [B2]). Numbers still work if desired
- for the last split, can now split on a warp (for use with star road 0/80 star)

- split on music change was removed for now
- removed Last Impact mode (Yeah)

Unchanged
- ability to split on final star, reset, key, star count, or level id
- should still work with a variety of emulators including PJ64, parallel launcher, and retroarch
- can still delete file A on reset

----------
Conditions
----------

All conditions must be separate from other words/terms in the split names. Also,
	none of them are case sensitive.

- for a reset split, add "R" or "reset"
- for a key split, add "key"
- to add a star count condition, add it with parentheses e.g. (10) or (128)
- to add a level id/label condition, add it with square brackets e.g. [9] or [C1]

- For key and star count splits, there are 4 options for split timing. The default is level change.
	There's also xcam, instant, and classic.
- Classic is the aglab autosplitter behavior.  It will split on a level change or after Mario is
	actionable after the save prompt of a "no-exit" star/key.
- To specify which split option you want, you can add -x or -xcam for xcam, -i or -instant for instant, -c
	or -classic for classic

----------------------
ASL File Customization
----------------------

- there are additional settings you can customize, though for now it must be done in the .asl file
- note that .asl uses C# code (.NET Framework 4.6.1)

- the default key and star count split option can be changed. can use -l or -level for level change if
	you change this. look for:
	vars.SplitOption_Default = "level";
	
- you can add or remove specific key or reset keywords. look for:
	vars.ResetKeywords = new string[] { "R", "reset" };
	vars.KeyKeywords = new string[] { "key" };
	
- Below are the course labels included by default for every level id in the game. You can add or remove
	labels as desired. Note that different areas within a level share the same level id. They are not case 
	sensitive. Look for:
	#region Add course labels

- try using this helper to find level id's https://github.com/aglab2/LiveSplitAutoSplitters/releases/tag/helper
	or potentially use quad https://github.com/DavidSM64/Quad64/releases
	
9  aka 0x09: "Course 1", "C1", "C01" // Bob-omb Battlefield<br />
24 aka 0x18: "Course 2", "C2", "C02" // Whomp's Fortress<br />
12 aka 0x0C: "Course 3", "C3", "C03" // Jolly Roger Bay<br />
5  aka 0x05: "Course 4", "C4", "C04" // Cool, Cool Mountain<br />
4  aka 0x04: "Course 5", "C5", "C05" // Big Boo's Haunt<br />
7  aka 0x07: "Course 6", "C6", "C06" // Hazy Maze Cave<br />
22 aka 0x16: "Course 7", "C7", "C07" // Lethal Lava Land<br />
8  aka 0x08: "Course 8", "C8", "C08" // Shifting Sand Land<br />
23 aka 0x17: "Course 9", "C9", "C09" // Dire, Dire Docks<br />
10 aka 0x0A: "Course 10", "C10" // Snowman's Land<br />
11 aka 0x0B: "Course 11", "C11" // Wet-Dry World<br />
36 aka 0x24: "Course 12", "C12" // Tall, Tall Mountain<br />
13 aka 0x0D: "Course 13", "C13" // Tiny-Huge Island<br />
14 aka 0x0E: "Course 14", "C14" // Tick Tock Clock<br />
15 aka 0x0F: "Course 15", "C15" // Rainbow Ride<br />
16 aka 0x10: "Overworld 1", "OW1" // Castle Grounds<br />
6  aka 0x06: "Overworld 2", "OW2" // Inside Castle<br />
26 aka 0x1A: "Overworld 3", "OW3" // Castle Courtyard<br />
17 aka 0x11: "Bowser Course 1", "Bowser 1", "BC1", "B1" // Bowser in the Dark World (Course)<br />
19 aka 0x13: "Bowser Course 2", "Bowser 2", "BC2", "B2" // Bowser in the Fire Sea (Course)<br />
21 aka 0x15: "Bowser Course 3", "Bowser 3", "BC3", "B3" // Bowser in the Sky (Course)<br />
30 aka 0x1E: "Bowser Fight 1", "Fight 1", "BF1", "F1" // Bowser in the Dark World (Fight)<br />
33 aka 0x21: "Bowser Fight 2", "Fight 2", "BF2", "F2" // Bowser in the Fire Sea (Fight)<br />
34 aka 0x22: "Bowser Fight 3", "Fight 3", "BF3", "F3" // Bowser in the Sky (Fight)<br />
28 aka 0x1C: "Metal Cap", "MC" // Cavern of the Metal Cap<br />
29 aka 0x1D: "Wing Cap", "WC" // Tower of the Wing Cap<br />
18 aka 0x12: "Vanish Cap", "VC" // Vanish Cap Under the Moat<br />
27 aka 0x1B: "Secret Level 1", "Secret 1", "SL1", "S1" // The Princess's Secret Slide<br />
20 aka 0x14: "Secret Level 2", "Secret 2", "SL2", "S2" // Secret Aquarium<br />
31 aka 0x1F: "Secret Level 3", "Secret 3", "SL3", "S3" // Wing Mario over the Rainbow<br />
25 aka 0x19: "Secret Level 4", "Secret 4", "SL4", "S4", "Cake", "End" // End Cake Picture<br />

--------------
Code Reference
--------------

Animation ID's<br />
4864 aka 0x1300: warp hole<br />
<br />
4866 aka 0x1302: land star/key dance, exit<br />
4867 aka 0x1303: water star dance<br />
4871 aka 0x1307: land star/key dance, no exit<br />
<br />
6404 aka 0x1904: falling after star grab<br />
6409 aka 0x1909: Grand Star grab<br />