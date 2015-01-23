package model 
{
	import Utils.AssetLoader;
	import Utils.FactoryAssets;
	
	import entities.Item;
	
	import events.ApplicationEvents;
	import events.C;
	import events.GlobalDispatcher;
	
	import interfaces.BaseInterfaceView;
	
	import lines.BaseLinesView;
	
	import net.BaseAPIController;
	
	import reels.BaseReelsView;
	
	import starling.display.Sprite;
	import starling.events.Event;

	/**
	 * ...
	 * @author 
	 */
	public class BaseGame extends Sprite
	{
		public static const atlasesNames:Array = 
		[
			"ace",
			"butterfly",
			"flower",
			"flowerred",
			"jack",
			"king",
			"nine",
			"owl",
			"pantera",
			"queen",
			"staticSymbols",
			"ten",
			"wolf",
		];
		public static const path:String = "game";
		
		
		
		public function BaseGame() 
		{
			Facade.game = this;
			if (this.stage) 
				init(); 
			else 
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			GlobalDispatcher.addListener(C.LOAD_FILES_COMPLETE, onLayoutLoaded);
			FactoryAssets.loadGraphics();
		}
		
		protected function onLayoutLoaded(e:ApplicationEvents):void
		{
			Facade.apiController = new BaseAPIController();
			Facade.layout = FactoryAssets.getMovieClipByName("layout");
			
			for (var i:int = 0; i < 50; i++)
				Facade.root.poolIn(new Item(AssetLoader.assetsDics["flowerred"], "flowerred", false));
			
			var allReels:BaseReelsView = new BaseReelsView();
			this.addChild(allReels);
					
			var interfaceView:BaseInterfaceView = new BaseInterfaceView();
			this.addChild(interfaceView);
			
			var linesView:BaseLinesView = new BaseLinesView();
			this.addChild(linesView);
			
			var states:BaseStates = new BaseStates();
		}	
		
	}

}