package Utils 
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	import events.C;
	import events.GlobalDispatcher;
	
	import starling.display.MovieClip;
	import starling.textures.Texture;

	/**
	 * ...
	 * @author ValeriiT Fedorov
	 */
	public class FactoryAssets 
	{
		private static var _loadedFilesLoaderInfo:Array = [];
				
		
		public static function loadGraphics():void 
		{			
			var cont:LoaderContext = new LoaderContext();
				cont.checkPolicyFile = true;
				cont.securityDomain = 	 SecurityDomain.currentDomain;
				cont.applicationDomain = ApplicationDomain.currentDomain;
			var urlRequest:URLRequest = new URLRequest("layout.swf");
			
			var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadGraphics);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,  onLoadErrorHandler);
				//loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,  onLoadProgressHandler);
				loader.load(urlRequest);
			
			function onLoadGraphics(e:Event):void
			{
				trace("SWF asset loaded");
				_loadedFilesLoaderInfo.push(e.target);
				GlobalDispatcher.dispatch(C.LOAD_FILES_COMPLETE);
			}
			
			function onLoadErrorHandler(e:IOErrorEvent):void
			{
				trace("ASDASD");
				trace("onLoadErrorHandler");
				
			}
		}
		
		
		
		public static function getTextureFromFlashMovieClip($mc:flash.display.MovieClip, $frame:int):Texture
		{
			$mc.gotoAndStop($frame);
			var m_bitmapData:BitmapData = new BitmapData($mc.width, $mc.height);
			m_bitmapData.draw($mc);
			var t:Texture = Texture.fromBitmapData(m_bitmapData);
			return t;
		}
		
		
		
		
		public static function getStarlingMovieClipFromFlashMovieClip($mcName:String):starling.display.MovieClip
		{
			var mc:flash.display.MovieClip = getMovieClipByName($mcName);
			var frames:int = mc.totalFrames;
			var tv:Vector.<Texture> = new Vector.<Texture>;
			var t:Texture;
			for (var i:int = 0; i < frames; i++) 
			{
				t = getTextureFromFlashMovieClip(mc, i);
				tv.push(t);
			}
			var smc:starling.display.MovieClip = new starling.display.MovieClip(tv, 60);
			return smc;
		}
		/**
		 * Получение класса по имени
		 * @param	$className имя класса
		 * @return полученый класс
		 */
		public static function getClassByName($className:String):Class
		{
			for each(var loaderInfo:LoaderInfo in _loadedFilesLoaderInfo)
			{
				if (loaderInfo.applicationDomain.hasDefinition($className))
					return loaderInfo.applicationDomain.getDefinition($className) as Class;
			}
			
			return null;
		}
		
		/**
		 * Получение мувиклипа по имени
		 * @param	$movieClipName имя мувиклипа
		 * @return полученый мувиклип
		 */
		public static function getMovieClipByName($movieClipName:String):flash.display.MovieClip
		{
			if (getClassByName($movieClipName))
				return new(getClassByName($movieClipName)) as flash.display.MovieClip;
			
			//trace("Не найден мувиклип", $movieClipName);
			return null;
		}
		
	}

}