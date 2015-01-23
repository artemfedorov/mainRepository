package entities 
{
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author 
	 */
	public class MyButton extends Sprite 
	{
		static public const UP_STATE:String = "upState";
		static public const DOWN_STATE:String = "downState";
		static public const OVER_STATE:String = "overState";
		static public const DISABLE_STATE:String = "disableState"
		static public const ENABLE_STATE:String = "enableState";
		static public const OUT_STATE:String = "outState";
		
		private var states:Vector.<Texture>;
		private var mc:MovieClip;
		private var _currentState:String;
		
		private var _isDown:Boolean;
		
		private var _onUpState:Function;
		private var _onDownState:Function;
		private var _onOverState:Function;
		private var _onDisableState:Function;
		private var _onOutState:Function;
		
		public function MyButton(upState:Texture, downState:Texture, overState:Texture = null, outState:Texture = null, disableState:Texture = null) 
		{
			super();
			states = new Vector.<Texture>;
			states.push(upState);
			states.push(downState);
			states.push(overState);
			states.push(outState);
			states.push(disableState);
			mc = new MovieClip(states, 12);
			mc.useHandCursor = true;
			mc.stop();
			mc.currentFrame = 1;
			addChild(mc);		
			touchOn();
		}
		
		
		private function touchOn():void
		{
			mc.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function touchOff():void
		{
			mc.removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		
		private function onTouch(e:TouchEvent):void 
		{
			if(name == "start_btn") 
				trace("ASD");
			var touch:Touch = e.getTouch(mc);
			if (!touch) 
			{
				switchState(OUT_STATE);
				return;
			}
			var phase:String = touch.phase;
			
			if (phase == TouchPhase.BEGAN) 
				switchState(DOWN_STATE);
			else
			if (phase == TouchPhase.ENDED) 
				switchState(UP_STATE);
			else
			if (phase == TouchPhase.HOVER) 
			{
				switchState(OVER_STATE);
			}
		}
		
		
		public function switchState(state:String):void
		{
			switch (state)
			{
				case UP_STATE:
					mc.useHandCursor = true;
					mc.currentFrame = 0;
					if(onUpState != null) onUpState(this);
     
				break;
				case DOWN_STATE:
					isDown = true;
					mc.useHandCursor = true;
					mc.currentFrame = 1;
					if(onDownState != null)	onDownState(this);
				break;
				case OVER_STATE:
					if (!states[2]) return;
					mc.useHandCursor = true;
					mc.currentFrame = 2;
					if(onOverState != null) onOverState(this);
					isDown = false;
				break;
				case OUT_STATE:
					if (!states[3]) return;
					mc.currentFrame = 3;
					mc.useHandCursor = true;
					if(onOutState != null) onOutState(this);
					isDown = false;
				break;
				case DISABLE_STATE:
				if (!states[4]) return;
					mc.useHandCursor = false;
					mc.currentFrame = 4;
					touchOff();
					if(onDisableState != null) onDisableState(this);
					isDown = false;
				break;
				case ENABLE_STATE:
					touchOn();
					mc.useHandCursor = true;
					mc.currentFrame = 0;
					break;
			}
			currentState = state;
		}
		
		
		
		public function get currentState():String 
		{
			return _currentState;
		}
		
		public function set currentState(value:String):void 
		{
			_currentState = value;
			if(name == "start_btn") 
				trace("ASD");
		}
		
		public function get onUpState():Function 
		{
			return _onUpState;
		}
		
		public function set onUpState(value:Function):void 
		{
			_onUpState = value;
		}
		
		public function get onDownState():Function 
		{
			return _onDownState;
		}
		
		public function set onDownState(value:Function):void 
		{
			_onDownState = value;
		}
		
		public function get onOverState():Function 
		{
			return _onOverState;
		}
		
		public function set onOverState(value:Function):void 
		{
			_onOverState = value;
		}
		
		public function get onDisableState():Function 
		{
			return _onDisableState;
		}
		
		public function set onDisableState(value:Function):void 
		{
			_onDisableState = value;
		}
		
		public function get onOutState():Function 
		{
			return _onOutState;
		}
		
		public function set onOutState(value:Function):void 
		{
			_onOutState = value;
		}
		
		public function get isDown():Boolean
		{
			return _isDown;
		}
		
		public function set isDown(value:Boolean):void
		{
			_isDown = value;
		}

		
	}

}