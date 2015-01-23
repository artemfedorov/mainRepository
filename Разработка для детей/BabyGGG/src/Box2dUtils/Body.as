package Box2dUtils
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Dynamics.Joints.*;
	
	import flash.display.*;
	
	import model.PhysiVals;

	use namespace b2internal;

	import utils.Utilities;
	
	public class Body
	{	
		public static function Create
		(
			clip:MovieClip,
			bodyType:int, 
			material:Array, 
			geomType:int,
			
			bullet:Boolean = false,
			fixedRotation:Boolean = false, 
			isSensor:Boolean = false,
			height:Number = 0,
			width:Number = 0,
			allowSleep:Boolean = true,
			linearDamping:Number = 0.0, 
			angularDamping:Number = 0.0,
			groupIndex:int = 0,
			inertiaScale:Number = 1.0
			
		):b2Body
		{		
			//==================================================
			
			//==================================================

			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = bodyType;
			bodyDef.position.Set(clip.x / PhysiVals.RATIO, clip.y / PhysiVals.RATIO);
			var rotation:Number = clip.rotation;
			clip.rotation = 0;
			bodyDef.userData = clip;
			bodyDef.fixedRotation = fixedRotation;
			bodyDef.bullet = bullet;
			bodyDef.allowSleep = allowSleep;
			bodyDef.linearDamping = linearDamping;
			bodyDef.angularDamping = angularDamping;
			bodyDef.inertiaScale = inertiaScale;
			
			var body:b2Body = PhysiVals.world.CreateBody(bodyDef);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.userData = material[Materials.MATERIAL];
			
			if (bodyType == BodyType.DYNAMIC) fixtureDef.density = material[Materials.DENSITY];
			else fixtureDef.density = 0.0;
			fixtureDef.friction = material[Materials.FRICTION];
			fixtureDef.restitution = material[Materials.RESTITUTION];
			fixtureDef.isSensor = isSensor;
			fixtureDef.filter.groupIndex = groupIndex;
			
			var myHeight:Number;
			var myWidth:Number;
			
			
			if(height > 0 && width > 0)
			{
				myHeight = height;
				myWidth = width;
			}
			else
			{
				myHeight = clip.height;
				myWidth = clip.width;
			}
			
			switch(geomType) 
			{
				case GeomType.POLYGON:

				var polygonShape:b2PolygonShape = new b2PolygonShape();
							
				polygonShape.SetAsBox(myWidth / PhysiVals.RATIO / 2, myHeight / PhysiVals.RATIO / 2);
											   
				fixtureDef.shape = polygonShape;
				body.CreateFixture(fixtureDef);
				break;
					
				case GeomType.CIRCLE:
				var circleShape:b2Shape = new b2CircleShape(myHeight / PhysiVals.RATIO / 2);
				fixtureDef.shape = circleShape;
				body.CreateFixture(fixtureDef);
				break;
				
				case GeomType.VERTEXES:
					var sd1:b2BodyDef = new b2BodyDef();
					var polyDef:b2PolygonShape = new b2PolygonShape();
					polyDef.SetAsArray([
						new b2Vec2(101 / PhysiVals.RATIO, 14 / PhysiVals.RATIO),
						new b2Vec2(200/ PhysiVals.RATIO, 120 / PhysiVals.RATIO),
						new b2Vec2(-3 / PhysiVals.RATIO, 120 / PhysiVals.RATIO)
					]);
					fixtureDef.shape = polyDef;
					body.CreateFixture(fixtureDef);
				break;
				
			}
			body.SetAngle(rotation * (Math.PI / 180));
			//clip.rotation = bodyDef.angle /180*Math.PI;
			return body;
		}
		
		
		public static function Destroy(body:b2Body):void 
		{
			PhysiVals.world.DestroyBody(body);
		}
	}
}