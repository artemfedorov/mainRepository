package view
{
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.Screen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.skins.StandardIcons;
	import feathers.system.DeviceCapabilities;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.textures.Texture;
	
	//[Event(name="showLoginScreen",type="starling.events.Event")]
	
	public class MainScreen extends Screen
	{
		public static const SHOW_LOGIN_SCREEN:String = "showLoginScreen";
		public static const SHOW_REGISTER_SCREEN:String = "showRegisterScreen";
		
		public function MainScreen()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		private var _list:List;
		private var _backButton:Button;
		private var _optionsButton:Button;
		
		protected function initializeHandler(event:Event):void
		{
			this.layout = new AnchorLayout();
			
			this.dispatchEventWith(SHOW_LOGIN_SCREEN);
			this._list = new List();
			this._list.dataProvider = new ListCollection(
				[
					{ label: "Login", event: SHOW_LOGIN_SCREEN },
					{ label: "Login", event: SHOW_LOGIN_SCREEN },
					{ label: "Timulka", event: SHOW_LOGIN_SCREEN },
					{ label: "Login", event: SHOW_LOGIN_SCREEN },
					{ label: "Login", event: SHOW_LOGIN_SCREEN },
					{ label: "Ira", event: SHOW_LOGIN_SCREEN },
					{ label: "Login", event: SHOW_LOGIN_SCREEN },
					{ label: "Login", event: SHOW_LOGIN_SCREEN },
					{ label: "Login", event: SHOW_LOGIN_SCREEN },
					{ label: "Artem", event: SHOW_LOGIN_SCREEN },
					{ label: "Login", event: SHOW_LOGIN_SCREEN },
					{ label: "Login", event: SHOW_LOGIN_SCREEN },
					{ label: "Timulka", event: SHOW_LOGIN_SCREEN },
					{ label: "Login", event: SHOW_LOGIN_SCREEN },
					{ label: "Login", event: SHOW_LOGIN_SCREEN },
					{ label: "Login", event: SHOW_LOGIN_SCREEN },
					{ label: "Timulka", event: SHOW_LOGIN_SCREEN },
					{ label: "Register", event: SHOW_REGISTER_SCREEN }
				]);
			
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this._list.clipContent = false;
			this._list.autoHideBackground = true;
			this._list.addEventListener(Event.CHANGE, list_changeHandler);
			
			var itemRendererAccessorySourceFunction:Function = null;
			
			this._list.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				
				//enable the quick hit area to optimize hit tests when an item
				//is only selectable and doesn't have interactive children.
				renderer.isQuickHitAreaEnabled = true;
				
				renderer.labelField = "label";
				renderer.accessorySourceFunction = itemRendererAccessorySourceFunction;
				return renderer;
			};
			
			this.addChild(this._list);
		}
		
		
		
		
		
		private function accessorySourceFunction(item:Object):Texture
		{
			return StandardIcons.listDrillDownAccessoryTexture;
		}
		
		private function list_changeHandler(event:Event):void
		{
			const eventType:String = this._list.selectedItem.event as String;
			this.dispatchEventWith(eventType);
		}
	}
}
