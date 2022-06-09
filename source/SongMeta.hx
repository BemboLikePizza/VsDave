package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

#if windows
import lime.app.Application;
#end

using StringTools;

typedef SongMeta =
{
	var showInFreeplay:Bool;
    var requireUnlock:Bool;
    var songPack:String;
}

class SongMetadata
{
	public static function loadFromJson(jsonInput:String, ?folder:String):SongMeta
	{
		var rawJson = "";
		rawJson = Assets.getText(Paths.chart(folder.toLowerCase() + '/' + jsonInput.toLowerCase())).trim();

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
		}

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):SongMeta
	{
		var swagShit:SongMeta = cast Json.parse(rawJson).song;
		return swagShit;
	}
}