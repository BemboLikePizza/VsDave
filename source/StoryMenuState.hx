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

	public static var weekUnlocked:Array<Bool> = [true, true, true, true, true, true];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var yellowBG:FlxSprite;

	var txtTracklist:FlxText;
	var txtTrackdeco:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var weeks:Array<Week> = [
		new Week(['Warmup'], LanguageManager.getTextString('story_tutorial'), 0xFF8A42B7, 'warmup'), // WARMUP
		new Week(['House', 'Insanity', 'Polygonized'], LanguageManager.getTextString('story_daveWeek'), 0xFF4965FF, 'DaveHouse'), // DAVE
		new Week(['Blocked', 'Corn-Theft', 'Maze'], LanguageManager.getTextString('story_bambiWeek'), 0xFF00B515, 'bamboi'), // MISTER BAMBI RETARD
		new Week(['Splitathon'], LanguageManager.getTextString('story_finale'), 0xFF00FFFF, 'splitathon'), // SPLIT THE THONNNNN
		new Week(['Shredder', 'Greetings', 'Interdimensional', 'Rano'], LanguageManager.getTextString('story_festivalWeek'), 0xFF800080,
			'festival'), // FESTEVAL
	];

	var awaitingExploitation:Bool;

	static var awaitingToPlayMasterWeek:Bool;

	var weekBanners:Array<FlxSprite> = new Array<FlxSprite>();
	var lastSelectedWeek:Int = 0;

	override function create()
	{
		awaitingExploitation = (FlxG.save.data.exploitationState == 'awaiting');

		if (FlxG.save.data.masterWeekUnlocked)
		{
			var weekName = !FlxG.save.data.hasPlayedMasterWeek ? LanguageManager.getTextString('story_masterWeekToPlay') : LanguageManager.getTextString('story_masterWeek');
			weeks.push(new Week(['Supernovae', 'Glitch', 'Master'], weekName, 0xFF116E1C,
				FlxG.save.data.hasPlayedMasterWeek ? 'masterweek' : 'masterweekquestion')); // MASTERA BAMBI
		}

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

		yellowBG = new FlxSprite(0, 56).makeGraphic(FlxG.width * 2, 400, FlxColor.WHITE);
		yellowBG.color = weeks[0].weekColor;

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 57, FlxColor.BLACK);
		add(blackBarThingie);

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		for (i in 0...weeks.length)
		{
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 80, i);
			weekThing.x += ((weekThing.width + 20) * i);
			weekThing.targetX = i;
			weekThing.antialiasing = true;
			grpWeekText.add(weekThing);
		}

		add(yellowBG);

		txtTrackdeco = new FlxText(0, yellowBG.x + yellowBG.height + 50, FlxG.width, LanguageManager.getTextString('story_track').toUpperCase(), 28);
		txtTrackdeco.alignment = CENTER;
		txtTrackdeco.font = rankText.font;
		txtTrackdeco.color = 0xFFe55777;
		txtTrackdeco.antialiasing = true;
		txtTrackdeco.screenCenter(X);

		txtTracklist = new FlxText(0, yellowBG.x + yellowBG.height + 80, FlxG.width, '', 28);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		txtTracklist.antialiasing = true;
		txtTracklist.screenCenter(X);
		add(txtTrackdeco);
		add(txtTracklist);
		add(scoreText);
		add(txtWeekTitle);

		for (i in 0...weeks.length)
		{
			var weekBanner:FlxSprite = new FlxSprite(600, 56).loadGraphic(Paths.image('weekBanners/${weeks[i].bannerName}'));
			weekBanner.antialiasing = false;
			weekBanner.active = true;
			weekBanner.screenCenter(X);
			weekBanner.alpha = i == curWeek ? 1 : 0;
			add(weekBanner);

			weekBanners.push(weekBanner);
		}

		updateText();

		if (awaitingToPlayMasterWeek)
		{
			awaitingToPlayMasterWeek = false;
			changeWeek(5 - curWeek);
		}
		else
		{
			changeWeek(0);
		}
		super.create();
	}

	override function update(elapsed:Float)
	{
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = LanguageManager.getTextString('story_weekScore') + lerpScore;
		txtWeekTitle.text = weeks[curWeek].weekName.toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.LEFT_P)
				{
					changeWeek(-1);
				}

				if (controls.RIGHT_P)
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
		if (FlxG.keys.justPressed.SEVEN && !FlxG.save.data.masterWeekUnlocked)
		{
			FlxG.sound.music.fadeOut(1, 0);
			FlxG.camera.shake(0.02, 5.1);
			FlxG.camera.fade(FlxColor.WHITE, 5.05, false, function()
			{
				FlxG.save.data.masterWeekUnlocked = true;
				FlxG.save.data.hasPlayedMasterWeek = false;
				awaitingToPlayMasterWeek = true;
				FlxG.save.flush();

				FlxG.resetState();
			});
			FlxG.sound.play(Paths.sound('doom'));
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

			PlayState.storyPlaylist = weeks[curWeek].songList;
			PlayState.isStoryMode = true;
			selectedWeek = true;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				PlayState.characteroverride = "none";
				PlayState.formoverride = "none";
				PlayState.curmult = [1, 1, 1, 1];

				switch (PlayState.storyWeek)
				{
					case 1:
						FlxG.sound.music.stop();
						var video:VideoHandler = new VideoHandler();
						video.finishCallback = function()
						{
							LoadingState.loadAndSwitchState(new PlayState(), true);
						}
						video.playVideo(Paths.video('daveCutscene'));
					case 5:
						if (!FlxG.save.data.hasPlayedMasterWeek)
						{
							FlxG.save.data.hasPlayedMasterWeek = true;
							FlxG.save.flush();
						}
						LoadingState.loadAndSwitchState(new PlayState(), true);
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
		lastSelectedWeek = curWeek;
		curWeek += change;

		if (curWeek > weeks.length - 1)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weeks.length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetX = bullShit - curWeek;
			if (item.targetX == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxTween.color(yellowBG, 0.25, yellowBG.color, weeks[curWeek].weekColor);

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
		updateWeekBanner();
	}

	function updateWeekBanner()
	{
		for (i in 0...weekBanners.length)
		{
			if (![lastSelectedWeek, curWeek].contains(i))
			{
				weekBanners[i].alpha = 0;
			}
		}
		FlxTween.tween(weekBanners[lastSelectedWeek], {alpha: 0}, 0.1);
		FlxTween.tween(weekBanners[curWeek], {alpha: 1}, 0.1);
	}

	function updateText()
	{
		txtTracklist.text = "";

		var stringThing:Array<String> = weeks[curWeek].songList;

		if (curWeek == 5 && !FlxG.save.data.hasPlayedMasterWeek)
		{
			stringThing = ['???', '???', '???'];
		}

		for (i in stringThing)
		{
			// txtTracklist.text += " - " + i;
		}

		txtTracklist.text = stringThing.join(' - ');

		// txtTracklist.text = txtTracklist.text += " - ";

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek);
		#end
	}
}

class Week
{
	public var songList:Array<String>;
	public var weekName:String;
	public var weekColor:FlxColor;
	public var bannerName:String;

	public function new(songList:Array<String>, weekName:String, weekColor:FlxColor, bannerName:String)
	{
		this.songList = songList;
		this.weekName = weekName;
		this.weekColor = weekColor;
		this.bannerName = bannerName;
	}
}
