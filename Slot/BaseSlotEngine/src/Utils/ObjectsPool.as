package Utils 
{
	import entities.MySpriteEntity;
	/**
	 * ...
	 * @author 
	 */
	public class ObjectsPool 
	{
		
		
		
		static private var _pool:Vector.<MySpriteEntity> = new Vector.<MySpriteEntity>;
		
		
		public static function poolIn($entity:MySpriteEntity):void
		{
			_pool.push($entity);
		}
		
		public static function poolOut():MySpriteEntity
		{
			var entity:MySpriteEntity = _pool.pop();
			return entity;
		}
		
	}

}