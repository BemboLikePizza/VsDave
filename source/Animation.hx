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

class Animation
{
	public var name:String;
	public var prefixName:String;
   public var frames:Int;
   public var looped:Bool;
   public var flip:Array<Bool>;

	public function create(name:String, prefixName:String, frames:Int, looped:Bool, flip:Array<Bool>)
	{
      if (flip == null) 
      {
         flip = new Array<Bool>();
         flip = [false, false];
      }
      this.name = name;
      this.prefixName = prefixName;
      this.frames = frames;
      this.looped = looped;
	}
}
