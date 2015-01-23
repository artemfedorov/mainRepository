package events
{
	import flash.events.Event;
	
	/**
	*
	* @author Artem.Fedorov
	*/
	public class ApplicationEvents extends Event
	{
		
		private var _params:Object;
		
		public function ApplicationEvents(type:String, param:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_params = param;
			super(type, bubbles, cancelable);
			//if (type != "GraphicMouseClick" && type != "GraphicMouseDown" && type != "GraphicMouseUp" && type != "GraphicMouseOut" && type != "GraphicMouseOver" && type != "InterfaceMouseClick" && type != "InterfaceMouseOver") 
				//trace("APPLICATION EVENTS: " + type + " type: " + param);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//
		//  Events handlers
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//
		//  Getters&setters
		//
		//--------------------------------------------------------------------------
		public function get params():Object 
		{
			return _params;
		}
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
	}
}