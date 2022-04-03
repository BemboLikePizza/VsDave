package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = null;
		if (FlxG.save.data.begin_thing)
		{
			txt = new FlxText(0, 0, FlxG.width, LanguageManager.getTextString('introWarningSeen'), 32);
		}
		else
		{
			txt = new FlxText(0, 0, FlxG.width, LanguageManager.getTextString('introWarningFirstPlay'), 32);
		}
		txt.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		txt.antialiasing = true;
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.PAUSE && FlxG.save.data.begin_thing == true)
		{
			leaveState();
		}
		if (FlxG.keys.justPressed.Y && FlxG.save.data.begin_thing != true || FlxG.keys.justPressed.ENTER && FlxG.save.data.begin_thing != true)
		{
			FlxG.save.data.begin_thing = true;
			FlxG.save.data.eyesores = true;
			leaveState();
		}
		if (FlxG.keys.justPressed.N && FlxG.save.data.begin_thing != true || FlxG.keys.justPressed.ENTER && FlxG.save.data.begin_thing != true)
		{
			FlxG.save.data.begin_thing = true;
			FlxG.save.data.eyesores = false;
			leaveState();	
		}
		super.update(elapsed);
	}
	function leaveState()
	{
		leftState = true;
		FlxG.switchState(new MainMenuState());
	}
}
