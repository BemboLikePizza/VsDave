import flixel.math.FlxMath;
import flixel.group.FlxGroup;
import sys.io.File;
import lime.app.Application;
import flixel.tweens.FlxTween;
import flixel.math.FlxRandom;
import haxe.ds.Map;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.*;
import flixel.util.FlxTimer;
import flash.system.System;

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
        "comma"
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
        ","
    ];
    public var fakeDisplayGroup:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();
    public var expungedTimer:FlxTimer;
    var curExpungedAlpha:Float = 0;

    override public function create():Void
    {
        Main.fps.visible = false;
        PlayState.isStoryMode = false;
        displayText = new FlxText(0, 0, FlxG.width, previousText, 32);
		displayText.setFormat(Paths.font("PixelOperator-Bold.ttf"), 16);
        displayText.size *= 2;
		displayText.antialiasing = false;
        FlxG.sound.music.stop();

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
            switch (arguments[0])
            {
                default:
                    tx = "File not found.";
                case "dave":
                    tx = "Forever lost and adrift.\nTrying to change his destiny.\nDespite this, it pulls him by a lead.\nIt doesn't matter to him though.\nHe has a child to feed.";
                case "bambi":
                    tx = "A forgotten god.\nThe truth will never be known.\nThe extent of his POWERs won't ever unfold.";
                case "tristan":
                    tx = "The key to defeating the one whose name shall not be stated.\nA heart of gold that will never become faded.";
                case "expunged":
                    tx = "[LOG DELETED]";
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
                    tx = "LOG 4\nI'm doing various tests on myself, trying to figure out what causes the polygonization.\nBut I must keep a smile. For Tristan's sake.";
                case "5":
                    tx = "[DATA DELETED]";
                case "6":
                    tx = "LOG 6\nNot infront of Tristan. I almost lost him in that void. I- [DATA DELETED]";
                case "7":
                    tx = "LOG 7\nMy interdimensional dislocation appears to be caused by mass amount of stress.\nHow strange.\nMaybe I could isolate this effect somehow?";
                case "8" | "9" | "11" | "12" | "13":
                    tx = "[DATA DELETED]";
                case "10":
                    tx = "LOG 10\nWorking on the prototype.";
                case "14":
                    tx = "LOG 14\nI need to stop naming these numerically its getting confusing.";
                case "prototype":
                    tx = "Project <P.R.A.E>\nNotes: The solution.\nEstimated Build Time: 2 years.";
                case "solution":
                    tx = "I feel every ounce of my being torn to shreds and reconstructed with some parts missing. \nI can hear the electronical hissing. \nEvery fiber in my being is begging me to STOP.\nI don't.";
                case "stop":
                    tx = "A reflection that is always wrong in his dreams.\nA part thats now missing.\nA crack in the soul.";
                case "boyfriend":
                    tx = "LOG [REDACTED]\nA multiversal constant, for some reason. Must dive into further research.";
                case "order":
                    tx = "What is order? There are many definitions. But the only one that will matter to Recurser is the following:\nThe opposite of [DATA EXPUNGED]";
                case "power":
                    tx = "[I HATE HIM.] [HE COULD'VE HAD SO MUCH POWER, BUT HE THREW IT AWAY.]\n[AND IN THAT HEAP OF UNWANTED POWER, I WAS CREATED.]";
                case "birthday":
                    tx = "Sent back to the void, a shattered soul encounters his broken <reflection>.";
                case "polygonized" | "polygon" | "3D":
                    tx = "He will never be <free>.";
                case "p.r.a.e" | "P.R.A.E":
                    tx = "Name: Power Removal And Extraction\nProgress: Complete\nNotes: Tristans 7th BIRTHDAY is in a month.";
                case "saving":
                    tx = "[I SEE WHAT YOUR TRYING TO DO. HAH HAH. VERY FUNNY.]\n[I DON'T NEED SAVING.]\n[DAVE DOES THOUGH. FROM ME.]";
                case "cGVyZmVjdGlvbg":
                    tx = "[A GOLDEN MINION WOULD'VE BEEN PERFECT. BUT DAVE HAD TO REFUSE. NOT ONLY REFUSE, BUT LIE TO MY FACE.]";
                case "bGlhcg":
                    tx = "LOG 331\nI refuse to put Tristan through the torture that is P.R.A.E. Especially for [DATA EXPUNGED]. I will hurry up completion of project &*$^@*^(@(^&@)#^[File Corrupted]";
                case "YmVkdGltZSBzb25n":
                    tx = "Even when you're feeling blue.\nAnd the world feels like its crumbling around you.\nJust know that I'll always be there.\nI wish I knew, everything that will happen to you.\nBut I don't, and that's okay.\nAs long as I'm here uncertainty never matters anyway.";
            }
            UpdateText("\n" + tx);
        }));
        CommandList.push(new TerminalCommand("vault", LanguageManager.getTerminalString("term_vault_ins"), function(arguments:Array<String>)
        {
            UpdatePreviousText(false); //resets the text
            var funnyRequiredKeys:Array<String> = ['free', 'reflection', 'p.r.a.e'];
            var amountofkeys:Int = (arguments.contains(funnyRequiredKeys[0]) ? 1 : 0);
            amountofkeys += (arguments.contains(funnyRequiredKeys[1]) ? 1 : 0);
            amountofkeys += (arguments.contains(funnyRequiredKeys[2]) ? 1 : 0);
            if (arguments.contains(funnyRequiredKeys[0]) && arguments.contains(funnyRequiredKeys[1]) && arguments.contains(funnyRequiredKeys[2]))
            {
                UpdateText("\nVault unlocked.\ncGVyZmVjdGlvbg\nbGlhcg\nYmVkdGltZSBzb25n");
            }
            else
            {
                UpdateText("\n" + "Invalid keys. Valid keys:" + amountofkeys);
            }
        }));
        CommandList.push(new TerminalCommand("welcometobaldis", LanguageManager.getTerminalString("term_leak_ins"), function(arguments:Array<String>)
        {
            FlxG.switchState(new MathGameState());
        }, false, true));

        add(displayText);

        super.create();
    }

    public function UpdateText(val:String)
    {
        displayText.text = previousText + val;
    }

    public function UpdatePreviousText(reset:Bool)
    {
        previousText = displayText.text + (reset ? "\n> " : "");
        displayText.text = previousText;
        curCommand = "";
        var finalthing:String = "";
        var splits:Array<String> = displayText.text.split("\n");
        if (splits.length <= 23)
        {
            return;
        }
        var split_end:Int = Math.round(Math.max(splits.length - 23,0));
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
            }
            else if (keyJustPressed == FlxKey.SPACE)
            {
                curCommand += " ";
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
        
        var expungedLines:Array<String> = ['TAKING OVER....', 'ATTEMPTING TO HIJACK ADMIN OVERRIDE...', 'THIS REALM IS MINE', "DON'T YOU UNDERSTAND? THIS IS MY WORLD NOW.", "I WIN, YOU LOSE.", "GAME OVER.", "THIS IS IT.", "FUCK YOU!", "I HAVE THE PLOT ARMOR NOW!!", "AHHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAH", "EXPUNGED'S REIGN SHALL START", '[DATA EXPUNGED]'];
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
        expungedTimer = new FlxTimer().start(FlxG.elapsed * 2, function(timer:FlxTimer) //t5 make this get slowed down when eyesores is off
        {
            var lastFakeDisplay = fakeDisplayGroup.members[i - 1];
            var fakeDisplay:FlxText = new FlxText(0, 0, FlxG.width, "> " + expungedLines[new FlxRandom().int(0, expungedLines.length - 1)], 19);
            fakeDisplay.setFormat(Paths.font("PixelOperator-Bold.ttf"), 16);
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