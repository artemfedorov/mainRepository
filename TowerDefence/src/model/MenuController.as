package model
{
	import assets.Assets;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class MenuController extends Sprite
	{
		
		private var _backImage:Image;
		private var _startButton:Button;
		
		
		
		
		public function MenuController()
		{
			create();
		}
		
		
		
		
		
		private function create():void
		{
			_backImage = new Image(Assets.getTexture("menuBackground"));
			this.addChild(_backImage);
			
			_startButton = new Button(Assets.getTexture("startButtonUp"), "", Assets.getTexture("startButtonDown"));
			_startButton.x = Facade.stage.stageWidth / 2 - _startButton.width / 2;
			_startButton.y = Facade.stage.stageHeight / 2 - _startButton.height / 2;
			this.addChild(_startButton);
			_startButton.addEventListener(Event.TRIGGERED, onStartButtonTriggered);
		}		
		
		
		
		
		
		
		private function onStartButtonTriggered(e:Event):void
		{
			var game:GameController = new GameController();
			this.addChild(Facade.game);
		}	
		
		
		
		
		
		
	}
}