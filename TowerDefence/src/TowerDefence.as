package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	
	import model.MenuController;
	
	import starling.core.Starling;
	
	[SWF(height="640", width="1136", frameRate="61")]
	
	public class TowerDefence extends Sprite
	{
		private var _starling:Starling;
		
		public function TowerDefence()
		{
			super();
			
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Starling.multitouchEnabled = true;
			_starling = new Starling(MenuController, stage);
			_starling.start();

			stage.align = StageAlign.TOP_LEFT;
			Facade.stage = _starling.stage;
			
		}
	}
	
}