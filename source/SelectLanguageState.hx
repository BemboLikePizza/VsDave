package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;

class SelectLanguageState extends MusicBeatState
{
   public var selectLanguage:FlxText;
   public var textItems:Array<FlxText> = new Array<FlxText>();

   public override function create()
   {
      selectLanguage = new FlxText(FlxG.width / 2, (FlxG.height / 2) - 300, 0, "Please Select A Language", 32);
      selectLanguage.screenCenter(X);
      selectLanguage.setFormat("Comic Sans MS Bold", 25, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
      selectLanguage.borderSize = 2;
      add(selectLanguage);

      var langaugeList:Array<String> = LanguageManager.getLanguages(false);

      for (i in 0...langaugeList.length)
      {
         var currentLangauge = langaugeList[i];

         var langaugeText:FlxText = new FlxText(FlxG.width / 2, (FlxG.height / 2 - 500) + i * 50, 0, currentLangauge, 25);
         langaugeText.screenCenter(X);
         langaugeText.setFormat("Comic Sans MS Bold", 25, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
         langaugeText.borderSize = 2;

         textItems.push(langaugeText);
         add(langaugeText);
      }
   }
   public override function update(elapsed:Float)
   {
      if (controls.ACCEPT)
      {
         FlxG.switchState(new MainMenuState());
      }
   }
}