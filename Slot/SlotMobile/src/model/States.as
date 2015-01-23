package model
{
	public class States extends BaseStates
	{
		public function States()
		{
			super();
		}
		
		
		override protected function start():void
		{
			queueStates = 
				[ 
					IDLE_STATE,
					SPIN_STATE, 
					COLLECT_STATE,
					SHOW_LINES, 
					SHOW_SCATTERS, 
					START_FREESPINS,
					ADD_FREESPINS,
					FINISH_FREESPINS,
					BONUS_STATE 
				];
			super.start();
		}
	}
}