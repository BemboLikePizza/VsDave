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
    public var previousText:String = "Vs Dave Developer Console[Version 1.0.00001.1234]\nAll Rights Reserved.\n> ";
    public var displayText:FlxText;
    var expungedActivated:Bool = false;
    public var CommandList:Array<TerminalCommand> = new Array<TerminalCommand>();

    // cuzsie was too lazy to finish this lol.
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
        "rbracket"
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
        "]"
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

        CommandList.push(new TerminalCommand("help", "Displays this menu.", function(arguments:Array<String>)
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

        CommandList.push(new TerminalCommand("characters", "Shows the list of characters.", function(arguments:Array<String>)
        {
            UpdatePreviousText(false); //resets the text
            UpdateText("\ndave.dat\nbambi.dat\ntristan.dat\nexpunged.dat\nexbungo.dat\nrecurser.dat\nmoldy.dat");
        }));
        CommandList.push(new TerminalCommand("admin", "Shows the admin list, use grant to grant rights.", function(arguments:Array<String>)
        {
            if (arguments.length == 0)
            {
                UpdatePreviousText(false); //resets the text
                UpdateText("\n" + (!FlxG.save.data.selfAwareness ? CoolSystemStuff.getUsername() : 'User354378')
                 + "\nTo add extra users, add the grant parameter and the name.\n(Example: admin grant expungo.dat)\nNOTE: ADDING CHARACTERS AS ADMINS CAN CAUSE UNEXPECTED CHANGES.");
                return;
            }
            else if (arguments.length != 2)
            {
                UpdatePreviousText(false); //resets the text
                UpdateText("\nNo version of the \"admin\" command takes " + arguments.length + " parameter(s).");
            }
            else
            {
                if (arguments[0] == "grant")
                {
                    switch (arguments[1])
                    {
                        default:
                            UpdatePreviousText(false); //resets the text
                            UpdateText("\n" + arguments[1] + " is not a valid user or character.");
                        case "dave.dat":
                            UpdatePreviousText(false); //resets the text
                            UpdateText("\nLoading...");
                            PlayState.globalFunny = CharacterFunnyEffect.Dave;
                            PlayState.SONG = Song.loadFromJson("house");
                            PlayState.SONG.validScore = false;
                            Main.fps.visible = !FlxG.save.data.disableFps;
                            LoadingState.loadAndSwitchState(new PlayState());
                        case "tristan.dat":
                            UpdatePreviousText(false); //resets the text
                            UpdateText("\nLoading...");
                            PlayState.globalFunny = CharacterFunnyEffect.Tristan;
                            PlayState.SONG = Song.loadFromJson("house");
                            PlayState.SONG.validScore = false;
                            Main.fps.visible = !FlxG.save.data.disableFps;
                            LoadingState.loadAndSwitchState(new PlayState());
                        case "exbungo.dat":
                            UpdatePreviousText(false); //resets the text
                            UpdateText("\nLoading...");
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
                            UpdateText("\nLoading...");
                            PlayState.globalFunny = CharacterFunnyEffect.Bambi;
                            PlayState.SONG = Song.loadFromJson('shredder');
                            PlayState.SONG.validScore = false;
                            LoadingState.loadAndSwitchState(new PlayState());
                        case "expunged.dat":
                            UpdatePreviousText(false); //resets the text
                            UpdateText("\nLoading...");
                            expungedActivated = true;
                            new FlxTimer().start(3, function(timer:FlxTimer)
                            {   
                                expungedReignStarts();
                            });
                        case "moldy.dat":
                            UpdatePreviousText(false); //resets the text
                            UpdateText("\nyou know what? im gonna close the game so you can watch my baldi's basics playthrough...");
                            new FlxTimer().start(2, function(timer:FlxTimer)
                            {   
                                fancyOpenURL("https://www.youtube.com/watch?v=azMGySH8fK8");
                                System.exit(0);
                            });
                    }
                }
            }
        }));
        CommandList.push(new TerminalCommand("clear", "Clears the screen.", function(arguments:Array<String>)
        {
            previousText = "> ";
            UpdateText("");
        }));
        CommandList.push(new TerminalCommand("secret mod leak", "No providing such leaks", function(arguments:Array<String>)
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
                UpdateText("\nUnknown command \"" + arguments[0] + "\"");
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
        add(glitch);

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
        expungedTimer = new FlxTimer().start(FlxG.elapsed * 2, function(timer:FlxTimer)
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