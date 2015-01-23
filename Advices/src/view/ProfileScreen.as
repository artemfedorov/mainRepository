package view
{
	import events.ApplicationEvents;
	import events.GlobalDispatcher;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.ScrollContainer;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import flash.media.Camera;
	import flash.media.Video;
	
	import model.C;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	
	public class ProfileScreen extends Screen
	{
		private var _backButton:Button;
		private var _giveAdviceButton:Button;
		private var _optionsButton:Button;
		
		private var _subscription:TextField;
		private var _subscribers:TextField;
		private var _advices:TextField;
		private var _name:TextField;
		
		private var _subscriptionValue:TextField;
		private var _subscribersValue:TextField;
		private var _advicesValue:TextField;
		
		private static const COMPLETE:String =  "showMainScreen";
		private static const REGISTER:String =  "showRegisterScreen";

		private var _advicesListCollection:ListCollection;

		private var _advicesList:List;
		
		
		
		public function ProfileScreen()
		{
			super();
			GlobalDispatcher.addListener(C.GET_MY_ADVICES_COMPLETE, onGetMyAdvicesComplete);
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
	
		protected function initializeHandler(event:Event):void
		{
			setSize(stage.stageWidth, stage.stageHeight - Facade.tabs.height);
			
			var topContainer:ScrollContainer = new ScrollContainer();
			topContainer.width = this.width;
			topContainer.height = this.height / 2;
			topContainer.y = 0;
			var vLayout:VerticalLayout = new VerticalLayout();
			vLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			vLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			topContainer.layout = vLayout;
			this.addChild(topContainer);
			
		
			var hLayout:HorizontalLayout = new HorizontalLayout();
			hLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			hLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			
			var avatarContainer:LayoutGroup = new LayoutGroup();
			avatarContainer.layout = hLayout;
			
			var labelsContainer:LayoutGroup = new LayoutGroup();
			labelsContainer.layout = hLayout;
			
			var labelsValuesContainer:LayoutGroup = new LayoutGroup();
			labelsValuesContainer.layout = hLayout;
			
			var buttonsContainer:LayoutGroup = new LayoutGroup();
			buttonsContainer.layout = hLayout;
			
			
			topContainer.addChild(avatarContainer);
			topContainer.addChild(labelsContainer);
			topContainer.addChild(labelsValuesContainer);
			topContainer.addChild(buttonsContainer);
			
			var avatar:ImageLoader = new ImageLoader();
			avatar.y = Facade.header.height;
			avatar.setSize(stage.width / 4, stage.height / 4);
			avatar.source = Facade.model.profileVO.ava_url;
			avatarContainer.addChild(avatar);
			avatarContainer.addEventListener(TouchEvent.TOUCH, onTouchAvatar);
			
			_name = new TextField(this.width - avatar.width, 60,  Facade.model.profileVO.name + " " + Facade.model.profileVO.sename, "Verdana", 30, 0xFFFFFF, true);
			avatarContainer.addChild(_name);
			_name.x = avatar.width;
			_name.y = avatar.y + avatar.height / 3;
			
			_subscription = new TextField(150, 40,  "Подписки", "Verdana", 20, 0xFFFFFF, false);
			labelsContainer.addChild(_subscription);
			
			_subscribers = new TextField(150, 40,  "Подписчики", "Verdana", 20, 0xFFFFFF, false);
			labelsContainer.addChild(_subscribers);
			
			_advices = new TextField(150, 40,  "Советов", "Verdana", 20, 0xFFFFFF, false);
			labelsContainer.addChild(_advices);
			
			_subscriptionValue = new TextField(150, 40,  String(Facade.model.subscriptions.length), "Verdana", 25, 0xFFFFFF, true);
			labelsValuesContainer.addChild(_subscriptionValue);
			
			_subscribersValue = new TextField(150, 40,  String(Facade.model.profileVO.subscribers), "Verdana", 25, 0xFFFFFF, true);
			labelsValuesContainer.addChild(_subscribersValue);
			
			_advicesValue = new TextField(150, 40,  String(Facade.model.myAdvices.length), "Verdana", 25, 0xFFFFFF, true);
			labelsValuesContainer.addChild(_advicesValue);
			
			
			
			_giveAdviceButton = new Button();
			_giveAdviceButton.label = "Дать совет";
			buttonsContainer.addChild(_giveAdviceButton);
			_giveAdviceButton.addEventListener(Event.TRIGGERED, onGiveAdvide);
			_giveAdviceButton.validate();
			_giveAdviceButton.height = 65;
			_giveAdviceButton.width = 165;
			
			
			var bottomScrollContainer:ScrollContainer = new ScrollContainer();
			bottomScrollContainer.width = this.width;
			bottomScrollContainer.height = this.height / 2;
			bottomScrollContainer.y = this.height / 2;
			bottomScrollContainer.layout = vLayout;
			
			this.addChild(bottomScrollContainer);
			
			_advicesList = new List();
			_advicesList.width = this.width;
			_advicesList.height = this.height / 2;
			_advicesList.y = this.height / 2;
			
			
			_advicesListCollection = new ListCollection(Facade.model.myAdvices);

			_advicesList.dataProvider = _advicesListCollection;
			
			_advicesList.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.labelField = "header";
				renderer.accessoryLabelField = "likesCount";
				//renderer.iconSourceField = "thumbnail";
				return renderer;
			};
			
			_advicesList.addEventListener(Event.CHANGE, onPickUpAdvicesList);
			bottomScrollContainer.addChild(_advicesList);
		}
		
		private function onTouchAvatar(e:TouchEvent):void
		{
			/*var cam:Camera = Camera.getCamera(); 
			var vid:Video = new Video(); 
			vid.attachCamera(cam); 
			//Starling.current.nativeOverlay.addChild(vid);
			Starling.current.nativeStage.addChild(vid);*/
		}
		
		private function onPickUpAdvicesList(e:Event):void
		{
			GlobalDispatcher.dispatch(C.SHOW_MY_ADVICE, {data:(e.target as Object).selectedItem});
		}		
		
		
		private function onGetMyAdvicesComplete(e:ApplicationEvents):void
		{
			_advicesValue.text = String(Facade.model.myAdvices.length);
			_advicesListCollection = new ListCollection(Facade.model.myAdvices);
			_advicesList.dataProvider = _advicesListCollection;
		}		
		
		
		
		private function onGiveAdvide(event:Event):void
		{
			GlobalDispatcher.dispatch(C.POST_ADVICE_SCREEN_SHOW);
		}		
		
		
		override public function dispose():void
		{
			super.dispose();
			GlobalDispatcher.removeListener(C.GET_MY_ADVICES_COMPLETE, onGetMyAdvicesComplete);
			removeEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		override protected function draw():void
		{
			super.draw();
		}
		
		
		
	}
}
