package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.system.FlxSound;

using flixel.util.FlxSpriteUtil;

class BambiEnemy extends FlxSprite
{
	static inline var SPEED:Float = 140;

	var brain:FSM;
	var idleTimer:Float;
	var moveDirection:Float;
	var stepSound:FlxSound;

	public var seesPlayer:Bool;
	public var playerPosition:FlxPoint;

	public var lockMovement:Bool = false;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		var graphic = Paths.image("bambiCornGame/bambi", 'shared');
		loadGraphic(graphic, true, 32, 32);
		setGraphicSize(64, 64);
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
		animation.add("d", [0, 1, 0, 2], 6, false);
		animation.add("lr", [3, 4, 3, 5], 6, false);
		animation.add("u", [6, 7, 6, 8], 6, false);
		drag.x = drag.y = 10;
		width = 8;
		height = 14;
		offset.x = 4;
		offset.y = 2;

		brain = new FSM(chase);
		idleTimer = 0;
		seesPlayer = false;
		playerPosition = FlxPoint.get();

		stepSound = FlxG.sound.load(Paths.sound("footstep", 'shared'));
		stepSound.proximity(x, y, FlxG.camera.target, FlxG.width * 0.6);
	}

	override public function update(elapsed:Float)
	{
		updateHitbox();

		if (this.isFlickering())
			return;

		if (!lockMovement)
			move();
		
		brain.update(elapsed);
		super.update(elapsed);
	}

	function move()
	{
		if ((velocity.x != 0 || velocity.y != 0) && touching == NONE)
		{
			if (Math.abs(velocity.x) > Math.abs(velocity.y))
			{
				if (velocity.x < 0)
					facing = LEFT;
				else
					facing = RIGHT;
			}
			else
			{
				if (velocity.y < 0)
					facing = UP;
				else
					facing = DOWN;
			}
	
			switch (facing)
			{
				case LEFT, RIGHT:
					animation.play("lr");
	
				case UP:
					animation.play("u");
	
				case DOWN:
					animation.play("d");
	
				case _:
			}
		}

		if ((velocity.x != 0 || velocity.y != 0) && touching == NONE)
		{
			stepSound.setPosition(x + frameWidth / 2, y + height);
			stepSound.play();
		}
	
	}

	public function idle(elapsed:Float)
	{
		// nuthin
	}

	public function chase(elapsed:Float)
	{
		FlxVelocity.moveTowardsPoint(this, playerPosition, Std.int(SPEED));
	}
}

class FSM
{
	public var activeState:Float->Void;

	public function new(initialState:Float->Void)
	{
		activeState = initialState;
	}

	public function update(elapsed:Float)
	{
		activeState(elapsed);
	}
}