package;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flash.system.System;
import lime.app.Application;

class GameOverPolygonizedSubState extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var camFollow:FlxObject;

	var stageSuffix:String = "";
	var deathSuffix:String = '';
	var bgSuffix:String = '';
	var polygonizedText:FlxText;
	var restartText:FlxText;
	var polygonizedTween:FlxTween;
	var bg:FlxSprite;
	var voidShader:Shaders.GlitchEffect;

	public function new(x:Float, y:Float,char:String)
	{
		super();
		
		var sheetInfo:String = '';
		switch (char)
		{
			case 'dave-angey' | 'dave-3d-recursed':
				deathSuffix = '-dave';
				bgSuffix = 'void/redsky';
			case 'bambi-3d':
				deathSuffix = '-bambi';
				bgSuffix = 'cheating/cheater';
		}
		switch (char)
		{
			case 'dave-angey':
				sheetInfo = 'dave/characters/Dave_3D_Dead';
			case 'bambi-3d':
				sheetInfo = 'expunged/Bambi_3D_Death';
			case 'dave-3d-recursed':
				sheetInfo = 'recursed/characters/Dave_3D_Recursed_Dead';
		}

		bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('backgrounds/$bgSuffix', 'shared'));
		bg.scrollFactor.set();
		bg.antialiasing = false;
		bg.color = FlxColor.multiply(bg.color, FlxColor.fromRGB(50, 50, 50));
		bg.alpha = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.5));
		add(bg);
		
		#if SHADERS_ENABLED
		voidShader = new Shaders.GlitchEffect();
		voidShader.waveAmplitude = 0.1;
		voidShader.waveFrequency = 5;
		voidShader.waveSpeed = 2;
		
		bg.shader = voidShader.shader;
		#end

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, char);
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('death/fnf_loss_sfx' + deathSuffix));
		Conductor.changeBPM(105);

		FlxG.camera.follow(camFollow, LOCKON, 0.01);

		FlxTween.tween(bf, {alpha: 0, 'scale.x': 0, 'scale.y': 0}, 2, { 
			ease: FlxEase.expoInOut, 
			onUpdate: function(tween:FlxTween)
			{
				bf.angle += FlxG.elapsed * 250;
				bf.centerOrigin();
			},
			onComplete: function(tween:FlxTween)
			{
				var charDeath = new FlxSprite();
				charDeath.frames = Paths.getSparrowAtlas(sheetInfo);
				charDeath.animation.addByPrefix('death', 'dead', 24, false);
				charDeath.scrollFactor.set();
				charDeath.antialiasing = false;
				charDeath.screenCenter();
				charDeath.animation.play('death');
				charDeath.animation.finishCallback = function(anim:String)
				{
					remove(charDeath);
					polygonizedText = new FlxText(0, 0, FlxG.width, LanguageManager.getTextString('3d_gameOver_polygonized'), 32);
					polygonizedText.setFormat(Paths.font('comic.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
					polygonizedText.borderSize = 2.5;
					polygonizedText.antialiasing = true;
					polygonizedText.screenCenter();
					polygonizedText.scrollFactor.set();
					polygonizedText.scale.set();
					add(polygonizedText);

					FlxTween.tween(polygonizedText, {'scale.x': 1, 'scale.y': 1}, 1, {
						ease: FlxEase.backOut,
						onUpdate: function(tween:FlxTween)
						{
							polygonizedText.centerOrigin();
						}
					});

					FlxG.sound.play(Paths.sound('trumpet', 'shared'), 1, false, null, function()
					{
						FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));

						restartText = new FlxText(0, 0, FlxG.width, LanguageManager.getTextString('3d_gameOver_restart'), 32);
						restartText.setFormat(Paths.font('comic.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
						restartText.borderSize = 2.5;
						restartText.antialiasing = true;
						restartText.screenCenter();
						restartText.y += 300;
						restartText.scrollFactor.set();
						restartText.alpha = 0;
						add(restartText);

						FlxTween.tween(polygonizedText, {y: polygonizedText.y - 300}, 1, {ease: FlxEase.expoOut});

						FlxTween.tween(bg, {alpha: 0.6}, 1);
						FlxTween.tween(restartText, {alpha: 1}, 1);
					});
				}
			}
		});

	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		#if SHADERS_ENABLED
		voidShader.shader.uTime.value[0] += elapsed;
		#end

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			Application.current.window.title = Main.applicationName;

			if (PlayState.SONG.song.toLowerCase() == "exploitation")
			{
				Main.toggleFuckedFPS(false);
			}
			if (FlxG.save.data.exploitationState == 'playing')
			{
				Sys.exit(0);
			}
			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
		}
		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new AnimationDebug(bf.curCharacter));
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
					if (FlxG.save.data.exploitationState == 'playing')
					{
						Sys.exit(0);
					}
				});
			});
		}
	}
}
