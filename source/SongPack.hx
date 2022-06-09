package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

#if windows
import lime.app.Application;
#end

using StringTools;


typedef SongPackData =
{
	var packName:String;
    var packSongs:Array<String>;
}

class SongPack
{
	public static function loadFromJson(?folder:String):SongPackData
	{
		var rawJson = Assets.getText(Paths.json("packs/" + folder + "/pack", "preload")).trim();		

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
		}

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):SongPackData
	{
		var swagShit:SongPackData = cast Json.parse(rawJson);
		return swagShit;
	}
}
