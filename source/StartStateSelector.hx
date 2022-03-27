package;

import flixel.FlxG;
import flixel.FlxState;

class StartStateSelector extends FlxState
{
   public override function create()
   {
      if (FlxG.save.data.language == null)
      {
         FlxG.switchState(new SelectLanguageState());
      }
      else
      {
         FlxG.switchState(new TitleState());
      }
   }
}