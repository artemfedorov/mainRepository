package net
{

	import events.ApplicationEvents;
	import events.EventConstants;
	import events.GlobalDispatcher;
	
	import flash.events.Event;
	import flash.globalization.DateTimeFormatter;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	

	public class APIController
	{
	
		public static function connect($login:String, $password:String, $callbackComplete:Function, $callbackError:Function = null):void
		{
			HTTPServerController.send({method:"connect", "login":$login, "password":$password}, $callbackComplete, $callbackError);
		}
		
		public static function postAdvice($header:String, $text:String, $category_id:int, $callbackComplete:Function, $callbackError:Function = null):void
		{
			HTTPServerController.send({method:"post_advice", "header":$header, "text":$text, "category_id":$category_id}, $callbackComplete, $callbackError);
		}
		
		public static function updateAdvice($id:int, $category_id:int, $header:String, $text:String, $likes:int, $callbackComplete:Function, $callbackError:Function = null):void
		{
			HTTPServerController.send({method:"update_advice", "id":$id,  "header":$header, "text":$text, "category_id":$category_id, "Likes":$likes}, $callbackComplete, $callbackError);
		}

		public static function like($id:int, $callbackComplete:Function, $callbackError:Function = null):void
		{
			HTTPServerController.send({method:"like", "id":$id}, $callbackComplete, $callbackError);
		}
		
		public static function getAllCategories($callbackComplete:Function, $callbackError:Function = null):void
		{
			HTTPServerController.send({method:"get_advice_categories"}, $callbackComplete, $callbackError);
		}

		public static function getUserAdvices($id:int, $callbackComplete:Function, $callbackError:Function = null):void
		{
			HTTPServerController.send({method:"get_user_advices", "user_id":$id}, $callbackComplete, $callbackError);
		}
		
		public static function getAdvicesByCategory($id:int, $callbackComplete:Function, $callbackError:Function = null):void
		{
			HTTPServerController.send({method:"get_advices_by_category", "category_id":$id}, $callbackComplete, $callbackError);
		}
		
		public static function getAdvicesByCategories($ids:Array, $callbackComplete:Function, $callbackError:Function = null):void
		{
			HTTPServerController.send({method:"get_advices_by_categories", "categories":$ids}, $callbackComplete, $callbackError);
		}
		
		public static function getAdvicesByUsers($ids:Array, $callbackComplete:Function, $callbackError:Function = null):void
		{
			HTTPServerController.send({method:"get_advices_by_users", "users":$ids}, $callbackComplete, $callbackError);
		}
		
		public static function getSubscriptions($callbackComplete:Function, $callbackError:Function = null):void
		{
			HTTPServerController.send({method:"get_subscriptions"}, $callbackComplete, $callbackError);
		}
		
	
		public static function updateSubscription($subscriptions:String, $callbackComplete:Function, $callbackError:Function = null):void
		{
			HTTPServerController.send({method:"update_subscription", "subscriptions":$subscriptions}, $callbackComplete, $callbackError);
		}
	}
}