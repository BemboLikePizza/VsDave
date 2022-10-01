package;

import flixel.FlxG;
import flixel.FlxState;

class StartStateSelector extends FlxState
{
   public override function create()
   {
      LanguageManager.initSave();
      LanguageManager.save.data.language == null;
      CompatTool.initSave();
      CompatTool.save.data.compatMode == null;
      if (LanguageManager.save.data.language == null)
      {
         FlxG.switchState(new SelectLanguageState());
      }
      else
      {
         if(CompatTool.save.data.compatMode == null)
            {
               FlxG.switchState(new CompatWarningState());
            }
         else
            {
               FlxG.switchState(new TitleState());
            }
      }
   }
}