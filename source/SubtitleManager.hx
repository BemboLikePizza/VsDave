package;

import flixel.group.FlxGroup.FlxTypedGroup;
import Subtitle.SubtitleProperties;

class SubtitleManager extends FlxTypedGroup<Subtitle>
{
   public function addSubtitle(text:String, ?typeSpeed:Float, showTime:Float, ?properties:SubtitleProperties, ?onComplete:Void->Void)
   {
		var subtitle = new Subtitle(text, typeSpeed, showTime, properties, onComplete);

		subtitle.manager = this;
		add(subtitle);
	}
	public function onSubtitleComplete(subtitle:Subtitle)
	{
		remove(subtitle);
	}
}
