package lines 
{
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	import Utils.AssetLoader;
	import Utils.PixelMask;
	
	import configs.Config;
	
	import entities.MySpriteEntity;
	
	import events.ApplicationEvents;
	import events.C;
	import events.GlobalDispatcher;
	
	import model.BaseStates;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;

	/**
	 *Класс создания и управления линиями 
	 * @author fedorovartem
	 * 
	 */	
	
	public class BaseLinesView extends Sprite
	{
		public static var atlasesNames:Array = 
			[
				"lines",
				"borders",
				"boxes"
			];
		public static var path:String = "lines";
		
		protected var linesLayer:PixelMask;
		protected var boxesLayer:Sprite;
		protected var borders:Array;
		protected var currentWinningLineIndex:uint;
		protected var linesArray:Vector.<BaseLineView>;
		protected var activeLines:uint;
		protected var isShowingLines:Boolean;
		protected var masks:Sprite;
		
		
		
		public function BaseLinesView() 
		{
			GlobalDispatcher.addListener(C.STATE_CHANGED, onStateChanged);
			GlobalDispatcher.addListener(C.LINES_CHANGED, onLinesChanged);
			super();
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		/**
		 * Построение всех линий
		 * бордеров
		 * и масок для них
		 * 
		 */
		
		protected function createLineInstance($name:String):BaseLineView
		{
			return new BaseLineView(AssetLoader.assetsDics["lines"], $name, false);
		}
		
		protected function init(e:Event = null):void
		{
			//boxes - маленькие квадратики на который изображен номер линии
			var boxes:MovieClip = Facade.layout.boxes;
			boxesLayer = new Sprite();
			this.parent.addChild(boxesLayer);
			boxesLayer.x = boxes.x;
			boxesLayer.y = boxes.y;
			//Создание линий
			//linesLayer - контейнер для линии который может работать с динамической маской
			linesLayer = new PixelMask(); 
			linesArray = new Vector.<BaseLineView>;
			var line:BaseLineView; // сама линия
			
			for (var i:int = 0; i < Config.linesAmout; i++) 
			{
				var lineName:String = "line" + String(i + 1);
				line = createLineInstance(lineName); //Создание экземпляра нужной линии по имени/номеру
				//Создание боксов для линий:начало
				var boxLeft:MySpriteEntity = new MySpriteEntity(AssetLoader.assetsDics["boxes"], lineName + "Left", false);
				boxLeft.x = boxes[lineName + "Left"].x;
				boxLeft.y = boxes[lineName + "Left"].y;
				boxesLayer.addChild(boxLeft);
				var boxRight:MySpriteEntity = new MySpriteEntity(AssetLoader.assetsDics["boxes"], lineName + "Right", false);
				boxRight.x = boxes[lineName + "Right"].x;
				boxRight.y = boxes[lineName + "Right"].y;
				boxesLayer.addChild(boxRight);
				line.leftBox = boxLeft;
				line.rightBox = boxRight;
				//Создание боксов для линий:конец
				linesArray.push(line);
				line.hide();
				var lineX:Number = Facade.layout.lines["line" + String(i + 1)].x;
				var lineY:Number = Facade.layout.lines["line" + String(i + 1)].y;
				line.setPosition(lineX, lineY);
				linesLayer.addChild(line);
			}
			activeLines = Config.activeLines;
			this.addChild(linesLayer);

			//Создание масок
			var layoutMask:MovieClip = Facade.layout.lines.reelsMask;
			masks = new Sprite();
			this.addChild(masks);
			for (var j:int = 0; j < layoutMask.numChildren; j++) 
			{
				var child:MovieClip = layoutMask.getChildAt(j) as MovieClip;
				var mask:Quad = new Quad(child.width, child.height, Math.round(Math.random() * 0xffffff));
				mask.name = child.name;
				mask.x = child.x;
				mask.y = child.y;
				masks.addChild(mask); 
			}
			masks.x = layoutMask.x;
			masks.y = layoutMask.y;
			masks.visible = false;
			linesLayer.mask = masks;
			
			//Создание бордеров для линий
			borders = [];
			for (var k:int = 0; k < Config.reelsAmount * Config.symbolsPerReel; k++) 
			{
				var border:MySpriteEntity = new MySpriteEntity(AssetLoader.assetsDics["borders"], "linesBorders", false);
				this.addChild(border);
				borders.push(border);
				border.visible = false;
			}
		}
		
		
		
		
		/**
		 * Показ линии
		 * 
		 */
		protected function showLines():void
		{
			for (var i:int = 0; i < activeLines; i++) 
			{
				linesArray[i].setActive();
			}
			for (i = activeLines; i < Config.linesAmout; i++) 
			{
				linesArray[i].setInactive();
			}
		}
		

		/**
		 * Спрятать все линии
		 * 
		 */
		protected function hideLines():void
		{
			hideBorders();
			hideMasks();
			for (var i:int = 0; i < linesArray.length; i++) 
			{
				linesArray[i].hide();
			}
		}
		
		
		
		/**
		 * Изменение количества активных линий
		 * @param e
		 * 
		 */
		private function onLinesChanged(e:ApplicationEvents):void
		{
			hideLines();
			if(!(e.params is uint)) 
			{
				trace("Ошибка onLinesChanged");
				return;
			}
			activeLines = e.params as uint;
			showLines();
			
			if(isShowingLines)
			{
				complete();
				TweenMax.killDelayedCallsTo(showWinningLines);
			}
		}
		
		
		/**
		 * Слушатель события изменения STATE из модели
		 */
		protected function onStateChanged(e:ApplicationEvents):void 
		{
			if(e.params == BaseStates.SHOW_LINES)
			{
				hideLines();
				isShowingLines = true;
				currentWinningLineIndex = 0;
				showWinningLines(currentWinningLineIndex);
			}
			else
			if(e.params == BaseStates.SPIN_STATE)
			{
				if(isShowingLines)
				{
					isShowingLines = false;
					TweenMax.killDelayedCallsTo(showWinningLines);
				}
				hideLines();
			}
		}
		
		
		/**
		 *Показ выигрышной линии путем обрезания по маске и показа бордеров 
		 * согласно данных с сервера 
		 * @param $indexLine
		 * 
		 */
		protected function showWinningLines($indexLine:uint):void
		{
			showMasks(Facade.states.winningLines[currentWinningLineIndex].symbols, Facade.states.winningLines[currentWinningLineIndex].line);
			linesArray[Facade.states.winningLines[currentWinningLineIndex].line - 1].showWinning();
			
			if(currentWinningLineIndex + 1 <= Facade.states.winningLines.length - 1)
			{
				currentWinningLineIndex++;
				TweenMax.delayedCall(1, showWinningLines, [currentWinningLineIndex]);
			}
			else
			{
				if(!Facade.states.auto) 
				{
					currentWinningLineIndex = 0;
					TweenMax.delayedCall(1, showWinningLines, [currentWinningLineIndex]);
				}
				else
				TweenMax.delayedCall(1, complete);
			}
		}		
		
		
		
	
		/**
		 *Скрыть все бордеры 
		 * 
		 */		
		protected function hideBorders():void
		{
			for (var i:int = 0; i < borders.length; i++) 
			{
				borders[i].visible = false;
			}
		}
		
		
		/**
		 *Уберание масок согласно данных от сервера 
		 * @param $symbols
		 * @param $line
		 * 
		 */		
		protected function showMasks($symbols:Array, $line:uint):void
		{
			for (var i:int = 0; i < $symbols.length; i++) 
			{
				var mask:Quad = masks.getChildByName("reel"+ $symbols[i]["0"] + $symbols[i]["1"]) as Quad;
				borders[i].x = mask.x + masks.x;
				borders[i].y = mask.y + masks.y;
				borders[i].mc.currentFrame = $line -  1;
				borders[i].visible = true;
				mask.scaleX = 0;
			}
		}
		
		
		
		/**
		 *Возвращение всех масок в первоначальное состояние 
		 * 
		 */		
		protected function hideMasks():void
		{
			for (var i:int = 0; i < Config.reelsAmount; i++) 
			{
				for (var j:int = 0; j < Config.symbolsPerReel; j++) 
				{
					(masks.getChildByName("reel"+ String(i) + String(j)) as Quad).scaleX = 1;
				}
			}
		}
		
		
		
		
		/**
		*Окончание показа всех выигрышных линий
		 */
		protected function complete():void 
		{
			isShowingLines = false;
			GlobalDispatcher.dispatch(C.SHOW_LINES_COMPLETE);
		}
		
		
		
	}

}