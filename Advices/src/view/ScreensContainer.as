package view
{
	import com.greensock.TweenMax;
	
	import events.ApplicationEvents;
	import events.GlobalDispatcher;
	
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.motion.transitions.ScreenFadeTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;
	
	import model.C;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class ScreensContainer extends Screen
	{
		private var _leftHeaderButton:Button;
		private var _rightHeaderButton:Button;
		private var _centerHeaderButton:Button;
		
	
		
		public static const MAIN_SCREEN:String = "MAIN_SCREEN";
		public static const CATEGORIES_SCREEN:String = "CATEGORIES_SCREEN";
		public static const NEWS_SCREEN:String = "NEWS_SCREEN";
		public static const LOGIN_SCREEN:String = "LOGIN_SCREEN";
		public static const REGISTER_SCREEN:String = "REGISTER_SCREEN";
		public static const PROFILE_SCREEN:String = "PROFILE_SCREEN";
		public static const POST_ADVICE_SCREEN:String = "POST_ADVICE_SCREEN";
		public static const ADVICE_LIST_SCREEN:String = "ADVICE_LIST_SCREEN";
		public static const ADVICE_SCREEN:String = "ADVICE_SCREEN";
		
		
		private var _navigator:ScreenNavigator;
		private var _mainScreen:MainScreen;
		private var _transitionManager:ScreenFadeTransitionManager;

		private var _header:Header;

		private var _advicesByCategory:Array;
		private var _advice:Object;

		private var _askedAdviceScreen:String;
		
		
		
		public function ScreensContainer()
		{
			super();
			Facade.screenContainer = this;
			GlobalDispatcher.addListener(C.CANCEL_POST_ADVICE, onCancelPostADvice);
			GlobalDispatcher.addListener(C.ADVICE_POSTED, onAdvicePosted);
			GlobalDispatcher.addListener(C.SHOW_MY_ADVICE, onPostAdviceScreenShow);
			GlobalDispatcher.addListener(C.SHOW_ADVICE, onShowAdviceScreen);
			GlobalDispatcher.addListener(C.POST_ADVICE_SCREEN_SHOW, onPostAdviceScreenShow);
			GlobalDispatcher.addListener(C.NEED_LOGIN, onNeedLogin);
			GlobalDispatcher.addListener(C.SHOW_CATEGORY_ADVICES, onShowCategoryAdvices);
			GlobalDispatcher.addListener(C.ENTER_COMPLETE, onEnterComplete);
			
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
	
		public function get askedAdviceScreen():String
		{
			return _askedAdviceScreen;
		}

		public function set askedAdviceScreen(value:String):void
		{
			_askedAdviceScreen = value;
		}

		public function get rightHeaderButton():Button
		{
			return _rightHeaderButton;
		}

		public function set rightHeaderButton(value:Button):void
		{
			_rightHeaderButton = value;
		}

		protected function initializeHandler(event:Event):void
		{
			new MetalWorksMobileTheme();

			this._navigator = new ScreenNavigator();
			_navigator.setSize(stage.stageWidth, stage.stageHeight);
			this.setSize(stage.stageWidth, stage.stageHeight);
			
			this._navigator.addScreen(MAIN_SCREEN, new ScreenNavigatorItem(MainScreen));
			this._navigator.addScreen(LOGIN_SCREEN, new ScreenNavigatorItem(LoginScreen));
			this._navigator.addScreen(REGISTER_SCREEN, new ScreenNavigatorItem(RegisterScreen));
			this._navigator.addScreen(PROFILE_SCREEN, new ScreenNavigatorItem(ProfileScreen));
			this._navigator.addScreen(NEWS_SCREEN, new ScreenNavigatorItem(NewsScreen));
			this._navigator.addScreen(CATEGORIES_SCREEN, new ScreenNavigatorItem(CategoriesScreen));
			this._navigator.addScreen(POST_ADVICE_SCREEN, new ScreenNavigatorItem(PostAdviceScreen));
			this._navigator.addScreen(ADVICE_LIST_SCREEN, new ScreenNavigatorItem(AdviceListScreen));
			this._navigator.addScreen(ADVICE_SCREEN, new ScreenNavigatorItem(AdviceScreen));
			
			this.addChild(_navigator);
			
			this._navigator.addEventListener(Event.CHANGE, onChangeScreen);
			
			_header = new Header();
			_header.x = 0;
			_header.y = 0;
			//_header.height = 100;
			_header.width = this.width;
			this.addChild( _header );
		
			_header.title = "Icansay.com";
			
			GlobalDispatcher.dispatch(C.SCREEN_CONTAINER_IS_READY);
		}
		
		
		
		private function onEnterComplete(e:ApplicationEvents):void
		{
			var tabs:TabBar = new TabBar();
			tabs.dataProvider = new ListCollection(
				[
					{ label: "Категории", value:CATEGORIES_SCREEN},
					{ label:"Мне советуют" , value:NEWS_SCREEN},
					{ label:"Профиль" , value:PROFILE_SCREEN},
				]);
			this.addChild( tabs );
			tabs.validate();
			tabs.width = this.width;
			//tabs.height = 100;
			tabs.y = this.height - tabs.height;
			tabs.addEventListener(Event.CHANGE, onTabsHasChanged);
			Facade.header = _header;
			Facade.tabs = tabs;
			
			_leftHeaderButton = new Button();
			_leftHeaderButton.visible = false;
			_leftHeaderButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
			_leftHeaderButton.label = "Back";
			_leftHeaderButton.height = _header.height * 0.8;
			_leftHeaderButton.width = _header.width * 0.2;
			_leftHeaderButton.addEventListener(Event.TRIGGERED, leftHeaderButtonTriggered);
			
			_rightHeaderButton = new Button();
			Facade.rightHeaderButton = rightHeaderButton;
			_rightHeaderButton.nameList.add(Button.ICON_POSITION_RIGHT);
			_rightHeaderButton.label = "Options";
			_rightHeaderButton.height = _header.height * 0.8;
			_rightHeaderButton.width = _header.width * 0.2;
			_rightHeaderButton.addEventListener(Event.TRIGGERED, rightHeaderButtonTriggered);
			
			_centerHeaderButton = new Button();
			Facade._centerHeaderButton = _centerHeaderButton;
			_centerHeaderButton.nameList.add(Button.ICON_POSITION_RIGHT);
			_centerHeaderButton.label = "Подписаться";
			_centerHeaderButton.height = _header.height * 0.8;
			_centerHeaderButton.width = _header.width * 0.2;
			_centerHeaderButton.addEventListener(Event.TRIGGERED, centerHeaderButtonTriggered);
			_centerHeaderButton.visible = false;
			_header.leftItems = new <DisplayObject>[_leftHeaderButton];
			_header.rightItems = new <DisplayObject>[_rightHeaderButton];
			_header.centerItems = new <DisplayObject>[_centerHeaderButton];
			
			this._transitionManager = new ScreenFadeTransitionManager(_navigator );
			this._transitionManager.duration = 0.2;
			tabs.selectedIndex = 2;
		}		
		
		
		
		
		private function rightHeaderButtonTriggered(event:Event):void
		{
			GlobalDispatcher.dispatch(C.RIGHT_BUTTON_TRIGGERED, (event.target as Object).label);
		}
		
		private function centerHeaderButtonTriggered(event:Event):void
		{
			GlobalDispatcher.dispatch(C.CENTER_BUTTON_TRIGGERED, (event.target as Object).label);
		}
		
		private function leftHeaderButtonTriggered(event:Event):void
		{
			GlobalDispatcher.dispatch(C.LEFT_BUTTON_TRIGGERED, {name:(event.target as Object).label, activeScreen:this._navigator.activeScreenID});
			/*switch(this._navigator.activeScreenID)
			{
				case ADVICE_LIST_SCREEN:
					showTabBar();
					this._navigator.showScreen(CATEGORIES_SCREEN);
					break;
				case ADVICE_SCREEN:
					this._navigator.showScreen(ADVICE_LIST_SCREEN);
					break;
				
			}*/
		}
		
		
		private function onTabsHasChanged(e:Event):void
		{
			var screen:String = Facade.tabs.selectedItem.value;
			var index:int = Facade.tabs.selectedIndex;
			trace(index, screen);
			this._navigator.showScreen(screen);
		}
		
		private function onChangeScreen(e:Event):void
		{
			if(this._navigator.activeScreenID == CATEGORIES_SCREEN || this._navigator.activeScreenID == NEWS_SCREEN) 
			{
				_leftHeaderButton.visible = false;
				_rightHeaderButton.label = "Фильтры";
			}
			if(this._navigator.activeScreenID == PROFILE_SCREEN) 
			{
				_leftHeaderButton.visible = false;
				_rightHeaderButton.label = "Опции";
			}
			if(this._navigator.activeScreenID == POST_ADVICE_SCREEN) 
			{
				_leftHeaderButton.visible = true;
				_leftHeaderButton.label = "Отмена";
				_rightHeaderButton.label = "Сохранить";
			}
			
			if(this._navigator.activeScreenID == ADVICE_LIST_SCREEN) 
			{
				_leftHeaderButton.visible = true;
				_leftHeaderButton.label = "Назад";
				_rightHeaderButton.label = "Фильтры";
				(this._navigator.activeScreen as AdviceListScreen).data = _advicesByCategory;
			}
			
			if(this._navigator.activeScreenID == ADVICE_SCREEN) 
			{
				_leftHeaderButton.visible = true;
				_leftHeaderButton.label = "Назад";
				//_rightHeaderButton.label = "Нравится";
				(this._navigator.activeScreen as AdviceScreen).data = _advice;
			}
		}		
		
		
			
		
		
		private function onNeedLogin(e:ApplicationEvents):void
		{
			this._navigator.showScreen(LOGIN_SCREEN);
		}		
		
		
		public function hideTabBar():void
		{
			TweenMax.to(Facade.tabs, 0.3, {y: Facade.tabs.y + Facade.tabs.height});
		}
		
		public function showTabBar():void
		{
			TweenMax.to(Facade.tabs, 0.3, {y: this.height - Facade.tabs.height});
		}
		
		private function onPostAdviceScreenShow(e:ApplicationEvents):void
		{
			hideTabBar();
			var screen:PostAdviceScreen = this._navigator.showScreen(POST_ADVICE_SCREEN) as PostAdviceScreen;
			if(e.params) screen.editMode(e.params.data);
		}		
		
		private function onAdvicePosted(e:ApplicationEvents):void
		{
			this._navigator.showScreen(PROFILE_SCREEN);
			Alert.show("Cовет сохранен.", "",new ListCollection([{ label: "OK"}]) );
			showTabBar();
		}
		
		private function onShowAdviceScreen(e:ApplicationEvents):void
		{
			hideTabBar();
			_advice = e.params;
			_askedAdviceScreen = this._navigator.activeScreenID;
			this._navigator.showScreen(ADVICE_SCREEN);
		}	
		
		
		
		
		private function onShowCategoryAdvices(e:ApplicationEvents):void
		{
			hideTabBar();
			_advicesByCategory = e.params as Array;
			this._navigator.showScreen(ADVICE_LIST_SCREEN);
		}		
		
		
		private function onCancelPostADvice(e:ApplicationEvents):void
		{
			this._navigator.showScreen(PROFILE_SCREEN);
			showTabBar();	
		}		
		
		
		
	}
}