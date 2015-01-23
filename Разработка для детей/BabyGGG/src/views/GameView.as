package views
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	
	import events.ApplicationEvents;
	import events.GlobalDispatcher;
	
	import flash.display.MovieClip;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import model.PhysiVals;
	
	import superClasses.BaseClass;
	import superClasses.DynamicActor;
	
	import utils.Utilities;
	
	public class GameView extends BaseClass
	{
		
		private var _skin:MovieClip;
		
		private var _activeItems:Array = [];
		private var _multiplier:Number = 1000;
		
		
		public function GameView()
		{
			super();
		}
		
		public function get multiplier():Number
		{
			return _multiplier;
		}

		public function set multiplier(value:Number):void
		{
			_multiplier = value;
		}

		public function createGame():void
		{
			_skin = GameFacade.skin.getChildByName("game") as MovieClip;
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			_skin.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove); 
			_skin.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd); 
			_skin.removeEventListener(TouchEvent.TOUCH_ROLL_OUT, onTouchEnd); 
			
			_skin.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove); 
			_skin.addEventListener(TouchEvent.TOUCH_END, onTouchEnd); 
			_skin.addEventListener(TouchEvent.TOUCH_ROLL_OUT, onTouchEnd); 
		}
		
		
		
		public function get skin():MovieClip
		{
			return _skin;
		}

		public function set skin(value:MovieClip):void
		{
			_skin = value;
		}

		public function get activeItems():Array
		{
			return _activeItems;
		}

		public function set activeItems(value:Array):void 
		{
			_activeItems = value;
		}

		
		protected function onTouchEnd(event:TouchEvent):void
		{
			if(!activeItems[event.touchPointID]) return;
			if(activeItems[event.touchPointID].mouseJoint)
			{
				GlobalDispatcher.dispatch(new ApplicationEvents(GameEventConstants.ITEM_DETOUCHED, activeItems[event.touchPointID]));
				PhysiVals.world.DestroyJoint(activeItems[event.touchPointID].mouseJoint);
				activeItems[event.touchPointID].mouseJoint = null;
				activeItems[event.touchPointID].touchIndex = -1;
				activeItems[event.touchPointID] = null;
			}
			else
			{
				GlobalDispatcher.dispatch(new ApplicationEvents(GameEventConstants.ITEM_DETOUCHED, activeItems[event.touchPointID]));
				activeItems[event.touchPointID].costume.filters = [];
				activeItems[event.touchPointID].costume.width -= 20;
				activeItems[event.touchPointID].costume.height -= 20;
				activeItems[event.touchPointID].touchIndex = -1;
				activeItems[event.touchPointID] = null;
			}
			trace("END", event.touchPointID);
			
		}
		
		protected function onTouchMove(event:TouchEvent):void
		{
			if(!activeItems[event.touchPointID]) return;
			
			if (activeItems[event.touchPointID].mouseJoint)
			{
				var mouseXWorldPhys:Number = event.stageX / PhysiVals.RATIO;
				var mouseYWorldPhys:Number = event.stageY / PhysiVals.RATIO;
				var p2:b2Vec2 = new b2Vec2(mouseXWorldPhys, mouseYWorldPhys);
				activeItems[event.touchPointID].mouseJoint.SetTarget(p2);
				
				if(GameFacade.gameModel.currentGameType == "construct")
					if((activeItems[event.touchPointID].mouseJoint as b2MouseJoint).GetReactionForce( 1/ 30).Length() > 10) (activeItems[event.touchPointID].mouseJoint as b2MouseJoint).SetMaxForce(10000);
			}
			else
			{
				activeItems[event.touchPointID].costume.x = event.stageX - activeItems[event.touchPointID].centerPoint.x;
				activeItems[event.touchPointID].costume.y = event.stageY - activeItems[event.touchPointID].centerPoint.y;
			}
		}
		
		protected function onTouchBegin(event:TouchEvent):void
		{
			
		}
	}
}