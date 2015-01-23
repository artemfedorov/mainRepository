package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	[SWF(width="1280", height="720", backgroundColor="#000000", frameRate="24")]
	
	
	
	
	public class ADMovie extends Sprite
	{

		
		
		private var flvs:Array = [{name:"KORABL_CAM1.flv", width:1280, height:341, t:10.41, x:14.15, y:232.6},
								  {name:"KORABL_CAM2.flv", width:1280, height:720, t:10.41, x:0, y:0},
								  {name:"KORABL_CAM3.flv", width:1280, height:720, t:10.41, x:0, y:0}];
			
		private var colors:Array = [0x66CCFF, 0xCCCCCC, 0x82BCCC, 0xffffff, 0x666666];
		private var ship:MovieClip;
		private var planet:Planet;
		private var under:MovieClip;
		private var staticStars:Sprite;
		private var over:MovieClip;
		//private var spaces:MovieClip;
		
		private var stars:Array = [];
		
		private var currentFrame:uint;

		private var b:Sprite;

		private var vid:Video;

		private var nc:NetConnection;

		private var ns:NetStream;

		private var listener:Object;

		private var index:int;
		private var ships:Array = [];
		private var oldIndex:int;

		public function ADMovie()
		{
			var m:Sprite = new Sprite();
			
			m.graphics.beginFill(0x000000);
			m.graphics.drawRect(0, 0, 1280, 720);     
			m.graphics.endFill();
			this.addChild(m);
			this.mask = m;
			b = new Sprite();
			staticStars = new Sprite();
			b.addChild(staticStars);
			
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0, 0, 1280, 720);     
			this.graphics.endFill();
			this.addChild(b);
			
			// = new s2;
			//stage.addChild(spaces);
			stage.quality = StageQuality.MEDIUM;
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			over = new MovieClip();
			under = new MovieClip();
			//ship = new ship2();
			
			b.addChild(over);
			b.addChild(under);
			//b.addChild(ship);
			//ship.gotoAndStop(1);
			
			startGenerateStars();
			generatePlanet();
			generateStars();
			
			for (var i:int = 0; i < flvs.length; i++) 
			{
				var vid:Video = new Video(flvs[i].width, flvs[i].height);
				vid.visible = false;
				vid.x = flvs[i].x;
				vid.y = flvs[i].y;
				vid.smoothing = true;
				b.addChild(vid);
				ships[i] = {v:vid, p:flvs[i].name, t:flvs[i].t};
			}
			alphaUp();
		}
		
		
		
		
		
		
		private function startGenerateStars():void
		{
			var s:Sprite;
			var platformBitmap:Bitmap;
			var rx:Number;
			var ry:Number;
			var color:uint;
			
			for (var i:int = 0; i < 5000; i++) 
			{
				rx = Math.random() * stage.width;
				ry = Math.random() * stage.height;
				s = new Sprite();
				s.graphics.clear();
				color = colors[int(Math.random() * colors.length)];
				s.graphics.beginFill(color);
				s.graphics.drawCircle(0, 0, Math.random() * 2);     
				s.graphics.endFill();
				//platformBitmapData = new BitmapData(s.width, s.height);
				//platformBitmapData.draw(s);
				
				s.x = rx;
				s.y = ry;
				staticStars.addChild(s);
			}
			staticStars.alpha = 0.3;
			staticStars.cacheAsBitmap = true;
		}
		
		private function generateStars():void
		{
			var s:Sprite;
			var platformBitmap:Bitmap;
			var rx:Number;
			var ry:Number;
			var color:uint;
			var c:int = Math.random() * 60;
			
			for (var i:int = 0; i < c; i++) 
			{
				rx = Math.random() * stage.width;
				ry = Math.random() * stage.height;
				s = new Sprite();
				s.graphics.clear();
				color = colors[int(Math.random() * colors.length)];
				s.graphics.beginFill(color);
				var r:Number = Math.random() * 2;
				s.graphics.drawCircle(0, 0, r);     
				s.graphics.endFill();
				//platformBitmapData = new BitmapData(s.width, s.height);
				//platformBitmapData.draw(s);
				
				s.x = 2000;
				s.y = ry;
				var v:Number = 200 - (r * 80);
				if(Math.random() > 0.9) v = Math.random() *2;
				TweenMax.to(s, v, {x:0, ease:Linear.easeNone, onComplete:onCompleteStar, onCompleteParams:[s]});
				over.addChild(s);
			}
			
			TweenMax.delayedCall(Math.random(), generateStars);
		}
		
		private function onCompleteStar(s:Sprite):void
		{
			s.parent.removeChild(s);
			s = null;
		}
		
		
		
		
		private function animateShip():void
		{
			oldIndex = index;
			TweenMax.delayedCall(ships[index].t - 0.5, alphaUp);
		}
		
		
		private function alphaUp():void
		{
			index = generateIndex();
			var flvName:String = ships[index].p;
			trace(flvName);
			if(ns) ns.dispose();
			ships[oldIndex].v.visible = false;
			removeAllPlanets();
			generateNewPlanets();
			nc = new NetConnection();
			nc.connect(null);
			
			ns = new NetStream(nc);
			ships[index].v.attachNetStream(ns);
			
			listener = new Object();
			listener.onMetaData = function(evt:Object):void {};
			ns.client = listener;
			ships[index].v.visible = true;
			ships[index].v.smoothing = true;
			ns.play(flvName);
			animateShip();
			
			//TweenMax.to(b, 0, {alpha:1, onComplete:animateShip});
		}
		
		private function generateIndex():int
		{
			var i:int;
			do
			{
				i = int(Math.random() * ships.length);
			}
			while(i == index)
				return i;
		}
		
		private var planets:Array = [];
		
		
		private function removeAllPlanets():void
		{
			while(planets.length > 0)
			{
				
				if(planets[0])
				{
					planets[0].destroy();
					planets.splice(0, 1);
				}
			}
			
		}
		
		private function generateNewPlanets():void
		{
			var amount:int = 1 + int(Math.random() * 2);
				for (var i:int = 0; i < amount; i++) 
				{
					var type:int = int(Math.random() * 3);
					planet = new Planet(type, currentFrame, true);
					planets.push(planet);
					under.addChild(planet);
					
				}
				
		}
		
		private function generatePlanet():void
		{
			var type:int = int(Math.random() * 3);
			planet = new Planet(type, currentFrame, false);
			under.addChild(planet);
			planets.push(planet);
			TweenMax.delayedCall(Math.random() * 10, generatePlanet);
		}
		
		
		public static function removeMe($mc:MovieClip):void
		{
			if($mc.parent) $mc.parent.removeChild($mc);
			$mc = null;
		}
		
		
	}
}