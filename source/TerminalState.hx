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
}