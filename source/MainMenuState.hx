package;

import sys.FileSystem;
import flixel.util.FlxSave;
import flixel.math.FlxRandom;
import flixel.math.FlxPoint;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.addons.display.FlxBackdrop;
import flixel.input.keyboard.FlxKey;
#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;
	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = 
	[
		'story mode', 
		'freeplay', 
		'credits',
		'extras', 
		'options'
	];

	public static var firstStart:Bool = true;

	public static var finishedFunnyMove:Bool = false;

	public static var daRealEngineVer:String = 'Dave';
	public static var engineVer:String = '3.0';

	public static var engineVers:Array<String> = 
	[
		'Dave', 
		'Bambi', 
		'Tristan'
	];

	public static var kadeEngineVer:String = "DAVE";
	public static var gameVer:String = "0.2.7.1";
	
	var bg:FlxSprite;
	var magenta:FlxSprite;
	var camFollow:FlxObject;
	public static var bgPaths:Array<String> = [
		'Aadsta',
		'ArtiztGmer',
		'DeltaKastel',
		'DeltaKastel2',
		'DeltaKastel3',
		'DeltaKastel4',
		'DeltaKastel5',
		'diamond man',
		'Jukebox',
		'kiazu',
		'Lancey',
		'mamakotomi',
		'mantis',
		'mepperpint',
		'morie',
		'neon',
		'Onuko',
		'ps',
		'ricee_png',
		'sk0rbias',
		'SwagnotrllyTheMod',
		'zombought',
	];

	var logoBl:FlxSprite;

	var lilMenuGuy:FlxSprite;

	var easterEggKeyCombination:Array<FlxKey> = 
	[
		FlxKey.I, 
		FlxKey.L, 
		FlxKey.O, 
		FlxKey.V, 
		FlxKey.E, 
		FlxKey.G, 
		FlxKey.O, 
		FlxKey.L, 
		FlxKey.D, 
		FlxKey.E, 
		FlxKey.N, 
		FlxKey.A, 
		FlxKey.P, 
		FlxKey.P, 
		FlxKey.L, 
		FlxKey.E
	];
	var lastKeysPressed:Array<FlxKey> = [];
	var awaitingExploitation:Bool;
	var rightArrow:FlxText;
	var leftArrow:FlxText;

	var voidShader:Shaders.GlitchEffect;


	override function create()
	{

		awaitingExploitation = (FlxG.save.data.exploitationState == 'awaiting');
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
		persistentUpdate = persistentDraw = true;

		#if desktop
		DiscordClient.changePresence("In the Menus", null);
		#end
		
		KeybindPrefs.loadControls();

		// daRealEngineVer = engineVers[FlxG.random.int(0, 2)];

		if (awaitingExploitation)
		{
			bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('backgrounds/void/redsky', 'shared'));
			bg.scrollFactor.set(0, 0.2);
			bg.antialiasing = false;
			bg.color = FlxColor.multiply(bg.color, FlxColor.fromRGB(50, 50, 50));
			add(bg);
			
			voidShader = new Shaders.GlitchEffect();
			voidShader.waveAmplitude = 0.1;
			voidShader.waveFrequency = 5;
			voidShader.waveSpeed = 2;
			
			bg.shader = voidShader.shader;

			magenta = new FlxSprite(-600, -200).loadGraphic(bg.graphic);
			magenta.scrollFactor.set();
			magenta.antialiasing = false;
			magenta.visible = false;
			magenta.color = FlxColor.multiply(0xFFfd719b, FlxColor.fromRGB(50, 50, 50));
			add(magenta);

			magenta.shader = voidShader.shader;
		}
		else
		{
			bg = new FlxSprite(-80).loadGraphic(randomizeBG());
			bg.scrollFactor.set();
			bg.setGraphicSize(Std.int(bg.width * 1.1));
			bg.updateHitbox();
			bg.screenCenter();
			bg.antialiasing = true;
			bg.color = 0xFFFDE871;
			add(bg);
	
			magenta = new FlxSprite(-80).loadGraphic(bg.graphic);
			magenta.scrollFactor.set();
			magenta.setGraphicSize(Std.int(magenta.width * 1.1));
			magenta.updateHitbox();
			magenta.screenCenter();
			magenta.visible = false;
			magenta.antialiasing = true;
			magenta.color = 0xFFfd719b;
			add(magenta);
		}
		

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('ui/FNF_main_menu_assets');

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		FlxG.camera.follow(camFollow, null, 0.06);

		camFollow.setPosition(640, 150.5);

		for (i in 0...optionShit.length)
		{
			var currentOptionShit = optionShit[i];
			var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1.6);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', currentOptionShit + " basic", 24);
			menuItem.animation.addByPrefix('selected', currentOptionShit + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(0, 1);
			menuItem.antialiasing = true;
			if (firstStart)
				FlxTween.tween(menuItem, {y: 60 + (i * 160)}, 1 + (i * 0.25), {
					ease: FlxEase.expoInOut,
					onComplete: function(flxTween:FlxTween)
					{
						finishedFunnyMove = true;
						changeItem();
					}
				});
			else
				menuItem.y = 60 + (i * 160);
		}

		firstStart = false;

		var versionShit:FlxText = new FlxText(1, FlxG.height - 44, 0, '${daRealEngineVer} Engine v${engineVer}\nFNF v${gameVer}', 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		if (awaitingExploitation)
		{
			var goToFreeplay = new FlxText(0, 150, 0, "Go To Freeplay", 50);
			goToFreeplay.setFormat("Comic Sans MS Bold", 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			goToFreeplay.borderSize = 3;
			goToFreeplay.antialiasing = true;
			goToFreeplay.screenCenter(X);
			goToFreeplay.alpha = 0;
			goToFreeplay.scrollFactor.set();
	
	
			var blackBorder:FlxSprite = new FlxSprite(goToFreeplay.x, goToFreeplay.y).makeGraphic(Std.int(goToFreeplay.width + 20), Std.int(goToFreeplay.height + 10), FlxColor.BLACK);
			blackBorder.alpha = 0;
			blackBorder.scrollFactor.set();
	
			add(blackBorder);
			add(goToFreeplay);

			rightArrow = new FlxText(menuItems.members[1].x - 200, menuItems.members[1].y, 0, ">>>", 50);
			rightArrow.setFormat("Comic Sans MS Bold", 48, FlxColor.WHITE, CENTER);
			rightArrow.antialiasing = true;
			rightArrow.scrollFactor.set(1, 1);

			leftArrow = new FlxText(menuItems.members[1].x + 200, menuItems.members[1].y, 0, "<<<", 50);
			leftArrow.setFormat("Comic Sans MS Bold", 48, FlxColor.WHITE, CENTER);
			leftArrow.antialiasing = true;
			rightArrow.scrollFactor.set(1, 1);

			add(rightArrow);
			add(leftArrow);

			FlxTween.tween(rightArrow, {alpha: 1}, 1);
			FlxTween.tween(leftArrow, {alpha: 1}, 1);

			FlxTween.tween(blackBorder, {alpha: 0.7}, 1);
			FlxTween.tween(goToFreeplay, {alpha: 1}, 1);
		}

		// NG.core.calls.event.logEvent('swag').send();

		super.create();
	}
	
	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (voidShader != null)
		{
			voidShader.shader.uTime.value[0] += elapsed;
		}

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var finalKey:FlxKey = FlxG.keys.firstJustPressed();

		if (finalKey != FlxKey.NONE)
		{
			lastKeysPressed.push(finalKey);

			if (lastKeysPressed.length > easterEggKeyCombination.length)
				lastKeysPressed.shift();

			if (lastKeysPressed.length == easterEggKeyCombination.length)
			{
				var isDifferent:Bool = false;

				for (i in 0...lastKeysPressed.length)
				{
					if (lastKeysPressed[i] != easterEggKeyCombination[i])
					{
						isDifferent = true;
						break;
					}
				}

				if (!isDifferent)
				{
					var poop:String = Highscore.formatSong("eletric-cockadoodledoo", 1);

					PlayState.SONG = Song.loadFromJson(poop, "eletric-cockadoodledoo");
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = 1;

					PlayState.storyWeek = 69;

					FlxG.save.data.bananacoreUnlocked = true;
					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new TerminalState());
		}
		if (FlxG.keys.justPressed.EIGHT)
		{
			FlxG.switchState(new ChartingState());
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'discord' || optionShit[curSelected] == 'merch')
				{
					switch (optionShit[curSelected])
					{
						case 'discord':
							fancyOpenURL("https://www.discord.gg/vsdave");
					}
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];
								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										if (FlxG.random.bool(0.1))
										{
											fancyOpenURL("https://www.youtube.com/watch?v=Z7wWa1G9_30%22");
										}
										FlxG.switchState(new FreeplayState());
										trace("Freeplay Menu Selected");
									case 'options':
										FlxG.switchState(new OptionsMenu());
									case 'extras':
										FlxG.switchState(new ExtrasMenuState());
									case 'ost':
										FlxG.switchState(new MusicPlayerState());
									case 'credits':
										FlxG.switchState(new CreditsMenuState());
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	override function beatHit()
	{
		super.beatHit();
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
		
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}

	public static function randomizeBG():flixel.system.FlxAssets.FlxGraphicAsset
	{
		var chance:Int = FlxG.random.int(0, bgPaths.length - 1);
		return Paths.image('backgrounds/${bgPaths[chance]}');
	}
}