package controller
{
	import events.ApplicationEvents;
	import events.GlobalDispatcher;
	
	import model.C;

	public class Controller
	{
		public function Controller()
		{
			GlobalDispatcher.addListener(C.SCREEN_CONTAINER_IS_READY, onScreenContainerIsReady);
			GlobalDispatcher.addListener(C.ON_LOGIN, onLogin);
			GlobalDispatcher.addListener(C.LOGIN_COMPLETE, onLoginComplete);
			GlobalDispatcher.addListener(C.GET_ALL_CATEGORIES_COMPLETE, onGetAllCategoriesComplete);
			GlobalDispatcher.addListener(C.GET_MY_ADVICES_COMPLETE, onGetMyAdvicesComplete);
			GlobalDispatcher.addListener(C.SAVE_POST_ADVICE, onSavePostAdvice);
			GlobalDispatcher.addListener(C.DISCRIBE, onDiscribe);
		}
		
		private function onDiscribe(e:ApplicationEvents):void
		{
			if(e.params.action == "Подписаться") 
				Facade.model.discribe(e.params.name);
			else 
				Facade.model.unDiscribe(e.params.name);
		}
		
		private function onGetMyAdvicesComplete(e:ApplicationEvents):void
		{
			if(!Facade.model.enterComplete) 
			{
				Facade.model.enterComplete = true; 
			}
		}
		
		private function onGetAllCategoriesComplete(e:ApplicationEvents):void
		{
			if(!Facade.model.enterComplete) 
			{
				Facade.model.getUserAdvices(Facade.model.profileVO.id);
			}
		}
		
		private function onLoginComplete(e:ApplicationEvents):void
		{
			if(!Facade.model.enterComplete) 
				Facade.model.getAllCategories();
		}		
	
		private function onScreenContainerIsReady(e:ApplicationEvents):void
		{
			Facade.model.start();
		}	
		
		
		
		private function onLogin(e:ApplicationEvents):void
		{
			if(!Facade.model.enterComplete) 
				Facade.model.login(e.params.login, e.params.password);
		}		
		
	
		
		private function onSavePostAdvice(e:ApplicationEvents):void
		{
			Facade.model.postAdvice(e.params);
		}		
		
		
		
	}
}