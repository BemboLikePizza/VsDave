package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.util.FlxColor;
import openfl.Lib;

#if windows
import sys.io.File;
import sys.io.Process;
import lime.app.Application;
#end

using StringTools;

class WindowShitTesting extends MusicBeatState
{
	override public function create()
	{
        Application.current.window.borderless = true;
        FlxG.camera.color = 0x0000ffff;
        Lib.current.stage.color = 0x0000ffff;

        trace(Application.current.window.borderless + "\n" + FlxG.camera.color + "\n" + Lib.current.stage.color + "\n" + Application.current.window.stage.color);
        super.create();
    }
}