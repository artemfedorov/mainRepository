//BaseEngine

package superClasses
{
	import com.greensock.TweenMax;

	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	/*
	*
	*@author Artem.Fedorov
	*/
	
	public class BaseClass extends EventDispatcher
	{
		private var _obj:Sprite;
		private var _objChild:Sprite;
		public function BaseClass()
		{
			_obj = new Sprite();
			_objChild = new Sprite();
			_obj.addChild(_objChild);
			onRegister();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		protected function onRegister():void
		{
			//for overrride
		}
		
		protected function onDispose():void
		{
			//for overrride
		}

		
		public function delay($time:Number, $callback:Function = null, $callbackParams:Array = null, $repeatCount:int = 0, $onRepeat:Function = null, $onRepeatParams:Array = null):void
		{
			TweenMax.to(_objChild, $time, {onComplete:$callback, onCompleteParams:$callbackParams, repeat:$repeatCount, onRepeat:$onRepeat, onRepeatParams:$onRepeatParams});
		}
		
		public function killDelay($complete:Boolean = false):void
		  {
		   TweenMax.killAll();
		  }
		
		
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
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
	}
}