package own.fedorov.engine.controller
{
	import org.robotlegs.mvcs.Command;
	
	import own.fedorov.engine.model.MainModel;
	
	public class ImageClickCommand extends Command
	{
		[Inject]
		private var _mainModel:MainModel;
		
		override public function execute():void
		{
		}
	}
}