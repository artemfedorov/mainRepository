package 
{
	import com.greensock.TweenMax;
	import com.looksLike.config.Config;
	import com.looksLike.Facade;
	import com.looksLike.screens.MainScreen;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import flash.display.Sprite;
	
	
	public class ScreensManager extends BaseClass
	{
		
		private var _screens:Dictionary = new Dictionary();
		private var _mainScreen:AppScreen;
		private var _screenContainer:DisplayObjectContainer;
		private var _currentScreen:AppScreen;
		
		public function ScreensManager()
		{
			super();
		}
		
		
		public function get currentScreen():AppScreen
		{
			return _currentScreen;
		}

		public function set currentScreen(value:AppScreen):void
		{
			_currentScreen = value;
		}
		
		public function get mainScreen():AppScreen 
		{
			return _mainScreen;
		}
		
		public function set mainScreen(value:AppScreen):void 
		{
			_mainScreen = value;
		}

		
		public function createMainScreen($screen:Class):void
		{
			if (_mainScreen) return;
			var s:AppScreen = new $screen();
			_mainScreen = s;
			Facade.screenMain.addChild(s.skin);
			if((s as MainScreen).screenContainer) _screenContainer = (s as MainScreen).screenContainer;
			s.start();
		}		
		
		private function createScreen($screen:Class):void
		{
			if (_screens[$screen] != null) 
			{
				_currentScreen = _screens[$screen];
				_currentScreen.skin.visible = true;
			}
			else 
			{
				_currentScreen = new $screen();
				if (_currentScreen.save) _screens[$screen] = _currentScreen;
				_screenContainer.addChild(_currentScreen.skin);
				_currentScreen.start();
			}
			_currentScreen.draw();
		}
		
		private function removeScreen():void
		{
			if (_currentScreen && !_currentScreen.save)
			{
				_currentScreen.sleep();
				_currentScreen.stop();
				_screenContainer.removeChild(_currentScreen.skin);
				/*var className:String = getClassName(_currentScreen);
				if (_screens[className] != null) 
					delete _screens[className];*/
				_currentScreen.skin = null;
				_currentScreen = null;
			}
			else
			{
				_currentScreen.sleep();
				_currentScreen.skin.visible = false;
			}
		}
		
		private function getClassName(s:AppScreen):String
		{
			var sf:String = getQualifiedClassName(s);
			for (var i:int = 0; i < sf.length; i++) 
			{
				if (sf.charAt(i) == ":") break;
			}
			return sf.substr(i + 2);
		}
		
		
		public function changeScreen($newScreen:Class):void
		{
			if (_currentScreen is $newScreen) return;
					
			if (_currentScreen)
			{
				removeScreen();
				createScreen($newScreen);
			}
			else 
			{
				createScreen($newScreen);
			}
		}
		
		
	}
}