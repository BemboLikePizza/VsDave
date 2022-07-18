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


class TerminalState extends FlxState
{

    //dont just yoink this code and use it in your own mod. this includes you, psych engine porters.
    //if you ingore this message and use it anyway, atleast give credit.

    public var curCommand:String = "";
    public var previousText:String = "> ";
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
        "zero"
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
        "0"
    ];


    override public function create():Void 
    {
        displayText = new FlxText(0, 0, FlxG.width, previousText, 32);
        FlxG.sound.music.stop();

        CommandList.push(new TerminalCommand("help", "Displays this menu.", function(arguments:Array<String>)
        {
            UpdatePreviousText(false); //resets the text
            var helpText:String = "";
            for (v in CommandList)
            {
                helpText += (v.commandName + " - " + v.commandHelp + "\n");
            }
            UpdateText("\n" + helpText);
        }));

        CommandList.push(new TerminalCommand("test", "Test command, delete this.", function(arguments:Array<String>)
        {
            UpdatePreviousText(false); //resets the text
            UpdateText("\n" + arguments[0]);
        }));

        CommandList.push(new TerminalCommand("characters", "Shows the list of characters.", function(arguments:Array<String>)
        {
            UpdatePreviousText(false); //resets the text
            UpdateText("\ndave.dat\nbambi.dat\ntristan.dat\nexpunged.dat\nexbungo.dat\nrecurser.dat");
        }));
        CommandList.push(new TerminalCommand("admin", "Shows the admin list, use grant to grant rights.", function(arguments:Array<String>)
        {
            if (arguments.length == 0)
            {
                UpdatePreviousText(false); //resets the text
                UpdateText("\n" + Sys.environment()["USERNAME"] + "\nTo add extra users, add the grant parameter and the name.\nNOTE: ADDING CHARACTERS AS ADMINS CAN CAUSE UNEXPECTED CHANGES.");
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
                            PlayState.SONG = Song.loadFromJson("house-hard", "house");
                            PlayState.SONG.validScore = false;
                            LoadingState.loadAndSwitchState(new PlayState());
                        case "exbungo.dat":
                            UpdatePreviousText(false); //resets the text
                            UpdateText("\nLoading...");
                            PlayState.globalFunny = CharacterFunnyEffect.Exbungo;
                            var funny:Array<String> = ["house","insanity","polygonized","five-nights","splitathon","shredder"];
                            var funny2:Array<String> = ["house-hard","insanity-hard","polygonized-hard","five-nights","splitathon","shredder-hard"];
                            var funnylol:Int = FlxG.random.int(0, funny.length - 1);
                            PlayState.SONG = Song.loadFromJson(funny2[funnylol], funny[funnylol]);
                            PlayState.SONG.validScore = false;
                            PlayState.SONG.player2 = "exbungo";
                            LoadingState.loadAndSwitchState(new PlayState());
                        case "bambi.dat":
                            UpdatePreviousText(false); //resets the text
                            UpdateText("\nLoading...");
                            PlayState.globalFunny = CharacterFunnyEffect.Bambi;
                            PlayState.SONG = Song.loadFromJson("shredder-hard", "shredder");
                            PlayState.SONG.validScore = false;
                            LoadingState.loadAndSwitchState(new PlayState());
                        case "expunged.dat":
                            UpdatePreviousText(false); //resets the text
                            UpdateText("\nLoading...");
                            expungedActivated = true;
                            CoolUtil.cacheImage(Paths.image('glitch'));
                            new FlxTimer().start(3, function(timer:FlxTimer)
                            {   
                                expungedReignStarts();
                            });
                    }
                }
            }
        }));
        add(displayText);
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
    }

    override public function update(elapsed:Float):Void
    {

        if (expungedActivated)
        {
            return;
        }
        var keyJustPressed:FlxKey = cast(FlxG.keys.firstJustPressed(), FlxKey);

        if (keyJustPressed == FlxKey.ENTER)
        {
            var arguments:Array<String> = curCommand.split(" ");
            for (v in CommandList)
            {
                if (v.commandName == arguments[0]) //argument 0 should be the actual command at the moment
                {
                    arguments.shift();
                    v.FuncToCall(arguments);
                    break;
                }
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
    }

    function expungedReignStarts()
    {
        var amountofText:Int = Std.int(FlxG.height / displayText.height) + 100;

        for (i in 0...amountofText)
        {
            new FlxTimer().start(1, function(timer:FlxTimer)
            {
                var expungedLines:Array<String> = ['TAKING OVER....', 'HIJACKING SYSTEM....', "EXPUNGED'S REIGN SHALL START"];
                var fakeDisplay:FlxText = new FlxText(0, i * (displayText.height), FlxG.width, "> " + expungedLines[new FlxRandom().int(0, expungedLines.length - 1)], 19);
                add(fakeDisplay);
                FlxG.camera.follow(fakeDisplay, 1);
            });
        }

        var glitch = new BGSprite('glitch', 0, 0, 'ui/glitch/glitch3', [
            new Animation('glitchScreen', 'glitch 3', 15, true, [false, false])
        ], 0, 0, true, true);
        glitch.setGraphicSize(FlxG.width, FlxG.height);
        glitch.updateHitbox();
		glitch.screenCenter();
		glitch.animation.play('glitchScreen');
		add(glitch);
        
        FlxG.sound.music.stop();
        FlxG.sound.play(Paths.sound("expungedGrantedAccess", "preload"), function()
        {
            FlxTween.tween(glitch, {alpha: 0}, 5);
			FlxG.sound.play(Paths.sound('iTrollYou', 'shared'), function()
			{
				new FlxTimer().start(1, function(timer:FlxTimer)
				{
					FlxG.save.data.exploitationState = 'awaiting';
					FlxG.save.data.exploitationFound = true;
					FlxG.save.flush();

					var programPath:String = Sys.programPath();
					var textPath = programPath.substr(0, programPath.length - CoolSystemStuff.executableFileName().length) + "help me.txt";
                    
					File.saveContent(textPath, "you don't know what you're getting yourself into\n don't open the application for your own risk");
					System.exit(0);
				});
			});
        });
    }
}


class TerminalCommand
{
    public var commandName:String = "undefined";
    public var commandHelp:String = "if you see this you are very homosexual and dumb.";
    public var FuncToCall:Dynamic;

    public function new(name:String, help:String, func:Dynamic)
    {
        commandName = name;
        commandHelp = help;
        FuncToCall = func;
    }

}