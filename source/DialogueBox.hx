package;

import flixel.math.FlxPoint;
import openfl.display.Shader;
import flixel.tweens.FlxTween;
import haxe.Log;
import flixel.input.gamepad.lists.FlxBaseGamepadList;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var blackScreen:FlxSprite;

	var curCharacter:String = '';
	var curExpression:String = '';
	var curMod:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	public var noAa:Array<String> = ["dialogue/dave_furiosity", "dialogue/3d_bamb", "dialogue/unfairnessPortrait"];

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var bfPortraitSizeMultiplier:Float = 1.5;
	var textBoxSizeFix:Float = 7;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var debug:Bool = false;

	var curshader:Dynamic;

	public static var randomNumber:Int;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'house' | 'insanity' | 'splitathon':
				FlxG.sound.playMusic(Paths.music('DaveDialogue'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'furiosity' | 'polygonized' | 'cheating' | 'unfairness' | 'interdimensional' | 'exploitation':
				FlxG.sound.playMusic(Paths.music('scaryAmbience'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'supernovae' | 'glitch':
				randomNumber = FlxG.random.int(0, 50);
				if(randomNumber == 50)
				{
					FlxG.sound.playMusic(Paths.music('secret'), 0);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				}
				else
				{
					FlxG.sound.playMusic(Paths.music('dooDooFeces'), 0);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				}
			case 'blocked' | 'corn-theft' | 'maze':
				randomNumber = FlxG.random.int(0, 50);
				if(randomNumber == 50)
				{
					FlxG.sound.playMusic(Paths.music('secret'), 0);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				}
				else
				{
					FlxG.sound.playMusic(Paths.music('DaveDialogue'), 0);
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				}
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);	

		FlxTween.tween(bgFade, {alpha: 0.7}, 4.15);
		
		blackScreen = new FlxSprite(0, 0).makeGraphic(5000, 5000, FlxColor.BLACK);
		blackScreen.screenCenter();
		blackScreen.alpha = 0;
		add(blackScreen);
		
		box = new FlxSprite(-20, 400);
		
		if (PlayState.instance.hasDialogue)
		{
			box.frames = Paths.getSparrowAtlas('ui/speech_bubble_talking');
			box.setGraphicSize(Std.int(box.width / textBoxSizeFix));
			box.updateHitbox();
			box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
			box.animation.addByPrefix('normal', 'speech bubble normal', 24, true);
			box.antialiasing = true;
		}

		this.dialogueList = dialogueList;
		
		if (!PlayState.instance.hasDialogue)
			return;
		
		var portraitLeftCharacter:Array<String> = new Array<String>();
		var portraitRightCharacter:Array<String> = new Array<String>();

		portraitLeft = new FlxSprite();
		portraitRight = new FlxSprite();

		portraitRightCharacter = ['bf', 'normal'];
		
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'house':
				portraitLeftCharacter = ['dave', 'normal'];
			case 'insanity':
				portraitLeftCharacter = ['dave', 'annoyed'];
			case 'furiosity' | 'polygonized' | 'interdimensional':
				portraitLeftCharacter = ['dave', '3d-scared'];
			case 'blocked':
				portraitLeftCharacter = ['bambi', 'annoyed'];
				portraitRightCharacter = ['gf', 'happy'];
			case 'corn-theft':
				portraitLeftCharacter = ['bambi', 'normal'];
				portraitRightCharacter = ['gf', 'what'];
			case 'maze':
				portraitLeftCharacter = ['bambi', 'upset'];
				portraitRightCharacter = ['gf', 'what'];
			case 'supernovae' | 'glitch':
				portraitLeftCharacter = ['bambi', 'bevel'];
			case 'splitathon':
				portraitLeftCharacter = ['bambi', 'splitathon'];
			case 'cheating':
				portraitLeftCharacter = ['bambi', '3d'];
			case 'unfairness':
				portraitLeftCharacter = ['bambi', 'unfair'];
		}
		

		var leftPortrait:Portrait = getPortrait(portraitLeftCharacter[0], portraitLeftCharacter[1]);

		portraitLeft.frames = Paths.getSparrowAtlas(leftPortrait.portraitPath);
		portraitLeft.animation.addByPrefix('enter', leftPortrait.portraitPrefix, 24, false);
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();

		var rightPortrait:Portrait = getPortrait(portraitRightCharacter[0], portraitRightCharacter[1]);
		
		portraitRight.frames = Paths.getSparrowAtlas(rightPortrait.portraitPath);
		portraitRight.animation.addByPrefix('enter', rightPortrait.portraitPrefix, 24, false);
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		
		portraitRight.visible = false;

		switch (PlayState.SONG.song.toLowerCase())
		{
			default:
				portraitLeft.setPosition(276.95, 170);
				portraitLeft.visible = true;
		}
		add(portraitLeft);
		add(portraitRight);

		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'furiosity' | 'polygonized' | 'cheating' | 'unfairness' | 'interdimensional':
				dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
				dropText.font = 'Comic Sans MS Bold';
				dropText.color = 0xFFFFFFFF;
				dropText.antialiasing = true;
				add(dropText);
			
				swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
				swagDialogue.font = 'Comic Sans MS Bold';
				swagDialogue.color = 0xFF000000;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				swagDialogue.antialiasing = true;
				add(swagDialogue);
			default:
				dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
				dropText.font = 'Comic Sans MS Bold';
				dropText.color = 0xFF00137F;
				dropText.antialiasing = true;
				add(dropText);
		
				swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
				swagDialogue.font = 'Comic Sans MS Bold';
				swagDialogue.color = 0xFF000000;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				swagDialogue.antialiasing = true;
				add(swagDialogue);
		}
		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		if (curshader != null)
		{
			curshader.shader.uTime.value[0] += elapsed;
		}
		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted)
		{
			remove(dialogue);
			
			switch (PlayState.SONG.song.toLowerCase())
			{
				default:
					FlxG.sound.play(Paths.sound('textclickmodern'), 0.8);
			}

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;
						
					FlxG.sound.music.fadeOut(2.2, 0);

					switch (PlayState.SONG.song.toLowerCase())
					{
						default:
							FlxTween.tween(box, {alpha: 0}, 1.2);
							FlxTween.tween(bgFade, {alpha: 0}, 1.2);
							FlxTween.tween(portraitLeft, {alpha: 0}, 1.2);
							FlxTween.tween(portraitRight, {alpha: 0}, 1.2);
							FlxTween.tween(swagDialogue, {alpha: 0}, 1.2);
							FlxTween.tween(dropText, {alpha: 0}, 1.2);
					}

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		curshader = null;
		if (curCharacter != 'generic')
		{
			var portrait:Portrait = getPortrait(curCharacter, curExpression);
			if (portrait.left)
			{
				portraitLeft.frames = Paths.getSparrowAtlas(portrait.portraitPath);
				portraitLeft.animation.addByPrefix('enter', portrait.portraitPrefix, 24, false);
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
			}
			else
			{
				portraitRight.frames = Paths.getSparrowAtlas(portrait.portraitPath);
				portraitRight.animation.addByPrefix('enter', portrait.portraitPrefix, 24, false);
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
				}
			}
			switch (curCharacter)
			{
				case 'dave' | 'bambi' | 'tristan': //guys its the funny bambi character
						portraitLeft.setPosition(220, 220);
				case 'bf' | 'gf': //create boyfriend & genderbent boyfriend
					portraitRight.setPosition(570, 220);
			}
			box.flipX = portraitLeft.visible;
			portraitLeft.x -= 150;
			//portraitRight.x += 100;
			portraitLeft.antialiasing = !noAa.contains(portrait.portraitPath);
			portraitRight.antialiasing = true;
			portraitLeft.animation.play('enter',true);
			portraitRight.animation.play('enter',true);
		}
		else
		{
			portraitLeft.visible = false;
			portraitRight.visible = false;
		}
		switch (curMod)
		{
			case 'distort':
				/*var shad:Shaders.PulseEffect = new Shaders.PulseEffect();
				curshader = shad;
				shad.waveAmplitude = 1;
				shad.waveFrequency = 2;
				shad.waveSpeed = 1;
				shad.shader.uTime.value[0] = new flixel.math.FlxRandom().float(-100000,100000);
				shad.shader.uampmul.value[0] = 1;*/
				PlayState.screenshader.Enabled = true;
			case 'undistort':
				PlayState.screenshader.Enabled = false;
			case 'distortbg':
				var shad:Shaders.DistortBGEffect = new Shaders.DistortBGEffect();
				curshader = shad;
				shad.waveAmplitude = 0.1;
				shad.waveFrequency = 5;
				shad.waveSpeed = 2;
				if (curCharacter != 'generic')
				{
					portraitLeft.shader = shad.shader;
					portraitRight.shader = shad.shader;
				}
			case 'setfont_normal':
				dropText.font = 'Comic Sans MS Bold';
				swagDialogue.font = 'Comic Sans MS Bold';
			case 'setfont_code':
				dropText.font = Paths.font("barcode.ttf");
				swagDialogue.font = Paths.font("barcode.ttf");
			case 'to_black':
				FlxTween.tween(blackScreen, {alpha:1}, 0.25);
		}
	}
	function getPortrait(character:String, expression:String):Portrait
	{
		var portrait:Portrait = new Portrait('', '', '', true);

		switch (character)
		{
			case 'dave':
				switch (expression)
				{
					case 'annoyed':
						portrait.portraitPath = 'dialogue/dave_insanity';
						portrait.portraitPrefix = 'dave insanity portrait';
					case 'scared':
						portrait.portraitPath = 'dialogue/dave_pre-furiosity';
						portrait.portraitPrefix = 'dave pre-furiosity portrait';
					case 'confused':
						portrait.portraitPath = 'dialogue/dave_bambiweek';
						portrait.portraitPrefix = 'dave bambi week portrait';
					case '3d-scared':
						portrait.portraitPath = 'dialogue/dave_furiosity';
						portrait.portraitPrefix = 'dave furiosity portrait';
					case 'splitathon':
						portrait.portraitPath = 'dialogue/dave_splitathon';
						portrait.portraitPrefix = 'dave splitathon portrait';
					default:
						portrait.portraitPath = 'dialogue/dave_house';
						portrait.portraitPrefix = 'dave house portrait';
				}
			case 'bambi':
				switch (expression)
				{
					case 'annoyed':
						portrait.portraitPath = 'dialogue/bambi_blocked';
						portrait.portraitPrefix = 'bambi blocked portrait';
					case 'upset':
						portrait.portraitPath = 'dialogue/bambi_maze';
						portrait.portraitPrefix = 'bambi maze portrait';
					case 'splitathon':
						portrait.portraitPath = 'dialogue/bambi_splitathon';
						portrait.portraitPrefix = 'bambi splitathon portrait';
					case 'bevel':
						portrait.portraitPath = 'dialogue/bambi_bevel';
						portrait.portraitPrefix = 'bambienter';
					case '3d':
						portrait.portraitPath = 'dialogue/3d_bamb';
						portrait.portraitPrefix = 'bambi 3d portrait';
					case 'unfair':
						portrait.portraitPath = 'dialogue/unfairnessPortrait';
						portrait.portraitPrefix = 'bambi unfairness portrait';
					default:
						portrait.portraitPath = 'dialogue/bambi_corntheft';
						portrait.portraitPrefix = 'bambi corntheft portrait';
				}
			case 'bf':
				switch (expression)
				{
					case 'ready':
						portrait.portraitPath = 'dialogue/bf_insanity_splitathon';
						portrait.portraitPrefix = 'bf insanity & splitathon portrait';
					case 'confused':
						portrait.portraitPath = 'dialogue/bf_furiosity_corntheft';
						portrait.portraitPrefix = 'bf furiosity & corntheft portrait';
					case 'upset':
						portrait.portraitPath = 'dialogue/bf_blocked_maze';
						portrait.portraitPrefix = 'bf blocked & maze portrait';
					default:
						portrait.portraitPath = 'dialogue/bf_house';
						portrait.portraitPrefix = 'bf house portrait';
				}
				portrait.left = false;
			case 'gf':
				switch (expression)
				{
					case 'confused':
						portrait.portraitPath = 'dialogue/gf_corntheft';
						portrait.portraitPrefix = 'gf corntheft portrait';
					case 'what':
						portrait.portraitPath = 'dialogue/gf_maze';
						portrait.portraitPrefix = 'gf maze portrait';
					case 'cheer':
						portrait.portraitPath = 'dialogue/gf_splitathon';
						portrait.portraitPrefix = 'gf splitathon portrait';
					default:
						portrait.portraitPath = 'dialogue/gf_blocked';
						portrait.portraitPrefix = 'gf blocked portrait';
				}
				portrait.left = false;
			case 'tristan':
				switch (expression)
				{
					default:
						portrait.portraitPath = 'dialogue/tristanPortrait';
						portrait.portraitPrefix = 'tristan portrait';
				}
		}
		return portrait;
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		var characterInfo = splitName[1];
		curMod = splitName[0];

		var splitCharacters:Array<String> = characterInfo.split(',');

		curCharacter = splitCharacters[0];
		curExpression = splitCharacters[1];
		
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + splitName[0].length + 2).trim();
	}
}
class Portrait
{
	public var portraitPath:String;
	public var portraitLibraryPath:String = '';
	public var portraitPrefix:String;
	public var left:Bool;
	public function new (portraitPath:String, portraitLibraryPath:String = '', portraitPrefix:String, left:Bool)
	{
		this.portraitPath = portraitPath;
		this.portraitLibraryPath = portraitLibraryPath;
		this.portraitPrefix = portraitPrefix;
		this.left = left;
	}
}