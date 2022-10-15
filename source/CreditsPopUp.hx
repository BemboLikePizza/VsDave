package;

import sys.FileSystem;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.math.FlxMath;

typedef SongHeading = {
	var path:String;
	var antiAliasing:Bool;
	var ?animation:Animation;
	var iconOffset:Float;
}
class CreditsPopUp extends FlxSpriteGroup
{
	public var bg:FlxSprite;
	public var bgHeading:FlxSprite;

	public var funnyText:FlxText;
	public var funnyIcon:FlxSprite;
	var iconOffset:Float;
	var curHeading:SongHeading;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		bg = new FlxSprite().makeGraphic(400, 50, FlxColor.WHITE);
		add(bg);
		var songCreator:String = '';
		var songCreatorIcon:String = '';
		var headingPath:SongHeading = null;

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'warmup' | 'house' | 'insanity' | 'polygonized' | 'bonus-song' | 'blocked' | 'corn-theft' | 'maze' | 'indignancy' |  'splitathon' | 'shredder' | 'greetings' |
				'interdimensional' | 'cheating' | 'escape-from-california' | 'five-nights' | 'kabunga' | 'secret' | 'unfairness' | 'rano' | 'master':
				songCreator = 'MoldyGH';
			case 'exploitation':
				songCreator = 'Oxygen';
			case 'memory' | 'mealie':
				songCreator = 'Alexander Cooper 19';
			case 'glitch':
				songCreator = 'DeadShadow & PixelGH\nRemix by MoldyGH';
				songCreatorIcon = 'DeadShadow & PixelGH';
			case 'overdrive':
				songCreator = 'Top 10 Awesome';
			case 'supernovae':
				songCreator = 'ArchWk\nRemix by MoldyGH';
				songCreatorIcon = 'ArchWk';
			case 'vs-dave-rap' | 'vs-dave-rap-two':
				songCreator = 'Your mom';
			case 'recursed':
				songCreator = 'Aadsta';
			case 'adventure':
				songCreator = 'Ruby';
			case 'bot-trot':
				songCreator = 'TH3R34LD34L';
			case 'roofs':
				songCreator = 'sibottle';
		}
		switch (PlayState.storyWeek)
		{
			case 0 | 1:
				headingPath = {path: 'songHeadings/daveHeading', antiAliasing: false, iconOffset: 0};
			case 2:
				headingPath = {path: 'songHeadings/bambiHeading', antiAliasing: true, iconOffset: 0};
			case 3:
				headingPath = {path: 'songHeadings/splitathonHeading', antiAliasing: false, iconOffset: 0};
			case 4:
				headingPath = {path: 'songHeadings/festivalHeading', antiAliasing: true, iconOffset: 0};
			case 5:
				headingPath = {path: 'songHeadings/bevelHeading', antiAliasing: false, iconOffset: 0};
			case 6:
				headingPath = {path: 'songHeadings/kabungaHeading', antiAliasing: true, iconOffset: 0};
			case 7:
				headingPath = {path: 'songHeadings/secretLeakHeading', antiAliasing: true, iconOffset: 3};
			case 8:
				headingPath = {path: 'songHeadings/tristanHeading', antiAliasing: true, iconOffset: 0};
			case 9:
				headingPath = {path: 'songHeadings/botHeading', antiAliasing: true,
				animation: new Animation('botTrot', 'Bot trot', 24, true, [false, false]), iconOffset: 0};
			case 10:
				headingPath = {path: 'songHeadings/recursedHeading', antiAliasing: true, iconOffset: 5};
			case 11:
				headingPath = {path: 'songHeadings/californiaHeading', antiAliasing: true,
				animation: new Animation('california', 'California', 24, true, [false, false]), iconOffset: 0};
			case 12:
				headingPath = {path: 'songHeadings/fnafHeading', antiAliasing: true, iconOffset: 0};
			case 13:
				headingPath = {path: 'songHeadings/fnfengeading', antiAliasing: false, iconOffset: 0};
			case 14:
				headingPath = {path: 'songHeadings/cheatingHeading', antiAliasing: true,
				animation: new Animation('cheating', 'Cheating', 24, true, [false, false]), iconOffset: 0};
			case 15:
				headingPath = {path: 'songHeadings/unfairHeading', antiAliasing: true,
				animation: new Animation('unfair', 'Unfairness', 24, true, [false, false]), iconOffset: 0};
			case 16:
				headingPath = {path: 'songHeadings/expungedHeading', antiAliasing: true,
				animation: new Animation('expunged', 'Expunged', 24, true, [false, false]), iconOffset: 0};
		}
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'polygonized':
				headingPath = {path: 'songHeadings/3D-daveHeading', antiAliasing: false, iconOffset: 0};
			case 'interdimensional':
				headingPath = {path: 'songHeadings/interdimensionalHeading', antiAliasing: false, iconOffset: 0};
		}
		if (PlayState.recursedStaticWeek)
		{
			headingPath = {path: 'songHeadings/somethingHeading', antiAliasing: false,
				animation: new Animation('scramble', 'Scramble', 24, true, [false, false]), iconOffset: 0};
		}

		if (headingPath != null)
		{
			if (headingPath.animation == null)
			{
				bg.loadGraphic(Paths.image(headingPath.path));
			}
			else
			{
				var info = headingPath.animation;
				bg.frames = Paths.getSparrowAtlas(headingPath.path);
				bg.animation.addByPrefix(info.name, info.prefixName, info.frames, info.looped, info.flip[0], info.flip[1]);
				bg.animation.play(info.name);
			}
			bg.antialiasing = headingPath.antiAliasing;
			curHeading = headingPath;
		}
		createHeadingText(LanguageManager.getTextString("credits_songby") + ' ' + songCreator);
		funnyIcon = new FlxSprite(0, 0, Paths.image('songCreators/${songCreatorIcon != '' ? songCreatorIcon : songCreator}'));
		rescaleIcon();
		add(funnyIcon);

		rescaleBG();

		var yValues = CoolUtil.getMinAndMax(bg.height, funnyText.height);
		funnyText.y = funnyText.y + ((yValues[0] - yValues[1]) / 2);
	}
	public function switchHeading(newHeading:SongHeading)
	{
		if (bg != null)
		{
			remove(bg);
		}
		bg = new FlxSprite().makeGraphic(400, 50, FlxColor.WHITE);
		if (newHeading != null)
		{
			if (newHeading.animation == null)
			{
				bg.loadGraphic(Paths.image(newHeading.path));
			}
			else
			{
				var info = newHeading.animation;
				bg.frames = Paths.getSparrowAtlas(newHeading.path);
				bg.animation.addByPrefix(info.name, info.prefixName, info.frames, info.looped, info.flip[0], info.flip[1]);
				bg.animation.play(info.name);
			}
		}
		bg.antialiasing = newHeading.antiAliasing;
		curHeading = newHeading;
		add(bg);
		
		rescaleBG();
	}
	public function changeText(newText:String, newIcon:String, rescaleHeading:Bool = true)
	{
		createHeadingText(newText);
		
		if (funnyIcon != null)
		{
			remove(funnyIcon);
		}
		funnyIcon = new FlxSprite(0, 0, Paths.image('songCreators/' + newIcon, 'shared'));
		rescaleIcon();
		add(funnyIcon);

		if (rescaleHeading)
		{
			rescaleBG();
		}
	}
	function createHeadingText(text:String)
	{
		if (funnyText != null)
		{
			remove(funnyText);
		}
		funnyText = new FlxText(1, 0, 650, text, 16);
		funnyText.setFormat('Comic Sans MS Bold', 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		funnyText.borderSize = 2;
		funnyText.antialiasing = true;
		add(funnyText);
	}
	public function rescaleIcon()
	{
		var offset = (curHeading == null ? 0 : curHeading.iconOffset);

		var scaleValues = CoolUtil.getMinAndMax(funnyIcon.height, funnyText.height);
		funnyIcon.setGraphicSize(Std.int(funnyIcon.height / (scaleValues[1] / scaleValues[0])));
		funnyIcon.updateHitbox();

		var heightValues = CoolUtil.getMinAndMax(funnyIcon.height, funnyText.height);
		funnyIcon.setPosition(funnyText.textField.textWidth + offset, (heightValues[0] - heightValues[1]) / 2);
	}
	function rescaleBG()
	{
		bg.setGraphicSize(Std.int((funnyText.textField.textWidth + funnyIcon.width + 0.5)), Std.int(funnyText.height + 0.5));
		bg.updateHitbox();
	}
}