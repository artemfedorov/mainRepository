package enemies
{
	import assets.Assets;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.geom.Point;
	
	import starling.display.MovieClip;
	import starling.display.Sprite;

	
	
	
	
	
	public class Enemy extends Sprite
	{
		
		
		
		
		private var _life:int;
		
		private var _skin:MovieClip;
		
		private var _currentWp:int = 1;
		
		private var _type:int;
		
		private var _setting:Object;
		
		
		
		private var _completeCount:int;
		
		
		
		
		
		
		public function Enemy($type:int)
		{
			_type = $type;
			_setting = Config["enemy" + _type];
			init();
		}

		
		
		

		private function init():void
		{
			_life = 100;
			_skin = new MovieClip(Assets.getAtlas().getTextures("enemy" + _type));
			_skin.x -= _skin.width / 2;
			_skin.y -= _skin.height / 2;
			this.addChild(_skin);
			this.x = Facade.wps[0].x;
			this.y = Facade.wps[0].y;
			
			moveToWayPoint(Facade.wps[_currentWp]);
		}
		
		
		
		
		
		
		public function getDamage($value:int):void
		{
			if(!_skin) return;
			life -= $value;
			if(life <= 0) destroy();
		}
		
		
		
		
		
		
		
		private function destroy():void
		{
			TweenMax.killTweensOf(this);
			_skin.parent.removeChild(_skin, true);
			_skin = null;
			Facade.game.destroyMe(this, true);
		}		
		
		
		
		
		
		
		
		protected function moveToWayPoint($wp:Object):void
		{
			var distance:Number = Utils.distanceBetweenTwoPoints(this.x, this.y, $wp.x, $wp.y);
			var speed:Number = distance / _setting.speed;
			TweenMax.to(this, speed, {x:$wp.x, ease:Linear.easeNone, onComplete:onCompleteTweening});	
			TweenMax.to(this, speed, {y:$wp.y, ease:Linear.easeNone, onComplete:onCompleteTweening});	
		}
		
		
		

		
		
		private function onCompleteTweening():void
		{
			_completeCount++;
			
			if(_completeCount == 2)
			{
				if(_currentWp == -1)
				{
					//Facade.game.removeMe(this);
					return;
				}
				if((_currentWp + 1) < Facade.wps.length) moveToWayPoint(Facade.wps[++_currentWp]);
				else 
				{
					_currentWp = 0;
					moveToWayPoint(Facade.wps[_currentWp]);
				}
				_completeCount = 0;
			}
		}
		
		
	
		
		
		
		
		
		public function get life():int
		{
			return _life;
		}
		
		
		
		
		
		public function set life(value:int):void
		{
			_life = value;
		}
		

		
		
	}
}