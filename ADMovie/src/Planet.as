package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class Planet extends MovieClip
	{
		private var skin:MovieClip;
		private var bb:int;
		private var immidiatly:Boolean;
		private var flvs:Array = [{name:"RED.flv", width:500, heigth:284, t:10.45, x:0, y:0},
			{name:"BLUE.flv", width:500, heigth:282, t:5.25, x:0, y:0},
			{name:"BRONZE.flv", width:500, heigth:500, t:10.45, x:0, y:0}];

		private var vid:Video;

		private var ns:NetStream;

		private var listener:Object;

		private var nc:NetConnection;
		
		
		public function Planet($type:int, b:int = 1, imm:Boolean = false)
		{
			super();
			immidiatly = imm;
			bb = b;
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var scale:Number = Math.random() * 2;
			var t:Number = 3 + Math.random() * (20 * scale);
			if(bb > 1)
			{
				TweenMax.to(this, t, {scaleX:this.scaleX / 3});
				TweenMax.to(this, t, {scaleY:this.scaleY / 3});
				
				
				var f:Number = Math.random() * 300;
				var s:Number = f + 300;
				
				this.y = s;
				TweenMax.to(this, t, {y:f});
			}
			else
			{
				this.y = Math.random() * (stage.height);
			}
			if(immidiatly) this.x = Math.random() * 1280
			else this.x = 2200;
			var index:int = int(Math.random() * flvs.length);
			var w:Number = flvs[index].width * scale;
			var h:Number = flvs[index].heigth * scale;
			vid = new Video(w, h);
			vid.x = flvs[index].x;
			vid.y = flvs[index].y;
			var flvName:String = flvs[index].name;
			this.addChild(vid);
			
			nc = new NetConnection();
			nc.connect(null);
			
			ns = new NetStream(nc);
			vid.attachNetStream(ns);
			
			listener = new Object();
			listener.onMetaData = function(evt:Object):void {};
			ns.client = listener;
			
			ns.play(flvName);
			vid.smoothing = true;
			
			TweenMax.to(this, t, {x:-flvs[index].width * scale, onComplete:destroy, ease:Linear.easeNone});
		}
		
		
		public function destroy():void
		{
			ns.dispose();
			if(vid) vid.parent.removeChild(vid);
			listener = null;
			skin = null;
			nc = null;
			vid = null;
			ADMovie.removeMe(this);
		}
	}
}