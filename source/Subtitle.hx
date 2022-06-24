package;

import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.text.FlxText;

class Subtitle extends FlxTypeText
{
   public function new(text:String, ?typeSpeed, showTime:Float)
   {
      super(FlxG.width / 2, (FlxG.height / 2) + 100, 0, text, 32);
      sounds = null;
	  
      setFormat("Comic Sans MS Bold", 48, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
      antialiasing = true;
      borderSize = 2;

      start(typeSpeed, false, false, [], function()
      {
         new FlxTimer().start(showTime, function(timer:FlxTimer)
         {
            FlxTween.tween(this, {alpha: 0}, 1);
         });
      });
   }
}