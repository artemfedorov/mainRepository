package views 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Expo;
	import com.greensock.easing.FastEase;
	import com.greensock.easing.Strong;
	
	import events.ApplicationEvents;
	import events.GlobalDispatcher;
	
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.LocalConnection;
	
	import superClasses.BaseClass;

	
	/**
	 * ...
	 * @author 
	 */
	public class InterfaceView extends BaseClass 
	{
		
		private var _skin:MovieClip;
		private var _window:MovieClip;
		private var _callBack:Function;
		
		public function InterfaceView($skin:MovieClip) 
		{
			_skin = $skin;
			super();
		}
		
		override protected function onRegister():void 
		{
			super.onRegister();
			TweenMax.to(_skin.play_btn, 1, {y: 346, ease:Strong.easeOut } );
			activateMouseEvents();
		}

		
		public function showWindow($closeSelf:Boolean = true, $callBack:Function = null, $type:String= "info", $params:Array = null):void
		{
			
			if($type == "info") _window = new infoWindow();
			_window.name = "closeWindow_btn";
			_window.mouseChildren = false;
			//if($type == "win") _window = new winWindow();
			//if($type == "extra") _window = new extraWindow();
			
			_window.alpha = 0;
			TweenMax.to(_window, 0.5, {alpha:1});
			_skin.addChild(_window);
			_window.x = GameFacade.myStage.width / 2 - 200;
			_window.y = GameFacade.myStage.height / 2 - 200;
			
			_callBack = $callBack;
			if($closeSelf) delay(3, closeWindow, [_callBack]);
		}
		
		private function closeWindow():void
		{
			TweenMax.to(_window, 0.5, {alpha:0, onComplete:actionAfterDestroyWindow});
		}		
		
		private function removeWindow():void
		{
			if(_window) _skin.removeChild(_window);
			_window = null;
		}		

		private function actionAfterDestroyWindow():void
		{
			removeWindow();
			if(_callBack != null) _callBack.call();
			GlobalDispatcher.dispatch(new ApplicationEvents(GameEventConstants.ON_CREATE_GAME));
		}		
		
		private function activateMouseEvents():void 
		{
			_skin.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			_skin.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			_skin.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
			_skin.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
		}
		
		private function deactivateMouseEvents():void 
		{
			_skin.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			_skin.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			_skin.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
			_skin.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
		}
		
		private function onMouseOverHandler(e:MouseEvent):void 
		{
			
		}
		
		private function onMouseOutHandler(e:MouseEvent):void 
		{
			
		}
		
		private function onMouseDownHandler(e:MouseEvent):void 
		{
			
		}
		
		private function onMouseUpHandler(e:MouseEvent):void 
		{
			switch (e.target.name)
			{
				case "play_btn":
					_skin.gotoAndStop("map");					
					break;
				
				case "constructGame":
				
				case "sortingGame":
				case "matchGame":
				case "bubblesGame":
				case "autoGame":
					_skin.gotoAndStop("game");
					GameFacade.gameModel.setGameType(e.target.name);
					GameFacade.gameView.createGame();
					GameFacade.gameView.skin.gotoAndStop("base");
					GameFacade.b2dEngine.createGame();
					break;
				
				case "piecesGame":
					_skin.gotoAndStop("game");
					GameFacade.gameModel.setGameType(e.target.name);
					GameFacade.gameView.createGame();
					GameFacade.gameView.skin.gotoAndStop("pieces");
					GameFacade.nb2dEngine.createGame();
					break ;
				
				case "menu":
					removeWindow();
					GameFacade.nb2dEngine.destroyAllObjects();  	
					GameFacade.b2dEngine.destroyAllObjects();  	
					delay(0.2, gotoMenu);
					break ;
			 	
			 	case "closeWindow_btn":
		 			closeWindow();
					break;

				case "exit":
					NativeApplication.nativeApplication.exit();
					break;
				
			}
		}
		
		private function gotoMenu():void
		{
			_skin.gotoAndStop("map"); 
		}
		
	}

}