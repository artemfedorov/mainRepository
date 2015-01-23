package
{
	public class Config
	{

		// GUN SETTINGS
		
		public static var gun1:Object = 
			{
				attackRadius:   300,
				shootFrequency: 0.5,
				lethalForce:   20
			}
			
			
		public static var gun2:Object = 
			{
				attackRadius:   300,
				shootFrequency: 1,
				lethalForce:   10
			}

		public static var gun3:Object = 
			{
				attackRadius:   400,
				shootFrequency: 0.1,
				lethalForce:   40
			}
		
		public static var gun4:Object = 
			{
				attackRadius:   350,
				shootFrequency: 0.3,
				lethalForce:   30
			}
			
			
		// ENEMY SETTINGS
			
		public static var enemy1:Object = 
			{
				speed: 50
			}
			
			
		// WAVES
			
		public static var wave1:Object = 
			{
				enter: 1,
				frequency:2,
				enemies: [{type:1, count:10},{type:1, count:10}, {type:1, count:10}]
				
			}
		
	}
}