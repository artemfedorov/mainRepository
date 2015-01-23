package view
{
	import events.GlobalDispatcher;
	
	import feathers.controls.Button;
	import feathers.controls.GroupedList;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.IGroupedListItemRenderer;
	import feathers.data.HierarchicalCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	
	import flash.events.Event;
	import flash.globalization.DateTimeFormatter;
	import flash.utils.Dictionary;
	
	import model.C;
	
	import net.APIController;
	
	import starling.events.Event;
	import starling.text.TextField;
	
	public class NewsScreen extends Screen
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

		private var _today:String;

		private var groups:Array;

		private var list:GroupedList;

		private var authorsAdvices:Object;
		
		
		
		public function NewsScreen()
		{
			super();
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
			var date:Date = new Date();
				
			var df:DateTimeFormatter = new DateTimeFormatter("us_US");
			df.setDateTimePattern("yyyy-MM-dd");
			var ds:String = df.format(date);
			_today = ds;
			
			getSubscriptionedAdvicesByAuthor();
			
		}
		
		
		private function getSubscriptionedAdvicesByCategory():void
		{
			var categories:Array = [];
			var c:String;
			var type:String;
			for (var i:int = 0; i < Facade.model.subscriptions.length; i++) 
			{
				c = Facade.model.subscriptions[i];
				type = c.substr(c.length - 1, 1);
				if(type == "!")
				{
					categories.push(c.substr(0, c.length - 1));
				}
				trace(categories);
			}
			
			APIController.getAdvicesByCategories(categories, onGetAdvicesByCategory);
		}		
		
		private function getSubscriptionedAdvicesByAuthor():void
		{
			var users:Array = [];
			var c:String;
			var type:String;
			for (var i:int = 0; i < Facade.model.subscriptions.length; i++) 
			{
				c = Facade.model.subscriptions[i];
				type = c.substr(c.length - 1, 1);
				if(type == "?")
				{
					users.push(c.substr(0, c.length - 1));
				}
				trace(users);
			}
			
			APIController.getAdvicesByUsers(users, onGetAdvicesByUsers);
		}		
		
		private function onGetAdvicesByUsers(e:flash.events.Event):void
		{
			authorsAdvices = JSON.parse(e.target.data as String);  trace("RESPONSE:", e.target.data as String);
			if (authorsAdvices.hasOwnProperty("error"))
			{
				return;
			}
			getSubscriptionedAdvicesByCategory();
		}		
		
		private function onGetAdvicesByCategory(e:flash.events.Event):void
		{
			var data:Object = JSON.parse(e.target.data as String);  trace("RESPONSE:", e.target.data as String);
			if (data.hasOwnProperty("error"))
			{
				return;
			}
			if(data.data is Array) 
			{
				for (var m:int = 0; m < data.data.length; m++) 
				{
					for (var l:int = 0; l < authorsAdvices.data.length; l++) 
					{
						if(authorsAdvices.data[l].id == data.data[m].id)
						{
							authorsAdvices.data.splice(l, 1);
							break;
						}
					}
					
				}
				data.data = data.data.concat(authorsAdvices.data);
				
				
				
				for (var k:int = 0; k < data.data.length; k++) 
				{
					var likesStr:String = data.data[k].likes;
					if(likesStr == "") 
						data.data[k].likes = [];
					else 
					data.data[k].likes = JSON.parse(likesStr);
				}
				
				var arr:Array;
				var dic:Dictionary = new Dictionary();
				for(var i:int = 0; i < data.data.length; i++)
				{
					if(dic[data.data[i].date])
					{
						dic[data.data[i].date].push(data.data[i]);
					}
					else
					{
						dic[data.data[i].date] = new Array();
						dic[data.data[i].date].push(data.data[i]);
					}
				}
				
				Facade.model.subscriptionsData = data;
				groups = [];
				var curdate:String;
				var group:Object;
				var children:Array;
				var v:Object;
				for(var item in dic)
				{
					group = {};
					group.header = item;
					group.children = [];
					for (var j:int = 0; j < dic[item].length; j++) 
					{
						v = 
							{
								text:dic[item][j].header,
								category:dic[item][j].likes.length,
								o:dic[item][j]
							}
							group.children.push(v);
					}
					groups.push(group);
					
				}
				groups.fixed = true;
				
				list = new GroupedList();
				list.y = Facade.header.height;
				list.width = this.width;
				list.height = this.height - Facade.tabs.height - Facade.header.height;
				list.dataProvider = new HierarchicalCollection(groups);
				list.typicalItem = { text: "Item 1000" };
				list.typicalItem = { category: "Category" };
				
				list.hasElasticEdges = true;
				list.clipContent = false;
				list.autoHideBackground = true;
				list.itemRendererFactory = function():IGroupedListItemRenderer
				{
					var renderer:DefaultGroupedListItemRenderer = new DefaultGroupedListItemRenderer();
					
					renderer.isQuickHitAreaEnabled = true;
					
					renderer.labelField = "text";
					renderer.accessoryLabelField = "category";
					return renderer;
				};
				
				this.addChild(list);
				list.addEventListener(starling.events.Event.CHANGE, onPickUpAdvice);
				this.validate();
				
			}
			else 
				trace(authorsAdvices.data);
		}
		
		
		
		
		private function onPickUpAdvice(e:starling.events.Event):void
		{
			var label:Label = new Label();
			GlobalDispatcher.dispatch(C.SHOW_ADVICE, (list.selectedItem as Object).o);
		}		
		
		
		
		protected function initializeHandler(event:starling.events.Event):void
		{
			setSize(stage.stageWidth, stage.stageHeight - Facade.tabs.height - Facade.header.height);
			
			var vLayout:VerticalLayout = new VerticalLayout();
			vLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			vLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			this.layout = vLayout;
		}
		
		
		
		private function onTouch(event:starling.events.Event):void
		{
			// TODO Auto Generated method stub
			
		}		
		
		
		
		private function onLogin(event:starling.events.Event):void
		{
			this.dispatchEventWith(COMPLETE);
		}
		
		
		private function onRegister(event:starling.events.Event):void
		{
			this.dispatchEventWith(REGISTER);
		}
	}
}
