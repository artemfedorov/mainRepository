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
	     public static function dispatch($type:String, $params:Object = null):void
		{
			var e:ApplicationEvents = new ApplicationEvents($type, $params);
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
			 _listenersList[$handler] = $type;
			 _dispatcher.addEventListener($type, $handler);
		 }
		 
		 /**
		  * 
		  * @param $type
		  * 
		  */		 
		 public static function removeListener($type:String, $handler:Function):void
		 {
			if(_listenersList[$handler] == null) return;
			 _dispatcher.removeEventListener($type, $handler);
			 _listenersList[$handler] = null;
		 }
		 
		 /**
		  * 
		  * 
		  */		 
		/* public static function removeAllListeners():void
		 {
			for (var item:String in _listenersList)
			{
				if(_listenersList[item] != null) 
				{
					_dispatcher.removeEventListener(item, _listenersList[item]);
					_listenersList[item] = null;
				}
			}
		 }*/
		 
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