package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

#if sys
import openfl.Lib;
#end

class ExpungedCrasherState extends MusicBeatState
{
	override function create()
	{
        FlxG.sound.music.stop();
		super.create();

		FlxG.sound.play(Paths.sound('bigFuckingReverbDeath', 'shared'));

        new FlxTimer().start(5.5, function(timer:FlxTimer)
        {
            FlxG.sound.play(Paths.sound('ex_CRASH', 'shared'));

            new FlxTimer().start(0.3, function(timer:FlxTimer)
            {
                Crasher.freezeGame();
            });
        });
	}
}

class Crasher
{
    public static function freezeGame()
    {
        // lmaoo crashing your game with a while statement easy (its basically an infinite loop)
        while(Lib.application.window.width > 5)
        {
            Lib.application.window.resize(Lib.application.window.width, Lib.application.window.height);
        }
    }
}
