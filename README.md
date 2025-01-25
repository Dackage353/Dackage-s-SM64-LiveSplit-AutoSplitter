# Dackage's SM64 LiveSplit AutoSplitter

Wanting to add the ability to use course labels, I looked into making my autosplitter version. This is
	functionally very similiar to aglab2's "LiveSplit.SuperMario64.asl" autosplitter and is what I built off of
	https://github.com/aglab2/LiveSplitAutoSplitters

Notes
- this is only made for binary ROM hacks of the US version of SM64. (Which is most hacks) Decomp hacks will not work
- only full game speedruns were in mind in making this. Stage RTA may not work well

New features and changes
- can use course labels instead of level id's e.g. [C1], [B1], or [WC]. You're still able to use level id's if desired.
	See the bottom of the readme for a complete list
- can now use multiple split conditions e.g. "get toad (20) and enter [C8]".
- split conditions can now be anywhere in the split name. (Previously they had to be at the end)
- added the option to split on grand stars that are a warp. Useful for categories that don't end on fadeout
	like Star Road 0/80 Star

Small fixes
- key splits no longer require a star count condition
- skipping a split after collecting a star won't autosplit on level change
- fix for the autosplitting not always working after water star/key animations

Retained features
- ability to split on final star, reset, key, star count, or level id
- compatibility with a variety of emulators including the many Project64's and parallel launcher
- delete file A on reset
- Last Impact mode
- igt

Removed features
- split on music change is removed for now, but I've never seen anyone use this

----------
Conditions
----------

Conditions are not case sensitive

- for a reset split, add "R" or "reset"
- for a key split, add "key"
- to add a star count condition, add it with parentheses e.g. (10) or (128)
- to add a level id/label condition, add it with square brackets e.g. [9] or [C1]

For key and star count splits, there are 4 options for split timing. Level change is the default for golds accuracy but
	there's also xcam, grab, and classic
- classic is the aglab autosplitter behavior. It will split after a fadeout or after Mario is actionable after the save
	prompt for a nonstop star/key. This is most useful for stars that warp you back to the same level.
- to specify which split option you want, you can add -x or -xcam for xcam, -g or -grab for grab, -c
	or -classic for classic

All conditions must be separate from other words/terms in the split names (meaning separated by a space or other whitespace)
	For Example:
- in "key 1 fight" a key keyword would be recognized, but not in "key1 fight"
- in "enter [OW2]" a level label would be recognized, but not in "enter [OW2]!"
- in "side star (35) + R" a reset keyword and a star count would be recognized, but not in "side star(35) +R"

----------
Common Issues
----------
- "keys are not working." Keys only work on File A at the moment
- "it didn't split after collecting an overworld star like toad or red coins." This is because my autosplitter waits for a level change by default.
	You can add a "-c" or "-classic" on the end of the split name, or plan for it to split on a level change instead. If you want it to
	behave like this by default, you can change the "vars.SplitOption_Default" from "level" to "classic" in the .asl file

-------------
Course Labels
-------------

Below are the course labels included by default. They are not case sensitive
- the easiest way to find level id's that aren't obvious is probably STROOP. Add the "Misc" tab if it isn't there
	already, then look for "Stage Index." Then you can match that number with the numbers below. Decomp hacks won't work.
	https://github.com/SM64-TAS-ABC/STROOP

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

----------------------
ASL File Customization
----------------------

There are additional settings you can customize, though for now it must be done in the .asl file
- any basic text editor will do, but I've been using Notepad++. If you do, change the language to C#
	so that it looks nicer.
- .asl uses C# code (.NET Framework 4.6.1)

The settings were made to be easy to change
- the default key and star count split option can be changed. Can use -l or -level for level change if
	you change this. Look for:<br />
	vars.SplitOption_Default = "level";<br />
	
- you can add or remove specific key or reset keywords. Look for:<br />
	vars.ResetKeywords = new string[] { "R", "reset" };<br />
	vars.KeyKeywords = new string[] { "key" };<br />
	
- you can add or remove course labels as desired. Note that different areas within a level share the
	same level id. Look for:<br />
	#region Add course labels<br />

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

--------------
Special Thanks
--------------

- DJ_Tala for help with testing
- aglab2 for the creation of the original and some help