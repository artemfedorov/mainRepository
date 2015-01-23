package own.fedorov.engine.events
{
	import flash.events.Event;
	
	
	/**
	 * ...
	 * @author Artem Fedorov aka Wizard
	 */
	
	
	public class GalleryEvent extends Event
	{
		public function GalleryEvent(type:String, data:* = null):void
		{
			super(type);
			_data = data;
		}
		
		public static const IMAGE_CLICK				:String = "imageClick";
		public static const LOAD_COMPLETE			:String = "loadComplete";
		public static const CLOSE_PREVIEW			:String = "closePreview";
		public static const LAYOUT_CREATED			:String = "LayoutCreated";
		public static const ON_LAYOUT_CREATED		:String = "onLayoutCreated";
		public static const ON_INSERT_NEW_PICTURE	:String = "onInsertNewPicture";
		
		override public function clone():Event
		{
			return new GalleryEvent(type, _data);
		}
		
		override public function toString():String
		{
			return formatToString("GalleryEvent", "type", "data");
		}
		
		public function get data():* { return _data; }
		
		private var _data:*;
	}
}