package;

import flixel.effects.particles.FlxParticle;
import hscript.Printer;
import openfl.desktop.Clipboard;
import flixel.system.debug.Window;
import sys.FileSystem;
#if desktop
import sys.io.File;
import openfl.display.BitmapData;
#end
import flixel.system.FlxBGSprite;
import flixel.tweens.misc.ColorTween;
import flixel.math.FlxRandom;
import openfl.net.FileFilter;
import openfl.filters.BitmapFilter;
import Shaders.PulseEffect;
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import flash.system.System;
import flixel.util.FlxSpriteUtil;
#if desktop
import Discord.DiscordClient;
#end

#if windows
import sys.io.File;
import sys.io.Process;
import lime.app.Application;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var characteroverride:String = "none";
	public static var formoverride:String = "none";
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public var darkLevels:Array<String> = ['bambiFarmNight', 'daveHouse_night', 'unfairness'];
	public var sunsetLevels:Array<String> = ['bambiFarmSunset', 'daveHouse_Sunset'];

	var howManyPlayerNotes:Int = 0;
	var howManyEnemyNotes:Int = 0;

	public var stupidx:Float = 0;
	public var stupidy:Float = 0; // stupid velocities for cutscene
	public var updatevels:Bool = false;

	public var hasTriggeredDumbshit:Bool = false;
	var AUGHHHH:String;
	var AHHHHH:String;

	public static var curmult:Array<Float> = [1, 1, 1, 1];

	public var curbg:BGSprite;
	public static var screenshader:Shaders.PulseEffect = new PulseEffect();
	public static var lazychartshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
	public var UsingNewCam:Bool = false;

	public var elapsedtime:Float = 0;

	var focusOnDadGlobal:Bool = true;

	var funnyFloatyBoys:Array<String> = ['dave-angey', 'bambi-3d', 'expunged', 'bambi-unfair', 'exbungo'];

	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";

	var boyfriendOldIcon:String = 'bf-old';

	private var vocals:FlxSound;

	private var dad:Character;
	private var dadmirror:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var splitathonCharacterExpression:Character;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	public var sunsetColor:FlxColor = FlxColor.fromRGB(255, 143, 178);

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;

	public var playerStrums:FlxTypedGroup<FlxSprite>;
	public var dadStrums:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;

	public static var misses:Int = 0;

	private var accuracy:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	public static var eyesoreson = true;

	private var STUPDVARIABLETHATSHOULDNTBENEEDED:FlxSprite;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var shakeCam:Bool = false;
	private var startingSong:Bool = false;

	public var TwentySixKey:Bool = false;

	public static var amogus:Int = 0;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var BAMBICUTSCENEICONHURHURHUR:HealthIcon;
	private var camDialogue:FlxCamera;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var notestuffs:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	var fc:Bool = true;

	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;

	var GFScared:Bool = false;

	var scaryBG:FlxSprite;
	var showScary:Bool = false;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;

	private var already_forced_screen:Bool = false;

	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;

	public static var warningNeverDone:Bool = false;

	public var crazyBatch:String = "shutdown /r /t 0";

	public var backgroundSprites:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();
	var normalDaveBG:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();
	var canFloat:Bool = true;

	var nightColor:FlxColor = 0xFF878787;

	var possibleNotes:Array<Note> = [];

	var tweenList:Array<FlxTween> = new Array<FlxTween>();

	var bfTween:ColorTween;

	var tweenTime:Float;

	var songPosBar:FlxBar;
	var songPosBG:FlxSprite;

	var bfNoteCamOffset:Array<Float> = new Array<Float>();
	var dadNoteCamOffset:Array<Float> = new Array<Float>();

	public var modchart:ExploitationModchartType;

	var weirdBG:FlxSprite;

	var cuzsieKapiBananacore:Array<FlxSprite> = [];


	public static var originalWindowTitle:String;


	var mcStarted:Bool = false;

	public static var devBotplay:Bool = false;

	override public function create()
	{
		if (SONG.song.toLowerCase() == "greetings" && characteroverride.toLowerCase() == "tristan")
		{
			var poop:String = Highscore.formatSong("confronting-yourself", 1);

			trace(poop);

			SONG = Song.loadFromJson(poop, "confronting-yourself");
			isStoryMode = false;
			storyDifficulty = 1;

			storyWeek = 4;
		}

		if (SONG.song.toLowerCase() == "exploitation")
		{
			Main.toggleFuckedFPS(true);
		}

		theFunne = FlxG.save.data.newInput;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		eyesoreson = FlxG.save.data.eyesores;

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;
		misses = 0;

		// Making difficulty text for Discord Rich Presence.
		storyDifficultyText = CoolUtil.difficultyString();

		// To avoid having duplicate images in Discord assets
		switch (SONG.player2)
		{
			case 'dave' | 'dave-angey':
				iconRPC = 'icon_dave';
			case 'bambi-new' | 'bambi-angey' | 'bambi' | 'bambi-old' | 'bambi-3d' | 'bambi-unfair' | 'expunged':
				iconRPC = 'icon_bambi';
			default:
				iconRPC = 'icon_none';
		}
		switch (SONG.song.toLowerCase())
		{
			case 'splitathon':
				iconRPC = 'icon_both';
		}

		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay Mode: ";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		curStage = "";

		// Updating Discord Rich Presence.
		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camDialogue = new FlxCamera();
		camDialogue.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camDialogue);

		FlxCamera.defaultCameras = [camGame];
		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		theFunne = theFunne && SONG.song.toLowerCase() != 'unfairness' && SONG.song.toLowerCase() != 'exploitation';

		var crazyNumber:Int;
		crazyNumber = FlxG.random.int(0, 5);
		switch (crazyNumber)
		{
			case 0:
				trace("secret dick message ???");
			case 1:
				trace("welcome baldis basics crap");
			case 2:
				trace("Hi, song genie here. You're playing " + SONG.song + ", right?");
			case 3:
				eatShit("this song doesnt have dialogue idiot. if you want this retarded trace function to call itself then why dont you play a song with ACTUAL dialogue? jesus fuck");
			case 4:
				trace("suck my balls");
			case 5:
				trace('i hate sick');
			case 6:
				trace('lmao secret message hahahaha you cant get me hahahahah secret message bambi phone do you want do you want phone phone phone phone');
		}

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = [":gf:Hey, you're pretty cute.", ':bambi:ok now FUCKING sing or break phone.. '];
			case 'house':
				dialogue = CoolUtil.coolTextFile(Paths.txt('house/houseDialogue'));
			case 'insanity':
				dialogue = CoolUtil.coolTextFile(Paths.txt('insanity/insanityDialogue'));
			case 'furiosity':
				dialogue = CoolUtil.coolTextFile(Paths.txt('furiosity/furiosityDialogue'));
			case 'polygonized':
				dialogue = CoolUtil.coolTextFile(Paths.txt('polygonized/polyDialogue'));
			case 'supernovae':
				dialogue = CoolUtil.coolTextFile(Paths.txt('supernovae/supernovaeDialogue'));
			case 'glitch':
				dialogue = CoolUtil.coolTextFile(Paths.txt('glitch/glitchDialogue'));
			case 'blocked':
				dialogue = CoolUtil.coolTextFile(Paths.txt('blocked/retardedDialogue'));
			case 'corn-theft' | 'old-corn-theft':
				dialogue = CoolUtil.coolTextFile(Paths.txt('corn-theft/cornDialogue'));
			case 'maze':
				dialogue = CoolUtil.coolTextFile(Paths.txt('maze/mazeDialogue'));
			case 'splitathon':
				dialogue = CoolUtil.coolTextFile(Paths.txt('splitathon/splitathonDialogue'));
			case 'vs-dave-thanksgiving':
				dialogue = CoolUtil.coolTextFile(Paths.txt('vs-dave-thanksgiving/lmaoDialogue'));
			case 'interdimensional':
				dialogue = CoolUtil.coolTextFile(Paths.txt('interdimensional/interDialogue'));
		}

		var stageCheck:String = 'stage';

		if(SONG.stage == null)
		{
			switch(SONG.song.toLowerCase())
			{
				case 'house' | 'insanity' | 'supernovae':
					stageCheck = 'house';
				case 'polygonized' | 'furiosity':
					stageCheck = 'red-void';
				case 'blocked' | 'corn-theft' | 'old-corn-theft' | 'maze':
					stageCheck = 'farm';
				case 'splitathon' | 'mealie' | 'shredder' | 'greetings' | 'confronting-yourself':
					stageCheck = 'farm-night';
				case 'cheating':
					stageCheck = 'green-void';
				case 'unfairness':
					stageCheck = 'glitchy-void';
				case 'exploitation':
					stageCheck = 'desktop'; 
				case 'kabunga':
					stageCheck = 'exbungo-land';
				case 'interdimensional':
					stageCheck = 'interdimension-void';
				case 'bonus-song' | 'glitch' | 'memory':
					stageCheck = 'house-night';
				case 'secret' | 'overdrive' | 'secret-mod-leak':
					stageCheck = 'house-sunset';
				case 'bananacore':
					stageCheck = 'banana-hell';
				case 'tutorial':
					stageCheck = 'stage';
			}
		}
		else
		{
			stageCheck = SONG.stage;
		}

		if (stageCheck == "desktop")
		{
			dad.x -= 130;
			dad.y -= 100;
		}

		backgroundSprites = createBackgroundSprites(stageCheck);
		switch (SONG.song.toLowerCase())
		{
			case 'supernovae' | 'glitch' | 'secret':
				UsingNewCam = true;
		}
		switch (SONG.song.toLowerCase())
		{
			case 'polygonized' | 'furiosity':
				normalDaveBG = createBackgroundSprites('house-night');
				for (bgSprite in normalDaveBG)
				{
					bgSprite.alpha = 0;
				}
		}
		var gfVersion:String = 'gf';

		if(SONG.gf != null)
		{
			gfVersion = SONG.gf;
		}

		screenshader.waveAmplitude = 1;
		screenshader.waveFrequency = 2;
		screenshader.waveSpeed = 1;
		screenshader.shader.uTime.value[0] = new flixel.math.FlxRandom().float(-100000, 100000);

		var charoffsetx:Float = 0;
		var charoffsety:Float = 0;
		if (formoverride == "bf-pixel" && SONG.song != "Tutorial")
		{
			gfVersion = 'gf-pixel';
			charoffsetx += 300;
			charoffsety += 300;
		}
		gf = new Character(400 + charoffsetx, 130 + charoffsety, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		if (!(formoverride == "bf" || formoverride == "none" || formoverride == "bf-pixel") && SONG.song != "Tutorial" || SONG.song.toLowerCase() == 'memory')
		{
			gf.visible = false;
		}

		dad = new Character(100, 100, SONG.player2);
		switch (SONG.song.toLowerCase())
		{
			default:
				dadmirror = new Character(100, 100, "dave-angey");
		}
		if (SONG.song.toLowerCase() == 'maze')
		{
			tweenTime = sectionStartTime(32);
			for (i in 0...backgroundSprites.members.length)
			{
				var bgSprite = backgroundSprites.members[i];
				var tween:FlxTween = null;
				switch (i)
				{
					case 0:
						tween = FlxTween.tween(bgSprite, {alpha: 0}, tweenTime / 1000);
					case 1:
						tween = FlxTween.tween(bgSprite, {alpha: 1}, tweenTime / 1000).then(FlxTween.tween(bgSprite, {alpha: 0}, tweenTime / 1000));
					case 2:
						tween = FlxTween.tween(bgSprite, {alpha: 0}, tweenTime / 1000).then(FlxTween.tween(bgSprite, {alpha: 1}, tweenTime / 1000));
					default:
						tween = FlxTween.color(bgSprite, tweenTime / 1000, FlxColor.WHITE, sunsetColor).then(
							FlxTween.color(bgSprite, tweenTime / 1000, sunsetColor, nightColor)
							);
				}
				tweenList.push(tween);
			}
			var gfTween = FlxTween.color(gf, tweenTime / 1000, FlxColor.WHITE, sunsetColor).then(FlxTween.color(gf, tweenTime / 1000, sunsetColor, nightColor));
			var bambiTween = FlxTween.color(dad, tweenTime / 1000, FlxColor.WHITE, sunsetColor).then(FlxTween.color(dad, tweenTime / 1000, sunsetColor, nightColor));
			bfTween = FlxTween.color(boyfriend, tweenTime / 1000, FlxColor.WHITE, sunsetColor, {
				onComplete: function(tween:FlxTween)
				{
					bfTween = FlxTween.color(boyfriend, tweenTime / 1000, sunsetColor, nightColor);
				}
			});

			tweenList.push(gfTween);
			tweenList.push(bambiTween);
			tweenList.push(bfTween);
		}

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case "tristan" | 'tristan-golden' | 'tristan-festival':
				dad.y += 350;
				dad.x += 175;

			case 'dave' | 'dave-annoyed' | 'dave-splitathon' | 'dave-cool':
				dad.y += 160;
				dad.x += 250;

			case 'dave-angey':
				dad.y += 0;
				dad.x += 150;
				camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y + 150);

			case 'bambi-3d':
				dad.y += 35;
				camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y + 150);

			case 'bambi-unfair':
				dad.y += 90;
				camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y + 50);

			case 'bambi' | 'bambi-old':
				dad.y += 400;

			case 'bambi-new':
				dad.y += 370;
				dad.x += 150;

			case 'bambi-splitathon':
				dad.x += 175;
				dad.y += 400;

			case 'bambi-angey':
				dad.y += 450;
				dad.x += 100;
		}


		dadmirror.y += 0;
		dadmirror.x += 150;

		dadmirror.visible = false;

		if (formoverride == "none" || formoverride == "bf" || formoverride == SONG.player1)
		{
			boyfriend = new Boyfriend(770, 450, SONG.player1);
		}
		else
		{
			boyfriend = new Boyfriend(770, 450, formoverride);
		}

		switch (boyfriend.curCharacter)
		{
			case "tristan" | 'tristan-golden' | 'tristan-festival':
				boyfriend.y = 100 + 325;
				boyfriendOldIcon = 'tristan';
			case 'dave' | 'dave-annoyed' | 'dave-splitathon' | 'dave-cool':
				boyfriend.y = 100 + 160;
				boyfriendOldIcon = 'dave';
			case 'dave-angey':
				boyfriend.y = 100;
				boyfriendOldIcon = 'dave-angey';
			case 'bambi-3d':
				boyfriend.y = 100 + 350;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi-unfair':
				boyfriend.y = 100 + 575;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi' | 'bambi-old':
				boyfriend.y = 100 + 400;
				boyfriendOldIcon = 'bambi-old';
			case 'bambi-new' | 'bambi-splitathon' | 'bambi-angey':
				boyfriend.y = 100 + 450;
				boyfriendOldIcon = 'bambi-old';
		}

		if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized")
		{
			dad.color = nightColor;
			gf.color = nightColor;
			boyfriend.color = nightColor;
		}

		if (sunsetLevels.contains(curStage))
		{
			dad.color = sunsetColor;
			gf.color = sunsetColor;
			boyfriend.color = sunsetColor;
		}
		
		//repositioning characters
		switch (curStage)
		{
			case 'daveHouse' | 'daveHouse_night' | 'daveHouse_sunset':
				switch (formoverride)
				{
					case 'bambi':
						boyfriend.y -= 50;
					case 'bambi-new':
						boyfriend.y -= 125;
					case 'bambi-splitathon' | 'bambi-angey':
						boyfriend.y -= 25;
					case 'bambi-old':
						boyfriend.y -= 50;
				}
			case 'bambiFarm' | 'bambiFarmNight' | 'bambiFarmSunset':
				switch (formoverride)
				{
					case 'bambi':
						boyfriend.y -= 50;
					case 'bambi-new':
						boyfriend.y -= 125;
					case 'bambi-splitathon' | 'bambi-angey':
						boyfriend.y -= 25;
					case 'bambi-old':
						boyfriend.y -= 50;
					case 'bambi-3d':
						boyfriend.y += 50;
					case 'bambi-unfair':
						boyfriend.y += 50;	
				}
				
			case 'cheating' | 'interdimension':
				switch (formoverride)
				{
					case 'bambi' | 'bambi-new' | 'bambi-splitathon' | 'bambi-angey':
						boyfriend.y -= 100;
					case 'bambi-old':
						boyfriend.y -= 150;
				}
			case 'unfairness':
				switch (formoverride)
				{
					case 'dave' | 'dave-insanity' | 'dave-splitathon' | 'dave-cool':
						boyfriend.y += 100;
					case 'bambi-new':
						boyfriend.y -= 100;
					case 'bambi' | 'bambi-splitathon' | 'bambi-angey':
						boyfriend.y -= 100;
					case 'bambi-old':
						boyfriend.y -= 150;
					case 'bambi-3d':
						boyfriend.y += 100;
					case 'bambi-unfair':
						boyfriend.y += 100;
				}
			case 'kabunga':
				switch (formoverride)
				{
					case 'dave-angey':
						boyfriend.y -= 50;
					case 'bambi-new':
						boyfriend.y -= 100;
					case 'bambi-splitathon':
						boyfriend.y -= 50;
					case 'bambi-angey':
						boyfriend.y -= 100;
					case 'bambi-old':
						boyfriend.y -= 150;
					case 'tristan' | 'tristan-golden' | 'tristan-festival':
						boyfriend.y -= 100;
					case 'bambi-unfair':
						boyfriend.y -= 50;
				}
		}

		add(gf);

		add(dad);
		add(dadmirror);
		add(boyfriend);

		switch (curStage)
		{
			case 'bambiFarm' | 'bambiFarmNight' | 'bambiFarmSunset':
				var sign:FlxSprite = addFarmSign(false);
				add(sign);
				if (SONG.song.toLowerCase() == 'maze')
				{
					var tween = FlxTween.color(sign, tweenTime / 1000, FlxColor.WHITE, sunsetColor).then(
						FlxTween.color(sign, tweenTime / 1000, sunsetColor, nightColor)
						);
					tweenList.push(tween);
				}
		}
		

		if(SONG.song.toLowerCase() == "unfairness" || PlayState.SONG.song.toLowerCase() == 'exploitation')
			health = 2;

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();

		dadStrums = new FlxTypedGroup<FlxSprite>();

		generateSong(SONG.song);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.01);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition)
		{
			var yPos = FlxG.save.data.downscroll ? FlxG.height * 0.9 + 20 : strumLine.y - 20;

			songPosBG = new FlxSprite(0, yPos).loadGraphic(Paths.image('ui/healthBar'));
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);
			
			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), Conductor, 
			'songPosition', 0, FlxG.sound.music.length);
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);
			
			var songName = new FlxText(songPosBG.x, songPosBG.y, 0, SONG.song, 32);
			songName.setFormat(Paths.font("comic.ttf"), 32, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			songName.scrollFactor.set();
			songName.borderSize = 2.5;

			var xValues = CoolUtil.getMinAndMax(songName.width, songPosBG.width);
			var yValues = CoolUtil.getMinAndMax(songName.height, songPosBG.height);
			
			songName.x = songPosBG.x - ((xValues[0] - xValues[1]) / 2);
			songName.y = songPosBG.y + ((yValues[0] - yValues[1]) / 2);

			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('ui/healthBar'));
		if (SONG.song.toLowerCase() == "exploitation")
			healthBarBG.loadGraphic(Paths.image('ui/HELLthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		add(healthBar);

		var credits:String;
		switch (SONG.song.toLowerCase())
		{
			case 'supernovae':
				credits = 'Original Song made by ArchWk!';
			case 'glitch':
				credits = 'Original Song made by DeadShadow and PixelGH!';
			case 'mealie' | 'memory':
				credits = 'Original Song made by Alexander Cooper 19!';
			case 'overdrive':
				credits = 'Original Song made by Top 10 Awesome! lol';
			case 'unfairness':
				credits = "Ghost tapping is forced off! FUCK you!";
			case 'cheating':
				credits = 'Notes are scrambled! FUCK you!';
			case 'exploitation':
				credits = "You won't survive " + CoolSystemStuff.getUsername() + "! SUPER FUCK you!";
			case 'kabunga':
				credits = 'OH MY GOD I JUST DEFLATED';
			case 'bananacore':
				credits = "Song by Cuzsie! (Original song from Golden Apple!)\n(THIS SONG IS NOT CANON)";
			default:
				credits = '';
		}

		var engineName:String = 'stupid';
		switch(FlxG.random.int(0, 2))
	    {
			case 0:
				engineName = 'Dave ';
			case 1:
				engineName = 'Bambi ';
			case 2:
				engineName = 'Tristan ';
		}
		var creditsText:Bool = credits != '';
		var textYPos:Float = healthBarBG.y + 50;
		if (creditsText)
		{
			textYPos = healthBarBG.y + 30;
		}
		
		var funkyText:String;

		switch(SONG.song.toLowerCase())
		{
			default:
				funkyText = SONG.song + " " + (!curSong.toLowerCase().endsWith('splitathon') ? CoolUtil.difficultyString() : "Finale") + ' - Dave Engine 3.0 (KE 1.2)';
			case "exploitation":
				funkyText = SONG.song + " FUCKED - [EXPUNGED] Engine 3.0 (???)";
		}

		if (SONG.song.toLowerCase() == "overdrive")
			funkyText = '';

		var kadeEngineWatermark = new FlxText(4, textYPos, 0, funkyText, 16);

		kadeEngineWatermark.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		kadeEngineWatermark.borderSize = 1.25;
		add(kadeEngineWatermark);
		if (creditsText)
		{
			var creditsWatermark = new FlxText(4, healthBarBG.y + 50, 0, credits, 16);
			creditsWatermark.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			creditsWatermark.scrollFactor.set();
			creditsWatermark.borderSize = 1.25;
			add(creditsWatermark);
			creditsWatermark.cameras = [camHUD];
		}
		switch (curSong.toLowerCase())
		{
			case 'insanity':
				preload('backgrounds/void/redsky');
				preload('backgrounds/void/redsky_insanity');
			case 'bananacore':
				preload('bananacore/characters/Bartholemew');
				preload('bananacore/characters/Cockey');
				preload('bananacore/characters/Kapi');
				preload('bananacore/characters/PizzaMan');
				preload('bananacore/indihome');
				preload('bananacore/kapicuzsie_back');
				preload('bananacore/kapicuzsie_front');
				preload('bananacore/muffin');
				preload('bananacore/sad_bambi');
				preload('bananacore/shaggy from fnf 1');
		}

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + 40, 0, "", 20);
		//scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat((SONG.song.toLowerCase() == "overdrive") ? Paths.font("opensans.ttf") : Paths.font("comic.ttf"), 20, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.5;

		if (SONG.song.toLowerCase() == "overdrive")
		{
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 1.3;
			scoreTxt.y -= 25;
		}
		add(scoreTxt);

		iconP1 = new HealthIcon((formoverride == "none" || formoverride == "bf") ? SONG.player1 : formoverride, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2 == "bambi" ? "bambi-stupid" : SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		kadeEngineWatermark.cameras = [camHUD];

		if (SONG.song.toLowerCase() == 'kabunga')
		{
			lazychartshader.waveAmplitude = 0.03;
			lazychartshader.waveFrequency = 5;
			lazychartshader.waveSpeed = 1;
	
			camHUD.setFilters([new ShaderFilter(lazychartshader.shader)]);
		}

		doof.cameras = [camDialogue];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode || FlxG.save.data.freeplayCuts)
		{
			switch (curSong.toLowerCase())
			{
				case 'house' | 'insanity' | 'furiosity' | 'polygonized' | 'supernovae' | 'glitch' | 'blocked' | 'corn-theft' | 'maze' | 'splitathon' | 'cheating' | 'interdimensional':
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}
		if (SONG.song.toLowerCase() == 'exploitation')
		{
			modchart = ExploitationModchartType.Figure8;
		}
		super.create();
	}

	public function createBackgroundSprites(bgName:String):FlxTypedGroup<BGSprite>
	{
		var sprites:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();
		switch (bgName)
		{
			case 'house' | 'house-night' | 'house-sunset':
				defaultCamZoom = 0.9;
				
				var skyType:String = '';
				var assetType:String = '';
				switch (bgName)
				{
					case 'house':
						curStage = 'daveHouse';
						skyType = 'sky';
					case 'house-night':
						curStage = 'daveHouse_night';
						skyType = 'sky_night';
						assetType = 'night/';
					case 'house-sunset':
						curStage = 'daveHouse_sunset';
						skyType = 'sky_sunset';
				}
								
				var bg:BGSprite = new BGSprite('bg', -600, -200, Paths.image('backgrounds/shared/' + skyType), null, 0.75, 0.75);
				sprites.add(bg);
				add(bg);
				
				var stageHills:BGSprite = new BGSprite('stageHills', -225, -125, Paths.image('backgrounds/dave-house/' + assetType + 'hills'), null, 0.8, 0.8);
				stageHills.setGraphicSize(Std.int(stageHills.width * 1.25));
				stageHills.updateHitbox();
				sprites.add(stageHills);
				add(stageHills);
	
				var gate:BGSprite = new BGSprite('gate', -200, -125, Paths.image('backgrounds/dave-house/' + assetType + 'gate'), null, 0.9, 0.9);
				gate.setGraphicSize(Std.int(gate.width * 1.2));
				gate.updateHitbox();
				sprites.add(gate);
				add(gate);
	
				var stageFront:BGSprite = new BGSprite('stageFront', -175, -125, Paths.image('backgrounds/dave-house/' + assetType + 'grass'), null);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
				stageFront.updateHitbox();
				sprites.add(stageFront);
				add(stageFront);

				if (SONG.song.toLowerCase() == 'insanity')
				{
					var bg:BGSprite = new BGSprite('bg', -600, -200, Paths.image('backgrounds/void/redsky_insanity'), null, 1, 1, true, true);
					bg.alpha = 0.75;
					bg.visible = false;
					add(bg);
					// below code assumes shaders are always enabled which is bad
					voidShader(bg);
				}

				var variantColor = getBackgroundColor();
				
				stageHills.color = variantColor;
				gate.color = variantColor;
				stageFront.color = variantColor;

			case 'farm' | 'farm-night' | 'farm-sunset':
				defaultCamZoom = 0.9;

				switch (bgName.toLowerCase())
				{
					case 'farm-night':
						curStage = 'bambiFarmNight';
					case 'farm-sunset':
						curStage = 'bambiFarmSunset';
					default:
						curStage = 'bambiFarm';
				}
	
				var skyType:String = curStage == 'bambiFarmNight' ? 'sky_night' : curStage == 'bambiFarmSunset' ? 'sky_sunset' : 'sky';
				
				var bg:BGSprite = new BGSprite('bg', -400, 0, Paths.image('backgrounds/shared/' + skyType), null, 0.9, 0.9);
				sprites.add(bg);

				if (SONG.song.toLowerCase() == 'maze')
				{
					var sunsetBG:BGSprite = new BGSprite('sunsetBG', -700, 0, Paths.image('backgrounds/shared/sky_sunset'), null, 0.9, 0.9);
					sunsetBG.alpha = 0;
					add(sunsetBG);
					sprites.add(sunsetBG);

					var nightBG:BGSprite = new BGSprite('nightBG', -700, 0, Paths.image('backgrounds/shared/sky_night'), null, 0.9, 0.9);
					nightBG.alpha = 0;
					add(nightBG);
					sprites.add(nightBG);
				}
				var flatGrass:BGSprite = new BGSprite('flatGrass', 500, 200, Paths.image('backgrounds/farm/gm_flatgrass'), null, 0.9, 0.9);
				sprites.add(flatGrass);
				
				var farmHouse:BGSprite = new BGSprite('farmHouse', -700, 50, Paths.image('backgrounds/farm/farmhouse'), null, 0.9, 1);
				sprites.add(farmHouse);
				
				var path:BGSprite = new BGSprite('path', -700, 500, Paths.image('backgrounds/farm/path'), null);
				sprites.add(path);
				
				var cornMaze:BGSprite = new BGSprite('cornMaze', -300, 200, Paths.image('backgrounds/farm/cornmaze'), null);
				sprites.add(cornMaze);
				
				var cornMaze2:BGSprite = new BGSprite('cornMaze2', 1000, 150, Paths.image('backgrounds/farm/cornmaze2'), null);
				sprites.add(cornMaze2);
				
				var cornBag:BGSprite = new BGSprite('cornBag', 1150, 500, Paths.image('backgrounds/farm/cornbag'), null);
				sprites.add(cornBag);
				
				var variantColor:FlxColor = getBackgroundColor();
				
				flatGrass.color = variantColor;
				farmHouse.color = variantColor;
				path.color = variantColor;
				cornMaze.color = variantColor;
				cornMaze2.color = variantColor;
				cornBag.color = variantColor;
				
				add(bg);
				add(flatGrass);
				add(farmHouse);
				add(path);
				add(cornMaze);
				add(cornMaze2);
				add(cornBag);


			case 'desktop':
				defaultCamZoom = 0.7;
				var expungedBG:BGSprite = new BGSprite('void', -600, -200, '', null, 1, 1, false, true);
				expungedBG.loadGraphic(Paths.image('backgrounds/void/creepyRoom'));
				expungedBG.setPosition(0, 200);
				expungedBG.setGraphicSize(Std.int(expungedBG.width * 3));
				expungedBG.scrollFactor.set();
				sprites.add(expungedBG);
				add(expungedBG);
				voidShader(expungedBG);

				#if desktop					
					var path = Sys.programPath();
					path = path.substr(0,path.length - 10);
					var exe_path:String = "\"" + path + Paths.executable("RunThing") + "\"";
					Sys.command(exe_path); //this will make it run the exe since if you just type a path to an exe as a command it'll run.

					var bgDesktopPath = Sys.getEnv("TEMP") + "\\IAMFORTNITEGAMERHACKER.png";
					var bytes = sys.io.File.getBytes(bgDesktopPath);
					var bg:BGSprite = new BGSprite('desktop', 0, 0, '', null, 1, 1, true, true);
					var data:openfl.display.BitmapData = openfl.display.BitmapData.fromBytes(bytes);
					var graphic:flixel.graphics.FlxGraphic = flixel.graphics.FlxGraphic.fromBitmapData(data);
					
					bg.loadGraphic(graphic);
					bg.setGraphicSize(Std.int(bg.width * 3));
					bg.updateHitbox();
					sprites.add(bg);
					add(bg);
				#end
	
			case 'red-void' | 'green-void' | 'glitchy-void' | 'interdimension-void' | "banana-hell":
				defaultCamZoom = 0.7;

				var bg:BGSprite = new BGSprite('void', -600, -200, '', null, 1, 1, false, true);
				
				switch (bgName.toLowerCase())
				{
					case 'red-void':
						bg.loadGraphic(Paths.image('backgrounds/void/redsky', 'shared'));
						curStage = 'daveEvilHouse';
					case 'green-void':
						bg.loadGraphic(Paths.image('backgrounds/cheating/cheater'));
						curStage = 'cheating';
					case 'glitchy-void':
						bg.loadGraphic(Paths.image('backgrounds/void/scarybg'));
						bg.setPosition(0, 200);
						bg.setGraphicSize(Std.int(bg.width * 3));
						curStage = 'unfairness';
					case 'interdimension-void':
						bg.loadGraphic(Paths.image('backgrounds/void/interdimensionVoid'));
						bg.setPosition(-700, -300);
						curStage = 'interdimension';
					case 'banana-hell': // this is a Cockey moment
						bg.loadGraphic(Paths.image('backgrounds/void/bananaVoid1'));
						bg.setPosition(-700, -300);
						weirdBG = bg;
						curStage = 'banana-land';
				}
				sprites.add(bg);
				add(bg);
				
				voidShader(bg);
			
			
			case 'exbungo-land':
				defaultCamZoom = 0.7;

				var bg:BGSprite = new BGSprite('bg', -850, -350, Paths.image('backgrounds/void/exbongo/Exbongo'), null, 1, 1, true, true);
				sprites.add(bg);
				add(bg);

				var circle:BGSprite = new BGSprite('circle', 100, 300, Paths.image('backgrounds/void/exbongo/Circle'), null);
				sprites.add(circle);	
				add(circle);

				var place:BGSprite = new BGSprite('place', 200, -200, Paths.image('backgrounds/void/exbongo/Place'), null);
				sprites.add(place);	
				add(place);
				
					voidShader(bg);

				curStage = 'kabunga';

			default:
				defaultCamZoom = 0.9;
				curStage = 'stage';

				var bg:BGSprite = new BGSprite('bg', -600, -200, Paths.image('backgrounds/stage/stageback'), null, 0.9, 0.9);
				sprites.add(bg);
				add(bg);
	
				var stageFront:BGSprite = new BGSprite('stageFront', -650, 600, Paths.image('backgrounds/stage/stagefront'), null, 0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				sprites.add(stageFront);
				add(stageFront);
	
				var stageCurtains:BGSprite = new BGSprite('stageCurtains', -500, -300, Paths.image('backgrounds/stage/stagecurtains'), null, 1.3, 1.3);
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				sprites.add(stageCurtains);
				add(stageCurtains);
		}


		// that one cuzsie and kapi part of bananacore
		if (SONG.song.toLowerCase() == "bananacore")
		{
			var bg:BGSprite = new BGSprite('bg', -600, -200, Paths.image('bananacore/kapicuzsie_back'), null, 0.9, 0.9);
			cuzsieKapiBananacore.push(bg);
			add(bg);
			bg.visible = false;
	
			var stageFront:BGSprite = new BGSprite('stageFront', -650, 600, Paths.image('bananacore/kapicuzsie_front'), null, 0.9, 0.9);
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			cuzsieKapiBananacore.push(stageFront);
			add(stageFront);
			stageFront.visible = false;
		}

		return sprites;
	}
	public function getBackgroundColor():FlxColor
	{
		var variantColor:FlxColor = FlxColor.WHITE;
		switch (curStage)
		{
			case 'bambiFarmNight':
				variantColor = nightColor;
			case 'bambiFarmSunset':
				variantColor = sunsetColor;
			case 'daveHouse_sunset':
				variantColor = sunsetColor;
			default:
				variantColor = FlxColor.WHITE;
		}
		return variantColor;
	}
	function addFarmSign(removeSign:Bool):BGSprite
	{
		if (removeSign)
		{
			for (bgSprite in backgroundSprites)
			{
				if (bgSprite.spriteName == 'sign')
				{
					remove(bgSprite);
					backgroundSprites.members.remove(bgSprite);
				}
			}
		}
		var sign:BGSprite = new BGSprite('sign', -50, 600, Paths.image('backgrounds/farm/sign'), null);
		sign.color = getBackgroundColor();
		backgroundSprites.add(sign);
		return sign;
	}

	function schoolIntro(?dialogueBox:DialogueBox, isStart:Bool = true):Void
	{
		inCutscene = true;
		camFollow.setPosition(boyfriend.getGraphicMidpoint().x - 200, dad.getGraphicMidpoint().y - 10);
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var stupidBasics:Float = 1;
		if (isStart)
		{
			FlxTween.tween(black, {alpha: 0}, stupidBasics);
		}
		else
		{
			black.alpha = 0;
			stupidBasics = 0;
		}
		new FlxTimer().start(stupidBasics, function(fuckingSussy:FlxTimer)
		{
			if (dialogueBox != null)
			{
				add(dialogueBox);
			}
			else
			{
				startCountdown();
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function voidShader(background:BGSprite)
	{
		var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
		testshader.waveAmplitude = 0.1;
		testshader.waveFrequency = 5;
		testshader.waveSpeed = 2;
		
		background.shader = testshader.shader;
		curbg = background;
	}
	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle', true);

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();

			if (SONG.song.toLowerCase() == "exploitation")
				introAssets.set('default', ['ui/ready', "ui/set", "ui/go_glitch"]);
			else
				introAssets.set('default', ['ui/ready', "ui/set", "ui/go"]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			var doing_funny:Bool = true;

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)
			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
					if (doing_funny)
					{
						focusOnDadGlobal = false;
						ZoomCam(false);
					}
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
					if (doing_funny)
					{
						focusOnDadGlobal = true;
						ZoomCam(true);
					}
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();
			
					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
					if (doing_funny)
					{
						focusOnDadGlobal = false;
						ZoomCam(false);
					}
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					go.updateHitbox();

					go.screenCenter();
					add(go);

					var sex:Float = 1000;

					if (SONG.song.toLowerCase() == "exploitation")
					{
						sex = 300;
					}

					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / sex, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					if (SONG.song.toLowerCase() == "exploitation")
						FlxG.sound.play(Paths.sound('introGo_weird'), 0.6);
					else
						FlxG.sound.play(Paths.sound('introGo'), 0.6);

					if (doing_funny)
					{
						focusOnDadGlobal = true;
						ZoomCam(true);
					}
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		if (SONG.song.toLowerCase() == "exploitation")
			Application.current.window.title = "EXPUNGED'S REIGN IS HERE, FUCK YOU";

		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
			vocals.play();
		}

		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
		FlxG.sound.music.onComplete = endSong;
		songPosBar.setRange(0, FlxG.sound.music.length);
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);
				var daNoteStyle:String = songNotes[3];

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, gottaHitNote, daNoteStyle);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true,
						gottaHitNote);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}

			}
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int, regenerate:Bool = false, ghMode:Bool = false):Void
	{
		var daKey:Int = switch(ghMode){ case true: 5; case false: 4;}

		if (regenerate)
		{
			switch(player)
			{
				case 0:
					dadStrums.forEach(function(spr:FlxSprite)
					{
						remove(spr);
					});
				case 1:
					playerStrums.forEach(function(spr:FlxSprite)
					{
						remove(spr);
					});
			}
		}

		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			if (!ghMode)
			{
					if (funnyFloatyBoys.contains(dad.curCharacter) && player == 0 || funnyFloatyBoys.contains(boyfriend.curCharacter) && player == 1)
					{
						babyArrow.frames = Paths.getSparrowAtlas('notes/NOTE_assets_3D');
						babyArrow.animation.addByPrefix('green', 'arrowUP');
						babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
		
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
		
						babyArrow.x += Note.swagWidth * Math.abs(i);
						switch (Math.abs(i))
						{
							case 0:
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							case 1:
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
							case 2:
								babyArrow.animation.addByPrefix('static', 'arrowUP');
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
							case 3:
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						}
					}
					else
					{
						switch (curStage)
						{
							default:
								if (SONG.song.toLowerCase() == "overdrive")
									babyArrow.frames = Paths.getSparrowAtlas('notes/OMGtop10awesomehi');
								else
									babyArrow.frames = Paths.getSparrowAtlas('notes/NOTE_assets');

								babyArrow.animation.addByPrefix('green', 'arrowUP');
								babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
								babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
								babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
		
								babyArrow.antialiasing = true;
								babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
		
								babyArrow.x += Note.swagWidth * Math.abs(i);
								switch (Math.abs(i))
								{
									case 0:
										babyArrow.animation.addByPrefix('static', 'arrowLEFT');
										babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
									case 1:
										babyArrow.animation.addByPrefix('static', 'arrowDOWN');
										babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
									case 2:
										babyArrow.animation.addByPrefix('static', 'arrowUP');
										babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
									case 3:
										babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
										babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
								}
						}
					}
					babyArrow.updateHitbox();
					babyArrow.scrollFactor.set();
		
					babyArrow.y -= 10;
					babyArrow.alpha = 0;
					FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
		
					babyArrow.ID = i;
					if (player == 1)
					{
						playerStrums.add(babyArrow);
					}
					else
					{
						dadStrums.add(babyArrow);
					}
		
					babyArrow.animation.play('static');
					babyArrow.x += 50;
					babyArrow.x += ((FlxG.width / 2) * player);
		
					strumLineNotes.add(babyArrow);
			}
			else
			{
				// it IS gh mode
				trace("gutrar helreo");
				
				babyArrow.frames = Paths.getSparrowAtlas('notes/NOTE_assets');
				babyArrow.animation.addByPrefix('green', 'arrowUP');
				babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
				babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
				babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
				babyArrow.animation.addByPrefix('yellow', 'arrowRIGHT');
					
				babyArrow.antialiasing = true;
				babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
		
				babyArrow.x += Note.swagWidth * Math.abs(i);
				switch (Math.abs(i))
				{
					case 0:
						babyArrow.animation.addByPrefix('static', 'arrowLEFT');
						babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
					case 1:
						babyArrow.animation.addByPrefix('static', 'arrowDOWN');
						babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
					case 2:
						babyArrow.animation.addByPrefix('static', 'arrowUP');
						babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
					case 3:
						babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
						babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
						babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
				}
			}
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}
			if (tweenList != null && tweenList.length != 0)
			{
				for (tween in tweenList)
				{
					if (!tween.finished)
					{
						tween.active = false;
					}
				}
			}

			#if desktop
			DiscordClient.changePresence("PAUSED on "
				+ SONG.song
				+ " ("
				+ storyDifficultyText
				+ ") |",
				"Acc: "
				+ truncateFloat(accuracy, 2)
				+ "% | Score: "
				+ songScore
				+ " | Misses: "
				+ misses, iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		
		}

		super.openSubState(SubState);
	}

	public function throwThatBitchInThere(guyWhoComesIn:String = 'bambi', guyWhoFliesOut:String = 'dave')
	{
		hasTriggeredDumbshit = true;
		if(BAMBICUTSCENEICONHURHURHUR != null)
		{
			remove(BAMBICUTSCENEICONHURHURHUR);
		}
		BAMBICUTSCENEICONHURHURHUR = new HealthIcon(guyWhoComesIn, false);
		BAMBICUTSCENEICONHURHURHUR.changeState(iconP2.getState());
		BAMBICUTSCENEICONHURHURHUR.y = healthBar.y - (BAMBICUTSCENEICONHURHURHUR.height / 2);
		add(BAMBICUTSCENEICONHURHURHUR);
		BAMBICUTSCENEICONHURHURHUR.cameras = [camHUD];
		BAMBICUTSCENEICONHURHURHUR.x = -100;
		FlxTween.linearMotion(BAMBICUTSCENEICONHURHURHUR, -100, BAMBICUTSCENEICONHURHURHUR.y, iconP2.x, BAMBICUTSCENEICONHURHURHUR.y, 0.3, true, {ease: FlxEase.expoInOut});
		AUGHHHH = guyWhoComesIn;
		AHHHHH = guyWhoFliesOut;
		new FlxTimer().start(0.3, FlingCharacterIconToOblivionAndBeyond);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;

			if (tweenList != null && tweenList.length != 0)
			{
				for (tween in tweenList)
				{
					if (!tween.finished)
					{
						tween.active = true;
					}
				}
			}
			paused = false;

			if (startTimer.finished)
				{
					#if desktop
					DiscordClient.changePresence(detailsText
						+ " "
						+ SONG.song
						+ " ("
						+ storyDifficultyText
						+ ") ",
						"\nAcc: "
						+ truncateFloat(accuracy, 2)
						+ "% | Score: "
						+ songScore
						+ " | Misses: "
						+ misses, iconRPC, true,
						FlxG.sound.music.length
						- Conductor.songPosition);
					#end
				}
				else
				{
					#if desktop
					DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") ", iconRPC);
					#end
				}
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();
		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	override public function update(elapsed:Float)
	{
		elapsedtime += elapsed;
		if (paused && FlxG.sound.music != null && vocals != null && vocals.playing)
		{
			FlxG.sound.music.pause();
			vocals.pause();
		}
		if (curbg != null)
		{
			if (curbg.active) // only the furiosity background is active
			{
				var shad = cast(curbg.shader, Shaders.GlitchShader);
				shad.uTime.value[0] += elapsed;
			}
		}

		//welcome to 3d sinning avenue
		if(funnyFloatyBoys.contains(dad.curCharacter.toLowerCase()) && canFloat)
		{
			dad.y += (Math.sin(elapsedtime) * 0.4);
		}
		if(funnyFloatyBoys.contains(boyfriend.curCharacter.toLowerCase()) && canFloat)
		{
			boyfriend.y += (Math.sin(elapsedtime) * 0.4);
		}
		/*if(funnyFloatyBoys.contains(dadmirror.curCharacter.toLowerCase()))
		{
			dadmirror.y += (Math.sin(elapsedtime) * 0.6);
		}*/
		if(funnyFloatyBoys.contains(gf.curCharacter.toLowerCase()) && canFloat)
		{
			gf.y += (Math.sin(elapsedtime) * 0.4);
		}

		if (SONG.song.toLowerCase() == 'cheating' && !inCutscene) // fuck you
		{
			playerStrums.forEach(function(spr:FlxSprite)
			{
				spr.x += Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
				spr.x -= Math.sin(elapsedtime) * 1.5;
			});
			dadStrums.forEach(function(spr:FlxSprite)
			{
				spr.x -= Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
				spr.x += Math.sin(elapsedtime) * 1.5;
			});
		}

		if (SONG.song.toLowerCase() == 'exploitation' && !inCutscene && mcStarted) // fuck you
		{
			switch (modchart)
			{
				case ExploitationModchartType.Figure8:
					playerStrums.forEach(function(spr:FlxSprite)
					{
						spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin(elapsedtime + spr.ID + 1) * (FlxG.width * 0.4));
						spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.sin((elapsedtime + spr.ID) * 3) * (FlxG.height * 0.2));
					});
					dadStrums.forEach(function(spr:FlxSprite)
					{
						spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin(elapsedtime + spr.ID + 1) * (FlxG.width * 0.4));
						spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.sin((elapsedtime + spr.ID) * -3) * (FlxG.height * 0.2));
					});
					

				case ExploitationModchartType.RotatingCircle:
					playerStrums.forEach(function(spr:FlxSprite)
					{
						switch (spr.ID)
						{
							case 0:
								spr.x = ((FlxG.width / 2) - (spr.width / 2)) - FlxG.width * 0.3;
								spr.screenCenter(Y);
							case 1:
								spr.y = ((FlxG.height / 2) - (spr.height / 2)) + FlxG.height * 0.3;
								spr.screenCenter(X);
							case 2:
								spr.y = ((FlxG.height / 2) - (spr.height / 2)) - FlxG.height * 0.3;
								spr.screenCenter(X);
							case 3:
								spr.x = ((FlxG.width / 2) - (spr.width / 2)) + FlxG.width * 0.3;
								spr.screenCenter(Y);
						}
					});
					
				case ExploitationModchartType.ScrambledNotes:
					playerStrums.forEach(function(spr:FlxSprite)
					{
						spr.x = (FlxG.width / 2) + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * (60 * (spr.ID + 1));
						spr.x += Math.sin(elapsedtime - 1) * 40;
						spr.y = (FlxG.height / 2) + (Math.sin(elapsedtime - 69.2) * ((spr.ID % 3) == 0 ? 1 : -1)) * (67 * (spr.ID + 1)) - 15;
						spr.y += Math.cos(elapsedtime - 1) * 40;
						spr.x -= 80;
					});
					dadStrums.forEach(function(spr:FlxSprite)
					{
						spr.x = (FlxG.width / 2) + (Math.cos(elapsedtime - 1) * ((spr.ID % 2) == 0 ? -1 : 1)) * (60 * (spr.ID + 1));
						spr.x += Math.sin(elapsedtime - 1) * 40;
						spr.y = (FlxG.height / 2) + (Math.sin(elapsedtime - 63.4) * ((spr.ID % 3) == 0 ? -1 : 1)) * (67 * (spr.ID + 1)) - 15;
						spr.y += Math.cos(elapsedtime - 1) * 40;
						spr.x -= 80;
					});
			}
		}

		if (SONG.song.toLowerCase() == 'unfairness' && !inCutscene) // fuck you x2
		{
			playerStrums.forEach(function(spr:FlxSprite)
			{
				spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((elapsedtime + (spr.ID))) * 300);
				spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos((elapsedtime + (spr.ID))) * 300);
			});
			dadStrums.forEach(function(spr:FlxSprite)
			{
				spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((elapsedtime + (spr.ID)) * 2) * 300);
				spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos((elapsedtime + (spr.ID)) * 2) * 300);
			});
		}
		if (tweenList != null && tweenList.length != 0)
		{
			for (tween in tweenList)
			{
				if (tween.active && !tween.finished)
					tween.percent = FlxG.sound.music.time / tweenTime;
			}
		}

		FlxG.camera.setFilters([new ShaderFilter(screenshader.shader)]); // this is very stupid but doesn't effect memory all that much so
		if (shakeCam && eyesoreson)
		{
			// var shad = cast(FlxG.camera.screen.shader,Shaders.PulseShader);
			FlxG.camera.shake(0.015, 0.015);
		}

		screenshader.shader.uTime.value[0] += elapsed;
		lazychartshader.shader.uTime.value[0] += elapsed;
		if (shakeCam && eyesoreson)
		{
			screenshader.shader.uampmul.value[0] = 1;
		}
		else
		{
			screenshader.shader.uampmul.value[0] -= (elapsed / 2);
		}
		screenshader.Enabled = shakeCam && eyesoreson;

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == boyfriendOldIcon)
			{
				var isBF:Bool = formoverride == 'bf' || formoverride == 'none';
				iconP1.changeIcon(isBF ? SONG.player1 : formoverride);
			}
			else
			{
				iconP1.changeIcon(boyfriendOldIcon);
			}
		}

		super.update(elapsed);

		if (SONG.song.toLowerCase() == "overdrive")
			scoreTxt.text = "score: " + Std.string(songScore);
		else if (SONG.song.toLowerCase() == "exploitation")
			scoreTxt.text = "Scor3: " + (songScore * FlxG.random.int(5,9)) + " | M1ss3s: " + (misses * FlxG.random.int(5,9)) + " | Accuracy: " + (truncateFloat(accuracy, 2) * FlxG.random.int(5,9)) + "% ";
		else
			scoreTxt.text = "Score:" + Std.string(songScore) + " | Misses:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "% ";
		
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;	
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			switch (curSong.toLowerCase())
			{
				case 'supernovae':
					PlayState.SONG = Song.loadFromJson("cheating", "cheating"); // you dun fucked up
					FlxG.save.data.cheatingFound = true;
					shakeCam = false;
					screenshader.Enabled = false;
					FlxG.switchState(new PlayState());
					return;
					// FlxG.switchState(new VideoState('assets/videos/fortnite/fortniteballs.webm', new CrasherState()));
				case 'cheating':
					PlayState.SONG = Song.loadFromJson("unfairness", "unfairness"); // you dun fucked up again
					FlxG.save.data.unfairnessFound = true;
					shakeCam = false;
					screenshader.Enabled = false;
					FlxG.switchState(new PlayState());
					return;
				case 'unfairness':
					shakeCam = false;
					screenshader.Enabled = false;
					FlxG.switchState(new YouCheatedSomeoneIsComing());
					#if desktop
					DiscordClient.changePresence("I have your IP address", null, null, true);
					#end
				case 'glitch':
					PlayState.SONG = Song.loadFromJson("kabunga", "kabunga"); // lol you loser
					FlxG.save.data.exbungoFound = true;
					shakeCam = false;
					screenshader.Enabled = false;
					FlxG.switchState(new PlayState());
					return;
				
				case 'kabunga':
					fancyOpenURL("https://benjaminpants.github.io/muko_firefox/index.html");
					System.exit(0);
				default:
					shakeCam = false;
					screenshader.Enabled = false;
					FlxG.switchState(new ChartingState());
					#if desktop
					DiscordClient.changePresence("Chart Editor", null, null, true);
					#end
			}
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.8)),Std.int(FlxMath.lerp(150, iconP1.height, 0.8)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.8)),Std.int(FlxMath.lerp(150, iconP2.height, 0.8)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.changeState('losing');
		else
			iconP1.changeState('normal');

		if (healthBar.percent > 80)
			iconP2.changeState('losing');
		else
			iconP2.changeState('normal');

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(dad.curCharacter));
		if (FlxG.keys.justPressed.SIX)
			FlxG.switchState(new AnimationDebug(boyfriend.curCharacter));
		if (FlxG.keys.justPressed.THREE)
			FlxG.switchState(new AnimationDebug(gf.curCharacter));
		#end
		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (health <= 0)
		{
			if(!perfectMode)
			{
				boyfriend.stunned = true;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;
	
				vocals.stop();
				FlxG.sound.music.stop();
	
				screenshader.shader.uampmul.value[0] = 0;
				screenshader.Enabled = false;
			}

			if(shakeCam)
			{
				CharacterSelectState.unlockCharacter('bambi-3d');
			}

			if (!shakeCam)
			{
				if(!perfectMode)
				{
					gameOver();
				}
			}
			else
			{
				if (isStoryMode)
				{
					switch (SONG.song.toLowerCase())
					{
						case 'blocked' | 'corn-theft' | 'maze':
							FlxG.openURL("https://www.youtube.com/watch?v=eTJOdgDzD64");
							System.exit(0);
						default:
							if(shakeCam)
							{
								CharacterSelectState.unlockCharacter('bambi-3d');
							}
							FlxG.switchState(new EndingState('rtxx_ending', 'badEnding'));
					}
				}
				else
				{
					if(!perfectMode)
					{
						if(shakeCam)
						{
							CharacterSelectState.unlockCharacter('bambi-3d');
						}
						gameOver();
					}
				}
			}

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (unspawnNotes[0] != null)
		{
			var thing:Int = (SONG.song.toLowerCase() == 'unfairness' || PlayState.SONG.song.toLowerCase() == 'exploitation' ? 15000 : 1500);

			if (unspawnNotes[0].strumTime - Conductor.songPosition < thing)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);
				dunceNote.finishedGenerating = true;

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}
		var currentSection = SONG.notes[Math.floor(curStep / 16)];

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";
					var healthtolower:Float = 0.02;

					if (currentSection != null)
					{
						if (currentSection.altAnim)
							if (SONG.song.toLowerCase() != "cheating")
							{
								altAnim = '-alt';
							}
							else
							{
								healthtolower = 0.005;
							}
					}

					//'LEFT', 'DOWN', 'UP', 'RIGHT'
					var fuckingDumbassBullshitFuckYou:String;
					fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(daNote.noteData)) % 4];
					if(dad.nativelyPlayable)
					{
						switch(notestuffs[Math.round(Math.abs(daNote.noteData)) % 4])
						{
							case 'LEFT':
								fuckingDumbassBullshitFuckYou = 'RIGHT';
							case 'RIGHT':
								fuckingDumbassBullshitFuckYou = 'LEFT';
						}
					}
					dad.playAnim('sing' + fuckingDumbassBullshitFuckYou + altAnim, true);
					dadmirror.playAnim('sing' + fuckingDumbassBullshitFuckYou + altAnim, true);

					cameraMoveOnNote(daNote.noteData, 'dad');
					
					dadStrums.forEach(function(sprite:FlxSprite)
					{
						if (Math.abs(Math.round(Math.abs(daNote.noteData)) % 4) == sprite.ID)
						{
							sprite.animation.play('confirm', true);
							if (sprite.animation.curAnim.name == 'confirm')
							{
								sprite.centerOffsets();
								sprite.offset.x -= 13;
								sprite.offset.y -= 13;
							}
							else
							{
								sprite.centerOffsets();
							}
							sprite.animation.finishCallback = function(name:String)
							{
								sprite.animation.play('static',true);
								sprite.centerOffsets();
							}
						}
					});
					if (UsingNewCam)
					{
						focusOnDadGlobal = true;
						ZoomCam(true);
					}

					switch (SONG.song.toLowerCase())
					{
						case 'cheating':
							health -= healthtolower;
							
						case 'unfairness':
							health -= (healthtolower / 5);
					}
					// boyfriend.playAnim('hit',true);
					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
				var change = FlxG.save.data.downscroll ? -1 : 1;
				switch (SONG.song.toLowerCase())
				{
					case 'unfairness' | 'exploitation':
						if (daNote.MyStrum != null)
							daNote.y = yFromNoteStrumTime(daNote, daNote.MyStrum, FlxG.save.data.downscroll);

					default:
						daNote.y = yFromNoteStrumTime(daNote, strumLine, FlxG.save.data.downscroll);
				}
				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
				var noteStrum:FlxSprite = daNote.MyStrum != null ? daNote.MyStrum : strumLine;
				
				if (daNote.wasGoodHit && daNote.isSustainNote && Conductor.songPosition >= (daNote.strumTime + 10))
				{
					destroyNote(daNote);
				}				
				if (!daNote.wasGoodHit && daNote.mustPress && daNote.finishedGenerating && Conductor.songPosition >= daNote.strumTime + strumTimeFromY(106, daNote))
				{
					if (!devBotplay)
						noteMiss(daNote.noteData);

					vocals.volume = 0;

					destroyNote(daNote);
				}
			});
		}

		ZoomCam(focusOnDadGlobal);

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end

		if (updatevels)
		{
			stupidx *= 0.98;
			stupidy += elapsed * 6;
			if (BAMBICUTSCENEICONHURHURHUR != null)
			{
				BAMBICUTSCENEICONHURHURHUR.x += stupidx;
				BAMBICUTSCENEICONHURHURHUR.y += stupidy;
			}
		}
	}

	function FlingCharacterIconToOblivionAndBeyond(e:FlxTimer = null):Void
	{
		iconP2.changeIcon(AUGHHHH);
		
		BAMBICUTSCENEICONHURHURHUR.changeIcon(AHHHHH);
		BAMBICUTSCENEICONHURHURHUR.changeState(iconP2.getState());
		stupidx = -5;
		stupidy = -5;
		updatevels = true;
	}
	function destroyNote(note:Note)
	{
		note.active = false;
		note.visible = false;
		note.kill();
		notes.remove(note, true);
		note.destroy();
	}
	function yFromNoteStrumTime(note:Note, strumLine:FlxSprite, downScroll:Bool):Float
	{
		var change = downScroll ? -1 : 1;
		return strumLine.y - (Conductor.songPosition - note.strumTime) * (change * 0.45 * FlxMath.roundDecimal(SONG.speed * note.LocalScrollSpeed, 2));
	}
	function strumTimeFromY(yPosition:Float, note:Note):Float
	{
		return yPosition * (yPosition / Conductor.stepCrochet) / (0.45 * FlxMath.roundDecimal(SONG.speed * note.LocalScrollSpeed, 2));
	}

	function ZoomCam(focusondad:Bool):Void
	{
		var bfplaying:Bool = false;
		if (focusondad)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (!bfplaying)
				{
					if (daNote.mustPress)
					{
						bfplaying = true;
					}
				}
			});
			if (UsingNewCam && bfplaying)
			{
				return;
			}
		}
		if (focusondad)
		{
			camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

			switch (dad.curCharacter)
			{
				case 'dave-angey':
					camFollow.y = dad.getMidpoint().y;
			}

			if (SONG.song.toLowerCase() == 'tutorial')
			{
				tweenCamIn();
			}

			bfNoteCamOffset[0] = 0;
			bfNoteCamOffset[1] = 0;

			camFollow.x += dadNoteCamOffset[0];
			camFollow.y += dadNoteCamOffset[1];
		}

		if (!focusondad)
		{
			camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

			switch(boyfriend.curCharacter)
			{
				case 'dave-angey':
					camFollow.y = boyfriend.getMidpoint().y;
				case 'bambi-3d':
					camFollow.x = boyfriend.getMidpoint().x - 375;
					camFollow.y = boyfriend.getMidpoint().y - 550;
				case 'bambi-unfair':
					camFollow.x = boyfriend.getMidpoint().x - 325;
					camFollow.y = boyfriend.getMidpoint().y - 1100;
			}
			dadNoteCamOffset[0] = 0;
			dadNoteCamOffset[1] = 0;

			camFollow.x += bfNoteCamOffset[0];
			camFollow.y += bfNoteCamOffset[1];

			if (SONG.song.toLowerCase() == 'tutorial')
			{
				FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
			}
		}
	}


	function THROWPHONEMARCELLO(e:FlxTimer = null):Void
	{
		STUPDVARIABLETHATSHOULDNTBENEEDED.animation.play("throw_phone");
		new FlxTimer().start(5.5, function(timer:FlxTimer)
		{ 
			FlxG.switchState(new FreeplayState());
		});
	}

	function endSong():Void
	{
		inCutscene = false;
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			trace("score is valid");
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty, characteroverride == "none"
				|| characteroverride == "bf" ? "bf" : characteroverride);
			#end
		}

		// Song Character Unlocks (Story Mode)
		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "splitathon":
					CharacterSelectState.unlockCharacter('dave-splitathon');
					CharacterSelectState.unlockCharacter('bambi-splitathon');
					CharacterSelectState.unlockCharacter('tristan');
				case "insanity":
					CharacterSelectState.unlockCharacter('dave-annoyed');
				case "polygonized":
					CharacterSelectState.unlockCharacter('dave-angey');
				case 'greetings':
					CharacterSelectState.unlockCharacter('tristan-festival');
			}
		}
		// Song Character Unlocks (Freeplay)
		else
		{
			switch (curSong.toLowerCase())
			{
				case "bonus-song":
					CharacterSelectState.unlockCharacter('dave');
				case "mealie":
					CharacterSelectState.unlockCharacter('bambi-angey');
				case "supernovae":
					CharacterSelectState.unlockCharacter('bambi');
				case "cheating":
					CharacterSelectState.unlockCharacter('bambi-3d');
				case "unfairness":
					CharacterSelectState.unlockCharacter('bambi-unfair');
				case "exploitation":
					CharacterSelectState.unlockCharacter('expunged');
			}
		}
	
	

		if (isStoryMode)
		{
			campaignScore += songScore;

			var completedSongs:Array<String> = [];
			var mustCompleteSongs:Array<String> = ['House', 'Insanity', 'Polygonized', 'Blocked', 'Corn-Theft', 'Maze', 'Splitathon'];
			var allSongsCompleted:Bool = true;
			if (FlxG.save.data.songsCompleted == null)
			{
				FlxG.save.data.songsCompleted = new Array<String>();
			}
			completedSongs = FlxG.save.data.songsCompleted;
			completedSongs.push(storyPlaylist[0]);
			for (i in 0...mustCompleteSongs.length)
			{
				if (!completedSongs.contains(mustCompleteSongs[i]))
				{
					allSongsCompleted = false;
					break;
				}
			}
			if (allSongsCompleted && CharacterSelectState.isLocked('tristan-golden'))
			{
				CharacterSelectState.unlockCharacter('tristan-golden');
			}
			FlxG.save.data.songsCompleted = completedSongs;
			FlxG.save.flush();

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				switch (curSong.toLowerCase())
				{
					case 'polygonized':
						CharacterSelectState.unlockCharacter('tristan');
						if (health >= 0.1)
						{
							if (storyDifficulty == 2)
							{
								CharacterSelectState.unlockCharacter('dave-angey');
							}
							FlxG.switchState(new EndingState('goodEnding', 'goodEnding'));
						}
						else if (health < 0.1)
						{
							CharacterSelectState.unlockCharacter('bambi');
							FlxG.switchState(new EndingState('vomit_ending', 'badEnding'));
						}
						else
						{
							FlxG.switchState(new EndingState('badEnding', 'badEnding'));
						}
					case 'maze':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('maze/endDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = function()
						{
							CharacterSelectState.unlockCharacter('bambi-new');
							FlxG.sound.playMusic(Paths.music('freakyMenu'));
							FlxG.switchState(new StoryMenuState());
						};
						doof.cameras = [camDialogue];
						schoolIntro(doof, false);
					case 'splitathon':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('splitathon/splitathonDialogueEnd')));
						doof.scrollFactor.set();
						doof.finishThing = function()
						{
							FlxG.sound.playMusic(Paths.music('freakyMenu'));
							FlxG.switchState(new CreditsMenuState());
						};
						doof.cameras = [camDialogue];
						schoolIntro(doof, false);
					default:
						FlxG.sound.playMusic(Paths.music('freakyMenu'));
						FlxG.switchState(new StoryMenuState());
				}
				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore)
				{
					NGio.unlockMedal(60961);
					Highscore.saveWeekScore(storyWeek, campaignScore,
						storyDifficulty, characteroverride == "none" || characteroverride == "bf" ? "bf" : characteroverride);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{	
				switch (SONG.song.toLowerCase())
				{
					case 'insanity':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('insanity/endDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = nextSong;
						doof.cameras = [camDialogue];
						schoolIntro(doof, false);
					case 'splitathon':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('splitathon/splitathonDialogueEnd')));
						doof.scrollFactor.set();
						doof.finishThing = nextSong;
						doof.cameras = [camDialogue];
						schoolIntro(doof, false);
					case 'glitch':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						var marcello:FlxSprite = new FlxSprite(dad.x - 170, dad.y);
						marcello.flipX = true;
						add(marcello);
						marcello.antialiasing = true;
						marcello.color = 0xFF878787;
						dad.visible = false;
						boyfriend.stunned = true;
						marcello.frames = Paths.getSparrowAtlas('bambi/cutscenes/cutscene');
						marcello.animation.addByPrefix('throw_phone', 'bambi0', 24, false);
						FlxG.sound.play(Paths.sound('break_phone'), 1, false, null, true);
						boyfriend.playAnim('hit', true);
						STUPDVARIABLETHATSHOULDNTBENEEDED = marcello;
						new FlxTimer().start(5.5, THROWPHONEMARCELLO);

					default:
						nextSong();
				}
			}
		}
		else
		{
			if(FlxG.save.data.freeplayCuts)
			{
				switch (SONG.song.toLowerCase())
				{
					case 'glitch':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						var marcello:FlxSprite = new FlxSprite(dad.x - 170, dad.y);
						marcello.flipX = true;
						add(marcello);
						marcello.antialiasing = true;
						marcello.color = 0xFF878787;
						dad.visible = false;
						boyfriend.stunned = true;
						marcello.frames = Paths.getSparrowAtlas('dave/cutscene');
						marcello.animation.addByPrefix('throw_phone', 'bambi0', 24, false);
						FlxG.sound.play(Paths.sound('break_phone'), 1, false, null, true);
						boyfriend.playAnim('hit', true);
						STUPDVARIABLETHATSHOULDNTBENEEDED = marcello;
						new FlxTimer().start(5.5, THROWPHONEMARCELLO);
					case 'insanity':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('insanity/endDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = function()
						{
							FlxG.switchState(new FreeplayState());
						}
						doof.cameras = [camDialogue];
						schoolIntro(doof, false);
					case 'maze':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('maze/endDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = function()
						{
							FlxG.switchState(new FreeplayState());
						}
						doof.cameras = [camDialogue];
						schoolIntro(doof, false);
					case 'splitathon':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('splitathon/splitathonDialogueEnd')));
						doof.scrollFactor.set();
						doof.finishThing = function()
						{
							FlxG.switchState(new FreeplayState());
						}
						doof.cameras = [camDialogue];
						schoolIntro(doof, false);
					default:
						FlxG.switchState(new FreeplayState());
				}
			}
			else
			{
				FlxG.switchState(new FreeplayState());
			}
			
		}
	}

	var endingSong:Bool = false;

	function nextSong()
	{
		var difficulty:String = "";

		switch (storyDifficulty)
		{
			case 0:
				difficulty = '-easy';
			case 2:
				difficulty = '-hard';
		}

		trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		prevCamFollow = camFollow;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
		FlxG.sound.music.stop();
		
		switch (curSong.toLowerCase())
		{
			case 'corn-theft':
				LoadingState.loadAndSwitchState(new VideoState('assets/videos/mazeecutscenee.webm', new PlayState()), false);
			default:
				LoadingState.loadAndSwitchState(new PlayState());
		}
	}
	private function popUpScore(strumtime:Float, note:Note):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 2)
		{
			daRating = 'shit';
			totalNotesHit -= 2;
			score = -3000;
			ss = false;
			shits++;
		}
		else if (noteDiff < Conductor.safeZoneOffset * -2)
		{
			daRating = 'shit';
			totalNotesHit -= 2;
			score = -3000;
			ss = false;
			shits++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.45)
		{
			daRating = 'bad';
			score = -1000;
			totalNotesHit += 0.2;
			ss = false;
			bads++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.25)
		{
			daRating = 'good';
			totalNotesHit += 0.65;
			score = 200;
			ss = false;
			goods++;
		}
		if (daRating == 'sick')
		{
			totalNotesHit += 1;
			sicks++;
		}
		score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[note.noteData], 0), Int);

		var assetPath:String = '';
		switch (note.noteStyle)
		{
			case '3D':
			  assetPath = '3D/';
		}

		if (daRating != 'shit' || daRating != 'bad')
		{
			songScore += score;

			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */

			rating.loadGraphic(Paths.image("ui/" + assetPath + daRating));
			rating.screenCenter();
			rating.x = coolText.x - 40;
			rating.y -= 60;
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);

			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image("ui/" + assetPath + "combo"));
			comboSpr.screenCenter();
			comboSpr.x = coolText.x;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			comboSpr.velocity.x += FlxG.random.int(1, 10);
			add(rating);

			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;

			comboSpr.updateHitbox();
			rating.updateHitbox();

			var seperatedScore:Array<Int> = [];

			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 2)
				seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

			for (i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}

			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image("ui/" + assetPath + "num" + Std.int(i)));
				numScore.screenCenter();
				numScore.x = coolText.x + (43 * daLoop) - 90;
				numScore.y += 80;

				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				numScore.updateHitbox();

				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);

				if (combo >= 10 || combo == 0)
					add(numScore);

				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});

				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */

			coolText.text = Std.string(seperatedScore);
			// add(coolText);

			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();

					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});

			curSection += 1;
		}
	}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
	{
		return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
	}

	var upHold:Bool = false;
	var downHold:Bool = false;
	var rightHold:Bool = false;
	var leftHold:Bool = false;

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];
		var releaseArray:Array<Bool> = [leftR, downR, upR, rightR];

		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			possibleNotes = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote && daNote.finishedGenerating)
				{
					possibleNotes.push(daNote);
				}
			});

			haxe.ds.ArraySort.sort(possibleNotes, function(a, b):Int {
				var notetypecompare:Int = Std.int(a.noteData - b.noteData);

				if (notetypecompare == 0)
				{
					return Std.int(a.strumTime - b.strumTime);
				}
				return notetypecompare;
			});

			

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				if (perfectMode)
					noteCheck(true, daNote);

				// Jump notes
				var lasthitnote:Int = -1;
				var lasthitnotetime:Float = -1;

				for (note in possibleNotes) 
				{
					if (controlArray[note.noteData % 4])
					{
						if (lasthitnotetime > Conductor.songPosition - Conductor.safeZoneOffset
							&& lasthitnotetime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.2)) //reduce the past allowed barrier just so notes close together that aren't jacks dont cause missed inputs
						{
							if ((note.noteData % 4) == (lasthitnote % 4))
							{
								continue; //the jacks are too close together
							}
						}
						lasthitnote = note.noteData;
						lasthitnotetime = note.strumTime;
						goodNoteHit(note);
					}
				}
				
				if (daNote.wasGoodHit)
				{
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			}
			else if (!theFunne)
			{
				if(!inCutscene)
					badNoteCheck(null);
			}
		}

		if ((up || right || down || left) && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					switch (daNote.noteData)
					{
						// NOTES YOU ARE HOLDING
						case 2:
							if (up || upHold)
								goodNoteHit(daNote);
						case 3:
							if (right || rightHold)
								goodNoteHit(daNote);
						case 1:
							if (down || downHold)
								goodNoteHit(daNote);
						case 0:
							if (left || leftHold)
								goodNoteHit(daNote);
					}
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.playAnim('idle');
				
				bfNoteCamOffset[0] = 0;
				bfNoteCamOffset[1] = 0;
			}
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			if (controlArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
			{
				spr.animation.play('pressed');
			}
			if (releaseArray[spr.ID])
			{
				spr.animation.play('static');
			}

			if (spr.animation.curAnim.name == 'confirm')
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (true)
		{
			misses++;	
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');
			if (boyfriend.animation.getByName("singLEFTmiss") != null)
			{
				//'LEFT', 'DOWN', 'UP', 'RIGHT'
				var fuckingDumbassBullshitFuckYou:String;
				fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(direction)) % 4];
				if(!boyfriend.nativelyPlayable)
				{
					switch(notestuffs[Math.round(Math.abs(direction)) % 4])
					{
						case 'LEFT':
							fuckingDumbassBullshitFuckYou = 'RIGHT';
						case 'RIGHT':
							fuckingDumbassBullshitFuckYou = 'LEFT';
					}
				}
				boyfriend.playAnim('sing' + fuckingDumbassBullshitFuckYou + "miss", true);
			}
			else
			{
				boyfriend.color = 0xFF000084;
				//'LEFT', 'DOWN', 'UP', 'RIGHT'
				var fuckingDumbassBullshitFuckYou:String;
				fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(direction)) % 4];
				if(!boyfriend.nativelyPlayable)
				{
					switch(notestuffs[Math.round(Math.abs(direction)) % 4])
					{
						case 'LEFT':
							fuckingDumbassBullshitFuckYou = 'RIGHT';
						case 'RIGHT':
							fuckingDumbassBullshitFuckYou = 'LEFT';
					}
				}
				boyfriend.playAnim('sing' + fuckingDumbassBullshitFuckYou, true);
			}
			updateAccuracy();
		}
	}

	function cameraMoveOnNote(note:Int, character:String)
	{
		var amount:Array<Float> = new Array<Float>();
		var followAmount:Float = FlxG.save.data.noteCamera ? 15 : 0;
		switch (note)
		{
			case 0:
				amount[0] = -followAmount;
				amount[1] = 0;
			case 1:
				amount[0] = 0;
				amount[1] = followAmount;
			case 2:
				amount[0] = 0;
				amount[1] = -followAmount;
			case 3:
				amount[0] = followAmount;
				amount[1] = 0;
		}
		switch (character)
		{
			case 'dad':
				dadNoteCamOffset = amount;
			case 'bf':
				bfNoteCamOffset = amount;
		}
	}

	function badNoteCheck(note:Note = null)
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		if (note != null)
		{
			if(note.mustPress && note.finishedGenerating)
			{
				if (!devBotplay)
					noteMiss(note.noteData);
			}
			return;
		}
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		for (i in 0...controlArray.length)
		{
			if (controlArray[i])
			{
				if (!devBotplay)
					noteMiss(i);
			}	
		}
		updateAccuracy();
	}

	function updateAccuracy()
	{
		if (misses > 0 || accuracy < 96)
			fc = false;
		else
			fc = true;
		totalPlayed += 1;
		accuracy = totalNotesHit / totalPlayed * 100;
	}

	function noteCheck(keyP:Bool, note:Note):Void // sorry lol
	{
		if (keyP)
		{
			goodNoteHit(note);
		}
		else if (!theFunne)
		{
			badNoteCheck(note);
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime, note);
				if (FlxG.save.data.donoteclick)
				{
					FlxG.sound.play(Paths.sound('note_click'));
				}
				combo += 1;

			}
			else
				totalNotesHit += 1;

			health += 0.023;
			
			
			if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized")
			{
				boyfriend.color = nightColor;
			}
			else if (sunsetLevels.contains(curStage))
			{
				boyfriend.color = sunsetColor;
			}
			else if (bfTween == null)
			{
				boyfriend.color = FlxColor.WHITE;
			}
			else
			{
				if (!bfTween.active && !bfTween.finished)
				{
					bfTween.active = true;
				}
				boyfriend.color = bfTween.color;
			}

			//'LEFT', 'DOWN', 'UP', 'RIGHT'
			var fuckingDumbassBullshitFuckYou:String;
			fuckingDumbassBullshitFuckYou = notestuffs[Math.round(Math.abs(note.noteData)) % 4];
			if(!boyfriend.nativelyPlayable)
			{
				switch(notestuffs[Math.round(Math.abs(note.noteData)) % 4])
				{
					case 'LEFT':
						fuckingDumbassBullshitFuckYou = 'RIGHT';
					case 'RIGHT':
						fuckingDumbassBullshitFuckYou = 'LEFT';
				}
			}
			if(boyfriend.curCharacter == 'bambi-unfair' || boyfriend.curCharacter == 'bambi-3d' || boyfriend.curCharacter == 'expunged')
			{
				FlxG.camera.shake(0.0075, 0.1);
				camHUD.shake(0.0045, 0.1);
			}
			boyfriend.playAnim('sing' + fuckingDumbassBullshitFuckYou, true);
			cameraMoveOnNote(note.noteData, 'bf'); 
			if (UsingNewCam)
			{
				focusOnDadGlobal = false;
				ZoomCam(false);
			}

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			note.kill();
			notes.remove(note, true);
			note.destroy();

			updateAccuracy();
		}
	}

	var black:FlxSprite;


	var vineBoomTriggers:Array<Int> = [524, 540, 588, 604, 666, 720, 736, 752, 1088, 1092, 1096, 1100, 1152, 1168, 1172, 1174, 1176, 1180, 2113, 2144, 2176];
	var shag:FlxSprite;
	var indihome:FlxSprite;
	var hideStuff:FlxSprite;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
			resyncVocals();
	
		switch (SONG.song.toLowerCase())
		{
			case 'splitathon':
				switch (curStep)
				{
					case 4750:
						dad.canDance = false;
						dad.playAnim('scared', true);
						camHUD.shake(0.015, (Conductor.stepCrochet / 1000) * 50);
					case 4800:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('dave', 'what');
						addSplitathonChar("bambi-splitathon");
						if (!hasTriggeredDumbshit)
						{
							throwThatBitchInThere('bambi-splitathon', 'dave-splitathon');
						}
					case 5824:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('bambi', 'umWhatIsHappening');
						addSplitathonChar("dave-splitathon");
						if (!hasTriggeredDumbshit)
						{
							throwThatBitchInThere('dave-splitathon', 'bambi-splitathon');
						}
					case 6080:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('dave', 'happy');
						addSplitathonChar("bambi-splitathon");
						if (!hasTriggeredDumbshit)
						{
							throwThatBitchInThere('bambi-splitathon', 'dave-splitathon');
						}
					case 8384:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('bambi', 'yummyCornLol');
						addSplitathonChar("dave-splitathon");
						if (!hasTriggeredDumbshit)
						{
							throwThatBitchInThere('dave-splitathon', 'bambi-splitathon');
						}
					case 4799 | 5823 | 6079 | 8383:
						hasTriggeredDumbshit = false;
						updatevels = false;
				}

			case 'insanity':
				switch (curStep)
				{
					case 660 | 680:
						FlxG.sound.play(Paths.sound('static'), 0.1);
						dad.visible = false;
						dadmirror.visible = true;
						curbg.visible = true;
						iconP2.changeIcon(dadmirror.curCharacter);
					case 664 | 684:
						dad.visible = true;
						dadmirror.visible = false;
						curbg.visible = false;
						iconP2.changeIcon(dad.curCharacter);
					case 1176:
						FlxG.sound.play(Paths.sound('static'), 0.1);
						dad.visible = false;
						dadmirror.visible = true;
						curbg.loadGraphic(Paths.image('dave/redsky'));
						curbg.alpha = 1;
						curbg.visible = true;
						iconP2.changeIcon(dadmirror.curCharacter);
					case 1180:
						dad.visible = true;
						dadmirror.visible = false;
						iconP2.changeIcon(dad.curCharacter);
						dad.canDance = false;
						dad.animation.play('scared', true);
				}

			case 'interdimensional':
				switch(curStep)
				{
					case 378:
						FlxG.camera.fade(FlxColor.WHITE, 0.3, false);
					case 384:
						black = new FlxSprite(0,0).makeGraphic(2560, 1440, FlxColor.BLACK);
						black.screenCenter();
						black.alpha = 0.4;
						add(black);
						defaultCamZoom += 0.2;
						FlxG.camera.fade(FlxColor.WHITE, 0.5, true);
					case 512:
						defaultCamZoom -= 0.1;
					case 639:
						FlxG.camera.flash(FlxColor.WHITE, 0.3, false);
						defaultCamZoom -= 0.1; // pooop
						FlxTween.tween(black, {alpha: 0}, 0.5, 
						{
							onComplete: function(tween:FlxTween)
							{
								remove(black);
							}
						});
				}

			case 'unfairness':
				switch(curStep)
				{
					case 2560:					
						dadStrums.forEach(function(spr:FlxSprite)
						{
							FlxTween.tween(spr, {alpha: 0}, 6);
						});
					case 2688:
						playerStrums.forEach(function(spr:FlxSprite)
						{
							FlxTween.tween(spr, {alpha: 0}, 6);
						});

					case 3072:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						dad.visible = false;
						iconP2.visible = false;
				}	
			case 'furiosity':
				switch (curStep)
				{
					case 512 | 768:
						shakeCam = true;
					case 640 | 896:
						shakeCam = false;
					case 1305:
						boyfriend.canDance = false;
						gf.canDance = false;
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
						for (bgSprite in backgroundSprites)
						{
							FlxTween.tween(bgSprite, {alpha: 0}, 1);
						}
						for (bgSprite in normalDaveBG)
						{
							FlxTween.tween(bgSprite, {alpha: 1}, 1);
						}
						canFloat = false;
						var position = dad.getPosition();
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						remove(dad);
						dad = new Character(position.x, position.y, 'dave', false);
						add(dad);
						FlxTween.color(dad, 0.6, dad.color, nightColor);
						FlxTween.color(boyfriend, 0.6, boyfriend.color, nightColor);
						FlxTween.color(gf, 0.6, gf.color, nightColor);
						FlxTween.linearMotion(dad, dad.x, dad.y, 350, 260, 0.6, true);
				}
			case 'polygonized':
				switch(curStep)
				{
					case 1024 | 1312 | 1424 | 1552 | 1664:
						shakeCam = true;
						camZooming = true;
					case 1152 | 1408 | 1472 | 1600 | 2048 | 2176:
						shakeCam = false;
						camZooming = false;
					case 2432:
						boyfriend.canDance = false;
						gf.canDance = false;
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
				}
			case 'glitch':
				switch (curStep)
				{
					case 480 | 681 | 1390 | 1445 | 1515 | 1542 | 1598 | 1655:
						shakeCam = true;
						camZooming = true;
					case 512 | 688 | 1420 | 1464 | 1540 | 1558 | 1608 | 1745:
						shakeCam = false;
						camZooming = false;
				}
			case 'mealie':
				switch (curStep)
				{
					case 1776:
						var position = dad.getPosition();
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						remove(dad);
						dad = new Character(position.x, position.y, 'bambi-angey', false);
						dad.color = nightColor;
						iconP2.changeIcon('bambi-angey');
						add(dad);
				}
			case 'bananacore':
				switch (curStep)
				{
					case 480:
						remove(dad);
						dad = new Character(dad.x, dad.y, 'bartholemew', false);
						add(dad);
						trace("Bartholemew");
					case 512:
						remove(dad);
						dad = new Character(dad.x, dad.y, SONG.player2, false);
						add(dad);
					case 768:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						weirdBG.loadGraphic(Paths.image('backgrounds/void/bananaVoid2'));
						trace("Phase 2");
					case 1530:
						shag = new FlxSprite().loadGraphic(Paths.image("bananacore/shaggy from fnf 1", 'shared'));
						shag.screenCenter();
						shag.alpha = 0;
						add(shag);
						trace("Shaggy Fade In");
						FlxTween.tween(shag, {alpha: 1}, 5);
					case 1550:
						remove(shag);
					case 1642:
						for (sprite in cuzsieKapiBananacore)
						{
							sprite.visible = true;
						}
						remove(dad);
						dad = new Character(dad.x, dad.y, "bananacore-kapi", false);
						add(dad);

						trace("Kapi BG");
					case 1664:
						for (sprite in cuzsieKapiBananacore)
						{
							sprite.visible = false;
						}
						remove(dad);
						dad = new Character(dad.x, dad.y, SONG.player2, false);
						add(dad);

						trace("Reset Kapi BG");
					case 1808:
						FlxG.camera.zoom += 1;
					case 1856:
						trace("BF Float");
						FlxTween.tween(boyfriend, {y: boyfriend.y - 700}, 5);
					case 1983:
						boyfriend.y = boyfriend.y + 700;
						FlxG.camera.flash(FlxColor.WHITE, 1);
						weirdBG.loadGraphic(Paths.image('backgrounds/void/bananaVoid3'));
						trace("Phase 3");
					case 2624:
						indihome = new FlxSprite().loadGraphic(Paths.image("bananacore/indihome", 'shared'));
						indihome.screenCenter();
						indihome.cameras = [camHUD];
						add(indihome);
						trace("Indihome");
					case 2688:
						remove(indihome);
					case 2818 | 2944:
						remove(dad);
						dad = new Character(dad.x, dad.y, "bambi-new", false);
						add(dad);
					case 2848 | 2972:
						remove(dad);
						dad = new Character(dad.x, dad.y, SONG.player2, false);
						add(dad);
					case 2912:
						remove(dad);
						dad = new Character(dad.x, dad.y, "expunged", false);
						add(dad);
					case 2989:
						remove(dad);
						dad = new Character(dad.x, dad.y, "ayo-the-pizza-here", false);
						add(dad);

						dad.playAnim('pizza');

						trace("Ayo the pizza here");
					case 3008:
						remove(dad);
						dad = new Character(dad.x, dad.y, SONG.player2, false);
						add(dad);
					case 3200:
						// re-using indihome bc im lazy as fuck
						indihome = new FlxSprite().loadGraphic(Paths.image("bananacore/muffin", 'shared'));
						indihome.screenCenter();
						indihome.cameras = [camHUD];
						add(indihome);

						trace("EGG McMuffin");
					case 3328:
						remove(indihome);
						camHUD.visible = false;
						boyfriend.playAnim("firstDeath");

						trace("Death Animation");
					case 3360:
						boyfriend.playAnim("deathLoop");

						trace("Death Loop");
					case 3392:
						camHUD.visible = true;
						boyfriend.playAnim("idle");
					case 3696:
						hideStuff = new FlxSprite().makeGraphic(2560, 1440, FlxColor.BLACK);
						hideStuff.screenCenter();
						add(hideStuff);
						camHUD.visible = false;
					case 3728:
						camHUD.visible = true;
						camHUD.alpha = 0;

						dadStrums.forEach(function(spr:FlxSprite)
						{
							spr.alpha = 0;
						});

						FlxTween.tween(camHUD, {alpha: 1}, 3);
				}

				// Vinebooms
				for (trigger in vineBoomTriggers)
				{
					if (curStep == trigger)
					{
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						var sadBamb:FlxSprite = new FlxSprite().loadGraphic(Paths.image("bananacore/sad_bambi", 'shared'));
						sadBamb.screenCenter();
						sadBamb.cameras = [camHUD];
						add(sadBamb);

						FlxTween.tween(sadBamb, {alpha: 0}, 1, {onComplete: function(tween:FlxTween)
						{
							remove(sadBamb);
						}});
					}
				}

			case "exploitation":
				switch(curStep)
				{
					case 64 | 1024:
						FlxTween.tween(camHUD, {alpha: 0}, 3);
						FlxTween.tween(boyfriend, {alpha: 0}, 3);
						FlxTween.tween(gf, {alpha: 0}, 3);
						defaultCamZoom = FlxG.camera.zoom + 0.3;
						FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.3}, 4);

						for (spr in backgroundSprites)
						{
							FlxTween.tween(spr, {alpha: 0}, 3);
						}
					case 256 | 1152:
						FlxTween.tween(camHUD, {alpha: 1}, 0.2);
						defaultCamZoom = FlxG.camera.zoom - 0.3;
						FlxTween.tween(boyfriend, {alpha: 1}, 0.2);
						FlxTween.tween(gf, {alpha: 1}, 0.2);
						FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom - 0.3}, 0.2);
						for (spr in backgroundSprites)
						{
							FlxTween.tween(spr, {alpha: 1}, 0.2);
						}
						mcStarted = true;

					case 368 | 1648:
						FlxTween.tween(FlxG.camera, {angle: 10}, 0.1);
					case 376 | 1656:
						FlxTween.tween(FlxG.camera, {angle: -10}, 0.1);
					case 384:
						FlxTween.tween(FlxG.camera, {angle: 0}, 0.2);
				}

			case "confronting-yourself":
				switch(curStep)
				{
					case 69 /*nice*/:
						for (spr in backgroundSprites)
						{
							FlxTween.tween(spr, {alpha: 0}, 2);
						}
				}
				
		}
		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"Acc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC, true,
			FlxG.sound.music.length
			- Conductor.songPosition);
		#end
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		var currentSection = SONG.notes[Std.int(curStep / 16)];
		if (!UsingNewCam)
		{
			if (generatedMusic && currentSection != null)
			{
				if (curBeat % 4 == 0)
				{
					// trace(currentSection.mustHitSection);
				}

				focusOnDadGlobal = !currentSection.mustHitSection;
				ZoomCam(!currentSection.mustHitSection);
			}
		}
		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (currentSection != null)
		{
			if (currentSection.changeBPM)
			{
				Conductor.changeBPM(currentSection.bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);
		}
		if (dad.animation.finished)
		{
			switch (SONG.song.toLowerCase())
			{
				case 'tutorial':
					dad.dance();
					dadmirror.dance();
				default:
					if (dad.holdTimer <= 0 && curBeat % 2 == 0)
					{
						dad.dance();
						dadmirror.dance();

						dadNoteCamOffset[0] = 0;
						dadNoteCamOffset[1] = 0;
					}
			}
		}

		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0 || (SONG.song.toLowerCase() == 'memory' && curBeat >= 416 && curBeat <= 672))
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		switch (curSong.toLowerCase())
		{
			case 'furiosity':
				if ((curBeat >= 128 && curBeat < 160) || (curBeat >= 192 && curBeat < 224))
				{
					if (camZooming)
					{
						FlxG.camera.zoom += 0.015;
						camHUD.zoom += 0.03;
					}
				}
				switch (curBeat)
				{
					case 127 | 191:
						camZooming = true;
					case 159 | 223:
						camZooming = false;
				}
			case 'polygonized':
				switch (curBeat)
				{
					case 608:
						for (bgSprite in backgroundSprites)
						{
							FlxTween.tween(bgSprite, {alpha: 0}, 1);
						}
						for (bgSprite in normalDaveBG)
						{
							FlxTween.tween(bgSprite, {alpha: 1}, 1);
						}
						canFloat = false;
						var position = dad.getPosition();
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						remove(dad);
						dad = new Character(position.x, position.y, 'dave', false);
						add(dad);
						FlxTween.color(dad, 0.6, dad.color, nightColor);
						FlxTween.color(boyfriend, 0.6, boyfriend.color, nightColor);
						FlxTween.color(gf, 0.6, gf.color, nightColor);
						FlxTween.linearMotion(dad, dad.x, dad.y, 350, 260, 0.6, true);
				}
			case 'memory':
				switch (curBeat)
				{
					case 416:
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						var dadPosition = dad.getPosition();
						remove(dad);
						dad = new Character(dadPosition.x, dadPosition.y, 'dave-annoyed');
						dad.color = nightColor;
						iconP2.changeIcon('dave-annoyed');
						add(dad);
				}
		}
		if (shakeCam)
		{
			gf.playAnim('scared', true);
		}

		var funny:Float = (healthBar.percent * 0.01) + 0.01;

		//health icon bounce but epic
		iconP1.setGraphicSize(Std.int(iconP1.width + (50 * funny)),Std.int(iconP2.height - (25 * funny)));
		iconP2.setGraphicSize(Std.int(iconP2.width + (50 * (2 - funny))),Std.int(iconP2.height - (25 * (2 - funny))));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			if (!shakeCam)
			{
				gf.dance();
			}
		}

		if(curBeat % 2 == 0)
		{
			if (!boyfriend.animation.curAnim.name.startsWith("sing") && boyfriend.canDance)
			{
				boyfriend.playAnim('idle', true);
				if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized")
				{
					boyfriend.color = nightColor;
				}
				else if(sunsetLevels.contains(curStage))
				{
					boyfriend.color = sunsetColor;
				}
				else if (bfTween == null)
				{
					boyfriend.color = FlxColor.WHITE;
				}
				else
				{
					if (!bfTween.active && !bfTween.finished)
					{
						bfTween.active = true;
					}
					boyfriend.color = bfTween.color;
				}
			}
		}

		if (curBeat % 8 == 7 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf') // fixed your stupid fucking code ninjamuffin this is literally the easiest shit to fix like come on seriously why are you so dumb
		{
			dad.playAnim('cheer', true);
			boyfriend.playAnim('hey', true);
		}
	}
	function gameOver()
	{
		var chance = FlxG.random.int(0, 99);
		if (chance <= 4 && eyesoreson)
		{
			openSubState(new TheFunnySubState(formoverride == "bf" || formoverride == "none" ? SONG.player1 : formoverride));
			#if desktop
				DiscordClient.changePresence("GAME OVER -- "
				+ SONG.song
				+ " ("
				+ storyDifficultyText
				+ ") ",
				"\n what", iconRPC);
			#end
		}
		else
		{
			#if desktop
			if (SONG.song.toLowerCase() == 'exploitation')
			{
				var expungedLines:Array<String> = 
				['i found you', 
				"you'll never beat me", 
				'HAHAHHAHAHA', 
				"punishment day is here, this one is removing you",
				"I'M UNSTOPPABLE",
				"YOU LIAR...YOU LIAR!"];

				var path = Sys.getEnv("TEMP") + "/HELLO.txt";

				var randomLine = new FlxRandom().int(0, expungedLines.length);
				File.saveContent(path, expungedLines[randomLine]);
				Sys.command("start " + path);
			}
			#end
			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y,
			formoverride == "bf" || formoverride == "none" ? SONG.player1 : formoverride));
			#if desktop
				DiscordClient.changePresence("GAME OVER -- "
				+ SONG.song
				+ " ("
				+ storyDifficultyText
				+ ") ",
				"\nAcc: "
				+ truncateFloat(accuracy, 2)
				+ "% | Score: "
				+ songScore
				+ " | Misses: "
				+ misses, iconRPC);
			#end
		}
		
	}

	function eatShit(ass:String):Void
	{
		if (dialogue[0] == null)
		{
			trace(ass);
		}
		else
		{
			trace(dialogue[0]);
		}
	}

	public function addSplitathonChar(char:String):Void
	{
		boyfriend.stunned = true; //hopefully this stun stuff should prevent BF from randomly missing a note
		remove(dad);
		dad = new Character(100, 100, char);
		add(dad);
		dad.color = nightColor;
		switch (dad.curCharacter)
		{
			case 'dave-splitathon':
				{
					dad.y += 175;
					dad.x += 250;
				}
			case 'bambi-splitathon':
				{
					dad.x += 200;
					dad.y += 450;
				}
		}

		var sign:FlxSprite = addFarmSign(true);
		add(sign);

		boyfriend.stunned = false;
		
	}

	public function splitathonExpression(character:String, expression:String):Void
	{
		boyfriend.stunned = true; //hopefully this stun stuff should prevent BF from randomly missing a note
		//stupid bullshit cuz i dont wanna bother with removing thing erighkjrehjgt
		if(splitathonCharacterExpression != null)
		{
			remove(splitathonCharacterExpression);
		}
		switch (character)
		{
			case 'dave':
				splitathonCharacterExpression = new Character(0, 275, 'dave-splitathon');
			case 'bambi':
				splitathonCharacterExpression = new Character(0, 550, 'bambi-splitathon');
		}
		add(splitathonCharacterExpression);

		var sign:FlxSprite = addFarmSign(true);
		add(sign);
		
		splitathonCharacterExpression.color = nightColor;
		splitathonCharacterExpression.canDance = false;
		splitathonCharacterExpression.playAnim(expression, true);
		boyfriend.stunned = false;
	}

	public function preload(graphic:String) //preload assets
	{
		if (boyfriend != null)
		{
			boyfriend.stunned = true;
		}
		var newthing:FlxSprite = new FlxSprite(9000,-9000).loadGraphic(Paths.image(graphic));
		add(newthing);
		remove(newthing);
		if (boyfriend != null)
		{
			boyfriend.stunned = false;
		}
	}

	function sectionStartTime(section:Int):Float
	{
		var daBPM:Int = SONG.bpm;
		var daPos:Float = 0;
		for (i in 0...section)
		{
			daPos += 4 * (1000 * 60 / daBPM);
		}
		return daPos;
	}
}
enum ExploitationModchartType
{
	Figure8; RotatingCircle; ScrambledNotes;
}