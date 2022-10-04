import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flash.system.System;


class FunnyTextState extends FlxState
{

    public var elapsedTime:Float = 0;
    public var DisplayText:FlxText;


    override public function create():Void 
    {
        FlxG.sound.music.stop();
        DisplayText = new FlxText(0, FlxG.height / 2, FlxG.width, "Well. It was worth a shot.", 32);
        DisplayText.setFormat(Paths.font("PixelOperator-Bold.ttf"), 54, FlxColor.WHITE, FlxTextAlign.CENTER);
        add(DisplayText);
    }

    override public function update(elapsed:Float):Void
    {
        elapsedTime += elapsed;
        DisplayText.x = (Math.sin(elapsedTime / 2) * 60);
        DisplayText.y = (FlxG.height / 2) + (Math.sin(elapsedTime / 3) * 100);
        super.update(elapsed);
    }
}