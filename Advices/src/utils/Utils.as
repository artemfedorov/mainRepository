package  utils 
{
	import com.greensock.TweenMax;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @author rocket
	 */
	public class Utils 
	{
		public static var toFixedValue:int;
		public static var denominationValue:Number;
		
		public static function convertToCredits($value:Number):int
		{
			//var temp:Number = Math.pow(10, 1);
			//return Math.round(($value / denominationValue) * temp) / temp;
			
			return normalizeMathAction($value, denominationValue, "/");
		}
		
		public static function convertFromCredits($value:Number):Number
		{
			//var temp:Number = Math.pow(10, 1);
			//return Math.round(($value * denominationValue) * temp) / temp;
			
			return normalizeMathAction($value, denominationValue, "*");
		}
		
		/**
		 * Правильныйе расчеты умножения, деления, сложения и вычитания
		 * @param	$value1
		 * @param	$value2
		 * @param	$action - значение действия в стринге ("+", "-", "*", "/")
		 * @return
		 */
		public static function normalizeMathAction($value1:Number, $value2:Number, $action:String):Number
		{
			var value:Number;
			var temp:Number = Math.pow(1 / denominationValue, 1);
				
			if (denominationValue == 1)
			{
				switch ($action) 
				{
					case "+":
						value = int(($value1 + $value2) * temp) / temp;
					break;
					case "-":
						value = int(($value1 - $value2) * temp) / temp;
					break;
					case "*":
						value = int(($value1 * $value2) * temp) / temp;
					break;
					case "/":
						value = int(($value1 / $value2) * temp) / temp;
					break;
				}
			}			
			else
			{
				switch ($action) 
				{
					case "+":
						value =  Math.round(($value1 + $value2) * temp) / temp;
					break;
					case "-":
						value = Math.round(($value1 - $value2) * temp) / temp;
					break;
					case "*":
						value =  Math.round(($value1 * $value2) * temp) / temp;
					break;
					case "/":
						value = Math.round(($value1 / $value2) * temp) / temp;
					break;
				}
			}
			return value;
		}
		
		public static function clearAll($object:DisplayObjectContainer):void 
		{
			if (!$object) return;
			while ($object.numChildren > 0)
				if ($object.getChildAt(0).parent)
					$object.removeChildAt(0);
		}
		
		public static function randRange(minNum:Number, maxNum:Number, round:Boolean = false):Number 
        {
			var value:Number = Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum;
			if (round)
				value = Math.round(value);
				
			return value;
        }
		
		
		public static function cloneObject(source:MovieClip):MovieClip
		{
			var objectClass:Class = Object(source).constructor;
			var instance:MovieClip = new objectClass() as MovieClip;
			instance.transform = source.transform;
			instance.filters = source.filters;
			instance.cacheAsSmartBitmapBitmapBitmap = source.cacheAsSmartBitmapBitmapBitmap;
			instance.opaqueBackground = source.opaqueBackground;
			return instance;
		}

		public static function copyObject(objectToCopy:*):*
		{
			var stream:ByteArray = new ByteArray();
			stream.writeObject(objectToCopy);
			stream.position = 0;
  
			return stream.readObject();
		}
		
		public static function countOf($object:Object):int
		{
			var count:int = 0;
			for (var key:String in $object)
				count++;
			
			return count;
		}
		
		public static function checkCopyInArray($arr:Array, $element:Object):Boolean
		{
			if ($arr.indexOf($element) == -1)
				return false;
				
			return true;
		}
		
		public static function valueToFixed($value:Number):String
		{
			if ($value == 0)
				return $value.toString();
				
			return $value.toFixed(toFixedValue);
		}
		
	}

}