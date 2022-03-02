package;

import flixel.input.actions.FlxActionInput;
import flixel.addons.display.FlxShaderMaskCamera;
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

	var camFollow:FlxObject;
	var curControlSelected:Int = 0;
	var controlItems:Array<FlxText> = new Array<FlxText>();
	var curControl:FlxText;

	public var uiControls:Array<ControlUI> = 
	[
		new ControlUI('LEFT', 'left'),
		new ControlUI('DOWN', 'down'),
		new ControlUI('UP', 'up'),
		new ControlUI('RIGHT', 'right'),
		new ControlUI('RESET', 'reset'),
		new ControlUI('ACCEPT', 'accept'),
		new ControlUI('BACK', 'back'),
		new ControlUI('PAUSE', 'pause'),
		new ControlUI('CHEAT', 'cheat')
	];
	var controlKeybindGroup:Array<TextGroup> = new Array<TextGroup>();
	var currentKeybindGroup:TextGroup;
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
		add(tutorial);

		var arrowOffset:Float = 100;
		
		var choosePreset:FlxText = new FlxText(0, 125, FlxG.width / 2, "Keybind Presets:", 32);
		choosePreset.screenCenter(X);
		choosePreset.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		choosePreset.borderSize = 2;
		add(choosePreset);

		var preset:FlxText = new FlxText(0, choosePreset.y + 75, FlxG.width / 2, "DFJK", 32);
		preset.screenCenter(X);
		preset.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		preset.borderSize = 2;
		add(preset);
		controlItems.push(preset);

		var presetLeft:FlxText = new FlxText(preset.x - arrowOffset, preset.y, FlxG.width / 2, "<", 32);
		presetLeft.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
		presetLeft.borderSize = 1;
		add(presetLeft);

		var presetRight:FlxText = new FlxText(preset.x + arrowOffset, preset.y, FlxG.width / 2, ">", 32);
		presetRight.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
		presetRight.borderSize = 1;
		add(presetRight);

		for (i in 0...uiControls.length)
		{
			var uiControl = uiControls[i];
			var uiControlAction = getAction(uiControl.controlName);
			var uiControlInputs = getActionInputs(uiControlAction);

			trace(uiControlInputs.length);

			var keybindTexts:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

			var control:FlxText = new FlxText((FlxG.width / 2) - 200, (preset.y + 75) + (i * 100), 0, uiControl.uiName + ":", 32);
			control.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			control.borderSize = 2;
			control.antialiasing = true;
			add(control);

			controlItems.push(control);

			for (j in 0...uiControlInputs.length)
			{
				var input = uiControlInputs[j];
				
				var inputKey:FlxKey = cast(input.inputID, FlxKey);

				var keybind:FlxText = new FlxText(control.x, control.y, 0, inputKey.toString(), 32);
				switch (j)
				{
					case 0:
						keybind.x = (FlxG.width / 2) + (j * 50);
					default:
						keybind.x = (FlxG.width / 2) + (j * 50) + keybindTexts.members[j - 1].width;
				}
				keybind.y = control.y;
				keybind.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				keybind.borderSize = 2;
				keybind.antialiasing = true;
				add(keybind);

				keybindTexts.add(keybind);
			}
			var keybindGroup = new TextGroup(keybindTexts);

			controlKeybindGroup.push(keybindGroup);
		}

		for (action in controls.digitalActions)
		{
			trace(action.name);
		}

		camFollow = new FlxObject(FlxG.width / 2, controlItems[curControlSelected].y);
		FlxG.camera.follow(camFollow, 0.2);
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
		camFollow.y = controlItems[curControlSelected].y;
		currentKeybindGroup = controlKeybindGroup[curControlSelected];
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
	function getAction(actionName:String):FlxActionDigital
	{
		for (action in controls.digitalActions)
		{
			if (action.name == actionName)
			{
				return action;
			}
		}
		return null;
	}
	function getActionInputs(action:FlxActionDigital):Array<FlxActionInput>
	{
		var actionInputs:Array<FlxActionInput> = new Array<FlxActionInput>();
		if (action != null)
		{
			for (input in action.inputs)
			{
				actionInputs.push(input);
			}
		}
		return actionInputs;
	}
}
enum KeybindState
{
	SelectControl; SelectKeybind; ChangeKeybind;
}
class TextGroup
{
	public var texts:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();
	
	public function new(texts:FlxTypedGroup<FlxText>)
	{
		this.texts = texts;
	}
}
class ControlUI
{
	public var uiName:String;
	public var controlName:String;

	public function new(uiName:String, controlName:String)
	{
		this.uiName = uiName;
		this.controlName = controlName;
	}
}