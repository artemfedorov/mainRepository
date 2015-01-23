package lines
{
	import com.greensock.TweenMax;
	
	import entities.MySpriteEntity;
	
	import starling.textures.TextureAtlas;
	
	public class BaseLineView extends MySpriteEntity
	{
		
		public var leftBox:MySpriteEntity;
		public var rightBox:MySpriteEntity;
		
		
		/**
		 * 
		 * @param $atlas
		 * @param $type
		 * @param $touchable
		 * 
		 */
		public function BaseLineView($atlas:TextureAtlas, $type:String, $touchable:Boolean = true)
		{
			super($atlas, $type, $touchable);
		}
		
		/**
		 *Показать выигрыш 
		 * @param $sum - сумма выигрыша показывается на боксах
		 * @param $delay время показа
		 * @param $animate
		 * 
		 */		
		public function showWinning($sum:Number = 0, $delay:Number = 1, $animate:Boolean = false):void
		{
			show();
			TweenMax.delayedCall($delay, hide);
		}
		
		
		
		
		/**
		 *показать боксы 
		 * 
		 */
		public function setActive():void
		{
			show();
			leftBox.visible = true;
			rightBox.visible = true;
		}
		
		
		/**
		 *спрятать боксы 
		 * 
		 */
		public function setInactive():void
		{
			hide();
			leftBox.visible = false;
			rightBox.visible = false;
		}
		
		
		/**
		 *показать саму линию 
		 * 
		 */		
		public function show():void
		{
			mc.visible = true;
		}
		
		/**
		 *спрятать саму линию 
		 * 
		 */	
		public function hide():void
		{
			mc.visible = false;
		}
		
		
		
	}
}