package own.fedorov.engine.view
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import org.robotlegs.mvcs.Mediator;
	
	import own.fedorov.engine.events.GalleryEvent;
	import own.fedorov.engine.model.MainModel;
	import own.fedorov.engine.values.LayoutsData;
	import own.fedorov.engine.view.components.Layout;
	
	public class LayoutMediator extends Mediator
	{
		public function LayoutMediator()
		{
			super();
		}
		
		[Inject]
		public var view:Layout;
		
		[Inject]
		public var mainModel:MainModel;
		
		private var _widthLeft:Number;
		private var _heightLeft:Number;
		private var _currentX:Number;
		private var _currentY:Number;
		private var _maxHeight:Number;
		private var _borderSize:Number = 10;
		private var _row:Array;
		private var _counter:uint;
		private var counter:int;
		
		
		override public function onRegister():void
		{
			eventMap.mapListener(view, MouseEvent.MOUSE_OVER, onMouseOver);
			eventMap.mapListener(view, MouseEvent.MOUSE_OUT, onMouseOut);
			eventMap.mapListener(view, MouseEvent.CLICK, onMouseClick);
			view.addEventListener(GalleryEvent.LAYOUT_CREATED, onLayoutCreated);
			
		}
		
	
		
		protected function onLayoutCreated(event:GalleryEvent):void
		{
			_row = [];
			_widthLeft = LayoutsData.LAYOUT_WIDTH;
			_heightLeft = LayoutsData.LAYOUT_HEIGHT;
			_currentX = 0;
			_currentY = 0;
			_maxHeight = LayoutsData.LAYOUT_HEIGHT / 4;
			fillView();
		}
		
		private function fillView(source:Array = null):void
		{
			var currentPicture:MovieClip = mainModel.getPictureWidth(_widthLeft);
			if(!currentPicture) 
			{
				for (var i:int = 0; i < _row.length; i++) 
				{
					_row[i].x += _widthLeft / 2;
					_row[i].oldX = _row[i].x;
					_row[i].oldY = _row[i].y;
				}
				_row.length = 0;
				_currentX = 0;
				if(_currentY >= LayoutsData.LAYOUT_HEIGHT - _maxHeight) 
					return;
				_currentY += _maxHeight + _borderSize;
				_widthLeft = LayoutsData.LAYOUT_WIDTH;
				currentPicture = mainModel.getPictureWidth(_widthLeft);
				if(!currentPicture) 
					return;
			}
			counter++;
			view.addPictureAt(currentPicture, _currentX, _currentY);
			_row.push(currentPicture);
			_currentX += currentPicture.width + _borderSize;
			_widthLeft -= currentPicture.width + _borderSize;
			currentPicture.oldX = currentPicture.x;
			currentPicture.oldY = currentPicture.y;
			currentPicture.oldScaleX = currentPicture.scaleX;
			currentPicture.oldScaleY = currentPicture.scaleY;
			currentPicture.maxWidth = currentPicture.width;
			currentPicture.maxHeight = currentPicture.height;
			fillView();
		}		
		
				
		
		private function onMouseOver(e:Event):void
		{
			view.swapChildrenAt(view.getChildIndex(e.target as DisplayObject), view.numChildren - 1);
			TweenMax.to(e.target, 0.4, {scaleX: e.target.scaleX + 0.025});			
			TweenMax.to(e.target, 0.4, {scaleY: e.target.scaleY + 0.025});	
			TweenMax.to(e.target, 0.4, {x: e.target.x - 5});	
			TweenMax.to(e.target, 0.4, {y: e.target.y - 5});	
			(e.target as MovieClip).filters = new Array(new DropShadowFilter(10, 0, 0, 0.5, 20, 20));
		}
		
		private function onMouseOut(e:Event):void
		{
			TweenMax.to(e.target, 0.4, {scaleX: e.target.oldScaleX});			
			TweenMax.to(e.target, 0.4, {scaleY: e.target.oldScaleY});	
			TweenMax.to(e.target, 0.4, {y: e.target.oldY});	
			TweenMax.to(e.target, 0.4, {x: e.target.oldX});	
			(e.target as MovieClip).filters = null;
			
		}		
		
		
		private function onMouseClick(e:Event):void
		{
			TweenMax.to(e.target, 0.2, {alpha: 0, onComplete:fadeOutComplete, onCompleteParams:[e.target as MovieClip]});
		}
		
		private function fadeOutComplete(oldPicture:MovieClip):void
		{
			view.removeChild(oldPicture);
			var newPicture:MovieClip = mainModel.changePicture(oldPicture);
			newPicture.alpha = 0;
			newPicture.maxWidth = oldPicture.maxWidth;
			newPicture.maxHeight = oldPicture.maxHeight;
			newPicture.oldScaleX = newPicture.scaleX;
			newPicture.oldScaleY = newPicture.scaleY;
			view.addPictureAt(newPicture, oldPicture.oldX, oldPicture.oldY);
			newPicture.oldX = oldPicture.oldX;
			newPicture.oldY = oldPicture.oldY;
			TweenMax.to(newPicture, 0.2, {alpha: 1, onComplete:fadeInComplete, onCompleteParams:[newPicture]});

		}
		
		private function fadeInComplete(picture:MovieClip):void
		{
			picture.mouseEnabled = true;
		}
		
	}
}