# Dackage's SM64 LiveSplit AutoSplitter

Wanting to add the ability to use course labels, I looked into making my autosplitter version. This is
	functionally very similiar to aglab2's "LiveSplit.SuperMario64.asl" autosplitter and is what I built off of
	https://github.com/aglab2/LiveSplitAutoSplitters

Main Features
- split on level entry: e.g. [C1] or [B1] or [WC] // See the bottom of the readme for a complete list
- split on specific area: e.g. [C1:3] or [B1:2] // The area index starts at 1
- split on fadeout after star count: e.g. (20) or (53)
- split on fadeout after key get: e.g. "key 1 fight" or "bowser 1 key" // Use the word "key" somewhere
- split on reset: e.g. "star 1 + R" or "top star then reset" // Include "R" or "reset" somewhere
- split on Grand Star // See the advanced options in the livesplit layout
- use the in-game timer

Compatibility
- Any Project64 version
- Parallel Launcher

----------
Common Issues
----------
"It won't split"
- Check that conditions are separated by a space. Like "star (1)" and not "star(1)"
- You can edit split names during the run and it will probably work.

"Keys aren't working"
- Keys only work on File A at the moment. I want to fix this eventually

"How to split on toad stars" 
- The splitter waits for an area change by default to split. It's recommended to do it this way for accurate golds.
- If you wish, you can split on star grab or xcam by adding -g or -x to the split name e.g. "toad star (32) -g"

-------------
Course Labels
-------------

Below are the course labels included by default. They are not case sensitive
- the easiest way to find level id's is probably STROOP. Add the "Misc" tab if it isn't there already, then look for "Stage Index."
    Then you can match that number with the numbers below. Decomp hacks won't work.
	https://github.com/SM64-TAS-ABC/STROOP

&nbsp; 9 aka 0x09: "Course 1", "C1", "C01" // Bob-omb Battlefield<br />
24 aka 0x18: "Course 2", "C2", "C02" // Whomp's Fortress<br />
12 aka 0x0C: "Course 3", "C3", "C03" // Jolly Roger Bay<br />
&nbsp; 5 aka 0x05: "Course 4", "C4", "C04" // Cool, Cool Mountain<br />
&nbsp; 4 aka 0x04: "Course 5", "C5", "C05" // Big Boo's Haunt<br />
&nbsp; 7 aka 0x07: "Course 6", "C6", "C06" // Hazy Maze Cave<br />
22 aka 0x16: "Course 7", "C7", "C07" // Lethal Lava Land<br />
&nbsp; 8 aka 0x08: "Course 8", "C8", "C08" // Shifting Sand Land<br />
23 aka 0x17: "Course 9", "C9", "C09" // Dire, Dire Docks<br />
10 aka 0x0A: "Course 10", "C10" // Snowman's Land<br />
11 aka 0x0B: "Course 11", "C11" // Wet-Dry World<br />
36 aka 0x24: "Course 12", "C12" // Tall, Tall Mountain<br />
13 aka 0x0D: "Course 13", "C13" // Tiny-Huge Island<br />
14 aka 0x0E: "Course 14", "C14" // Tick Tock Clock<br />
15 aka 0x0F: "Course 15", "C15" // Rainbow Ride<br />
16 aka 0x10: "Overworld 1", "OW1" // Castle Grounds<br />
&nbsp; 6 aka 0x06: "Overworld 2", "OW2" // Inside Castle<br />
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
- any basic text editor will do, but I've been using VS Code. If you do, you can change the language to C#
	so that it's easier to read.
- .asl uses C# code (.NET Framework 4.8.1)

The split option can be changed. By default it's "area" but you can also do level, grab, xcam, or classic.
- Look for: vars.SplitOption_Default = "area";
	
You can add or remove specific key or reset keywords. Look for:
- vars.ResetKeywords = new string[] { "R", "reset" };
- vars.KeyKeywords = new string[] { "key" };
	
You can add or remove course labels as desired. Note that different areas within a level share the
	same level id. Look for:
- #region Add course labels

--------------
Code Reference
--------------

Animation ID's
- 4864 aka 0x1300: warp hole
- 4866 aka 0x1302: land star/key dance, exit
- 4867 aka 0x1303: water star dance
- 4871 aka 0x1307: land star/key dance, no exit
- 6404 aka 0x1904: falling after star grab
- 6409 aka 0x1909: Grand Star grab

--------------
Special Thanks
--------------

- DJ_Tala for help with testing
- aglab2 for the creation of the original and some help