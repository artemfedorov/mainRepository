package  
{
	import Utils.AssetLoader;
	
	import entities.Item;
	
	import interfaces.BaseInterfaceView;
	
	import lines.BaseLinesView;
	
	import model.BaseGame;
	
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author 
	 */
	public class RootClass extends Sprite 
	{
		private var _pool:Vector.<Item> = new Vector.<Item>;
		private var _loadAssetCounter:uint;
		private var _loadQueue:Array = [];
		
		/**
		 * 
		 * 
		 */
		public function RootClass() 
		{
			super();
			Facade.root = this;
			
			initQueue();
		}
		
		protected function initQueue():void
		{
			addLoadQueue(BaseLinesView.path, BaseLinesView.atlasesNames);
			addLoadQueue(BaseGame.path, BaseGame.atlasesNames);
			addLoadQueue(BaseInterfaceView.path, BaseInterfaceView.atlasesNames);
		}		
		
		

		protected function onLoadedGameAssets():void 
		{
			if (loadQueue.length == 0)
			{
				startGame();
				return;
			}
			var element:Object = loadQueue.pop();
			AssetLoader.loadAsset(element.path, element.atlases, onLoadedGameAssets);

		}
		
		protected function startGame():void
		{
			var game:BaseGame = new BaseGame();
			addChild(game);
		}
		
		public function addLoadQueue($path:String, $atlases:Array):void
		{
			loadQueue.push({path:$path, atlases:$atlases});
		}
		
		public function poolIn($item:Item):void
		{
			_pool.push($item);
		}
		
		public function poolOut():Item
		{
			var item:Item = _pool.pop();
			//trace(_pool.length);
			return item;
		}
		
		public function get loadAssetCounter():uint 
		{
			return _loadAssetCounter;
		}
		
		public function set loadAssetCounter(value:uint):void 
		{
			_loadAssetCounter = value;
		}
				
		public function get loadQueue():Array
		{
			return _loadQueue;
		}

		public function set loadQueue(value:Array):void
		{
			_loadQueue = value;
		}
		
	}

}