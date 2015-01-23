package
{
	import starling.core.Starling;
	import starling.events.Event;
	
	import flash.display.Sprite;
	
	
	[SWF(frameRate="60", backgroundColor = "#000FFF", height="600", width="800")]
	
	public class Main extends Sprite
	{
		
		public function Main() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var starling:Starling = new Starling(RootClass, stage);
			starling.start();
		}
	}
}