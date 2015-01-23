package entities
{
	import configs.Config;
	import events.C;
	import events.GlobalDispatcher;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.textures.TextureAtlas;
	
	/**
	 *Класс предназначен только для создания символов на барабанах 
	 * @author fedorovartem
	 * 
	 */	
	
	public class Item extends MySpriteEntity
	{
		private var curPosI:int;
		private var curPosJ:int;
		private var _skin:int;
		private var _steps:int;
		
		private var _mustDispatchDestroyed:Boolean;
		private var _addedToDestroy:Boolean;
		
		
		
		
		public function Item($atlas:TextureAtlas, $type:String, $touchable:Boolean = true)
		{
			skin = Config.types.indexOf($type);
			super($atlas, $type, $touchable);
			Starling.juggler.add(mc);
		}
		
		
		public function play():void
		{
			if(this.isFlattened) this.unflatten();
			mc.play();
		}
		
		public function stop():void
		{
			this.flatten();
			mc.stop();
			mc.currentFrame = 0;
		}
		
		
		public function awake($atlas:TextureAtlas, $type:String, $touchable:Boolean = true):void
		{
			atlas = $atlas;
			this.touchable = $touchable;
			mc.touchable = $touchable;
			mc.swapTextures($atlas.getTextures($type), 60);
			this.addChild(mc);
			mc.x = 0;
			mc.y = 0;
			skin = Config.types.indexOf($type);
			addedToDestroy = false;
		}
		
		
		override public function setTexture($textureName:String, $atlas:TextureAtlas):void 
		{
			_skin = Config.types.indexOf($textureName);
			super.setTexture($textureName, $atlas);
			mc.x = 0;
			mc.y = 0;
			mc.width = 100;
			mc.height = 100;
		}
		
		
		public function reincarnation($atlas:TextureAtlas, $to:String):void
		{
			_skin = Config.types.indexOf($to);
			Starling.juggler.delayCall(setTexture, Config.speedRolling, [$to, $atlas]);
		}
		
		
		public function joinTo($item:Item, $destroyAfter:Boolean = false):void
		{
			var x:Number = $item.x;
			var y:Number = $item.y;
			if ($destroyAfter) 
			{
				var tween:Tween = new Tween(this, Config.speedRolling, Transitions.EASE_IN);
				tween.onComplete = destroy;
				tween.onCompleteArgs = [true];
				tween.moveTo(x, y);
				Starling.juggler.add(tween);
			}
			else 
			{
				tween = new Tween(this, Config.speedRolling, Transitions.EASE_IN);
				tween.moveTo(x, y);
				Starling.juggler.add(tween);
			}
		}

		override public function destroy($destroyMC:Boolean = false):void 
		{
			if (mustDispatchDestroyed) 
				GlobalDispatcher.dispatch(C.ALL_SYMBOLS_DESTROYED);
			super.destroy($destroyMC);
		}
		
		
		
		
		

		public function get addedToDestroy():Boolean 
		{
			return _addedToDestroy;
		}
		
		public function set addedToDestroy(value:Boolean):void 
		{
			_addedToDestroy = value;
		}
		

		public function get mustDispatchDestroyed():Boolean 
		{
			return _mustDispatchDestroyed;
		}
		
		public function set mustDispatchDestroyed(value:Boolean):void 
		{
			_mustDispatchDestroyed = value;
		}
	
		
		public function get steps():int 
		{
			return _steps;
		}
		
		public function set steps(value:int):void 
		{
			_steps = value;
		}
		
		public function get skin():int 
		{
			return _skin;
		}
		
		public function set skin(value:int):void 
		{
			_skin = value;
		}
		
		
		
		
		

	}
}