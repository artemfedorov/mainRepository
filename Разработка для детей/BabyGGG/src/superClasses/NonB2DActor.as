package  superClasses
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import events.ApplicationEvents;
	import events.GlobalDispatcher;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	import utils.Utilities;
	
	
	/**
	 * ...
	 * @author artemfedorov.com
	 */
	public class NonB2DActor
	{
		private var _objectType:String;
		
		private var ang:Number;
		private var dx:Number;
		private var dy:Number;
		private var _touchIndex:int = -1;
		private var _name:String;
		private var _mouseJoint:Object = null;
		private var _centerPoint:Point;
		
		/*---------------------------------------------------------------------
		* 
		* constructor
		* 
		*---------------------------------------------------------------------*/
		
		public function NonB2DActor($skin:MovieClip)
		{
			
			_costume = $skin;
			name = $skin.name
			
			_costume.addEventListener(TouchEvent.TOUCH_BEGIN, onMouseDownHandler);
			
			if(_costume.border)
			{
				var border:MovieClip = _costume.border;
				TweenMax.to(border, 25, {rotation: 360, ease:Linear.easeNone, repeat: -1});
			}
			_centerPoint = new Point(0, 0);
			animate();
		}
		
		
		/*---------------------------------------------------------------------
		* 
		* Methods
		* 
		*---------------------------------------------------------------------*/
		public function get centerPoint():Point
		{
			return _centerPoint;
		}
		
		public function set centerPoint(value:Point):void
		{
			_centerPoint = value;
		}

		public function get costume():MovieClip
		{
			return _costume;
		}

		public function set costume(value:MovieClip):void
		{
			_costume = value;
		}

		public function delay($time:Number, $callback:Function = null, $callbackParams:Array = null, $repeatCount:int = 0, $onRepeat:Function = null, $onRepeatParams:Array = null):void
		{
			TweenMax.to(_costume, $time, {onComplete:$callback, onCompleteParams:$callbackParams, repeat:$repeatCount, onRepeat:$onRepeat, onRepeatParams:$onRepeatParams});
		}
		
		private function animate():void
		{
			var time:Number;
			if(!_costume) return;
			if(!_animationState)
			{
				if(_costume.animation1) _costume.animation1.play();
				if(_costume.animation2) _costume.animation2.play();
				_animationState = true;
				time = Math.random() * 5;
				delay(time, animate);
			}
			else
			{
				if(_costume.animation1) _costume.animation1.stop();
				if(_costume.animation2) _costume.animation2.stop();
				_animationState = false;
				time = Math.random() * 5;
				delay(time, animate);
			}
		}
	
		
		public function get objectType():String
		{
			return _objectType;
		}
		
		public function set objectType(value:String):void
		{
			_objectType = value;
		}
		
		
		
		public function destroyUrgent():void
		{
			if(!costume) return;
			_costume.removeEventListener(TouchEvent.TOUCH_BEGIN, onMouseDownHandler);
			_costume.parent.removeChild(_costume);
			_costume = null;
		}
		
		public function removeListeners():void
		{
			_costume.removeEventListener(TouchEvent.TOUCH_BEGIN, onMouseDownHandler);
		}
		
		public function destroy():void
		{
			_costume.removeEventListener(TouchEvent.TOUCH_BEGIN, onMouseDownHandler);
			var time:Number = 0.2;
			GameFacade.gameView.activeItems[_touchIndex] = null;
			TweenMax.to(_costume, time, {alpha:0, onComplete:onCompleteAnimationHandler });
		}
		
		private function onCompleteAnimationHandler():void
		{
			_costume.parent.removeChild(_costume);
			_costume = null;
		}
		
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get touchIndex():int
		{
			return _touchIndex;
		}
		
		public function set touchIndex(value:int):void
		{
			_touchIndex = value;
		}
		public function get mouseJoint():Object
		{
			return _mouseJoint;
		}
		
		public function set mouseJoint(value:Object):void
		{
			_mouseJoint = value;
		}

		
		private var _animationState:Boolean;
		private var _costume:MovieClip;
		public var owner:MovieClip;
		
		
		private function getBitmapFilter():BitmapFilter 
		{
			var color:Number = 0x000000;
			var angle:Number = 45;
			var alpha:Number = 0.8;
			var blurX:Number = 8;
			var blurY:Number = 8;
			var distance:Number = 15;
			var strength:Number = 0.65;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			return new DropShadowFilter(distance,
				angle,
				color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
		}
		
		private function onMouseDownHandler(e:TouchEvent):void 
		{
			touchIndex = e.touchPointID;
			var p:Point = new Point(e.stageX, e.stageY); 
			centerPoint = costume.globalToLocal(p);
			if(GameFacade.nb2dEngine.rightCard == this) GameFacade.nb2dEngine.rightCard = null;
			if(GameFacade.nb2dEngine.leftCard == this) GameFacade.nb2dEngine.leftCard = null;
			GameFacade.gameView.activeItems[touchIndex] = this;
			trace("Touched", _touchIndex);
			GlobalDispatcher.dispatch(new ApplicationEvents(GameEventConstants.ITEM_TOUCHED, this));
			costume.parent.swapChildrenAt(costume.parent.getChildIndex(costume), costume.parent.numChildren - 1);
			costume.width += 20;
			costume.height += 20;
			costume.filters = [getBitmapFilter()];
		}
	}
}