package;

import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flash.system.System;
import lime.app.Application;
import flixel.effects.FlxFlicker;

class GameOverFNAF extends MusicBeatSubstate
{
	var camFollow:FlxObject;
	var retryText:FlxText;

	public function new()
	{
		super();

		Conductor.songPosition = 0;

		camFollow = new FlxObject(FlxG.width / 2, FlxG.height / 2, 1, 1);
		add(camFollow);

		FlxG.camera.zoom = 1;
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		var jumpscareSound = new FlxSound().loadEmbedded(Paths.sound('fiveNights/scream'));
		jumpscareSound.volume = 0.5;
		jumpscareSound.play();

		var jumpscare = new FlxSprite();
		jumpscare.frames = Paths.getSparrowAtlas('fiveNights/nofriendJumpscare', 'shared');
		jumpscare.animation.addByPrefix('scare', 'jumpscare', 24, false);
		jumpscare.setGraphicSize(FlxG.width, FlxG.height);
		jumpscare.updateHitbox();
		jumpscare.screenCenter();
		jumpscare.scrollFactor.set();
		jumpscare.animation.play('scare');
		add(jumpscare);

		jumpscare.animation.finishCallback = function(animation:String)
		{
			jumpscareSound.stop();
			FlxG.sound.play(Paths.sound('fiveNights/static'));

			var staticBG = new FlxSprite();
			staticBG.frames = Paths.getSparrowAtlas('fiveNights/deathStatic', 'shared');
			staticBG.animation.addByPrefix('static', 'static', 24, true);
			staticBG.setGraphicSize(FlxG.width, FlxG.height);
			staticBG.updateHitbox();
			staticBG.screenCenter();
			staticBG.scrollFactor.set();
			staticBG.animation.play('static');
			add(staticBG);

			remove(jumpscare);
			
			new FlxTimer().start(2, function(timer:FlxTimer)
			{
				endBullshit();
			});
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			FlxG.switchState(new FreeplayState());
		}
	}
	function endBullshit():Void
	{
		new FlxTimer().start(0.7, function(tmr:FlxTimer)
		{
			FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
			{
				LoadingState.loadAndSwitchState(new PlayState());
			});
		});
	}
}
