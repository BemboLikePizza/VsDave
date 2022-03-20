package;

import flixel.util.FlxColor;

class LanguageManager
{
   public static var currentLocaleList:Array<String>;

   public static function languageFromPathName(pathName:String):Language
   {
      var langauges:Array<Language> = getLanguages();

      for (langauge in langauges)
      {
         if (langauge.pathName == pathName)
         {
            return langauge;
         }
      }
	  return null;
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
   public static function getLanguages():Array<Language>
   {
      var languages:Array<Language> = new Array<Language>();
      var languagesText:Array<String> = CoolUtil.coolTextFile(Paths.langaugeFile());

      for (language in languagesText)
      {
         var splitInfo = language.split(':');
         var languageClass:Language = new Language(splitInfo[0], splitInfo[1], FlxColor.fromString(splitInfo[2]));
         languages.push(languageClass);
      }
      return languages;
   }
}