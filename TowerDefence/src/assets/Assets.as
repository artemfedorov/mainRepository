package assets
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Assets
	{
		//[Embed(source="/../assets/back1.png")]
		//public static const back1:Class;

		[Embed(source="/../assets/levelBackground1.png")]
		public static const levelBackground1:Class;

			
		[Embed(source="/../assets/Default-568@2x.png")]
		public static const menuBackground:Class;
		
		
		
		
		

		[Embed(source="/../assets/gunMenu.png")]
		public static const gunMenu:Class;

		[Embed(source="/../assets/fixGunButtonUp.png")]
		public static const fixGunButtonUp:Class;

		[Embed(source="/../assets/fixGunButtonDown.png")]
		public static const fixGunButtonDown:Class;
		
		[Embed(source="/../assets/sellGunButtonUp.png")]
		public static const sellGunButtonUp:Class;

		[Embed(source="/../assets/sellGunButtonDown.png")]
		public static const sellGunButtonDown:Class;
		
		[Embed(source="/../assets/startButtonUp.png")]
		public static const startButtonUp:Class;

		[Embed(source="/../assets/startButtonDown.png")]
		public static const startButtonDown:Class;

		[Embed(source="/../assets/playWaveButtonUp.png")]
		public static const playWaveButtonUp:Class;

		[Embed(source="/../assets/playWaveButtonDown.png")]
		public static const playWaveButtonDown:Class;
		
		
		
		
		
		
		
		
		
		
		
		
		
		[Embed(source="/../assets/asset.png")]
		public static const graphicsAtlas:Class;
		
		[Embed(source="/../assets/asset.xml", mimeType="application/octet-stream")]
		public static const graphicsAtlasXml:Class;
		
		public static var gameTextures:Dictionary = new Dictionary();
		public static var gameTextureAtlas:TextureAtlas;
		
		
		
		
		public static function getAtlas():TextureAtlas
		{
			if(gameTextureAtlas == null)
			{
				var texture:Texture = getTexture("graphicsAtlas");
				var xml:XML = XML(new graphicsAtlasXml());
				gameTextureAtlas = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlas;
		}
		
		
		
		public static function getTexture($name:String):Texture
		{
			if(gameTextures[$name] == undefined)
			{
				var bitmap:Bitmap = new Assets[$name]();
				gameTextures[$name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[$name];
		}
	}
}