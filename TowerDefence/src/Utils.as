package
{
	
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author artem fedorov
	 */
	public class Utils
	{
		
		static public function degreesToRadians(degrees:Number):Number 
		{
			return degrees * (Math.PI / 180);
		}
		static public function radiansToDegrees(radians:Number):Number 
		{
			return radians * (180 / Math.PI);
		}
		/**
		 * returns angle in degrees of object at x1, y1 to rotate towards point x2, y2
		 * @param	x1 
		 * @param	y1
		 * @param	x2
		 * @param	y2
		 * @return angle of rotation in degrees
		 */
		static public function rotateTowards(x1:Number, y1:Number , x2:Number , y2:Number ):Number 
		{
			var dx:Number = x1 - x2;
			var dy:Number  = y1 - y2;
			var radianAngle:Number = Math.atan2(dy, dx);
			return radianAngle;
		}
		
		
		static public function distanceBetweenTwoPoints(x1:Number, y1:Number , x2:Number , y2:Number ):Number 
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return  Math.sqrt(dx * dx + dy * dy);
		}
	}
	
}