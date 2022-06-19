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


class TerminalState extends FlxState
{
    public var curCommand:String = "";
    public var displayText:FlxText;

    // IM LAZY TO DO THE RESTY ARFASLAJHLKSDKSD
    var unformattedSymbols:Array<String> =
    [
        "PERIOD",
        "BACKSLASH",
        "ONE",
        "TWO",
        "THREE",
        "FOUR",
        "FIVE",
        "SIX",
        "SEVEN",
        "EIGHT",
        "NINE",
        "ZERO",
        "PLUS",
        "COMMA",
        "QUESTION",
        "HASHTAG"
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
        "+",
        ",",
        "?",
        "#"
    ];

    var badKeys:Array<FlxKey> = [FlxKey.ESCAPE, FlxKey.ALT, FlxKey.CONTROL, FlxKey.SHIFT, FlxKey.ENTER, FlxKey.PLUS, FlxKey.MINUS];

    var bkspcDelay:Float = 0;
    var expungedActivated:Bool;

    override public function create():Void 
    {
        FlxG.sound.music.volume = 0.01;

        displayText = new FlxText(0, 0, FlxG.width, ">", 19);
        add(displayText);
    }

    override public function update(elapsed:Float):Void
    {
        if(bkspcDelay > 0)
            bkspcDelay - 0.01;

        if (FlxG.keys.justPressed.ESCAPE && !expungedActivated)
        {
            FlxG.switchState(new MainMenuState());
        }

        var keyJustPressed:FlxKey = cast(FlxG.keys.firstJustPressed(), FlxKey);
        var keyToShow:String;
        var badCheck:Bool = true;

        for(bad in badKeys)
        {
            if (keyJustPressed == bad)
            {
                badCheck = false;
            }
        }

        if (keyJustPressed != FlxKey.NONE && keyJustPressed != FlxKey.ENTER && badCheck)
        {
            if (keyJustPressed == FlxKey.BACKSPACE)
            {
                curCommand = curCommand.substr(0,curCommand.length - 1);
                FlxG.sound.play(Paths.sound("terminal_bkspc", "preload"));

                bkspcDelay = 1;
            }
            else if (keyJustPressed == FlxKey.SPACE)
            {
                curCommand += " ";
                FlxG.sound.play(Paths.sound("terminal_space", "preload"));
            }
            else
            {   
                keyToShow = keyJustPressed.toString();

                for (i in 0...unformattedSymbols.length)
                {
                    if (keyJustPressed.toString() == unformattedSymbols[i])
                    {
                        keyToShow = formattedSymbols[i];
                        break;
                    }
                }

                curCommand += keyToShow.toLowerCase();
                FlxG.sound.play(Paths.sound("terminal_key", "preload"));
            }
            displayText.text = ">" + curCommand + "|";
        }
        
        else if (keyJustPressed == FlxKey.ENTER)
        {
            if (curCommand == "administrator grant expunged.exe")
            {
                displayText.text += "\nLoading...";
                expungedActivated = true;
                CoolUtil.cacheImage(Paths.image('glitch'));
				new FlxTimer().start(3, function(timer:FlxTimer)
				{   
                    expungedReignStarts();
				});
            }
            else if (StringTools.startsWith(curCommand, "administrator grant"))
            {
                displayText.text += "\nThat process was not found. Please provide a valid process and try again.\n";
            }
        }

        else if (FlxG.keys.pressed.BACKSPACE)
        {   
            if(bkspcDelay < 0.04)
            {
                curCommand = curCommand.substr(0,curCommand.length - 1);
                FlxG.sound.play(Paths.sound("terminal_bkspc", "preload"));
            }
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

        var glitch = new BGSprite('glitch', 0, 0, Paths.image('glitch3', 'shared'), [
            new Animation('glitchScreen', 'glitch 3', 15, true, [false, false])
        ], 0, 0, true);
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