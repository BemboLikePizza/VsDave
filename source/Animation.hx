using StringTools;

class Animation
{
	public var name:String;
	public var prefixName:String;
   public var frames:Int;
   public var looped:Bool;
   public var flip:Array<Bool>;

	public function create(name:String, prefixName:String, frames:Int, looped:Bool, flip:Array<Bool>)
	{
      if (flip == null) 
      {
         flip = new Array<Bool>();
         flip = [false, false];
      }
      this.name = name;
      this.prefixName = prefixName;
      this.frames = frames;
      this.looped = looped;
	}
}