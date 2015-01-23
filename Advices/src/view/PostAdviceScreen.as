package view
{
	import events.ApplicationEvents;
	import events.GlobalDispatcher;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TextInput;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.skins.StandardIcons;
	
	import model.C;
	
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class PostAdviceScreen extends Screen
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
		
		private var _newAdvice:TextInput;
		private var _headerAdvice:TextInput;
		private var _mode:String = C.NEW_MODE;
		private var _editedAdvice:Object;
		private var _categoryListCollection:ListCollection;

		private var _categoryList:List;
		private var _selectedCategory:int = -1;
		
		
		
		public function PostAdviceScreen()
		{
			super();
			GlobalDispatcher.addListener(C.RIGHT_BUTTON_TRIGGERED, onRightButtonTriggered);
			GlobalDispatcher.addListener(C.LEFT_BUTTON_TRIGGERED, onLeftButtonTriggered);
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		public function editMode($data:Object):void
		{
			_mode = C.EDIT_MODE;
			_editedAdvice = $data;
			_headerAdvice.text = $data.header;
			_newAdvice.text = $data.text;
			
			selectCategory(_editedAdvice.category_id);
		}
		
		private function selectCategory($id:int):void
		{
			for (var i:int = 0; i < _categoryList.dataProvider.data.length; i++) 
			{
				if(_categoryList.dataProvider.data[i].id == $id) 
				{
					_categoryList.selectedIndex = i;
					return;
				}
			}
			
		}
		
		private function onPickUpCategory(e:Event):void
		{
			_selectedCategory = _categoryList.dataProvider.data[_categoryList.selectedIndex].id;
		}		
		
		
		private function onLeftButtonTriggered(e:ApplicationEvents):void
		{
			GlobalDispatcher.dispatch(C.CANCEL_POST_ADVICE);
		}
		
		private function onRightButtonTriggered(e:ApplicationEvents):void
		{
			if(_newAdvice.text.length == 0) 
			{
				Alert.show("Ваш совет пуст", "",new ListCollection([{ label: "OK"}]) );
				return;
			}
			if(_headerAdvice.text.length == 0) 
			{
				Alert.show("Заголовок пуст", "",new ListCollection([{ label: "OK"}]) );
				return;
			}
			if(_selectedCategory == -1) 
			{
				Alert.show("Не выбрана категория", "",new ListCollection([{ label: "OK"}]) );
				return;
			}
			if(_editedAdvice) GlobalDispatcher.dispatch(C.SAVE_POST_ADVICE, {mode:_mode, advice_id:_editedAdvice.id, category_id:_selectedCategory, header:_headerAdvice.text, text:_newAdvice.text, likes:_editedAdvice.likes});
				 else GlobalDispatcher.dispatch(C.SAVE_POST_ADVICE, {mode:_mode, category_id:_selectedCategory, header:_headerAdvice.text, text:_newAdvice.text});
		}		
		
	
		
		protected function initializeHandler(event:Event):void
		{
			setSize(stage.stageWidth, stage.stageHeight - Facade.tabs.height);
			var vLayout:VerticalLayout = new VerticalLayout();
			vLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			vLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			
			_headerAdvice = new TextInput();
			_headerAdvice.padding = 20;
			_headerAdvice.prompt = "Введите сюда заголовок совета";
			_headerAdvice.maxChars = 100;
			_headerAdvice.textEditorProperties.fontFamily = "Verdana";
			_headerAdvice.textEditorProperties.fontSize = 35;
			_headerAdvice.textEditorProperties.color = 0xffffff;
			this.addChild(_headerAdvice);
			_headerAdvice.width = this.width;
			_headerAdvice.y = Facade.header.height;
			_headerAdvice.validate();
			
			_newAdvice = new TextInput();
			_newAdvice.padding = 20;
			_newAdvice.prompt = "Поделитесь здесь советом со всем миром!";
			_newAdvice.textEditorProperties.fontFamily = "Verdana";
			_newAdvice.textEditorProperties.fontSize = 35;
			_newAdvice.textEditorProperties.color = 0xffffff;
			this.addChild(_newAdvice);
			_newAdvice.width = this.width;
			_newAdvice.height = stage.stageHeight / 2 - Facade.header.height - _headerAdvice.height;
			_newAdvice.y = Facade.header.height + _headerAdvice.height;
			_newAdvice.validate();
			
			
			
			var hLayout:HorizontalLayout = new HorizontalLayout();
			hLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			hLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			
			var bottomScrollContainer:ScrollContainer = new ScrollContainer();
			bottomScrollContainer.width = this.width;
			bottomScrollContainer.height = stage.stageHeight / 2;
			bottomScrollContainer.y = stage.stageHeight / 2;
			bottomScrollContainer.layout = vLayout;
			
			this.addChild(bottomScrollContainer);
			
			
			_categoryList = new List();
			_categoryList.width = this.width;
			_categoryList.height = bottomScrollContainer.height;
			_categoryList.y = bottomScrollContainer.height;
			
			_categoryListCollection = new ListCollection(Facade.model.categories);
			_categoryList.addEventListener(Event.CHANGE, onPickUpCategory);
			_categoryList.dataProvider = _categoryListCollection;
			
			var itemRendererAccessorySourceFunction:Function = null;
			itemRendererAccessorySourceFunction = this.accessorySourceFunction;
			
			_categoryList.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				
				renderer.isQuickHitAreaEnabled = true;
				
				renderer.labelField = "name";
				renderer.accessorySourceFunction = itemRendererAccessorySourceFunction;
				return renderer;
			};
			
			bottomScrollContainer.addChild(_categoryList);
			
			this.validate();
		}
		
		
		private function accessorySourceFunction(item:Object):Texture
		{
			return StandardIcons.listDrillDownAccessoryTexture;
		}
	
		
		override public function dispose():void
		{
			super.dispose();
			GlobalDispatcher.removeListener(C.RIGHT_BUTTON_TRIGGERED, onRightButtonTriggered);
			GlobalDispatcher.removeListener(C.LEFT_BUTTON_TRIGGERED, onLeftButtonTriggered);
			removeEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
	}
	
}
