package Box2dUtils
{
	import Box2D.Dynamics.b2Body;
	
	public class BodyType
	{
		public static const STATIC:int = b2Body.b2_staticBody;
		public static const KINEMATIC:int = b2Body.b2_kinematicBody;
		public static const DYNAMIC:int = b2Body.b2_dynamicBody;
	}
}