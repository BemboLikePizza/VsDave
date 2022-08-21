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
		['Warmup'],
		['House', 'Insanity', 'Polygonized'],
		['Blocked', 'Corn-Theft', 'Maze'],
		['Splitathon'],
		['Shredder', 'Greetings', 'Interdimensional', 'Rano']
	];

	var curDifficulty:Int = 1;
	
	public static var weekUnlocked:Array<Bool> = [true, true, true, true, true];

	var weekCharacters:Array<Dynamic> = [
		['empty', 'empty', 'empty'],
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

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var songColors:Array<FlxColor> = [
        //0xFFca1f6f, // TUTORIAL
		0xFF8A42B7, // WARMUP
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
		scoreText.antialiasing = true;

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 0, 0, "", 32);
		txtWeekTitle.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.antialiasing = true;
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("comic.ttf"), 32);
		rankText.antialiasing = true;
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

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 55, FlxColor.BLACK);
		add(blackBarThingie);

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

		difficultySelectors = new FlxGroup();

		add(yellowBG);

		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 50, 0, LanguageManager.getTextString('story_track'), 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		txtTracklist.antialiasing = true;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);

		updateText();
		
		imageBgCheck();

		super.create();
	}


	override function update(elapsed:Float)
	{
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = LanguageManager.getTextString('story_weekScore') + lerpScore;
		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = false;

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

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase());
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
						var video:VideoHandler;
						video = new VideoHandler();
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


	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek > weekData.length - 1)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		curDifficulty = 1;
		
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
			case 0:
				path = Paths.image("weekBanners/warmup");
				position = new FlxPoint(600, 56);
			case 1:
				path = Paths.image("weekBanners/DaveHouse");
				position = new FlxPoint(600, 56);
			case 2:
				path = Paths.image("weekBanners/bamboi");
				position = new FlxPoint(600, 56);
			case 3:
				path = Paths.image("weekBanners/splitathon");
				position = new FlxPoint(600, 56);
			case 4:
				path = Paths.image("weekBanners/festival");
				position = new FlxPoint(600, 56);
			default:
				path = Paths.image("blank", "shared");
				position = new FlxPoint(600, 200);
		}
		imageBG.destroy();
		imageBG = new FlxSprite(position.x, position.y).loadGraphic(path);
		imageBG.antialiasing = false;
		imageBG.screenCenter(X);
		imageBG.active = true;
		add(imageBG);
	}
	function resetData()
	{
		FlxG.save.erase();
		FlxG.save.flush();
		
		FlxG.save.bind('funkin', 'ninjamuffin99');

		SaveDataHandler.initSave();
		LanguageManager.init();

		Highscore.load();
		
		CoolUtil.init();

		FlxG.switchState(new StartStateSelector());
	}

	function updateText()
	{
		txtTracklist.text = "Tracks\n";

		var stringThing:Array<String> = weekData[curWeek];

		for (i in stringThing)
		{
			txtTracklist.text += "\n" + i;
		}

		txtTracklist.text = txtTracklist.text += "\n";

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek);
		#end
	}
}
