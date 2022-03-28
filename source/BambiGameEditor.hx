package;

import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.IOErrorEvent;
import openfl.events.IOErrorEvent;
import haxe.Json;
#if desktop
import Discord.DiscordClient;
#end

class BambiGameEditor extends MusicBeatState
{
    public static var map:BambiMap;
    var _file:FileReference;

    private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

    override function create()
    {
        #if desktop
		DiscordClient.changePresence("Making a Bambi Map", "");
		#end

        // Create a blank map
        map = 
        {
            objects: []
        }

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
    }

    override function update(elapsed:Float)
    {
        if (FlxG.mouse.justPressed)
        {
            var obj:Block = new Block(FlxG.mouse.x, FlxG.mouse.y, 1);
            add(obj);

            map.objects.push(obj);
        }

        super.update(elapsed);
    }



    /*
        saving system based off of chartingstate.hx
    */
    private function saveLevel()
    {
        var json = 
        {
            "map": map
        };
    
        var data:String = Json.stringify(json);
    
        if ((data != null) && (data.length > 0))
        {
            _file = new FileReference();
            _file.addEventListener(Event.COMPLETE, onSaveComplete);
            _file.addEventListener(Event.CANCEL, onSaveCancel);
            _file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
            _file.save(data, "map.json");
        }
    }
    
    function onSaveComplete(_):Void
    {
        _file.removeEventListener(Event.COMPLETE, onSaveComplete);
        _file.removeEventListener(Event.CANCEL, onSaveCancel);
        _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
        _file = null;
         FlxG.log.notice("Successfully saved LEVEL DATA.");
    }
    
    function onSaveCancel(_):Void
    {
        _file.removeEventListener(Event.COMPLETE, onSaveComplete);
         _file.removeEventListener(Event.CANCEL, onSaveCancel);
         _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
        _file = null;
    }
    
    function onSaveError(_):Void
    {
        _file.removeEventListener(Event.COMPLETE, onSaveComplete);
        _file.removeEventListener(Event.CANCEL, onSaveCancel);
        _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
        _file = null;
        FlxG.log.error("Problem saving Level data");
    }
}