package reels
{
	import flash.geom.Rectangle;
	
	import reels.interfaces.IReelView;

	public class ReelsView extends BaseReelsView
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
		
		public function ReelsView()
		{
			super();
			this.clipRect = new Rectangle(0, 100, Facade.layout.lines.reelsMask.width, 3 * 100);
		}
		
		
		override protected function createReelView():IReelView
		{
			return new ReelView();
		}
	}
}