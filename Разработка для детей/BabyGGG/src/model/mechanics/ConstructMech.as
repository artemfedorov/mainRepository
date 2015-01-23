package model.mechanics
{
	import events.ApplicationEvents;
	import events.GlobalDispatcher;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import superClasses.BaseClass;
	import superClasses.DynamicActor;
	import superClasses.NonB2DActor;
	
	public class ConstructMech extends BaseClass implements IMechanics
	{
		public function ConstructMech()
		{
			super();
			GlobalDispatcher.addListener(GameEventConstants.ITEM_DETOUCHED, detouched);
			GlobalDispatcher.addListener(GameEventConstants.ITEM_TOUCHED, touched);
		}
		
		private function detouched(e:ApplicationEvents):void
		{
			for (var i:int = 0; i < GameFacade.b2dEngine.gameObjects.length; i++) 
			{
				var costume:MovieClip = GameFacade.b2dEngine.gameObjects[i].costume;
				for (var j:int = 0; j < 9; j++) 
				{
					if(costume.item.getChildByName("p" + j))
					{
						var mc:MovieClip = costume.item.getChildByName("p" + j) as MovieClip;
						var p:Point = new Point(mc.x, mc.y);
						var p1:Point = new Point();
						p1 = costume.item.localToGlobal(p);
						if(!GameFacade.b2dEngine.buildings.hitTestPoint(p1.x, p1.y, true)) 
							return;
					}
				}
			}
			GameFacade.b2dEngine.buildings.parent.removeChild(GameFacade.b2dEngine.buildings);
			GameFacade.b2dEngine.buildings = null;
			GameFacade.interfaceView.showWindow(false, levelComplete);
		}
		
		public function collided2($item1:NonB2DActor, $item2:NonB2DActor):void {}
		public function collided($item1:DynamicActor, $item2:DynamicActor):void	{}
		public function dispose():void{}
		
		public function touched(e:ApplicationEvents):void
		{
			
		}
		
		
		public function levelComplete():void
		{
			GlobalDispatcher.removeListener(GameEventConstants.ITEM_DETOUCHED);
			GlobalDispatcher.removeListener(GameEventConstants.ITEM_TOUCHED);
			GameFacade.b2dEngine.destroyAllObjects();
			delay(0.2, GameFacade.b2dEngine.createGame);
		}
		
		
		
	}
}