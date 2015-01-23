package reels 
{
	import com.greensock.TweenMax;
	
	import configs.Config;
	
	import events.ApplicationEvents;
	import events.C;
	import events.GlobalDispatcher;
	
	import model.BaseStates;
	
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
		private var _reelStopCounter:int = 0;
		
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
			for (var i:int = 0; i < Config.reelsAmount; i++) 
			{
				var reelView:BaseReelView = new BaseReelView();
				reelView.x = Facade.layout.reels["reel" + String(i + 1)].x;
				reelView.y = Facade.layout.reels["reel" + String(i + 1)].y;
				this.addChild(reelView);
				_reels.push(reelView);
			}
		}
		
		
		
		protected function initStartRolling():void
		{
			startRolling(0);
			
		}	
		
		protected function startRolling($reelIndex:uint):void 
		{
			for (var i:int = 0; i < _reels.length; i++) 
			{
				_reels[i].start();
			}
			TweenMax.delayedCall(2, initStopRolling);
		}
		
		
		protected function initStopRolling():void
		{
			stopRolling(0);
			
		}
		
		
		protected function stopRolling($reelIndex:int):void 
		{
			_reels[$reelIndex].stop();
			if(_reels.length - 1 >= $reelIndex + 1) 
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