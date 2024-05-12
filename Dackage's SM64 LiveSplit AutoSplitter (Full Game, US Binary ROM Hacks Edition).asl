/*
Dackage's SM64 LiveSplit AutoSplitter v1.0 (Full Game, US Binary ROM Hacks Edition)

Github repository:
https://github.com/Dackage353/Dackage-s-SM64-LiveSplit-AutoSplitter
*/

state("project64") { }
state("retroarch") { }

startup
{
	#region Editable settings and constants
	refreshRate = 30;
	
	// Not case sensitive
	vars.SplitOption_ClassicKeywords = new string[] { "c", "classic" };
	vars.SplitOption_LevelKeywords = new string[] { "l", "level" };
	vars.SplitOption_XCamKeywords = new string[] { "x", "xcam" };
	vars.SplitOption_GrabKeywords = new string[] { "g", "grab" };
	vars.SplitOption_Default = "level"; // Must match a keyword from above
	
	// Not case sensitive
	vars.ResetKeywords = new string[] { "R", "reset" };
	vars.KeyKeywords = new string[] { "key" };
	
	// Case sensitive. Can be the same symbol for open and close
	vars.StarCountOpenSymbol = '(';
	vars.StarCountCloseSymbol = ')';
	vars.LevelOpenSymbol = '[';
	vars.LevelCloseSymbol = ']';
	vars.ArgumentSymbol = '-';
	
	// These need changing if using another vanilla game version or a nonbinary/decomp ROM hack
	vars.StarCountAddress = 0x33B218;
	vars.LevelIDAddress = 0x32DDFA;
	vars.AnimationIDAddress = 0x33B17C;
	vars.TimeAddress = 0x32D580;
	vars.FileAAddress = 0x207708;
	vars.FileALength = 0x70;
	vars.KeyByteOffset = 0x0;
	#endregion
	
	#region Non-editable constants
	vars.EmptyFile = ((IEnumerable<byte>) Enumerable.Repeat((byte) 0, vars.FileALength)).ToArray();
	
	// The livesplit parser can't handle braces in quotes. 123 is open brace, 125 is close brace
	vars.SubsplitSectionNameOpenSymbol = (char) 123;
	vars.SubsplitSectionNameCloseSymbol = (char) 125;
	
	vars.AddressSearchInterval = 1000;
	vars.DeleteFileADuration = 4 * 60;
	#endregion
	
	#region Initialize settings
	settings.Add("DeleteFileA", false, "Delete \"File A\" when a new run starts");
	settings.Add("SplitOnLastSplitStar", true, "Split on final split when Grand Star or regular star was grabbed");
	settings.Add("SplitOnLastSplitWarp", false, "Split on final split when warped (like in Star Road 0/80 Star)");
	settings.Add("LastImpactStartReset", false, "Enable Last Impact start/reset mode");
	#endregion
	
	#region Create methods
	vars.GetSplitName = (Func<string>) (() =>
	{
		string splitName = timer.CurrentSplit.Name.Trim();
		
		bool containsSubsplits = false;
		foreach (var component in timer.Layout.Components)
		{
			if (component.ComponentName == "Subsplits")
			{
				containsSubsplits = true;
				break;
			}
		}
		
		if (containsSubsplits && splitName.Length > 0)
		{
			if (splitName[0] == vars.SubsplitSectionNameOpenSymbol && splitName.Contains(vars.SubsplitSectionNameCloseSymbol.ToString()))
			{
				return splitName.Substring(splitName.IndexOf(vars.SubsplitSectionNameCloseSymbol) + 1);
			}
			else if (splitName[0] == '-')
			{
				return splitName.Substring(1);
			}
		}
		
		return splitName;
	});
	
	vars.AddCourseLabels = (Action<byte, string[]>) ((levelID, labels) =>
	{
		labels = labels.Select(label => label.Trim()).ToArray();
		
		for (int i = 0; i < labels.Length; i++)
		{
			if (!vars.levelLabelsAndIDs.ContainsKey(labels[i]))
			{
				vars.levelLabelsAndIDs.Add(labels[i], levelID);
			}
		}
	});
	
	vars.StringArrayContains_IgnoreCase = (Func<string[], string, bool>) ((array, text) =>
	{
		return array.Any(element => string.Equals(text, element, StringComparison.OrdinalIgnoreCase));
	});
	#endregion
	
	#region Add course labels
	vars.levelLabelsAndIDs = new Dictionary<string, byte>(StringComparer.OrdinalIgnoreCase);
	
	// Labels are not case sensitive
	vars.AddCourseLabels(9, new string[] { "Course 1", "C1", "C01" }); // Bob-omb Battlefield
	vars.AddCourseLabels(24, new string[] { "Course 2", "C2", "C02" }); // Whomp's Fortress
	vars.AddCourseLabels(12, new string[] { "Course 3", "C3", "C03" }); // Jolly Roger Bay
	vars.AddCourseLabels(5, new string[] { "Course 4", "C4", "C04" }); // Cool, Cool Mountain
	vars.AddCourseLabels(4, new string[] { "Course 5", "C5", "C05" }); // Big Boo's Haunt
	vars.AddCourseLabels(7, new string[] { "Course 6", "C6", "C06" }); // Hazy Maze Cave
	vars.AddCourseLabels(22, new string[] { "Course 7", "C7", "C07" }); // Lethal Lava Land
	vars.AddCourseLabels(8, new string[] { "Course 8", "C8", "C08" }); // Shifting Sand Land
	vars.AddCourseLabels(23, new string[] { "Course 9", "C9", "C09" }); // Dire, Dire Docks
	vars.AddCourseLabels(10, new string[] { "Course 10", "C10" }); // Snowman's Land
	vars.AddCourseLabels(11, new string[] { "Course 11", "C11" }); // Wet-Dry World
	vars.AddCourseLabels(36, new string[] { "Course 12", "C12" }); // Tall, Tall Mountain
	vars.AddCourseLabels(13, new string[] { "Course 13", "C13" }); // Tiny-Huge Island
	vars.AddCourseLabels(14, new string[] { "Course 14", "C14" }); // Tick Tock Clock
	vars.AddCourseLabels(15, new string[] { "Course 15", "C15" }); // Rainbow Ride
	vars.AddCourseLabels(16, new string[] { "Overworld 1", "OW1" }); // Castle Grounds
	vars.AddCourseLabels(6, new string[] { "Overworld 2", "OW2" }); // Inside Castle
	vars.AddCourseLabels(26, new string[] { "Overworld 3", "OW3" }); // Castle Courtyard
	vars.AddCourseLabels(17, new string[] { "Bowser Course 1", "Bowser 1", "BC1", "B1" }); // Bowser in the Dark World (Course)
	vars.AddCourseLabels(19, new string[] { "Bowser Course 2", "Bowser 2", "BC2", "B2" }); // Bowser in the Fire Sea (Course)
	vars.AddCourseLabels(21, new string[] { "Bowser Course 3", "Bowser 3", "BC3", "B3" }); // Bowser in the Sky (Course)
	vars.AddCourseLabels(30, new string[] { "Bowser Fight 1", "Fight 1", "BF1", "F1" }); // Bowser in the Dark World (Fight)
	vars.AddCourseLabels(33, new string[] { "Bowser Fight 2", "Fight 2", "BF2", "F2" }); // Bowser in the Fire Sea (Fight)
	vars.AddCourseLabels(34, new string[] { "Bowser Fight 3", "Fight 3", "BF3", "F3" }); // Bowser in the Sky (Fight)
	vars.AddCourseLabels(28, new string[] { "Metal Cap", "MC" }); // Cavern of the Metal Cap
	vars.AddCourseLabels(29, new string[] { "Wing Cap", "WC" }); // Tower of the Wing Cap
	vars.AddCourseLabels(18, new string[] { "Vanish Cap", "VC" }); // Vanish Cap Under the Moat
	vars.AddCourseLabels(27, new string[] { "Secret Level 1", "Secret 1", "SL1", "S1" }); // The Princess's Secret Slide
	vars.AddCourseLabels(20, new string[] { "Secret Level 2", "Secret 2", "SL2", "S2" }); // Secret Aquarium
	vars.AddCourseLabels(31, new string[] { "Secret Level 3", "Secret 3", "SL3", "S3" }); // Wing Mario over the Rainbow
	vars.AddCourseLabels(25, new string[] { "Secret Level 4", "Secret 4", "SL4", "S4", "Cake", "End" }); // End Cake Picture
	#endregion
}

