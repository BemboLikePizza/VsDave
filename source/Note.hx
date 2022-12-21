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

	private var CharactersWith3D:Array<String> = ["dave-angey", "bambi-3d", 'bambi-unfair', 'exbungo', 'expunged', 'dave-festival-3d', 'dave-3d-recursed', 'bf-3d', 'nofriend'];

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	private var notetolookfor = 0;

	public var originalType = 0;

	public var MyStrum:StrumNote;

	public var noteStyle:String = 'normal';

	public var guitarSection:Bool;

	public var alphaMult:Float = 1.0;
	public var noteOffset:Float = 0;

	var notes = ['purple', 'blue', 'green', 'red'];

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?musthit:Bool = true, noteStyle:String = "normal", inCharter:Bool = false, guitarSection:Bool = false)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		this.noteStyle = noteStyle;
		this.isSustainNote = sustainNote;
		this.originalType = noteData;
		this.guitarSection = guitarSection;
		this.noteData = noteData;

		x += 78;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		//NOW IT SHALL FOR REALLY ALWAYS BE OFF SCREEN.
		//luckily i think only the devs really noticed that you can see the notes spawn in at the bottom of the screen when there is a modchart.
		y -= 9000;
		
		inCharter ? this.strumTime = strumTime : {
			this.strumTime = Math.round(strumTime);
			alpha = 0;
		}
		
		if (this.strumTime < 0)
			this.strumTime = 0;

		if (isInState('PlayState'))
		{
			this.strumTime += FlxG.save.data.offset;
		}		
		if ((guitarSection && inCharter && noteData < 5) || (guitarSection))
		{
			notes = ['green', 'red', 'yellow', 'blue', 'orange'];
		}

		var notePathLol:String = 'notes/NOTE_assets';
		var noteSize:Float = 0.7;

		if ((((CharactersWith3D.contains(PlayState.SONG.player2) && !musthit) || ((CharactersWith3D.contains(PlayState.SONG.player1)
				|| CharactersWith3D.contains(PlayState.characteroverride) || CharactersWith3D.contains(PlayState.formoverride)) && musthit))
				|| ((CharactersWith3D.contains(PlayState.SONG.player2) || CharactersWith3D.contains(PlayState.SONG.player1)) && ((this.strumTime / 50) % 20 > 10)))
				&& this.noteStyle == 'normal')
		{
			this.noteStyle = '3D';
			notePathLol = 'notes/NOTE_assets_3D';
		}
		switch (noteStyle)
		{
			case 'phone':
				notePathLol = 'notes/NOTE_phone';
			case 'shape':
				notePathLol = 'notes/NOTE_assets_Shape';
		}
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'overdrive':
				notePathLol = 'notes/OMGtop10awesomehi';
			case 'recursed':
				musthit ? {
					if ((this.strumTime / 50) % 20 > 12 && !isSustainNote)
					{
						this.noteStyle = 'text';
					}
				} : {
					this.noteStyle = 'recursed';
					notePathLol = 'notes/NOTE_recursed';
				}
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
				antialiasing = noteStyle != '3D';
			
			case 'shape':
				frames = Paths.getSparrowAtlas(notePathLol, 'shared');

				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');
		
				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');

				animation.addByPrefix('purpleholdend', 'purple hold piece');
				animation.addByPrefix('greenholdend', 'green hold piece');
				animation.addByPrefix('redholdend', 'red hold piece');
				animation.addByPrefix('blueholdend', 'blue hold piece');

				setGraphicSize(Std.int(width * noteSize));
				updateHitbox();
				antialiasing = false;

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
				frames = Paths.getSparrowAtlas('notes/NOTEGH_assets', 'shared');

				animation.addByPrefix('greenScroll', 'A Note');
				animation.addByPrefix('greenhold', 'A Hold Piece');
				animation.addByPrefix('greenholdend', 'A Hold End');


				animation.addByPrefix('redScroll', 'B Note');
				animation.addByPrefix('redhold', 'B Hold Piece');
				animation.addByPrefix('redholdend', 'B Hold End');

				animation.addByPrefix('yellowScroll', 'C Note');
				animation.addByPrefix('yellowhold', 'C Hold Piece');
				animation.addByPrefix('yellowholdend', 'C Hold End');

				animation.addByPrefix('blueScroll', 'D Note');
				animation.addByPrefix('bluehold', 'D Hold Piece');
				animation.addByPrefix('blueholdend', 'D Hold End');

				animation.addByPrefix('orangeScroll', 'E Note');
				animation.addByPrefix('orangehold', 'E Hold Piece');
				animation.addByPrefix('orangeholdend', 'E Hold End');

				setGraphicSize(Std.int(width * noteSize));
				updateHitbox();
				antialiasing = true;
			case 'phone' | 'phone-alt':
				if (!isSustainNote)
				{
					frames = Paths.getSparrowAtlas('notes/NOTE_phone', 'shared');
				}
				else
				{
					frames = Paths.getSparrowAtlas('notes/NOTE_assets', 'shared');
				}
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

				LocalScrollSpeed = 1.08;
				
				setGraphicSize(Std.int(width * noteSize));
				updateHitbox();
				antialiasing = true;
				
				noteOffset = 20;

		}
		var str:String = PlayState.SONG.song.toLowerCase();
		if (isInState('PlayState'))
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
		if (isInState('PlayState'))
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
			if (rng.int(0, 484) == 1)
			{
				LocalScrollSpeed = 0.1;
			}
			else
			{
				LocalScrollSpeed = rng.float(2.9, 3.6);
			}
		}

		if (isSustainNote && prevNote != null)
		{
			alphaMult = 0.6;

			noteOffset += width / 2;

			animation.play('${notes[noteData]}holdend');

			if (PlayState.scrollType == 'downscroll')
			{
				flipY = true;
			}

			updateHitbox();

			noteOffset -= width / 2;

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play('${notes[prevNote.noteData]}hold');

				if (noteStyle != 'shape')
				{
					prevNote.scale.y *= (Conductor.stepCrochet / 100) * PlayState.SONG.speed * 1.5;
					prevNote.updateHitbox();
				}
				else
				{
					prevNote.scale.y *= (Conductor.stepCrochet / 100) * PlayState.SONG.speed * 0.75;
					prevNote.scale.x *= (Conductor.stepCrochet / 100) * PlayState.SONG.speed * 0.5;
					prevNote.offset.y += prevNote.height / 3;
					prevNote.updateHitbox();
				}
			}
			if (noteStyle == 'shape' && isSustainNote)
			{
				alphaMult = 1;
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
			if (isInState('PlayState'))
			{
				SearchForStrum(mustPress);
			}
		}
		if (mustPress && isInState('PlayState'))
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
	public function GoToStrum(strum:StrumNote)
	{
		x = strum.x + noteOffset;
		alpha = strum.alpha * alphaMult;

		if (strum.pressingKey5)
		{
			if (noteStyle != "shape")
			{
				alpha *= 0.5;
			}
		}
		else
		{
			if (noteStyle == "shape")
			{
				alpha *= 0.5;
			}
		}
	}

	public function isInState(state:String)
	{
		return Type.getClassName(Type.getClass(FlxG.state)).contains(state);
	}

	public function SearchForStrum(musthit:Bool)
	{
		var state:PlayState = cast(FlxG.state, PlayState);
		if (musthit)
		{
			state.playerStrums.forEach(function(spr:StrumNote)
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
			state.dadStrums.forEach(function(spr:StrumNote)
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
}