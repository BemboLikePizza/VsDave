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

	public var noAa:Array<String> = ["dialogue/dave/dave_3d_scared", "dialogue/dave/dave_3d_festival"];

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var bfPortraitSizeMultiplier:Float = 1.5;
	var textBoxSizeFix:Float = 7;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var debug:Bool = false;

	var curshader:Dynamic;

	public static var randomNumber:Int;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>, playMusic:Bool = true)
	{
		super();

		if (playMusic)
		{
			switch (PlayState.SONG.song.toLowerCase())
			{
				case 'house' | 'insanity' | 'splitathon' | 'shredder':
					FlxG.sound.playMusic(Paths.music('DaveDialogue'), 0);
				case 'polygonized' | 'interdimensional' | 'master':
					if (PlayState.instance.localFunny != PlayState.CharacterFunnyEffect.Recurser)
					{
						FlxG.sound.playMusic(Paths.music('scaryAmbience'), 0);
					}
					else
					{
						FlxG.sound.playMusic(Paths.music('DaveDialogue'), 0);
					}
				case 'supernovae' | 'glitch':
					randomNumber = FlxG.random.int(0, 50);
					if (randomNumber == 50)
					{
						FlxG.sound.playMusic(Paths.music('secret'), 0);
					}
					else
					{
						FlxG.sound.playMusic(Paths.music('dooDooFeces'), 0);
					}
				case 'blocked' | 'corn-theft' | 'maze':
					randomNumber = FlxG.random.int(0, 50);
					if (randomNumber == 50)
					{
						FlxG.sound.playMusic(Paths.music('secret'), 0);
					}
					else
					{
						FlxG.sound.playMusic(Paths.music('DaveDialogue'), 0);
					}
				case 'rano':
					FlxG.sound.playMusic(Paths.music('stocknightambianceforranolol'), 0);
				default:
					FlxG.sound.music.stop();
			}
			FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFF8A9AF5);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		FlxTween.tween(bgFade, {alpha: 0.7}, 4.15);

		blackScreen = new FlxSprite(0, 0).makeGraphic(5000, 5000, FlxColor.BLACK);
		blackScreen.screenCenter();
		blackScreen.alpha = 0;
		add(blackScreen);

		box = new FlxSprite(-20, 400);

		box.frames = Paths.getSparrowAtlas('ui/speech_bubble_talking');
		box.setGraphicSize(Std.int(box.width / textBoxSizeFix));
		box.updateHitbox();
		box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
		box.animation.addByPrefix('normal', 'speech bubble normal', 24, true);
		box.antialiasing = true;

		if (!PlayState.instance.hasDialogue)
			return;

		this.dialogueList = dialogueList;

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
			case 'polygonized':
				if (PlayState.instance.localFunny != PlayState.CharacterFunnyEffect.Recurser)
				{
					portraitLeftCharacter = ['dave', '3d-scared'];
				}
				else
				{
					portraitLeftCharacter = ['dave', 'normal'];
				}
			case 'blocked':
				portraitLeftCharacter = ['bambi', 'annoyed'];
				portraitRightCharacter = ['gf', 'happy'];
			case 'corn-theft':
				portraitLeftCharacter = ['bambi', 'normal'];
				portraitRightCharacter = ['gf', 'what'];
			case 'maze':
				portraitLeftCharacter = ['bambi', 'upset'];
				portraitRightCharacter = ['gf', 'what'];
			case 'supernovae' | 'glitch' | 'master':
				portraitLeftCharacter = ['bambi', 'bevelmad'];
			case 'splitathon':
				portraitLeftCharacter = ['bambi', 'splitathon'];
			case 'shredder' | 'rano':
				portraitLeftCharacter = ['dave', 'festival-happy'];
			case 'greetings':
				portraitLeftCharacter = ['dave', 'festival-tired'];
			case 'interdimensional':
				portraitLeftCharacter = ['dave', 'festival-3d-scared'];
		}

		var leftPortrait:Portrait = getPortrait(portraitLeftCharacter[0], portraitLeftCharacter[1]);
		var rightPortrait:Portrait = getPortrait(portraitRightCharacter[0], portraitRightCharacter[1]);

		generatePortrait(portraitLeft, leftPortrait);
		generatePortrait(portraitRight, rightPortrait);

		portraitLeft.visible = false;
		portraitRight.visible = false;

		switch (PlayState.SONG.song.toLowerCase())
		{
			default:
				portraitLeft.setPosition(276.95, 170);
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
			case 'polygonized' | 'interdimensional':
				dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
				dropText.font = 'Comic Sans MS Bold';
				dropText.color = PlayState.instance.localFunny != PlayState.CharacterFunnyEffect.Recurser ? 0xFFFFFFFF : 0xFF00137F;
				dropText.antialiasing = true;
				add(dropText);

				swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
				swagDialogue.font = 'Comic Sans MS Bold';
				swagDialogue.color = 0xFF000000;
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
				swagDialogue.antialiasing = true;
				add(swagDialogue);
		}
		dialogue = new Alphabet(0, 80, "", false, true);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		#if SHADERS_ENABLED
		if (curshader != null)
		{
			curshader.shader.uTime.value[0] += elapsed;
		}
		#end
		dropText.text = swagDialogue.text;
		switch (curCharacter)
		{
			case 'dave':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/daveDialogue'), 0.9)];
			case 'bambi':
				swagDialogue.sounds = [FlxG.sound.load(Paths.soundRandom('dialogue/bambDialogue', 1, 3), 0.6)];
			case 'tristan':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/trisDialogue'), 0.9)];
			case 'bf':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/bfDialogue'), 0.6)];
			case 'gf':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/gfDialogue'), 0.6)];
			default:
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/pixelText'), 0.6)];
		}

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

		if (FlxG.keys.justPressed.ANY && dialogueStarted)
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

		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		curshader = null;
		if (curCharacter != 'generic')
		{
			var portrait:Portrait = getPortrait(curCharacter, curExpression);
			if (portrait.left)
			{
				generatePortrait(portraitLeft, portrait);

				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
				}
			}
			else
			{
				generatePortrait(portraitRight, portrait);

				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
				}
			}
			switch (curCharacter)
			{
				case 'dave':
					switch (curExpression)
					{
						case 'scared':
							portraitLeft.setPosition(180, 220);
						case 'phone':
							portraitLeft.setPosition(77, 145);
						case '3d-scared':
							portraitLeft.setPosition(110, 226);
						case 'shocked':
							portraitLeft.setPosition(150, 220);
						case 'furious':
							portraitLeft.setPosition(170, 220);
						case 'festival-3d-scared':
							portraitLeft.setPosition(135, 174);
						case 'festival-tired' | 'festival-exhausted' | 'festival':
							portraitLeft.setPosition(200, 175);
						default:
							portraitLeft.setPosition(200, 220);
					}
				case 'bambi': // guys its the funny bambi character
					portraitLeft.setPosition(200, 220);
				case 'tristan':
					portraitLeft.setPosition(143, 200);
				case 'bf' | 'gf': // create boyfriend & genderbent boyfriend
					portraitRight.setPosition(570, 220);
			}
			box.flipX = portraitLeft.visible;

			portraitLeft.antialiasing = !noAa.contains(portrait.portraitPath);
			portraitRight.antialiasing = !noAa.contains(portrait.portraitPath);

			var portraitSprite = portrait.left ? portraitLeft : portraitRight;
			if (portrait.portraitAnim != null)
			{
				var anim = portrait.portraitAnim;
				portraitSprite.animation.play(anim.name, true);
			}

			var pushbackAmount = portrait.left ? -200 : 200;
			portraitSprite.x += pushbackAmount;
			portraitSprite.alpha = 0;

			FlxTween.cancelTweensOf(portraitSprite);
			FlxTween.tween(portraitSprite, {x: portraitSprite.x - pushbackAmount, alpha: 1}, 0.2);
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
					shad.shader.uampmul.value[0] = 1; */
				#if SHADERS_ENABLED
				PlayState.screenshader.Enabled = true;
				#end
			case 'undistort':
				#if SHADERS_ENABLED
				PlayState.screenshader.Enabled = false;
				#end
			case 'distortbg':
				#if SHADERS_ENABLED
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
				#end
			case 'setfont_normal':
				dropText.font = 'Comic Sans MS Bold';
				swagDialogue.font = 'Comic Sans MS Bold';
			case 'setfont_code':
				dropText.font = Paths.font("barcode.ttf");
				swagDialogue.font = Paths.font("barcode.ttf");
			case 'to_black':
				FlxTween.tween(blackScreen, {alpha: 1}, 0.25);
		}
	}

	function generatePortrait(portraitSprite:FlxSprite, portrait:Portrait)
	{
		if (portrait.portraitAnim != null)
		{
			var anim = portrait.portraitAnim;
			portraitLeft.frames = Paths.getSparrowAtlas(portrait.portraitPath);
			portraitLeft.animation.addByPrefix(anim.name, anim.prefixName, anim.frames, false);
		}
		else
		{
			portraitSprite.loadGraphic(Paths.image(portrait.portraitPath));
		}
		portraitSprite.updateHitbox();
		portraitSprite.scrollFactor.set();
	}

	function getPortrait(character:String, expression:String):Portrait
	{
		var portrait:Portrait = new Portrait('', null, true);

		switch (character)
		{
			case 'dave':
				switch (expression)
				{
					case 'annoyed':
						portrait.portraitPath = 'dialogue/dave/dave_annoyed';
					case 'scared':
						portrait.portraitPath = 'dialogue/dave/dave_scared';
						portrait.portraitAnim = new Animation('enter', 'post insanity', 24, true, [false, false]);
					case 'phone':
						portrait.portraitPath = 'dialogue/dave/dave_phone';
					case '3d-scared':
						portrait.portraitPath = 'dialogue/dave/dave_3d_scared';
					case 'post-maze':
						portrait.portraitPath = 'dialogue/dave/dave_postMaze';
					case 'splitathon':
						portrait.portraitPath = 'dialogue/dave/dave_splitathon';
					case 'festival':
						portrait.portraitPath = 'dialogue/dave/dave_festival_happy';
					case 'festival-exhausted':
						portrait.portraitPath = 'dialogue/dave/dave_festival_exhausted';
					case 'festival-tired':
						portrait.portraitPath = 'dialogue/dave/dave_festival_tired';
					case 'festival-3d-scared':
						portrait.portraitPath = 'dialogue/dave/dave_3d_festival';
					case 'shocked':
						portrait.portraitPath = 'dialogue/dave/dave_shocked';
					case 'erm':
						portrait.portraitPath = 'dialogue/dave/dave_erm';
					case 'furious':
						portrait.portraitPath = 'dialogue/dave/dave_furious';
					default:
						portrait.portraitPath = 'dialogue/dave/dave_happy';
				}
			case 'bambi':
				switch (expression)
				{
					case 'annoyed':
						portrait.portraitPath = 'dialogue/bambi/bambi_annoyed';
					case 'upset':
						portrait.portraitPath = 'dialogue/bambi/bambi_upset';
					case 'splitathon':
						portrait.portraitPath = 'dialogue/bambi/bambi_splitathon';
					case 'bevel':
						portrait.portraitPath = 'dialogue/bambi/bambi_bevel';
					case 'bevelmad':
						portrait.portraitPath = 'dialogue/bambi/bambi_bevel_mad';
					default:
						portrait.portraitPath = 'dialogue/bambi/bambi_normal';
				}
			case 'bf':
				switch (expression)
				{
					case 'ready':
						portrait.portraitPath = 'dialogue/bf/bf_ready';
					case 'confused':
						portrait.portraitPath = 'dialogue/bf/bf_confused';
					case 'upset':
						portrait.portraitPath = 'dialogue/bf/bf_upset';
					default:
						portrait.portraitPath = 'dialogue/bf/bf_happy';
				}
				portrait.left = false;
			case 'gf':
				switch (expression)
				{
					case 'confused':
						portrait.portraitPath = 'dialogue/gf/gf_confused';
					case 'what':
						portrait.portraitPath = 'dialogue/gf/gf_what';
					case 'cheer':
						portrait.portraitPath = 'dialogue/gf/gf_cheer';
					default:
						portrait.portraitPath = 'dialogue/gf/gf_happy';
				}
				portrait.left = false;
			case 'tristan':
				switch (expression)
				{
					case 'festival-content':
						portrait.portraitPath = 'dialogue/tristan/tristan_festival_content';
					case 'irritated':
						portrait.portraitPath = 'dialogue/tristan/tristan_irritated';
					case 'sad':
						portrait.portraitPath = 'dialogue/tristan/tristan_sad';
					default:
						portrait.portraitPath = 'dialogue/tristan/tristan_content';
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
	public var portraitAnim:Animation;
	public var left:Bool;

	public function new(portraitPath:String, portraitAnim:Animation = null, left:Bool)
	{
		this.portraitPath = portraitPath;
		this.portraitAnim = portraitAnim;
		this.left = left;
	}
}