init
{
	current.starCount = (byte) 0;
	current.levelID = (byte) 0;
	current.animationID = 0;
	current.time = 0;
	current.keyFlagsByte = (byte) 0;
	
	vars.baseRAMAddressFound = false;
	vars.stopwatch = new Stopwatch();
	vars.baseRAMAddress = IntPtr.Zero;
	vars.verifyRetriesLeft = 0;
	
	vars.retroarch = game.ProcessName.Contains("retroarch");
}

update
{
	#region Handle baseRAMAddress
	if (!vars.baseRAMAddressFound)
	{
		if (!vars.stopwatch.IsRunning || vars.stopwatch.ElapsedMilliseconds > vars.AddressSearchInterval)
		{
			vars.stopwatch.Start();
			vars.baseRAMAddress = IntPtr.Zero;
			
			if (!vars.retroarch)
			{
				// Hardcoded values because GetSystemInfo / GetNativeSystemInfo can't return info for remote process
				var min = 0x10000L;
				var max = game.Is64Bit() ? 0x00007FFFFFFEFFFFL : 0xFFFFFFFFL;
				
				var mbiSize = (UIntPtr) 0x30; // Clueless
				
				var addr = min;
				do
				{
					MemoryBasicInformation mbi;
					if (WinAPI.VirtualQueryEx(game.Handle, (IntPtr)addr, out mbi, mbiSize) == (UIntPtr)0)
						break;
					
					addr += (long)mbi.RegionSize;
					
					if (mbi.State != MemPageState.MEM_COMMIT)
						continue;
					
					if ((mbi.Protect & MemPageProtect.PAGE_GUARD) != 0)
						continue;
					
					if (mbi.Type != MemPageType.MEM_PRIVATE)
						continue;
					
					if (((int) mbi.Protect & (int) 0xcc) == 0)
						continue;
					
					uint val;
					if (!game.ReadValue(mbi.BaseAddress, out val))
					{
						continue;
					}
					if ((val & 0xfffff000) == 0x3C1A8000)
					{
						vars.baseRAMAddress = mbi.BaseAddress;
						break;
					}
				} while (addr < max);
			}
			else
			{
				var parallelModule = modules.Where(x => x.ModuleName.Contains("parallel_n64")).First();
				var parallelStart = (long) parallelModule.BaseAddress;
				for (long num = 0; num < (long) parallelModule.ModuleMemorySize / 0x1000; num++)
				{
					uint val;
					var addr = (IntPtr) (parallelStart + num * 0x1000);
					if (!game.ReadValue(addr, out val))
					{
						continue;
					}
					if ((val & 0xfffff000) == 0x3C1A8000)
					{
						vars.baseRAMAddress = addr;
						break;
					}
				}
			}
			
			if (vars.baseRAMAddress == IntPtr.Zero)
			{
				vars.stopwatch.Restart();
				return false;
			}
			else
			{
				vars.stopwatch.Reset();
				vars.baseRAMAddressFound = true;
			}
		}
		else
		{
			return false;
		}
	}
	
	// Verify base RAM address is still valid on each update
	uint tval;
	if (!game.ReadValue((IntPtr) vars.baseRAMAddress, out tval))
	{
		vars.baseRAMAddressFound = false;
		vars.baseRAMAddress = IntPtr.Zero;
		return false;
	}
	
	if ((tval & 0xfffff000) != 0x3C1A8000)
	{
		if (0 == (vars.verifyRetriesLeft--))
		{
			vars.baseRAMAddressFound = false;
			vars.baseRAMAddress = IntPtr.Zero;
		}
		return false;
	}
	else
	{
		vars.verifyRetriesLeft = 100;
	}
	#endregion
	
	#region Read memory addresses
	current.starCount = memory.ReadValue<byte>((IntPtr) (vars.baseRAMAddress + vars.StarCountAddress));
	current.levelID = memory.ReadValue<byte>((IntPtr) (vars.baseRAMAddress + vars.LevelIDAddress));
	current.animationID = memory.ReadValue<int> ((IntPtr) (vars.baseRAMAddress + vars.AnimationIDAddress));
	current.time = memory.ReadValue<int> ((IntPtr) (vars.baseRAMAddress + vars.TimeAddress));
	current.keyFlagsByte = memory.ReadValue<byte>((IntPtr) (vars.baseRAMAddress + vars.FileAAddress + vars.KeyByteOffset));
	#endregion
	
	if (timer.CurrentPhase == TimerPhase.Running)
	{
		#region Handle vars.deleteFileA
		if (vars.deleteFileA)
		{
			if (current.time < vars.DeleteFileADuration)
			{
				IntPtr ptr = vars.baseRAMAddress + vars.FileAAddress;
				game.WriteBytes(ptr, (byte[]) vars.EmptyFile);
			}
			else
			{
				vars.deleteFileA = false;
			}
		}
		#endregion
		
		#region Initialize split handling
		current.splitName = vars.GetSplitName();
		
		bool key1Flag = (current.keyFlagsByte & (1 << 4)) != 0 || (current.keyFlagsByte & (1 << 6)) != 0;
		bool key2Flag = (current.keyFlagsByte & (1 << 5)) != 0 || (current.keyFlagsByte & (1 << 7)) != 0;
		#endregion
		
		#region Process split name on new split
		if (current.splitName != old.splitName)
		{
			vars.splitContainsReset = false;
			vars.splitContainsKey = false;
			vars.splitStarCount = -1;
			vars.splitLevelID = -1;
			vars.splitOption = null;
			
			vars.initialKey1Flag = key1Flag;
			vars.initialKey2Flag = key2Flag;
			
			string[] splitNameTerms = current.splitName.Split(null);
			splitNameTerms = splitNameTerms.Select(term => term.Trim()).ToArray();
			
			foreach (string term in splitNameTerms)
			{
				if (vars.StringArrayContains_IgnoreCase(vars.ResetKeywords, term))
				{
					vars.splitContainsReset = true;
				}
				else if (vars.StringArrayContains_IgnoreCase(vars.KeyKeywords, term))
				{
					vars.splitContainsKey = true;
				}
				else if (term.Length >= 2)
				{
					string inside = term.Substring(1, term.Length - 2).Trim();
					
					if (term.First() == vars.StarCountOpenSymbol && term.Last() == vars.StarCountCloseSymbol)
					{
						byte num;
						if (byte.TryParse(inside, out num))
						{
							vars.splitStarCount = num;
						}
					}
					else if (term.First() == vars.LevelOpenSymbol && term.Last() == vars.LevelCloseSymbol)
					{
						byte num;
						if (byte.TryParse(inside, out num))
						{
							vars.splitLevelID = num;
						}
						else if (vars.levelLabelsAndIDs.ContainsKey(inside))
						{
							vars.splitLevelID = vars.levelLabelsAndIDs[inside];
						}
					}
					else if (term.First() == vars.ArgumentSymbol)
					{
						string argument = term.Substring(1);
						
						if (vars.StringArrayContains_IgnoreCase(vars.SplitOption_ClassicKeywords, argument) ||
							vars.StringArrayContains_IgnoreCase(vars.SplitOption_LevelKeywords, argument) ||
							vars.StringArrayContains_IgnoreCase(vars.SplitOption_XCamKeywords, argument) ||
							vars.StringArrayContains_IgnoreCase(vars.SplitOption_GrabKeywords, argument))
						{
							vars.splitOption = argument;
						}
					}
				}
			}
		}
		#endregion
		
		#region Test split info against current values
		bool passedKeyTest = !vars.splitContainsKey || (vars.initialKey1Flag != key1Flag || vars.initialKey2Flag != key2Flag);
		bool passedStarCountTest = vars.splitStarCount == -1 || current.starCount == vars.splitStarCount;
		bool passedLevelIDTest = vars.splitLevelID == -1 || current.levelID == vars.splitLevelID;
		current.passedAllTests = passedKeyTest && passedStarCountTest && passedLevelIDTest;
		#endregion
	}
	
	return true;
}

