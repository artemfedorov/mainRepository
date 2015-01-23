package interfaces
{
	import entities.MyButton;
	
	import events.ApplicationEvents;
	import events.C;
	import events.GlobalDispatcher;
	
	import model.BaseStates;

	public class InterfaceView extends BaseInterfaceView
	{
		
		public static var atlasesNames:Array = 
			[
				"buttons"
			];
		public static var path:String = "interface";
		
		
		public function InterfaceView()
		{
			super();
			GlobalDispatcher.addListener(C.STATE_CHANGED, onStateChanged);
			GlobalDispatcher.addListener(C.SPIN_COMPLETE, onSpinComplete);
		}
		
		
		private function onSpinComplete(e:ApplicationEvents):void
		{
			if(Facade.states.auto) return;
			for (var i:int = 0; i < buttons.length; i++) 
			{
				buttons[i].switchState(MyButton.ENABLE_STATE);
			}
		}
		
		/**
		 * Слушатель события изменения STATE из модели
		 */
		protected function onStateChanged(e:ApplicationEvents):void 
		{
			if(e.params == BaseStates.SPIN_STATE)
			{
				
			}
		}
		
		override protected function onUpState($btn:MyButton):void 
		{
			super.onUpState($btn);
			switch($btn.name)
			{
				case "start_btn":
					if($btn.isDown) 
					{
						GlobalDispatcher.dispatch(C.SPIN_PRESSED);
					
						for (var i:int = 0; i < buttons.length; i++) 
						{
							buttons[i].switchState(MyButton.DISABLE_STATE);
						}
					}
					break;
				case "autoPlay_btn":
					if($btn.isDown) 
					{
						GlobalDispatcher.dispatch(C.AUTOSPIN_PRESSED);
						for (i = 0; i < buttons.length; i++) 
						{
							if(buttons[i] != $btn) 
								buttons[i].switchState(MyButton.DISABLE_STATE);
							else
								trace("ASD");
						}
					}
					break;
				
				case "line1_btn":
				case "line3_btn":
				case "line5_btn":
				case "line7_btn":
				case "line9_btn":
					var num:uint = uint($btn.name.substr(4, 1));
					if($btn.isDown) GlobalDispatcher.dispatch(C.LINES_CHANGED, num);
					break;
			}
		}
		
		override protected function onDownState($btn:MyButton):void 
		{
			super.onDownState($btn);
		}
		override protected function onOutState($btn:MyButton):void 
		{
			super.onDownState($btn);
		}
		override protected function onDisableState($btn:MyButton):void 
		{
			super.onDownState($btn);
		}
	}
}