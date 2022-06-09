package;

import flixel.group.FlxSpriteGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.math.FlxMath;

class CreditsPopUp extends FlxSpriteGroup
{
	public var bg:FlxSprite;
	public var bgHeading:FlxSprite;

	public var funnyText:FlxText;
	public var funnyIcon:FlxSprite;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		bg = new FlxSprite().makeGraphic(400, 50);
		add(bg);
		var songCreator:String = '';
		var headingPath:String = '';
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
				headingPath = Paths.image('songHeadings/daveHeading');
				bg.antialiasing = false;
			case 2:
				headingPath = Paths.image('songHeadings/bambiHeading');
		}
		if (headingPath != '')
		{
			bg.loadGraphic(headingPath);
		}
		funnyText = new FlxText(1, 0, 650, "Song by " + songCreator, 16);
		funnyText.setFormat('Comic Sans MS Bold', 45, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		funnyText.borderSize = 2.5;
		funnyText.borderQuality = 1;
		funnyText.antialiasing = true;
		funnyText.updateHitbox();

		funnyIcon = new FlxSprite(0, 0, Paths.image('songCreators/' + songCreator));

		var values = CoolUtil.getMinAndMax(funnyIcon.height, funnyText.height);
		funnyIcon.setGraphicSize(Std.int(funnyIcon.height / (values[1] / values[0])));
		funnyIcon.updateHitbox();
      
		var yValues = CoolUtil.getMinAndMax(funnyIcon.height, funnyText.height);

		funnyIcon.x = funnyText.x + funnyText.width + 20;
		funnyIcon.y = funnyIcon.y + ((yValues[0] - yValues[1]) / 2);

		add(funnyIcon);

		bg.setGraphicSize(Std.int((funnyText.width + funnyIcon.width) + 20), Std.int(funnyText.height) + 40);
		bg.updateHitbox();
		add(funnyText);
	}
	public function updateHitboxes()
	{
		var values = CoolUtil.getMinAndMax(funnyIcon.height, funnyText.height);
		
		funnyIcon.setGraphicSize(Std.int(funnyIcon.height / (values[1] / values[0])));
		funnyIcon.updateHitbox();

		var yValues = CoolUtil.getMinAndMax(funnyIcon.height, funnyText.height);

		funnyIcon.x = funnyText.x + funnyText.width + 20;
		funnyIcon.y = funnyIcon.y + ((yValues[0] - yValues[1]) / 2);


		bg.setGraphicSize(Std.int((funnyText.width + funnyIcon.width) + 20), Std.int(funnyText.height) + 40);
		bg.updateHitbox();
	}
}