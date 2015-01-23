package own.fedorov.engine
{
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;
	
	import own.fedorov.engine.controller.CreateLayoutCommand;
	import own.fedorov.engine.controller.ImageClickCommand;
	import own.fedorov.engine.controller.LoadPicturesCommand;
	import own.fedorov.engine.events.GalleryEvent;
	import own.fedorov.engine.model.MainModel;
	import own.fedorov.engine.view.LayoutMediator;
	import own.fedorov.engine.view.components.Layout;

	
	/**
	 * ...
	 * @author Artem Fedorov aka Wizard
	 */
	
	public class FGalleryContext extends Context
	{
		public function FGalleryContext(contextView:DisplayObjectContainer)
		{
			super(contextView);
		}
		
		override public function startup():void
		{
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, LoadPicturesCommand, ContextEvent, true);
			commandMap.mapEvent(GalleryEvent.LOAD_COMPLETE, CreateLayoutCommand,  GalleryEvent, true);
			commandMap.mapEvent(GalleryEvent.IMAGE_CLICK, ImageClickCommand, GalleryEvent);
			
			injector.mapSingleton(MainModel);
			
			mediatorMap.mapView(Layout, LayoutMediator);		
			
			super.startup();
		}
	}
}