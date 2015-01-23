package view
{
	import events.ApplicationEvents;
	import events.GlobalDispatcher;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.Slider;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	import feathers.skins.StandardIcons;
	
	import model.C;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class AdviceListScreen extends Screen
	{
		private var _backButton:Button;
		private var _giveAdviceButton:Button;
		private var _optionsButton:Button;
		
		private var _adviceListCollection:ListCollection;
		private var _advicesList:List;
		private var _selectedAdvice:int;
		private var _data:Array;
		
		
		
		public function AdviceListScreen()
		{
			super();
			GlobalDispatcher.addListener(C.LEFT_BUTTON_TRIGGERED, onLeftPressed);
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		private function onLeftPressed(e:ApplicationEvents):void
		{
			if(e.params.name == "Назад")
			{
				owner.showScreen(ScreensContainer.CATEGORIES_SCREEN);
				Facade.screenContainer.showTabBar();
			}
		}	
		
		
		public function get data():Array
		{
			return _data;
		}

		public function set data(value:Array):void
		{
			_data = value;
			
			_adviceListCollection = new ListCollection(_data);
			_advicesList.addEventListener(Event.CHANGE, onPickUpAdvice);
			_advicesList.dataProvider = _adviceListCollection;
		}

		protected function initializeHandler(event:Event):void
		{
			setSize(stage.stageWidth, stage.stageHeight);
			this.y = Facade.header.height;
			var vLayout:VerticalLayout = new VerticalLayout();
			vLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			vLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			this.layout = vLayout;
			
			_advicesList = new List();
			_advicesList.width = this.width;
			_advicesList.height = this.height;
			_advicesList.y = 0;
			
			var itemRendererAccessorySourceFunction:Function = null;
			itemRendererAccessorySourceFunction = this.accessorySourceFunction;
			
			

			_advicesList.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				
				renderer.isQuickHitAreaEnabled = true;
				
				renderer.labelField = "header";
				renderer.accessorySourceFunction = itemRendererAccessorySourceFunction;
				return renderer;
			};
			
			_advicesList.selectedIndex = 0;
			this.addChild(_advicesList);			
			
			this.validate();
		}
		
		
		
		private function onPickUpAdvice(e:Event):void
		{
			if(_advicesList.selectedIndex == -1) return;
			
			var label:Label = new Label();
			/*for (var k:int = 0; k < data.data.length; k++) 
			{
				var likesStr:String = data.data[k].likes;
				data.data[k].likes = JSON.parse(likesStr);
			}*/
			GlobalDispatcher.dispatch(C.SHOW_ADVICE, _data[_advicesList.selectedIndex]);
		}		
		
		
		private function accessorySourceFunction(item:Object):Texture
		{
			return StandardIcons.listDrillDownAccessoryTexture;
		}
		
		override public function dispose():void
		{
			_advicesList.selectedIndex = -1;
			GlobalDispatcher.removeListener(C.LEFT_BUTTON_TRIGGERED, onLeftPressed);
			_advicesList.removeEventListener(starling.events.Event.CHANGE, onPickUpAdvice);
			removeEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
	
	}
}
