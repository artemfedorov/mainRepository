package  superClasses
{

	import Box2D.Dynamics.b2Body;
	import Box2D.Common.Math.*;
	import flash.events.Event;

	import model.PhysiVals;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	
	import model.PhysiVals;

	/**
	 * ...
	 * @author artemfedorov.com
	 */
	public class Actor extends EventDispatcher
	{
		/**
		* properties
		*/
		protected var _body:b2Body;
		protected var _costume:MovieClip;

		/*---------------------------------------------------------------------
		 * 
		 * constructor
		 * 
		 *---------------------------------------------------------------------*/
		
		public function Actor(myBody:b2Body, myCostume:MovieClip) 
		{
			_body = myBody;
			_costume = myCostume;
			GameFacade.myStage.addEventListener(Event.ENTER_FRAME, updateNow);
		}
		
		/*---------------------------------------------------------------------
		 * 
		 * Methods
		 * 
		 *---------------------------------------------------------------------*/
		
		
		public function get costume():MovieClip
		{
			return _costume;
		}

		public function set costume(value:MovieClip):void
		{
			_costume = value;
		}
		
		public function setDamaged(damage:int):void{}

		public function updateNow(e:Event):void
		{
			updateMyLook();
			childSpecificUpdating();
		}
		public function collisionWith(body:b2Body):void
		{
			//This function does nothing
			//I expected it to called by my children
		}
		
		protected function childSpecificUpdating():void 
		{
			//This function does nothing
			//I expected it to called by my children
		}
		
		public function destroy():void
		{
			if(_costume)
			{
				_costume.parent.removeChild(_costume);
				_costume = null;
			}
			PhysiVals.world.DestroyBody(_body);
			_body = null;
		}
		
		private function updateMyLook():void 
		{
			if (!_costume) return;
			_costume.x = _body.GetPosition().x * PhysiVals.RATIO;
			_costume.y = _body.GetPosition().y * PhysiVals.RATIO;
			_costume.rotation = _body.GetAngle() * 180 / Math.PI % 360;
			
		}
		
	}
}
