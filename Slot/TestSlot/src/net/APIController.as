package net
{

	import events.C;
	import events.GlobalDispatcher;
	

	public class APIController extends BaseAPIController
	{
	
		override public function connect($login:String, $password:String, $callbackComplete:Function, $callbackError:Function = null):void
		{
			HTTPServerController.send({method:"connect"}, $callbackComplete, $callbackError);
		}
		

		override public function sendSpin():void 
		{
			trace("sendSpin");
			GlobalDispatcher.dispatch(C.UPDATE_DATA, ExampleResponses.OnSpinResponse);
		}
		
		override public function sendCollect():void 
		{
			trace("sendCollect");
		}
	}
}