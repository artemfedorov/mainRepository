package own.fedorov.engine.model 
{
	import flash.display.MovieClip;
	
	import org.robotlegs.mvcs.Actor;
	
	import own.fedorov.engine.values.LayoutsData;
	
	/**
	 * ...
	 * @author Artem Fedorov aka Wizard
	 */
	
	public class MainModel extends Actor
	{
		private var _pictures:Vector.<MovieClip>;
		private var _currentLayoutIndex:int = 1;
		private var _usedPics:Vector.<MovieClip>;
		private var _generalHeight:Number;
		
		public function MainModel() 
		{
			_pictures = new Vector.<MovieClip>;
			_usedPics = new Vector.<MovieClip>;
			_generalHeight = LayoutsData.LAYOUT_HEIGHT / 4;
			super();
		}
		
		
		
		public function get currentLayoutIndex():int
		{
			return _currentLayoutIndex;
		}

		
		public function changePicture(picture:MovieClip):MovieClip
		{
			var newPicture:MovieClip = getPictureWidth(picture.maxWidth);
			if(newPicture) 
			{
				picture.height = _generalHeight;
				picture.width *= picture.ar;
				_pictures.push(picture);
				_usedPics.splice(_usedPics.indexOf(picture), 1);
				newPicture.mouseEnabled = false;
				return newPicture;
			}
			return picture;
		}

		public function addPicture(container:MovieClip):void
		{
			var ar:Number = container.width / container.height;
			container.ar = ar;
			container.height = _generalHeight;
			container.width *= ar;
			_pictures.push(container);		
		}
		
		
		
		public function getPictureWidth(maxWidth:Number):MovieClip
		{
			for (var i:int = 0; i < _pictures.length; i++) 
			{
				if(_pictures[i].width <= maxWidth) 
				{
					var r:MovieClip =  _pictures[i];
					_pictures.splice(i, 1);
					_usedPics.push(r);
					return r;
				}
			}
			return null;
		}

		public function getPictureAspectRatio(min:Number, max:Number):MovieClip
		{
			var ar:Number;
			for (var i:int = 0; i < _pictures.length; i++) 
			{
				ar = _pictures[i].ar;
				if(ar >= min && ar <= max) 
				{
					var r:MovieClip =  _pictures[i];
					_pictures.splice(i, 1);
					_usedPics.push(r);
					return r;
				}
			}
			return null;
		}
		
		
		
		
		public function getPicture():MovieClip
		{
			return _pictures[0];
		}
	}
}