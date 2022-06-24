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
}
class CreditsPopUp extends FlxSpriteGroup
{
	public var bg:FlxSprite;
	public var bgHeading:FlxSprite;

	public var funnyText:FlxText;
	public var funnyIcon:FlxSprite;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		bg = new FlxSprite().makeGraphic(400, 50, FlxColor.WHITE);
		add(bg);
		var songCreator:String = '';
		var headingPath:SongHeading = null;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'house' | 'insanity' | 'polygonized' | 'bonus-song' | 'blocked' | 'corn-theft' | 'maze' | 'splitathon' | 'shredder' | 'greetings' |
				'interdimensional' | 'cheating' | 'escape-from-california' | 'five-nights' | 'furiosity' | 'kabunga' | 'roots' | 'secret' |
				'secret-mod-leak' | 'unfairness' | 'rano':
				songCreator = 'MoldyGH';
			case 'exploitation':
				songCreator = 'Oxygen';
			case 'memory' | 'mealie':
				songCreator = 'Alexander Cooper 19';
			case 'confronting-yourself' | 'eletric-cockadoodledoo':
				songCreator = 'Cuzsie';
			case 'glitch':
				songCreator = 'DeadShadow & PixelGH';
			case 'overdrive':
				songCreator = 'Top 10 Awesome';
			case 'supernovae':
				songCreator = 'ArchWk';
			case 'vs-dave-rap':
				songCreator = 'Your mom';
			case 'recursed':
				bg.color = FlxColor.fromRGB(44, 44, 44);
				songCreator = 'Aadsta';
			case 'adventure':
				songCreator = 'Ruby';
		}
		switch (PlayState.storyWeek)
		{
			case 1:
				headingPath = {path: 'songHeadings/daveHeading', antiAliasing: false};
			case 2:
				headingPath = {path: 'songHeadings/bambiHeading', antiAliasing: true};
			case 8:
				headingPath = {path: 'songHeadings/expungedHeading', antiAliasing: true,
				animation: new Animation('expunged', 'Expunged', 24, true, [false, false])};
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
		}
		funnyText = new FlxText(1, 0, 650, "Song by " + songCreator, 16);
		funnyText.setFormat('Comic Sans MS Bold', 35, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		funnyText.borderSize = 1.5;
		funnyText.antialiasing = true;
		funnyText.updateHitbox();

		funnyIcon = new FlxSprite(0, 0, Paths.image('songCreators/' + songCreator));

		var values = CoolUtil.getMinAndMax(funnyIcon.height, funnyText.height);
		funnyIcon.setGraphicSize(Std.int(funnyIcon.height / (values[1] / values[0])));
		funnyIcon.updateHitbox();
      
		var yValues = CoolUtil.getMinAndMax(funnyIcon.height, funnyText.height);

		funnyIcon.x = funnyText.x + funnyText.frameWidth + 20;
		funnyIcon.y = funnyIcon.y + ((yValues[0] - yValues[1]) / 2);

		add(funnyIcon);

		bg.setGraphicSize(Std.int((funnyText.frameWidth + funnyIcon.width) + 20), Std.int(funnyText.height) + 40);
		bg.updateHitbox();
		add(funnyText);
	}
	public function updateHitboxes()
	{
		var values = CoolUtil.getMinAndMax(funnyIcon.height, funnyText.height);
		
		funnyIcon.setGraphicSize(Std.int(funnyIcon.height / (values[1] / values[0])));
		funnyIcon.updateHitbox();

		var yValues = CoolUtil.getMinAndMax(funnyIcon.height, funnyText.height);

		funnyIcon.x = funnyText.x + funnyText.frameWidth + 20;
		funnyIcon.y = funnyIcon.y + ((yValues[0] - yValues[1]) / 2);


		bg.setGraphicSize(Std.int((funnyText.frameWidth + funnyIcon.width) + 20), Std.int(funnyText.height) + 40);
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
		updateHitboxes();
	}
	public function changeText(newText:String, newIcon:String)
	{
		funnyText.text = newText;
		if (!FileSystem.exists(Paths.image('songCreators/$newIcon', 'shared')))
		{
			funnyIcon.loadGraphic(Paths.image('songCreators/none', 'shared'));
		}
		else
		{
			funnyIcon.loadGraphic(Paths.image('songCreators/$newIcon', 'shared'));
		}
		updateHitboxes();
	}
}