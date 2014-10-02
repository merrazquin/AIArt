package  
{
	import flash.display.Sprite;
	

	
	/**
	 * @author Marcela Errazquin
	 */
	public class Ant extends Sprite 
	{
		
		public function Ant() 
		{
			super();
			graphics.beginFill(0xFF0000);
			graphics.moveTo(0, -5);
			graphics.lineTo(5, 8);
			graphics.lineTo( -5, 8);
			graphics.lineTo(0, -5);
			graphics.endFill();
		}
	}
	
}