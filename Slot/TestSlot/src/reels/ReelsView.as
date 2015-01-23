package reels
{
	import flash.geom.Rectangle;

	public class ReelsView extends BaseReelsView
	{
		public function ReelsView()
		{
			super();
			this.clipRect = new Rectangle(0, 100, Facade.layout.lines.reelsMask.width, 3 * 100);
		}
	}
}