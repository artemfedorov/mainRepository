package Utils
{
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	/**
	 * ...
	 * @author 
	 */
	public class AssetLoader 
	{		
		private static var assets:AssetManager;
		private static var assetsNames:Array;
		public static var assetsDics:Dictionary = new Dictionary();
		private static var callback:Function;
		
		private static var currentIndex:int;
		static private var _path:String;
		
		
		
		
		public static function loadAsset($path:String, $assetNames:Array, $callback:Function):void 
		{
			_path = $path;
			assetsNames = $assetNames;
			currentIndex = 0;
			callback = $callback;
			load();
		}
		
		
		private static function load():void
		{
			assets = new AssetManager();
			assets.enqueue(_path + "/" + assetsNames[currentIndex] + ".xml", _path + "/" + assetsNames[currentIndex] + ".png");
			assets.loadQueue(
			function(ratio:Number):void
			{
				if (ratio == 1)
				{
					textureComplete();
				}
			});
		}
		
		
		private static function textureComplete():void
		{
			var texture:Texture = assets.getTexture(assetsNames[currentIndex]);
			var t:TextureAtlas = assets.getTextureAtlas(assetsNames[currentIndex]);
			trace("Loaded asset: ", assetsNames[currentIndex]);
			
			assetsDics[assetsNames[currentIndex]] = t;
			if (currentIndex + 1 < assetsNames.length) 
			{
				currentIndex++;
				load();
				return;
			}
			callback();
		}
		
		
		
	}

}