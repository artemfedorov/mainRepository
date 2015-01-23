package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	import model.B2DController;
	import model.GameModel;
	
	import views.GameView;
	import views.InterfaceView;
	import model.NB2DController;

	/**
	 * ...
	 * @author 
	 */
	public class GameFacade 
	{		
		public static var currentGameType:String;
	
		public static var myStage:Stage;
		public static var gameModel:GameModel;
		public static var gameView:GameView;
		public static var b2dEngine:B2DController;
		public static var skin:MovieClip;
		public static var interfaceView:InterfaceView;
		public static var nb2dEngine:NB2DController;
	}

}