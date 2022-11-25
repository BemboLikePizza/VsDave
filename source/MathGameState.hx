package;

import flixel.system.FlxSound;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;

class MathGameState extends MusicBeatState
{
	var yctp:FlxSprite;
	var baldi:FlxSprite;

	var questionText:FlxText;
	var inputField:FlxText;

	var resultPos:Array<FlxPoint> = [new FlxPoint(280, 156), new FlxPoint(273, 243), new FlxPoint(270, 338)];
	var mathButtons:FlxTypedGroup<MathButton> = new FlxTypedGroup<MathButton>();

	var audioQueue:Array<MathSound> = new Array<MathSound>();
	var baldiAudio:FlxSound = new FlxSound();
	var curQuestion:Int = 0;
	var num1:Int;
	var num2:Int;
	var sign:Int;
	var solution:Float;
	var operat:String;
	var endState:String = '';

	public var endDelay:Float;

	public static var failedGame:Bool;
	public static var accessThroughTerminal:Bool;

	override function create()
	{
		persistentUpdate = persistentDraw = true;

		baldiAudio = new FlxSound();
		FlxG.sound.music.stop();
		FlxG.sound.playMusic(Paths.music('math/mus_Learn', 'shared'), 1, true, null);

		queueAudio(new MathSound(Paths.sound('math/BAL_Math_Intro', 'shared'), 1, false));
		queueAudio(new MathSound(Paths.sound('math/BAL_General_HowTo', 'shared'), 1, false));

		Conductor.changeBPM(120);

		baldi = new FlxSprite(265, 442);

		baldi.frames = Paths.getSparrowAtlas('math/Baldi_MathGame_Sheet', 'shared');
		baldi.animation.addByIndices('talkIdle', 'talk', [0], '', 0, false);
		baldi.animation.addByPrefix('talk', 'talk', 60);
		baldi.animation.addByPrefix('frown', 'frown', 30, false);
		baldi.setGraphicSize(179, 187);
		baldi.updateHitbox();
		baldi.antialiasing = false;
		baldi.scrollFactor.set();
		baldi.animation.play('talkIdle');
		add(baldi);

		var whiteFill:FlxSprite = new FlxSprite(275, 160).makeGraphic(644, 264, FlxColor.WHITE);
		whiteFill.scrollFactor.set();
		add(whiteFill);

		var whiteFill2:FlxSprite = new FlxSprite(485, 446.7).makeGraphic(404, 151, FlxColor.WHITE);
		whiteFill2.scrollFactor.set();
		add(whiteFill2);

		questionText = new FlxText(417, 169, 426, 'SOLVE MATH Q1:\n\n9+1=', 45);
		questionText.setFormat(Paths.font('comic_normal.ttf'), 45, FlxColor.BLACK, FlxTextAlign.LEFT);
		questionText.scrollFactor.set();
		add(questionText);

		inputField = new FlxText(508, 487, 514.7, "", 44);
		inputField.setFormat(Paths.font('comic_normal.ttf'), 50, FlxColor.BLACK, FlxTextAlign.LEFT);
		inputField.scrollFactor.set();
		add(inputField);

		yctp = new FlxSprite(3, -125).loadGraphic(Paths.image('math/YCTP', 'shared'));
		yctp.setGraphicSize(1280, 969);
		yctp.updateHitbox();
		yctp.antialiasing = false;
		yctp.scrollFactor.set();
		add(yctp);

		var buttonStuff:Array<Dynamic> = [
			['7', 959, 140], ['8', 1041, 140], ['9', 1122, 140], ['4', 959, 221], ['5', 1040, 222], ['6', 1122, 221], ['1', 959, 304], ['2', 1041, 303],
			['3', 1122, 303], ['C', 959, 385], ['0', 1041, 385], ['-', 1122, 384], ['OK', 960, 466]];
		for (i in 0...buttonStuff.length)
		{
			var button = new MathButton(buttonStuff[i][1], buttonStuff[i][2], buttonStuff[i][0], function()
			{
				switch (buttonStuff[i][0])
				{
					case 'OK':
						if (endState == '')
						{
							checkAnswer();
						}
					case 'C':
						inputField.text = '';
					default:
						inputField.text += buttonStuff[i][0];
				}
			});
			button.loadGraphic(Paths.image('math/buttons/${buttonStuff[i][0]}', 'shared'));
			button.setGraphicSize(Std.int(button.width * 1.22));
			button.updateHitbox();
			button.scrollFactor.set();
			mathButtons.add(button);
			add(button);
		}
		generateQuestion();

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null && !failedGame)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, 0.95);

		if (!FlxG.mouse.visible)
		{
			FlxG.mouse.visible = true;
		}

		var keyID = FlxG.keys.firstJustPressed();
		if (keyID > -1)
		{
			switch (keyID)
			{
				case FlxKey.ENTER:
					if (endState == '')
					{
						checkAnswer();
					}
				case FlxKey.BACKSPACE:
					if (inputField.text.length > 0)
					{
						inputField.text = inputField.text.substr(0, inputField.text.length - 1);
					}
				default:
					var keyJustPressed = cast(keyID, FlxKey).toString();

					var validKeys:Array<Dynamic> = [
						['MINUS', '-'], ['ONE', '1'], ['TWO', '2'], ['THREE', '3'], ['FOUR', '4'], ['FIVE', '5'], ['SIX', '6'], ['SEVEN', '7'],
						['EIGHT', '8'], ['NINE', '9'], ['ZERO', '0'],
					];
					for (i in 0...validKeys.length)
					{
						if (keyJustPressed == validKeys[i][0])
						{
							inputField.text += validKeys[i][1];
						}
					}
			}
		}

		mathButtons.forEach(function(button:MathButton)
		{
			if (FlxG.mouse.overlaps(button))
			{
				button.loadGraphic(Paths.image('math/buttons/${button.id}_select', 'shared'));
				button.setGraphicSize(Std.int(button.width * 1.22));
				button.updateHitbox();
				if (FlxG.mouse.justPressed)
				{
					button.clickFunc();
				}
			}
			else
			{
				button.loadGraphic(Paths.image('math/buttons/${button.id}', 'shared'));
				button.setGraphicSize(Std.int(button.width * 1.22));
				button.updateHitbox();
			}
		});
		if (!baldiAudio.playing && audioQueue.length > 0)
		{
			playNextAudio();
		}
		if (!failedGame)
		{
			if (baldiAudio.playing && baldi.animation.curAnim.name != 'talk')
			{
				baldi.animation.play('talk');
			}
			else if (!baldiAudio.playing && baldi.animation.curAnim.name != 'talkIdle')
			{
				baldi.animation.play('talkIdle');
			}
		}

		if (endState != '')
		{
			if (endDelay > 0)
			{
				endDelay -= elapsed;
			}
			else
			{
				switch (endState)
				{
					case 'won':
						PlayState.SONG = Song.loadFromJson('roofs');
						PlayState.storyWeek = 7;

						FlxG.save.data.roofsUnlocked = true;
						FlxG.save.flush();

						FlxG.switchState(new PlayState());
					case 'failed':
						accessThroughTerminal ? FlxG.switchState(new MainMenuState()) : FlxG.switchState(new PlayState());
				}
			}
		}

		super.update(elapsed);
	}

	override function beatHit()
	{
		super.beatHit();

		if (curBeat % 2 == 0 && !failedGame)
		{
			FlxG.camera.zoom += 0.01;
		}
	}

	function generateQuestion()
	{
		inputField.text = '';
		curQuestion++;
		sign = FlxG.random.int(0, 2);
		num1 = FlxG.random.int(0, 9);
		num2 = FlxG.random.int(0, 9);
		var operatorAudio:String = '';
		switch (sign)
		{
			case 0: // addition
				solution = num1 + num2;
				operat = '+';
				operatorAudio = 'Plus';
			case 1: // substract
				solution = num1 - num2;
				operat = '-';
				operatorAudio = 'Minus';
			case 2: // multiply
				solution = num1 * num2;
				operat = '*';
				operatorAudio = 'Times';
		}
		questionText.text = 'SOLVE MATH Q${curQuestion}:\n\n$num1$operat$num2=';

		queueAudio(new MathSound(Paths.sound('math/BAL_General_Problem${curQuestion}', 'shared'), 1, false));

		queueAudio(new MathSound(Paths.sound('math/number/BAL_Math_$num1', 'shared'), 1, false));
		queueAudio(new MathSound(Paths.sound('math/BAL_Math_$operatorAudio', 'shared'), 1, false));
		queueAudio(new MathSound(Paths.sound('math/number/BAL_Math_$num2', 'shared'), 1, false));
		queueAudio(new MathSound(Paths.sound('math/BAL_Math_Equals', 'shared'), 1, false));
	}

	function checkAnswer()
	{
		var inputValue = Std.parseFloat(inputField.text);

		var result:FlxSprite = new FlxSprite(resultPos[curQuestion - 1].x, resultPos[curQuestion - 1].y);
		if (inputValue == solution)
		{
			clearQueue();
			queueAudio(new MathSound(Paths.sound('math/praise/BAL_Praise${FlxG.random.int(1, 5)}', 'shared'), 1, false));

			result.loadGraphic(Paths.image('math/Check', 'shared'));
			if (curQuestion == 3)
			{
				endDelay = 3;
				questionText.text = 'WOW! YOU EXIST!';
				endState = 'won';
			}
			else
			{
				generateQuestion();
			}
		}
		else
		{
			FlxG.sound.playMusic(Paths.music('math/mus_hang', 'shared'), 1, false, null);
			endState = 'failed';
			endDelay = 3;
			failedGame = true;

			clearQueue();
			baldi.animation.play('frown');

			questionText.text = 'I HEAR MATH THAT BAD';

			result.loadGraphic(Paths.image('math/X', 'shared'));
		}
		result.setGraphicSize(83, 83);
		result.updateHitbox();
		insert(members.indexOf(yctp), result);
	}

	function queueAudio(sound:MathSound)
	{
		audioQueue.push(sound);
	}

	function clearQueue()
	{
		while (audioQueue.length > 0)
		{
			unqueueAudio();
		}
		baldiAudio.stop();
	}

	function playNextAudio()
	{
		var soundToPlay = audioQueue[0];

		baldiAudio = new FlxSound().loadEmbedded(soundToPlay.soundAsset, soundToPlay.looped, false, null);
		baldiAudio.volume = soundToPlay.volume;
		baldiAudio.play();

		unqueueAudio();
	}

	function unqueueAudio()
	{
		audioQueue.remove(audioQueue[0]);
	}
}

class MathButton extends FlxSprite
{
	public var id:String;
	public var clickFunc:Void->Void;

	public function new(x:Float, y:Float, id:String, clickFunc:Void->Void)
	{
		this.id = id;
		this.clickFunc = clickFunc;

		super(x, y);
	}
}

class MathSound
{
	public var soundAsset:FlxSoundAsset;
	public var volume:Float;
	public var looped:Bool;

	public function new(soundAsset:FlxSoundAsset, volume:Float, looped:Bool)
	{
		this.soundAsset = soundAsset;
		this.volume = volume;
		this.looped = looped;
	}
}
