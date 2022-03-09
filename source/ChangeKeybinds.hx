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

	public static var uiControls:Array<ControlUI> = 
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
	var currentUIControl:ControlUI;

	var controlKeybindGroup:Array<TextGroup> = new Array<TextGroup>();
	var currentKeybindGroup:TextGroup;

	var curKeybindSelected:Int = 0;
	var currentKeybind:FlxText;

	var keybindPresets:Array<String> = ['Arrow Keys', 'WASD', 'DFJK', 'ASKL', 'ZX,.'];

	var choosePreset:FlxText;
	var preset:FlxText;
	var presetLeft:FlxText;
	var presetRight:FlxText;
	var curSelectedPreset:Int = 0;
	var curPreset:String;

	var state:KeybindState = KeybindState.SelectControl;

	public override function create()
	{
		if (FlxG.save.data.keybinds == null)
		{
			controls.setKeyboardScheme(Solo);
			saveControls(controls);
		}
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
		var keybindPresetGroup:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();
		
		choosePreset = new FlxText(0, 125, FlxG.width / 2, "Keybind Presets:", 32);
		choosePreset.screenCenter(X);
		choosePreset.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		choosePreset.borderSize = 2;
		keybindPresetGroup.add(choosePreset);
		add(choosePreset);

		preset = new FlxText(0, choosePreset.y + 75, FlxG.width / 2, "DFJK", 32);
		preset.screenCenter(X);
		preset.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		preset.borderSize = 2;
		add(preset);
		keybindPresetGroup.add(preset);
		controlItems.push(preset);

		presetLeft = new FlxText(preset.x - arrowOffset, preset.y, FlxG.width / 2, "<", 32);
		presetLeft.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
		presetLeft.borderSize = 1;
		keybindPresetGroup.add(presetLeft);
		add(presetLeft);

		presetRight = new FlxText(preset.x + arrowOffset, preset.y, FlxG.width / 2, ">", 32);
		presetRight.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
		presetRight.borderSize = 1;
		keybindPresetGroup.add(presetRight);
		add(presetRight);
		
		var presetGroup:TextGroup = new TextGroup('presetGroup', keybindPresetGroup);
		controlKeybindGroup.push(presetGroup);

		for (i in 0...uiControls.length)
		{
			var uiControl = uiControls[i];
			var uiControlAction = getAction(controls, uiControl.controlName);
			var uiControlInputs = getActionInputs(uiControlAction);

			var keybindTexts:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

			var control:FlxText = new FlxText((FlxG.width / 2) - 200, (preset.y + 75) + (i * 100), 0, uiControl.uiName + ":", 32);
			control.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
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
				keybind.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
				keybind.borderSize = 2;
				keybind.antialiasing = true;
				add(keybind);

				keybindTexts.add(keybind);
			}
			var keybindGroup = new TextGroup('keybindGroup', keybindTexts);

			controlKeybindGroup.push(keybindGroup);
		}
		currentKeybindGroup = controlKeybindGroup[curControlSelected];

		camFollow = new FlxObject(FlxG.width / 2, controlItems[curControlSelected].y);
		FlxG.camera.follow(camFollow, 0.2);
		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		var left = controls.LEFT_P;
		var down = controls.DOWN_P;
		var up = controls.UP_P;
		var right = controls.RIGHT_P;
		var back = controls.BACK;
		var accept = controls.ACCEPT;

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
				if (accept)
				{
					switch (controlKeybindGroup[curControlSelected].groupName)
					{
						case 'presetGroup':
							changePreset();
						case 'keybindGroup':
							state = KeybindState.SelectKeybind;
							FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
							changeKeybindSelection();
					}
				}
				if (controlKeybindGroup[curControlSelected].groupName == 'presetGroup')
				{
					if (controls.RIGHT)
					{
						updateText(presetRight, true);
					}
					if (controls.RIGHT_R)
					{
						updateText(presetRight, false);
					}
					if (controls.LEFT)
					{
						updateText(presetLeft, true);
					}
					if (controls.LEFT_R)
					{
						updateText(presetLeft, false);
					}
					if (left)
					{
						changePresetSelection(-1);
					}
					if (right)
					{
						changePresetSelection(1);
					}
				}
				
			case SelectKeybind:
				if (left)
				{
					changeKeybindSelection(-1);
				}
				if (right)
				{
					changeKeybindSelection(1);
				}
				if (accept)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					state = KeybindState.ChangeKeybind;
				}
			case ChangeKeybind:
				currentKeybind.text = "_";

				var keyID = FlxG.keys.firstJustPressed();

				if (keyID != -1)
				{
					var keyJustPressed = cast(keyID, FlxKey);
					var controlAction = getAction(controls, currentUIControl.controlName);
					var actionKeys = actionToFlxKeys(controlAction);

					controls.unbindKeys(controls.stringControlToControl(currentUIControl.controlName), actionKeys);
					actionKeys[curKeybindSelected] = keyJustPressed;
					controls.bindKeys(controls.stringControlToControl(currentUIControl.controlName), actionKeys);
					
					FlxG.sound.play(Paths.sound('confirmMenu'));

					currentKeybind.text = keyJustPressed.toString();

					updateText(currentKeybind, false);

					state = KeybindState.SelectControl;
				}
		}
		
		if (back)
		{
			switch (state)
			{
				case SelectControl:
					saveControls(controls);
					FlxG.switchState(new OptionsMenu());
				case SelectKeybind:
					updateText(currentKeybind, false);
					state = SelectControl;
				case KeybindState.ChangeKeybind:

			}
			
		}
	}
	public static function saveControls(controls:Controls)
	{
		var keysToSave:Array<Array<FlxKey>> = new Array<Array<FlxKey>>();

		for (action in controls.digitalActions)
		{
			var keybindings:Array<FlxKey> = new Array<FlxKey>();

			for (input in action.inputs)
			{
				keybindings.push(cast(input.inputID, FlxKey));
			}
			keysToSave.push(keybindings);
		}
		FlxG.save.data.keybinds = keysToSave;
		FlxG.save.flush();
	}
	public static function loadControls(controls:Controls)
	{
		var loadedKeys:Array<Array<FlxKey>> = FlxG.save.data.keybinds;

		if (loadedKeys != null)
		{
			for (i in 0...controls.digitalActions.length)
			{
				var action = controls.digitalActions[i];

				controls.unbindKeys(controls.stringControlToControl(action.name), actionToFlxKeys(action));
				controls.bindKeys(controls.stringControlToControl(action.name), loadedKeys[i]);
			}
		}
	}
	function changeSelection(amount:Int = 0)
	{
		curControlSelected += amount;
		if (amount != 0)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
		if (curControlSelected > controlItems.length - 1)
		{
			curControlSelected = 0;
		}
		if (curControlSelected < 0)
		{
			curControlSelected = controlItems.length - 1;
		}
		curControl = controlItems[curControlSelected];
		
		for (item in controlItems)
		{
			updateText(item, item == curControl);
		}
		camFollow.y = controlItems[curControlSelected].y;
		if (controlKeybindGroup[curControlSelected].groupName == 'keybindGroup')
		{
			currentKeybindGroup = controlKeybindGroup[curControlSelected];
			currentUIControl = uiControls[curControlSelected];
		}
	}
	function changeKeybindSelection(amount:Int = 0)
	{
		curKeybindSelected += amount;
		if (amount != 0)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
		if (curKeybindSelected > currentKeybindGroup.texts.length - 1)
		{
			curKeybindSelected = 0;
		}
		if (curKeybindSelected < 0)
		{
			curKeybindSelected = currentKeybindGroup.texts.length - 1;
		}
		if (currentKeybindGroup.groupName == 'keybindGroup')
		{
			currentKeybind = currentKeybindGroup.texts.members[curKeybindSelected];
			for (text in currentKeybindGroup.texts)
			{
				updateText(text, text == currentKeybind);
			}
		}
	}
	function changePresetSelection(amount:Int)
	{
		curSelectedPreset += amount;

		if (curSelectedPreset > keybindPresets.length - 1)
		{
			curSelectedPreset = 0;
		}
		if (curSelectedPreset < 0)
		{
			curSelectedPreset = keybindPresets.length - 1;
		}
		curPreset = keybindPresets[curSelectedPreset];
		
		preset.text = curPreset;
		preset.y = (choosePreset.y + 75) - 30;
		preset.alpha = 0;
		FlxTween.tween(preset, {alpha: 1, y: preset.y + 30}, 0.07);
		presetLeft.x = preset.x - 100;
		presetRight.x = preset.x + 100;
	}
	function changePreset()
	{
		switch (curPreset)
		{
			case 'Arrow Keys':
				controls.setKeyboardScheme(KeyboardScheme.Duo(false), true);
			case 'WASD':
				controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);
			case 'DFJK':
				controls.setKeyboardScheme(Solo, true);
			case 'ASKL':
				controls.setKeyboardScheme(Askl, true);
			case 'ZX,.':
				controls.setKeyboardScheme(ZxCommaDot, true);
		}
		saveControls(controls);
		FlxFlicker.flicker(preset, 1.1, 0.07, true);
		FlxG.sound.play(Paths.sound('confirmMenu'));
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
	static function getAction(controls:Controls, actionName:String):FlxActionDigital
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
	static function getActionInputs(action:FlxActionDigital):Array<FlxActionInput>
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
	static function actionToFlxKeys(action:FlxActionDigital):Array<Int>
	{
		var actionInputs = getActionInputs(action);
		var inputs:Array<Int> = new Array<Int>();

		for (actionInput in actionInputs)
		{
			inputs.push(actionInput.inputID);
		}
		return inputs;
	}
}
enum KeybindState
{
	SelectControl; SelectKeybind; ChangeKeybind;
}
class TextGroup
{
	public var groupName:String;
	public var texts:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();
	
	public function new(groupName:String, texts:FlxTypedGroup<FlxText>)
	{
		this.groupName = groupName;
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