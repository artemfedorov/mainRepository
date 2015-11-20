package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class TetrisGame extends Sprite
	{
		public function TetrisGame()
		{
			if(stage) 
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		private function init(e:Event = null):void
		{
			var gameModel:GameModel = new GameModel();
		}
	}
}