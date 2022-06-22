package;

import flixel.util.FlxColor;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	public var furiosityScale:Float = 1.02;
	public var canDance:Bool = true;

	public var nativelyPlayable:Bool = false;

	public var globaloffset:Array<Float> = [0,0];
	
	public var barColor:FlxColor;
	
	public var canSing:Bool = true;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		
		antialiasing = true;

		switch (curCharacter)
		{
			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared');
				frames = tex;
				
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(49, 176, 209);

				playAnim('idle');

				nativelyPlayable = true;

				flipX = true;
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('weeb/bfPixel', 'shared');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				loadOffsetFile(curCharacter);
					
				globaloffset[0] = -200;
				globaloffset[1] = -175;

				barColor = FlxColor.fromRGB(49, 176, 209);
				
				
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				
				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				nativelyPlayable = true;

				flipX = true;
				
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('weeb/bfPixelsDEAD', 'shared');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');
				loadOffsetFile(curCharacter);

				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				nativelyPlayable = true;
				flipX = true;
			
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_assets', 'shared');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromString('#33de39');

				playAnim('danceRight');
			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('weeb/gfPixel', 'shared');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				if (!PlayState.curStage.startsWith('school'))
				{
					globaloffset[0] = -200;
					globaloffset[1] = -175;
				}
				
				loadOffsetFile(curCharacter);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'dave':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('dave/characters/dave_sheet', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('hey', 'hey', 24, false);
	
				loadOffsetFile(curCharacter);
				
				barColor = FlxColor.fromRGB(15, 95, 255);

				playAnim('idle');
			case 'dave-annoyed':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('dave/characters/Dave_insanity_lol', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
				animation.addByPrefix('scared', 'Scared', 24, true);
	
				loadOffsetFile(curCharacter);
				
				barColor = FlxColor.fromRGB(15, 95, 255);

				playAnim('idle');
			case 'dave-cool':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('dave/characters/thecoolerdave', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Id', 24, false);
				animation.addByPrefix('singUP', 'the up', 24, false);
				animation.addByPrefix('singRIGHT', 'righ', 24, false);
				animation.addByPrefix('singDOWN', 'dow', 24, false);
				animation.addByPrefix('singLEFT', 'lef', 24, false);
	
				loadOffsetFile(curCharacter);
				
				barColor = FlxColor.fromRGB(15, 95, 255);
	
				playAnim('idle');

			case 'dave-angey':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('dave/characters/Dave_Furiosity', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
		
				loadOffsetFile(curCharacter);
				
				barColor = FlxColor.fromRGB(249, 180, 207);

				setGraphicSize(Std.int(width * furiosityScale),Std.int(height * furiosityScale));
				updateHitbox();
				antialiasing = false;
		
				playAnim('idle');
				
			case 'dave-splitathon':
				frames = Paths.getSparrowAtlas('splitathon/Splitathon_Dave', 'shared');
				animation.addByPrefix('idle', 'SplitIdle', 24, false);
				animation.addByPrefix('singDOWN', 'SplitDown', 24, false);
				animation.addByPrefix('singUP', 'SplitUp', 24, false);
				animation.addByPrefix('singLEFT', 'SplitLeft', 24, false);
				animation.addByPrefix('singRIGHT', 'SplitRight', 24, false);
				animation.addByPrefix('scared', 'Nervous', 24, true);
				animation.addByPrefix('what', 'Mad', 24, true);
				animation.addByPrefix('happy', 'Happy', 24, true);

				loadOffsetFile(curCharacter);
				
				barColor = FlxColor.fromRGB(15, 95, 255);

				playAnim('idle');

			case 'bambi':
				var tex = Paths.getSparrowAtlas('bambi/characters/bambi', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS0', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
	
				barColor = FlxColor.fromRGB(37, 191, 55);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				nativelyPlayable = true;
				flipX = true;

			case 'bambi-new':
				frames = Paths.getSparrowAtlas('bambi/bambiRemake', 'shared');
				animation.addByPrefix('idle', 'bambi idle', 24, false);
				animation.addByPrefix('singDOWN', 'bambi down', 24, false);
				animation.addByPrefix('singUP', 'bambi up', 24, false);
				animation.addByPrefix('singLEFT', 'bambi left', 24, false);
				animation.addByPrefix('singRIGHT', 'bambi right', 24, false);
				animation.addByPrefix('singSmash', 'bambi phone', 24, false);

				barColor = FlxColor.fromRGB(37, 191, 55);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'baldi':
				frames = Paths.getSparrowAtlas('characters/BaldiInRoof', 'shared');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(14, 174, 44);

				playAnim('idle');

			case 'bambi-splitathon':
				frames = Paths.getSparrowAtlas('splitathon/Splitathon_Bambi', 'shared');
				animation.addByPrefix('idle', 'splitathon idle', 24, true);
				animation.addByPrefix('singDOWN', 'splitathon down', 24, false);
				animation.addByPrefix('singUP', 'splitathon up', 24, false);
				animation.addByPrefix('singLEFT', 'splitathon left', 24, false);
				animation.addByPrefix('singRIGHT', 'splitathon right', 24, false);
				animation.addByPrefix('yummyCornLol', 'splitathon corn', 24, true);
				animation.addByPrefix('umWhatIsHappening', 'confused Idle', 24, true);
							
				loadOffsetFile(curCharacter);
				
				barColor = FlxColor.fromRGB(37, 191, 55);

				playAnim('idle');

			case 'bambi-angey':
				frames = Paths.getSparrowAtlas('bambi/bambimaddddd', 'shared');
				animation.addByPrefix('idle', 'idle', 24, true);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);

				barColor = FlxColor.fromRGB(37, 191, 55);

				loadOffsetFile(curCharacter);

				playAnim('idle');
	
			case 'bambi-3d':
				// BAMBI SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('bambi/characters/Cheating', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
		
				barColor = FlxColor.fromRGB(17, 223, 10);

				loadOffsetFile(curCharacter);

				globaloffset[0] = 150;
				globaloffset[1] = 450; //this is the y
				setGraphicSize(Std.int((width * 1.5) / furiosityScale));
				updateHitbox();
				antialiasing = false;
		
				playAnim('idle');
			

			case 'bambi-unfair':
				// BAMBI SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('bambi/unfair_bambi', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'singUP', 24, false);
				animation.addByPrefix('singRIGHT', 'singRIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'singDOWN', 24, false);
				animation.addByPrefix('singLEFT', 'singLEFT', 24, false);
		
				barColor = FlxColor.fromRGB(178, 7, 7);

				loadOffsetFile(curCharacter);

				globaloffset[0] = 150 * 1.3;
				globaloffset[1] = 450 * 1.3; //this is the y
				setGraphicSize(Std.int((width * 1.3) / furiosityScale));
				updateHitbox();
				antialiasing = false;
		
				playAnim('idle');

			case 'expunged':
				// EXPUNGED SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('bambi/ExpungedFinal', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
		
				loadOffsetFile(curCharacter);
				
				barColor = FlxColor.fromRGB(82, 15, 15);

				globaloffset[0] = 150 * 0.8;
				globaloffset[1] = 450 * 0.8; //this is the y
				setGraphicSize(Std.int((width * 0.8) / furiosityScale));
				updateHitbox();
				antialiasing = false;
		
				playAnim('idle');
			
			case 'bambi-old':
				var tex = Paths.getSparrowAtlas('bambi/characters/bambi-old', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'MARCELLO idle dance', 24, false);
				animation.addByPrefix('singUP', 'MARCELLO NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'MARCELLO NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'MARCELLO NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'MARCELLO NOTE DOWN0', 24, false);
				animation.addByPrefix('idle', 'MARCELLO idle dance', 24, false);
				animation.addByPrefix('singUPmiss', 'MARCELLO MISS UP0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'MARCELLO MISS LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'MARCELLO MISS RIGHT0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'MARCELLO MISS DOWN0', 24, false);

				animation.addByPrefix('firstDeath', "MARCELLO dead0", 24, false);
				animation.addByPrefix('deathLoop', "MARCELLO dead0", 24, true);
				animation.addByPrefix('deathConfirm', "MARCELLO dead0", 24, false);
	
				
				barColor = FlxColor.fromRGB(12, 181, 0);

				loadOffsetFile(curCharacter);
				

				playAnim('idle');

				nativelyPlayable = true;
	
				flipX = true;
			case 'tristan':
				var tex = Paths.getSparrowAtlas('dave/TRISTAN', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
	
				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);
	
				loadOffsetFile(curCharacter + (isPlayer ? '-playable' : ''));

				barColor = FlxColor.fromRGB(255, 19, 15);
	
				playAnim('idle');

				nativelyPlayable = true;
	
				flipX = true;

			case 'tristan-golden':
			    var tex = Paths.getSparrowAtlas('dave/tristan_golden', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
	
				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);
	
				loadOffsetFile(curCharacter + (isPlayer ? '-playable' : ''));
				
				barColor = FlxColor.fromRGB(255, 222, 0);
				
				playAnim('idle');

				nativelyPlayable = true;
	
				flipX = true;
			case 'tristan-golden-glowing':
				var tex = Paths.getSparrowAtlas('dave/tristan_golden_glowing', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
		
				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('dodge', "boyfriend dodge", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('hit', 'BF hit', 24, false);
		
				loadOffsetFile(curCharacter + (isPlayer ? '-playable' : ''));
					
				barColor = FlxColor.fromRGB(255, 222, 0);
					
				playAnim('idle');
	
				nativelyPlayable = true;
		
				flipX = true;	
			case 'tristan-festival':
				frames = Paths.getSparrowAtlas('festival/tristan_festival');
				
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				
				loadOffsetFile(curCharacter + (isPlayer ? '-playable' : ''));
				
				barColor = FlxColor.fromRGB(255, 19, 15);
				
				nativelyPlayable = true;
				flipX = true;
				playAnim('idle');
			case 'exbungo':
				var tex = Paths.getSparrowAtlas('bambi/exbungo', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);

				loadOffsetFile(curCharacter);
				
				barColor = FlxColor.fromRGB(253, 39, 33);

				playAnim('idle');
	
				nativelyPlayable = true;
	
				flipX = true;

				setGraphicSize(Std.int((width * 1.3) / furiosityScale));
				updateHitbox();
	
				antialiasing = false;

			// Bananacore shit
			// You can basically ignore everything beyond this point
			// Most of these are just one-time characters that appear for a few seconds

			case 'cockey':
				tex = Paths.getSparrowAtlas('eletric-cockadoodledoo/characters/Cockey', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Cockey idle', 24, false);
				animation.addByPrefix('singUP', 'Cockey up', 24, false);
				animation.addByPrefix('singRIGHT', 'Cockey right', 24, false);
				animation.addByPrefix('singDOWN', 'Cockey down', 24, false);
				animation.addByPrefix('singLEFT', 'Cockey left', 24, false);
		
				loadOffsetFile(curCharacter);

				barColor = FlxColor.fromRGB(228, 85, 81);

				setGraphicSize(Std.int(width * 2));
				updateHitbox();
				antialiasing = false;
		
				playAnim('idle');
			

			case 'pissey':
				tex = Paths.getSparrowAtlas('eletric-cockadoodledoo/characters/Pissey', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('phoneOFF', 'turning his phone off', 24, true);
				animation.addByPrefix('phoneAWAY', 'putting his phone away', 24, false);
		
				loadOffsetFile(curCharacter);
				
				barColor = FlxColor.fromRGB(255, 206, 11);

				setGraphicSize(Std.int(width * 1.85));
				updateHitbox();
				antialiasing = false;
		
				playAnim('idle');

			case 'shartey':
				tex = Paths.getSparrowAtlas('eletric-cockadoodledoo/characters/Shartey', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Shartey idle', 24, false);
				animation.addByPrefix('singUP', 'Shartey up', 24, false);
				animation.addByPrefix('singRIGHT', 'Shartey right', 24, false);
				animation.addByPrefix('singDOWN', 'Shartey down', 24, false);
				animation.addByPrefix('singLEFT', 'Shartey left', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Shartey alt-down', 24, false);
			
				loadOffsetFile(curCharacter);
					
				barColor = FlxColor.fromRGB(104, 191, 202);
	
				setGraphicSize(Std.int(width * 1.65));
				updateHitbox();
				antialiasing = false;
			
				playAnim('idle');

			case 'pooper':
				tex = Paths.getSparrowAtlas('eletric-cockadoodledoo/characters/Pooper', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
			
				loadOffsetFile(curCharacter);
				
				barColor = FlxColor.fromRGB(136, 104, 107);

				setGraphicSize(Std.int(width * 4.75));
				updateHitbox();
				antialiasing = false;
			
				playAnim('idle');

			case 'bartholemew':
				tex = Paths.getSparrowAtlas('eletric-cockadoodledoo/characters/Bartholemew', "shared");
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'kapi':
				tex = Paths.getSparrowAtlas('eletric-cockadoodledoo/characters/Kapi', "shared");
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				loadOffsetFile(curCharacter);
	
				playAnim('idle');

			case 'cuzsiee':
				tex = Paths.getSparrowAtlas('eletric-cockadoodledoo/characters/cuzsiee', "shared");
				frames = tex;
				animation.addByPrefix('idle', 'cuzsiee idle', 24);
				animation.addByPrefix('singUP', 'cuzsiee up', 24);
				animation.addByPrefix('singRIGHT', 'cuzsiee right', 24);
				animation.addByPrefix('singDOWN', 'cuzsiee down', 24);
				animation.addByPrefix('singLEFT', 'cuzsiee left', 24);
	
				loadOffsetFile(curCharacter);
		
				playAnim('idle');	

			case 'ayo-the-pizza-here':
				tex = Paths.getSparrowAtlas('eletric-cockadoodledoo/characters/PizzaMan', "shared");
				frames = tex;
				animation.addByPrefix('idle', 'Idle', 24);
				animation.addByPrefix('singUP', 'Up', 24);
				animation.addByPrefix('singRIGHT', 'Right', 24);
				animation.addByPrefix('singDOWN', 'Down', 24);
				animation.addByPrefix('singLEFT', 'Left', 24);
				animation.addByPrefix('pizza', 'PizzasHere', 24);
				loadOffsetFile(curCharacter);
		
				playAnim('idle');
			case 'recurser':
				frames = Paths.getSparrowAtlas('recursed/Recurser', "shared");

				animation.addByPrefix('idle', 'recursedIdle', 24);
				animation.addByPrefix('singLEFT', 'recursedLeft', 24);
				animation.addByPrefix('singDOWN', 'recursedDown', 24);
				animation.addByPrefix('singUP', 'recursedUp', 24);
				animation.addByPrefix('singRIGHT', 'recursedRight', 24);

				barColor = FlxColor.fromRGB(44, 44, 44);

				loadOffsetFile(curCharacter);

				playAnim('idle');
			case 'bf-recursed':
				frames = Paths.getSparrowAtlas('recursed/Recursed_BF', 'shared');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);

				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);

				animation.addByPrefix('firstDeath', 'BF dies', 24, false);
				animation.addByPrefix('deathLoop', 'BF Dead Loop', 24, false);
				animation.addByPrefix('deathConfirm', 'BF Dead confirm', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24, false);

				flipX = true;
				barColor = FlxColor.WHITE;
				
				loadOffsetFile(curCharacter);
				
				nativelyPlayable = true;

				playAnim('idle');
		}
		dance();

		if(isPlayer)
		{
			flipX = !flipX;
		}
	}
	function loadOffsetFile(character:String)
	{
		var offsetStuffs:Array<String> = CoolUtil.coolTextFile(Paths.offsetFile(character));
		
		for (offsetText in offsetStuffs)
		{
			var offsetInfo:Array<String> = offsetText.split(' ');

			addOffset(offsetInfo[0], Std.parseFloat(offsetInfo[1]), Std.parseFloat(offsetInfo[2]));
		}
	}

	override function update(elapsed:Float)
	{
		if (animation == null)
		{
			super.update(elapsed);
			return;
		}
		else if (animation.curAnim == null)
		{
			super.update(elapsed);
			return;
		}
		if (!nativelyPlayable && !isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode && canDance)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight', true);
						else
							playAnim('danceLeft', true);
					}
				default:
					playAnim('idle', true);
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (animation.getByName(AnimName) == null)
		{
			return; //why wasn't this a thing in the first place
		}
		if(AnimName.toLowerCase() == 'idle' && !canDance)
		{
			return;
		}
		
		if(AnimName.toLowerCase().startsWith('sing') && !canSing)
		{
			return;
		}
		
		animation.play(AnimName, Force, Reversed, Frame);
	
		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			if (isPlayer)
			{
				if(!nativelyPlayable)
				{
					offset.set((daOffset[0] * -1) + globaloffset[0], daOffset[1] + globaloffset[1]);
				}
				else
				{
					offset.set(daOffset[0] + globaloffset[0], daOffset[1] + globaloffset[1]);
				}
			}
			else
			{
				if(nativelyPlayable)
				{
					offset.set((daOffset[0] * -1), daOffset[1]);
				}
				else
				{
					offset.set(daOffset[0], daOffset[1]);
				}
			}
		}
		
		else
			offset.set(0, 0);
	
		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}
	
			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
