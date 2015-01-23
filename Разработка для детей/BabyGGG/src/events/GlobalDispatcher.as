//BaseEngine

package events
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	
	/*
	*
	*@author Artem.Fedorov
	*/
	
	public class GlobalDispatcher extends EventDispatcher
	{
		private static var _dispatcher:EventDispatcher = new EventDispatcher();
		private static var _listenersList:Dictionary = new Dictionary();
		static public var gameId:int = 0;

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		 /**
		  * 
		  * @param event
		  * 
		  */		
	     public static function dispatch(event:ApplicationEvents):void
		{
			var e:ApplicationEvents = new ApplicationEvents(String(event.type/* + gameId*/), event.params, event.bubbles, event.cancelable);
			_dispatcher.dispatchEvent(e);
			//if(e.type.indexOf("Graphic") == -1 && e.type.indexOf("Interface") == -1) trace("GlobalDispatcher dispatch:", e.type);
		}
		 
		 /**
		  * 
		  * @param $type
		  * @param $handler
		  * 
		  */		 
		 public static function addListener($type:String, $handler:Function):void
		 {
			if(!$type) return;
			 _listenersList[$type/* + gameId*/] = $handler;
			 trace("addListener", $type/* + gameId*/, " gameId", gameId);
			 _dispatcher.addEventListener($type/* + gameId*/, $handler);
		 }
		 
		 /**
		  * 
		  * @param $type
		  * 
		  */		 
		 public static function removeListener($type:String):void
		 {
			if(_listenersList[$type/* + gameId*/] == null) return;
			 _dispatcher.removeEventListener($type/* + gameId*/, _listenersList[$type/* + gameId*/]);
			 _listenersList[$type/* + gameId*/] = null;
		 }
		 
		 /**
		  * 
		  * 
		  */		 
		 public static function removeAllListeners():void
		 {
			for (var item:String in _listenersList)
			{
				if(_listenersList[item/* + gameId*/] != null) 
				{
					_dispatcher.removeEventListener(item/* + gameId*/, _listenersList[item/* + gameId*/]);
					_listenersList[item/* + gameId*/] = null;
				}
			}
		 }
		 
		//--------------------------------------------------------------------------
		//
		//  Getters&setters
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
		 
	}
}