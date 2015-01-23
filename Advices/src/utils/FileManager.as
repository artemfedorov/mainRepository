package com.looksLike.utils
{
	import com.looksLike.adobe.images.JPGEncoder;
	import com.looksLike.config.Config;
	import com.looksLike.config.imageVO;
	import com.looksLike.config.Storage;
	import com.looksLike.config.UserVO;
	import com.looksLike.events.ApplicationEvents;
	import com.looksLike.events.EventConstants;
	import com.looksLike.events.GlobalDispatcher;
	import com.looksLike.net.APIController;
	import fl.containers.UILoader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.system.Security;
	import flash.utils.ByteArray;
	

	public class FileManager
	{
		static private var fileRef:FileReference;
		public function FileManager()
		{
			
		}
		//----------------------------------------------------------------------------------------------------------
		//
		//							fileReference
		//
		//----------------------------------------------------------------------------------------------------------
		private static var _callback:Function;

		public static function fileReference(callbackSelected:Function):void
		{
			_callback = callbackSelected;
            fileRef = new FileReference(); 
            fileRef.addEventListener(Event.SELECT, onFileSelected);
            fileRef.addEventListener(Event.CANCEL, onCancel); 
            fileRef.addEventListener(IOErrorEvent.IO_ERROR, onIOError); 
            fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError); 
            var textTypeFilter:FileFilter = new FileFilter("Images (*.jpg)", "*.jpg");
            fileRef.browse([textTypeFilter]); 
		}
		
		public static function onFileSelected(evt:Event):void 
        { 
            fileRef.addEventListener(ProgressEvent.PROGRESS, onProgress); 
            fileRef.addEventListener(Event.COMPLETE, _callback); 
            fileRef.load(); 
        } 
 
        public static function onProgress(evt:ProgressEvent):void 
        { 
            trace("Loaded " + evt.bytesLoaded + " of " + evt.bytesTotal + " bytes."); 
        } 
 
        public static function onComplete(evt:Event):void 
        { 
            trace("File was successfully loaded."); 
           GlobalDispatcher.dispatch(new ApplicationEvents(EventConstants.FILE_REFERENCE_COMPLETE, evt.target.data));
        } 
 
        public static  function onCancel(evt:Event):void 
        { 
            trace("The browse request was canceled by the user."); 
        } 
 
        public static function onIOError(evt:IOErrorEvent):void 
        { 
            trace("There was an IO Error."); 
        } 
        public static function onSecurityError(evt:Event):void 
        { 
            trace("There was a security error."); 
        } 
		
		//----------------------------------------------------------------------------------------------------------
		//
		//							fileReference
		//
		//----------------------------------------------------------------------------------------------------------
		
		public static function setConfigFrom($JSONString:String):Boolean
		{
			var data:Object = JSON.parse($JSONString as String);
			if (data.error)	trace("ОШИБКА: setConfigFrom");
			else 
			{
				Config.profile = new UserVO();
			
				if (data.user.id != null) Config.profile.id = data.user.id;
				else return false;
				
				if (data.user.login != null) Config.profile.login = data.user.login;
				else return false;
				
				if (data.user.pass != null) Config.profile.pass = data.user.pass;
				else return false;
				
				if (data.user.balance != null) Config.profile.balance = data.user.balance;
				else return false;
				
				if (data.user.vip != null) Config.profile.vip = data.user.vip;
				else return false;
				
				if (data.user.ava_url != null) Config.profile.avatarURL = data.user.ava_url;
				else return false;
				
				if (data.user.name != null) Config.profile.name = data.user.name;
				else return false;
				//if (data.user.id) Config.profile.last_name 	= data.user.last_name;
				//if (data.user.id) Config.profile.email 		= data.user.email;
				//if (data.user.id) Config.profile.country 	= data.user.country;
				
			}
			return true;
			
			APIController.serverPopupCheck(e.target.data);
		}
		
		
		public static function downloadImageFromeServer($url:String, $callback:Function):void
		{
			var request:URLRequest = new URLRequest($url);
			var loader:URLLoader = new URLLoader();
			//loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, $callback, false, 0, true);
			loader.load(request); 
		}

		
		
		
		public static function uploadImageToServerStorage($bytes:BitmapData, $callback:Function = null, $altUrl:String = null, $params:String = "look"):void
		{
			var j:JPGEncoder = new JPGEncoder(100);
			var b:ByteArray = j.encode($bytes);
			var sendHeader:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			var url:String = $altUrl != null ? $altUrl : "http://37.139.31.203/swf/api/upload_image.php?client=" + $params;
			var sendReq:URLRequest = new URLRequest(url);
			sendReq.requestHeaders.push(sendHeader);
			sendReq.method = URLRequestMethod.POST;
			sendReq.data = b;
			
			var sendLoader:URLLoader = new URLLoader();
			
			sendLoader.addEventListener(Event.COMPLETE, $callback, false, 0, true);
			sendLoader.load(sendReq);
		}
		
		
		public static function encode(bitmap:Bitmap):ByteArray {
			var bytes:ByteArray = new ByteArray();
			bytes.writeBytes(bitmap.bitmapData.getPixels(bitmap.bitmapData.rect));
			return bytes;
		}

		
		/*
		public static function getBytesFromFile($url:String):ByteArray
		{
			var f:File = new File($url);
			var fs:FileStream = new FileStream();
			var ba:ByteArray = new ByteArray();
			fs.open(f, FileMode.READ);
			fs.readBytes(ba);
			fs.close();
			var j:JPGEncoder = new JPGEncoder(100);
			return ba;
		}
		*/
		
		
	}
	
	
	
}

