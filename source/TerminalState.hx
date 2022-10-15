import flixel.math.FlxMath;
import flixel.group.FlxGroup;
import sys.io.File;
import lime.app.Application;
import flixel.tweens.FlxTween;
import flixel.math.FlxRandom;
import openfl.filters.ShaderFilter;
import haxe.ds.Map;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.*;
import flixel.util.FlxTimer;
import flash.system.System;
import flixel.system.FlxSound;

using StringTools;

import PlayState; //why the hell did this work LMAO.


class TerminalState extends MusicBeatState
{

    //dont just yoink this code and use it in your own mod. this includes you, psych engine porters.
    //if you ingore this message and use it anyway, atleast give credit.

    public var curCommand:String = "";
    public var previousText:String = LanguageManager.getTerminalString("term_introduction");
    public var displayText:FlxText;
    var expungedActivated:Bool = false;
    public var CommandList:Array<TerminalCommand> = new Array<TerminalCommand>();
    public var typeSound:FlxSound;

    // [BAD PERSON] was too lazy to finish this lol.
    var unformattedSymbols:Array<String> =
    [
        "period",
        "backslash",
        "one",
        "two",
        "three",
        "four",
        "five",
        "six",
        "seven",
        "eight",
        "nine",
        "zero",
        "shift",
        "semicolon",
        "alt",
        "lbracket",
        "rbracket",
        "comma",
        "plus"
    ];

    var formattedSymbols:Array<String> =
    [
        ".",
        "/",
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "0",
        "",
        ";",
        "",
        "[",
        "]",
        ",",
        "="
    ];
    public var fakeDisplayGroup:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();
    public var expungedTimer:FlxTimer;
    var curExpungedAlpha:Float = 0;

