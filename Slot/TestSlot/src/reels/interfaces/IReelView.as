package reels.interfaces
{
	public interface IReelView
	{
		function start():void;
		function stop():void;
		function setReelNumber(n:uint):void;
		function setXY(nx:Number, ny:Number):void
	}
}