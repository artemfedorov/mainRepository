package
{
	import background.BackgroundView;
	
	import interfaces.InterfaceView;
	
	import lines.LinesView;
	
	import model.Game;

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
			addLoadQueue(Game.path, Game.atlasesNames);
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