package com.looksLike.utils 
{
	import art.popup.upload.UploadFromComputerContainer;
	import com.adobe.images.JPGEncoder;
	import com.greensock.TweenMax;
	import com.ryan.geom.FreeTransformManager;
	import controllers.server.ServerController;
	import fl.controls.Button;
	import flash.display.SmartBitmapBitmapBitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import utils.CropUtil;
	import utils.files.Uploader;
	
	/**
	 * ...
	 * @author Jack Klimov
	 */
	public class UploadFromComputerParent extends Sprite 
	{
		// COMPONENTS
		public var fUpload_btn:Button;
		public var fBrowse_btn:Button;
		public var fClose_btn:Button;
		public var fPathToFile_tf:TextField;
		public var fContainerForImage_mc:UploadFromComputerContainer;
		public var fAlphaMask:MovieClip;
		public var fCropBounds:MovieClip;
		public var fUploadStatus:MovieClip;
		
		// VARS
		private var file:FileReference = new FileReference();
		private var fts:FreeTransformManager;
		public  var priority:String;
		
		public function UploadFromComputerParent() 
		{
			
			onRegister();
			
			
		}
		
		private function onRegister():void 
		{
			file.addEventListener( Event.CANCEL, onCancelFile );
            file.addEventListener( Event.COMPLETE, onCompleteFile );
            file.addEventListener( IOErrorEvent.IO_ERROR, onIOErrorFile );
            file.addEventListener( Event.OPEN, onOpenFile );
            file.addEventListener( ProgressEvent.PROGRESS, onProgressFile );
            file.addEventListener( Event.SELECT, onSelectFile );
            file.addEventListener( DataEvent.UPLOAD_COMPLETE_DATA, onUploadCompleteFile );  
			
			this.fBrowse_btn.addEventListener(MouseEvent.CLICK, onBrowseClick);
			this.fUpload_btn.addEventListener(MouseEvent.CLICK, onUploadClick);
			this.fClose_btn.addEventListener(MouseEvent.CLICK, onCloseClick);
			
			this.fContainerForImage_mc.fAvatarContainer.fLoader.addEventListener(MouseEvent.MOUSE_DOWN, onLoaderMouseDown);
			this.fContainerForImage_mc.fAvatarContainer.fLoader.addEventListener(MouseEvent.MOUSE_UP, onLoaderMouseUp);
			
			// Set up FreeTransformManager
			fts = new FreeTransformManager(false);
			fts.registerSprite(this.fContainerForImage_mc.fAvatarContainer);
			this.fAlphaMask.mouseEnabled = false;
			this.fUploadStatus.visible = false;
			this.fContainerForImage_mc.fCropBounds.mouseEnabled = false;
			this.fContainerForImage_mc.fCropBounds.visible = false;
			
		}
		
		private function onCloseClick(e:MouseEvent):void 
		{
			this.visible = false;
		}
		
		private function onLoaderMouseUp(e:MouseEvent):void 
		{
			//this.fContainerForImage_mc.fAvatarContainer.stopDrag();
		}
		
		private function onLoaderMouseDown(e:MouseEvent):void 
		{
			//this.fContainerForImage_mc.fAvatarContainer.startDrag(false);
		}
		
		private function onUploadCompleteFile(e:DataEvent):void 
		{
			trace();
		}
		
		private function onSelectFile(e:Event):void 
		{			
			fPathToFile_tf.text = (e.currentTarget as FileReference).name;
			(e.currentTarget as FileReference).load();
		}
		
		private function onProgressFile(e:ProgressEvent):void 
		{
			
		}
		
		private function onOpenFile(e:Event):void 
		{
			trace();
		}
		
		private function onIOErrorFile(e:IOErrorEvent):void 
		{
			
		}
		
		private function onCompleteFile(e:Event):void 
		{
			trace('File.data - ready to convert!');
			this.fContainerForImage_mc.fAvatarContainer.fLoader.loadBytes((e.currentTarget as FileReference).data);
		}
		
		private function onCancelFile(e:Event):void 
		{
			
		}
		
		/** загружаем файл на сервер */
		private function onUploadClick(e:MouseEvent):void 
		{
			this.fUploadStatus.visible = true;
			
			var resultSmartBitmapBitmapBitmap:SmartBitmapBitmapBitmap = CropUtil.crop(this.fContainerForImage_mc, this.fContainerForImage_mc.fCropBounds.width, this.fContainerForImage_mc.fCropBounds.height, fContainerForImage_mc.fCropBounds.x, fContainerForImage_mc.fCropBounds.y);
			resultSmartBitmapBitmapBitmap.smoothing = true;
			
			//encode BitmapData to JPG 
            var encoder:JPGEncoder = new JPGEncoder(100);
            var rawBytes:ByteArray = encoder.encode(resultBitmap.BitmapData);
			
			Uploader.instance.loadByteArrayAsImage(rawBytes, onUploadImageComplete);
		}
		
		private function onUploadImageComplete($data:Object):void 
		{
			//trace($data);
			$data.priority = priority;
			ServerController.instance.updateUserAvatar($data, onUpdateUserAvatar);
		}
		
		private function onUpdateUserAvatar($data:Object):void 
		{
			trace($data);			
			this.fUploadStatus.visible = false;
		}
		
		/** НАЖАЛИ НА КНОПКУ выбрать файл */
		private function onBrowseClick(e:MouseEvent):void 
		{
			var filefilters:Array = [ new FileFilter('Images', '*.jpg') ]; // TODO add other file filters
            file.browse( filefilters );
		}
		
	}

}