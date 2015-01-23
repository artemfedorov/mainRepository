package entities
{
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;

	public class MySpriteEntity extends Sprite
	{
		
		private var _mc:MovieClip;
		private var _atlas:TextureAtlas;
		
		
		
		
		public function MySpriteEntity($atlas:TextureAtlas, $type:String, $touchable:Boolean = true)
		{
			super();
			_atlas = $atlas;
			this.touchable = $touchable;
			_mc = new MovieClip($atlas.getTextures($type), 60);
			_mc.touchable = $touchable;
			this.addChild(_mc);
			_mc.currentFrame = 0;
			_mc.x = 0;
			_mc.y = 0;
		}
		
	
		
		public function setPosition($x:Number, $y:Number):void
		{
			this.x = $x;
			this.y = $y;
		}

		
	
		public function setTexture($textureName:String, $atlas:TextureAtlas):void 
		{
			_mc.swapTextures($atlas.getTextures($textureName), 60);
		}
		
		
		
		
		public function destroy($destroyMC:Boolean = false):void 
		{
			if ($destroyMC) 
			{
				mc.parent.removeChild(mc);
				mc = null;
			}
			Starling.juggler.remove(_mc);
			this.parent.removeChild(this);
		}
		
		
		public function get mc():MovieClip 
		{
			return _mc;
		}
		
		public function set mc(value:MovieClip):void 
		{
			_mc = value;
		}
		
		public function get atlas():TextureAtlas 
		{
			return _atlas;
		}
		
		public function set atlas(value:TextureAtlas):void 
		{
			_atlas = value;
		}

	}
}