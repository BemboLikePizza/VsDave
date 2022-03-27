package;

import flixel.FlxSprite;
import flixel.text.FlxText;

using StringTools;

class AttachedText extends FlxText
{
	public var sprTracker:FlxSprite;
	public var xAdd:Float = 0;
	public var yAdd:Float = 0;
	public var alphaMultiplier:Float = 1;
	public var copyAlpha:Bool = true;
	public var copyVisible:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null) {
			setPosition(sprTracker.x + xAdd, sprTracker.y + yAdd);
			scrollFactor.set(sprTracker.scrollFactor.x, sprTracker.scrollFactor.y);
			if(copyAlpha)
			{
				alpha = sprTracker.alpha * alphaMultiplier;
			}
			if(copyVisible)
			{
				visible = sprTracker.visible;
			}
		}
	}
}

