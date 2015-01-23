package model
{
	import Utils.AssetLoader;
	import Utils.FactoryAssets;
	
	import background.BackgroundView;
	
	import entities.Item;
	
	import events.ApplicationEvents;
	
	import interfaces.InterfaceView;
	
	import lines.LinesView;
	
	import net.APIController;
	
	import reels.ReelsView;

	public class Game extends BaseGame
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
		
		
		public function Game()
		{
			super();
		}
		
		
		override protected function onLayoutLoaded(e:ApplicationEvents):void
		{
			Facade.apiController = new APIController();
			Facade.layout = FactoryAssets.getMovieClipByName("layout");
			
			for (var i:int = 0; i < 50; i++)
				Facade.root.poolIn(new Item(AssetLoader.assetsDics["flowerred"], "flowerred", false));
			
			var back:BackgroundView = new BackgroundView();
			back.x = Facade.layout.background.x;
			back.y = Facade.layout.background.y;
			this.addChild(back);
			
			
			var allReels:ReelsView = new ReelsView();
			allReels.x = Facade.layout.reels.x;
			allReels.y = Facade.layout.reels.y - 100;
			this.addChild(allReels);
			
			var interfaceView:InterfaceView = new InterfaceView();
			interfaceView.x = Facade.layout.buttons.x;
			interfaceView.y = Facade.layout.buttons.y;
			this.addChild(interfaceView);
			
			var linesView:LinesView = new LinesView();
			linesView.x = Facade.layout.lines.x;
			linesView.y = Facade.layout.lines.y;
			this.addChild(linesView);
			
			var states:States = new States();
		}	
	}
}