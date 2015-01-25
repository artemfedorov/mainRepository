package reels
{
	public class ReelView extends BaseReelView
	{
		public function ReelView()
		{
			super();
		}
		
		
		override protected function animateSymbolsOnStop():void
		{
			trace(_reelNumber);
		}
	}
}