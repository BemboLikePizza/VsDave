package;

import flixel.input.actions.FlxActionInputDigital.FlxActionInputDigitalMouseWheel;
import haxe.macro.Context;
import haxe.Json;
import flixel.effects.FlxFlicker;
import flixel.input.keyboard.FlxKeyList;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.FlxCamera;
import flixel.input.actions.FlxAction.FlxActionDigital;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.math.FlxMath;

/*
ello again!! another reminder to not use my coding without my permission/without checking in with me :))
-vs dave dev T5mpler
*/
class ChangeKeybinds extends MusicBeatState
{
	var bg:FlxSprite = new FlxSprite();

	var curControlSelected:Int = 0;
	var controlItems:Array<FlxText> = new Array<FlxText>();
	var curControl:FlxText;
	
	var state:KeybindState = KeybindState.SelectControl;

	public override function create()
	{
		bg.color = 0xFFea71fd;
		bg.loadGraphic(MainMenuState.randomizeBG());
      bg.scrollFactor.set();
		add(bg);
		
		var tutorial:FlxText = new FlxText(0, 50, FlxG.width / 2, "Select a control & then a keybind", 32);
		tutorial.screenCenter(X);
		tutorial.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		tutorial.borderSize = 3;
		tutorial.scrollFactor.set();
		add(tutorial);

		var arrowOffset:Float = 100;
		
		var choosePreset:FlxText = new FlxText(0, FlxG.height - 150, FlxG.width / 2, "Keybind Presets:", 32);
		choosePreset.screenCenter(X);
		choosePreset.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		choosePreset.borderSize = 2;
		choosePreset.scrollFactor.set();
		add(choosePreset);

		var preset:FlxText = new FlxText(0, choosePreset.y + 75, FlxG.width / 2, "DFJK", 32);
		preset.screenCenter(X);
		preset.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		preset.borderSize = 2;
		preset.scrollFactor.set();
		add(preset);

		var presetLeft:FlxText = new FlxText(preset.x - arrowOffset, preset.y, FlxG.width / 2, "<", 32);
		presetLeft.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
		presetLeft.scrollFactor.set();
		presetLeft.borderSize = 1;
		add(presetLeft);

		var presetRight:FlxText = new FlxText(preset.x + arrowOffset, preset.y, FlxG.width / 2, ">", 32);
		presetRight.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
		presetRight.scrollFactor.set();
		presetRight.borderSize = 1;
		add(presetRight);

		for (i in 0...6)
		{
			var keybind:FlxText = new FlxText(0, ((FlxG.height / 2) - 400) + (i * 100), 0, "Test Keybind " + i, 32);
			keybind.screenCenter(X);
			keybind.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			keybind.borderSize = 2;
			add(keybind);

			controlItems.push(keybind);
		}
		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		var up = controls.UP_P;
		var down = controls.DOWN_P;
		var back = controls.BACK;

		switch (state)
		{
			case SelectControl:
				if (up)
				{
					changeSelection(-1);
				}
				if (down)
				{
					changeSelection(1);
				}
			case SelectKeybind:
			
			case ChangeKeybind:
		}
		
		if (back)
		{
			FlxG.switchState(new OptionsMenu());
		}
	}
	function changeSelection(amount:Int = 0)
	{
		curControlSelected += amount;
		if (curControlSelected > controlItems.length - 1)
		{
			curControlSelected = 0;
		}
		if (curControlSelected < 0)
		{
			curControlSelected = controlItems.length - 1;
		}
		curControl = controlItems[curControlSelected];
		FlxG.camera.follow(curControl, 0.1);

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		for (item in controlItems)
		{
			if (item == curControl)
			{
				updateText(item, true);
			}
			else
			{
				updateText(item, false);
			}
		}
	}

	function updateText(text:FlxText, selected:Bool)
	{
		if (selected)
		{
			text.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			text.borderSize = 2;
		}
		else
		{
			text.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
		}
	}
}
enum KeybindState
{
	SelectControl; SelectKeybind; ChangeKeybind;
}