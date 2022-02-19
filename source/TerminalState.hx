import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.*;
import flixel.util.FlxTimer;
import flash.system.System;


class TerminalState extends FlxState
{
    public var curCommand:String = "";
    public var displayText:FlxText;


    override public function create():Void 
    {
        displayText = new FlxText(0, 0, FlxG.width, ">", 32);
        add(displayText);
    }

    override public function update(elapsed:Float):Void
    {
        var keyJustPressed:FlxKey = cast(FlxG.keys.firstJustPressed(), FlxKey);
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
                curCommand += keyJustPressed.toString();
            }
            displayText.text = curCommand;
        }
    

        


    }
}