package model.mechanics
{
	import events.ApplicationEvents;
	
	import superClasses.DynamicActor;
	import superClasses.NonB2DActor;

	public interface IMechanics
	{
		function collided($item1:DynamicActor, $item2:DynamicActor):void
		function collided2($item1:NonB2DActor, $item2:NonB2DActor):void
		function touched(e:ApplicationEvents):void
		function levelComplete():void
		function dispose():void
	}
}