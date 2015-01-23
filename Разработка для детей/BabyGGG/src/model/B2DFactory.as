package model 
{
	import Box2D.Collision.b2Bound;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	
	import Box2dUtils.BodyType;
	import Box2dUtils.GeomType;
	import Box2dUtils.Materials;
	
	import flash.display.MovieClip;
	
	import superClasses.DynamicActor;
	import superClasses.NonB2DActor;

	/**
	 * ...
	 * @author 
	 */
	public class B2DFactory 
	{		
		public static function actor($costume:MovieClip):DynamicActor
		{
			return new DynamicActor(BodyType.DYNAMIC, GeomType.CIRCLE, $costume.rotation, $costume, $costume.parent as MovieClip, Materials.STONE, false, 0);
		}
		
		public static function nonB2DActor($costume:MovieClip):NonB2DActor
		{
			return new NonB2DActor($costume);
		}

		public static function actorSensor($costume:MovieClip):DynamicActor
		{
			return new DynamicActor(BodyType.STATIC, GeomType.CIRCLE, $costume.rotation, $costume, $costume.parent as MovieClip, Materials.STONE, true, 0);
		}
		
		public static function actorBox($costume:MovieClip):DynamicActor
		{
			return new DynamicActor(BodyType.DYNAMIC, GeomType.POLYGON, $costume.rotation, $costume, $costume.parent as MovieClip, Materials.METAL, false, 0);
		}
		
		public static function actorTriangle($costume:MovieClip):DynamicActor
		{
			return new DynamicActor(BodyType.DYNAMIC, GeomType.VERTEXES, $costume.rotation, $costume, $costume.parent as MovieClip, Materials.METAL, false, 0);
		}

		public static function wall($costume:MovieClip):DynamicActor
		{
			return new DynamicActor(BodyType.STATIC, GeomType.POLYGON, $costume.rotation, $costume, $costume.parent as MovieClip, Materials.METAL, false, 0);
		}
	}

}