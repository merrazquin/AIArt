package  
{
	import fl.controls.listClasses.CellRenderer;
	import flash.display.Sprite;
	import flash.events.Event;

	
	/**
	 * @author Marcela Errazquin
	 */
	public class ListIcon extends Sprite
	{
		
		public function ListIcon() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function drawGFX($color:uint):void 
		{
			graphics.beginFill($color);
			graphics.drawRect(0, 0, 20, 20);
			graphics.endFill();			
		}
		
		private function onAdded($event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			var cell:CellRenderer = this.parent as CellRenderer;
			drawGFX(cell.data.data as uint);
		}
	}
	
}