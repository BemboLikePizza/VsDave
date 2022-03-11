package;

import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.effects.FlxFlicker;

class SelectLanguageState extends MusicBeatState
{
   var selectLanguage:FlxText;
   var textItems:Array<FlxText> = new Array<FlxText>();
   var curLanguageSelected:Int;
   var currentLanguage:FlxText;
   var langaugeList:Array<String> = new Array<String>();
   var accepted:Bool;

   public override function create()
   {
      selectLanguage = new FlxText(0, (FlxG.height / 2) - 300, 0, "Please Select A Language", 45);
      selectLanguage.screenCenter(X);
      selectLanguage.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
      selectLanguage.borderSize = 2;
      add(selectLanguage);

      langaugeList = LanguageManager.getLanguages(false);

      for (i in 0...langaugeList.length)
      {
         var currentLangauge = langaugeList[i];

         var langaugeText:FlxText = new FlxText(0, (FlxG.height / 2 - 250) + i * 50, 0, currentLangauge, 30);
         langaugeText.screenCenter(X);
         langaugeText.setFormat("Comic Sans MS Bold", 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
         langaugeText.borderSize = 2;

         langaugeText.y -= 10;
         langaugeText.alpha = 0;
         FlxTween.tween(langaugeText, {y: langaugeText.y + 10, alpha: 1}, 0.07, {startDelay: i * 0.1});

         textItems.push(langaugeText);
         add(langaugeText);
      }

      changeSelection();
   }
   public override function update(elapsed:Float)
   {
      if (controls.ACCEPT)
      {
         if (!accepted)
         {
            accepted = true;

            var localeList = LanguageManager.getLanguages(true);
            FlxG.save.data.language = localeList[curLanguageSelected];
            FlxFlicker.flicker(currentLanguage, 1.1, 0.07, true, true, function(flick:FlxFlicker)
            {
               FlxG.switchState(new MainMenuState());
            });
         }
      }
      if (controls.UP_P)
      {
         changeSelection(-1);
      }
      if (controls.DOWN_P)
      {
         changeSelection(1);
      }
   }
   function changeSelection(amount:Int = 0)
   {
      if (amount != 0) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

      curLanguageSelected += amount;

      if (curLanguageSelected > langaugeList.length - 1)
      {
         curLanguageSelected = 0;
      }
      if (curLanguageSelected < 0)
      {
         curLanguageSelected = langaugeList.length - 1;
      }
      for (menuItem in textItems)
      {
         updateText(menuItem, menuItem == textItems[curLanguageSelected]);
      }
   }
   function updateText(text:FlxText, selected:Bool)
   {
      if (selected)
      {
         text.setFormat("Comic Sans MS Bold", 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
      }
      else
      {
         text.setFormat("Comic Sans MS Bold", 25);
      }
   }
}