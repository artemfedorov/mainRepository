package model
{
	import assets.Assets;
	
	import com.greensock.TweenMax;
	
	import enemies.Enemy;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import heroes.Gun;
	
	import model.events.GameEvents;
	
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	
	
	
	
	
	
	public class GameController extends Sprite
	{
		
		
		private var _currentWave:int = 1;
		
		private var _levelBackground:Image;
		private var _levelMapImage:Image;
		
		private var _waypoints:Array;
		private var _gunPlaces:Array;
		private var _enemyList:Vector.<Enemy>;
		
		private var _touchPivotX:Number;
		private var _touchPivotY:Number;
		
		private var _levelLayer:Sprite;
		private var _interfaceLayer:Sprite;
		private var _gunsLayer:Sprite;
		private var _enemiesLayer:Sprite;
		
		
		private var _isLevelTouched:Boolean;
		private var _gameHeight:Number;
		private var _gameWidth:Number;

		
		
		public var level:flash.display.MovieClip;
		
		
		
		
		
		
		
		/**
		 *Конструктор  
		 * 
		 */
		public function GameController()
		{
			Facade.game = this;
			create();
		}
		
		
		

		/**
		 *Создание: слоев-спрайтов 
		 * ..вейпоитов
		 * ..мест для башен
		 * 
		 * level = new blevel1();  Создание лекала уровня
		 */
		private function create():void
		{
			level = new blevel1(); // FIXME: исправить хардкод - номер уровня должен присылаться сюда
			_enemyList = new Vector.<Enemy>;
			
			_levelLayer = new Sprite();
			this.addChild(_levelLayer);

			_levelBackground = new Image(Assets.getTexture("levelBackground1"));
			_levelLayer.addChild(_levelBackground);
			
			_enemiesLayer = new Sprite();
			_levelLayer.addChild(_enemiesLayer);
			
			_gunsLayer = new Sprite();
			_levelLayer.addChild(_gunsLayer);

			_interfaceLayer = new Sprite();
			this.addChild(_interfaceLayer);
			
			Facade.gameInterfaceController = new GameInterfaceController(_interfaceLayer);
			
			createWaypoints();
			createGunPlaces();
			
			addListeners();
			
			_gameWidth = _levelLayer.width;
			_gameHeight = _levelLayer.height;
		}	
		
			
			
		
		
		
		
		
		/**
		 *подписка слушателей класса 
		 * 
		 */
		private function addListeners():void
		{
			Facade.stage.addEventListener(GameEvents.PLAY_PRESSED, buildNewWave);
			Facade.stage.addEventListener(TouchEvent.TOUCH, onTouchlevelBackground);
		}

		
		
		
		
		
		
		/**
		 *отписка слушателей класса 
		 * 
		 */
		private function removeListeners():void
		{
			Facade.stage.removeEventListener(GameEvents.PLAY_PRESSED, buildNewWave);
			Facade.stage.removeEventListener(TouchEvent.TOUCH, onTouchlevelBackground);
		}
		
		
		
		
		
		/**
		 *слушатель генерации новой волны врагов 
		 * @param e
		 * 
		 */		
		private function buildNewWave(e:Event):void
		{
			var dataWave:Object = Config["wave" + _currentWave];
			var timer:int;
			for (var i:int = 0; i < dataWave.enemies.length; i++)
			{
				for (var j:int = 0; j < dataWave.enemies[i].count; j++)
				{
					TweenMax.delayedCall(timer, buildEnemy, [dataWave.enemies[i].type]);
					timer += dataWave.frequency;
				}
			}
		}
		
		
		
		
		
		
		/**
		 * Создание врага и помешение его в массив врагов
		 * @param $type тип врага
		 * 
		 */		
		private function buildEnemy($type:int):void
		{
			var en:Enemy = new Enemy($type); 
			_enemiesLayer.addChild(en);
			_enemyList.push(en);
		}
		
		
		
		
		
		
		/**
		 *Слушатель касания экрана для скроллинга экрана 
		 * @param e
		 * 
		 */		
		private function onTouchlevelBackground(e:TouchEvent):void
		{
			if(e.touches[0].phase == "began")	
			{
				_touchPivotX = e.touches[0].globalX - _levelLayer.x;
				_touchPivotY = e.touches[0].globalY - _levelLayer.y;
				_isLevelTouched = true;
			}
			if(e.touches[0].phase == "ended")	_isLevelTouched = false;
				
			var globalX:Number = e.touches[0].globalX;
			var globalY:Number = e.touches[0].globalY;
			
			if(_isLevelTouched && !Facade.startDrag) 
			{
				_levelLayer.x = globalX - _touchPivotX;
				_levelLayer.y = globalY - _touchPivotY;
				if(_levelLayer.x < Facade.stage.stageWidth - _gameWidth)  _levelLayer.x = Facade.stage.stageWidth - _gameWidth;
				if(_levelLayer.x > 0) _levelLayer.x = 0;
				if(_levelLayer.y < Facade.stage.stageHeight - _gameHeight)  _levelLayer.y = Facade.stage.stageHeight - _gameHeight;
				if(_levelLayer.y > 0) _levelLayer.y = 0;
			}
		}		
		
		
		
		
		
		/**
		 *Создание мест для башен 
		 * позиция берется из лекала уровня
		 */		
		private function createGunPlaces():void
		{
			var g:DisplayObject;
			_gunPlaces = [];
			for (var i:int = 0; i < level.numChildren; i++) 
			{
				g = level.getChildAt(i); 
				if(g is flash.display.MovieClip && g.name == "gunPlaces")
					_gunPlaces.push({x:g.x, y:g.y});
			}
			
			for (i = 0; i < _gunPlaces.length; i++) 
			{
				var gunPlace:starling.display.MovieClip = new starling.display.MovieClip(Assets.getAtlas().getTextures("gunPlace"));
				_gunsLayer.addChild(gunPlace);
				gunPlace.x = _gunPlaces[i].x - gunPlace.width / 2;
				gunPlace.y = _gunPlaces[i].y - gunPlace.height / 2;
				_gunPlaces[i] = {place:gunPlace, busy:false};
			}
			g = null;
		}	
		
		
		
		
		
		
		
		/**
		 *Создание вейпоинтов по лекалу уровня  
		 * 
		 */		
		private function createWaypoints():void
		{
			var w:flash.display.MovieClip;
			var level:flash.display.MovieClip = new blevel1();
			_waypoints = [];
			
			for (var i:int = 0; i < 16; i++) 
			{
				w = level["w" + i] as flash.display.MovieClip;
				_waypoints[i] = {x:w.x, y:w.y};
			}
			for (var j:int = 0; j < _waypoints[j].length; j++) 
			{
				var wp:Quad = new Quad(10, 10);
				_levelLayer.addChild(wp);
				wp.x = _waypoints[j].x;
				wp.y = _waypoints[j].y;
			}
			Facade.wps = _waypoints;
			level = null;
			w = null;
		}
		
		
		
		
		
		
		/**
		 *Функция удаляющая врагов и башни 
		 * @param $sprite
		 * @param $isEnemy 
		 * 
		 */		
		public function destroyMe($sprite:Sprite, $isEnemy:Boolean = false):void
		{
			if($isEnemy) _enemyList.splice(_enemyList.indexOf($sprite), 1);
			$sprite.parent.removeChild($sprite, true);
			$sprite = null;
		}
		
		
		
		
		
		
		
		
		
		public function get gunPlaces():Array
		{
			return _gunPlaces;
		}
		
		public function set gunPlaces(value:Array):void
		{
			_gunPlaces = value;
		}
		
		public function get gunsSprite():Sprite
		{
			return _gunsLayer;
		}
		
		public function set gunsSprite(value:Sprite):void
		{
			_gunsLayer = value;
		}
		
		public function get levelSprite():Sprite
		{
			return _levelLayer;
		}
		
		public function set levelSprite(value:Sprite):void
		{
			_levelLayer = value;
		}
		
		public function get enemyList():Vector.<Enemy>
		{
			return _enemyList;
		}
		
		public function set enemyList(value:Vector.<Enemy>):void
		{
			_enemyList = value;
		}
		
		
		
		
		
		
		
		
	}
}