start
{
	if (settings["LastImpactStartReset"])
	{
		return old.levelID == 35 && current.levelID == 16 && current.starCount == 0;
	}
	
	return current.time < old.time;
}

reset
{
	if (settings["LastImpactStartReset"])
	{
		return old.levelID == 35 && current.levelID == 16 && current.starCount == 0;
	}
	
	if (current.time < old.time)
	{
		if (vars.splitContainsReset)
		{
			return !old.passedAllTests;
		}
		
		return true;
	}
	
	return false;
}

onStart
{
	vars.deleteFileA = settings["DeleteFileA"];
	vars.resetIGTFixup = 0;
	
	current.splitName = null;
	current.passedAllTests = false;
}

split
{
	#region Handle reset splits
	if (old.passedAllTests && vars.splitContainsReset)
	{
		return current.time < old.time;
	}
	#endregion
	
	if (current.passedAllTests)
	{
		#region Handle last split splitting
		bool isLastSplit = timer.CurrentSplitIndex == timer.Run.Count - 1;
		if (isLastSplit)
		{
			if (settings["SplitOnLastSplitStar"])
			{
				bool starGrabbed = current.animationID == 4866 || current.animationID == 4867 || current.animationID == 4871 ||
					current.animationID == 6404 || current.animationID == 6409;
				
				if (starGrabbed) return true;
			}
				
			if (settings["SplitOnLastSplitWarp"] && current.animationID == 4864)
			{
				return true;
			}
		}
		#endregion
		
		#region Handle key, star count, or level id splits
		bool levelChanged = current.levelID != old.levelID;
		if (vars.splitContainsKey || vars.splitStarCount != -1)
		{
			if (vars.splitOption == null)
			{
				vars.splitOption = vars.SplitOption_Default;
			}
			
			if (vars.StringArrayContains_IgnoreCase(vars.SplitOption_ClassicKeywords, vars.splitOption))
			{
				bool xCamJustEnded = current.animationID != old.animationID && (old.animationID == 4866 || old.animationID == 4867 || old.animationID == 4871);
				return levelChanged || xCamJustEnded;
			}
			else if (vars.StringArrayContains_IgnoreCase(vars.SplitOption_LevelKeywords, vars.splitOption))
			{
				return levelChanged;
			}
			else if (vars.StringArrayContains_IgnoreCase(vars.SplitOption_XCamKeywords, vars.splitOption))
			{
				return current.animationID == 4866 || current.animationID == 4867 || current.animationID == 4871;
			}
			else if (vars.StringArrayContains_IgnoreCase(vars.SplitOption_GrabKeywords, vars.splitOption))
			{
				return true;
			}
		}
		else if (vars.splitLevelID != -1)
		{
			return levelChanged;
		}
		#endregion
	}
	
	return false;
}

// Without this, livesplit will increment the igt when the ROM is not running
isLoading
{
	return true;
}

gameTime
{
	if (current.time < old.time)
	{
		vars.resetIGTFixup += old.time;
	}
	
	return TimeSpan.FromSeconds((double)(vars.resetIGTFixup + current.time) / 60.0416);
}