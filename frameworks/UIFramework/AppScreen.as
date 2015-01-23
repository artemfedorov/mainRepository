package 
{
	import events.ApplicationEvents;
	import events.EventConstants;
	import events.GlobalDispatcher;
	import utils.Utils;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;

	public class AppScreen extends BaseClass
	{
		public var callback:Function;
		
		private var _skin:MovieClip;
		private var _owner:AppScreen;
		private var _save:Boolean = true;
		private var _name:String;
		
		public function AppScreen($skin:MovieClip = null)
		{
			if ($skin) _skin = $skin;
			super();
		}
		
		public function findViewByName($name:String):DisplayObject
		{
			var d:DisplayObject;
			for (var i:int = 0; i < _skin.numChildren; i++) 
			{
				d = _skin.getChildAt(i);
				if (d.name && d.name == $name)
				return d;
			}
			return null;
		}
		
		
		public function draw():void
		{
			
		}
		
		public function sleep():void
		{
			
		}
		public function start($o:Object = null):void
		{
			GlobalDispatcher.dispatch(new ApplicationEvents(EventConstants.SCREEN_CREATED, _name));
			/*skin.addEventListener(TouchEvent.TOUCH_TAP, onTouchTapHandler);
			skin.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBeginHandler);
			skin.addEventListener(TouchEvent.TOUCH_END, onTouchEndHandler);
			skin.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMoveHandler);*/

			skin.addEventListener(MouseEvent.CLICK, onMouseClickHandler);
			skin.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			skin.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			skin.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
		}
		
		public function init($mc:MovieClip):void
		{
			
		}
		
		
		public function stop():void
		{
			/*skin.removeEventListener(TouchEvent.TOUCH_TAP, onTouchTapHandler);
			skin.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBeginHandler);
			skin.removeEventListener(TouchEvent.TOUCH_END, onTouchEndHandler);
			skin.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMoveHandler);*/
			
			skin.removeEventListener(MouseEvent.CLICK, onMouseClickHandler);
			skin.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			skin.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			skin.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			Utils.clearAll(skin);
		}
		
		protected function onMouseClickHandler(event:MouseEvent):void
		{
		//	trace("onMouseClickHandler");
		}
		
		protected function onMouseDownHandler(event:MouseEvent):void
		{
		//	trace("onMouseDownHandler");
		}
		
		protected function onMouseUpHandler(event:MouseEvent):void
		{
		//	trace("onMouseUpHandler");
		}
		
		protected function onMouseMoveHandler(event:MouseEvent):void
		{
		}		
		
		
		/*protected function onTouchMoveHandler(event:TouchEvent):void
		{
			trace("onTouchMoveHandler");
		}
		
		protected function onTouchEndHandler(event:TouchEvent):void
		{
			trace("onTouchEndHandler");
		}
		
		protected function onTouchBeginHandler(event:TouchEvent):void
		{
			trace("onTouchBeginHandler");
		}
		
		protected function onTouchTapHandler(event:TouchEvent):void
		{
			trace("onTouchTapHandler");
		}		*/
		
		public function get skin():MovieClip
		{
			return _skin;
		}

		public function set skin(value:MovieClip):void
		{
			_skin = value;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get owner():AppScreen 
		{
			return _owner;
		}
		
		public function set owner(value:AppScreen):void 
		{
			_owner = value;
		}
		
		public function get save():Boolean 
		{
			return _save;
		}
		
		public function set save(value:Boolean):void 
		{
			_save = value;
		}
		
		
		
		

	}
}