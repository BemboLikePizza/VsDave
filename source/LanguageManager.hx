package;

class LanguageManager
{
   public static function getLanguages(localeList:Bool):Array<String>
   {
      var langauges:Array<String> = new Array<String>();
      var langaugeText:Array<String> = CoolUtil.coolTextFile(Paths.langaugeFile());

      for (langauge in langaugeText)
      {
         var splitInfo = langauge.split(':');
         langauges.push(splitInfo[localeList ? 1 : 0]);
      }
      return langauges;
   }
}