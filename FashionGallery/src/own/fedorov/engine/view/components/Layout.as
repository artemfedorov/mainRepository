package own.fedorov.engine.view.components
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import own.fedorov.engine.events.GalleryEvent;
	import own.fedorov.engine.values.LayoutsData;
	
	public class Layout extends Sprite
	{
		
		private var _backs:Array;
		
		public function Layout(type:int)
		{
			super();
			
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			this.mouseEnabled = false;
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0, 0, LayoutsData.LAYOUT_WIDTH, LayoutsData.LAYOUT_HEIGHT);
			dispatchEvent(new GalleryEvent(GalleryEvent.LAYOUT_CREATED));

		}
		
		public function addPictureAt(bm:MovieClip, px:Number, py:Number):void
		{
			this.addChild(bm);
			bm.buttonMode = true;
			bm.mouseChildren = false;
			bm.x = px;
			bm.y = py;
			
		}
	}
}