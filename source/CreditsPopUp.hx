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

    public function new(x:Float, y:Float)
    {
        super(x, y);
        bg = new FlxSprite().makeGraphic(400, 50, FlxColor.GREEN);
        bg.alpha = 0.7;
        add(bg);
        var songCreator:String = '';
        switch (PlayState.SONG.song.toLowerCase())
        {
           case 'house' | 'insanity' | 'polygonized' | 'bonus-song' | 'blocked' | 'corn-theft' | 'maze' | 'splitathon' | 'shredder' | 'greetings' 
           | 'interdimensional' |'cheating' | 'escape-from-california' | 'five-nights' | 'furiosity' | 'kabunga' | 'roots' | 'secret' | 'secret-mod-leak' | 'unfairness' | 'rano':
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
           case 'adventure':
              songCreator = 'Ruby';
           case 'bonkers':
              songCreator = 'Cynda';
        }
        var funnyText:FlxText = new FlxText(1, 0, 650, "Song by " + songCreator, 16);
        funnyText.setFormat('Comic Sans MS Bold', 35, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        funnyText.borderSize = 4;
        funnyText.updateHitbox();
        bg.setGraphicSize(Std.int(funnyText.width + 20), Std.int(funnyText.height + 20));
        bg.updateHitbox();
        add(funnyText);
    }
}