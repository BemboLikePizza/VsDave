package;

import flixel.FlxSprite;

class StrumNote extends FlxSprite
{
   public var copyAlpha:Bool = false;
   public var copyX:Bool = false;

   public function new(x:Float, y:Float, type:String, strumID:Int)
   {
      super(x, y);

		ID = strumID;

      //get the frames and stuff
      switch (type)
      {
         case '3D':
            frames = Paths.getSparrowAtlas('notes/NOTE_assets_3D');
         case 'top10awesome':
            frames = Paths.getSparrowAtlas('notes/OMGtop10awesomehi');
         case 'gh':
            frames = Paths.getSparrowAtlas('notes/NOTE_gh');
         default:
            frames = Paths.getSparrowAtlas('notes/NOTE_assets');
      }
      //actually load in the animation
      switch (type)
      {
         case 'gh':
            animation.addByPrefix('green', 'arrowUP');
            animation.addByPrefix('blue', 'arrowDOWN');
            animation.addByPrefix('purple', 'arrowLEFT');
            animation.addByPrefix('red', 'arrowRIGHT');
            animation.addByPrefix('yellow', 'arrowLEFT');

				switch (Math.abs(strumID))
				{
					case 0:
						animation.addByPrefix('static', 'arrowLEFT');
						animation.addByPrefix('pressed', 'left press', 24, false);
						animation.addByPrefix('confirm', 'left confirm', 24, false);
					case 1:
						animation.addByPrefix('static', 'arrowDOWN');
						animation.addByPrefix('pressed', 'down press', 24, false);
						animation.addByPrefix('confirm', 'down confirm', 24, false);
					case 2:
						animation.addByPrefix('static', 'arrowLEFT');
						animation.addByPrefix('pressed', 'left press', 24, false);
						animation.addByPrefix('confirm', 'left confirm', 24, false);
					case 3:
						animation.addByPrefix('static', 'arrowUP');
						animation.addByPrefix('pressed', 'up press', 24, false);
						animation.addByPrefix('confirm', 'up confirm', 24, false);
					case 4:
						animation.addByPrefix('static', 'arrowRIGHT');
						animation.addByPrefix('pressed', 'right press', 24, false);
						animation.addByPrefix('confirm', 'right confirm', 24, false);
				}
			default:
				animation.addByPrefix('green', 'arrowUP');
				animation.addByPrefix('blue', 'arrowDOWN');
				animation.addByPrefix('purple', 'arrowLEFT');
				animation.addByPrefix('red', 'arrowRIGHT');
				switch (Math.abs(strumID))
				{
					case 0:
						animation.addByPrefix('static', 'arrowLEFT');
						animation.addByPrefix('pressed', 'left press', 24, false);
						animation.addByPrefix('confirm', 'left confirm', 24, false);
					case 1:
						animation.addByPrefix('static', 'arrowDOWN');
						animation.addByPrefix('pressed', 'down press', 24, false);
						animation.addByPrefix('confirm', 'down confirm', 24, false);
					case 2:
						animation.addByPrefix('static', 'arrowUP');
						animation.addByPrefix('pressed', 'up press', 24, false);
						animation.addByPrefix('confirm', 'up confirm', 24, false);
					case 3:
						animation.addByPrefix('static', 'arrowRIGHT');
						animation.addByPrefix('pressed', 'right press', 24, false);
						animation.addByPrefix('confirm', 'right confirm', 24, false);
				}
      }
      animation.play('static');

      antialiasing = true;

      setGraphicSize(Std.int(width * 0.7));
      updateHitbox();
	  
      scrollFactor.set();
   }
}