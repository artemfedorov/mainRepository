package model
{
	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2ContactListener;
	
	public class GameContactListener extends b2ContactListener
	{
		
		public function GameContactListener()
		{
		}
		
		public override function BeginContact(contact:b2Contact):void
		{
			var obj1:* = contact.GetFixtureA().GetBody().OwnerMyself;
			var obj2:* = contact.GetFixtureB().GetBody().OwnerMyself;
			GameFacade.b2dEngine.Collided(obj1, obj2);
		}
		
		public override function EndContact(contact:b2Contact):void
		{
			
		}
		
		public override function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void
		{
			
		}
		
		public override function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void
		{
			
		}
	}
}