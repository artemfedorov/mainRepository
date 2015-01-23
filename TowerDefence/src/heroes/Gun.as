package heroes
{
	import assets.Assets;
	
	import bullets.Bullet;
	
	import com.greensock.TweenMax;
	
	import enemies.Enemy;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	
	
	
	
	
	public class Gun extends Sprite
	{
		
		
		private const IDLE:String = "idle";
		private const LOOK:String = "look";
		private const ATTACK:String = "attack";
		
		
		private var _life:int;
		
		private var _targetEnemy:Enemy;
		

		private var _currentJob:Function;
		
		private var _updaterFrequency:int = 10;
		
		private var _skin:MovieClip;
		private var _type:int;
		private var _speed:Number;
		
		private var _state:String;
		private var _updater:Timer;

		private var _enemies:Vector.<Enemy> = Facade.game.enemyList;
		
		private var _sellButton:Button;
		private var _fixButton:Button;
		private var _gunMenuBackground:Image;
		private var _menuShowed:Boolean;

		public var place:Object;
		private var _setting:Object;
		
		
		
		
		
		/**
		 *Коструктор 
		 * @param $type - тип башни;  От него зависит графика и остальные параметры
		 * 
		 */	
		public function Gun($type:int)
		{
			_life = 100;
			type = $type;
			if(stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
			super();
		}
		
		
		
		
		
		/**
		 *Создание графики башни 
		 * @param e
		 * 
		 */		
		private function init(e:Event =null):void
		{
			_skin = new MovieClip(Assets.getAtlas().getTextures("gun" + _type));
			this.addChild(_skin);
			Starling.juggler.add(_skin);
			_skin.stop();
		}
		
		
		
		
		
		
		/**
		 *Старт работы башни;  
		 * Вызывается в GameInterfaceController.onCompleteGunPlaced
		 */		
		public function start():void
		{
			_skin.currentFrame = 1; _skin.pause();
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			
			_updater = new Timer(_updaterFrequency);
			_updater.addEventListener(TimerEvent.TIMER, update);
			
			state = LOOK;
			_updater.start();
		}
		
		
		
		
		
		
		
		/**
		 *Обработчик касания башни  
		 * @param e
		 * Создание меню, кнопок меню и добавление слушателей к этим кнопкам <Продать башню>  <Починить башню>
		 */		
		private function onTouch(e:TouchEvent):void
		{
			if(e.touches[0].phase != "began" || _menuShowed) return;
			_menuShowed = true;
			Facade.startDrag = true;
			_gunMenuBackground = new Image(Assets.getTexture("gunMenu"));
			this.addChild(_gunMenuBackground);
			
			_sellButton = new Button(Assets.getTexture("sellGunButtonUp"), "", Assets.getTexture("sellGunButtonDown"));
			this.addChild(_sellButton);
			_sellButton.addEventListener(Event.TRIGGERED, onSellButtonTriggered);

			_fixButton = new Button(Assets.getTexture("fixGunButtonUp"), "", Assets.getTexture("fixGunButtonDown"));
			this.addChild(_fixButton);
			_fixButton.x = _sellButton.width * 2;
			_fixButton.addEventListener(Event.TRIGGERED, onFixButtonTriggered);
		}		
		
		
		
		
		
		
		/**
		 *Получение ущерба 
		 * @param $value
		 * 
		 */		
		public function getDamage($value:int):void
		{
			life -= 10;
			if(life <= 0) destroy();
		}
		
		
		
		
		/**
		 *Обработчик касания кнопки - починить башню 
		 * @param e
		 * TODO: сделать почин башни
		 * Удаляется меню со всеми кнопками и слушателями кнопок
		 */		
		private function onFixButtonTriggered(e:Event):void
		{
			_menuShowed = false;
			Facade.startDrag = false;
			_sellButton.removeEventListener(Event.TRIGGERED, onSellButtonTriggered);
			_sellButton.removeEventListener(Event.TRIGGERED, onFixButtonTriggered);
			_fixButton.parent.removeChild(_fixButton, true);
			_fixButton = null;
			_sellButton.parent.removeChild(_sellButton, true);
			_sellButton = null;
			_gunMenuBackground.removeFromParent(true);
		}
		
		
		
		
		
		/**
		 * Обработчик касания кнопки - продать башню 
		 * @param e
		 * TODO: сделать саму продажу башни
		 * Удаляется сама башня
		 */		
		private function onSellButtonTriggered(e:Event):void
		{
			Facade.startDrag = false;
			destroy();
		}
		
		
		
		
		
		/**
		 *Удаление башни 
		 * 
		 */		
		private function destroy():void
		{
			place.busy = false;
			TweenMax.killDelayedCallsTo(attack);
			this.removeEventListener(TouchEvent.TOUCH, onTouch);
			_updater.stop();
			_updater.removeEventListener(TimerEvent.TIMER, update);
			_updater = null;
			_sellButton.removeEventListener(Event.TRIGGERED, onSellButtonTriggered);
			_sellButton.removeEventListener(Event.TRIGGERED, onFixButtonTriggered);
			_fixButton.parent.removeChild(_fixButton, true);
			_fixButton = null;
			_sellButton.parent.removeChild(_sellButton, true);
			_sellButton = null;
			_gunMenuBackground.removeFromParent(true);
			_skin.removeFromParent(true);
			Facade.game.destroyMe(this);
		}
		
		
		
		
		
		
		public function get state():String
		{
			return _state;
		}
		
		
		
		
		
		
		/**
		 *Сеттер состояния башни 
		 * @param value
		 * Состояние LOOK - поиск врага
		 * Состояние ATTACK - атака найденного врага
		 */		
		public function set state(value:String):void
		{
			_state = value;
			switch(value)
			{
				case LOOK:
					_currentJob = look;
					_updater.start();
					break;
				case ATTACK:
					_currentJob = attack;
					break;
			}
		}
		
		
		
		
		
		
		/**
		 *Поиск врага 
		 *происходит перебор всех существующих врагов и определение растояния между ними и башней
		 * если расстояние < или == радиусу поражения башни, то башня переходит в состояние ATTACK 
		 * 
		 */		
		private function look():void
		{
			var distance:Number;
			for (var i:int = 0; i < _enemies.length; i++) 
			{
				distance = Utils.distanceBetweenTwoPoints(this.x, this.y, _enemies[i].x, _enemies[i].y); 
				if(distance <= _setting.attackRadius) 
				{
					_targetEnemy = _enemies[i];
					_updater.stop();
					attack();
					//state = ATTACK;
					return;
				}
			}
		}
		
		
		
		
		
		
		/**
		 *Атака врага 
		 * 
		 */		
		private function attack():void
		{
			if(_targetEnemy && _targetEnemy.life >= 0) 
			{
				var b:Bullet = new Bullet(1, this, _targetEnemy, _setting.lethalForce);
				Facade.game.levelSprite.addChild(b);
				
				var distance:Number = Utils.distanceBetweenTwoPoints(this.x, this.y, _targetEnemy.x, _targetEnemy.y);
				if(distance >_setting.attackRadius) state = LOOK;
				else TweenMax.delayedCall(1 / _setting.shootFrequency, attack);
				if(_targetEnemy.life <= 0) _targetEnemy = null;
			}
			else state = LOOK;
		}
		
		
		
		
		
		
		
		protected function update(event:TimerEvent):void
		{
			_currentJob();
		}	
		
		
		
		
		
		
		
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(value:int):void
		{
			_type = value;
			_setting = Config["gun" + _type];
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