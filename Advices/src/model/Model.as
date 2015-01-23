package model
{
	import events.GlobalDispatcher;
	
	import flash.events.Event;
	
	import net.APIController;
	
	import vo.ProfileVO;

	public class Model
	{
		private var needLogin:Boolean = true;
		private var _profileVO:ProfileVO;
		private var _categories:Array = [];
		private var _myAdvices:Array = [];
		private var _needToReloadMyAdvices:Boolean;
		
		private var _enterComplete:Boolean;
		private var _subscriptions:Array = [];
		private var _subscriptionsData:Object;
		
		
		
		public function Model()
		{
			start();
		}
		
		
		


		public function start():void
		{
			if(needLogin) 
				GlobalDispatcher.dispatch(C.NEED_LOGIN); 
			
			
			else 
				enterComplete = true;
		}
		
		
		public function getCategoryIdByName($name:String):int
		{
			for (var i:int = 0; i < categories.length; i++) 
			{
				if(categories[i].name == $name) return categories[i].id;
			}
			return 0;
		}
		
		
		public function login($login:String, $password:String):void
		{
			APIController.connect($login, $password, onLoggedIn);
			
		}
		
		public function getAllCategories():void
		{
			APIController.getAllCategories(onGetAllCategories);
			
		}
		
		public function getUserAdvices($id:int):void
		{
			APIController.getUserAdvices($id, onGetMyADvices);
			
		}
		
		private function onLoggedIn(e:Event):void
		{
			var user:Object = JSON.parse(e.target.data as String);  trace("RESPONSE:", e.target.data as String);
			if (user.hasOwnProperty("error"))
			{
				return;
			}
			if(user.data) 
			{
				_profileVO = new ProfileVO();
				
				_profileVO.id = user.data.id;
				_profileVO.ava_url = user.data.ava_url;
				_profileVO.login = user.data.login;
				_profileVO.name = user.data.name;
				_profileVO.sename = user.data.sename;
				_profileVO.birthday = user.data.birthday;
				_profileVO.country = user.data.country;
				_profileVO.city = user.data.city;
				_profileVO.language = user.data.language;
				_profileVO.subscriptions = user.data.subscriptions;
				_profileVO.subscribers = user.data.subscribers;
				GlobalDispatcher.dispatch(C.LOGIN_COMPLETE);
			}
		}
		
		
					
		private function onGetAllCategories(e:Event):void
		{
			var categoryVO:Object;
			var categories:Object = JSON.parse(e.target.data as String);  trace("RESPONSE:", e.target.data as String);
			if (categories.hasOwnProperty("error"))
			{
				return;
			}
			if(categories.data) 
			{
				
				var c:Array = categories.data;
				for (var i:int = 0; i < c.length; i++) 
				{
					categoryVO = 
						{
							id : c[i].id,
							owner_id : c[i].owner_id,
							name : c[i].name
						}
					_categories.unshift(categoryVO);
				}
				APIController.getSubscriptions(onGetMySubscriptions);
			
			}
		}
		
		private function onGetMySubscriptions(e:Event):void
		{
			var subscriptionsVO:Object;
			var subs:Object = JSON.parse(e.target.data as String);  trace("RESPONSE:", e.target.data as String);
			if (subs.hasOwnProperty("error"))
			{
				return;
			}
			if(subs.data != "") 
			{
				_subscriptions = JSON.parse(subs.data as String) as Array;
			}
			GlobalDispatcher.dispatch(C.GET_ALL_CATEGORIES_COMPLETE);	
		}
				
				
		public function isExistInList($str:String, $type:String):Boolean
		{
			if(_subscriptions.indexOf($str + $type) > -1) 
				return true;
			else 
				return false;
		}
				
		private function onGetMyADvices(e:Event):void
		{
			var adviceVO:Object;
			var advices:Object = JSON.parse(e.target.data as String);  trace("RESPONSE:", e.target.data as String);
			if (advices.hasOwnProperty("error"))
			{
				return;
			}
			if(advices.data) 
			{
				_myAdvices = [];
				var serverAdvices:Array = advices.data;
				
				for (var i:int = 0; i < serverAdvices.length; i++) 
				{
					adviceVO =
						{
							category_id : serverAdvices[i].category_id,
								date : serverAdvices[i].date,
								header : serverAdvices[i].header,
								id : serverAdvices[i].id,
								likes : serverAdvices[i].likes,
								owner_id : serverAdvices[i].owner_id,
								text : serverAdvices[i].text
						}
					_myAdvices.unshift(adviceVO);
				}
				for (var k:int = 0; k < _myAdvices.length; k++) 
				{
					var likesStr:String = _myAdvices[k].likes;
					if(likesStr == "") 
					{
						_myAdvices[k].likes = [];
						_myAdvices[k].likesCount = 0;
					}
					else 
					{
						_myAdvices[k].likes = JSON.parse(likesStr);
						_myAdvices[k].likesCount = _myAdvices[k].likes.length;
					}
				}
				GlobalDispatcher.dispatch(C.GET_MY_ADVICES_COMPLETE);	
			}
		}
	

		public function discribe($thing:String):void
		{
			if(_subscriptions.indexOf($thing) == -1)
				_subscriptions.push($thing);
			else 
			{
				trace("Подписка", _subscriptions, "уже есть");
				return;
			}
			APIController.updateSubscription(JSON.stringify(_subscriptions), onUpdateSubscription);
		}
		
		
		public function unDiscribe($thing):void
		{
			if(_subscriptions.indexOf($thing) == -1)
			{
				trace("Такой подписки нет", $thing);
				return;
			}
			_subscriptions.splice(_subscriptions.indexOf($thing), 1);
			APIController.updateSubscription(JSON.stringify(_subscriptions), onUpdateSubscription);
		}
		
		
		
		
		private function onUpdateSubscription(e:Event):void
		{
			var data:Object = JSON.parse(e.target.data as String);  trace("RESPONSE:", e.target.data as String);
			if (data.hasOwnProperty("error"))
			{
				return;
			}
			GlobalDispatcher.dispatch(C.SUBSCRIPTIONS_UPDATED);
		}
		
		
		
		
		public function postAdvice($advice:Object):void
		{
			if($advice.mode == C.NEW_MODE) APIController.postAdvice($advice.header, $advice.text,  $advice.category_id, onPostedAdvice);
			if($advice.mode == C.EDIT_MODE) APIController.updateAdvice($advice.advice_id, $advice.category_id, $advice.header, $advice.text, $advice.likes, onPostedAdvice);
			function onPostedAdvice(e:Event):void
			{
				var data:Object = JSON.parse(e.target.data as String);  trace("RESPONSE:", e.target.data as String);
				if (data.hasOwnProperty("error"))
				{
					return;
				}
				if(data.data) 
				{
					trace("Advice saved in database");
					needToReloadMyAdvices = true;
					GlobalDispatcher.dispatch(C.ADVICE_POSTED);
				}
			}		
		}
		
		

		
		public function get needToReloadMyAdvices():Boolean
		{
			return _needToReloadMyAdvices;
		}
		
		public function set needToReloadMyAdvices(value:Boolean):void
		{
			_needToReloadMyAdvices = value;
			if(value) 
			{
				_needToReloadMyAdvices= false;
				getUserAdvices(profileVO.id);
			}
		}
		
		
		
		
		public function get enterComplete():Boolean
		{
			return _enterComplete;
		}
		
		public function set enterComplete(value:Boolean):void
		{
			_enterComplete = value;
			if(value) 
				GlobalDispatcher.dispatch(C.ENTER_COMPLETE);
		}
	
		public function get myAdvices():Array
		{
			return _myAdvices;
		}
		
		public function set myAdvices(value:Array):void
		{
			_myAdvices = value;
		}
		
		public function get categories():Array
		{
			return _categories;
		}
		
		public function set categories(value:Array):void
		{
			_categories = value;
		}
		public function get profileVO():ProfileVO
		{
			return _profileVO;
		}
		
		public function set profileVO(value:ProfileVO):void
		{
			_profileVO = value;
		}
		public function get subscriptions():Array
		{
			return _subscriptions;
		}
		
		public function set subscriptions(value:Array):void
		{
			_subscriptions = value;
		}
		
		public function get subscriptionsData():Object
		{
			return _subscriptionsData;
		}
		
		public function set subscriptionsData(value:Object):void
		{
			_subscriptionsData = value;
		}

	}
}