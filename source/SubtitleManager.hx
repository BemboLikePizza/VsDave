package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;

class SubtitleManager extends FlxTypedGroup<Subtitle>
{
   public function addSubtitle(text:String, ?typeSpeed:Float, showTime:Float)
   {
		var subtitle = new Subtitle(text, typeSpeed, showTime);
		subtitle.x = (FlxG.width - subtitle.width) / 2;
		subtitle.y = ((FlxG.height - subtitle.height) / 2) - 200;
		add(subtitle);
   }
}