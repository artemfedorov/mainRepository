package bullets
{
	import assets.Assets;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import enemies.Enemy;
	
	import heroes.Gun;
	
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	
	
	
	public class Bullet extends Sprite
	{
		
		
		
		private var _lethalForce:int;
		
		private var _damage:int;
		
		private var _type:int;
		
		private var _owner:Gun;
		
		private var _target:Enemy;
		
		private var _targetX:Number;
		
		private var _targetY:Number;
		
		private var _skin:MovieClip;
		
		private var _speed:Number = 1000;
		
		private var _distanceDestroy:Number;
		
		
		
		
		
		
		public function Bullet($type:int, $owner:Gun, $target:Enemy, $lethalForce:int)
		{
			super();
			_lethalForce = $lethalForce;
			_type = $type;
			_owner = $owner;
			_target = $target;
			this.x = _owner.x + _owner.width / 2;
			this.y = _owner.y;
			_targetX = _target.x;
			_targetY = _target.y;
			if(stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		
		
		
		
		private function init(e:Event = null):void
		{
			_skin = new MovieClip(Assets.getAtlas().getTextures("bullet"));
			this.addChild(_skin);
			
			_distanceDestroy = this.width * 2;
			
			var distance:Number = Utils.distanceBetweenTwoPoints(this.x, this.y, _target.x, _target.y);
			
			var speed:Number = distance / _speed;
			
			TweenMax.to(this, speed, {x: _targetX, ease:Linear.easeNone, onUpdate:update, onComplete:destroy});
			TweenMax.to(this, speed, {y: _targetY, ease:Linear.easeNone});
		}
		
		
		
		
		
		
		private function update():void
		{
			var distance:Number = Utils.distanceBetweenTwoPoints(this.x, this.y, _target.x, _target.y);
			if(distance <= _distanceDestroy)
			{
				trace("boom");
				destroy();
			}
		}
		
		
		
		
		
		private function destroy():void
		{
			_target.getDamage(_lethalForce);
			TweenMax.killTweensOf(this);
			this.removeEventListeners();
			_skin.removeFromParent(true);
		}
		
		
		
		
		
	}
	
	
}