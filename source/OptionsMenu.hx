package;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end

class OptionsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	override function create()
	{
		#if desktop
		DiscordClient.changePresence("In the Options Menu", null);
		#end
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('backgrounds/SUSSUS AMOGUS'));
		controlsStrings = CoolUtil.coolStringFile(
			"Change Keybinds"
			+ "\n" + (FlxG.save.data.newInput ? "Ghost Tapping" : "No Ghost Tapping") 
			+ "\n" + (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll') 
			+ "\n" + (FlxG.save.data.eyesores ? 'Eyesores Enabled' : 'Eyesores Disabled') 
			+ "\n" + (FlxG.save.data.donoteclick ? "Hitsounds On" : "Hitsounds Off") 
			+ "\n" + (FlxG.save.data.freeplayCuts ? "Freeplay Cutscenes On" : "Freeplay Cutscenes Off"));
		

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		menuBG.loadGraphic(MainMenuState.randomizeBG());
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
				controlLabel.screenCenter(X);
				controlLabel.itemType = 'Vertical';
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}


		versionShit = new FlxText(5, FlxG.height - 18, 0, "Offset (Left, Right): " + FlxG.save.data.offset, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

			if (controls.BACK)
				FlxG.switchState(new MainMenuState());
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
			
			if (controls.RIGHT_R)
			{
				FlxG.save.data.offset++;
				versionShit.text = "Offset (Left, Right): " + FlxG.save.data.offset;
			}

			if (controls.LEFT_R)
				{
					FlxG.save.data.offset--;
					versionShit.text = "Offset (Left, Right): " + FlxG.save.data.offset;
				}
	

			if (controls.ACCEPT)
			{
				grpControls.remove(grpControls.members[curSelected]);
				switch(curSelected)
				{
					case 0:
						new FlxTimer().start(0.01, function(timer:FlxTimer)
						{
							openSubState(new ChangeKeybinds());
						});
						updateGroupControls("Change Keybinds", 0, 'Vertical');
					case 1:
						FlxG.save.data.newInput = !FlxG.save.data.newInput;
						updateGroupControls((FlxG.save.data.newInput ? "Ghost Tapping" : "No Ghost Tapping"), 1, 'Vertical');	
					case 2:
						FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
						updateGroupControls((FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll'), 2, 'Vertical');
					case 3:
						FlxG.save.data.eyesores = !FlxG.save.data.eyesores;
						updateGroupControls((FlxG.save.data.eyesores ? 'Eyesores Enabled' : 'Eyesores Disabled'), 3, 'Vertical');	
					case 4:
						FlxG.save.data.donoteclick = !FlxG.save.data.donoteclick;
						updateGroupControls((FlxG.save.data.donoteclick ? "Hitsounds On" : "Hitsounds Off"), 4, 'Vertical');	
					case 5:
						FlxG.save.data.freeplayCuts = !FlxG.save.data.freeplayCuts;
						updateGroupControls((FlxG.save.data.freeplayCuts ? "Freeplay Cutscenes On" : "Freeplay Cutscenes Off"), 5, 'Vertical');	
				}
			}
	}

	var isSettingControl:Bool = false;

	override function beatHit()
	{
		super.beatHit();
		FlxTween.tween(FlxG.camera, {zoom:1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
	}
	function updateGroupControls(controlText:String, yIndex:Int, controlTextItemType:String)
	{
		var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, controlText, true, false);
		ctrl.screenCenter(X);
		ctrl.isMenuItem = true;
		ctrl.targetY = curSelected - yIndex;
		ctrl.itemType = controlTextItemType;
		grpControls.add(ctrl);
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end
		
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
