package reels 
{
	import com.greensock.TweenMax;
	
	import configs.Config;
	
	import events.ApplicationEvents;
	import events.C;
	import events.GlobalDispatcher;
	
	import model.BaseStates;
	
	import reels.interfaces.IReelView;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	
	
	/**
	 *Класс реализующий работу барабанов.
	 * создает нужное количество барабанов и управляет ими. 
	 * 
	 * @author fedorovartem
	 * 
	 */	
	public class BaseReelsView extends Sprite
	{		
		private var _reels:Array = [];
		private var _reelsLayer:Sprite = new Sprite();
		private var _altReels:Array = [];
		private var _altReelsLayer:Sprite = new Sprite();
		private var _activeReels:Array;
		private var _reelStopCounter:int = 0;
		
		
		public static const atlasesNames:Array = 
			[
				"ace",
				"butterfly",
				"flower",
				"flowerred",
				"jack",
				"king",
				"nine",
				"owl",
				"pantera",
				"queen",
				"staticSymbols",
				"ten",
				"wolf",
			];
		public static const path:String = "game";
		
		
		public function BaseReelsView() 
		{
			GlobalDispatcher.addListener(C.STATE_CHANGED, onStateChanged);
			GlobalDispatcher.addListener(C.REEL_STOPED, onReelStoped);
			init();
		}
		
		/**
		 * Слушатель события изменения состояния 
		 */
		protected function onStateChanged(e:ApplicationEvents):void 
		{
			if (e.params == BaseStates.SPIN_STATE) initStartRolling();
			
		}
		
		
		
		protected function init():void 
		{
			_activeReels = _reels;
			this.addChild(_reelsLayer);
			this.addChild(_altReelsLayer);
			_altReelsLayer.visible = false;
			for (var i:int = 0; i < Config.reelsAmount; i++) 
			{
				var reelView:IReelView = createReelView();
				reelView.setReelNumber(i);
				reelView.setXY(Facade.layout.reels["reel" + String(i + 1)].x, Facade.layout.reels["reel" + String(i + 1)].y);
				_reelsLayer.addChild(reelView as DisplayObject);
				_reels.push(reelView);
				
				reelView = createReelView();
				reelView.setReelNumber(i);
				reelView.setXY(Facade.layout.reels["reel" + String(i + 1)].x, Facade.layout.reels["reel" + String(i + 1)].y);
				_altReelsLayer.addChild(reelView as DisplayObject);
				_altReels.push(reelView);
			}
		}

		/**
		 *Фукция обязательна для переопределения 
		 * @return 
		 * 
		 */		
		protected function createReelView():IReelView
		{
			return new BaseReelView();
		}		
		
		
		protected function initStartRolling():void
		{
			startRolling(0);
			
		}	
		
		protected function startRolling($reelIndex:uint):void 
		{
			for (var i:int = 0; i < _activeReels.length; i++) 
			{
				_activeReels[i].start();
			}
			TweenMax.delayedCall(2, initStopRolling);
		}
		
		
		protected function initStopRolling():void
		{
			stopRolling(0);
			
		}
		
		
		protected function stopRolling($reelIndex:int):void 
		{
			_activeReels[$reelIndex].stop();
			if(_activeReels.length - 1 >= $reelIndex + 1) 
				TweenMax.delayedCall(0.2, stopRolling, [$reelIndex + 1]);
		}
		
		
		protected function onReelStoped(e:ApplicationEvents):void 
		{
			_reelStopCounter++;
			//trace(_reelStopCounter);
			if (_reelStopCounter == Config.reelsAmount) 
			{
				_reelStopCounter = 0;
				complete();
			}
		}
		
		
		/**
		 * Вращение полностью завершено. Все барабаны полностью остановлены.
		 * Сообщаем об этом в модель.
		 */
		protected function complete():void 
		{
			GlobalDispatcher.dispatch(C.SPIN_COMPLETE);
		}
		
		
		
		
		
		
	
	}

}