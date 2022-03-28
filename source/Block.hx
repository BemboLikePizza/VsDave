package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

using StringTools;

class Block extends FlxExtendedSprite
{
    var blockReg:Array<Dynamic> =
    [
        ["air", FlxColor.TRANSPARENT],
        ["tree", FlxColor.GREEN],
        ["cornstalk", FlxColor.GREEN],
    ];

	public function new(x:Float, y:Float, block:Int)
	{
		super(x, y);
        
        var targetColor:FlxColor = blockReg[block][1];

        makeGraphic(25, 14, targetColor);
        this.x = x;
        this.y = y;

        enableMouseSnap(25, 14, false, false);
	}
}
