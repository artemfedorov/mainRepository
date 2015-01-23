package
{
	import flash.display.Sprite;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	
	[SWF(frameRate="60", backgroundColor = "#000FFF", height="1080", width="1920")]
	
	public class SlotMobile extends Sprite
	{
		
		public function SlotMobile() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var starling:Starling = new Starling(Root, stage);
			starling.start();
		}
	}
}