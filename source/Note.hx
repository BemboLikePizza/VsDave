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

	public var originalType = 0;

	public var MyStrum:FlxSprite;

	private var InPlayState:Bool = false;

	private var CharactersWith3D:Array<String> = ["dave-angey", "bambi-3d", 'bambi-unfair', 'exbungo', 'expunged', 'dave-festival-3d', 'dave-3d-recursed'];

	public var noteStyle:String = 'normal';

	public var noteText:FlxText;

	public var noteObject:FlxObject;
	public var guitarSection:Bool;

	public var alphaMult:Float = 1.0;

	public var noteOffset:Float = 0;

	public var ModchartEnabled:Bool = true;

	var notes = ['purple', 'blue', 'green', 'red'];

	public function GoToStrum(strum:FlxSprite)
	{
		x = strum.x + (isSustainNote ? width : 0);
		x += noteOffset;
		alpha = strum.alpha * alphaMult;
	}

	public function InPlaystate()
	{
		return Type.getClassName(Type.getClass(FlxG.state)).contains("PlayState");
	}

	public function SearchForStrum(musthit:Bool)
	{
		var state:PlayState = cast(FlxG.state, PlayState);
		InPlayState = true;
		if (musthit)
		{
			state.playerStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.ID == notetolookfor)
				{
					GoToStrum(spr);
					MyStrum = spr;
					return;
				}
			});
		}
		else
		{
			state.dadStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.ID == notetolookfor)
				{
					GoToStrum(spr);
					MyStrum = spr;
					return;
				}
			});
		}
	}

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?musthit:Bool = true, noteStyle:String = "normal", inCharter:Bool = false, guitarSection:Bool = false)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		this.noteStyle = noteStyle;
		isSustainNote = sustainNote;
		originalType = noteData;
		this.guitarSection = guitarSection;
		
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
		if ((guitarSection && inCharter && noteData < 5) || (guitarSection))
		{
			notes = ['purple', 'blue', 'yellow', 'green', 'red'];
		}

		var notePathLol:String = '';
		var noteSize:Float = 0.7; // Here incase we need to do something like pixel arrows

		if (((CharactersWith3D.contains(PlayState.SONG.player2) && !musthit) || ((CharactersWith3D.contains(PlayState.SONG.player1)
				|| CharactersWith3D.contains(PlayState.characteroverride) || CharactersWith3D.contains(PlayState.formoverride)) && musthit))
				|| ((CharactersWith3D.contains(PlayState.SONG.player2) || CharactersWith3D.contains(PlayState.SONG.player1)) && ((this.strumTime / 50) % 20 > 10)))
		{
			this.noteStyle = '3D';
			notePathLol = 'notes/NOTE_assets_3D';
		}
		else if (noteStyle == "phone")
			notePathLol = 'notes/NOTE_phone';
		else if (PlayState.SONG.song.toLowerCase() == "overdrive")
			notePathLol = 'notes/OMGtop10awesomehi';
		else if (PlayState.SONG.song.toLowerCase() == 'recursed' && !musthit)
		{
			this.noteStyle = 'recursed';
			if (sustainNote)
			{
				noteOffset = 18;
			}
			notePathLol = 'notes/NOTE_recursed';
		}
		else
			notePathLol = 'notes/NOTE_assets';

		if (PlayState.SONG.song.toLowerCase() == 'recursed' && (musthit && (this.strumTime / 50) % 20 > 12) && !isSustainNote)
		{
			this.noteStyle = 'text';
		}
		if (guitarSection)
		{
			this.noteStyle = 'guitarHero';
		}
		switch (this.noteStyle)
		{
			default:
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
			case 'text':
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
				noteOffset = -(width - 78);
			case 'guitarHero':
				frames = Paths.getSparrowAtlas('notes/NOTE_gh', 'shared');

				animation.addByPrefix('greenScroll', 'green alone');
				animation.addByPrefix('redScroll', 'red alone');
				animation.addByPrefix('blueScroll', 'blue alone');
				animation.addByPrefix('purpleScroll', 'purple alone');
				animation.addByPrefix('yellowScroll', 'purple alone');

				animation.addByPrefix('purpleholdend', 'purple tail');
				animation.addByPrefix('greenholdend', 'green tail');
				animation.addByPrefix('redholdend', 'red tail');
				animation.addByPrefix('blueholdend', 'blue tail');
				animation.addByPrefix('yellowholdend', 'purple tail');
		
				animation.addByPrefix('purplehold', 'purple hold');
				animation.addByPrefix('greenhold', 'green hold');
				animation.addByPrefix('redhold', 'red hold');
				animation.addByPrefix('bluehold', 'blue hold');
				animation.addByPrefix('yellowhold', 'purple hold');

				setGraphicSize(Std.int(width * noteSize));
				updateHitbox();
				antialiasing = true;
			case 'phone':
				frames = Paths.getSparrowAtlas('notes/NOTE_phone', 'shared');
				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');
				animation.addByPrefix('yellowScroll', 'purple');

				LocalScrollSpeed = 1.08;
				
				setGraphicSize(Std.int(width * noteSize));
				updateHitbox();
				antialiasing = true;
				
				//x -= (width - 78);
				//TODO: make this MATH.
				noteOffset = 20;

		}
		var str:String = PlayState.SONG.song.toLowerCase();
		if (InPlaystate())
		{
			var state:PlayState = cast(FlxG.state, PlayState);
			if (state.localFunny == CharacterFunnyEffect.Dave)
			{
				str = 'cheating';
			}
		}
		switch (str)
		{
			case 'cheating':
				switch (originalType)
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
				x += swagWidth * originalType;
				notetolookfor = originalType;

				animation.play('${notes[originalType]}Scroll');
		}
		if (InPlaystate() && ModchartEnabled)
		{
			SearchForStrum(musthit);
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
		if (PlayState.SONG.song.toLowerCase() == 'exploitation')
		{
			var rng:FlxRandom = new FlxRandom();
			if (rng.int(0, 481) == 1)
			{
				LocalScrollSpeed = 0.1;
			}
			else
			{
				LocalScrollSpeed = rng.float(2.8, 3.7);
			}
		}

		if (PlayState.scrollType == 'downscroll' && sustainNote)
			flipY = true;

		if (isSustainNote && prevNote != null)
		{
			alphaMult = 0.6;

			x += width / 2;

			animation.play('${notes[noteData]}holdend');

			updateHitbox();

			x -= width / 2;

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play('${notes[prevNote.noteData]}hold');

				prevNote.scale.y *= (Conductor.stepCrochet / 100) * 1.49 * PlayState.SONG.speed;
				prevNote.updateHitbox();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (MyStrum != null)
		{
			GoToStrum(MyStrum);
		}
		else
		{
			if (InPlayState && ModchartEnabled)
			{
				SearchForStrum(mustPress);
			}
		}
		if (mustPress && InPlaystate())
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
			alphaMult = 0.3;
		}
	}
}