package own.fedorov.engine.controller
{
	import org.robotlegs.mvcs.Command;
	
	import own.fedorov.engine.model.MainModel;
	import own.fedorov.engine.view.components.Layout;
	
	public class CreateLayoutCommand extends Command
	{
		[Inject]
		public var mainModel:MainModel;
		
		
		override public function execute():void
		{
			var layoutType:int = mainModel.currentLayoutIndex;
			contextView.addChild(new Layout(layoutType));
		}
	}
}