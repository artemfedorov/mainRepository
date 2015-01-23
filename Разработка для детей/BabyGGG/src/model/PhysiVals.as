package  model
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	
	import flash.display.MovieClip;

	/**
	 * ...
	 * @author artemfedorov.com
	 */
	public class PhysiVals 
	{
		/**
		* properties
		*/
		public static var itemsList:Vector.<MovieClip> = new Vector.<MovieClip>;
		
		public static var cl:Vector.<b2Body>;
		
		public static const RATIO:Number = 30;
		
		public static var _world:b2World;
		

		
		/*---------------------------------------------------------------------
		 * 
		 * constructor
		 * 
		 *---------------------------------------------------------------------*/
		
		public function PhysiVals() 
		{
			
		}
		
		static public function get world():b2World 
		{
			return _world;
		}
		
		static public function set world(value:b2World):void 
		{
			_world = value;
		}
		
	}

}