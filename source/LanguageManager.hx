package;

class LanguageManager
{
   public static var currentLocaleList:Array<String>;

   public static function languageNameFromPathName(pathName:String):String
   {
      var langaugeText:Array<String> = CoolUtil.coolTextFile(Paths.langaugeFile());

      for (langauge in langaugeText)
      {
         var splitInfo = langauge.split(':');
         
         if (pathName == splitInfo[1])
         {
            return splitInfo[0];
         }
      }
	  return '';
   }
   public static function getTextString(stringName:String):String
   {
      for (value in currentLocaleList)
      {
         var splitValue = value.split("==");

         if (splitValue[0] != stringName)
         {
            return '';
         }
         else
         {
            return splitValue[1];
         }
      }
      return '';
   }
   public static function getLanguages(pathNameList:Bool):Array<String>
   {
      var langauges:Array<String> = new Array<String>();
      var langaugeText:Array<String> = CoolUtil.coolTextFile(Paths.langaugeFile());

      for (langauge in langaugeText)
      {
         var splitInfo = langauge.split(':');
         langauges.push(splitInfo[pathNameList ? 1 : 0]);
      }
      return langauges;
   }
}