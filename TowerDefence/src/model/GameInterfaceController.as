package model
{
	import assets.Assets;
	
	import com.greensock.TweenMax;
	
	import flash.geom.Point;
	
	import heroes.Gun;
	
	import model.events.GameEvents;
	
	import starling.display.Button;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;

	
	
	
	
	
	
	
	public class GameInterfaceController
	{
		
		
		private var _skin:Sprite;
		private var _playButton:Button;
		private var _dragedObject:Gun;
		
		
		
		/**
		 *Коструктор 
		 * @param $skin - слой
		 * 
		 */		
		public function GameInterfaceController($skin:Sprite)
		{
			_skin = $skin;
			create();
			addListeners();
		}
		
		
		
		
		/**
		 *Создание всей интерфейсной части уровня 
		 * кнопки, иконки, индикаторы
		 */		
		private function create():void
		{
			var gun1icon:starling.display.MovieClip = new starling.display.MovieClip(Assets.getAtlas().getTextures("icongun1"));
			var gun2icon:starling.display.MovieClip = new starling.display.MovieClip(Assets.getAtlas().getTextures("icongun2"));
			var gun3icon:starling.display.MovieClip = new starling.display.MovieClip(Assets.getAtlas().getTextures("icongun3"));
			var gun4icon:starling.display.MovieClip = new starling.display.MovieClip(Assets.getAtlas().getTextures("icongun4"));
			
			gun1icon.name = "icongun1";
			gun2icon.name = "icongun2";
			gun3icon.name = "icongun3";
			gun4icon.name = "icongun4";
			
			_skin.addChild(gun1icon);
			_skin.addChild(gun2icon);
			_skin.addChild(gun3icon);
			_skin.addChild(gun4icon);
			
			gun1icon.x = Facade.game.level.gun1icon.x;
			gun1icon.y = Facade.game.level.gun1icon.y;
			gun2icon.x = Facade.game.level.gun2icon.x;
			gun2icon.y = Facade.game.level.gun2icon.y;
			gun3icon.x = Facade.game.level.gun3icon.x;
			gun3icon.y = Facade.game.level.gun3icon.y;
			gun4icon.x = Facade.game.level.gun4icon.x;
			gun4icon.y = Facade.game.level.gun4icon.y;
			
			_playButton = new Button(Assets.getTexture("playWaveButtonUp"), "", Assets.getTexture("playWaveButtonDown"));
			_playButton.x = Facade.game.level.playWaveButton.x;
			_playButton.y = Facade.game.level.playWaveButton.y;
			_skin.addChild(_playButton);
		}		
		
		
		
		
		
		
		/**
		 *Обработка касания к интерфейсной части уровня 
		 * @param e
		 * при касании иконки, создается башня и таскается пока не отпустишь ее на коллизию с местом для башен.
		 */		
		private function onTouch(e:TouchEvent):void
		{
			if(e.touches[0].phase == "began") 
			{
				var icon:MovieClip = e.touches[0].target as MovieClip;
				if(!icon || icon.name.indexOf("icon") == -1 || _dragedObject) return;
				
				var type:int = int(icon.name.substr(icon.name.length - 1, 1));
				var gun:Gun = new Gun(type); 
				Facade.game.gunsSprite.addChild(gun);
				_dragedObject = gun;
				
				Facade.startDrag = true;	
			}
			if(_dragedObject && e.touches[0].phase == "ended") 
			{
				
				for (var i:int = 0; i < Facade.game.gunPlaces.length; i++) 
				{
					if(!Facade.game.gunPlaces[i].busy && (Facade.game.gunPlaces[i].place as Quad).bounds.intersects(_dragedObject.bounds))
					{
						Facade.startDrag = false;	
						TweenMax.to(_dragedObject, 0.5, {x:Facade.game.gunPlaces[i].place.x, onComplete:onCompleteGunPlaced, onCompleteParams:[_dragedObject]});
						TweenMax.to(_dragedObject, 0.5, {y:Facade.game.gunPlaces[i].place.y});
						
						_dragedObject.place = Facade.game.gunPlaces[i];
						Facade.game.gunPlaces[i].busy = true;
						return;
					}
				}
				Facade.startDrag = false;	
				TweenMax.to(_dragedObject, 0.2, {x:Facade.stage.stageWidth, onComplete:dragedObjectGoToHomeComplete});
				TweenMax.to(_dragedObject, 0.2, {y:Facade.stage.stageHeight});
			}
			
			if(Facade.startDrag && _dragedObject) 
			{
				_dragedObject.x = e.touches[0].globalX + Facade.game.x - Facade.game.levelSprite.x - _dragedObject.width / 2;
				_dragedObject.y = e.touches[0].globalY + Facade.game.y - Facade.game.levelSprite.y - _dragedObject.height / 2;
			}
		}

		
		
		
		
		
		
		
		/**
		 *Вызывается при комплите твина башни в случае когда башню отпустили не на месте для башен   
		 * и она тупо улетела. Вот и в конце "улетела" ее удаляем.
		 */		
		private function dragedObjectGoToHomeComplete():void
		{
			_dragedObject.removeFromParent(true);
			_dragedObject = null;
		}
		
		
		
		
		
		/**
		 * Вызывается при комплите твина башни в случае когда башню отпустили на месте для башен 
		 * @param $gun
		 * Вызываем старт у башни чтобы она начала работать.
		 */		
		private function onCompleteGunPlaced($gun:Gun):void
		{
			_dragedObject = null;
			$gun.start();
		}
		
		
		
		
		
		/**
		 *Нажимаем на кнапку старт уровня 
		 * @param e
		 * 
		 */		
		private function onPlayButtonTriggered(e:Event):void
		{
			Facade.stage.dispatchEventWith(GameEvents.PLAY_PRESSED);
		}
		
		
		
		
		
		
		/**
		 *Подписка на все события класса 
		 * 
		 */		
		private function addListeners():void
		{
			_skin.addEventListener(TouchEvent.TOUCH, onTouch);
			_playButton.addEventListener(Event.TRIGGERED, onPlayButtonTriggered);
		}
		
		
		
		
		
		/**
		 *Отписка от всех событий класса 
		 * 
		 */	
		private function removeListeners():void
		{
			_skin.removeEventListener(TouchEvent.TOUCH, onTouch);
			_playButton.removeEventListener(Event.TRIGGERED, onPlayButtonTriggered);
		}
		
		
		
		
		
		
	}
}