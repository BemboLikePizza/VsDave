package;

import haxe.Json;
import haxe.Http;
import flixel.math.FlxRandom;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	#if debug
	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Developer No Miss', 'Exit to menu'];
	#else
	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Exit to menu'];
	#end
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var expungedSelectWaitTime:Float = 0;
	var timeElapsed:Float = 0;
	var patienceTime:Float = 0;

	public function new(x:Float, y:Float)
	{
		super();
		
		switch (PlayState.SONG.song.toLowerCase())
		{
			default:
				pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);	
			case "exploitation":
				pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast-ohno'), true, true);
				expungedSelectWaitTime = new FlxRandom().float(0.5, 2);
				patienceTime = new FlxRandom().float(15, 30);
		}
		
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5,
		onComplete: function(tween:FlxTween)
		{
			switch (PlayState.SONG.song.toLowerCase())
			{
				case 'exploitation':
					doALittleTrolling(levelDifficulty);
				case 'eletric-cockadoodledoo':
					cockadoodledooTrolling(levelDifficulty);
			}
		}});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		timeElapsed += elapsed;
		if (pauseMusic.volume < 0.75)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		if (PlayState.SONG.song.toLowerCase() == 'exploitation' && PauseSubState != null)
		{
			if (expungedSelectWaitTime >= 0)
			{
				expungedSelectWaitTime -= elapsed;
			}
			else
			{
				expungedSelectWaitTime = new FlxRandom().float(0.5, 2);
				changeSelection(new FlxRandom().int((menuItems.length - 1) * -1, menuItems.length - 1));
			}
			if (timeElapsed > patienceTime)
			{
				selectOption();
			}
		}

		if (accepted)
		{
			selectOption();
		}
	}
	function selectOption()
	{
		var daSelected:String = menuItems[curSelected];

		switch (daSelected)
		{
			case "Resume":
				close();
			case "Restart Song":
				PlayState.screenshader.shader.uampmul.value[0] = 0;
				PlayState.screenshader.Enabled = false;
				FlxG.resetState();
			case "Developer No Miss":
				PlayState.devBotplay = !PlayState.devBotplay;
			case "Exit to menu":
				PlayState.screenshader.shader.uampmul.value[0] = 0;
				PlayState.screenshader.Enabled = false;
				PlayState.characteroverride = 'none';
				PlayState.formoverride = 'none';

				Application.current.window.title = Main.applicationName;

				if (PlayState.SONG.song.toLowerCase() == "exploitation")
				{
					Main.toggleFuckedFPS(false);
				}

				FlxG.switchState(new MainMenuState());
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}
	function doALittleTrolling(levelDifficulty:FlxText)
	{
		var difficultyHeight = levelDifficulty.height;
		var amountOfDifficulties = Math.ceil(FlxG.height / difficultyHeight);

		for (i in 0...amountOfDifficulties)
		{
			var difficulty:FlxText = new FlxText(20, (15 + 32) * (i + 2), 0, "", 32);
			difficulty.text += levelDifficulty.text;
			difficulty.scrollFactor.set();
			difficulty.setFormat(Paths.font('vcr.ttf'), 32);
			difficulty.updateHitbox();
			if (this != null)
				add(difficulty);

			difficulty.alpha = 0;

			difficulty.x = FlxG.width - (difficulty.width + 20);

			FlxTween.tween(difficulty, {alpha: 1, y: difficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.05 * i});
		}
	}
	function cockadoodledooTrolling(levelDifficulty:FlxText)
	{
		var amountOfDifficulties = 247;

		for (i in 0...amountOfDifficulties)
		{
			var difficulty:FlxText = new FlxText(new FlxRandom().float(levelDifficulty.width, FlxG.width - levelDifficulty.width),
				new FlxRandom().float(levelDifficulty.height, FlxG.width - levelDifficulty.height), 0, levelDifficulty.text, 32);
			difficulty.scrollFactor.set();
			difficulty.setFormat(Paths.font('vcr.ttf'), 32);
			difficulty.updateHitbox();
			if (this != null)
				add(difficulty);

			difficulty.angle = new FlxRandom().float(0, 180);

			difficulty.alpha = 0;

			FlxTween.tween(difficulty, {alpha: 1, y: difficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.01 * i});
		}
	}
	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
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