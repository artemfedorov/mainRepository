package utils {

	import AIEvents.GameEvents;
	
	import Box2D.Common.Math.b2Vec2;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author artemfedorov.com
	 */

	public class KeyboardEvents
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
		
		public function KeyboardEvents(level:MovieClip)
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
				
		public function key_down(e:KeyboardEvent):void 
		{
			keysm[int(e.keyCode)] = true;
			//trace(e.keyCode);
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