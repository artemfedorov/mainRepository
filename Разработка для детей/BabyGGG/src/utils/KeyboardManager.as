package utils {

	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	
	import gameEvents.GameEvents;
	import gameEvents.targets.GlobalListenerOwner;
	
	/**
	 * ...
	 * @author artemfedorov.com
	 */

	public class KeyboardManager
 {

		/**
		* properties
		*/
		private var currLevel:MovieClip;
		private var _keysm:Array = [];

		/*---------------------------------------------------------------------
		 * 
		 * constructor
		 * 
		 *---------------------------------------------------------------------*/
		
		public function KeyboardManager(level:MovieClip)
		{
			currLevel = level;
			currLevel.stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			currLevel.stage.addEventListener(KeyboardEvent.KEY_UP, key_up);
		}
		
		/*---------------------------------------------------------------------
		 * 
		 * getters / setter
		 * 
		 *---------------------------------------------------------------------*/
		
		public function get keysm():Array
		{
			return _keysm;
		}
		/*---------------------------------------------------------------------
		 * 
		 * Methods
		 * 
		 *---------------------------------------------------------------------*/
		public function dispose():void
		{
			currLevel.stage.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
			currLevel.stage.removeEventListener(KeyboardEvent.KEY_UP, key_up);	
		}
		public function key_down(e:KeyboardEvent):void 
		{
			keysm[int(e.keyCode)] = true;
			GlobalListenerOwner.GameListenersOwner.dispatchEvent(new GameEvents(GameEvents.KEY_DOWN, e.keyCode));
		}


		public function key_up(e:KeyboardEvent):void
		{
			keysm[int(e.keyCode)] = false;
		}
		
		
		public function isDown (k:int):Boolean
		{
			return (keysm[k]);
		}
	}
}