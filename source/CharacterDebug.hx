package;

import flixel.math.FlxPoint;
import flixel.ui.FlxButton;
import openfl.net.FileReference;
import openfl.display.TriangleCulling;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
/**
	*DEBUG MODE
 */
class CharacterDebug extends MusicBeatState
{
	var bf:Boyfriend;
	var dad:Character;
	var char:Character;
	var dadChar:String;
	var camFollow:FlxObject;

	var offsetText:FlxText;

	public function new(dadChar:String)
	{
		this.dadChar = dadChar; 
		super();
	}

	override function create()
	{
		FlxG.sound.music.stop();

		FlxG.mouse.visible = true;

		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);
		
		bf = new Boyfriend(0, 0);
		bf.screenCenter();
		bf.debugMode = true;
		bf.alpha = 0.3;
		bf.flipX = true;
		add(bf);

		dad = new Character(bf.x, bf.y, dadChar);
		dad.screenCenter();
		dad.debugMode = true;
		dad.flipX = false;
		add(dad);
		
		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		offsetText = new FlxText(-FlxG.width + 200, FlxG.height - 300, FlxG.width, 'Meee', 32);
		offsetText.screenCenter();
		offsetText.setFormat('Comic Sans MS Bold', 32, FlxColor.BLUE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
		add(offsetText);

		updateText();

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new MainMenuState());
		}
		if (FlxG.keys.justPressed.E)
			FlxG.camera.zoom += 0.25;
		if (FlxG.keys.justPressed.Q)
			FlxG.camera.zoom -= 0.25;

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
		{
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -90;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = 90;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -90;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = 90;
			else
				camFollow.velocity.x = 0;
		}
		else
		{
			camFollow.velocity.set();
		}
		if (FlxG.keys.pressed.LEFT)
		{
			dad.x -= 100 * elapsed;
			updateText();
		}
		if (FlxG.keys.pressed.RIGHT)
		{
			dad.x += 100 * elapsed;
			updateText();
		}
		if (FlxG.keys.pressed.DOWN)
		{
			dad.y += 100 * elapsed;
			updateText();
		}
		if (FlxG.keys.pressed.UP)
		{
			dad.y -= 100 * elapsed;
			updateText();
		}
		super.update(elapsed);
	}
	function updateText()
	{
		var dadScreenCenter = new FlxPoint((FlxG.width - dad.width) / 2, (FlxG.height - dad.height) / 2);
		offsetText.text = "Dad position: ${dad.getPosition()}\n Dad offset position from it's center position: " + new FlxPoint(dadScreenCenter.x - dad.getPosition().x, dadScreenCenter.y - dad.getPosition().y);
	}
}
