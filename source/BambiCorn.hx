package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class BambiCorn extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        makeGraphic(16, 16, FlxColor.YELLOW);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}