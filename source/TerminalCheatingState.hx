package;

import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.text.FlxText.FlxTextAlign;
import flixel.addons.text.FlxTypeText;
import openfl.filters.ShaderFilter;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIState;
import flixel.FlxG;
import flixel.util.FlxColor;

class TerminalCheatingState extends FlxUIState
{
   var typedText:FlxTypeText;
   var terminalTextsLeft:Array<TerminalText> = new Array<TerminalText>();
   var curTextIndex:Int = 0;
   var typeTime:Float = 0.05;
   var startText:String = '> ';
   
   var onCommandsComplete:Void->Void;

   public function new(terminalTexts:Array<TerminalText>, onCommandsComplete:Void->Void)
   {
      terminalTextsLeft = terminalTexts;
      this.onCommandsComplete = onCommandsComplete;

      super();
   }
   override function create()
	{
      if (!FlxG.save.data.enteredTerminalCheatingState)
      {
         FlxG.save.data.enteredTerminalCheatingState = true;
         FlxG.save.flush();
      }
      FlxG.sound.music.onComplete = null;
      FlxG.sound.music.fadeOut(1, 0, function(tween:FlxTween)
      {
         FlxG.sound.music.stop();
      });

      if(CompatTool.save.data.compatMode != null && CompatTool.save.data.compatMode == false)
      {
         var vcr:VCRDistortionShader = new VCRDistortionShader();
         FlxG.camera.setFilters([new ShaderFilter(vcr)]);
      }

      var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('backgrounds/terminal'));
      bg.setGraphicSize(FlxG.width, FlxG.height);
      bg.updateHitbox();
      bg.screenCenter();
      bg.scrollFactor.set();
      add(bg);

      typedText = new FlxTypeText(50, 100, FlxG.width, terminalTextsLeft[0].texts[curTextIndex][0], 12);
      typedText.setFormat(Paths.font("consola.ttf"), 24, FlxColor.LIME, FlxTextAlign.LEFT);
      typedText.sounds = [FlxG.sound.load(Paths.sound('terminal_space'), 0.6)];
      typedText.antialiasing = false;
      typedText.showCursor = true;
      typedText.prefix = startText;
      add(typedText);

      startTypingText();

		super.create();
	}
	override function update(elapsed:Float)
	{
      if (FlxG.keys.justPressed.ENTER && FlxG.save.data.enteredTerminalCheatingState)
      {
         FlxG.camera.setFilters([]);
			onCommandsComplete();
      }
		super.update(elapsed);
	}
   function continueTerminalText()
   {
      curTextIndex++;
      var curDisplayedText = terminalTextsLeft[0].texts[curTextIndex - 1][0];
      var delay:Float = terminalTextsLeft[0].texts[curTextIndex - 1][1];
      var nextText = terminalTextsLeft[0].texts[curTextIndex][0];

      typedText.prefix += curDisplayedText;
      typedText.resetText(nextText);

      new FlxTimer().start(delay, function(timer:FlxTimer)
      {
			startTypingText();
      });
   }
   function nextTerminalText()
   {
		if (terminalTextsLeft.length - 1 > 0)
		{
         terminalTextsLeft.remove(terminalTextsLeft[0]);
			curTextIndex = 0;

			var newText = terminalTextsLeft[0].texts[curTextIndex][0];
			var yOffset = terminalTextsLeft[0].yOffset;
			var delay = terminalTextsLeft[0].texts[curTextIndex][1];
			
			new FlxTimer().start(delay, function(timer:FlxTimer)
			{
            typedText.prefix = startText;
            typedText.resetText(newText);
            typedText.y += yOffset;

				startTypingText();
			});
		}
		else
		{
			end();
		}
   }
   function startTypingText()
   {
		typedText.start(typeTime, false, false, [], function()
		{
			if (curTextIndex + 1 > terminalTextsLeft[0].texts.length - 1)
			{
				nextTerminalText();
			}
			else
			{
				continueTerminalText();
			}
		});
   }
   function end()
   {
		new FlxTimer().start(1, function(timer:FlxTimer)
		{
			FlxG.camera.setFilters([]);
			onCommandsComplete();
		});
   }
}
class TerminalText
{
   public var yOffset:Float;
   public var texts:Array<Dynamic> = new Array<Dynamic>();
   //the text, and the delay before the next text

   public function new(yOffset:Float, texts:Array<Dynamic>)
   {
      this.yOffset = yOffset;
      this.texts = texts;
   }
}