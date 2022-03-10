package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end

class BambiCornInstructionSubState extends MusicBeatSubstate
{
    var txt:FlxText;

    var curText:Int = 0;

    var texts:Array<String> =
    [
        "Welcome to Bambis' Corn Game!",
        "Your objective is to get all the corn before bambi catches you!",
        "If you get all the corn before he finds you, you win!",
        "Good luck!"
    ];

    override function create()
    {
		txt = new FlxText(0, 0, FlxG.width, texts[0] + "\n\n\n\n\nCONTINUE - ENTER",32);
		txt.setFormat(Paths.font("pixel.otf"), 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		txt.antialiasing = true;
		add(txt);

        super.create();

        FlxG.sound.playMusic(Paths.music('cornIntro', 'shared'));
    }


    override function update(elapsed:Float)
    {
        super.update(elapsed);
    
        if (FlxG.keys.justPressed.ENTER)
        {
            if (curText == texts.length)
            {
                FlxG.sound.music.stop();
                trace("Closing");
                BambisCornGame.bambi.lockMovement = false;
                BambisCornGame.player.lockMovement = false;
                BambisCornGame.bambi.chase(elapsed);
                FlxG.sound.playMusic(Paths.inst('roots'));
                close();            
            }
            else
            {
                curText++;
                txt.text = texts[curText] + "\n\n\n\n\nCONTINUE - ENTER";
            }
        }   
    }
}