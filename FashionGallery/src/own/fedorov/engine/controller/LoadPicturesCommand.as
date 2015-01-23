package own.fedorov.engine.controller 
{
	/*
	Here is I am going to load all the images for showing through the "FashionGallery Engine"
	All the images will be saved into Vector instance and can be removed if it needed.
	Also, I need to have pre-loading procedure to be sure if an image is unique at the list and so on.
	 */
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import org.robotlegs.mvcs.Command;
	
	import own.fedorov.engine.Constants;
	import own.fedorov.engine.events.GalleryEvent;
	import own.fedorov.engine.model.MainModel;
	
	/**
	 * ...
	 * @author Artem Fedorov aka Wizard
	 */
	
	public class LoadPicturesCommand extends Command
	{
		public function LoadPicturesCommand() { }
		
		
		[Inject]
		public var mainModel:MainModel;
		
		private var _picPaths:Vector.<String>;
		private var _loader:Loader;
		private var _currentIndex:uint;

		
		override public function execute():void
		{
			_picPaths = Constants.PICTURES;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoadHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			load();
		}
		
		
		private function load():void
		{
			_loader.load(new URLRequest(_picPaths[_currentIndex]));			
		}
		
		private function imageLoadHandler(event:Event):void
		{
			
			var info:LoaderInfo = LoaderInfo(event.currentTarget);
			if(_currentIndex + 1 < _picPaths.length) 
			{
				_currentIndex++;
				var container:MovieClip = new MovieClip();
				container.addChild(info.content as Bitmap);
				mainModel.addPicture(container);
				load();
			}
			else
			{
				info.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageLoadHandler);
				info.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				eventDispatcher.dispatchEvent(new GalleryEvent(GalleryEvent.LOAD_COMPLETE));
			}
		}
		
		private function errorHandler(event:ErrorEvent):void
		{
			throw new Error("bad link or internet disconnect");
		}
	}
}