package view
{
	import events.GlobalDispatcher;
	
	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.controls.TextInput;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	
	import flash.events.Event;
	
	import model.C;
	
	import net.APIController;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class LoginScreen extends Screen
	{
		private var _backButton:Button;
		private var _loginButton:Button;
		private var _optionsButton:Button;
		private var _loginTextInput:TextInput;
		private var _passTextInput:TextInput;
		private var _registerButton:Button;

		private static const COMPLETE:String =  "showMainScreen";
		private static const REGISTER:String =  "showRegisterScreen";
		
		
		
		public function LoginScreen()
		{
			super();
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		
		protected function initializeHandler(event:starling.events.Event):void
		{
			setSize(stage.stageWidth, stage.stageHeight);
			var vlayout:VerticalLayout = new VerticalLayout();
			vlayout.padding = 20 * this.dpiScale;
			vlayout.gap = 16 * this.dpiScale;
			vlayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			vlayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			layout = vlayout;
			
			_loginTextInput = new TextInput();
			_loginTextInput.text = "artem";
			_loginTextInput.prompt = "Enter login";
			_loginTextInput.width = this.width / 2;
			addChild(_loginTextInput);
			
			_passTextInput = new TextInput();
			_passTextInput.displayAsPassword = true;
			_passTextInput.text = "ajtdmw";
			_passTextInput.prompt = "Enter password";
			_passTextInput.width = this.width / 2;
			addChild(_passTextInput);
			
			_loginButton = new Button();
			_loginButton.width = _loginTextInput.width;
			_loginButton.label = "Sign in";
			addChild(_loginButton);
			_loginButton.addEventListener(starling.events.Event.TRIGGERED, onLogin);

			_registerButton = new Button();
			_registerButton.label = "Sign up";
			_registerButton.width = _loginButton.width * 0.6;
			_registerButton.nameList.add(Button.ALTERNATE_NAME_DANGER_BUTTON);
			addChild(_registerButton);
			_registerButton.addEventListener(starling.events.Event.TRIGGERED, onRegister);
		}
		
		
		
		
		private function onLogin(event:starling.events.Event):void
		{
			GlobalDispatcher.dispatch(C.ON_LOGIN, {"login":_loginTextInput.text, "password":_passTextInput.text});
		}
		
		
		
		private function onRegister(event:starling.events.Event):void
		{
			this.dispatchEventWith(REGISTER);
		}
	}
}
