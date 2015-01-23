package reels 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import Utils.AssetLoader;
	
	import configs.Config;
	
	import entities.Item;
	
	import events.C;
	import events.GlobalDispatcher;
	
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	
	/**
	 * ...
	 * @author ValeriiT Fedorov
	 */
	public class BaseReelView extends Sprite 
	{
		
		private var _symbols:Vector.<Item>;

		private var _run:Function;
		private var _speed:Number = Config.speedRolling;
		private var _shift:Number = 50;
		private var _isStoping:Boolean;
		private var _counter:int = 0;
		private var _counterStopTween:int = 0;
		private var _symbolWidth:Number;
		private var _symbolHeight:Number;
		
		
		
		
		public function BaseReelView() 
		{
			super();
			init();
		}
		
		
		
		protected function init():void 
		{
			_symbols = new Vector.<Item>;
			createSymbols();
		}
		
		
		
		
		protected function createSymbols():void 
		{
			var symbol:Item;
			var type:uint;
			for (var i:int = 0; i < Config.symbolsPerReel + 2; i++) 
			{
				symbol = Facade.root.poolOut();
				type = int(Math.random() * Config.types.length);
				symbol.awake(AssetLoader.assetsDics[Config.types[type]], Config.types[type], false);
				symbol.stop();
				symbol.y = i * symbol.height;
				addChild(symbol);
				_symbols.push(symbol);
			}
			_symbolWidth = symbol.width;
			_symbolHeight = symbol.height;
		}
		
		
		
		
		public function start():void 
		{
			for (var i:int = 0; i < _symbols.length; i++) 
			{
				_symbols[i].stop();
			}
			addEventListener(EnterFrameEvent.ENTER_FRAME, update);
			_run = rollDown;
		}
		
		
		
		
		public function stop():void
		{
			var symbol:Item;
			var type:uint;
			_counter = 0;
			_isStoping = true;
			for (var i:int = 0; i < Config.symbolsPerReel + 2; i++) 
			{
				symbol = Facade.root.poolOut();
				symbol.y = _symbols[0].y - symbol.height;
				symbol.stop();
				addChild(symbol);
				type = int(Math.random() * Config.types.length);
				symbol.awake(AssetLoader.assetsDics[Config.types[type]], Config.types[type], false);
				_symbols.unshift(symbol);
			}
		}
		
		
		
		
		
		protected function update(e:EnterFrameEvent):void 
		{
			_run();
		}
		
		
		
		
		protected function rollDown():void
		{
			var symbolsAmounts:uint = _symbols.length - 1; 
			var type:uint;
			
			for (var i:int = symbolsAmounts; i >= 0; i--) 
			{
				if (_symbols[i].y > Config.symbolsPerReel * _symbolHeight + 100) 
				{
					if (!_isStoping)
					{
						_symbols[i].stop();
						_symbols[i].y = _symbols[0].y - _symbolHeight;
						type = int(Math.random() * Config.types.length);
						_symbols[i].setTexture(Config.types[type], AssetLoader.assetsDics[Config.types[type]]);
						_symbols.unshift(_symbols.pop());
					}
					else
					{
						if (_counter == Config.symbolsPerReel + 2) 
						{
							_isStoping = false;
							removeEventListener(EnterFrameEvent.ENTER_FRAME, update);
							finishSTween();
							return;
						}
						_counter++;
						Facade.root.poolIn(_symbols[i]);
						_symbols[i].parent.removeChild(_symbols[i]);
						_symbols.splice(i, 1);
						symbolsAmounts = _symbols.length - 1; 
						if(i > symbolsAmounts) continue;
					}
				}
				_symbols[i].y += _speed;
			}
		}
		
		
		
		
		protected function finishSTween():void 
		{
			for (var i:int = 0; i < _symbols.length; i++) 
			{
				_counterStopTween++;
				TweenMax.to(_symbols[i], 0.05, {y: i * _symbolHeight + _shift, ease:Linear.power, onComplete:onCompleteStopTween, onCompleteParams:[_symbols[i]]} );
			}
		}
		
		
		
		
		protected function onCompleteStopTween(s:Item):void 
		{
			TweenMax.to(s, 0.1, {y: s.y - _shift, ease:Linear.easeOut, onComplete:onFinnalyStopTween} );
		}
		
		
		
		
		protected function onFinnalyStopTween():void 
		{
			_counterStopTween--;
			if (_counterStopTween == 0) 
			{
				for (var i:int = 0; i < _symbols.length; i++) 
				{
					_symbols[i].play();
				}
				GlobalDispatcher.dispatch(C.REEL_STOPED);
			}
		}
		
		
		
		public function get shift():Number
		{
			return _shift;
		}
		
		public function set shift(value:Number):void
		{
			_shift = value;
		}
		
		
	}

}