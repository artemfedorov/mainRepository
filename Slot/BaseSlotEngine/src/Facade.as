package
{
	import flash.display.MovieClip;
	
	import model.BaseGame;
	import model.BaseStates;
	
	import net.BaseAPIController;
	
	import starling.display.Stage;

	public class Facade
	{
		public static var game:BaseGame;
		public static var stage:starling.display.Stage;
		public static var root:RootClass;
		static public var apiController:BaseAPIController;
		static public var states:BaseStates;
		public static var layout:MovieClip;
	}
}