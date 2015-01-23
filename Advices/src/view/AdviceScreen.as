package view
{
	import events.ApplicationEvents;
	import events.GlobalDispatcher;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ScrollText;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	import feathers.skins.StandardIcons;
	
	import flash.events.Event;
	
	import model.C;
	
	import net.APIController;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class AdviceScreen extends Screen
	{
		private var _backButton:Button;
		private var _giveAdviceButton:Button;
		private var _optionsButton:Button;
		
		private var _advice:ScrollText;
		private var _headerAdvice:ScrollText;
		private var _mode:String = C.NEW_MODE;
		private var _editedAdvice:Object;
		private var _categoryListCollection:ListCollection;
		
		private var _categoryList:List;
		private var _selectedCategory:int = -1;
		private var _data:Object;
		
		
		public function AdviceScreen()
		{
			super();
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
			GlobalDispatcher.addListener(C.RIGHT_BUTTON_TRIGGERED, onLikePressed);
			GlobalDispatcher.addListener(C.CENTER_BUTTON_TRIGGERED, onCentralPressed);
			GlobalDispatcher.addListener(C.LEFT_BUTTON_TRIGGERED, onLeftPressed);
		}
		
		private function onCentralPressed(e:ApplicationEvents):void
		{
			if(e.params == "Подписаться") Facade._centerHeaderButton.label = "Отписаться";
			if(e.params == "Отписаться") Facade._centerHeaderButton.label = "Подписаться";
			GlobalDispatcher.dispatch(C.DISCRIBE, {name:data.owner_id + "?", action:e.params}); 
		}
		
		private function onLeftPressed(e:ApplicationEvents):void
		{
			if(e.params.name == "Назад")
			{
				owner.showScreen(Facade.screenContainer.askedAdviceScreen);
				Facade.screenContainer.showTabBar();
			}
		}		
		
		protected function initializeHandler(event:starling.events.Event):void
		{
			setSize(stage.stageWidth, stage.stageHeight - Facade.tabs.height);
			var vLayout:VerticalLayout = new VerticalLayout();
			vLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			vLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			
			var container:ScrollContainer = new ScrollContainer();
			container.width = this.width;
			container.height = stage.stageHeight - Facade.header.height;
			container.y = Facade.header.height
			container.layout = vLayout;
			
			this.addChild(container);
			
			_headerAdvice = new ScrollText();
			_headerAdvice.border = true; 
			_headerAdvice.borderColor = 0xFEFEFE;
			_headerAdvice.padding = 20;
			container.addChild(_headerAdvice);
			_headerAdvice.width = this.width;
			_headerAdvice.y = Facade.header.height;
			_headerAdvice.validate();
			
			_advice = new ScrollText();
			_advice.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			_advice.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
			_advice.interactionMode = ScrollText.INTERACTION_MODE_TOUCH_AND_SCROLL_BARS;
			_advice.padding = 20;
			container.addChild(_advice);
			_advice.width = this.width;
			_advice.height = stage.stageHeight - Facade.header.height;
			_advice.y = Facade.header.height + _headerAdvice.height;
			_advice.validate();
			Facade._centerHeaderButton.visible = true;
			this.validate();
		}
		
		
		
		private function onLikePressed(e:ApplicationEvents):void
		{
			if(e.params == "Нравится") Facade.rightHeaderButton.label = "Не нравится";
			if(e.params == "Не нравится") Facade.rightHeaderButton.label = "Нравится";
			APIController.like(_data.id, onLike);
		}		
		
		private function onLike(e:flash.events.Event):void
		{
			var data:Object = JSON.parse(e.target.data as String);  trace("RESPONSE:", e.target.data as String);
			if (data.hasOwnProperty("error"))
			{
				return;
			}
		}		
		
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
			_headerAdvice.text = _data.header;
			_advice.text = _data.text;
			if((_data.likes as Array).indexOf(String(Facade.model.profileVO.id)) > -1) 
				Facade.rightHeaderButton.label = "Не нравится";
			else 
				Facade.rightHeaderButton.label = "Нравится";
			
			if(Facade.model.subscriptions.indexOf(_data.owner_id + "?") > -1) 
				Facade._centerHeaderButton.label = "Отписаться";
			else 
				Facade._centerHeaderButton.label = "Подписаться";
				
		}
		
		private function accessorySourceFunction(item:Object):Texture
		{
			return StandardIcons.listDrillDownAccessoryTexture;
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			Facade._centerHeaderButton.visible = false;
			GlobalDispatcher.removeListener(C.LEFT_BUTTON_TRIGGERED, onLeftPressed);
			GlobalDispatcher.removeListener(C.RIGHT_BUTTON_TRIGGERED, onLikePressed);
			removeEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
	}
	
}
