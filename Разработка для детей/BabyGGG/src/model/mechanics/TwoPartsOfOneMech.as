package model.mechanics
{
	import events.ApplicationEvents;
	import events.GlobalDispatcher;
	
	import flash.display.MovieClip;
	
	import superClasses.BaseClass;
	import superClasses.DynamicActor;
	import superClasses.NonB2DActor;
	
	public class TwoPartsOfOneMech extends BaseClass implements IMechanics
	{
		public function TwoPartsOfOneMech()
		{
			super();
		}
		
		public function checkend():void
		{
			if(GameFacade.nb2dEngine.gameObjects.length == 0) delay(1, levelComplete);
		}		
		
		
		public function collided2($item1:NonB2DActor, $item2:NonB2DActor):void{}
		public function collided($item1:DynamicActor, $item2:DynamicActor):void{}
		public function touched(e:ApplicationEvents):void{}
		public function dispose():void{}
		
		public function levelComplete():void
		{
			GameFacade.nb2dEngine.destroyAllObjects();
			GameFacade.nb2dEngine.createGame();
		}
		
		
		
	}
}