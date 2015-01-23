package model.mechanics
{
	import events.ApplicationEvents;
	
	import superClasses.BaseClass;
	import superClasses.DynamicActor;
	import superClasses.NonB2DActor;
	
	public class SortingMech extends BaseClass implements IMechanics
	{
		public function SortingMech()
		{
			super();
		}
		
		public function collided($item1:DynamicActor, $item2:DynamicActor):void
		{
			if($item1.name == $item2.name)	
			{
				if ($item1.boxBody.GetFixtureList().IsSensor()) 
					GameFacade.b2dEngine.initDestroyObject($item2);
				if ($item2.boxBody.GetFixtureList().IsSensor()) 
					GameFacade.b2dEngine.initDestroyObject($item1);
			}
			if (GameFacade.b2dEngine.gameObjects.length == 0) delay(1, levelComplete);
		}
		public function collided2($item1:NonB2DActor, $item2:NonB2DActor):void {}
		public function touched(e:ApplicationEvents):void{}
		public function dispose():void{}
		
		public function levelComplete():void
		{
			for (var i:int = 0; i < GameFacade.b2dEngine.bascketsArr.length; i++) 
			{
				GameFacade.b2dEngine.initDestroyObject2(GameFacade.b2dEngine.bascketsArr[i]);
			} 
			GameFacade.b2dEngine.destroyAllObjects();
			delay(0.2, GameFacade.b2dEngine.createGame);
		}
	}
}