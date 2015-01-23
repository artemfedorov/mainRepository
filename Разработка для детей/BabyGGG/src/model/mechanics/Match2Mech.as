package model.mechanics
{
	import events.ApplicationEvents;
	
	import flash.media.Sound;
	
	import superClasses.BaseClass;
	import superClasses.DynamicActor;
	import superClasses.NonB2DActor;
	
	public class Match2Mech extends BaseClass implements IMechanics
	{
		public function Match2Mech()
		{
			super();
		}
		public function collided2($item1:NonB2DActor, $item2:NonB2DActor):void {}
		public function collided($item1:DynamicActor, $item2:DynamicActor):void
		{
			if($item1.name == $item2.name && $item1.touchIndex > -1 && $item2.touchIndex > -1)	
			{
					GameFacade.b2dEngine.initDestroyObject($item1);
					GameFacade.b2dEngine.initDestroyObject($item2);
			}
			if(GameFacade.b2dEngine.gameObjects.length == 0) delay(1, levelComplete);
		}
		
		public function touched(e:ApplicationEvents):void{}
		public function dispose():void{}
		
		public function levelComplete():void
		{
			GameFacade.b2dEngine.destroyAllObjects();
			delay(0.3, GameFacade.b2dEngine.createGame);
		}
				
		
		
	}
}