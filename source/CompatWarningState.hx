package;

import flixel.math.FlxMath;
import flixel.tweens.misc.ColorTween;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.effects.FlxFlicker;
import flixel.util.FlxSave;

class CompatWarningState extends MusicBeatState
{
    var bg:FlxBackdrop;
    var warningBox:FlxText;
    var textItems:Array<FlxText> = new Array<FlxText>();
    var optionArray:Array<Int> = [1, 0]; //Yes, No
    var optionTranslate:Array<String> = [LanguageManager.getTextString("compat_yes"), LanguageManager.getTextString("compat_no")];
    var accepted:Bool;

    public override function create():Void
    {
        bg = new FlxBackdrop(Paths.image('ui/checkeredBG', 'preload'), 1, 1, true, true, 1, 1);
        bg.antialiasing = true;
        add(bg);

        warningBox = new FlxText(0, (FlxG.height / 2) - 300, FlxG.width, LanguageManager.getTextString("compat_warning"), 45);
        warningBox.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        warningBox.antialiasing = true;
        warningBox.borderSize = 2;
        warningBox.screenCenter(X);
        add(warningBox);

        for(i in 0...optionArray.length)
        {
            var optionText:FlxText = new FlxText(i * 75, FlxG.height / 2 - 150, FlxG.width, optionTranslate[i], 25);
            optionText.screenCenter(X);
            optionText.setFormat("Comic Sans MS Bold", 25, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            optionText.antialiasing = true;
            optionText.borderSize = 2;

            textItems.push(optionText);
            add(optionText);
        }
    }

}