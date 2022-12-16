package;

import flixel.system.FlxSound;
import Controls.Device;
import Controls.Control;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.util.FlxStringUtil;
import lime.utils.Assets;
import flixel.FlxObject;
import flixel.addons.util.FlxAsyncLoop;
#if sys import sys.FileSystem; #end
#if desktop import Discord.DiscordClient; #end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;

	var bg:FlxSprite = new FlxSprite();

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	private var curChar:String = "unknown";

	private var InMainFreeplayState:Bool = false;

	private var CurrentSongIcon:FlxSprite;

	private var Catagories:Array<String> = ['dave', 'joke', 'extras'];
	var translatedCatagory:Array<String> = [
		LanguageManager.getTextString('freeplay_dave'),
		LanguageManager.getTextString('freeplay_joke'),
		LanguageManager.getTextString('freeplay_extra')
	];

	private var CurrentPack:Int = 0;
	private var NameAlpha:Alphabet;

	var loadingPack:Bool = false;

	var songColors:Array<FlxColor> = [
		0xFF00137F, // GF but its actually dave!
		0xFF4965FF, // DAVE
		0xFF00B515, // MISTER BAMBI RETARD (thats kinda rude ngl)
		0xFF00FFFF, // SPLIT THE THONNNNN
		0xFF800080, // FESTIVAL
		0xFF116E1C, // MASTA BAMBI
		0xFFFF0000, // KABUNGA
		0xFF0EAE2C, // SECRET MOD LEAK
		0xFFFF0000, // TRISTAN
		FlxColor.fromRGB(162, 150, 188), // PLAYROBOT
		FlxColor.fromRGB(44, 44, 44), // RECURSED
		0xFF31323F, // MOLDY
		0xFF35396C, // FIVE NIGHT
		0xFF0162F5, // OVERDRIVE
		0xFF119A2B, // CHEATING
		0xFFFF0000, // UNFAIRNESS
		0xFF810000, // EXPLOITATION
	];

	public static var skipSelect:Array<String> = ['five-nights', 'vs-dave-rap', 'vs-dave-rap-two'];

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var iconArray:Array<HealthIcon> = [];

	var titles:Array<Alphabet> = [];
	var icons:Array<FlxSprite> = [];

	var doneCoolTrans:Bool = false;

	var defColor:FlxColor;
	var canInteract:Bool = true;

	// recursed
	var timeSincePress:Float;
	var lastTimeSincePress:Float;

	var pressSpeed:Float;
	var pressSpeeds:Array<Float> = new Array<Float>();
	var pressUnlockNumber:Int;
	var requiredKey:Array<Int>;
	var stringKey:String;

	var bgShader:Shaders.GlitchEffect;
	var awaitingExploitation:Bool;

	public static var packTransitionDone:Bool = false;

	var characterSelectText:FlxText;
	var showCharText:Bool = true;

	override function create()
	{
		#if desktop DiscordClient.changePresence("In the Freeplay Menu", null); #end

		awaitingExploitation = (FlxG.save.data.exploitationState == 'awaiting');
		showCharText = FlxG.save.data.wasInCharSelect;

		if (awaitingExploitation)
		{
			bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('backgrounds/void/redsky', 'shared'));
			bg.scrollFactor.set();
			bg.antialiasing = false;
			bg.color = FlxColor.multiply(bg.color, FlxColor.fromRGB(50, 50, 50));
			add(bg);

			#if SHADERS_ENABLED
			bgShader = new Shaders.GlitchEffect();
			bgShader.waveAmplitude = 0.1;
			bgShader.waveFrequency = 5;
			bgShader.waveSpeed = 2;

			bg.shader = bgShader.shader;
			#end
			defColor = bg.color;
		}
		else
		{
			bg.loadGraphic(MainMenuState.randomizeBG());
			bg.color = 0xFF4965FF;
			defColor = bg.color;
			bg.scrollFactor.set();
			add(bg);
		}
		if (FlxG.save.data.terminalFound && !awaitingExploitation)
		{
			Catagories = ['dave', 'joke', 'extras', 'terminal'];
			translatedCatagory = [
				LanguageManager.getTextString('freeplay_dave'),
				LanguageManager.getTextString('freeplay_joke'),
				LanguageManager.getTextString('freeplay_extra'),
				LanguageManager.getTextString('freeplay_terminal')
			];
		}

		for (i in 0...Catagories.length)
		{
			Highscore.load();

			var CurrentSongIcon:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('packs/' + (Catagories[i].toLowerCase()), "preload"));
			CurrentSongIcon.centerOffsets(false);
			CurrentSongIcon.x = (1000 * i + 1) + (512 - CurrentSongIcon.width);
			CurrentSongIcon.y = (FlxG.height / 2) - 256;
			CurrentSongIcon.antialiasing = true;

			var NameAlpha:Alphabet = new Alphabet(40, (FlxG.height / 2) - 282, translatedCatagory[i], true, false);
			NameAlpha.x = CurrentSongIcon.x;

			add(CurrentSongIcon);
			icons.push(CurrentSongIcon);
			add(NameAlpha);
			titles.push(NameAlpha);
		}

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(icons[CurrentPack].x + 256, icons[CurrentPack].y + 256);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		FlxG.camera.focusOn(camFollow.getPosition());

		if (awaitingExploitation)
		{
			if (!packTransitionDone)
			{
				var curIcon = icons[CurrentPack];
				var curTitle = titles[CurrentPack];

				canInteract = false;
				var expungedPack:FlxSprite = new FlxSprite(curIcon.x, curIcon.y).loadGraphic(Paths.image('packs/uhoh', "preload"));
				expungedPack.centerOffsets(false);
				expungedPack.antialiasing = false;
				expungedPack.alpha = 0;
				add(expungedPack);

				var expungedTitle:Alphabet = new Alphabet(40, (FlxG.height / 2) - 282, 'uh oh', true, false);
				expungedTitle.x = expungedPack.x;
				add(expungedTitle);

				FlxTween.tween(curIcon, {alpha: 0}, 1);
				FlxTween.tween(curTitle, {alpha: 0}, 1);
				FlxTween.tween(expungedTitle, {alpha: 1}, 1);
				FlxTween.tween(expungedPack, {alpha: 1}, 1, {
					onComplete: function(tween:FlxTween)
					{
						icons[CurrentPack].destroy();
						titles[CurrentPack].destroy();

						icons[CurrentPack] = expungedPack;
						titles[CurrentPack] = expungedTitle;

						curIcon.alpha = 1;
						curTitle.alpha = 1;

						Catagories = ['uhoh'];
						translatedCatagory = ['uh oh'];
						packTransitionDone = true;
						canInteract = true;
					}
				});
			}
			else
			{
				var originalIconPos = icons[CurrentPack].getPosition();
				var originalTitlePos = titles[CurrentPack].getPosition();

				icons[CurrentPack].destroy();
				titles[CurrentPack].destroy();

				icons[CurrentPack].loadGraphic(Paths.image('packs/uhoh', "preload"));
				icons[CurrentPack].setPosition(originalIconPos.x, originalIconPos.y);
				icons[CurrentPack].centerOffsets(false);
				icons[CurrentPack].antialiasing = false;

				titles[CurrentPack] = new Alphabet(40, (FlxG.height / 2) - 282, 'uh oh', true, false);
				titles[CurrentPack].setPosition(originalTitlePos.x, originalTitlePos.y);

				Catagories = ['uhoh'];
				translatedCatagory = ['uh oh'];
			}
		}

		super.create();
	}

	public function LoadProperPack()
	{
		switch (Catagories[CurrentPack].toLowerCase())
		{
			case 'uhoh':
				addWeek(['Exploitation'], 16, ['expunged']);
			case 'dave':
				addWeek(['Warmup'], 0, ['dave']);
				addWeek(['House', 'Insanity', 'Polygonized'], 1, ['dave', 'dave-annoyed', 'dave-angey']);
				addWeek(['Blocked', 'Corn-Theft', 'Maze'], 2, ['bambi-new', 'bambi-new', 'bambi-new']);
				addWeek(['Splitathon'], 3, ['the-duo']);
				addWeek(['Shredder', 'Greetings', 'Interdimensional', 'Rano'], 4, ['bambi-new', 'tristan-festival', 'dave-festival-3d', 'dave-festival']);
			case 'joke':
				if (FlxG.save.data.hasPlayedMasterWeek)
				{
					addWeek(['Supernovae', 'Glitch', 'Master'], 5, ['bambi-joke']);
				}
				if (!FlxG.save.data.terminalFound)
				{
					if (FlxG.save.data.cheatingFound)
						addWeek(['Cheating'], 14, ['bambi-3d']);
					if (FlxG.save.data.unfairnessFound)
						addWeek(['Unfairness'], 15, ['bambi-unfair']);
				}
				if (FlxG.save.data.exbungoFound)
					addWeek(['Kabunga'], 6, ['exbungo']);

				if (FlxG.save.data.roofsUnlocked)
					addWeek(['Roofs'], 7, ['baldi']);

				addWeek(['Vs-Dave-Rap'], 1, ['dave-cool']);
				if (FlxG.save.data.vsDaveRapTwoFound)
				{
					addWeek(['Vs-Dave-Rap-Two'], 1, ['dave-cool']);
				}
			case 'extras':
				if (FlxG.save.data.recursedUnlocked)
					addWeek(['Recursed'], 10, ['recurser']);
				addWeek(['Bonus-Song'], 1, ['dave']);
				addWeek(['Bot-Trot'], 9, ['playrobot']);
				addWeek(['Escape-From-California'], 11, ['moldy']);
				addWeek(['Five-Nights'], 12, ['dave']);
				addWeek(['Adventure'], 8, ['tristan-opponent']);
				addWeek(['Overdrive'], 13, ['dave-awesome']);
				addWeek(['Mealie'], 2, ['bambi-loser']);
				addWeek(['Indignancy'], 2, ['bambi-angey']);
				addWeek(['Memory'], 1, ['dave']);
			case 'terminal':
				if (FlxG.save.data.cheatingFound)
					addWeek(['Cheating'], 14, ['bambi-3d']);
				if (FlxG.save.data.unfairnessFound)
					addWeek(['Unfairness'], 15, ['bambi-unfair']);
				if (FlxG.save.data.exploitationFound)
					addWeek(['Exploitation'], 16, ['expunged']);

				addWeek(['Enter Terminal'], 17, ['terminal']);
		}
	}

	var scoreBG:FlxSprite;

	public function GoToActualFreeplay()
	{
		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.itemType = 'Classic';
			songText.targetY = i;
			songText.scrollFactor.set();
			songText.alpha = 0;
			songText.y += 1000;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;
			icon.scrollFactor.set();

			iconArray.push(icon);
			add(icon);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 0, 0, "", 32);
		scoreText.setFormat(Paths.font("comic.ttf"), 32, FlxColor.WHITE, LEFT);
		scoreText.antialiasing = true;
		scoreText.y = -225;
		scoreText.scrollFactor.set();

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		scoreBG.scrollFactor.set();
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 15, 0, "", 24);
		diffText.setFormat(Paths.font("comic.ttf"), 24, FlxColor.WHITE, LEFT);
		diffText.antialiasing = true;
		diffText.scrollFactor.set();

		if (showCharText)
		{
			characterSelectText = new FlxText(FlxG.width, FlxG.height, 0, LanguageManager.getTextString("freeplay_skipChar"), 18);
			characterSelectText.setFormat("Comic Sans MS Bold", 18, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			characterSelectText.borderSize = 1.5;
			characterSelectText.antialiasing = true;
			characterSelectText.scrollFactor.set();
			characterSelectText.alpha = 0;
			characterSelectText.x -= characterSelectText.textField.textWidth;
			characterSelectText.y -= characterSelectText.textField.textHeight;
			add(characterSelectText);

			FlxTween.tween(characterSelectText, {alpha: 1}, 0.5, {ease: FlxEase.expoInOut});
		}

		add(diffText);
		add(scoreText);

		FlxTween.tween(scoreBG, {y: 0}, 0.5, {ease: FlxEase.expoInOut});
		FlxTween.tween(scoreText, {y: -5}, 0.5, {ease: FlxEase.expoInOut});
		FlxTween.tween(diffText, {y: 30}, 0.5, {ease: FlxEase.expoInOut});

		for (song in 0...grpSongs.length)
		{
			grpSongs.members[song].unlockY = true;

			// item.targetY = bullShit - curSelected;
			FlxTween.tween(grpSongs.members[song], {y: song, alpha: song == curSelected ? 1 : 0.6}, 0.5, {
				ease: FlxEase.expoInOut,
				onComplete: function(twn:FlxTween)
				{
					grpSongs.members[song].unlockY = false;

					canInteract = true;
				}
			});
		}

		changeSelection();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function UpdatePackSelection(change:Int)
	{
		CurrentPack += change;
		if (CurrentPack == -1)
			CurrentPack = Catagories.length - 1;

		if (CurrentPack == Catagories.length)
			CurrentPack = 0;

		camFollow.x = icons[CurrentPack].x + 256;
	}

	override function beatHit()
	{
		super.beatHit();
		FlxTween.tween(FlxG.camera, {zoom: 1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;

		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		#if SHADERS_ENABLED
		if (bgShader != null)
		{
			bgShader.shader.uTime.value[0] += elapsed;
		}
		#end

		if (InMainFreeplayState)
		{
			timeSincePress += elapsed;

			if (timeSincePress > 2 && pressSpeeds.length > 0)
			{
				resetPresses();
			}
			if (pressSpeeds.length >= pressUnlockNumber && !FlxG.save.data.recursedUnlocked)
			{
				var canPass:Bool = true;
				for (i in 0...pressSpeeds.length)
				{
					var pressSpeed = pressSpeeds[i];
					if (pressSpeed >= 0.5)
					{
						canPass = false;
					}
				}
				if (canPass)
				{
					recursedUnlock();
				}
				else
				{
					resetPresses();
				}
			}
		}
		else
		{
			timeSincePress = 0;
		}

		// Selector Menu Functions
		if (!InMainFreeplayState)
		{
			scoreBG = null;
			scoreText = null;
			diffText = null;
			characterSelectText = null;

			if (controls.LEFT_P && canInteract)
			{
				UpdatePackSelection(-1);
			}
			if (controls.RIGHT_P && canInteract)
			{
				UpdatePackSelection(1);
			}
			if (controls.ACCEPT && !loadingPack && canInteract)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				canInteract = false;

				new FlxTimer().start(0.2, function(Dumbshit:FlxTimer)
				{
					loadingPack = true;
					LoadProperPack();

					for (item in icons)
					{
						FlxTween.tween(item, {alpha: 0, y: item.y - 200}, 0.2, {ease: FlxEase.cubeInOut});
					}
					for (item in titles)
					{
						FlxTween.tween(item, {alpha: 0, y: item.y - 200}, 0.2, {ease: FlxEase.cubeInOut});
					}

					new FlxTimer().start(0.2, function(Dumbshit:FlxTimer)
					{
						for (item in icons)
						{
							item.visible = false;
						}
						for (item in titles)
						{
							item.visible = false;
						}

						GoToActualFreeplay();
						resetPresses();
						InMainFreeplayState = true;
						loadingPack = false;
					});
				});
			}
			if (controls.BACK && canInteract && !awaitingExploitation)
			{
				FlxG.switchState(new MainMenuState());
			}

			return;
		}

		// Freeplay Functions
		else
		{
			var upP = controls.UP_P;
			var downP = controls.DOWN_P;
			var accepted = controls.ACCEPT;

			if (upP && canInteract)
			{
				stringKey = 'up';
				changeSelection(-1);
			}
			if (downP && canInteract)
			{
				stringKey = 'down';
				changeSelection(1);
			}
			if (controls.BACK && canInteract)
			{
				loadingPack = true;
				canInteract = false;

				for (i in grpSongs)
				{
					i.unlockY = true;

					FlxTween.tween(i, {y: 5000, alpha: 0}, 0.3, {
						onComplete: function(twn:FlxTween)
						{
							i.unlockY = false;

							for (item in icons)
							{
								item.visible = true;
								FlxTween.tween(item, {alpha: 1, y: item.y + 200}, 0.2, {ease: FlxEase.cubeInOut});
							}
							for (item in titles)
							{
								item.visible = true;
								FlxTween.tween(item, {alpha: 1, y: item.y + 200}, 0.2, {ease: FlxEase.cubeInOut});
							}

							if (scoreBG != null)
							{
								FlxTween.tween(scoreBG, {y: scoreBG.y - 100}, 0.5, {
									ease: FlxEase.expoInOut,
									onComplete: function(spr:FlxTween)
									{
										scoreBG = null;
									}
								});
							}

							if (scoreText != null)
							{
								FlxTween.tween(scoreText, {y: scoreText.y - 100}, 0.5, {
									ease: FlxEase.expoInOut,
									onComplete: function(spr:FlxTween)
									{
										scoreText = null;
									}
								});
							}

							if (diffText != null)
							{
								FlxTween.tween(diffText, {y: diffText.y - 100}, 0.5, {
									ease: FlxEase.expoInOut,
									onComplete: function(spr:FlxTween)
									{
										diffText = null;
									}
								});
							}
							if (showCharText)
							{
								if (characterSelectText != null)
								{
									FlxTween.tween(characterSelectText, {alpha: 0}, 0.5, {
										ease: FlxEase.expoInOut,
										onComplete: function(spr:FlxTween)
										{
											characterSelectText = null;
										}
									});
								}
							}

							InMainFreeplayState = false;
							loadingPack = false;

							for (i in grpSongs)
							{
								remove(i);
							}
							for (i in iconArray)
							{
								remove(i);
							}

							FlxTween.color(bg, 0.25, bg.color, defColor);

							// MAKE SURE TO RESET EVERYTHIN!
							songs = [];
							grpSongs.members = [];
							iconArray = [];
							curSelected = 0;
							canInteract = true;
						}
					});
				}
			}
			if (accepted && canInteract)
			{
				switch (songs[curSelected].songName)
				{
					case 'Enter Terminal':
						FlxG.switchState(new TerminalState());
					default:
						FlxG.sound.music.fadeOut(1, 0);
						PlayState.SONG = Song.loadFromJson(songs[curSelected].songName.toLowerCase());
						PlayState.isStoryMode = false;

						PlayState.characteroverride = "none";
						PlayState.formoverride = "none";
						PlayState.curmult = [1, 1, 1, 1];

						PlayState.storyWeek = songs[curSelected].week;

						packTransitionDone = false;
						if ((FlxG.keys.pressed.CONTROL || skipSelect.contains(PlayState.SONG.song.toLowerCase()))
							&& PlayState.SONG.song.toLowerCase() != 'exploitation')
						{
							LoadingState.loadAndSwitchState(new PlayState());
						}
						else
						{
							if (!FlxG.save.data.wasInCharSelect)
							{
								FlxG.save.data.wasInCharSelect = true;
								FlxG.save.flush();
							}
							LoadingState.loadAndSwitchState(new CharacterSelectState());
						}
				}
			}
		}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		if (scoreText != null)
			scoreText.text = LanguageManager.getTextString('freeplay_personalBest') + lerpScore;
		positionHighscore();
	}

	function positionHighscore()
	{
		scoreText.x = FlxG.width - scoreText.width - 6;

		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}

	function updateDifficultyText()
	{
		switch (songs[curSelected].week)
		{
			case 3:
				diffText.text = LanguageManager.getTextString('freeplay_finale') + " - " + curChar.toUpperCase();
			case 10:
				diffText.text = "RECURSED" + " - " + curChar.toUpperCase();
			case 16:
				diffText.text = LanguageManager.getTextString('freeplay_fucked') + " - " + curChar.toUpperCase();
			default:
				diffText.text = curChar.toUpperCase();
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (change != 0)
		{
			pressSpeed = timeSincePress - lastTimeSincePress;

			lastTimeSincePress = timeSincePress;

			timeSincePress = 0;
			pressSpeeds.push(Math.abs(pressSpeed));

			var inputKeys = controls.getInputsFor(Controls.stringControlToControl(stringKey), Device.Keys);
			if (pressSpeeds.length == 1)
			{
				requiredKey = inputKeys;
			}
			if (!CoolUtil.isArrayEqualTo(requiredKey, inputKeys))
			{
				resetPresses();
			}
			var shakeCheck = pressSpeeds.length % 5;
			if (shakeCheck == 0 && pressSpeeds.length > 0 && !FlxG.save.data.recursedUnlocked)
			{
				FlxG.camera.shake(0.003 * (pressSpeeds.length / 5), 0.1);
				FlxG.sound.play(Paths.sound('recursed/thud', 'shared'), 1, false, null, true);
			}
		}

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;

		if (curSelected >= songs.length)
			curSelected = 0;

		if (songs[curSelected].songName != 'Enter Terminal')
		{
			#if !switch
			intendedScore = Highscore.getScore(songs[curSelected].songName);
			#end

			#if PRELOAD_ALL
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
			#end

			curChar = Highscore.getChar(songs[curSelected].songName);
		}

		if (diffText != null)
			updateDifficultyText();

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
		FlxTween.color(bg, 0.25, bg.color, songColors[songs[curSelected].week]);
	}

	function getTrueSongTextWidth(song:Alphabet)
	{
		var index = grpSongs.members.indexOf(song);
		var icon = iconArray[index];

		return song.width + icon.width + 10;
	}

	function resetPresses()
	{
		pressSpeeds = new Array<Float>();
		pressUnlockNumber = new FlxRandom().int(20, 40);
	}

	function recursedUnlock()
	{
		canInteract = false;

		FlxG.sound.music.stop();
		FlxG.sound.playMusic(Paths.sound('recursed/rumble', 'shared'), 0.8, false, null);
		var boom = new FlxSound().loadEmbedded(Paths.sound('recursed/boom', 'shared'), false, false);

		FlxG.camera.shake(0.015, 3, function()
		{
			FlxG.camera.flash();
			var objects:Array<FlxSprite> = new Array<FlxSprite>();
			for (icon in iconArray)
			{
				icon.screenCenter();
				icon.sprTracker = null;
				objects.push(icon);

				icon.velocity.set(new FlxRandom().float(-300, 400), new FlxRandom().float(-200, 400));
				icon.angularVelocity = 60;
			}
			for (song in grpSongs)
			{
				song.unlockY = true;
				song.screenCenter();
				for (character in song.characters)
				{
					character.velocity.set(new FlxRandom().float(-100, 250), new FlxRandom().float(-100, 250));
					character.angularVelocity = 80;
					objects.push(character);
				}
			}
			boom.play();
			FlxG.sound.music.stop();
			FlxG.sound.playMusic(Paths.sound('recursed/ambience', 'shared'), 1, false, null);

			bg.color = FlxColor.fromRGB(44, 44, 44);
			new FlxTimer().start(4, function(timer:FlxTimer)
			{
				for (object in objects)
				{
					object.angularVelocity = 0;
					object.velocity.set();
					FlxTween.tween(object, {x: (FlxG.width / 2) - (object.width), y: (FlxG.height / 2) - (object.height)}, 1, {ease: FlxEase.backOut});
				}
				FlxG.camera.shake(0.05, 3);

				FlxG.sound.music.stop();
				FlxG.sound.playMusic(Paths.sound('recursed/rumble', 'shared'), 0.8, false, null);
				FlxG.sound.play(Paths.sound('recursed/piecedTogether', 'shared'), 1, false, null, true);

				FlxG.camera.fade(FlxColor.WHITE, 3, false, function()
				{
					FlxG.camera.shake(0.1, 0.5);
					FlxG.camera.fade(FlxColor.BLACK, 0);

					FlxG.sound.play(Paths.sound('recursed/recurser_laugh', 'shared'), function()
					{
						new FlxTimer().start(1, function(timer:FlxTimer)
						{
							PlayState.SONG = Song.loadFromJson("Recursed");

							PlayState.storyWeek = 10;

							PlayState.formoverride = 'none';

							FlxG.save.data.recursedUnlocked = true;
							FlxG.save.flush();

							LoadingState.loadAndSwitchState(new PlayState());
						});
					});
				});
			});
		});
	}

	static function getSongWeek(song:String)
	{
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
