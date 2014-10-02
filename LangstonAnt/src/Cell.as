package  
{
	import flash.display.Sprite;
	
	/**
	 * @author Marcela Errazquin
	 */
	public class Cell extends Sprite 
	{
		public static const CELL_SIZE:Number = 20;
		private var _alive:Boolean;
		public function Cell($alive:Boolean = false) 
		{
			super();
			alive = $alive;
		}
		
		public function get alive():Boolean { return _alive; }
		
		public function set alive(value:Boolean):void 
		{
			_alive = value;
			graphics.clear();
			graphics.beginFill(int(!_alive) * 0xFFFFFF);
			graphics.drawRect(-CELL_SIZE*.5, -CELL_SIZE*.5, CELL_SIZE, CELL_SIZE)
			graphics.endFill();
		}
	}
	
}