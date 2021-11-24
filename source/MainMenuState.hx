package;

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
import io.newgrounds.NG;
import lime.app.Application;
import flixel.addons.display.FlxBackdrop;
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
		'extras', 
		'options'
	];

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool;

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
	
	var checkeredBackground:FlxBackdrop;

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	public static var bgPaths:Array<String> = 
	[
		'backgrounds/SUSSUS AMOGUS',
		'backgrounds/SwagnotrllyTheMod',
		'backgrounds/Olyantwo',
		'backgrounds/morie',
		'backgrounds/mantis',
		'backgrounds/mamakotomi',
		'backgrounds/T5mpler'
	];

	/*public var menuCharacters:Array<String> = 
	[
		'dave',
		'tristan',
		'bambi-new'
	];*/

	var logoBl:FlxSprite;

	var lilMenuGuy:FlxSprite;

	// cvar character:Character;

	override function create()
	{
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;
		
		if (FlxG.save.data.eyesores == null)
		{
			FlxG.save.data.eyesores = true;
		}

		#if desktop
		DiscordClient.changePresence("In the Menus", null);
		#end
		
		if (FlxG.save.data.unlockedcharacters == null)
		{
			FlxG.save.data.unlockedcharacters = [true,true,false,false,false,false];
		}

		daRealEngineVer = engineVers[FlxG.random.int(0, 2)];
		
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(randomizeBG());
		bg.scrollFactor.set();
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
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

		checkeredBackground = new FlxBackdrop(Paths.image('ui/checkeredBG', "preload"), 0.2, 0.2, true, true);
		add(checkeredBackground);
		checkeredBackground.scrollFactor.set(0, 0.07);
		

		var coolSideBar:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image("mainMenu/Menu_Side", "preload"));
		coolSideBar.setGraphicSize(1280,720);
		coolSideBar.screenCenter();
		coolSideBar.scrollFactor.set();
		add(coolSideBar);


		logoBl = new FlxSprite(900, -200);
		logoBl.loadGraphic(Paths.image('ui/logo', 'preload'));
		logoBl.antialiasing = true;
		logoBl.updateHitbox();
		add(logoBl);


		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('ui/FNF_main_menu_assets');

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		FlxG.camera.follow(camFollow, null, 0.06);
		
		camFollow.setPosition(640, 150.5);
		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0,0);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.y = 60 + (i * 150) - 200;
			menuItem.screenCenter(X);
			menuItem.x = menuItem.x - 350;
			menuItem.setGraphicSize(Std.int(menuItem.width * 0.95));
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(0, 1);
			menuItem.antialiasing = true;
		}	

		firstStart = false;


		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Vs Dave and Bambi V" + engineVer + " | " + daRealEngineVer + " Engine", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font("comic.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.antialiasing = true;
		add(versionShit);

		ChangeKeybinds.loadControls(controls);
		
		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	function updateChar()
	{
		if (lilMenuGuy == null)
		{
			lilMenuGuy = new FlxSprite(-500,190);
			add(lilMenuGuy);
		}
		lilMenuGuy.loadGraphic(Paths.image("menuCharacters/" + optionShit[curSelected] + "_char", 'preload'));
	}



	override function update(elapsed:Float)
	{
		checkeredBackground.x -= 0.45 / (100 / 60);
		checkeredBackground.y -= 0.16 / (100 / 60);
		

		#if debug
		if (FlxG.keys.justPressed.R)
		{
			updateChar();
		}
		#end

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
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
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				FlxFlicker.flicker(magenta, 1.1, 0.15, false);
				
				FlxTween.tween(lilMenuGuy, {y: 500}, 0.5, {ease: FlxEase.expoIn});
				FlxTween.tween(FlxG.camera, {zoom: 20}, 1, {ease: FlxEase.expoIn});
				FlxTween.tween(FlxG.camera, {angle: 30}, 1, {ease: FlxEase.expoIn});
				FlxG.camera.fade(FlxColor.BLACK, 1, false);



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

		super.update(elapsed);
	}

	override function beatHit()
	{
		super.beatHit();
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;
		
		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;	

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
			}

			spr.updateHitbox();
		});

		updateChar();
	}
	public static function randomizeBG():flixel.system.FlxAssets.FlxGraphicAsset
	{
		var chance:Int = FlxG.random.int(0, bgPaths.length - 1);
		return Paths.image(bgPaths[chance]);
	}
}
