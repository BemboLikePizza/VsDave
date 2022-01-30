package;

import openfl.events.SampleDataEvent;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import openfl.ui.Keyboard;
import flixel.util.FlxCollision;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class BGSprite extends FlxSprite
{
	public var name:String;
	public function new(name:String, posX:Float, posY:Float, path:String = '', animations:Array<Animation>, scrollX:Float = 1, scrollY:Float = 1, antialiasing:Bool = true, active:Bool = false)
	{
		super(posX, posY);
		
		this.name = name;
		var hasAnimations:Bool = !(animations == null);

		if (hasAnimations)
		{
			frames = Paths.getSparrowAtlas(path);
			for (anim in animations)
			{
				animation.addByPrefix(anim.name, anim.prefixName, anim.frames, anim.looped, anim.flip[0], anim.flip[1]);
			}
		}
		else
		{
			loadGraphic(path);
		}
		this.antialiasing = antialiasing;
		scrollFactor.set(scrollX, scrollY);
		this.active = active;

	}
}
