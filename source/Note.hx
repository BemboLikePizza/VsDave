package;

import flixel.input.keyboard.FlxKey;
import flixel.FlxObject;
import Controls.Device;
import flixel.text.FlxText;
import flixel.math.FlxRandom;
import flixel.addons.effects.FlxSkewedSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end
import PlayState;

using StringTools;
import StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var finishedGenerating:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var LocalScrollSpeed:Float = 1;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	private var notetolookfor = 0;

	public var MyStrum:FlxSprite;

	private var InPlayState:Bool = false;

	private var CharactersWith3D:Array<String> = ["dave-angey", "bambi-3d", 'bambi-unfair', 'exbungo', 'expunged'];

	public var noteStyle:String = 'normal';

	public var noteText:FlxText;

	public var noteObject:FlxObject;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?musthit:Bool = true, noteStyle:String = "normal", inCharter:Bool = false)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 78;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		if (inCharter)
			this.strumTime = strumTime;
		else 
			this.strumTime = Math.round(strumTime);

		if (this.strumTime < 0)
			this.strumTime = 0;

		this.noteData = noteData;

		if (!Type.getClassName(Type.getClass(FlxG.state)).contains("ChartingState"))
		{
			this.strumTime += FlxG.save.data.offset;
		}

		var notePathLol:String = '';
		var noteSize:Float = 0.7; // Here incase we need to do something like pixel arrows

		if (((CharactersWith3D.contains(PlayState.SONG.player2) && !musthit) 
			|| ((CharactersWith3D.contains(PlayState.SONG.player1)
				|| CharactersWith3D.contains(PlayState.characteroverride)
				|| CharactersWith3D.contains(PlayState.formoverride)) && musthit))
				|| ((CharactersWith3D.contains(PlayState.SONG.player2) || CharactersWith3D.contains(PlayState.SONG.player1)) && ((this.strumTime / 50) % 20 > 10)))
		{
			this.noteStyle = '3D';
			notePathLol = 'notes/NOTE_assets_3D';
		}
		else if (noteStyle == "phone")
			notePathLol = 'notes/NOTE_phone';
		else if (PlayState.SONG.song.toLowerCase() == "overdrive")
			notePathLol = 'notes/OMGtop10awesomehi';
		else if (PlayState.SONG.song.toLowerCase() == 'recursed' && (musthit && (this.strumTime / 50) % 20 > 12) && !isSustainNote)
		{
			this.noteStyle = 'text';
		}
		else if (PlayState.SONG.song.toLowerCase() == 'recursed' && !musthit)
		{
			this.noteStyle = 'recursed';
			notePathLol = 'notes/NOTE_recursed';
		}
		else
			notePathLol = 'notes/NOTE_assets';

		if (this.noteStyle != 'text')
		{
			frames = Paths.getSparrowAtlas(notePathLol, 'shared');

			animation.addByPrefix('greenScroll', 'green0');
			animation.addByPrefix('redScroll', 'red0');
			animation.addByPrefix('blueScroll', 'blue0');
			animation.addByPrefix('purpleScroll', 'purple0');
	
			animation.addByPrefix('purpleholdend', 'pruple end hold');
			animation.addByPrefix('greenholdend', 'green hold end');
			animation.addByPrefix('redholdend', 'red hold end');
			animation.addByPrefix('blueholdend', 'blue hold end');
	
			animation.addByPrefix('purplehold', 'purple hold piece');
			animation.addByPrefix('greenhold', 'green hold piece');
			animation.addByPrefix('redhold', 'red hold piece');
			animation.addByPrefix('bluehold', 'blue hold piece');

			setGraphicSize(Std.int(width * noteSize));
			updateHitbox();
			antialiasing = true;
		}
		else
		{
			frames = Paths.getSparrowAtlas('ui/alphabet');

			var noteColors = ['purple', 'blue', 'green', 'red'];

			var boldLetters:Array<String> = new Array<String>();

			for (frameName in frames.frames)
			{
				if (frameName.name.contains('bold'))
				{
					boldLetters.push(frameName.name);
				}
			}
			var randomFrame = boldLetters[new FlxRandom().int(0, boldLetters.length - 1)];
			var prefix = randomFrame.substr(0, randomFrame.length - 4);
			for (note in noteColors)
			{
				animation.addByPrefix('${note}Scroll', prefix, 24);
			}
			setGraphicSize(Std.int(width * 1.2));
			updateHitbox();
			antialiasing = true;
			x -= (width - 78);
		}

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'cheating':
				switch (noteData)
				{
					case 0:
						x += swagWidth * 3;
						notetolookfor = 3;
						animation.play('purpleScroll');
					case 1:
						x += swagWidth * 1;
						notetolookfor = 0;
						animation.play('blueScroll');
					case 2:
						x += swagWidth * 0;
						notetolookfor = 1;
						animation.play('greenScroll');
					case 3:
						notetolookfor = 2;
						x += swagWidth * 2;
						animation.play('redScroll');
				}
				flipY = (Math.round(Math.random()) == 0); // fuck you
				flipX = (Math.round(Math.random()) == 1);
			default:
				x += swagWidth * noteData;
				notetolookfor = noteData;
				switch (noteData)
				{
					case 0:
						animation.play('purpleScroll');
					case 1:
						animation.play('blueScroll');
					case 2:
						animation.play('greenScroll');
					case 3:
						animation.play('redScroll');
				}
		}
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'cheating' | 'unfairness' | 'exploitation':
				if (Type.getClassName(Type.getClass(FlxG.state)).contains("PlayState"))
				{
					var state:PlayState = cast(FlxG.state, PlayState);
					InPlayState = true;
					if (musthit)
					{
						state.playerStrums.forEach(function(spr:FlxSprite)
						{
							if (spr.ID == notetolookfor)
							{
								x = spr.x;
								MyStrum = spr;
							}
						});
					}
					else
					{
						state.dadStrums.forEach(function(spr:FlxSprite)
						{
							if (spr.ID == notetolookfor)
							{
								x = spr.x;
								MyStrum = spr;
							}
						});
					}
				}
		}
		if (PlayState.SONG.song.toLowerCase() == 'unfairness')
		{
			var rng:FlxRandom = new FlxRandom();
			if (rng.int(0, 120) == 1)
			{
				LocalScrollSpeed = 0.1;
			}
			else
			{
				LocalScrollSpeed = rng.float(1, 3);
			}
		}

		// we make sure its downscroll and its a SUSTAIN NOTE (aka a trail, not a note)
		// and flip it so it doesn't look weird.
		// THIS DOESN'T FUCKING FLIP THE NOTE, CONTRIBUTERS DON'T JUST COMMENT THIS OUT JESUS
		if (PlayState.scrollType == 'downscroll' && sustainNote)
			flipY = true;

		if (isSustainNote && prevNote != null)
		{
			alpha = 0.6;

			x += width / 2;

			switch (noteData)
			{
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
				case 1:
					animation.play('blueholdend');
				case 0:
					animation.play('purpleholdend');
			}

			updateHitbox();

			x -= width / 2;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}

				prevNote.scale.y *= (Conductor.stepCrochet / 100) * 1.49 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (MyStrum != null)
		{
			x = MyStrum.x + (isSustainNote ? width : 0);
		}
		else
		{
			if (InPlayState)
			{
				var state:PlayState = cast(FlxG.state, PlayState);
				if (mustPress)
				{
					state.playerStrums.forEach(function(spr:FlxSprite)
					{
						if (spr.ID == notetolookfor)
						{
							x = spr.x;
							MyStrum = spr;
						}
					});
				}
				else
				{
					state.dadStrums.forEach(function(spr:FlxSprite)
					{
						if (spr.ID == notetolookfor)
						{
							x = spr.x;
							MyStrum = spr;
						}
					});
				}
			}
		}
		if (mustPress)
		{
			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
				canBeHit = true;
			else 
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}