package;

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

class ChangeKeybinds extends MusicBeatSubstate
{
	var keybindState:KeybindState = KeybindState.Selecting;
	var currentControlSelected:Int = 0;
	var currentKeybindSelected:Int = 0;
	var selectedKeybind = false;

	var controlTextGroup:Array<ControlText> = [];

	public static var controlStrings:Array<ControlString> =
	[
		new ControlString('LEFT', ['left', 'left-press', 'left-release']),
		new ControlString('DOWN', ['down', 'down-press', 'down-release']),
		new ControlString('UP', ['up', 'up-press', 'up-release']),
		new ControlString('RIGHT', ['right', 'right-press', 'right-release']),
		new ControlString('ACCEPT', ['accept']),
		new ControlString('BACK/EXIT', ['back']),
		new ControlString('PAUSE', ['pause']),
		new ControlString('RESTART', ['reset']),
		new ControlString('CHEAT', ['cheat'])
	];
	public function new()
	{
		super();
		loadControls(controls);
		var bg = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
      bg.alpha = 0;
      add(bg);

		var title:FlxText = new FlxText(0, 100, 0, "Select a control and then select a keybind");
		title.setFormat(Paths.font('vcr.ttf'), 35, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		title.screenCenter(X);
		title.alpha = 0;
		add(title);

		for (i in 0...controlStrings.length)
		{
			var control = controlStrings[i];
			var controlText = new ControlText(control, '', null, [], []);
			
			var controlTitle = new FlxText(FlxG.width / 2 - 300, 200 + (i * 50), 0, control.title + ":");
			controlTitle.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			controlTitle.alpha = 0;
			add(controlTitle);

			controlText.titleText = controlTitle;
			controlText.texts.push(controlTitle);

			var actionKeys:Array<FlxKey> = keybindsFromControlString(control, controls);

			for (actionKey in 0...actionKeys.length)
			{
				var currentActionKey = actionKeys[actionKey];
				var lastActionKey = actionKeys[actionKey - 1];
				var keybindTextX:Float = 0;
				if (lastActionKey != FlxKey.NONE)
				{
					keybindTextX = FlxG.width / 2 + (Std.string(lastActionKey).length * 10) + (actionKey * 100);
				}
				else
				{
					keybindTextX = FlxG.width / 2 + (actionKey * 100);
				}
				var keybindText = new FlxText(keybindTextX, controlTitle.y, 0, Std.string(currentActionKey));
				keybindText.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				keybindText.alpha = 0;
				add(keybindText);

				controlText.texts.push(keybindText);
				controlText.keybinds.push(keybindText);
				controlText.controlType = 'control';
			}
			controlTextGroup.push(controlText);
		}
		
		var resetKeybindsText = new FlxText(0, FlxG.height - 50, 0, "Reset To Default Keybinds");
		resetKeybindsText.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		resetKeybindsText.alpha = 0;
		resetKeybindsText.screenCenter(X);
		add(resetKeybindsText);

		var controlText = new ControlText(null, 'resetKeybinds', resetKeybindsText, [resetKeybindsText], []);
		controlTextGroup.push(controlText);
		
		for (controlText in controlTextGroup)
		{
			for (text in controlText.texts)
			{
				FlxTween.tween(text, {alpha: 1}, 0.5);
			}
		}
		FlxTween.tween(resetKeybindsText, {alpha: 1}, 0.5);
		FlxTween.tween(bg, {alpha: 0.7}, 0.5);
		FlxTween.tween(title, {alpha: 1}, 0.5);

		changeControlSelection();
		changeKeybindSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		var back = controls.BACK;
		var up = controls.UP_P;
		var down = controls.DOWN_P;
		var left = controls.LEFT_P;
		var right = controls.RIGHT_P;
		var enter = controls.ACCEPT;

		switch (keybindState)
		{
			case KeybindState.Selecting:
				if (up)
				{
					changeControlSelection(-1);
				}
				if (down)
				{
					changeControlSelection(1);
				}
				if (left)
				{
					changeKeybindSelection(-1);
				}
				if (right)
				{
					changeKeybindSelection(1);
				}
				if (enter)
				{
					var currentControl = getCurrentControlSelected();
					switch (currentControl.controlType)
					{
						case 'control':
							if (getCurrentSelectedKeybind() != null)
							{
								FlxG.sound.play(Paths.sound('scrollMenu'));
								var currentKeybind = getCurrentSelectedKeybind();
								currentKeybind.text = "_";
								updateKeybindPositions(getCurrentControlSelected());
								keybindState = KeybindState.EnteringKeybind;
							}
						case 'resetKeybinds':
							controls.setKeyboardScheme(Solo);
							FlxG.sound.play(Paths.sound('confirmMenu'));
							for (controlString in controlStrings)
							{
								updateKeybindDisplay(controlString);
							}
							FlxFlicker.flicker(currentControl.titleText, 0.9, 0.05, true, true, function(flicker:FlxFlicker)
							{
								keybindState = KeybindState.Selecting;
								selectedKeybind = false;
								saveControls(controls);
							});
					}
				}
				if (back)
				{
					saveControls(controls);
					close();
				}
			case KeybindState.EnteringKeybind:
				var keyJustPressed:FlxKey = cast(FlxG.keys.firstJustPressed(), FlxKey);
				if (keyJustPressed != FlxKey.NONE && !selectedKeybind)
				{
					var keybindings:Array<FlxKey> = [];
					var control:Control = Control.ACCEPT;
					for (actionControl in getCurrentControlString().controls)
					{
						keybindings = getActionKeys(actionFromString(actionControl, controls));
						control = controls.stringControlToControl(actionControl);
					}
					controls.unbindKeys(control, keybindings);
					keybindings[currentKeybindSelected] = keyJustPressed;
					controls.bindKeys(control, keybindings);

					selectedKeybind = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					var currentKeybind = getCurrentSelectedKeybind();

					for (controlString in controlStrings)
					{
						updateKeybindDisplay(controlString);
					}
					FlxFlicker.flicker(currentKeybind, 0.9, 0.05, true, true, function(flicker:FlxFlicker)
					{
						keybindState = KeybindState.Selecting;
						selectedKeybind = false;
						saveControls(controls);
					});
				}
		}
	}
	public static function saveControls(controls:Controls)
	{
		var controlKeybinds:Array<Array<FlxKey>> = [];
		for (controlString in controlStrings)
		{
			var keybindings:Array<FlxKey> = keybindsFromControlString(controlString, controls);
			controlKeybinds.push(keybindings);
		}
		FlxG.save.data.keybinds = controlKeybinds;
		FlxG.save.flush();
	}
	public static function loadControls(controls:Controls)
	{	
		if (FlxG.save.data.keybinds != null)
		{
			var loadedControls:Array<Array<FlxKey>> = FlxG.save.data.keybinds;
			for (i in 0...loadedControls.length)
			{
				for (actionControl in controlStrings[i].controls)
				{
					controls.unbindKeys(controls.stringControlToControl(actionControl), getActionKeys(actionFromString(actionControl, controls)));
					controls.bindKeys(controls.stringControlToControl(actionControl), loadedControls[i]);
				}
			}
		}
		else
		{
			controls.setKeyboardScheme(Solo);
			saveControls(controls);
		}
	}

	function changeControlSelection(amount:Int = 0)
	{
		currentControlSelected += amount;
		if (currentControlSelected < 0)
		{
			currentControlSelected = controlTextGroup.length - 1;
		}
		if (currentControlSelected > controlTextGroup.length - 1)
		{
			currentControlSelected = 0;
		}
		if (amount != 0)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		for (controlText in controlTextGroup)
		{
			changeTextState(controlText.titleText, controlText.titleText == getCurrentControlSelected().titleText);
		}
		changeKeybindSelection();
	}
	function changeKeybindSelection(amount:Int = 0)
	{
		currentKeybindSelected += amount;

		var controlKeybinds:Array<FlxKey> = [];
		var currentControlString = getCurrentControlString();
		if (currentControlString != null)
		{
			for (actionControl in currentControlString.controls)
			{
				controlKeybinds = getActionKeys(actionFromString(actionControl, controls));
			}
		
			if (currentKeybindSelected < 0)
			{
				currentKeybindSelected = controlKeybinds.length - 1;
			}
			if (currentKeybindSelected > controlKeybinds.length - 1)
			{
				currentKeybindSelected = 0;
			}
			if (amount != 0)
			{
					FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			for (controlText in controlTextGroup)
			{
				for (keybind in controlText.keybinds)
				{
					changeTextState(keybind, keybind == getCurrentSelectedKeybind());
				}
			}
		}
		
	}
	function updateKeybindDisplay(controlString:ControlString)
	{
		for (controlText in controlTextGroup)
		{
			if (controlText.controlTextString == controlString)
			{
				var actionKeys = keybindsFromControlString(controlString, controls);
				for (i in 0...actionKeys.length)
				{
					controlText.keybinds[i].text = Std.string(actionKeys[i]);
				}
			}
			updateKeybindPositions(controlText);
		}
	}
	function changeTextState(text:FlxText, selected:Bool)
	{
		if (selected)
		{
			text.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		else
		{
			text.setFormat(Paths.font('vcr.ttf'), 30, FlxColor.WHITE, FlxTextAlign.CENTER);
		}
	}
	public static function keybindsFromControlString(controlString:ControlString, controls:Controls):Array<FlxKey>
	{
		var actionKeys:Array<FlxKey> = [];
		for (actionControl in controlString.controls)
		{
			actionKeys = getActionKeys(actionFromString(actionControl, controls));
		}
		return actionKeys;
	}
	function getCurrentControlString():ControlString
	{
		return controlStrings[currentControlSelected];
	}
	function getCurrentControlSelected():ControlText
	{
		return controlTextGroup[currentControlSelected];
	}
	function getCurrentSelectedKeybind():FlxText
	{
		var currentControlSelected = getCurrentControlSelected();
		return currentControlSelected.keybinds[currentKeybindSelected];
	}
	function updateKeybindPositions(control:ControlText)
	{
		var keybindTextX:Float = 0;
		for (i in 0...control.keybinds.length)
		{
			if (i == 0)
			{
				keybindTextX = FlxG.width / 2 + (i * 100);
			}
			else
			{
				var lastKeybind = control.keybinds[i - 1].text;
				keybindTextX = FlxG.width / 2 + (Std.string(lastKeybind).length * 10) + (i * 100);
			}
		}
	}

	public static function getActionKeys(action:FlxActionDigital):Array<FlxKey>
	{
		var keys:Array<FlxKey> = [];
		for (input in action.inputs)
		{
			keys.push(cast (input.inputID, FlxKey));
		}
		return keys;
	}
	public static function actionFromString(actionString:String, controls:Controls):FlxActionDigital
	{
		for (action in controls.digitalActions)
		{
			if (action.name == actionString)
			{
				return action;
			}
		}
		return null;
	}
}

class ControlString
{
	public var title:String;
	public var controls:Array<String>;


	public function new(title:String, controls:Array<String>)
	{
		this.title = title;
		this.controls = controls;
	}
}
class ControlText
{
	public var controlTextString:ControlString;
	public var controlType:String;
	public var titleText:FlxText;
	public var texts:Array<FlxText>;
	public var keybinds:Array<FlxText>;

	public function new(controlTextString:ControlString, controlType:String, titleText:FlxText, texts:Array<FlxText>, keybinds:Array<FlxText>)
	{
		this.controlTextString = controlTextString;
		this.controlType = controlType;
		this.titleText = titleText;
		this.texts = texts;
		this.keybinds = keybinds;
	}
}
enum KeybindState
{
	Selecting;
	EnteringKeybind;
}