    override public function create():Void
    {
        Main.fps.visible = false;
        PlayState.isStoryMode = false;
        displayText = new FlxText(0, 0, FlxG.width, previousText, 32);
		displayText.setFormat(Paths.font("fixedsys.ttf"), 16);
        displayText.size *= 2;
		displayText.antialiasing = false;
        typeSound = FlxG.sound.load(Paths.sound('terminal_space'), 0.6);
        FlxG.sound.playMusic(Paths.music('TheAmbience','shared'), 0.7);

        CommandList.push(new TerminalCommand("help", LanguageManager.getTerminalString("term_help_ins"), function(arguments:Array<String>)
        {
            UpdatePreviousText(false); //resets the text
            var helpText:String = "";
            for (v in CommandList)
            {
                if (v.showInHelp)
                {
                    helpText += (v.commandName + " - " + v.commandHelp + "\n");
                }
            }
            UpdateText("\n" + helpText);
        }));

        CommandList.push(new TerminalCommand("characters", LanguageManager.getTerminalString("term_char_ins"), function(arguments:Array<String>)
        {
            UpdatePreviousText(false); //resets the text
            UpdateText("\ndave.dat\nbambi.dat\ntristan.dat\nexpunged.dat\nexbungo.dat\nrecurser.dat\nmoldy.dat");
        }));
        CommandList.push(new TerminalCommand("admin", LanguageManager.getTerminalString("term_admin_ins"), function(arguments:Array<String>)
        {
            if (arguments.length == 0)
            {
                UpdatePreviousText(false); //resets the text
                UpdateText("\n" + (!FlxG.save.data.selfAwareness ? CoolSystemStuff.getUsername() : 'User354378')
                 + LanguageManager.getTerminalString("term_admlist_ins"));
                return;
            }
            else if (arguments.length != 2)
            {
                UpdatePreviousText(false); //resets the text
                UpdateText(LanguageManager.getTerminalString("term_admin_error1") + " " + arguments.length + LanguageManager.getTerminalString("term_admin_error2"));
            }
            else
            {
                if (arguments[0] == "grant")
                {
                    switch (arguments[1])
                    {
                        default:
                            UpdatePreviousText(false); //resets the text
                            UpdateText("\n" + arguments[1] + LanguageManager.getTerminalString("term_grant_error1"));
                        case "dave.dat":
                            UpdatePreviousText(false); //resets the text
                            UpdateText(LanguageManager.getTerminalString("term_loading"));
                            PlayState.globalFunny = CharacterFunnyEffect.Dave;
                            PlayState.SONG = Song.loadFromJson("house");
                            PlayState.SONG.validScore = false;
                            Main.fps.visible = !FlxG.save.data.disableFps;
                            LoadingState.loadAndSwitchState(new PlayState());
                        case "tristan.dat":
                            UpdatePreviousText(false); //resets the text
                            UpdateText(LanguageManager.getTerminalString("term_loading"));
                            PlayState.globalFunny = CharacterFunnyEffect.Tristan;
                            PlayState.SONG = Song.loadFromJson("house");
                            PlayState.SONG.validScore = false;
                            Main.fps.visible = !FlxG.save.data.disableFps;
                            LoadingState.loadAndSwitchState(new PlayState());
                        case "exbungo.dat":
                            UpdatePreviousText(false); //resets the text
                            UpdateText(LanguageManager.getTerminalString("term_loading"));
                            PlayState.globalFunny = CharacterFunnyEffect.Exbungo;
                            var funny:Array<String> = ["house","insanity","polygonized","five-nights","splitathon","shredder"];
                            var funnylol:Int = FlxG.random.int(0, funny.length - 1);
                            PlayState.SONG = Song.loadFromJson(funny[funnylol]);
                            PlayState.SONG.validScore = false;
                            PlayState.SONG.player2 = "exbungo";
                            Main.fps.visible = !FlxG.save.data.disableFps;
                            LoadingState.loadAndSwitchState(new PlayState());
                        case "bambi.dat":
                            UpdatePreviousText(false); //resets the text
                            UpdateText(LanguageManager.getTerminalString("term_loading"));
                            PlayState.globalFunny = CharacterFunnyEffect.Bambi;
                            PlayState.SONG = Song.loadFromJson('shredder');
                            PlayState.SONG.validScore = false;
                            LoadingState.loadAndSwitchState(new PlayState());
                        case "recurser.dat":
                            UpdatePreviousText(false); //resets the text
                            UpdateText(LanguageManager.getTerminalString("term_loading"));
                            PlayState.globalFunny = CharacterFunnyEffect.Recurser;
                            PlayState.SONG = Song.loadFromJson('polygonized');
                            PlayState.SONG.validScore = false;
                            PlayState.SONG.stage = "house-night";
                            PlayState.SONG.player2 = 'dave-annoyed';
                            LoadingState.loadAndSwitchState(new PlayState());
                        case "expunged.dat":
                            UpdatePreviousText(false); //resets the text
                            UpdateText(LanguageManager.getTerminalString("term_loading"));
                            expungedActivated = true;
                            new FlxTimer().start(3, function(timer:FlxTimer)
                            {   
                                expungedReignStarts();
                            });
                        case "moldy.dat":
                            UpdatePreviousText(false); //resets the text
                            UpdateText(LanguageManager.getTerminalString("term_moldy_error"));
                            new FlxTimer().start(2, function(timer:FlxTimer)
                            {
                                fancyOpenURL("https://www.youtube.com/watch?v=azMGySH8fK8");
                                System.exit(0);
                            });
                    }
                }
                else
                {
                    UpdateText("\nInvalid Parameter"); //todo: translate.
                }
            }
        }));
        CommandList.push(new TerminalCommand("clear", LanguageManager.getTerminalString("term_clear_ins"), function(arguments:Array<String>)
        {
            previousText = "> ";
            UpdateText("");
        }));
        CommandList.push(new TerminalCommand("open", LanguageManager.getTerminalString("term_texts_ins"), function(arguments:Array<String>)
        {
            UpdatePreviousText(false); //resets the text
            var tx = "";
            switch (arguments[0].toLowerCase())
            {
                default:
                    tx = "File not found.";
                case "dave":
                    tx = "Forever lost and adrift.\nTrying to change his destiny.\nDespite this, it pulls him by a lead.\nIt doesn't matter to him though.\nHe has a child to feed.";
                case "bambi":
                    tx = "A forgotten GOD.\nThe truth will never be known.\nThe extent of his POWERs won't ever unfold.";
                case "god" | "artifact1":
                    tx = "Artifact 1:\nA stone with symbols and writing carved into it.\nDescription:Its a figure that has hundreds of EYEs all across its body.\nNotes: Why does it look so much like Bambi?";
                case "eye":
                    tx = "Our LORD told us that he would remove one of his eyes everyday.\nHe tells me that he's doing this to save us.\nThat he might one day become unreasonable and we need to have faith in ourselves.\n...\nPlease, I promise you that's what he said. I-I'm not lying.\nDon't hurt me.";
                case "lord":
                    tx = "A being of many eyes. A being so wise. He gives it all up to ensure, that the golden one will have a bright future.";
                case "artifact2":
                    tx = "Artifact 2:\nAn almost entirely destroyed red robe.\nDescription: A red robe. \nIt has a symbol that resembles Bambi's hat, etched on it.";
                case "artifact3":
                    tx = "Artifact 3:\nA notebook, found on the floor of the 3D realm.\nNotes: I haven't bothered with the cypher yet.\nI have more important matters.";
                case "artifact4":
                    tx = "\"Artifact\" 4:\nA weird email, with attached images that use the same cypher as Artifact 3.\nNotes: Who sent this?";
                case "tristan":
                    tx = "The key to defeating the one whose name shall not be stated.\nA heart of gold that will never become faded.";
                case "expunged":
                    tx = "[FILE DELETED]\n[FUCK YOU!]"; // [THIS AND EXBUNGOS FILE ARE THE ONLY ONES I HAVE ACCESS TO UNFORTUNATELY. I HATE IT]
                case "deleted":
                    tx = "The unnamable never was a god and never will be. Just an accident.";
                case "exbungo":
                    tx = "[FAT AND UGLY.]";
                case "recurser":
                    tx = "A being of chaos that wants to spread ORDER.\nDespite this, his sanity is at the border.";
                case "moldy":
                    tx = "Let me show you my DS family!";    
                case "1":
                    tx = "LOG 1\nHello. I'm currently writing this from in my lab.\nThis entry will probably be short.\nTristan is only 3 and will wake up soon.\nBut this is mostly just to test things. Bye.";
                case "2":
                    tx = "LOG 2\nI randomly turned 3-Dimensional again, but things were different this time...\nI appeared in a void with\nrandom red geometric shapes scattered everywhere and an unknown light source.\nWhat is that place?\nCan I visit it again?";
                case "3":
                    tx = "LOG 3\nI'm currently working on studying interdimensional dislocation.\nThere has to be a root cause. Some trigger.\nI hope there aren't any long term side effects.";
                case "4":
                    tx = "LOG 4\nI'm doing various tests on myself, trying to figure out what causes the POLYGONization.\nIt hurts a lot, \nBut I must keep a smile. For Tristan's sake.";
                case "5":
                    tx = "[FILE DELETED]";
                case "6":
                    tx = "LOG 6\nNot infront of Tristan. I almost lost him in that void. I- [DATA DELETED]";
                case "7":
                    tx = "LOG 7\nMy interdimensional dislocation appears to be caused by mass amount of stress.\nHow strange.\nMaybe I could isolate this effect somehow?";
                case "8":
                    tx = "LOG 8\nHey, Muko here. Dave recently called me to assist with the PROTOTYPE. \nIt's been kind of fun. He won't tell me what it does though.";
                case "9" | "11" | "13":
                    tx = "[FILE DELETED]";
                case "12":
                    tx = "LOG 12\nThe prototype going pretty well.\nDave still won't tell me what this thing does.\nI can't figure it out even with the\nblueprints.\nI managed to convince him to take a break and\ngo to Cicis Pizza with me and Maldo.\nHe brought Tristan long as well. It was fun.\n-Maldo";
                case "10":
                    tx = "LOG 10\nWorking on the prototype.";
                case "14":
                    tx = "LOG 14\nI need to stop naming these numerically its getting confusing.";
                case "prototype":
                    tx = "Project <P.R.A.E.M>\nNotes: The SOLUTION.\nEstimated Build Time: 2 years.";
                case "solution":
                    tx = "I feel every ounce of my being torn to shreds and reconstructed with some parts removed.\nI can hear the electronical hissing of the machine.\nEvery fiber in my being is begging me to STOP.\nI don't.";
                case "stop":
                    tx = "A reflection that is always wrong now has appeared in his dreams.\nIt's a part thats now missing.\nA chunk out of his soul.";
                case "boyfriend":
                    tx = "LOG [REDACTED]\nA multiversal constant, for some reason. Must dive into further research.";
                case "order":
                    tx = "What is order? There are many definitions. Recurser doesn't use any of these though.\nThey want to keep everything the way they love it.\nTo them, that's order.";
                case "power":
                    tx = "[I HATE THEM.] [THEY COULD'VE HAD SO MUCH POWER, BUT THEY THREW IT AWAY.]\n[AND IN THAT HEAP OF UNWANTED POWER, I WAS CREATED.]";
                case "birthday":
                    tx = "Sent back to the void, a shattered soul encounters his broken <reflection>.";
                case "polygonized" | "polygon" | "3D":
                    tx = "He will never be <free>.";
                case "p.r.a.e.m":
                    tx = "Name: Power Removal And Extraction Machine\nProgress: Complete\nNotes: Took longer than expected. Tristans 7th BIRTHDAY is in a month.";
            }
            //case sensitive!!
            switch (arguments[0])
            {
                case "cGVyZmVjdGlvbg":
                    tx = "[BLADE WOULD'VE BEEN PERFECT. BUT DAVE HAD TO REFUSE.]";
                case "bGlhcg":
                    tx = "LOG 331\nI refuse to put Tristan through the torture that is P.R.A.E.M. Especially for [DATA EXPUNGED]. Not now. Not ever.";
                case "YmVkdGltZSBzb25n":
                    tx = "Even when you're feeling blue.\nAnd the world feels like its crumbling around you.\nJust know that I'll always be there.\nI wish I knew, everything that will happen to you.\nBut I don't, and that's okay.\nAs long as I'm here you'll always see a sunny day.";
                case "Y29udmVyc2F0aW9u":
                    tx = "Log 336\nI encountered some entity in the void today.\nCalled me \"Out of Order\".\nIt mentioned [DATA EXPUNGED] and I asked it for help.\nI don't know if I can trust it but I don't really have\nany other options.";
                case "YXJ0aWZhY3QzLWE=":
                    tx = "http://gg.gg/davetabase-artifact3";
                case "YmlydGhkYXk=":
                    tx = "http://gg.gg/davetabase-birthday";
                case "ZW1haWw=":
                    tx = "http://gg.gg/davetabase-mysterious-email";
            }
            UpdateText("\n" + tx);
        }));
        CommandList.push(new TerminalCommand("vault", LanguageManager.getTerminalString("term_vault_ins"), function(arguments:Array<String>)
        {
            UpdatePreviousText(false); //resets the text
            var funnyRequiredKeys:Array<String> = ['free', 'reflection', 'p.r.a.e.m'];
            var amountofkeys:Int = (arguments.contains(funnyRequiredKeys[0]) ? 1 : 0);
            amountofkeys += (arguments.contains(funnyRequiredKeys[1]) ? 1 : 0);
            amountofkeys += (arguments.contains(funnyRequiredKeys[2]) ? 1 : 0);
            if (arguments.contains(funnyRequiredKeys[0]) && arguments.contains(funnyRequiredKeys[1]) && arguments.contains(funnyRequiredKeys[2]))
            {
                UpdateText("\nVault unlocked.\ncGVyZmVjdGlvbg\nbGlhcg\nYmVkdGltZSBzb25n\ndGhlIG1lZXRpbmcgcDE=\ndGhlIG1lZXRpbmcgcDI=\nYmlydGhkYXk=\nZW1haWw=\nYXJ0aWZhY3QzLWE=");
            }
            else
            {
                UpdateText("\n" + "Invalid keys. Valid keys: " + amountofkeys);
            }
        }));
        CommandList.push(new TerminalCommand("secret mod leak", LanguageManager.getTerminalString("term_leak_ins"), function(arguments:Array<String>)
        {
			MathGameState.accessThroughTerminal = true;
            FlxG.switchState(new MathGameState());
        }, false, true));

        add(displayText);

        super.create();
    }

