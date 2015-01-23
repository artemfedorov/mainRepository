package model
{
	import com.greensock.TweenMax;
	
	import events.ApplicationEvents;
	import events.GlobalDispatcher;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	import model.mechanics.IMechanics;
	import model.mechanics.TwoPartsOfOneMech;
	
	import superClasses.BaseClass;
	import superClasses.NonB2DActor;
	
	public class NB2DController extends BaseClass
	{
		private var _gameSkin:MovieClip;
		private var _currentAsset:Object;
		private var _gameObjects:Array;
		private var _dummies:Array;
		private var _leftCard:NonB2DActor;
		private var _rightCard:NonB2DActor;
		private var _mechanics:IMechanics;
		

		
		public function NB2DController()
		{
			super();
		}
		
		
		
		public function get mechanics():IMechanics
		{
			return _mechanics;
		}

		public function set mechanics(value:IMechanics):void
		{
			_mechanics = value;
		}

		public function get gameObjects():Array
		{
			return _gameObjects;
		}

		public function set gameObjects(value:Array):void
		{
			_gameObjects = value;
		}

		public function get leftCard():NonB2DActor
		{
			return _leftCard;
		}

		public function set leftCard(value:NonB2DActor):void
		{
			_leftCard = value;
		}

		public function get rightCard():NonB2DActor
		{
			return _rightCard;
		}

		public function set rightCard(value:NonB2DActor):void
		{
			_rightCard = value;
		}

		override protected function onRegister():void
		{
			super.onRegister();
		} 
		
			
		
		public function createGame():void
		{
			_gameObjects = [];
			_gameSkin = GameFacade.gameView.skin;
			_currentAsset = GameFacade.gameModel.getNextGameAsset();
			createStuff(_currentAsset);
		}
		
		private function createStuff($asset:Object):void 
		{ 
			var obj:NonB2DActor;
			var costume:MovieClip;
			var itemsCounter:int;
			
			GameFacade.currentGameType = $asset.type;
			_dummies = [];
			for (var k:int = 1; k < 13; k++) 
				_dummies.push("dummy" + k);
			switch($asset.type)
			{
				case "pieces":
					
					_gameSkin.gotoAndStop("pieces");
					for (var i:int = 0; i < $asset.setting.length; i++) 
					{
						for (var j:int = 1; j < 3; j++) 
						{
							costume = new cards();
							costume.x = (_gameSkin.getChildByName(_dummies[itemsCounter]) as MovieClip).x;  
							costume.y = (_gameSkin.getChildByName(_dummies[itemsCounter]) as MovieClip).y;  
							costume.mask1.getChildByName("mask" + j).scaleY = 0;
							
							if(j == 2) costume.back.x = -115;
							if(j == 1) costume.back.x = 0;
							costume.name = $asset.setting[i];
							costume.gotoAndStop($asset.setting[i]);
							_gameSkin.itemsContainer.addChild(costume);
							obj = B2DFactory.nonB2DActor(costume);
							obj.objectType = "GameObject";
							obj.owner = (_gameSkin.getChildByName(_dummies[itemsCounter]) as MovieClip);
							_gameObjects.push(obj);
							
							itemsCounter++;
							trace(itemsCounter);
							GlobalDispatcher.addListener(GameEventConstants.ITEM_DETOUCHED, detouched);
						}
					}
					_mechanics = new TwoPartsOfOneMech();
				break;
			}
		}
		
		
		private function detouched(e:ApplicationEvents):void
		{
			ankor(e.params as NonB2DActor);
		}		
		
		
		public function ankor($obj:NonB2DActor):void
		{
			var nope:Boolean;
			if(!_leftCard)
			{	
				if($obj.costume.mask1.mask1.scaleY > 0 && $obj.costume.mask1.mask1.hitTestObject(_gameSkin.cardLeft))
				{
					TweenMax.to($obj.costume, 0.3, {x: _gameSkin.cardLeft.x + $obj.costume.width / 4});
					TweenMax.to($obj.costume, 0.3, {y: _gameSkin.cardLeft.y});
					_leftCard = $obj;
					nope = true;
				}
				else
				if($obj.costume.mask1.mask2.scaleY > 0 && $obj.costume.mask1.mask2.hitTestObject(_gameSkin.cardLeft))
				{
					TweenMax.to($obj.costume, 0.3, {x: _gameSkin.cardLeft.x - $obj.costume.width / 4});
					TweenMax.to($obj.costume, 0.3, {y: _gameSkin.cardLeft.y});
					_leftCard = $obj;
					nope = true;
				}
			}
			
			if(!_rightCard)
			{
				if($obj.costume.mask1.mask1.scaleY > 0 && $obj.costume.mask1.mask1.hitTestObject(_gameSkin.cardRight))
				{
					TweenMax.to($obj.costume, 0.3, {x: _gameSkin.cardRight.x + $obj.costume.width / 4});
					TweenMax.to($obj.costume, 0.3, {y: _gameSkin.cardRight.y});
					_rightCard = $obj;
					nope = true;
				}				
				else
				if($obj.costume.mask1.mask2.scaleY > 0 && $obj.costume.mask1.mask2.hitTestObject(_gameSkin.cardRight))
				{
					TweenMax.to($obj.costume, 0.3, {x: _gameSkin.cardRight.x - $obj.costume.width / 4});
					TweenMax.to($obj.costume, 0.3, {y: _gameSkin.cardRight.y});
					_rightCard = $obj;
					nope = true;
				}
			}	
			
			if(!nope)
			{
				TweenMax.to($obj.costume, 0.3, {x: $obj.owner.x});
				TweenMax.to($obj.costume, 0.3, {y: $obj.owner.y});
			}
			
			
			
			if(_leftCard && _rightCard) 
			if(_leftCard.costume.mask1.mask1.scaleY > 0 && _rightCard.costume.mask1.mask2.scaleY > 0 && _leftCard.costume.name == _rightCard.costume.name) 
			{
				_leftCard.removeListeners();
				_rightCard.removeListeners();
				delay(1, destroyCards);
			}
		}
		
		private function destroyCards():void
		{
			initDestroyObject(_leftCard);
			initDestroyObject(_rightCard);
			_leftCard = null;
			_rightCard = null;
			if(!mechanics) return;
			(mechanics as TwoPartsOfOneMech).checkend();
		}
		
		public function initDestroyObject($item:NonB2DActor):void
		{
			if(!$item) return;
			$item.destroy();
			_gameObjects.splice(_gameObjects.indexOf($item), 1);
		}
		
		
		public function destroyAllObjects():void
		{
			GlobalDispatcher.removeListener(GameEventConstants.ITEM_DETOUCHED);
			if(!_gameObjects) return;
			for (var i:int = 0; i < _gameObjects.length; i++) 
			{
				_gameObjects[i].destroy();
			}
			_gameObjects.length = 0;
			mechanics = null;
		}
	}
}