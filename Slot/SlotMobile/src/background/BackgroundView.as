package background
{
	import Utils.AssetLoader;
	
	import events.ApplicationEvents;
	import events.C;
	import events.GlobalDispatcher;
	
	import model.BaseStates;
	
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;

	public class BackgroundView extends Sprite
	{
		public static var atlasesNames:Array = 
			[
				"slotBackground"
			];
		public static var path:String = "background";

		private var back:MovieClip;
		
		
		public function BackgroundView()
		{
			GlobalDispatcher.addListener(C.STATE_CHANGED, onStateChanged);
			var atlas:TextureAtlas = AssetLoader.assetsDics["slotBackground"];
			back = new MovieClip(atlas.getTextures("slotBackground"), 60);
			this.addChild(back);
		}
		
		/**
		 * Слушатель события изменения STATE из модели
		 */
		protected function onStateChanged(e:ApplicationEvents):void 
		{
			if(e.params == BaseStates.SPIN_STATE)
			{
				
			}
		}
	}
}