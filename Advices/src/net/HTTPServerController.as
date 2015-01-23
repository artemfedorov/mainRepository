package net
{	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author rocket
	 */
	public class HTTPServerController
	{		
		private static var _urlLoader		:URLLoader;
		private static var _urlVariables	:URLVariables;
		public static var _urlRequest		:URLRequest = new URLRequest();
		private static var _serverData		:Object;
		
		public function HTTPServerController() 
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		 * Инициализация
		 */
		private function init():void 
		{
			
		}

		/**
		 * Функция отправки запроса на сервер
		 */		
		public static function send($dataToSend:Object, $callbackComplete:Function, $callbackError:Function = null):void
		{
			_urlVariables = new URLVariables();
			_urlRequest.url = Config.mainURL;
			_urlRequest.method = URLRequestMethod.POST;
			_urlRequest.data = _urlVariables;
			
			 var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, $callbackComplete, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.DISK_ERROR, onServerErrorHandler, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onServerErrorHandler, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.VERIFY_ERROR, onServerErrorHandler, false, 0, true);
			_urlVariables.data = JSON.stringify($dataToSend);
			trace("HTTP > REQUEST:", _urlVariables.data);
			
			urlLoader.load(_urlRequest);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Events handlers
		//
		//--------------------------------------------------------------------------
		/**
		 *  
		 * @param e
		 * 
		 */		
		private static function onServerCompleteHandler(e:Event):void 
		{
			trace("RESPONSE:", e.target.data);
			_serverData = JSON.parse(e.target.data);
			//GlobalDispatcher.dispatch(new ApplicationEvents(AppEventConstants.SERVER_RESPONSE, _serverData));
			
		}
		
		/**
		 * Ошибка загрузки
		 * @param	e
		 */
		private static function onServerErrorHandler(e:IOErrorEvent):void 
		{
			trace("Server ERROR", e.text);
		}
		
	
		//--------------------------------------------------------------------------
		//
		//  Getters&setters
		//
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
		
	}

}