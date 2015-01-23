package configs
{
	import interfaces.BaseInterfaceView;
	
	import lines.BaseLinesView;
	
	import model.BaseGame;

	public class Config
	{
		public static var types:Array = 
		[
			"ace",
			"butterfly",
			"flower",
			"flowerred",
			"jack",
			"king",
			"nine",
			"owl",
			"pantera",
			"queen",
			"ten",
			"wolf",
		];
		
		public static var speedRolling:Number = 25;
		static public var reelsAmount:int = 5;
		static public var symbolsPerReel:int = 3;
		static public var mainURL:String = "https://www.artemland.com/api";
		static public var showLinesCyclically:Boolean;
		static public var linesAmout:uint = 9;
		static public var activeLines:uint = 9;
		static public var showLinesInterval:Number = 1;
		
		
		
	}
}