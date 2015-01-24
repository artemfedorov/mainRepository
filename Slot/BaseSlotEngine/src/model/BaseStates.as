package model
{
	import events.ApplicationEvents;
	import events.C;
	import events.GlobalDispatcher;
	
	
	/**
	 * Класс реализующий всю логику поведения 
	 * Модель всей игры
	 * Менеджер состояний
	 *  
	 * @author fedorovartem
	 * 
	 */	
	public class BaseStates
	{
		
		/**
		 *Все состояния игры 
		 */		
		public static const IDLE_STATE:String = 		"IDLE_STATE";
		public static const PRE_SPIN_STATE:String = 	"PRE_SPIN_STATE";
		public static const SPIN_STATE:String = 		"SPIN_STATE";
		public static const SHOW_LINES:String = 		"SHOW_LINES";
		public static const SHOW_SCATTERS:String = 		"SHOW_SCATTERS";
		public static const START_FREESPINS:String = 	"START_FREESPINS";
		public static const ADD_FREESPINS:String = 		"ADD_FREESPINS";
		public static const FINISH_FREESPINS:String = 	"FINISH_FREESPINS";
		public static const COLLECT_STATE:String = 		"COLLECT_STATE";
		public static const BONUS_STATE:String = 		"BONUS_STATE";
		
		/**
		 *Счетчик фриспинов 
		 */		
		private var _freespinsCount:		int;
		
		
		private var _freespinOn:Boolean = 	false;
		private var _auto:Boolean = 		false;
		
		
		/**
		 * Последовательность состояний данной игры
		 */		
		public var queueStates:Array = 
		[ 
			IDLE_STATE,
			PRE_SPIN_STATE,
			SPIN_STATE, 
			COLLECT_STATE,
			SHOW_LINES, 
			SHOW_SCATTERS, 
			START_FREESPINS,
			ADD_FREESPINS,
			FINISH_FREESPINS,
			BONUS_STATE 
		];
		
		private var _currentState:String;
		private var _currentStateIndex:int = -1;
		
		
		private var _response:Object;
		private var freeSpinData:Object;

		private var _winningLines:Array;
		private var _winningScatters:Array;
		private var _reelsResponse:Array;
		private var _spinPressed:Boolean;
		private var isFreespins:Boolean;
		private var balance:Number;
		private var betPerLine:Number;
		private var _autoSpinsCount:int;
		private var lines:uint;
		
		
		
		public function BaseStates()
		{
			super();
			Facade.states = this;
			if (isFreespins) 
			{
				freespinOn = true;
			}
			GlobalDispatcher.addListener(C.UPDATE_DATA, 		onResponse);
			GlobalDispatcher.addListener(C.STATE_COMPLETED, 	tryChangeNextState);
			GlobalDispatcher.addListener(C.SHOW_LINES_COMPLETE, showLinesComplete);
			GlobalDispatcher.addListener(C.SPIN_COMPLETE, 		spinComplete);
			GlobalDispatcher.addListener(C.COLLECT_COMPLETE, 	collectComplete);
			GlobalDispatcher.addListener(C.SPIN_PRESSED, 		onSpinPressed);
			GlobalDispatcher.addListener(C.STOP_PRESSED, 		onStopPressed);
			GlobalDispatcher.addListener(C.AUTOSPIN_PRESSED, 	onAutoSpinPressed);

			start();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		protected function start():void
		{
			tryChangeNextState();
		}
		
		/**
		 * Попытка перехода к следующему состоянию игры
		 * Может вызываться принудительно
		 * @param	e - если приходит событие, то это означает, что текущее событие завершено
		 */
		public function tryChangeNextState(e:ApplicationEvents = null):void
		{
			if (_currentStateIndex + 1 == queueStates.length) 	_currentStateIndex = 0;
			else _currentStateIndex++;
			
			var nextState:String = queueStates[_currentStateIndex];

			switch (nextState) 
			{
				case IDLE_STATE: tryIdleState();
				break;
				
				case PRE_SPIN_STATE: tryPreSpinState();
				break;
				
				case SPIN_STATE: trySpinState();
				break;
				
				case SHOW_LINES: tryShowLinesState();
				break;
				
				case SHOW_SCATTERS: tryShowScattersState();
				break;
				
				case START_FREESPINS: tryStartFreespinsState();
				break;
				
				case FINISH_FREESPINS: tryFinishFreespinsState();
				break;
				
				case ADD_FREESPINS: tryAddFreespinsState();
				break;
				
				case COLLECT_STATE: tryCollectState();
				break;
				
				case BONUS_STATE: tryBonusGameState();
				break;
			}
		}

		
		
		
		
		/**
		 * Условия перехода и переход в состояние IDLE_STATE
		 */
		protected function tryIdleState():void 
		{
			_response = null;
			_winningLines = null;
			_winningScatters = null;
			currentState = queueStates[_currentStateIndex];
			if (auto || _spinPressed) tryChangeNextState();
		}
		
		
	   /**
		* Условия перехода и переход в состояние PRE_SPIN_STATE
		* например закрыть открытое окно PAYTABLE и тп.
		*/
		protected function tryPreSpinState():void 
		{
			currentState = queueStates[_currentStateIndex];
		}
	   
	   
	   
		/**
		 * Условия перехода и переход в состояние SPIN_STATE
		 */
		protected function trySpinState():void 
		{
			_spinPressed = false;
			if (freespinOn) freespinsCount--;
			if (auto) autoSpinsCount--;
			if (balance - (betPerLine * lines) <= 0) 
			{
				GlobalDispatcher.dispatch(C.NOT_ENOUGH_MONEY);
				return;
			}
			currentState = queueStates[_currentStateIndex];
			Facade.apiController.sendSpin();
			trace("AUTO", auto);
		}
		
		
		
		/**
		 * Условия перехода и переход в состояние SHOW_LINES
		 */
		protected function tryShowLinesState():void 
		{
			if (winningLines)
			{
				currentState = queueStates[_currentStateIndex];
			}
			else 
			{
				tryChangeNextState();
			}
		}
		
		
		
		/**
		 * Условия перехода и переход в состояние SHOW_SCATTERS
		 */
		protected function tryShowScattersState():void 
		{
			if (_response && _response.scatters && _response.scatters.length > 0) 
			{
				currentState = queueStates[_currentStateIndex];
			}
			else
			{
				tryChangeNextState();
			}
		}
		
		
		/**
		 * Условия перехода и переход в состояние START_FREESPINS
		 */
		protected function tryStartFreespinsState():void 
		{
			if (!_freespinOn && freeSpinData && freeSpinData.freeSpinDone == 0)
			{
				freespinOn = true;
				currentState = queueStates[_currentStateIndex];
			}
			else
			{
				tryChangeNextState();
			}
		}
		
		
		/**
		 * Условия перехода и переход в состояние ADD_FREESPINS
		 */
		protected function tryAddFreespinsState():void 
		{
			if (freespinOn && _freespinsCount < freeSpinData.totalFreeSpins - freeSpinData.freeSpinDone) 
			{
				_freespinsCount = freeSpinData.totalFreeSpins;
				currentState = queueStates[_currentStateIndex];
			}
			else
			{
				tryChangeNextState();
			}
		}
		
		
		/**
		 * Условия перехода и переход в состояние FINISH_FREESPINS
		 */
		protected function tryFinishFreespinsState():void 
		{
			if (_freespinOn && freeSpinData.freeSpinDone >= freeSpinData.totalFreeSpins) 
			{
				auto = false;
				freespinOn = false;
				isFreespins = false;
				_freespinsCount = 0;
				currentState = queueStates[_currentStateIndex];
			}
			else
			{
				tryChangeNextState();
			}
		}
		
	
		
		/**
		 * Условия перехода и переход в состояние COLLECT_STATE
		 */
		protected function tryCollectState():void 
		{
			if (_response && _response.totalWin > 0)
			{
				trace("-----------------------------SENDING COLLECT-------------------------------");
				Facade.apiController.sendCollect();
				currentState = queueStates[_currentStateIndex];
			}
			else
			{
				tryChangeNextState();
			}
		}
		
		
		/**
		 * Условия перехода и переход в состояние BONUS_STATE
		 */
		protected function tryBonusGameState():void 
		{
			/*if (_response.winnings && _response.winnings.bonus_game) 
			{
				currentState = _queueStates[_currentStateIndex];
			}
			else*/
			{
				tryChangeNextState();
			}
		}
		
		
		
		/**
		 * Обновление символов
		 * @param	$response - Ответ от сервера
		 */
		protected function updateReelsData($response:Object):void 
		{
			if($response.reelStops && $response.reelStops) reelsResponse = $response.reelStops;
		}
		
		
		
		/**
		 * Обновление количества фриспинов
		 * @param	$response - Ответ от сервера
		 */
		protected function updateFreespinsObject($response:Object):void 
		{
			if(!_freespinOn && $response.freeSpinData) GlobalDispatcher.dispatch(C.FREESPINS_RESPONSE);
		}

		
		protected function updateWinningLines($response:Object):void 
		{
			if ($response && $response.winLines && $response.winLines.length > 0)
			_winningLines = $response.winLines as Array;
		}
		
		protected function updateWinningScatters($response:Object):void 
		{
			if ($response && $response.scatters && $response.scatters.length > 0)
			winningScatters = $response.scatters as Array;
		}
		
	
		//--------------------------------------------------------------------------
		//
		//  Events handlers
		//
		//--------------------------------------------------------------------------
		
		
		
		/**I
		 * Ответ от сервера
		 * @param	e
		 */
		protected function onResponse(e:ApplicationEvents):void 
		{
			_response = e.params;
			if (_response.freeSpinData && auto) auto = false;
			updateReelsData(_response);
			updateFreespinsObject(_response);
			updateWinningLines(_response);
			updateWinningScatters(_response);
		}
		
		
		/**
		 * Нажали на спин
		 * @param	e
		 */
		protected function onSpinPressed(e:ApplicationEvents):void 
		{
			_spinPressed = true;
			_currentStateIndex++;
			tryChangeNextState();
		}
		
				
		
		/**
		 * Нажали на остановку ургентную спина
		 * @param	e
		 */
		protected function onStopPressed(e:ApplicationEvents):void 
		{
			if (_currentState == SPIN_STATE) 
			{
				GlobalDispatcher.dispatch(C.URGENT_STOP);
			}
		}
		
		
		/**
		 * Нажали на авто спин
		 * @param	e
		 */
		protected function onAutoSpinPressed(e:ApplicationEvents):void 
		{
			auto = !auto;
			if (e.params) autoSpinsCount = e.params as int;
			if (auto && _currentState == IDLE_STATE || _currentState == FINISH_FREESPINS) tryChangeNextState();
		}
		
		
		
		
		
		protected function spinComplete(e:ApplicationEvents):void 
		{
			tryChangeNextState();
		}
		
		
		protected function collectComplete(e:ApplicationEvents):void 
		{
			tryChangeNextState();
		}
		
		protected function showLinesComplete(e:ApplicationEvents):void 
		{
			tryChangeNextState();
		}
		
	
	
		//--------------------------------------------------------------------------
		//
		//  Getters&setters
		//
		//--------------------------------------------------------------------------
		public function get currentStateIndex():int 
		{
			return _currentStateIndex;
		}
		
		public function set currentStateIndex(value:int):void 
		{
			_currentStateIndex = value;
		}
		
		public function get currentState():String 
		{
			return _currentState;
		}
		
		public function set currentState(value:String):void 
		{
			_currentState = value;
			GlobalDispatcher.dispatch(C.STATE_CHANGED, currentState);
			trace("STATE:", value);
		}
		
		
		public function get reelsResponse():Array 
		{
			return _reelsResponse;
		}
		
		public function set reelsResponse(value:Array):void 
		{
			_reelsResponse = value;
			GlobalDispatcher.dispatch(C.RESPONSE_ON_SPIN, _reelsResponse);
		}
		
		public function get auto():Boolean 
		{
			return _auto;
		}
		
		public function set auto(value:Boolean):void 
		{
			_auto = value;
		}
		
		public function get winningLines():Array 
		{
			return _winningLines;
		}
		
		public function set winningLines(value:Array):void 
		{
			_winningLines = value;
		}
		
		public function get winningScatters():Array 
		{
			return _winningScatters;
		}
		
		public function set winningScatters(value:Array):void 
		{
			_winningScatters = value;
		}
		
		public function get freespinOn():Boolean 
		{
			return _freespinOn;
		}
		
		public function set freespinOn(value:Boolean):void 
		{
			_freespinOn = value;
		}
		
		public function get freespinsCount():int 
		{
			return _freespinsCount;
		}
		
		public function set freespinsCount(value:int):void 
		{
			_freespinsCount = value;
		}
		
		public function get autoSpinsCount():int 
		{
			return _autoSpinsCount;
		}
		
		public function set autoSpinsCount(value:int):void 
		{
			_autoSpinsCount = value;
		}
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
	}
}