    public function UpdateText(val:String)
    {
        displayText.text = previousText + val;
    }

    //after all of my work this STILL DOESNT COMPLETELY STOP THE TEXT SHIT FROM GOING OFF THE SCREEN IM GONNA DIE
    public function UpdatePreviousText(reset:Bool)
    {
        previousText = displayText.text + (reset ? "\n> " : "");
        displayText.text = previousText;
        curCommand = "";
        var finalthing:String = "";
        var splits:Array<String> = displayText.text.split("\n");
        if (splits.length <= 22)
        {
            return;
        }
        var split_end:Int = Math.round(Math.max(splits.length - 22,0));
        for (i in split_end...splits.length)
        {
            var split:String = splits[i];
            if (split == "")
            {
                finalthing = finalthing + "\n";
            }
            else
            {
                finalthing = finalthing + split + (i < (splits.length - 1) ? "\n" : "");
            }
        }
        previousText = finalthing;
        displayText.text = finalthing;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        if (expungedActivated)
        {
            curExpungedAlpha = Math.min(curExpungedAlpha + elapsed, 1);
            if (fakeDisplayGroup.exists && fakeDisplayGroup != null)
            {
                for (text in fakeDisplayGroup.members)
                {
                    text.alpha = curExpungedAlpha;
                }
            }
            return;
        }
        var keyJustPressed:FlxKey = cast(FlxG.keys.firstJustPressed(), FlxKey);

        if (keyJustPressed == FlxKey.ENTER)
        {
            var calledFunc:Bool = false;
            var arguments:Array<String> = curCommand.split(" ");
            for (v in CommandList)
            {
                if (v.commandName == arguments[0] || (v.commandName == curCommand && v.oneCommand)) //argument 0 should be the actual command at the moment
                {
                    arguments.shift();
                    calledFunc = true;
                    v.FuncToCall(arguments);
                    break;
                }
            }
            if (!calledFunc)
            {
                UpdatePreviousText(false); //resets the text
                UpdateText(LanguageManager.getTerminalString("term_unknown") + arguments[0] + "\"");
            }
            UpdatePreviousText(true);
            return;
        }

        if (keyJustPressed != FlxKey.NONE)
        {
            if (keyJustPressed == FlxKey.BACKSPACE)
            {
                curCommand = curCommand.substr(0,curCommand.length - 1);
                typeSound.play();
            }
            else if (keyJustPressed == FlxKey.SPACE)
            {
                curCommand += " ";
                typeSound.play();
            }
            else
            {
                var toShow:String = keyJustPressed.toString().toLowerCase();
                for (i in 0...unformattedSymbols.length)
                {
                    if (toShow == unformattedSymbols[i])
                    {
                        toShow = formattedSymbols[i];
                        break;
                    }
                }
                if (FlxG.keys.pressed.SHIFT)
                {
                    toShow = toShow.toUpperCase();
                }
                curCommand += toShow;
                typeSound.play();
            }
            UpdateText(curCommand);
        }
        if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.BACKSPACE)
        {
            curCommand = "";
        }
        if (FlxG.keys.justPressed.ESCAPE)
        {
            Main.fps.visible = !FlxG.save.data.disableFps;
            FlxG.switchState(new MainMenuState());
        }
    }

	function expungedReignStarts()
	{
		var glitch = new FlxSprite(0, 0);
		glitch.frames = Paths.getSparrowAtlas('ui/glitch/glitch');
		glitch.animation.addByPrefix('glitchScreen', 'glitch', 40);
		glitch.animation.play('glitchScreen');
		glitch.setGraphicSize(FlxG.width, FlxG.height);
		glitch.updateHitbox();
		glitch.screenCenter();
		glitch.scrollFactor.set();
		glitch.antialiasing = false;
		if (FlxG.save.data.eyesores)
		{
			add(glitch);
		}

		add(fakeDisplayGroup);

		var expungedLines:Array<String> = [
			'TAKING OVER....',
			'ATTEMPTING TO HIJACK ADMIN OVERRIDE...',
			'THIS REALM IS MINE',
			"DON'T YOU UNDERSTAND? THIS IS MY WORLD NOW.",
			"I WIN, YOU LOSE.",
			"GAME OVER.",
			"THIS IS IT.",
			"FUCK YOU!",
			"I HAVE THE PLOT ARMOR NOW!!",
			"AHHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAH",
			"EXPUNGED'S REIGN SHALL START",
			'[DATA EXPUNGED]'
		];
		var i:Int = 0;
		var camFollow = new FlxObject(FlxG.width / 2, -FlxG.height / 2, 1, 1);

		#if windows
		if (FlxG.save.data.selfAwareness)
		{
			expungedLines.push("Hacking into " + Sys.environment()["COMPUTERNAME"] + "...");
		}
		#end

        FlxG.camera.follow(camFollow, 1);

        expungedActivated = true;
        expungedTimer = new FlxTimer().start(FlxG.elapsed * 2, function(timer:FlxTimer)
        {
            var lastFakeDisplay = fakeDisplayGroup.members[i - 1];
            var fakeDisplay:FlxText = new FlxText(0, 0, FlxG.width, "> " + expungedLines[new FlxRandom().int(0, expungedLines.length - 1)], 19);
            fakeDisplay.setFormat(Paths.font("fixedsys.ttf"), 16);
            fakeDisplay.size *= 2;
            fakeDisplay.antialiasing = false;

            var yValue:Float = lastFakeDisplay == null ? displayText.y + displayText.textField.textHeight : lastFakeDisplay.y + lastFakeDisplay.textField.textHeight;
            fakeDisplay.y = yValue;
            fakeDisplayGroup.add(fakeDisplay);
            if (fakeDisplay.y > FlxG.height)
            {
                camFollow.y = fakeDisplay.y - FlxG.height / 2;
            }
            i++;
        }, FlxMath.MAX_VALUE_INT);
        
        FlxG.sound.music.stop();
        FlxG.sound.play(Paths.sound("expungedGrantedAccess", "preload"), function()
        {
            FlxTween.tween(glitch, {alpha: 0}, 1);
            expungedTimer.cancel();
            fakeDisplayGroup.clear();

            var eye = new FlxSprite(0, 0).loadGraphic(Paths.image('mainMenu/eye'));
			eye.screenCenter();
			eye.antialiasing = false;
            eye.alpha = 0;
			add(eye);

            FlxTween.tween(eye, {alpha: 1}, 1, {onComplete: function(tween:FlxTween)
            {
                FlxTween.tween(eye, {alpha: 0}, 1);
            }});
			FlxG.sound.play(Paths.sound('iTrollYou', 'shared'), function()
			{
				new FlxTimer().start(1, function(timer:FlxTimer)
				{
					FlxG.save.data.exploitationState = 'awaiting';
					FlxG.save.data.exploitationFound = true;
					FlxG.save.flush();

					var programPath:String = Sys.programPath();
					var textPath = programPath.substr(0, programPath.length - CoolSystemStuff.executableFileName().length) + "help me.txt";

					File.saveContent(textPath, "you don't know what you're getting yourself into\n don't open the game for your own risk");
					System.exit(0);
				});
			});
        });
    }
}


class TerminalCommand
{
    public var commandName:String = "undefined";
    public var commandHelp:String = "if you see this you are very homosexual and dumb."; //hey im not homosexual. kinda mean ngl
    public var FuncToCall:Dynamic;
    public var showInHelp:Bool;
    public var oneCommand:Bool;

    public function new(name:String, help:String, func:Dynamic, showInHelp = true, oneCommand:Bool = false)
    {
        commandName = name;
        commandHelp = help;
        FuncToCall = func;
        this.showInHelp = showInHelp;
        this.oneCommand = oneCommand;
    }

}