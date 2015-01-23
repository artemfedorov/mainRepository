package 
{
	import com.greensock.easing.FastEase;
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import model.GameModel;
	
	import views.GameView;
	
	/**
	 * ...
	 * @author 
	 * 
	 */
	
	[SWF(width="1280", height="800", framerate="31")]
	
	public class BabyGGG extends Sprite 
	{
		
		public function BabyGGG():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			GameFacade.myStage = stage;
			GameFacade.skin = new gameScreen();
			GameFacade.skin.alpha = 0;
			GameFacade.myStage.addChild(GameFacade.skin);
			TweenMax.to(GameFacade.skin, 1, {alpha: 1, onComplete:onCompleteHandler } );
		}
		
		private function onCompleteHandler():void 
		{
			GameFacade.gameModel = new GameModel();
		}
	}
}