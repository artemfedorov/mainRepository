package Utils 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author 
	 */
	public class ImageLoader 
	{
		
		public  var urls:Array = [];
		private  var loaders:Array = [];
		public  var images:Array = [];
		private  var callback:Function;
		private  var loaderIndex:int;
		
		
		public function ImageLoader()
		{
			
		}

		public  function load($urls:Array, $callback:Function):void 
		{
			callback = $callback;
			urls = $urls;
			for (var i:int = 0; i < urls.length; i++) 
			{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,  onLoadErrorHandler);
				// you'll want to add your other handlers here too for IOErrorEvent and Progress.
				loader.load(new URLRequest(urls[i]));
				loaders[i] = loader.contentLoaderInfo;
			}
		}
		
		 private function onLoadErrorHandler(e:Event):void 
		{
			trace("ImageLoader: onLoadErrorHandler");
		}

		private  function completeHandler(e:Event):void 
		{
			// this tells you which loader finished
			//var loaderIndex:int = loaders.indexOf(e.currentTarget); 
			// I think this will work, you may have to play with Array syntax to make sure you're not adding tons of empty items and screwing up your order.
			images[loaderIndex] = e.currentTarget.content as Bitmap; 
			loaderIndex++;
			if (images.length == urls.length) 
			{
				trace("All images loaded!");
				callback(images);
			}
		}
		
	}

}