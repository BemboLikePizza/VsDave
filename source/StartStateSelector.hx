package;

import flixel.FlxG;
import flixel.FlxState;

class StartStateSelector extends FlxState
{
   public override function create()
   {
      LanguageManager.initSave();
      if (LanguageManager.save.data.langauge == null)
      {
         FlxG.switchState(new SelectLanguageState());
      }
      else
      {
         FlxG.switchState(new TitleState());
      }
   }
}