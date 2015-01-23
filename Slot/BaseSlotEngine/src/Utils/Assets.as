package
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Assets
	{
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