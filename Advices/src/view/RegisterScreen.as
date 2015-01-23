package view
{
	import feathers.controls.Alert;
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.controls.Screen;
	import feathers.controls.TextInput;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	import feathers.system.DeviceCapabilities;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class RegisterScreen extends Screen
	{
		
		private var _backButton:Button;
		private var _loginButton:Button;
		private var _optionsButton:Button;
		private var _loginTextInput:TextInput;
		private var _passTextInput:TextInput;
		private var _pass2TextInput:TextInput;
		private var _registerButton:Button;

		
		private static const COMPLETE:String = "showLoginScreen";
		
		
		public function RegisterScreen()
		{
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		protected function initializeHandler(event:Event):void
		{
			var vlayout:VerticalLayout = new VerticalLayout();
			vlayout.padding = 20 * this.dpiScale;
			vlayout.gap = 16 * this.dpiScale;
			vlayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			vlayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			layout = vlayout;
			
			setSize(stage.stageWidth, stage.stageHeight);
			
			_loginTextInput = new TextInput();
			_loginTextInput.prompt = "Enter login";
			_loginTextInput.width = this.width / 2;
			addChild(_loginTextInput);
			_loginTextInput.validate();
			
			_passTextInput = new TextInput();
			_passTextInput.prompt = "Enter password";
			_passTextInput.width = this.width / 2;
			addChild(_passTextInput);
			
			_pass2TextInput = new TextInput();
			_pass2TextInput.prompt = "Re-enter password";
			_pass2TextInput.width = this.width / 2;
			addChild(_pass2TextInput);
			
			
			_registerButton = new Button();
			_registerButton.label = "Sign up";
			_registerButton.width = _loginTextInput.width;
			_registerButton.nameList.add(Button.ALTERNATE_NAME_DANGER_BUTTON);
			addChild(_registerButton);
			_registerButton.addEventListener(Event.TRIGGERED, registerTriggeredHandler);
		}
		
		private function registerTriggeredHandler(event:Event):void
		{
			this.dispatchEventWith(COMPLETE);
		}
		
		
	}
}
