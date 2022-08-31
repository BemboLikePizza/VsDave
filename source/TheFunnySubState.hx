package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flash.system.System;

class TheFunnySubState extends MusicBeatSubstate
{
   var timer:Float = 0;
   var toPlayFor:Float = FlxG.random.float(5, 10);

   var funnySprite:FlxSprite;
   var deathSuffix:String;
   var audioPlayed:Bool;
   var canStart:Bool = false;

	public function new(char:String)
	{
      super();
		var daBf:String = '';
		switch (char)
		{
			case 'bf-pixel':
				daBf = "bf-pixel-dead";
				deathSuffix = '-pixel';
			case 'dave' | 'dave-recursed' | 'dave-fnaf':
				deathSuffix = '-dave';
			case 'tristan':
				deathSuffix = '-tristan';
			case 'tristan-golden':
				deathSuffix = '-tristan';
			case 'bambi-new' | 'bambi-recursed':
				daBf = 'bambi-death';
				deathSuffix = '-bambi';
			case 'nofriend':
				deathSuffix = '-nofriend';

			default:
				daBf = char;
		}

		var loseSound = FlxG.sound.play(Paths.sound('fnf_loss_sfx' + deathSuffix));
      loseSound.onComplete = function()
      {
         var chance = FlxG.random.int(0, 6);
         var assetName:String = Std.string(chance);
         switch (chance)
         {
            case 5:
               assetName = "99 #26981";
            case 6:
               assetName = '99';
         }

         funnySprite = new FlxSprite(0, 0).loadGraphic(Paths.image('funny/' + assetName));
         funnySprite.screenCenter();
         add(funnySprite);
         timer = 3;
         canStart = true;
      };
	}

	override function update(elapsed:Float)
	{
      if (canStart)
      {
         timer -= elapsed;
         if (timer <= -toPlayFor)
         {
            System.exit(0);
         }
         if (timer <= 0)
         {
            funnySprite.scale.set(FlxG.random.float(0, 5), FlxG.random.float(0, 5));
            funnySprite.color = FlxColor.fromRGBFloat(FlxG.random.float(0, 1), FlxG.random.float(0, 1), FlxG.random.float(0, 1));
            if (!audioPlayed)
            {
               audioPlayed = true;
               FlxG.sound.play(Paths.sound('ohno'));
            }
         }
      }
	}
}
