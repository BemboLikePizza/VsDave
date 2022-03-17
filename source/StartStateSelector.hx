package;

import flixel.FlxG;
import flixel.FlxState;

class StartStateSelector extends FlxState
{
   public override function create()
   {
      FlxG.save.data.language = null;
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