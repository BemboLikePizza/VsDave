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
		var headingPath:SongHeading = null;

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'warmup' | 'house' | 'insanity' | 'polygonized' | 'bonus-song' | 'blocked' | 'corn-theft' | 'maze' | 'splitathon' | 'shredder' | 'greetings' |
				'interdimensional' | 'cheating' | 'escape-from-california' | 'five-nights' | 'kabunga' | 'roots' | 'secret' |
				'secret-mod-leak' | 'unfairness' | 'rano' | 'master':
				songCreator = 'MoldyGH';
			case 'exploitation':
				songCreator = 'Oxygen';
			case 'memory' | 'mealie':
				songCreator = 'Alexander Cooper 19';
			case 'glitch':
				songCreator = 'DeadShadow & PixelGH\nRemix by MoldyGH';
			case 'overdrive':
				songCreator = 'Top 10 Awesome';
			case 'supernovae':
				songCreator = 'ArchWk\nRemix by MoldyGH';
			case 'vs-dave-rap':
				songCreator = 'Your mom';
			case 'recursed':
				songCreator = 'Aadsta';
			case 'adventure':
				songCreator = 'Ruby';
			case 'bot-trot':
				songCreator = 'TH3R34LD34L';
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
			case 7:
				headingPath = {path: 'songHeadings/kabungaHeading', antiAliasing: true, iconOffset: 0};
			case 8 | 6:
				headingPath = {path: 'songHeadings/expungedHeading', antiAliasing: true,
				animation: new Animation('expunged', 'Expunged', 24, true, [false, false]), iconOffset: 0};
			case 10:
				headingPath = {path: 'songHeadings/recursedHeading', antiAliasing: true, iconOffset: 5};
		}
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'polygonized':
				headingPath = {path: 'songHeadings/3D-daveHeading', antiAliasing: false, iconOffset: 0};
			case 'supernovae' | 'glitch' | 'master':
				headingPath = {path: 'songHeadings/bevelHeading', antiAliasing: false, iconOffset: 0};
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
		var offset = (curHeading == null ? 0 : curHeading.iconOffset);
		
		funnyText = new FlxText(1, 0, 650, "Song by " + songCreator, 16);
		funnyText.setFormat('Comic Sans MS Bold', 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		funnyText.borderSize = 2;
		funnyText.antialiasing = true;
		add(funnyText);
		
		funnyIcon = new FlxSprite(0, 0, Paths.image('songCreators/' + songCreator));

		var scaleValues = CoolUtil.getMinAndMax(funnyIcon.height, funnyText.height);
		funnyIcon.setGraphicSize(Std.int(funnyIcon.height / (scaleValues[1] / scaleValues[0])));
		funnyIcon.updateHitbox();
      
		var heightValues = CoolUtil.getMinAndMax(funnyIcon.height, funnyText.height);
		funnyIcon.setPosition(funnyText.textField.textWidth + offset, (heightValues[0] - heightValues[1]) / 2);
		add(funnyIcon);

		bg.setGraphicSize(Std.int((funnyText.textField.textWidth + funnyIcon.width)), Std.int(funnyText.height));
		bg.updateHitbox();

		var yValues = CoolUtil.getMinAndMax(bg.height, funnyText.height);
		funnyText.y = funnyText.y + ((yValues[0] - yValues[1]) / 2);
	}
	public function updateHitboxes()
	{
		var offset = (curHeading == null ? 0 : curHeading.iconOffset);
		
		var scaleValues = CoolUtil.getMinAndMax(funnyIcon.height, funnyText.height);
		funnyIcon.setGraphicSize(Std.int(funnyIcon.height / (scaleValues[1] / scaleValues[0])));
		funnyIcon.updateHitbox();

		var heightValues = CoolUtil.getMinAndMax(funnyIcon.height, funnyText.height);
		funnyIcon.setPosition(funnyText.textField.textWidth + offset, (heightValues[0] - heightValues[1]) / 2);
		
		bg.setGraphicSize(Std.int((funnyText.textField.textWidth + funnyIcon.width)), Std.int(funnyText.height));
		bg.updateHitbox();
	}
	public function switchHeading(newHeading:SongHeading)
	{
		remove(bg);
		bg = new FlxSprite().makeGraphic(400, 50, FlxColor.WHITE);
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
		add(bg);
		bg.antialiasing = newHeading.antiAliasing;
		curHeading = newHeading;
		updateHitboxes();
	}
	public function changeText(newText:String, newIcon:String)
	{
		funnyText.text = newText;
		if (!FileSystem.exists(Paths.image('songCreators/' + newIcon, 'shared')))
		{
			funnyIcon.loadGraphic(Paths.image('songCreators/none', 'shared'));
		}
		else
		{
			funnyIcon.loadGraphic(Paths.image('songCreators/' + newIcon, 'shared'));
		}
		updateHitboxes();
	}
}