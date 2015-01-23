package view
{
	import events.ApplicationEvents;
	import events.GlobalDispatcher;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	import feathers.skins.StandardIcons;
	
	import flash.display.TriangleCulling;
	import flash.events.Event;
	
	import model.C;
	
	import net.APIController;
	
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class CategoriesScreen extends Screen
	{
		private var _backButton:Button;
		private var _giveAdviceButton:Button;
		private var _optionsButton:Button;
		
		private var _subscription:TextField;
		private var _subscribers:TextField;
		private var _advices:TextField;
		private var _name:TextField;
		
		private var _subscriptionValue:TextField;
		private var _subscribersValue:TextField;
		private var _advicesValue:TextField;
		
		private static const COMPLETE:String =  "showMainScreen";
		private static const REGISTER:String =  "showRegisterScreen";
		private var _categoryListCollection:ListCollection;
		private var _categoryList:List;
		private var _selectedCategory:int;

		private var als:AdviceListScreen;
		
		
		
		public function CategoriesScreen()
		{
			super();
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		
		protected function initializeHandler(event:starling.events.Event):void
		{
			GlobalDispatcher.addListener(C.SUBSCRIPTIONS_UPDATED, onSubscriptionsUpdated);
			setSize(stage.stageWidth, stage.stageHeight - Facade.header.height - Facade.tabs.height);
			
			var vLayout:VerticalLayout = new VerticalLayout();
			vLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			vLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			this.layout = vLayout;
			
			
			_categoryList = new List();
			_categoryList.width = this.width;
			_categoryList.height = this.height;

			
			var arr:Array = [];
			for (var i:int = 0; i < Facade.model.categories.length; i++) 
			{
				var o:Object = Facade.model.categories[i];
				var b:Button = new Button();
				b.addEventListener(starling.events.Event.TRIGGERED, onSubscriptionCategory);
				if(Facade.model.isExistInList(o.id, "!")) b.label = "Отписаться";
				else b.label = "Подписаться";
				o.subscribe = b;
				arr.push(o);
			}
			
			
			_categoryListCollection = new ListCollection(arr);
			_categoryList.addEventListener(starling.events.Event.CHANGE, onPickUpCategory);
			_categoryList.dataProvider = _categoryListCollection;
			var itemRendererAccessorySourceFunction:Function = null;
			itemRendererAccessorySourceFunction = this.accessorySourceFunction;
			_categoryList.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				
				renderer.labelField = "name";
				renderer.accessoryField = "subscribe";
				
				return renderer;
			};
			
			this.addChild(_categoryList);			
			
			//this.validate();
		}
		
		
		
		private function onSubscriptionsUpdated(e:ApplicationEvents):void
		{
			var subscriptions:Array = Facade.model.subscriptions;
			var label:String;
			for (var i:int = 0; i < _categoryListCollection.data.length; i++) 
			{
				label = _categoryListCollection.data[i].id + "!";
				if(subscriptions.indexOf(label) > -1)
					_categoryListCollection.data[i].subscribe.label = "Отписаться";
				else
					_categoryListCollection.data[i].subscribe.label = "Подписаться";
			}
		}
		
		
		
		
		private function onSubscriptionCategory(e:starling.events.Event):void
		{
			var name:String = _categoryListCollection.data[(e.target as Object).parent.index].id; 
			trace(name);
			GlobalDispatcher.dispatch(C.DISCRIBE, {name:name + "!", action:(e.target as Object).label}); 
		}		
		
		
		private function onPickUpCategory(e:starling.events.Event):void
		{
			_selectedCategory = _categoryList.dataProvider.data[_categoryList.selectedIndex].id;
			APIController.getAdvicesByCategory(_selectedCategory, onGetAdvicesByCategory);
		}		
		
		
		private function onGetAdvicesByCategory(e:flash.events.Event):void
		{
			var data:Object = JSON.parse(e.target.data as String);  trace("RESPONSE:", e.target.data as String);
			if (data.hasOwnProperty("error"))
			{
				return;
			}
			if(data.data) 
			{
				for (var k:int = 0; k < data.data.length; k++) 
				{
					var likesStr:String = data.data[k].likes;
					if(likesStr == "") 
						data.data[k].likes = [];
					else 
						data.data[k].likes = JSON.parse(likesStr);
				}
				GlobalDispatcher.dispatch(C.SHOW_CATEGORY_ADVICES, data.data);
			}
		}
		
		private function accessorySourceFunction(item:Object):Texture
		{
			return StandardIcons.listDrillDownAccessoryTexture;
		}

	
		
		override public function dispose():void
		{
			_categoryList.removeEventListener(starling.events.Event.CHANGE, onPickUpCategory);
			removeEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		
	}
}
