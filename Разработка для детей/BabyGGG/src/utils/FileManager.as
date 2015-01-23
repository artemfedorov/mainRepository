//BaseEngine

package utils
{
	import superClasses.BaseClass;
	import flash.text.Font;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	/**
	*
	*@author Artem.Fedorov
	*/
	
	public class FileManager extends BaseClass
	{
		//Constants
		
		
		//Privates
		private var _loadedFiles:Array = [];
		private var _currentIndex:int;	
		
		private static var _xml:XML;
		
		private static var _filesToLoad:Array = [];
		private static var _loadedFilesLoaderInfo:Array = [];
		private static var _loadedBinaryFiles:Array = [];
		
		private static var _settingsLoader:URLLoader;		
		static private var _loadedFilesCount:int;
		static private var _startLoadedFiles:int;
		static private var _totalFilesSize:int;
		static private var _fromByteArray:Boolean;
		static private var _localizationLoader:URLLoader;

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public static function addFilesToLoad($filesToLoad:Array, $bynary:Boolean = false):void
		{
			if(_filesToLoad.length == 0) 
			{
				_filesToLoad = $filesToLoad;
				loadFiles($filesToLoad, $bynary);
			} else {
				_filesToLoad.concat($filesToLoad);
				loadFiles($filesToLoad);
			}
		}
		
		
		private static function loadFiles($filesToLoad:Array, $bynary:Boolean = false,  $callBack:Function = null):void
		{
			/*for (var i:int = 0; i < $filesToLoad.length; i++)
			{
				var cont:LoaderContext = new LoaderContext();
				cont.checkPolicyFile = true;
				cont.securityDomain = 	 SecurityDomain.currentDomain;
				cont.applicationDomain = ApplicationDomain.currentDomain;
				
				var request:URLRequest = new URLRequest($filesToLoad[i]);
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadCompleteHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,  onLoadErrorHandler);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,  onLoadProgressHandler);
				loader.contentLoaderInfo.addEventListener(Event.INIT,  onLoadOpenHandler);
				if(Security.sandboxType == Security.REMOTE)
				{
					loader.load(request,cont);
				}
				else
				{
					loader.load(request);	
				}
			}*/
			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
				//loaderContext.securityDomain = SecurityDomain.currentDomain;
			
			if ($bynary)
			{
				var request:URLRequest = new URLRequest($filesToLoad[0]); 
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				urlLoader.addEventListener(Event.COMPLETE, onUrlLoaderLoadCompleteHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR,  onUrlLoaderLoadErrorHandler);
				urlLoader.addEventListener(ProgressEvent.PROGRESS,  onUrlLoaderLoadProgressHandler);
				urlLoader.load(request); 
			}
			else
			{
				if (GameFacade.mobileMode)
				{
					request = new URLRequest(GameFacade.serverData.settingsURL+$filesToLoad[0]);
				}
				else
				{
					if (GameFacade.serverData.settingsURL)
					{
						trace (GameFacade.serverData.settingsURL);
						var context2:LoaderContext = new LoaderContext();
						context2.applicationDomain = ApplicationDomain.currentDomain;
						try 
						{
							context2.securityDomain = SecurityDomain.currentDomain;	
						}
						catch(e:Error)
						{
							trace (e);
						}
						request = new URLRequest(GameFacade.serverData.settingsURL+$filesToLoad[0]);
					}
					else
					{
						request = new URLRequest($filesToLoad[0]);	
					}
					
				}
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadCompleteHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,  onLoadErrorHandler);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,  onLoadProgressHandler);
				if (!_fromByteArray)
				{
					if (GameFacade.mobileMode)
					{
						
						var swfDataLoader:URLLoader = new URLLoader;
						swfDataLoader.dataFormat = URLLoaderDataFormat.BINARY;
						
						swfDataLoader.addEventListener(Event.COMPLETE , sfwDataLoaderCompleteHandler);
						swfDataLoader.load(request);
						
						function sfwDataLoaderCompleteHandler(e:Event):void
						{
							if (e && e.target && e.target.data)
							{
								var context:LoaderContext = new LoaderContext();
								context.applicationDomain = ApplicationDomain.currentDomain;
								try{
								context["allowCodeImport"] = true;
								context["allowLoadBytesCodeExecution"] = true;
								}catch(e:Error)
								{
									trace (e);
								}
								
								
								loader.loadBytes(e.target.data as ByteArray, context);
							}
						}
						
						
						
					
					}
					else
					{
						if (GameFacade.serverData.settingsURL)
						{
							loader.load(request,context2);	
						}
						else
						{
							loader.load(request);		
						}
					
					}
				}
				else
				{
					
					loader.loadBytes($filesToLoad[0].data, loaderContext); 
				}
			}
		}
		
		static private function onUrlLoaderLoadProgressHandler(e:ProgressEvent):void 
		{
			
		}
		
		static private function onUrlLoaderLoadErrorHandler(e:IOErrorEvent):void 
		{
			
		}
		
		static private function onUrlLoaderLoadCompleteHandler(e:Event):void 
		{			
			trace("Файл загружен");
			_loadedBinaryFiles.push(e.target);
			
			_loadedFilesCount++;
			
			_filesToLoad.shift();
			if (_filesToLoad.length > 0)
			{
				loadFiles(_filesToLoad, true);
			} else {
				trace("Файлы загружены");
				_filesToLoad = _loadedBinaryFiles;
				_fromByteArray = true;
				decrypt(_loadedBinaryFiles);
				loadFiles(_loadedBinaryFiles, false);
			}			
			e.target.removeEventListener(IOErrorEvent.IO_ERROR,  onUrlLoaderLoadErrorHandler);
			e.target.removeEventListener(ProgressEvent.PROGRESS,  onUrlLoaderLoadProgressHandler);
			e.target.removeEventListener(Event.COMPLETE, onUrlLoaderLoadCompleteHandler);
		}

		
		
		static private function XOR(binaryData:ByteArray, key:String = "123"):void
		{
            var keyIndex:Number = 0;
            for (var i:Number = 0; i < binaryData.length; i++)
			{
                binaryData[i] = binaryData[i] ^ key.charCodeAt(keyIndex);
                keyIndex++;
                if(keyIndex >= key.length) keyIndex = 0;
            }
        }
		
		static private function decrypt($loadedBinaryFiles:Array):void 
		{
			for (var i:int = 0; i < $loadedBinaryFiles.length; i++) 
			{
				XOR($loadedBinaryFiles[i].data);
			}
		}
		
		public static function onLoadOpenHandler(event:Event):void 
		{
			trace("Началась загрузка файла", event.target.url);
			
			_startLoadedFiles++;
			_totalFilesSize += event.target.bytesTotal;
			//if (_startLoadedFiles == _filesToLoad.length)
			//	GlobalDispatcher.dispatch(new ApplicationEvents(ModelEventConstants.FILE_LOAD_START, _totalFilesSize));
		}
		
		/*public static function init():void
		{
			_settingsLoader = new URLLoader();
			_settingsLoader.addEventListener(IOErrorEvent.IO_ERROR, onSettingsErrorHandler);
			_settingsLoader.addEventListener(Event.COMPLETE, onSettingsCmpleteHandler);
			
			_localizationLoader = new URLLoader();
			_localizationLoader.addEventListener(IOErrorEvent.IO_ERROR, onLocalizationErrorHandler);
			_localizationLoader.addEventListener(Event.COMPLETE, onLocalizationCmpleteHandler);
			
			if(GameFacade.serverData.lang)
				_localizationLoader.load(new URLRequest(GameFacade.serverData.gameURL + "localizations/localization_" + GameFacade.serverData.lang + ".xml"));
			
			trace ("setting url = ",GameFacade.serverData.settingsURL);
			if (GameFacade.serverData.settingsURL == null)
			{
				_settingsLoader.load(new URLRequest(GameFacade.serverData.gameURL + "settings.xml"));
			}
			else
			{
				trace ("setting url = ",GameFacade.serverData.settingsURL);
				_settingsLoader.load(new URLRequest(GameFacade.serverData.settingsURL+"settings.xml"));
			}
		}*/
		
		/*static private function onLocalizationCmpleteHandler(e:Event):void 
		{
			LocalizationManager.localizationXML = new XML(_localizationLoader.data);
		}
		
		static private function onLocalizationErrorHandler(e:IOErrorEvent):void 
		{
			trace("Ошибка загрузки файла локализации", e.text);
		}*/
		
		
		//--------------------------------------------------------------------------
		//
		//  Events handlers
		//
		//--------------------------------------------------------------------------
		/**
		 * Получение URL-адресов ассетов графики, управления view и шаблона игры.
		 * Изменяется модель - config. 
		 * @param event
		 * 
		 */		
		protected static function onSettingsCmpleteHandler(event:Event):void
		{
			var config:ConfigurationVO = new ConfigurationVO();
			_xml = new XML(_settingsLoader.data);
			GameFacade.baseEngineModel.parseConfig(_xml);
		}
		
		protected static function onSettingsErrorHandler(event:IOErrorEvent):void
		{
			trace("Ошибка загрузки файла настроек", event.text);
		}
		
		protected static function onLoadProgressHandler(event:ProgressEvent):void
		{
			//trace(event.bytesTotal, "/", event.bytesLoaded);
			GlobalDispatcher.dispatch(new ApplicationEvents(ModelEventConstants.FILE_PROGRESS, event));
		}
		
		protected static function onLoadErrorHandler(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			trace("Ошибка загрузки файла", event.text);
			event.target.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadErrorHandler);
			_filesToLoad.shift();
			
		}		
		
		/**
		 * Все файлы загружены.
		 * @param event
		 * 
		 */		
		protected static function onLoadCompleteHandler(event:Event):void
		{
			trace("Файл", event.target.url, "загружен");
			_loadedFilesLoaderInfo.push(event.target);
			
			_loadedFilesCount++;
			
			_filesToLoad.shift();
			if (_filesToLoad.length > 0)
			{
				loadFiles(_filesToLoad, false);
				GlobalDispatcher.dispatch(new ApplicationEvents(ModelEventConstants.FILE_LOADED));
			} else {
				_fromByteArray = false;
				GlobalDispatcher.dispatch(new ApplicationEvents(ModelEventConstants.ALL_FILES_LOADED));
			}			
			event.target.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadCompleteHandler);
			event.target.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,  onLoadErrorHandler);
			event.target.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,  onLoadProgressHandler);
		}
		
		
		protected static function onOpenHandler(event:Event):void
		{
			// TODO Auto-generated method stub	
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
		public static function getMovieClipByName($movieClipName:String):MovieClip
		{
			if (getClassByName($movieClipName))
				return new(getClassByName($movieClipName)) as MovieClip;
			
			//trace("Не найден мувиклип", $movieClipName);
			return null;
		}
		
		public static function getSoundByName($soundName:String):Sound
		{
			if (getClassByName($soundName))
				return new(getClassByName($soundName)) as Sound;
			
			//trace("Не найден звук", $soundName);
			return null;
		}
		
		/**
		 * Получение шрифта по имени
		 * @param	$fontName имя шрифта
		 * @return полученый шрифт
		 */
		public static function getFontByName($fontName:String):Font
		{
			if (getClassByName($fontName))
				return new(getClassByName($fontName)) as Font;
			
			//trace("Не найден мувиклип", $movieClipName);
			return null;
		}
		
		/**
		 * Получение, соответствующего шаблону, графического элемента.
		 * @param $patternName
		 * @return 
		 * 
		 */		
		public static function findGraphicName($patternName:String):String
		{
			var graphicName:String = _xml.graphicSwapNames.name.(@patternName == $patternName).@graphicName;
			return (graphicName == "") ? $patternName : graphicName;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters&setters
		//
		//--------------------------------------------------------------------------
		static public function get loadedFilesLoaderInfo():Array 
		{
			return _loadedFilesLoaderInfo;
		}
		//--------------------------------------------------------------------------
		//
		//  Logs
		//
		//--------------------------------------------------------------------------
	}
}