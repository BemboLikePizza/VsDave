import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flash.system.System;
import flixel.system.FlxSound;


class RecurserFunnyBGText extends FlxText
{
    public var randomXRange:Float = 100;
    public var randomYRange:Float = 100;
    public var randomOffset:Float = 0;

    public function Randomize()
    {
        alpha = 0.05;
        var random:FlxRandom = new FlxRandom();
        randomXRange = random.float(40,400);
        randomYRange = random.float(40,400);
        randomOffset = random.float(-999,999);
    }

    override public function update(elapsed:Float)
    {
        var curtime:Float = FunnyTextState.currentInstance.elapsedTime + randomOffset;
        x = ((FlxG.width / 2) - (width / 4)) + Math.sin(curtime / 1.5) * randomXRange;
        y = (FlxG.height / 2) + (Math.sin(curtime / 2) * randomYRange);
    }
}

class FunnyTextState extends FlxState
{

    public var elapsedTime:Float = 0;

    public static var currentInstance:FunnyTextState;

    public var timeTilNextDialogue:Float = 9999;

    public var DisplayText:FlxText;

    public var Dialogue:Array<String>;

    public var recurserTextBG:FlxTypedGroup<RecurserFunnyBGText>;

    public var sound:FlxSound;

    public function new(dial:Array<String>)
    {
        super();
        currentInstance = this;
        Dialogue = dial;
        Dialogue.reverse(); //so the order is correct since "pop" pops the last element
        sound = new FlxSound();
        sound.loadEmbedded(Paths.sound('dialogue/recurserDialogue',"shared"));
    }

    override public function create():Void 
    {
        FlxG.sound.playMusic(Paths.music('TheAmbience','shared'), 1);
        recurserTextBG = new FlxTypedGroup<RecurserFunnyBGText>();
        for (_ in 0...50) //discard
        {
            var t = new RecurserFunnyBGText(0, FlxG.height / 2, FlxG.width, "Placeholder", 32);
            t.Randomize();
            recurserTextBG.add(t);
        }
        add(recurserTextBG);
        DisplayText = new FlxText(0, FlxG.height / 2, FlxG.width, "Placeholder", 32);
        DisplayText.setFormat(Paths.font("PixelOperator-Bold.ttf"), 54, FlxColor.WHITE, FlxTextAlign.CENTER);
        popDialogue();
        add(DisplayText);
    }

    function popDialogue():Void
    {
        var DialogueDataRaw:String = Dialogue.pop();
        if (DialogueDataRaw == null)
        {
            endDialogue();
            return;
        }
        sound.play();
        var DialogueData:Array<String> = DialogueDataRaw.split("|");
        DialogueData.reverse(); //so the order is correct
        DisplayText.text = DialogueData.pop();
        for (text in recurserTextBG)
        {
            text.text = DisplayText.text;
        }
        timeTilNextDialogue = Std.parseFloat(DialogueData.pop());
    }

    function endDialogue()
    {
        FlxG.switchState(new TerminalState());
    }

    override public function update(elapsed:Float):Void
    {
        elapsedTime += elapsed;
        timeTilNextDialogue -= elapsed;
        if (timeTilNextDialogue <= 0)
        {
            popDialogue();
        }
        DisplayText.x = (Math.sin(elapsedTime / 2) * 30);
        DisplayText.y = (FlxG.height / 2) + (Math.sin(elapsedTime / 3) * 30);
        super.update(elapsed);
    }
}