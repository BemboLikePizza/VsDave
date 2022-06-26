package;

import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.addons.effects.chainable.FlxGlitchEffect.FlxGlitchDirection;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import openfl.ui.Keyboard;
import flixel.util.FlxCollision;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	var weekData:Array<Dynamic> = [
		['Tutorial'],
		['House', 'Insanity', 'Polygonized'],
		['Blocked', 'Corn-Theft', 'Maze'],
		['Splitathon'],
		['Shredder', 'Greetings', 'Interdimensional']
	];

	var curDifficulty:Int = 1;
	
	public static var weekUnlocked:Array<Bool> = [true, true, true, true, true];

	var weekCharacters:Array<Dynamic> = [
		['empty', 'bf', 'gf'],
		['empty', 'empty', 'empty'],
		['empty', 'empty', 'empty'],
		['empty', 'empty', 'empty'],
		['empty', 'empty', 'empty'],
	];

	var weekNames:Array<String> = [
		LanguageManager.getTextString('story_tutorial'), // tutorial
		LanguageManager.getTextString('story_daveWeek'), //dave week name
		LanguageManager.getTextString('story_bambiWeek'), // bambi week name
		LanguageManager.getTextString('story_finale'), // finale week name
		LanguageManager.getTextString('story_festivalWeek'), // festival week name
	];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var imageBG:FlxSprite;
	var yellowBG:FlxSprite;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var songColors:Array<FlxColor> = [
      0xFFca1f6f, // GF
		0xFF4965FF, // DAVE
		0xFF00B515, // MISTER BAMBI RETARD
		0xFF00FFFF, //SPLIT THE THONNNNN
		0xFF800080, //FESTEVAL
	
	];
	var awaitingExploitation:Bool;

	override function create()
	{
		awaitingExploitation = (FlxG.save.data.exploitationState == 'awaiting');

		#if desktop
		DiscordClient.changePresence("In the Story Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 0, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("Comic Sans MS Bold", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 0, 0, "", 32);
		txtWeekTitle.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("comic.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('ui/campaign_menu_UI_assets');
		yellowBG = new FlxSprite(0, 56).makeGraphic(FlxG.width * 2, 400, FlxColor.WHITE);
		yellowBG.color = songColors[0];

		imageBG = new FlxSprite(600, 1000).loadGraphic(Paths.image("blank", "shared"));
		imageBG.antialiasing = true;
		imageBG.screenCenter(X);
		imageBG.active = false;
		add(imageBG);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		for (i in 0...weekData.length)
		{
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			
			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				grpLocks.add(lock);
			}
		}

		for (char in 0...3)
		{
			var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, weekCharacters[curWeek][char]);
			weekCharacterThing.y += 70;
			weekCharacterThing.antialiasing = true;

			switch (weekCharacterThing.character)
			{
				case 'bf':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.9));
					weekCharacterThing.updateHitbox();
					weekCharacterThing.x -= 80;
				case 'gf':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.5));
					weekCharacterThing.updateHitbox();
			}

			grpWeekCharacters.add(weekCharacterThing);
		}

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.addByPrefix('finale', 'FINALE');
		sprDifficulty.animation.play('easy');
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		add(yellowBG);
		add(grpWeekCharacters);

		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 50, 0, LanguageManager.getTextString('story_track'), 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);

		updateText();

		super.create();
	}


	override function update(elapsed:Float)
	{
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = LanguageManager.getTextString('story_weekScore') + lerpScore;
		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UP_P)
				{
					changeWeek(-1);
				}

				if (controls.DOWN_P)
				{
					changeWeek(1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (!stopspamming)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = "";

			switch (curDifficulty)
			{
				case 0:
					diffic = '-easy';
				case 2:
					diffic = '-hard';
			}

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				PlayState.characteroverride = "none";
				PlayState.curmult = [1, 1, 1, 1];
				switch (PlayState.storyWeek)
				{
					case 1:
						FlxG.sound.music.stop();
						var video:MP4Handler;
						video = new MP4Handler();
						video.finishCallback = function()
						{
							LoadingState.loadAndSwitchState(new PlayState(), true);
						}
						video.playVideo(Paths.video('daveCutscene'));
					default:
						LoadingState.loadAndSwitchState(new PlayState(), true);
					
				}

			});
		}
	}
	function updateDifficultySprite()
	{
		sprDifficulty.offset.x = 0;
		switch (curWeek)
		{
			case 3:
				sprDifficulty.animation.play('finale');
				sprDifficulty.offset.x = 45;
			default:
				switch (curDifficulty)
				{
					case 0:
						sprDifficulty.animation.play('easy');
						sprDifficulty.offset.x = 20;
						sprDifficulty.offset.y = 0;
					case 1:
						sprDifficulty.animation.play('normal');
						sprDifficulty.offset.x = 70;
						sprDifficulty.offset.y = 0;
					case 2:
						sprDifficulty.animation.play('hard');
						sprDifficulty.offset.x = 20;
						sprDifficulty.offset.y = 0;
				}
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;
		
		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		if (curWeek == 3)
		{
			curDifficulty = 1;
		}

		updateDifficultySprite();

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek > weekData.length - 1)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		updateDifficultySprite();
		
		var bullShit:Int = 0;
		
		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxTween.color(yellowBG, 0.25, yellowBG.color, songColors[curWeek]);

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
		imageBgCheck();
	}
	

	function imageBgCheck()
	{
		var path:String;
		var position:FlxPoint;
		switch (curWeek)
		{
			case 1:
				path = Paths.image("dave/DaveHouse", "shared");
				position = new FlxPoint(600, 55);
			case 2:
				path = Paths.image("dave/bamboi", "shared");
				position = new FlxPoint(600, 55);
			case 3:
				path = Paths.image("dave/splitathon", "shared");
				position = new FlxPoint(600, 55);
			case 4:
				path = Paths.image("dave/festival", "shared");
				position = new FlxPoint(600, 55);
			default:
				path = Paths.image("blank", "shared");
				position = new FlxPoint(600, 200);
		}
		imageBG.destroy();
		imageBG = new FlxSprite(position.x, position.y).loadGraphic(path);
		imageBG.antialiasing = true;
		imageBG.screenCenter(X);
		imageBG.active = false;
		add(imageBG);
	}

	function updateText()
	{
		for (i in 0...grpWeekCharacters.members.length)
		{
			grpWeekCharacters.members[i].animation.play(weekCharacters[curWeek][i]);
		}
		txtTracklist.text = "Tracks\n";

		switch (grpWeekCharacters.members[0].animation.curAnim.name)
		{
			default:
				grpWeekCharacters.members[0].offset.set(100, 100);
				grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));
				// grpWeekCharacters.members[0].updateHitbox();
		}

		var stringThing:Array<String> = weekData[curWeek];

		for (i in stringThing)
		{
			txtTracklist.text += "\n" + i;
		}

		txtTracklist.text = txtTracklist.text += "\n";

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}
}
