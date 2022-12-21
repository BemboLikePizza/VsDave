package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxSoundGroup;
import flixel.ui.FlxBar;
import flixel.system.FlxSound;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import lime.utils.Assets;
#if desktop
import Discord.DiscordClient;
#end

using StringTools;

// a lot of this code is copied from freeplay lol
// unlike the character select code, you guys are free to use this without asking me(but you gotta give me credit), although you might have to ask moldy. -ben

class MusicPlayerState extends MusicBeatState
{
	var songs:Array<PlaySongMetadata> = [];
	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<HealthIcon> = [];
	var curSelected:Int = 0;
	var CurVocals:FlxSound;
	var currentlyplaying:Bool = false;

	public var playdist:Float = 0;

	var bg:FlxSprite;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;

	private var barText:FlxText;

	override function create()
	{
		FlxG.autoPause = false;
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('djSonglist')); // ah yeah dj song list
		for (i in 0...initSonglist.length)
		{
			var splitstring:Array<String> = initSonglist[i].split(",");

			songs.push(new PlaySongMetadata(splitstring[1], splitstring[0] == "external", splitstring[2], splitstring[3] == "bad",
				splitstring[1] != 'vs-dave-rap'));

			if (splitstring[0] != "external" && splitstring[1] != 'vs-dave-rap') // remove this later
			{
				songs.push(new PlaySongMetadata(splitstring[1], splitstring[0] == "external", splitstring[2], splitstring[3] == "bad", false));
			}
		}
		var secretSongs:Array<Dynamic> = [
			['supernovae', 'bambi-joke'],
			['glitch', 'bambi-joke'],
			['master', 'bambi-joke', true],
			['cheating', 'bambi-3d'],
			['unfairness', 'bambi-unfair'],
			['exploitation', 'expunged'],
			['kabunga', 'exbungo'],
			['roofs', 'baldi'],
			['recursed', 'recurser'],
			['vs-dave-rap-two', 'dave-cool'],
		];
		for (i in 0...secretSongs.length)
		{
			var unlockSong = false;
			unlockSong = switch (secretSongs[i][0].toLowerCase())
			{
				case 'supernovae', 'glitch', 'master': FlxG.save.data.hasPlayedMasterWeek;
				case 'cheating': FlxG.save.data.cheatingFound;
				case 'unfairness': FlxG.save.data.unfairnessFound;
				case 'exploitation': FlxG.save.data.exploitationFound;
				case 'kabunga': FlxG.save.data.exbungoFound;
				case 'roofs': FlxG.save.data.roofsUnlocked;
				case 'recursed': FlxG.save.data.recursedUnlocked;
				case 'vs-dave-rap-two': FlxG.save.data.vsDaveRapTwoFound;
				default: false;
			}
			if (unlockSong)
			{
				var bad = secretSongs[i][2] != null ? secretSongs[i][2] : false;
				songs.push(new PlaySongMetadata(secretSongs[i][0], false, secretSongs[i][1], bad, secretSongs[i][0] != 'vs-dave-rap-two'));
				if (secretSongs[i][0] != 'vs-dave-rap-two')
				{
					songs.push(new PlaySongMetadata(secretSongs[i][0], false, secretSongs[i][1], bad, false));
				}
			}
		}

		bg = new FlxSprite().loadGraphic(Paths.image('backgrounds/Aadsta'));
		bg.loadGraphic(MainMenuState.randomizeBG());
		bg.color = 0xFFFD719B;
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		#if desktop
		DiscordClient.changePresence("In the OST Menu", null);
		#end

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, 0,
				songs[i].songName + (songs[i].hasVocals ? "" : ((songs[i].songName != 'vs-dave-rap-two'
					&& songs[i].songName != 'vs-dave-rap') ? "-Inst" : "")),
				true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;
			icon.changeState(songs[i].ShowBadIcon ? 'losing' : 'normal');

