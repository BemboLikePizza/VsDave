package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.util.FlxStringUtil;
import lime.utils.Assets;
import flixel.FlxObject;
#if desktop
import Discord.DiscordClient;
#end
using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var bg:FlxSprite = new FlxSprite();

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	private var curChar:String = "unknown";

	private var InMainFreeplayState:Bool = false;

	private var CurrentSongIcon:FlxSprite;

	private var Catagories:Array<String> = ["Dave", "Joke", "Extra"];

	private var CurrentPack:Int = 0;

	private var NameAlpha:Alphabet;

	var loadingPack:Bool = false;

	var songColors:Array<FlxColor> = [
    	0xFFca1f6f, // GF
		0xFF4965FF, // DAVE
		0xFF00B515, // MISTER BAMBI RETARD
		0xFF00FFFF, // SPLIT THE THONNNNN
		0xFF800080, // FESTIVAL
		0xFFFF0000,  // UNFAIRNESS
		0xFFFF0000  // EXPLOITATION
    ];

	private var camFollow:FlxObject;
	private static var prevCamFollow:FlxObject;

	private var iconArray:Array<HealthIcon> = [];

	var titles:Array<Alphabet> = [];
	var icons:Array<FlxSprite> = [];

	var doneCoolTrans:Bool = false;

	override function create()
	{
		#if desktop
		DiscordClient.changePresence("In the Freeplay Menu", null);
		#end
		
		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		bg.loadGraphic(MainMenuState.randomizeBG());
		bg.color = 0xFF4965FF;
		bg.scrollFactor.set();
		add(bg);

		for (i in 0...Catagories.length)
		{
			var NameAlpha:Alphabet = new Alphabet(40,(FlxG.height / 2) - 282,Catagories[i],true,false);
			
			var CurrentSongIcon:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('weekIcons/week_icons_' + (Catagories[i].toLowerCase()), "preload"));
			CurrentSongIcon.centerOffsets(false);
			CurrentSongIcon.x = (1000 * i + 1);
			CurrentSongIcon.y = (FlxG.height / 2) - 256;
			CurrentSongIcon.antialiasing = true;
			add(CurrentSongIcon);
			icons.push(CurrentSongIcon);

			// NameAlpha.screenCenter(X);
			Highscore.load();
			NameAlpha.x = CurrentSongIcon.x;
			add(NameAlpha);
			titles.push(NameAlpha);
		}

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(icons[CurrentPack].x + 256, icons[CurrentPack].y + 256);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);
		
		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		FlxG.camera.focusOn(camFollow.getPosition());

		super.create();
	}

	public function LoadProperPack()
	{
		switch (Catagories[CurrentPack].toLowerCase())
		{
			case 'dave':
				addWeek(['Tutorial'], 0, ['gf']);	
				addWeek(['House', 'Insanity', 'Polygonized'], 1, ['dave', 'dave', 'dave-angey']);
				addWeek(['Bonus-Song'], 1, ['dave']);
				addWeek(['Blocked','Corn-Theft','Maze',], 2, ['bambi']);
				addWeek(['Splitathon'], 3, ['the-duo']);
				addWeek(['Shredder', 'Greetings', 'Interdimensional'], 4, ['bambi', 'tristan-festival', 'dave-angey']);
			case 'joke':
				addWeek(['Supernovae', 'Glitch'], 2, ['bambi-stupid']);
				if (FlxG.save.data.cheatingFound)
					addWeek(['Cheating'], 2, ['bambi-3d']);
				if(FlxG.save.data.unfairnessFound)
					addWeek(['Unfairness'], 5, ['bambi-unfair']);
				addWeek(['Exploitation'], 6, ['expunged']);
				if(FlxG.save.data.exbungoFound)
					addWeek(['Kabunga'], 2, ['exbungo']);
			case 'extra':
				addWeek(['Mealie'], 2, ['bambi-loser']);
				addWeek(['Memory'], 1, ['dave']);
				addWeek(['Escape-From-California'], 5, ['none']);
				addWeek(['Overdrive'], 1, ['dave']);
				addWeek(['Furiosity'], 1, ['dave-angey']);
				addWeek(['Vs-Dave-Rap'], 2, ['dave-cool']);
				addWeek(['Five-Nights'], 2, ['dave']);
				addWeek(['Roots'], 2, ['dave']);
		}
	}

	public function GoToActualFreeplay()
	{
		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.itemType = 'D-Shape';
			songText.targetY = i;
			songText.scrollFactor.set();
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;
			icon.scrollFactor.set();

			iconArray.push(icon);
			add(icon);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		scoreText.y = -200;
		scoreText.scrollFactor.set();

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		scoreBG.y = -200;
		scoreBG.scrollFactor.set();
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		diffText.y = -200;
		diffText.scrollFactor.set();

		add(diffText);

		add(scoreText);

		FlxTween.tween(scoreBG,{y: 0},0.5,{ease: FlxEase.expoInOut});
		FlxTween.tween(scoreText,{y: 5},0.5,{ease: FlxEase.expoInOut});
		FlxTween.tween(diffText,{y: 40},0.5,{ease: FlxEase.expoInOut});

		changeSelection();
		changeDiff();

	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function UpdatePackSelection(change:Int)
	{
		CurrentPack += change;
		if (CurrentPack == -1)
			CurrentPack = Catagories.length - 1;
		
		if (CurrentPack == Catagories.length)
			CurrentPack = 0;

		camFollow.setPosition(icons[CurrentPack].x + 256, icons[CurrentPack].y + 256);
	}

	override function beatHit()
	{
		super.beatHit();
		FlxTween.tween(FlxG.camera, {zoom:1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!InMainFreeplayState) 
		{
			if (controls.LEFT_P)
			{
				UpdatePackSelection(-1);
			}
			if (controls.RIGHT_P)
			{
				UpdatePackSelection(1);
			}
			if (controls.ACCEPT && !loadingPack)
			{
				loadingPack = true;
				LoadProperPack();
				
				for (item in icons) { FlxTween.tween(item, {alpha: 0}, 0.3); }
				for (item in titles) { FlxTween.tween(item, {alpha: 0}, 0.3); }

				new FlxTimer().start(0.5, function(Dumbshit:FlxTimer)
				{
					for (item in icons) { item.visible = false; }
					for (item in titles) { item.visible = false; }

					GoToActualFreeplay();
					InMainFreeplayState = true;
					loadingPack = false;
				});
			}
			if (controls.BACK)
			{
				FlxG.switchState(new MainMenuState());
			}	
		
			return;
		}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

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
		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.switchState(new FreeplayState());
		}

		if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			PlayState.storyWeek = songs[curSelected].week;
			LoadingState.loadAndSwitchState(new CharacterSelectState());
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		if (songs[curSelected].week == 3)
		{
			curDifficulty = 1;
		}
		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end
		curChar = Highscore.getChar(songs[curSelected].songName, curDifficulty);
		updateDifficultyText();
		
	}

	function updateDifficultyText()
	{
		switch (songs[curSelected].week)
		{
			case 3:
				diffText.text = 'FINALE' + " - " + curChar.toUpperCase();
			default:
				switch (curDifficulty)
				{
					case 0:
						diffText.text = "EASY" + " - " + curChar.toUpperCase();
					case 1:
						diffText.text = 'NORMAL' + " - " + curChar.toUpperCase();
					case 2:
						diffText.text = "HARD" + " - " + curChar.toUpperCase();
					case 3:
						diffText.text = "LEGACY" + " - " + curChar.toUpperCase();
				}
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;

		if (curSelected >= songs.length)
			curSelected = 0;

		if (curDifficulty < 0)
			curDifficulty = 2;

		if (curDifficulty > 2)
			curDifficulty = 0;

		if (songs[curSelected].week == 3)
		{
			curDifficulty = 1;
		}

		curChar = Highscore.getChar(songs[curSelected].songName, curDifficulty);
		updateDifficultyText();

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
		FlxTween.color(bg, 0.25, bg.color, songColors[songs[curSelected].week]);
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}