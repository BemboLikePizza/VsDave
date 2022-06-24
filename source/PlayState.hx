package;

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

	public static var darkLevels:Array<String> = ['bambiFarmNight', 'daveHouse_night', 'unfairness', 'johnland i think'];
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

	var funnyFloatyBoys:Array<String> = ['dave-angey', 'bambi-3d', 'expunged', 'bambi-unfair', 'exbungo', 'cockey', 'pissey', 'pooper', 'shartey'];

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
	public static var shakeCam:Bool = false;
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
	var revertedBG:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();
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

	var video:MP4Handler;
	public var modchart:ExploitationModchartType;
	var weirdBG:FlxSprite;
	var cuzsieKapiEletricCockadoodledoo:Array<FlxSprite> = [];
	var cockeyHat:BGSprite;

	var mcStarted:Bool = false;
	public static var devBotplay:Bool = false;
	public var creditsPopup:CreditsPopUp;
	public var blackScreen:FlxSprite;

	var interdimensionBG:BGSprite;
	var currentInterdimensionBG:String;
	var nimbiLand:BGSprite;
	var nimbi:BGSprite;

	var vcr:VCRDistortionShader;

	var place:BGSprite;

	var stageCheck:String = 'stage';

	// FUCKING UHH particles
	var _emitter:FlxEmitter;
	var smashPhone:Array<Int> = new Array<Int>();
	
	public var hasDialogue:Bool = true;

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
	var daveSongs:Array<String> = ['House', 'Insanity', 'Polygonized', 'Bonus Song', 'Furiosity'];
	var bambiSongs:Array<String> = ['Blocked', 'Corn-Theft', 'Maze', 'Mealie'];
	var tristanSongs:Array<String> = ['Adventure', 'Vs-Tristan'];

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
	var rotateCamToRight:Bool;
	var camRotateAngle:Float = 0;

	var rotatingCamTween:FlxTween;

	//explpit
	var expungedBG:BGSprite;
	public static var scrollType:String;

	static var DOWNSCROLL_Y:Float;
	static var UPSCROLL_Y:Float;

	var switchSide:Bool;

	public var subtitleManager:SubtitleManager;
	
	override public function create()
	{
		instance = this;	

		if ((SONG.song.toLowerCase() == "greetings" || SONG.song.toLowerCase() == "adventure") && characteroverride.toLowerCase() == "tristan")
		{
			var poop:String = Highscore.formatSong("Confronting-Yourself", 1);

			SONG = Song.loadFromJson(poop, "Confronting-Yourself");
			isStoryMode = false;
			storyDifficulty = 1;

			storyWeek = 4;
		}
		switch (SONG.song.toLowerCase())
		{
			case 'exploitation':
				var programPath:String = Sys.programPath();
				var textPath = programPath.substr(0, programPath.length - CoolSystemStuff.executableFileName().length) + "help me.txt";
	
				if (FileSystem.exists(textPath))
				{
					FileSystem.deleteFile(textPath);
				}
				Main.toggleFuckedFPS(true);
				modchart = ExploitationModchartType.None;
			case 'recursed':
				daveBG = MainMenuState.randomizeBG();
				bambiBG = MainMenuState.randomizeBG();
				tristanBG = MainMenuState.randomizeBG();
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

		// DIALOGUE STUFF
		// Hi guys i know yall are gonna try to add more dialogue here, but with this new system, all you have to do is add a dialogue file with the name of the song in the assets/data/dialogue folder,
		// and it will automatically get the dialogue in this function
		if (FileSystem.exists(Paths.txt('dialogue/${SONG.song.toLowerCase()}')))
		{
			dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/${SONG.song.toLowerCase()}'));
		}
		else
		{
			hasDialogue = false;
		}

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
				case 'splitathon' | 'mealie' | 'shredder' | 'greetings' | 'confronting-yourself' | 'rano':
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
				case 'secret' | 'overdrive':
					stageCheck = 'house-sunset';
				case 'electric-cockaldoodledoo':
					stageCheck = 'banana-hell';
				case 'vs-dave-rap':
					stageCheck = 'rapBattle';
				case 'recursed':
					stageCheck = 'freeplay';
				case 'secret-mod-leak':
					stageCheck = 'roof';
				case 'tutorial':
					stageCheck = 'stage';
			}
		}
		else
		{
			stageCheck = SONG.stage;
		}
		backgroundSprites = createBackgroundSprites(stageCheck, false);
		switch (SONG.song.toLowerCase())
		{
			case 'supernovae' | 'glitch' | 'secret':
				UsingNewCam = true;
		}
		switch (SONG.song.toLowerCase())
		{
			case 'polygonized' | 'furiosity' | 'interdimensional':
				var stage = SONG.song.toLowerCase() != 'interdimensional' ? 'house-night' : 'farm-night';
				revertedBG = createBackgroundSprites(stage, true);
				for (bgSprite in revertedBG)
				{
					bgSprite.color = getBackgroundColor(SONG.song.toLowerCase() != 'interdimensional' ? 'daveHouse_night' : 'bambiFarmNight');
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

		if (!(formoverride == "bf" || formoverride == "none" || formoverride == "bf-pixel") && SONG.song != "Tutorial" || SONG.song.toLowerCase() == 'memory' || SONG.song.toLowerCase() == 'secret-mod-leak')
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
				dad.y += 450;
				dad.x += 200;

			case 'bambi-splitathon':
				dad.x += 175;
				dad.y += 400;

			case 'bambi-angey':
				dad.y += 450;
				dad.x += 100;
			case 'recurser':
				dad.y -= 150;
				dad.x -= 700;
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
			if (darkLevels.contains(curStage) && formoverride == 'tristan-golden')
			{
				formoverride = 'tristan-golden-glowing';
			}
			boyfriend = new Boyfriend(770, 450, formoverride);
		}
		switch (boyfriend.curCharacter)
		{
			case "tristan" | 'tristan-golden' | 'tristan-festival' | 'tristan-golden-glowing':
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
					case 'tristan' | 'tristan-golden' | 'tristan-festival' | 'tristan-golden-glowing':
						boyfriend.y -= 100;
					case 'bambi-unfair':
						boyfriend.y -= 50;
				}
		}

		add(gf);

		add(dad);
		add(dadmirror);
		add(boyfriend);

		switch (stageCheck)
		{
			case 'desktop':
				dad.x -= 500;
				dad.y -= 100;
			case 'banana-hell':
				dad.x -= 600;
			case 'roof':
				dad.setPosition(200, 300);
				boyfriend.setPosition(700, 100);
		}
		switch (curStage)
		{
			case 'bambiFarm' | 'bambiFarmNight' | 'bambiFarmSunset' | 'interdimension-void':
				var sign:BGSprite = addFarmSign(false);
				add(sign);
				switch (SONG.song.toLowerCase())
				{
					case 'maze':
						var tween = FlxTween.color(sign, tweenTime / 1000, FlxColor.WHITE, sunsetColor).then(
							FlxTween.color(sign, tweenTime / 1000, sunsetColor, nightColor)
							);
						tweenList.push(tween);
					case 'interdimensional':
						sign.alpha = 0;
						revertedBG.add(sign);
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

		UPSCROLL_Y = 50;
		DOWNSCROLL_Y = FlxG.height - 165;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		if (scrollType == 'downscroll')
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
			var yPos = scrollType == 'downscroll' ? FlxG.height * 0.9 + 20 : strumLine.y - 20;

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
			songName.antialiasing = true;

			var xValues = CoolUtil.getMinAndMax(songName.width, songPosBG.width);
			var yValues = CoolUtil.getMinAndMax(songName.height, songPosBG.height);
			
			songName.x = songPosBG.x - ((xValues[0] - xValues[1]) / 2);
			songName.y = songPosBG.y + ((yValues[0] - yValues[1]) / 2);

			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		var healthBarPath = SONG.song.toLowerCase() == 'exploitation' ? Paths.image('ui/HELLthBar') : Paths.image('ui/healthBar');

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(healthBarPath);
		if (scrollType == 'downscroll')
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(dad.barColor, boyfriend.barColor);
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
				credits = "You won't survive " + (!FlxG.save.data.selfAwareness ? CoolSystemStuff.getUsername() : 'Boyfriend') + "!";
			case 'kabunga':
				credits = 'OH MY GOD I JUST DEFLATED';
			case 'electric-cockaldoodledoo':
				credits = "Song by Cuzsie! (THIS SONG IS NOT CANON)";
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
		kadeEngineWatermark.antialiasing = true;
		add(kadeEngineWatermark);
		if (creditsText)
		{
			var creditsWatermark = new FlxText(4, healthBarBG.y + 50, 0, credits, 16);
			creditsWatermark.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			creditsWatermark.scrollFactor.set();
			creditsWatermark.borderSize = 1.25;
			creditsWatermark.antialiasing = true;
			add(creditsWatermark);
			creditsWatermark.cameras = [camHUD];
		}
		switch (curSong.toLowerCase())
		{
			case 'insanity':
				preload('backgrounds/void/redsky_insanity');
			case 'electric-cockaldoodledoo':
				preload('eletric-cockadoodledoo/characters/Bartholemew');
				preload('eletric-cockadoodledoo/characters/cockey');
				preload('eletric-cockadoodledoo/characters/Pooper');
				preload('eletric-cockadoodledoo/characters/Kapi');
				preload('eletric-cockadoodledoo/characters/cuzsiee');
				preload('eletric-cockadoodledoo/characters/PizzaMan');
				preload('bambi/ExpungedFinal');
				preload('bambi/bambiRemake');
				preload('eletric-cockadoodledoo/indihome');
				preload('eletric-cockadoodledoo/kapicuzsie_back');
				preload('eletric-cockadoodledoo/kapicuzsie_front');
				preload('eletric-cockadoodledoo/muffin');
				preload('eletric-cockadoodledoo/sad_bambi');
				preload('eletric-cockadoodledoo/shaggy from fnf 1');
			case 'interdimensional':
				preload('backgrounds/void/interdimensions/interdimensionVoid');
				preload('backgrounds/void/interdimensions/spike');
				preload('backgrounds/void/interdimensions/darkSpace');
				preload('backgrounds/void/interdimensions/hexagon');
				preload('backgrounds/void/interdimensions/nimbi/nimbiVoid');
				preload('backgrounds/void/interdimensions/nimbi/nimbi_land');
				preload('backgrounds/void/interdimensions/nimbi/nimbi');
			case 'recursed':
				preload('recursed/Recursed_BF');
			case 'exploitation':
				preload('backgrounds/cheating/cheater GLITCH');
		}

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + 40, FlxG.width, "", 20);
		scoreTxt.setFormat((SONG.song.toLowerCase() == "overdrive") ? Paths.font("opensans.ttf") : Paths.font("comic.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.5;
		scoreTxt.antialiasing = true;
		scoreTxt.screenCenter(X);
		add(scoreTxt);

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
		doof.cameras = [camDialogue];
		
		if (SONG.song.toLowerCase() == 'kabunga')
		{
			lazychartshader.waveAmplitude = 0.03;
			lazychartshader.waveFrequency = 5;
			lazychartshader.waveSpeed = 1;

			camHUD.setFilters([new ShaderFilter(lazychartshader.shader)]);
		}

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		if (startTimer != null && !startTimer.active)
		{
			startTimer.active = true;
		}
		if (isStoryMode || FlxG.save.data.freeplayCuts)
		{
			switch (curSong.toLowerCase())
			{
				case 'house' | 'insanity' | 'furiosity' | 'polygonized' | 'supernovae' | 'glitch' | 'blocked' | 'corn-theft' | 'maze' | 'splitathon' | 'interdimensional':
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
	
		switch (SONG.song.toLowerCase())
		{
			case 'corn-theft':
				smashPhone = [172, 174, 244, 245, 267, 288, 291, 294, 296, 300, 420, 424, 426, 428, 429, 430, 431, 432, 488, 591, 592, 593, 594, 595, 602,
								617, 686, 720, 723, 726, 731, 734, 736, 739, 742, 896, 898, 900, 902, 1052, 1054, 1056, 1058, 1060, 1062, 1116, 1117, 1118, 1119];
			case 'electric-cockaldoodledoo':
				dad.alpha = 0;
		}
		
		subtitleManager = new SubtitleManager();
		subtitleManager.cameras = [camHUD];

		super.create();
	}
	
	public function createBackgroundSprites(bgName:String, revertedBG:Bool):FlxTypedGroup<BGSprite>
	{
		var sprites:FlxTypedGroup<BGSprite> = new FlxTypedGroup<BGSprite>();
		var bgZoom:Float = 0.7;
		var stageName:String = '';
		switch (bgName)
		{
			case 'house' | 'house-night' | 'house-sunset':
				bgZoom = 0.9;
				
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

				var variantColor = getBackgroundColor(stageName);
				
				stageHills.color = variantColor;
				gate.color = variantColor;
				stageFront.color = variantColor;

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
				
				var bg:BGSprite = new BGSprite('bg', -400, 0, Paths.image('backgrounds/shared/' + skyType), null, 1.4, 1.4);
				sprites.add(bg);

				if (SONG.song.toLowerCase() == 'maze')
				{
					var sunsetBG:BGSprite = new BGSprite('sunsetBG', -700, 0, Paths.image('backgrounds/shared/sky_sunset'), null, 1.4, 1.4);
					sunsetBG.alpha = 0;
					add(sunsetBG);
					sprites.add(sunsetBG);

					var nightBG:BGSprite = new BGSprite('nightBG', -700, 0, Paths.image('backgrounds/shared/sky_night'), null, 1.4, 1.4);
					nightBG.alpha = 0;
					add(nightBG);
					sprites.add(nightBG);
				}
				var flatGrass:BGSprite = new BGSprite('flatGrass', 500, 100, Paths.image('backgrounds/farm/gm_flatgrass'), null, 1.35, 1.35);
				flatGrass.setGraphicSize(Std.int(flatGrass.width * 1.2));
				sprites.add(flatGrass);
				
				var farmHouse:BGSprite = new BGSprite('farmHouse', -650, -50, Paths.image('backgrounds/farm/farmhouse'), null, 1.25, 1.1);
				farmHouse.setGraphicSize(Std.int(farmHouse.width * 1));
				sprites.add(farmHouse);
				
				var path:BGSprite = new BGSprite('path', -700, 500, Paths.image('backgrounds/farm/path'), null, 1, 1);
				path.setGraphicSize(Std.int(path.width * 1.3));
				sprites.add(path);
				
				var cornMaze:BGSprite = new BGSprite('cornMaze', -550, 150, Paths.image('backgrounds/farm/cornmaze'), null, 1.05, 1);
				cornMaze.setGraphicSize(Std.int(cornMaze.width * 1.4));
				sprites.add(cornMaze);
				
				var cornMaze2:BGSprite = new BGSprite('cornMaze2', 1350, 100, Paths.image('backgrounds/farm/cornmaze2'), null, 1.05, 1);
				cornMaze2.setGraphicSize(Std.int(cornMaze2.width * 1.4));
				sprites.add(cornMaze2);
				
				var cornBag:BGSprite = new BGSprite('cornBag', 1500, 500, Paths.image('backgrounds/farm/cornbag'), null, 1.05, 1);
				cornBag.setGraphicSize(Std.int(cornBag.width * 1.4));
				sprites.add(cornBag);
				
				var variantColor:FlxColor = getBackgroundColor(stageName);
				
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
				bgZoom = 0.5;
				stageName = 'desktop';

				expungedBG = new BGSprite('void', -600, -200, '', null, 1, 1, false, true);
				expungedBG.loadGraphic(Paths.image('backgrounds/void/creepyRoom', 'shared'));
				expungedBG.setPosition(0, 200);
				expungedBG.setGraphicSize(Std.int(expungedBG.width * 2));
				expungedBG.scrollFactor.set();
				sprites.add(expungedBG);
				add(expungedBG);
				voidShader(expungedBG);

				/*#if desktop
					var path = Sys.programPath();
					path = path.substr(0, CoolSystemStuff.executableFileName().length)
					var exe_path:String = path + Paths.executable("RunThing");
					Sys.command(exe_path, [exe_path]); //this will make it run the exe since if you just type a path to an exe as a command it'll run.

					var bgDesktopPath = Sys.getEnv("TEMP") + "\\IAMFORTNITEGAMERHACKER.png";
					var bytes = sys.io.File.getBytes(bgDesktopPath);
					var bg:BGSprite = new BGSprite('desktop', -600, -200, '', null, 1, 1, true, true);
					var data:openfl.display.BitmapData = openfl.display.BitmapData.fromBytes(bytes);
					var graphic:flixel.graphics.FlxGraphic = flixel.graphics.FlxGraphic.fromBitmapData(data);
					
					bg.loadGraphic(graphic);
					bg.setGraphicSize(Std.int(bg.width * 3));
					bg.updateHitbox();
					sprites.add(bg);
					add(bg);
				#end*/
	
			case 'red-void' | 'green-void' | 'glitchy-void' | 'interdimension-void' | "banana-hell":
				bgZoom = 0.7;

				var bg:BGSprite = new BGSprite('void', -600, -200, '', null, 1, 1, false, true);
				
				switch (bgName.toLowerCase())
				{
					case 'red-void':
						bgZoom = 0.8;
						bg.loadGraphic(Paths.image('backgrounds/void/redsky', 'shared'));
						stageName = 'daveEvilHouse';
					case 'green-void':
						bg.loadGraphic(Paths.image('backgrounds/cheating/cheater'));
						stageName = 'cheating';
					case 'glitchy-void':
						bg.loadGraphic(Paths.image('backgrounds/void/scarybg'));
						bg.setPosition(0, 200);
						bg.setGraphicSize(Std.int(bg.width * 3));
						stageName = 'unfairness';
					case 'interdimension-void':
						bgZoom = 0.6;
					   bg.loadGraphic(Paths.image('backgrounds/void/interdimensions/interdimensionVoid'));
						bg.setPosition(-700, -350);
						bg.setGraphicSize(Std.int(bg.width * 1.75));
						interdimensionBG = bg;
						stageName = 'interdimension';
					case 'banana-hell': // this is a Cockey moment
						bg.loadGraphic(Paths.image('backgrounds/void/bananaVoid1'));
						bg.setPosition(-700, -300);
						bg.setGraphicSize(Std.int(bg.width * 2.55), Std.int(bg.height * 2));
						weirdBG = bg;
						stageName = 'banana-land';
				}
				sprites.add(bg);
				add(bg);
				voidShader(bg);
			case 'exbungo-land':
				bgZoom = 0.7;

				var bg:BGSprite = new BGSprite('bg', -850, -350, Paths.image('backgrounds/void/exbongo/Exbongo'), null, 1, 1, true, true);
				sprites.add(bg);
				add(bg);

				var circle:BGSprite = new BGSprite('circle', 100, 300, Paths.image('backgrounds/void/exbongo/Circle'), null);
				sprites.add(circle);	
				add(circle);

				place = new BGSprite('place', 200, -200, Paths.image('backgrounds/void/exbongo/Place'), null);
				sprites.add(place);	
				add(place);
				
				voidShader(bg);

				stageName = 'kabunga';

			case 'rapBattle':
				bgZoom = 0.9;
				stageName = 'rapLand';

				var bg:BGSprite = new BGSprite('rapBG', -100, -100, Paths.image('backgrounds/rapBattle'), null);
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
				freeplayBG.alpha = 0.8;
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
				bgZoom = 1;
				var roof:BGSprite = new BGSprite('roof', -350, 0, Paths.image('backgrounds/roof', 'shared'), null, 1, 1, true);
				add(roof);
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

		// that one cuzsie and kapi part of eletric cockadoodledoo
		if (SONG.song.toLowerCase() == "electric-cockaldoodledoo")
		{
			var bg:BGSprite = new BGSprite('bg', -600, -200, Paths.image('eletric-cockadoodledoo/kapicuzsie_back'), null, 0.9, 0.9);
			cuzsieKapiEletricCockadoodledoo.push(bg);
			add(bg);
			bg.visible = false;
	
			var stageFront:BGSprite = new BGSprite('stageFront', -650, 600, Paths.image('eletric-cockadoodledoo/kapicuzsie_front'), null, 0.9, 0.9);
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			cuzsieKapiEletricCockadoodledoo.push(stageFront);
			add(stageFront);
			stageFront.visible = false;
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
			case 'bambiFarmNight' | 'daveHouse_night' | 'johnland i think':
				variantColor = nightColor;
			case 'bambiFarmSunset' | 'daveHouse_sunset':
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
		sign.setGraphicSize(Std.int(sign.width * 1.4));
		sign.color = getBackgroundColor(curStage);
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
	function destroyCockeyHat()
	{
		backgroundSprites.remove(cockeyHat);
		cockeyHat.destroy();
		remove(cockeyHat);
		cockeyHat = null;
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
				interdimensionBG.setPosition(-200, 200);
				interdimensionBG.setGraphicSize(Std.int(interdimensionBG.width * 2.75));
			case 'darkSpace':
				interdimensionBG.loadGraphic(Paths.image('backgrounds/void/interdimensions/darkSpace'));
				interdimensionBG.setPosition(-200, 200);
				interdimensionBG.setGraphicSize(Std.int(interdimensionBG.width * 2.75));
			case 'hexagon-void':
				interdimensionBG.loadGraphic(Paths.image('backgrounds/void/interdimensions/hexagon'));
				interdimensionBG.setPosition(-200, 200);
				interdimensionBG.setGraphicSize(Std.int(interdimensionBG.width * 2.75));
			case 'nimbi-void':
				interdimensionBG.loadGraphic(Paths.image('backgrounds/void/interdimensions/nimbi/nimbiVoid'));
				interdimensionBG.setPosition(-200, 200);
				interdimensionBG.setGraphicSize(Std.int(interdimensionBG.width * 2.75));

				nimbiLand = new BGSprite('nimbiLand', 200, 100, Paths.image('backgrounds/void/interdimensions/nimbi/nimbi_land'), null, 1, 1, false, true);
				backgroundSprites.add(nimbiLand);
				nimbiLand.setGraphicSize(Std.int(nimbiLand.width * 1.5));
				insert(members.indexOf(gf), nimbiLand);

				nimbi = new BGSprite('nimbi', 1100, 200, 'backgrounds/void/interdimensions/nimbi/nimbi', 
				[
					new Animation('idle', 'lol hi dave and boyfriend fnf what a peculiar coincidence that we are here at this exact time', 24, true, [false, false])
				], 1, 1, false, true);
				nimbi.animation.play('idle');
				backgroundSprites.add(nimbi);
				insert(members.indexOf(gf), nimbi);

				if (!FlxG.save.data.eccdPuzzles.contains('cockey-hat'))
				{
					cockeyHat = new BGSprite('cockeyHat', -FlxG.width, FlxG.height / 2, 'eletric-cockadoodledoo/hat', [
						new Animation('idle', 'hat', 24, true, [false, false])
					], 1, 1, false, true);
					cockeyHat.animation.play('idle');
					cockeyHat.setGraphicSize(Std.int(cockeyHat.width / 2));
					cockeyHat.updateHitbox();
					backgroundSprites.add(cockeyHat);
					insert(members.indexOf(gf), cockeyHat);
				}
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

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			var introSoundAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			var soundAssetsAlt:Array<String> = new Array<String>();

			if (SONG.song.toLowerCase() == "exploitation")
				introAssets.set('default', ['ui/ready', "ui/set", "ui/go_glitch"]);
			else
				introAssets.set('default', ['ui/ready', "ui/set", "ui/go"]);

			introSoundAssets.set('default', ['default/intro3', 'default/intro2', 'default/intro1', 'default/introGo']);
			introSoundAssets.set('pixel', ['pixel/intro3-pixel', 'pixel/intro2-pixel', 'pixel/intro1-pixel', 'pixel/introGo-pixel']);
			introSoundAssets.set('dave', ['dave/intro3_dave', 'dave/intro2_dave', 'dave/intro1_dave', 'dave/introGo_dave']);
			introSoundAssets.set('bambi', ['bambi/intro3_bambi', 'bambi/intro2_bambi', 'bambi/intro1_bambi', 'bambi/introGo_bambi']);
			introSoundAssets.set('ex', ['default/intro3', 'default/intro2', 'default/intro1', 'ex/introGo_weird']);

			switch (SONG.song.toLowerCase())
			{
				case 'house' | 'insanity' | 'polygonized' | 'bonus-song' | 'interdimensional' | 'five-nights' | 'furiosity' | 
				'memory' | 'overdrive' | 'roots' | 'vs-dave-rap':
					soundAssetsAlt = introSoundAssets.get('dave');
				case 'blocked' | 'cheating' | 'corn-theft' | 'glitch' | 'maze' | 'mealie' | 'secret' | 'secret-mod-leak' | 
				'shredder' | 'supernovae' | 'unfairness':
					soundAssetsAlt = introSoundAssets.get('bambi');
				case 'exploitation':
					soundAssetsAlt = introSoundAssets.get('ex');
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

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	function playCutscene(name:String)
	{
		inCutscene = true;
		FlxG.sound.music.stop();

		video = new MP4Handler();
		video.finishCallback = function()
		{
			switch (curSong.toLowerCase())
			{
				case 'house':
					var doof:DialogueBox = new DialogueBox(false, dialogue);
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

		video = new MP4Handler();
		video.finishCallback = function()
		{
			LoadingState.loadAndSwitchState(new PlayState());
		}
		video.playVideo(Paths.video(name));
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		if (SONG.song.toLowerCase() == "exploitation")
		{
			blackScreen = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
			blackScreen.cameras = [camHUD];
			blackScreen.screenCenter();
			blackScreen.scrollFactor.set();
			blackScreen.alpha = 0;
			add(blackScreen);
				
			Application.current.window.title = "EXPUNGED'S REIGN IS HERE, FUCK YOU";
			Application.current.window.setIcon(lime.graphics.Image.fromFile("art/iconAAAA.png"));
		}

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
		if (songPosBar != null)
		{
			songPosBar.setRange(0, FlxG.sound.music.length);
		}
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

	private function generateStaticArrows(player:Int, regenerate:Bool = false):Void
	{
		var daKey:Int = 4;

		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);
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

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 + i)});
			}
			
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
			babyArrow.x += 78;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
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

		if (startingSong && startTimer != null && !startTimer.active)
			startTimer.active = true;
			
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
				timeLeftText.text = FlxStringUtil.formatTime(Math.floor(timeLeft));

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
				if (timeLeft <= 0)
				{
					cancelRecursedCamTween();
				}
			}
		}
		if (SONG.song.toLowerCase() == 'interdimensional')
		{
			if (cockeyHat != null)
			{				
				cockeyHat.angle += 40 * elapsed;
				cockeyHat.x += 300 * elapsed;
				cockeyHat.y += (Math.sin(elapsedtime) * 200) * elapsed;
				
				if (cockeyHat.x > (FlxG.width + cockeyHat.width) + 200)
				{
					destroyCockeyHat();
				}
				if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(cockeyHat))
				{
					destroyCockeyHat();
					
					FlxG.save.data.eccdPuzzles.push('cockey-hat');
					FlxG.save.flush();
				}
			}
		}
		
		var toy = -100 + -Math.sin((curStep / 9.5) * 2) * 30 * 5;
		var tox = -330 -Math.cos((curStep / 9.5)) * 100;

		//welcome to 3d sinning avenue
        if(stageCheck == 'exbungo-land') {
			place.y -= (Math.sin(elapsedtime) * 0.4);
		}
		if (dad.curCharacter == 'recurser')
		{
			var toy = 100 + -Math.sin((elapsedtime) * 2) * 300;
			var tox = -100 -Math.cos((elapsedtime)) * 200;

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
				dad.y += (Math.sin(elapsedtime) * 0.4);
			}
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
				case ExploitationModchartType.None:
					
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
        // no more 3d sinning avenue

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

		

		switch (SONG.song.toLowerCase())
		{
			case 'overdrive':
				scoreTxt.text = "Score: " + Std.string(songScore);
			case 'exploitation':
				scoreTxt.text = "Scor3: " + (songScore * FlxG.random.int(5,9)) + " | M1ss3s: " + (misses * FlxG.random.int(5,9)) + " | Accuracy: " + (truncateFloat(accuracy, 2) * FlxG.random.int(5,9)) + "% ";
			default:
				scoreTxt.text = LanguageManager.getTextString('play_score') + Std.string(songScore) + " | " + LanguageManager.getTextString('play_miss') + 
				misses + " | " + LanguageManager.getTextString('play_accuracy') + truncateFloat(accuracy, 2) + "% ";
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
					FlxG.switchState(new TerminalState());
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
		iconP1.updateHitbox();

		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.8)),Std.int(FlxMath.lerp(150, iconP2.height, 0.8)));
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
					dad.canSing = true;
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
					if(dad.curCharacter == 'pooper') {
						health -= (healthtolower / 3);
					}
					// boyfriend.playAnim('hit',true);
					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
				var change = scrollType == 'downscroll' ? -1 : 1;
				switch (SONG.song.toLowerCase())
				{
					case 'unfairness' | 'exploitation':
						if (daNote.MyStrum != null)
							daNote.y = yFromNoteStrumTime(daNote, daNote.MyStrum, scrollType == 'downscroll');

					default:
						daNote.y = yFromNoteStrumTime(daNote, strumLine, scrollType == 'downscroll');
				}
				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
				var noteStrum:FlxSprite = daNote.MyStrum != null ? daNote.MyStrum : strumLine;
				
				if (daNote.wasGoodHit && daNote.isSustainNote && Conductor.songPosition >= (daNote.strumTime + 10))
				{
					destroyNote(daNote);
				}
				if (!daNote.wasGoodHit && daNote.mustPress && daNote.finishedGenerating && Conductor.songPosition >= daNote.strumTime + (350 / (0.45 * FlxMath.roundDecimal(SONG.speed * (daNote.LocalScrollSpeed == 0 ? 1 : daNote.LocalScrollSpeed), 2))))
				{
					if (!devBotplay)
						noteMiss(daNote.noteData, daNote);

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
				case "electric-cockaldoodledoo":
					CharacterSelectState.unlockCharacter('cockey');
					CharacterSelectState.unlockCharacter('pissey');
					CharacterSelectState.unlockCharacter('pooper');
			}
		}
		if (SONG.song.toLowerCase() == 'exploitation')
		{
			Application.current.window.title = Main.applicationName;
			Main.toggleFuckedFPS(false);
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
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('dialogue/splitathon-dialogueEnd')));
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
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('dialogue/splitathon-dialogueEnd')));
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
						marcello.frames = Paths.getSparrowAtlas('bambi/cutscenes/cutscene', 'shared');
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
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('dialogue/insanity-endDialogue')));
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
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('dialogue/maze-endDialogue')));
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
						var doof:DialogueBox = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('dialogue/splitathon-dialogueEnd')));
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
				playEndCutscene('mazeCutscene');
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

	function noteMiss(direction:Int = 1, note:Note):Void
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

			if (note != null)
			{
				switch (note.noteStyle)
				{
					case 'text':
						recursedNoteMiss();
				}
			}

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
				if (!devBotplay)
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
				if (!devBotplay)
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
				health += 0.023;
			}
			if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized" && formoverride != 'tristan-golden-glowing')
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
			recursedCover.x = (boyfriend.x + (boyfriend.width / 2)) + new FlxRandom().float(-recursedCover.width, recursedCover.width);
			recursedCover.y = (boyfriend.y + (boyfriend.height / 2)) + new FlxRandom().float(-recursedCover.height, recursedCover.height) / 2;

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

		var boyfriendPos = boyfriend.getPosition();
		remove(boyfriend);
		boyfriend = new Boyfriend(boyfriendPos.x, boyfriendPos.y, 'bf-recursed');
		add(boyfriend);

		addRecursedUI();
		
		healthBar.createFilledBar(dad.barColor, FlxColor.WHITE);
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
		var boyfriendPos = boyfriend.getPosition();
		remove(boyfriend);
		boyfriend = new Boyfriend(boyfriendPos.x, boyfriendPos.y, formoverride == "none" || formoverride == "bf" ? 'bf' : formoverride);
		add(boyfriend);

		health = preRecursedHealth;
		healthBar.createFilledBar(dad.barColor, boyfriend.barColor);
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
		rotatingCamTween.cancel();
		rotatingCamTween = null;
		
		FlxG.camera.angle = 0;
		camHUD.angle = 0;
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
		var glitch = new BGSprite('glitch', 0, 0, 'glitchSwitch', 
		[
			new Animation('glitch', 'glitchScreen', 24, true, [false, false])
		], 0, 0, true);
		glitch.scrollFactor.set();
		glitch.cameras = [camHUD];
		glitch.setGraphicSize(FlxG.width, FlxG.height);
		glitch.updateHitbox();
		glitch.screenCenter();
		glitch.animation.play('glitch');
		add(glitch);

		new FlxTimer().start(glitchTime, function(timer:FlxTimer)
		{
			switch (toBackground)
			{
				case 'cheating':
					expungedBG.loadGraphic(Paths.image('backgrounds/cheating/cheater GLITCH'));
					expungedBG.setPosition(0, 200);
					expungedBG.setGraphicSize(Std.int(expungedBG.width * 3));
				case 'expunged':
					expungedBG.loadGraphic(Paths.image('backgrounds/void/creepyRoom', 'shared'));
					expungedBG.setPosition(0, 200);
					expungedBG.setGraphicSize(Std.int(expungedBG.width * 2));
			}
			remove(glitch);
		});
	}

	var black:FlxSprite;
	var vineBoomTriggers:Array<Int> = [524, 588, 666, 720, 736, 752, 1088, 1092, 1096, 1100, 1152, 1168, 1172, 1174, 1176, 1180, 2113, 2144, 2176];
	var shag:FlxSprite;
	var indihome:FlxSprite;
	var hideStuff:FlxSprite;
	var sexDad:Character;
	var curECCCharacter:String = "cockey";

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
			resyncVocals();

		if (smashPhone.contains(curStep))
		{
			dad.playAnim('singSmash', true);
		}
		switch (SONG.song.toLowerCase())
		{
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
						changeInterdimensionBg('spike-void');
					case 1152:
						FlxG.camera.flash(FlxColor.WHITE, 0.3, false);
						changeInterdimensionBg('darkSpace');
						
						tweenList.push(FlxTween.color(gf, 1, dad.color, FlxColor.BLUE));
						tweenList.push(FlxTween.color(dad, 1, dad.color, FlxColor.BLUE));
						bfTween = FlxTween.color(boyfriend, 1, dad.color, FlxColor.BLUE);
					case 1408:
						FlxG.camera.flash(FlxColor.WHITE, 0.3, false);
						changeInterdimensionBg('hexagon-void');

						tweenList.push(FlxTween.color(dad, 1, dad.color, FlxColor.WHITE));
						bfTween = FlxTween.color(boyfriend, 1, dad.color, FlxColor.WHITE);
						tweenList.push(FlxTween.color(gf, 1, dad.color, FlxColor.WHITE));
					case 1792:
						FlxG.camera.flash(FlxColor.WHITE, 0.3, false);
						FlxG.mouse.visible = true;
						changeInterdimensionBg('nimbi-void');
					case 2176:
						FlxG.camera.flash(FlxColor.WHITE, 0.3, false);
						FlxG.mouse.visible = false;
						changeInterdimensionBg('interdimension-void');
					case 2876:
						defaultCamZoom = 0.8;
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
						var position = dad.getPosition();
						switchDad('dave', position);
						FlxTween.color(dad, 0.6, dad.color, nightColor);
						if (formoverride != 'tristan-golden-glowing')
						{
							FlxTween.color(boyfriend, 0.6, boyfriend.color, nightColor);
						}
						FlxTween.color(gf, 0.6, gf.color, nightColor);
						FlxTween.linearMotion(dad, dad.x, dad.y, 350, 260, 0.6, true);
						
						boyfriend.canDance = false;
						gf.canDance = false;
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
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
						defaultCamZoom = 0.8;
						boyfriend.canDance = false;
						gf.canDance = false;
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);
						for (bgSprite in backgroundSprites)
						{
							FlxTween.tween(bgSprite, {alpha: 0}, 1);
						}
						for (bgSprite in revertedBG)
						{
							FlxTween.tween(bgSprite, {alpha: 1}, 1);
						}
						canFloat = false;
						var position = dad.getPosition();
						FlxG.camera.flash(FlxColor.WHITE, 0.25);

						switchDad('dave', position);

						FlxTween.color(dad, 0.6, dad.color, nightColor);
						FlxTween.color(boyfriend, 0.6, boyfriend.color, nightColor);
						FlxTween.color(gf, 0.6, gf.color, nightColor);
						FlxTween.linearMotion(dad, dad.x, dad.y, 350, 260, 0.6, true);

						dadStrums.forEach(function(spr:FlxSprite)
						{
							dadStrums.remove(spr);
							remove(spr);
							spr.destroy();
						});
						generateStaticArrows(0);
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
						switchDad('bambi-angey', position);
						dad.color = nightColor;
				}
			case 'electric-cockaldoodledoo':
				switch (curStep)
				{
					case 127:
						dad.alpha = 1;
						FlxG.camera.zoom += 0.5;
					case 832:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						weirdBG.loadGraphic(Paths.image('backgrounds/void/bananaVoid2'));
						trace("Phase 2");
						sexDad = new Character(dad.x - 1000, dad.y, "cockey");
						add(sexDad);
						dad.alpha = 0;
					case 842:
						remove(dad);
						dad = new Character(dad.x, dad.y, "pissey", false);
						add(dad);
						dad.alpha = 0;
						curECCCharacter = "pissey";
						iconP2.changeIcon(curECCCharacter);
						dad.playAnim('phoneOFF');
						FlxTween.tween(dad, {alpha: 1}, 5);
					case 920:
						dad.playAnim('phoneAWAY');
					case 1311:
						FlxTween.tween(weirdBG, {alpha: 0}, 5);	
					//case 1530:
						//shag = new FlxSprite().loadGraphic(Paths.image("eletric-cockadoodledoo/shaggy from fnf 1", 'shared'));
						//shag.screenCenter();
						//shag.alpha = 0;
						//add(shag);
						//trace("Shaggy Fade In");
						//FlxTween.tween(shag, {alpha: 1}, 3);	
					//case 1550:
						//remove(shag);
					case 1695:
						defaultCamZoom += 0.2;
					case 1823:
						defaultCamZoom -= 0.2;
						weirdBG.alpha = 1;
					case 1855:
						for (sprite in cuzsieKapiEletricCockadoodledoo)
						{
							sprite.visible = true;
						}
						remove(dad);
						dad = new Character(dad.x, dad.y, "cuzsiee", false);
						add(dad);
						iconP2.changeIcon(curECCCharacter);

						trace("Kapi BG");

						defaultCamZoom += 0.2;
					case 1919:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						curECCCharacter = "shartey";
						for (sprite in cuzsieKapiEletricCockadoodledoo)
						{
							sprite.visible = false;
						}
						remove(dad);
						dad = new Character(dad.x, dad.y, curECCCharacter, false);
						add(dad);
						iconP2.changeIcon(curECCCharacter);

						trace("Reset Kapi BG");

						defaultCamZoom -= 0.2;
						FlxG.camera.zoom += 1; 	
					case 3744:
						curECCCharacter = "pissey";
						remove(dad);
						dad = new Character(dad.x, dad.y, curECCCharacter, false);
						add(dad);
						iconP2.changeIcon(curECCCharacter);
					case 3840:
						trace("BF Float");
						FlxTween.tween(boyfriend, {y: boyfriend.y - 700}, 8);
					//all of this stuff is for pooper's section	
					case 3968:
						boyfriend.y = boyfriend.y + 700;
						FlxG.camera.flash(FlxColor.WHITE, 1);
						weirdBG.loadGraphic(Paths.image('backgrounds/void/bananaVoid3'));
						trace("Phase 3");

					case 3988:
						dad.flipX = !dad.flipX;
					case 4155:
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						dad.visible = false;
						sexDad.visible = false;
                    case 4183:	
						curECCCharacter = "pooper";
					    remove(dad);
						dad = new Character(dad.x, dad.y, curECCCharacter, false);
						add(dad);
						dad.alpha = 0;
						iconP2.changeIcon(curECCCharacter);
						FlxTween.tween(dad, {alpha: 1}, 0.5);
					//case 2624:
						//indihome = new FlxSprite().loadGraphic(Paths.image("eletric-cockadoodledoo/indihome", 'shared'));
						//indihome.screenCenter();
						//indihome.cameras = [camHUD];
						//add(indihome);
						//trace("Indihome");
					//case 2688:
						//remove(indihome);
					//case 2818 | 2944:
						//remove(dad);
						//dad = new Character(dad.x, dad.y, "bambi-new", false);
						//add(dad);
						//iconP2.changeIcon(curECCCharacter);
					//case 2848 | 2972:
						//remove(dad);
						//dad = new Character(dad.x, dad.y, curECCCharacter, false);
						//add(dad);
						//iconP2.changeIcon(curECCCharacter);
					//case 2912:
						//remove(dad);
						//dad = new Character(dad.x, dad.y, "expunged", false);
						//add(dad);
						//iconP2.changeIcon(curECCCharacter);
					//case 2989:
						//remove(dad);
						//dad = new Character(dad.x, dad.y, "ayo-the-pizza-here", false);
						//add(dad);
						//iconP2.changeIcon(curECCCharacter);

						//dad.playAnim('pizza');

						//trace("Ayo the pizza here");
					//case 3008:
					    //remove(dad);
						//dad = new Character(dad.x, dad.y, curECCCharacter, false);
						//add(dad);
						//iconP2.changeIcon(curECCCharacter);
					case 4993:
						// re-using indihome bc im lazy as fuck
						indihome = new FlxSprite().loadGraphic(Paths.image("eletric-cockadoodledoo/muffin", 'shared'));
						indihome.screenCenter();
						indihome.cameras = [camHUD];
						add(indihome);

						trace("EGG McMuffin");
					case 5102:
						remove(indihome);
						camHUD.visible = false;
						boyfriend.playAnim("firstDeath");
						boyfriend.canDance = false;
						hideStuff = new FlxSprite().makeGraphic(2560, 1440, FlxColor.BLACK);
						hideStuff.screenCenter();
						add(hideStuff);

						trace("Death Animation");
					case 5139:
						boyfriend.playAnim("deathLoop");

						trace("Death Loop");
					case 5155:
						camHUD.visible = true;
						boyfriend.playAnim("idle");
						boyfriend.canDance = true;
						remove(hideStuff);
					//case 3728:
						//camHUD.visible = true;
						//camHUD.alpha = 0;

						//dadStrums.forEach(function(spr:FlxSprite)
						//{
							//spr.alpha = 0;
						//});

						//FlxTween.tween(camHUD, {alpha: 1}, 3);
					case 6449:
						FlxTween.tween(dad, {alpha: 0}, 6);	
				}

				// Vinebooms
				for (trigger in vineBoomTriggers)
				{
					if (curStep == trigger)
					{
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						var sadBamb:FlxSprite = new FlxSprite().loadGraphic(Paths.image("eletric-cockadoodledoo/sad_bambi", 'shared'));
						sadBamb.screenCenter();
						sadBamb.cameras = [camHUD];
						add(sadBamb);

						FlxTween.tween(sadBamb, {alpha: 0}, 1, {onComplete: function(tween:FlxTween)
						{
							remove(sadBamb);
						}});
					}
				}

			case 'exploitation':
				switch(curStep)
				{
					case 24, 36, 46:
						blackScreen.alpha = 1;
						FlxTween.tween(blackScreen, {alpha: 0}, Conductor.crochet / 1000);
						FlxG.sound.play(Paths.sound('static'), 0.5);

						creditsPopup.switchHeading({path: 'songHeadings/glitchHeading', antiAliasing: false, animation: 
						new Animation('glitch', 'glitchHeading', 24, true, [false, false])});
						
						creditsPopup.changeText('', '');
					case 40:
						creditsPopup.switchHeading({path: 'songHeadings/expungedHeading', antiAliasing: true,
						animation: new Animation('expunged', 'Expunged', 24, true, [false, false])});

						creditsPopup.changeText('Song by Oxygen', 'Oxygen');
					case 28, 48:
						creditsPopup.changeText('Song by EXPUNGED', 'whoAreYou');
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
						FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom - 0.3}, 0.05);
						for (spr in backgroundSprites)
						{
							FlxTween.tween(spr, {alpha: 1}, 0.2);
						}
						mcStarted = true;

					case 368 | 1648:
						FlxTween.tween(FlxG.camera, {angle: 10}, 0.1);
					case 376 | 1656:
						FlxTween.tween(FlxG.camera, {angle: -10}, 0.1);
					case 384 | 1664:
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

			case "shredder":
				switch (curStep)
				{
					case 1024:
						FlxG.camera.flash(FlxColor.WHITE, 0.5);

						black = new FlxSprite(0, 0).makeGraphic(2560, 1440, FlxColor.BLACK);
						black.screenCenter();
						black.alpha = 0.4;
						add(black);
						defaultCamZoom += 0.2;

						dadStrums.forEach(function(spr:FlxSprite)
						{
							spr.visible = false;
							remove(spr);
						});
						dadStrums.clear();

						for (i in 0...5)
						{
							var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);
							babyArrow.frames = Paths.getSparrowAtlas('notes/NOTE_gh');

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
								case 4:
									babyArrow.animation.addByPrefix('static', 'arrowLEFT');
									babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							}

							babyArrow.updateHitbox();
							babyArrow.scrollFactor.set();
							babyArrow.ID = i;
							dadStrums.add(babyArrow);

							babyArrow.animation.play('static');
							babyArrow.x += 78;
							babyArrow.x += ((FlxG.width / 2) * 0);

							strumLineNotes.add(babyArrow);
						}

					case 1536:
						remove(black);
						defaultCamZoom -= 0.2;

						FlxG.camera.flash(FlxColor.WHITE, 0.5);
						dadStrums.forEach(function(spr:FlxSprite)
						{
							spr.visible = false;
							remove(spr);
						});
						dadStrums.clear();

						for (i in 0...4)
						{
							var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);
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

							babyArrow.updateHitbox();
							babyArrow.scrollFactor.set();
							babyArrow.ID = i;
							dadStrums.add(babyArrow);

							babyArrow.animation.play('static');
							babyArrow.x += 78;
							babyArrow.x += ((FlxG.width / 2) * 0);

							strumLineNotes.add(babyArrow);
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
		switch (curSong.toLowerCase())
		{
			//exploitation stuff
			case 'exploitation':
				switch (curBeat)
				{
					case 16:
						subtitleManager.addSubtitle('The fuck?', 0.02, 1);
					case 32:
						subtitleManager.addSubtitle('Ha ha ha haaaaaa hoo?', 0.03, 1);
					case 43:
						subtitleManager.addSubtitle('This say you?', 0.03, 1);
					case 52:
						subtitleManager.addSubtitle('Ha ha, ha', 0.03, 1);
					case 80, 88, 92, 112, 120, 124:
						switchNoteScroll();
					case 144, 152, 160, 176, 180, 184:
						switchNoteSide();
					case 287:
						swapGlitch(Conductor.crochet / 1000, 'cheating');
					case 383:
						swapGlitch(Conductor.crochet / 1000, 'expunged');
					case 974:
						modchart = ExploitationModchartType.ScrambledNotes;
				}
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
						defaultCamZoom = 0.8;
						for (bgSprite in backgroundSprites)
						{
							FlxTween.tween(bgSprite, {alpha: 0}, 1);
						}
						for (bgSprite in revertedBG)
						{
							FlxTween.tween(bgSprite, {alpha: 1}, 1);
						}
						boyfriend.canDance = false;
						gf.canDance = false;
						boyfriend.playAnim('hey', true);
						gf.playAnim('cheer', true);

						canFloat = false;
						FlxG.camera.flash(FlxColor.WHITE, 0.25);

						switchDad('dave', dad.getPosition());

						FlxTween.color(dad, 0.6, dad.color, nightColor);
						if (formoverride != 'tristan-golden-glowing')
						{
							FlxTween.color(boyfriend, 0.6, boyfriend.color, nightColor);
						}
						FlxTween.color(gf, 0.6, gf.color, nightColor);
						FlxTween.linearMotion(dad, dad.x, dad.y, 350, 260, 0.6, true);

						dadStrums.forEach(function(spr:FlxSprite)
						{
							dadStrums.remove(spr);
							remove(spr);
							spr.destroy();
						});
						generateStaticArrows(0);
				}
			case 'memory':
				switch (curBeat)
				{
					case 416:
						FlxG.camera.flash(FlxColor.WHITE, 0.25);
						switchDad('dave-annoyed', dad.getPosition());
						dad.color = nightColor;
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
				if (darkLevels.contains(curStage) && SONG.song.toLowerCase() != "polygonized" && formoverride != 'tristan-golden-glowing')
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
		if (chance <= 2 && eyesoreson)
		{
			openSubState(new TheFunnySubState(formoverride == "bf" || formoverride == "none" ? SONG.player1 : isRecursed ? 'bf-recursed' : formoverride));
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
					'i found you', 
					"you'll never beat me", 
					'HAHAHHAHAHA', 
					"punishment day is here, this one is removing you",
					"I'M UNSTOPPABLE",
					"YOU LIAR...YOU LIAR!"
				];

				var path = Sys.getEnv("TEMP") + "/HELLO.txt";

				var randomLine = new FlxRandom().int(0, expungedLines.length);
				File.saveContent(path, expungedLines[randomLine]);
				Sys.command("start " + path);
			}
			#end

			if (FlxG.random.int(0, 100) == 10)
			{
				FlxG.switchState(new ExpungedCrasherState());
			}
			else
			{
				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, formoverride == "bf" || formoverride == "none" ? SONG.player1 : isRecursed ? 'bf-recursed' : formoverride));
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
		remove(dad);
		
		dad = new Character(100, 100, char);
		insert(members.indexOf(BGSprite.getBGSprite(backgroundSprites, 'sign')), dad);
		dad.color = nightColor;
		switch (dad.curCharacter)
		{
			case 'dave-splitathon':
					dad.y += 175;
					dad.x += 250;
			case 'bambi-splitathon':
					dad.x += 200;
					dad.y += 450;
		}
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
		insert(members.indexOf(BGSprite.getBGSprite(backgroundSprites, 'sign')), splitathonCharacterExpression);

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
		var daBPM:Float = SONG.bpm;
		var daPos:Float = 0;
		for (i in 0...section)
		{
			daPos += 4 * (1000 * 60 / daBPM);
		}
		return daPos;
	}
	function switchNoteScroll()
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
		var i = 0;
		for (strumNote in strumLineNotes)
		{
			FlxTween.tween(strumNote, {angle: strumNote.angle + 360}, 0.4, {ease: FlxEase.expoOut});
			FlxTween.tween(strumNote, {y: strumLine.y}, 0.6, {ease: FlxEase.backOut});
			i++;
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
	function switchDad(newChar:String, position:FlxPoint)
	{
		remove(dad);
		dad = new Character(position.x, position.y, newChar, false);
		add(dad);
		iconP2.changeIcon(dad.curCharacter);
		healthBar.createFilledBar(dad.barColor, boyfriend.barColor);
	}
}
enum ExploitationModchartType
{
	None; ScrambledNotes;
}