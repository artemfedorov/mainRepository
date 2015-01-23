package net
{

	import events.C;
	import events.GlobalDispatcher;
	

	public class BaseAPIController
	{
	
		public function connect($login:String, $password:String, $callbackComplete:Function, $callbackError:Function = null):void
		{
			HTTPServerController.send({method:"connect"}, $callbackComplete, $callbackError);
		}
		

		public function sendSpin():void 
		{
			trace("sendSpin");
			GlobalDispatcher.dispatch(C.UPDATE_DATA, {"RERE":"KUKU"});
		}
		
		public function sendCollect():void 
		{
			trace("sendCollect");
		}
	}
}