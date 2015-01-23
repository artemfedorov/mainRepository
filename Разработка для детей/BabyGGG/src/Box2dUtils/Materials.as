package Box2dUtils
{
	public class Materials 
	{	
		public static const GROUND:int = 0;
		public static const WOOD:int = 1;

		public static const STONE:int = 2;
		public static const METAL:int = 3;
		
		public static const BALL:int = 4;
		public static const HERO:int = 5;
		 
		public static const MATERIAL:int = 0;
		public static const DENSITY:int = 1;
		public static const FRICTION:int = 2;
		public static const RESTITUTION:int = 3;
		
		public static var material:Array = new Array 
		(	
			new Array(GROUND,   0.9, 0.3, 0.0),
			new Array(WOOD,     0.9, 0.3, 0.0),
			
			new Array(STONE,    1.0, 0.0, 0.8),
			new Array(METAL,    1.0  , 1.0, 0.0),
			
			new Array(BALL,    1.0, 0.3, 0.0),
			new Array(HERO,    1.0, 0.3, 0.0)
		);
	}
}