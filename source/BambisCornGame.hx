package;

import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.util.FlxColor;
#if desktop
import Discord.DiscordClient;
#end

// i was bored ok?
class BambisCornGame extends MusicBeatState
{
    public static var player:MinigamePlayer;
    public static var bambi:BambiEnemy;

    var showHitboxes:Bool = false;
    var dead:Bool = false;

    private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

    // iNTROOO
    var introText:FlxText;
    var curText:Int = 0;
    var inIntro:Bool = false;
    var texts:Array<String> =
    [
        "Welcome to Bambis' Corn Game!",
        "Your objective is to get all the corn before bambi catches you!",
        "If you get all the corn before he finds you, you win!",
        "Good luck!"
    ];

    override function create()
    {
        #if desktop
		DiscordClient.changePresence("Playing Bambi's Corn Game", "");
		#end

        camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

        var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image("bambiCornGame/grass", 'shared'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

        super.create();
        
        intro();
    }

    function intro()
    {
        inIntro = true;
        FlxG.sound.playMusic(Paths.music('cornIntro', 'shared'));

        introText = new FlxText(0, 0, FlxG.width, texts[0] + "\n\n\n\n\nCONTINUE - ENTER",32);
		introText.setFormat(Paths.font("pixel.otf"), 32, FlxColor.WHITE, CENTER);
		introText.screenCenter();
		introText.antialiasing = true;
		add(introText);
    }

    override function update(elapsed:Float)
    {
        if (bambi != null)
            bambi.playerPosition = player.getGraphicMidpoint();

        FlxG.overlap(player, bambi, function(player, bambi) 
        {
            trace("dead as hell");
        });

        if (FlxG.keys.justPressed.H)
            showHitboxes = !showHitboxes;
        
        FlxG.debugger.drawDebug = showHitboxes;

        // just keeping this for testing!
        if (FlxG.keys.justPressed.ESCAPE) FlxG.switchState(new ExtrasMenuState());


        if (dead)
        {
            if (FlxG.keys.justPressed.ENTER) FlxG.switchState(new BambisCornGame()); // PLEASE SHUT UP IM TIRED AND LAZY
            else if (FlxG.keys.justPressed.ESCAPE) FlxG.switchState(new ExtrasMenuState());
        }

        if (FlxG.keys.justPressed.ENTER && inIntro)
        {
            if (curText == texts.length)
            {
                FlxG.sound.music.stop();
                trace("Closing");
                FlxG.sound.playMusic(Paths.inst('roots'));
                    
                player = new MinigamePlayer(20, 20);
                player.screenCenter();
                add(player);

                bambi = new BambiEnemy(500, 500);
                bambi.chase(elapsed);
                add(bambi);    

                remove(introText);
                    
                inIntro = false;
            }
            else
            {
                curText++;
                introText.text = texts[curText] + "\n\n\n\n\nCONTINUE - ENTER";
            }
        }   

        super.update(elapsed);
    }


    function lose()
    {
        bambi.lockMovement = false;
        player.lockMovement = false;
        bambi.idle(0);
        
        FlxG.sound.music.stop();

        var txt:FlxText = new FlxText(0, 0, FlxG.width, "You Lose!\nYou kinda suck ngl bro...\n\n\nENTER - Try Again\nESCAPE - Back to Menu",32);
		txt.setFormat(Paths.font("pixel.otf"), 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		txt.antialiasing = true;
        txt.cameras = [camHUD];
		add(txt);

        FlxG.sound.play(Paths.sound('cornLose', 'shared'));

        dead = true;
    }
}