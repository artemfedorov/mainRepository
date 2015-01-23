package model 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import com.greensock.easing.Linear;
	
	import events.ApplicationEvents;
	import events.GlobalDispatcher;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.getClassByAlias;
	import flash.utils.getDefinitionByName;
	
	import flashx.textLayout.operations.MoveChildrenOperation;
	
	import model.mechanics.BubbleMech;
	import model.mechanics.ConstructMech;
	import model.mechanics.IMechanics;
	import model.mechanics.Match2Mech;
	import model.mechanics.SortingMech;
	import model.mechanics.TwoPartsOfOneMech;
	
	import superClasses.BaseClass;
	import superClasses.DynamicActor;
	
	/**
	 * ...
	 * @author 
	 */
	public class B2DController extends BaseClass 
	{
		private var _destroyedBodies:Array = [];
		private var _gameSkin:MovieClip;
		
		private var _walls:Array = [];
		private var _gameObjects:Array = [];
		private var _bascketsArr:Array = [];
		private var _dummies:Array = [];
		private var _mechanics:IMechanics;
		private var _back:MovieClip;
		
		public function B2DController() 
		{
			super();
		}
		
		public function get mechanics():IMechanics
		{
			return _mechanics;
		}

		public function set mechanics(value:IMechanics):void
		{
			_mechanics = value;
		}

		public function get gameObjects():Array
		{
			return _gameObjects;
		}

		public function set gameObjects(value:Array):void
		{
			_gameObjects = value;
		}

		public function get dummies():Array
		{
			return _dummies;
		}

		public function set dummies(value:Array):void
		{
			_dummies = value;
		}
		
		public function get bascketsArr():Array 
		{
			return _bascketsArr;
		}
		
		public function set bascketsArr(value:Array):void 
		{
			_bascketsArr = value;
		}

		override protected function onRegister():void
		{
			super.onRegister();
			

			setupPhysicsWorld();
			var contactListener:GameContactListener = new GameContactListener();
			PhysiVals.world.SetContactListener(contactListener);
			
			
			

		} 
		
	
//-----------------------------------------------------------------------------------------------------------------------------
//
//	collisions the game objects
//
//-----------------------------------------------------------------------------------------------------------------------------		
		
		public function Collided($item1:DynamicActor, $item2:DynamicActor):void
		{
			if(!_mechanics) return;
			_mechanics.collided($item1, $item2);
		}

		
//-----------------------------------------------------------------------------------------------------------------------------
//
//	creating the game objects
//
//-----------------------------------------------------------------------------------------------------------------------------
		
		
		private function callbackRandom($a:Object, $b:Object):Object
		{
			return Math.random() >= 0.5 ? 1 : -1;	
		}
		
		
		
		
		public function createGame():void
		{
			GameFacade.myStage.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			_gameSkin = GameFacade.gameView.skin;
			//debugDraw();
			createWall();
			_currentAsset = GameFacade.gameModel.getNextGameAsset();
			createStuff(_currentAsset);
		}
		
		
		private function changeMechanics($name:String):*
		{
			_mechanics = null;
			switch($name)
			{
				case "match2game":
					_mechanics = new Match2Mech();
					break;
				
				case "sorting":
					_mechanics = new SortingMech();
					break;

				case "bubble":
					_mechanics = new BubbleMech();
					break;

				case "construct":
					_mechanics = new ConstructMech();
					break;
			}
		}
		
		
		private function createStuff($asset:Object):void 
		{ 
			var costume:MovieClip;
			var itemsCounter:int;
			var j:int;
			var i:int;

			GameFacade.currentGameType = $asset.type;
			_dummies = [];
			for (var k:int = 1; k < 13; k++) 
				dummies.push("dummy" + k);
			//dummies.sort(callbackRandom);
			_wallTop.boxBody.GetFixtureList().SetSensor(false);
			_wallBottom.boxBody.GetFixtureList().SetSensor(false);
			switch($asset.type)
			{
				case "sorting":
					_gameSkin.back.gotoAndStop("base");
					var bascket:MovieClip;
					bascketsArr = [];
					dummies = [];
					for (k = 1; k < 13; k++) 
						if (k != 5 && k != 9 && k != 8 && k != 4) dummies.push("dummy" + k);
						
					for (i = 0; i < $asset.setting.length; i++) 
					{
						bascket = new basckets();
						bascket.x = 200 * (i + 1);  
						bascket.y = 800;  
						bascket.name = $asset.setting[i];
						bascket.gotoAndStop($asset.setting[i]);
						_gameSkin.itemsContainer.addChild(bascket);
						obj = B2DFactory.actorSensor(bascket);
						obj.objectType = "GameObject";
						bascketsArr.push(obj);
						
						for (j = 0; j < 1; j++) 
						{
							costume = new colorStuff();
							costume.x = (_gameSkin.getChildByName(dummies[itemsCounter]) as MovieClip).x;  
							costume.y = (_gameSkin.getChildByName(dummies[itemsCounter]) as MovieClip).y;  
							
							costume.name = $asset.setting[i];
							costume.gotoAndStop($asset.setting[i]);
							_gameSkin.itemsContainer.addChild(costume);
							var obj:DynamicActor = B2DFactory.actor(costume);
							obj.objectType = "GameObject";
							_gameObjects.push(obj);
							itemsCounter++;
							trace(itemsCounter);
						}
						
					}
				break;
				
				case "match2game":
					_gameSkin.back.gotoAndStop("base");
					for (i = 0; i < $asset.setting.length; i++) 
					{
						for (j = 1; j < 3; j++) 
						{
							costume = new items();
							costume.x = (_gameSkin.getChildByName(dummies[itemsCounter]) as MovieClip).x;  
							costume.y = (_gameSkin.getChildByName(dummies[itemsCounter]) as MovieClip).y;  
							
							costume.name = $asset.setting[i];
							costume.gotoAndStop($asset.setting[i]);
							_gameSkin.itemsContainer.addChild(costume);
							obj = B2DFactory.actor(costume);
							obj.objectType = "GameObject";
							_gameObjects.push(obj);
							itemsCounter++;
							trace(itemsCounter);
							//obj.boxBody.ApplyImpulse(new b2Vec2(0, Math.random() * 20), obj.boxBody.GetPosition());
						}
					}
				break;
				
				
				case "twoPartsOfOneGame":
					for (i = 0; i < $asset.setting.length; i++) 
					{
						for (j = 1; j < 3; j++) 
						{
							costume = new items();
							costume.x = (_gameSkin.getChildByName(dummies[itemsCounter]) as MovieClip).x;  
							costume.y = (_gameSkin.getChildByName(dummies[itemsCounter]) as MovieClip).y;   
							
							costume.name = $asset.setting[i];
							costume.gotoAndStop($asset.setting[i]);
							_gameSkin.itemsContainer.addChild(costume);
							obj = B2DFactory.actor(costume);
							obj.objectType = "GameObject";
							_gameObjects.push(obj);
							itemsCounter++;
						}
					}
					break;
				
				case "bubble":
					_gameSkin.back.gotoAndStop("bubbles");
					_wallBottom.boxBody.GetFixtureList().SetSensor(true);
					var t:Number = 0;
					for (i = 0; i < 13; i++) 
					{ 
						delay(t, createItem);
						t += 0.4;
					}
					break;
 
				case "construct":
					building1;
					building2;
					building3;
					_gameSkin.back.gotoAndStop("construct");
					var linkName:Class = getDefinitionByName($asset.building) as Class;
					buildings = new linkName();
					buildings.name = "building";
					_gameSkin.back.addChild(buildings);
					buildings.x = 340; buildings.y = _gameSkin.back.buildHere.y;

					_wallTop.boxBody.GetFixtureList().SetSensor(true);
					var tt:Number = 0;
					for (i = 0; i < $asset.setting.length; i++) 
					{
						tt += 0.1;
						delay(tt, createItemForConstruct, [i]);
					}
					delay($asset.setting.length * 0.3 + 1.5, setLinearDamping);
					break;
				
			}
			changeMechanics($asset.type);
			//delay(3, antiGravi); 
		}
		
		private function setLinearDamping():void
		{
			for (var i:int = 0; i < _gameObjects.length; i++) 
			{
				_gameObjects[i].boxBody.SetLinearDamping(8);
			}
			
		}
		
		private function createItemForConstruct($i:int):void
		{
			var costume:MovieClip = new items();
			costume.x = 100 + Math.random() * 1000;  
			costume.y = -200// + Math.random() * 100;  
			
			costume.name = _currentAsset.setting[$i];
			costume.gotoAndStop(_currentAsset.setting[$i]);
			_gameSkin.itemsContainer.addChild(costume);
			if(costume.name == "triangle") 
				var obj:DynamicActor = B2DFactory.actorTriangle(costume);
			else
				if(costume.name == "circle") 
					obj = B2DFactory.actor(costume);
				else
					obj = B2DFactory.actorBox(costume);
			obj.objectType = "GameObject";
			_gameObjects.push(obj);
			obj.boxBody.SetLinearDamping(0);
			obj.boxBody.allowGravity = 7;
			obj.boxBody.SetFixedRotation(false);
			obj.boxBody.SetAngularDamping(1);
		}
		
		
		private function createItem():void
		{
			var costume:MovieClip = new items();
			costume.x = 100 + Math.random() * 1000;  
			costume.y = 900 + Math.random() * 200;  
			var size:Number = 0.3 + Math.random();
			costume.scaleX = size;
			costume.scaleY = size;
			costume.gotoAndStop("bubble");
			_gameSkin.itemsContainer.addChild(costume);
			var obj:DynamicActor = B2DFactory.actor(costume);
			obj.objectType = "GameObject";
			obj.boxBody.allowGravity = -((8 + Math.random() * 4) - size * 3);
			_gameObjects.push(obj);
		}
		
		
		private function antiGravi():void
		{
			trace(_gameObjects.length);
			for (var i:int = 0; i < _gameObjects.length; i++) 
			{
				_gameObjects[i].boxBody.allowGravity = 0;
				_gameObjects[i].boxBody.SetLinearDamping(8);
			}
			
		}		
		
		
		
		
		
	
//-----------------------------------------------------------------------------------------------------------------------------
//
//	destroing the game objects
//
//-----------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------
//
//	destroing the game objects
//
//-----------------------------------------------------------------------------------------------------------------------------
			
		public function initDestroyObject2($item:DynamicActor):void
		{
			$item.destroy();
			_gameObjects.pop();
		}
		
		
		public function initDestroyObject($item:DynamicActor):void
		{
			var objIndex:int = _gameObjects.indexOf($item);
			if(objIndex < 0) return;
			_gameObjects[objIndex].destroy();
			_gameObjects.splice(objIndex, 1);
		}
		
		public function destroyObject($item:DynamicActor):void
		{
			_destroyedBodies.push($item.boxBody);
		}
		
		
		
		public function destroyAllObjects():void
		{
			killDelay();
			GameFacade.myStage.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			if(_mechanics) _mechanics.dispose();
			_mechanics = null;
			if(bascketsArr.length > 0) 
				
			
			for (var i:int = 0; i < bascketsArr.length; i++) 
			{
				initDestroyObject(bascketsArr[i]);
			} 
			
			for (i = 0; i < _gameObjects.length; i++) 
			{
				_gameObjects[i].destroyUrgent();
			}
			
			for (var worldbody:b2Body = PhysiVals._world.GetBodyList(); worldbody; worldbody = worldbody.GetNext()) 
			{
				PhysiVals._world.DestroyBody(worldbody);
			}
			
			_gameObjects.length = 0;
			bascketsArr.length = 0;
			_walls.length = 0;
			
			if(_wallTop && _wallTop.boxBody.GetFixtureList()) _wallTop.boxBody.GetFixtureList().SetSensor(false);
			if(_wallBottom && _wallBottom.boxBody.GetFixtureList()) _wallBottom.boxBody.GetFixtureList().SetSensor(false);
			
		}
		
		
//-----------------------------------------------------------------------------------------------------------------------------
//
//	b2d physic functionality
//
//-----------------------------------------------------------------------------------------------------------------------------
		private var _wallBottom:DynamicActor;
		private var _wallTop:DynamicActor;

		private var _currentAsset:Object;
		public var buildings:MovieClip;
		
		private function createWall():void 
		{
			if(_walls.length != 0 || _walls[0]) return;
			for (var i:int = 1; i < 5; i++) 
			{
				var obj:DynamicActor = B2DFactory.wall(_gameSkin.getChildByName("wall" + i) as MovieClip);
				obj.objectType = "BaseObject";
				_walls.push(obj);
				if(i == 2) _wallTop = obj;
				if(i == 4) _wallBottom = obj;
			}
		}
		
		
		private function setupPhysicsWorld():void 
		{
			var gravity:b2Vec2 = new b2Vec2(0, 10);
			var allowSleep:Boolean = true;			
			PhysiVals.world = new b2World(gravity, allowSleep);
		}
		
		
		
		private function debugDraw():void 
		{
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			var debugSprite:Sprite = new Sprite();
			debugSprite.mouseEnabled = false;
			_gameSkin.addChild(debugSprite);
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(PhysiVals.RATIO);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
			debugDraw.SetFillAlpha(0.5);
			PhysiVals._world.SetDebugDraw(debugDraw);
		}
		
		
		protected function onEnterFrameHandler(event:Event):void
		{
			PhysiVals.world.Step(0.025, 10, 10);
			
			PhysiVals.world.ClearForces();
	
			while(_destroyedBodies.length > 0) 
			{
				PhysiVals.world.DestroyBody(_destroyedBodies.shift());
				trace("A");
			}
				
			//PhysiVals.world.DrawDebugData();
		}
		
	}

}