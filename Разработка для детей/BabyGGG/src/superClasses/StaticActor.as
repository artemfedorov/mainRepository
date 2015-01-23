package  superClasses
{
	import Box2D.Dynamics.b2Body;
	
	import Box2dUtils.*;
	
	import Interfaces.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	import interfaces.IGameObject;

	/**
	 * ...
	 * @author artemfedorov.com
	 */
	public class StaticActor extends Actor  implements IGameObject
	{	
		private var _boxBody:b2Body;
		private var clip:MovieClip;

		/*---------------------------------------------------------------------
		 * 
		 * constructor
		 * 
		 *---------------------------------------------------------------------*/
		
		public function StaticActor(shape:int, angle:int, mc:MovieClip, parent:DisplayObjectContainer, material:int, isSensor:Boolean = false, index:int = 0)
		{
			clip = mc;
			boxBody = Body.Create(mc, BodyType.STATIC,   Materials.material[material], shape, false, false, isSensor);
			super(boxBody, mc);
			boxBody.SetAngle(angle * Math.PI / 180);
		}
		
		/*---------------------a------------------------------------------------
		 * 
		 * Methods
		 * 
		 *---------------------------------------------------------------------*/
		
		public function get boxBody():b2Body
		{
			return _boxBody;
		}
		public function set boxBody(value:b2Body):void
		{
			_boxBody = value;
		}
		 
		//override public function updateNow():void{}
		override protected function childSpecificUpdating():void
		{
			if (_costume.y > _costume.stage.stageHeight)
			{
				//trace("WOW! OFF Stage");
			}
			super.childSpecificUpdating();
		}
	}

}