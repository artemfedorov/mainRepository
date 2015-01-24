package
{
	import background.BackgroundView;
	
	import interfaces.InterfaceView;
	
	import lines.LinesView;
	
	import model.Game;
	
	import reels.ReelsView;

	public class Root extends RootClass
	{
		public function Root()
		{
			super();
			onLoadedGameAssets();
		}
		
		
		override protected function initQueue():void
		{
			addLoadQueue(LinesView.path, LinesView.atlasesNames);
			addLoadQueue(ReelsView.path, ReelsView.atlasesNames);
			addLoadQueue(InterfaceView.path, InterfaceView.atlasesNames);
			addLoadQueue(BackgroundView.path, BackgroundView.atlasesNames);
		}
		
		override protected function startGame():void 
		{
			var game:Game = new Game();
			addChild(game);
		}
	}
}