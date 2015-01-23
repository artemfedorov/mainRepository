package
{
	import flash.display.Sprite;
	
	import model.GameController;
	import model.MenuController;
	
	import starling.display.Stage;
	import model.GameInterfaceController;

	public class Facade
	{
		public static var wpStart:Sprite;
		public static var wpFinish:Sprite;
		
		public static var wps:Array = [];
		public static var game:GameController;
		public static var stage:Stage;
		public static var menu:MenuController;
		public static var startDrag:Boolean;
		public static var gameInterfaceController:GameInterfaceController;
	}
}