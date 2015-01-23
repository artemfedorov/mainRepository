package  superClasses
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.b2Body;
	
	import Box2dUtils.*;
	
	import utils.Utilities;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import events.ApplicationEvents;
	import events.GlobalDispatcher;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	import model.B2DController;
	import model.PhysiVals;


	/**
	 * ...
	 * @author artemfedorov.com
	 */
	public class DynamicActor extends Actor
	{
		private var _boxBody:b2Body;
		private var _objectType:String;
		
		private var ang:Number;
		private var dx:Number;
		private var dy:Number;
		private var _touchIndex:int = -1;

		private var _targetPoint:b2Vec2;
		
		
		private var _name:String;

		/*---------------------------------------------------------------------
		 * 
		 * constructor
		 * 
		 *---------------------------------------------------------------------*/
		
		public function DynamicActor(type:int, shape:int, angle:int, mc:MovieClip, parent:MovieClip, material:int, sensor:Boolean = false, index:int = 0)
		{
			_targetPoint = new b2Vec2();
			_costume = mc;
			name = mc.name
			if(type == BodyType.DYNAMIC)
			_costume.addEventListener(TouchEvent.TOUCH_BEGIN, onMouseDownHandler);
			
			boxBody = Body.Create(mc, type,  Materials.material[material], shape, false, false, sensor, 0, 0, true, 0, 0, index);
			boxBody.SetAngle(angle * Math.PI / 180);

			super(boxBody, mc);
			boxBody.allowGravity = 0;
			boxBody.SetFixedRotation(true);
			boxBody.SetAngle(angle * Math.PI / 180);
			boxBody.SetLinearDamping(8);
			boxBody.OwnerMyself = this;
			
			if(_costume.border)
			{
				var border:MovieClip = _costume.border;
				TweenMax.to(border, 25, {rotation: 360, ease:Linear.easeNone, repeat: -1});
			}
			_centerPoint = new Point();
			animate();
		}
		 
		
		/*---------------------------------------------------------------------
		 * 
		 * Methods
		 * 
		 *---------------------------------------------------------------------*/
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

		public function get centerPoint():Point
		{
			return _centerPoint;
		}

		public function set centerPoint(value:Point):void
		{
			_centerPoint = value;
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
			GameFacade.myStage.removeEventListener(Event.ENTER_FRAME, updateNow);
			GameFacade.b2dEngine.destroyObject(this);
			if(!costume) return;
			_costume.removeEventListener(TouchEvent.TOUCH_BEGIN, onMouseDownHandler);
			onCompleteAnimationHandler();
		}
		
		
		override public function destroy():void
		{
			_costume.removeEventListener(TouchEvent.TOUCH_BEGIN, onMouseDownHandler);
			GameFacade.b2dEngine.destroyObject(this);
			GameFacade.myStage.removeEventListener(Event.ENTER_FRAME, updateNow);
			var time:Number = 0.2;
			GameFacade.gameView.activeItems[_touchIndex] = null;
			TweenMax.to(_costume, time, {alpha:0, onComplete:onCompleteAnimationHandler });
		}
		
		private function onCompleteAnimationHandler():void
		{
			_costume.parent.removeChild(_costume);
			_costume = null;
			boxBody = null;
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

		
		private var _centerPoint:Point;
		private var _animationState:Boolean;
		public var mouseJoint:b2MouseJoint;
		
		private function onMouseDownHandler(e:TouchEvent):void 
		{
			if(mouseJoint) return;
			touchIndex = e.touchPointID;
			_centerPoint.x = e.localX;
			_centerPoint.y = e.localY;
			GameFacade.gameView.activeItems[touchIndex] = this;
			trace("Touched", _touchIndex);
			GlobalDispatcher.dispatch(new ApplicationEvents(GameEventConstants.ITEM_TOUCHED, this));
			
			var mouse_joint:b2MouseJointDef = new b2MouseJointDef;
			mouse_joint.bodyA = PhysiVals.world.GetGroundBody();
			mouse_joint.bodyB = boxBody;
			mouse_joint.target.Set(e.stageX / PhysiVals.RATIO, e.stageY /PhysiVals.RATIO);
			mouse_joint.maxForce = 1000000;
			mouse_joint.frequencyHz = 200;
			mouseJoint = PhysiVals.world.CreateJoint(mouse_joint) as b2MouseJoint;
		}
		
		
		
		public function get boxBody():b2Body
		{
			return _boxBody;
		}
		public function set boxBody(value:b2Body):void
		{
			_boxBody = value;
		}
		override protected function childSpecificUpdating():void
		{
			if(GameFacade.gameModel.currentGameType == "construct")
			{
				if(boxBody.GetLinearVelocity().Length() < 0.5) boxBody.allowGravity = 1;
				else boxBody.allowGravity = 7;
			}
			/*if(GameFacade.gameModel.currentGameType == "construct")
			if (_costume.stage && _costume.y < -100)
			{
				destroy();
			}*/
			
			
			super.childSpecificUpdating();
			
		}
	}

}