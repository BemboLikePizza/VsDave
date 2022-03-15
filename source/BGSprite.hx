package;
import flixel.FlxSprite;

using StringTools;

class BGSprite extends FlxSprite
{
	public var spriteName:String;
	public function new(spriteName:String, posX:Float, posY:Float, path:String = '', animations:Array<Animation>, scrollX:Float = 1, scrollY:Float = 1, antialiasing:Bool = true, active:Bool = false)
	{
		super(posX, posY);
		
		this.spriteName = spriteName;
		var hasAnimations:Bool = !(animations == null);

		if (path != '')
		{
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
		}
		this.antialiasing = antialiasing;
		scrollFactor.set(scrollX, scrollY);
		this.active = active;
	}
}