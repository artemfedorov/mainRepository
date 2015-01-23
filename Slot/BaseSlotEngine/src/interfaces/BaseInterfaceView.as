package interfaces 
{
	import flash.display.MovieClip;
	
	import Utils.AssetLoader;
	
	import entities.MyButton;
	
	import starling.display.Sprite;

	/**
	 * ...
	 * @author 
	 */
	public class BaseInterfaceView extends Sprite
	{
		public static var atlasesNames:Array = 
		[
			"buttons"
		];
		public static var path:String = "interface";
		
		private var _buttons:Vector.<MyButton>;
		
		public function BaseInterfaceView() 
		{
			_buttons = new Vector.<MyButton>;
			var layout:MovieClip = Facade.layout.buttons;
			var btnName:String;
			var btn:MyButton;
			
			for (var i:int = 0; i < layout.numChildren; i++) 
			{
				btnName = layout.getChildAt(i).name;
				btn = new MyButton (AssetLoader.assetsDics["buttons"].getTexture(btnName + "_up"), 
									AssetLoader.assetsDics["buttons"].getTexture(btnName + "_down"), 
									AssetLoader.assetsDics["buttons"].getTexture(btnName + "_over"),
									AssetLoader.assetsDics["buttons"].getTexture(btnName + "_up"),
									AssetLoader.assetsDics["buttons"].getTexture(btnName + "_disable"));
				btn.name = btnName;
				addChild(btn);
				btn.x = layout[btnName].x;
				btn.y = layout[btnName].y;
				btn.switchState(MyButton.UP_STATE);
				btn.onUpState = onUpState;
				btn.onDownState = onDownState;
				btn.onOutState = onOutState;
				btn.onDisableState = onDisableState;
				_buttons.push(btn);
			}
			
			
			
		}
		
		
		protected function get buttons():Vector.<MyButton>
		{
			return _buttons;
		}

		protected function set buttons(value:Vector.<MyButton>):void
		{
			_buttons = value;
		}

		protected function onUpState($name:MyButton):void 
		{
		}
		protected function onDownState($name:MyButton):void 
		{
		}
		protected function onOutState($name:MyButton):void 
		{
		}
		protected function onDisableState($name:MyButton):void 
		{
		}
		
		
	}
}