package model.mechanics
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
	
	import events.ApplicationEvents;
	import events.GlobalDispatcher;
	
	import flash.display.MovieClip;
	import flash.media.Sound;
	
	import superClasses.BaseClass;
	import superClasses.DynamicActor;
	import superClasses.NonB2DActor;
	
	public class BubbleMech extends BaseClass implements IMechanics
	{
		public function BubbleMech()
		{
			super();
			GlobalDispatcher.addListener(GameEventConstants.ITEM_TOUCHED, touched);
		}
		
		public function collided($item1:DynamicActor, $item2:DynamicActor):void	{}
		
		public function touched(e:ApplicationEvents):void
		{
			var s:Sound = new bubblePick();
			s.play();
			//buildDrops((e.params as DynamicActor).costume);
			GameFacade.b2dEngine.initDestroyObject2(e.params as DynamicActor);
			
			if(GameFacade.b2dEngine.gameObjects.length == 0) delay(1, levelComplete);
		}
		
		
		public function collided2($item1:NonB2DActor, $item2:NonB2DActor):void {}
		public function dispose():void
		{
			GlobalDispatcher.removeListener(GameEventConstants.ITEM_TOUCHED);
		}
		
		public function levelComplete():void
		{
			GameFacade.b2dEngine.destroyAllObjects();
			delay(0.2, GameFacade.b2dEngine.createGame);
		}
		
		
		
		
		
	}
}