package com.looksLike.UIFramework
{
	import com.greensock.TweenMax;
	import com.looksLike.Facade;
	import com.looksLike.popups.InfoErrorPopUp;
	import com.looksLike.UIFramework.AppScreen;
	import com.looksLike.UIFramework.BaseClass;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	
	public class PopUpManager extends BaseClass
	{
		
		public static var overedPopUp:AppScreen;
		public static var currentPopUp:AppScreen;
		
		public static var pool:Vector.<PoolPopupVO> = new Vector.<PoolPopupVO>;
		static private var _shadow:MovieClip;
		
		public function PopUpManager()
		{
			super();
		}
		
		
	
		
		private var _callback:Function;
		
		public static function createPopUp($owner:AppScreen, 
										   $newScreen:AppScreen, 
										   $alingnCenter:Boolean = true, 
										   $params:Object = null, 
										   $callBack:Function = null, 
										   $over:Boolean = false, 
										   $unique:Boolean = false,
										   $shadowed:Boolean = true
										   ):void
		{
			if ($unique) removePopUp();
			
			if (currentPopUp && !$over) 
			{
				var poolPopup:PoolPopupVO = new PoolPopupVO();
				poolPopup.owner = $owner;
				poolPopup.newScreen = $newScreen;
				poolPopup.alingnCenter = $alingnCenter;
				poolPopup.params = $params;
				poolPopup.callBack = $callBack;
				pool.push(poolPopup);
				return;
			}
			if (currentPopUp) overedPopUp = currentPopUp;
			currentPopUp = $newScreen;
			currentPopUp.callback = $callBack;
			currentPopUp.owner = $owner;
			if ($shadowed) 
			{
				if(!_shadow) _shadow = new popupShadow();
				Facade.screenMain.addChild(_shadow);
				_shadow.width = Facade.stage.width;
				_shadow.height = Facade.stage.height;
			}
			Facade.screenMain.addChild(currentPopUp.skin);
			if($alingnCenter)
			{
				currentPopUp.skin.x = Facade.stage.stageWidth / 2;
				currentPopUp.skin.y = Facade.stage.stageHeight / 2;
			}
			currentPopUp.start($params);
			trace("PopUpManager: createPopUp(", currentPopUp.name, ")");
		}
		
		
		
		
		public static function removePopUp():void
		{
			if (!currentPopUp) return;
			trace("PopUpManager: removePopUp(", currentPopUp.name, ")");
			currentPopUp.stop();
			if(_shadow.parent) _shadow.parent.removeChild(_shadow);
			currentPopUp.skin.parent.removeChild(currentPopUp.skin);
			currentPopUp.skin = null;
			currentPopUp = null;
			if (overedPopUp) 
			{
				currentPopUp = overedPopUp;
				overedPopUp = null;
			}
			if (!overedPopUp && pool.length > 0) handlePool();
		}		
		
		
		
		static private function handlePool():void 
		{
			var popupVO:PoolPopupVO = pool.shift();
			createPopUp(popupVO.owner, popupVO.newScreen, popupVO.alingnCenter, popupVO.params, popupVO.callBack);
			/*switch (popupVO.type) 
			{
				case PopUpTypes.ERROR:
				case PopUpTypes.INFO:
					createPopUp(Facade.screenManager.currentScreen, new InfoErrorPopUp(), true, popupVO.message, poolAction);
				break;
			}*/
		}
		
		static private function poolAction():void 
		{
			
		}
		
	}
}