			iconArray.push(icon);
			add(icon);
		}

		// create hp bar for pico funny
		healthBarBG = new FlxSprite(0, 50).loadGraphic(Paths.image('ui/healthBar'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'playdist', 0, 1);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(FlxColor.WHITE, FlxColor.BLACK);
		insert(members.indexOf(healthBarBG), healthBar);

		iconP1 = new HealthIcon("bf", true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon("bf-old", false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		barText = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + healthBarBG.height + 5, 0, "", 20);
		barText.setFormat(Paths.font("comic.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		barText.scrollFactor.set();
		barText.borderSize = 1.5;
		barText.antialiasing = true;
		barText.screenCenter(X);
		add(barText);

		HideBar();

		super.create();
	}

	var lastText:String = "";

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (barText != null && barText.text != lastText)
		{
			barText.screenCenter(X);
			lastText = barText.text;
		}

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;

		var leftP = controls.LEFT_P;
		var rightP = controls.RIGHT_P;
		var accepted = controls.ACCEPT;

		playdist = 1 - (FlxG.sound.music.time / FlxG.sound.music.length);

		// copied from playstate
		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - 26);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - 26);

		var currentTimeFormatted = FlxStringUtil.formatTime(FlxG.sound.music.time / 1000);
		var lengthFormatted = FlxStringUtil.formatTime(FlxG.sound.music.length / 1000);
		if (currentlyplaying)
		{
			if (songs[curSelected].hasVocals || songs[curSelected].ExternalSong)
			{
				#if desktop
				DiscordClient.changePresence('In The OST Menu',
					'\nListening To: '
					+ CoolUtil.formatString(songs[curSelected].songName, '-')
					+ ' | '
					+ currentTimeFormatted
					+ ' / '
					+ lengthFormatted,
					null);
				#end
			}
			else
			{
				#if desktop
				DiscordClient.changePresence('In The OST Menu',
					'\nListening To: '
					+ CoolUtil.formatString(songs[curSelected].songName, '-')
					+ ' Instrumental | '
					+ currentTimeFormatted
					+ ' / '
					+ lengthFormatted,
					null);
				#end
			}
		}

		if (healthBar.percent < 20)
			iconP1.changeState('losing');
		else
			iconP1.changeState('normal');

		if (healthBar.percent > 80)
			iconP2.changeState('losing');
		else
			iconP2.changeState('normal');

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		if (currentlyplaying)
		{
			if (leftP)
			{
				if (CurVocals != null)
				{
					CurVocals.time -= 5000;
				}
				FlxG.sound.music.time -= 5000;
			}
			if (rightP)
			{
				if (CurVocals != null)
				{
					CurVocals.time += 5000;
				}
				FlxG.sound.music.time += 5000;
			}
		}

		barText.text = FlxStringUtil.formatTime(FlxG.sound.music.time / 1000) + " / " + FlxStringUtil.formatTime(FlxG.sound.music.length / 1000);

		if (controls.BACK)
		{
			if (currentlyplaying)
			{
				#if desktop
				DiscordClient.changePresence('In The OST Menu', null);
				#end

				if (CurVocals != null)
				{
					CurVocals.stop();
					FlxG.sound.list.remove(CurVocals);
				}
				HideBar();
				FlxG.sound.music.stop();
				currentlyplaying = false;
				FlxG.sound.playMusic(Paths.music('freakyMenu'));

				var bullShit:Int = 0; // the fact that i have to copy this code is bullshit

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
					// item.setGraphicSize(Std.int(item.width * 0.8));
					if (item.targetY == 0)
					{
						item.alpha = 1;
						// item.setGraphicSize(Std.int(item.width));
					}
				}
			}
			else
			{
				FlxG.autoPause = true;
				FlxG.switchState(new MainMenuState());
			}
		}
		if (accepted)
		{
			if (currentlyplaying == false)
			{
				ShowBar(songs[curSelected].songCharacter);
				if (!songs[curSelected].ExternalSong)
				{
					currentlyplaying = true;
					if (songs[curSelected].hasVocals)
					{
						CurVocals = new FlxSound().loadEmbedded(Paths.voices(songs[curSelected].songName));
					}
					else
					{
						CurVocals = new FlxSound();
					}
					// let both the vocals and the instrumental load before playing
					FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 1, true);
					CurVocals.looped = true; // this assumes the vocal length is the same as the instrumental, which is also bad
					CurVocals.play();
					FlxG.sound.list.add(CurVocals);
				}
				else
				{
					currentlyplaying = true;
					FlxG.sound.playMusic(Paths.externmusic(songs[curSelected].songName), 1, true);
				}

				var bullShit:Int = 0;

				for (i in 0...iconArray.length)
				{
					if (i != curSelected)
					{
						FlxTween.tween(iconArray[i], {alpha: 0}, 0.15);
						// iconArray[i].alpha = 0;
					}
					else
					{
						iconArray[curSelected].alpha = 1;
					}
				}

				for (item in grpSongs.members)
				{
					item.targetY = bullShit - curSelected;
					bullShit++;

					if (item.targetY != 0)
					{
						FlxTween.tween(item, {alpha: 0}, 0.15);
						// item.alpha = 0;
					}
					// item.setGraphicSize(Std.int(item.width * 0.8));

					if (item.targetY == 0)
					{
						item.alpha = 1;
						// item.setGraphicSize(Std.int(item.width));
					}
				}
			}
		}
	}

	function HideBar()
	{
		FlxTween.tween(iconP1, {alpha: 0}, 0.15);
		FlxTween.tween(iconP2, {alpha: 0}, 0.15);
		FlxTween.tween(barText, {alpha: 0}, 0.15);
		FlxTween.tween(healthBar, {alpha: 0}, 0.15);
		FlxTween.tween(healthBarBG, {alpha: 0}, 0.15);
		new FlxTimer().start(0.15, function(bitchFuckAssDickCockBalls:FlxTimer)
		{
			iconP1.visible = false;
			iconP2.visible = false;
			barText.visible = false;
			healthBar.visible = false;
			healthBarBG.visible = false;
		});
	}

	function ShowBar(char:String)
	{
		iconP1.alpha = 0;
		iconP2.alpha = 0;
		barText.alpha = 0;
		healthBar.alpha = 0;
		healthBarBG.alpha = 0;
		iconP1.visible = true;
		iconP2.changeIcon(char);
		iconP2.visible = true;
		barText.visible = true;
		healthBar.visible = true;
		healthBarBG.visible = true;
		FlxTween.tween(iconP1, {alpha: 1}, 0.15);
		FlxTween.tween(iconP2, {alpha: 1}, 0.15);
		FlxTween.tween(barText, {alpha: 1}, 0.15);
		FlxTween.tween(healthBar, {alpha: 1}, 0.15);
		FlxTween.tween(healthBarBG, {alpha: 1}, 0.15);
	}

	function changeSelection(change:Int = 0)
	{
		if (currentlyplaying)
		{
			return;
		}
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			if (i != curSelected)
			{
				FlxTween.tween(iconArray[i], {alpha: 0.6}, 0.15);
				// iconArray[i].alpha = 0.6;
			}
			else
			{
				iconArray[curSelected].alpha = 1;
			}
		}

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if (item.targetY != 0)
			{
				FlxTween.tween(item, {alpha: 0.6}, 0.15);
				// item.alpha = 0.6;
			}
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

class PlaySongMetadata
{
	public var songName:String = "";
	public var ExternalSong:Bool = false;
	public var ShowBadIcon:Bool = false;
	public var songCharacter:String = "";
	public var hasVocals:Bool = true;

	public function new(song:String, external:Bool, songCharacter:String, bad:Bool, vocal:Bool)
	{
		this.songName = song;
		this.ExternalSong = external;
		this.songCharacter = songCharacter;
		this.ShowBadIcon = bad;
		this.hasVocals = vocal;
	}
}
