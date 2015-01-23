package lines
{
	import Utils.AssetLoader;
	
	import starling.events.Event;
	

	public class LinesView extends BaseLinesView
	{
		public static var atlasesNames:Array = 
			[
				"lines",
				"borders",
				"boxes"
			];
		public static var path:String = "lines";

		
		public function LinesView()
		{
			super();
		}
		
		override protected function init(e:starling.events.Event = null):void
		{
			super.init(e);
			showLines();
		}
		
		override protected function createLineInstance($name:String):BaseLineView
		{
			return new LineView(AssetLoader.assetsDics["lines"], $name, false);
		}
	}
}