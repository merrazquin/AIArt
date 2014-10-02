package 
{
	import com.greensock.easing.Ease;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Marcela Errazquin
	 */
	public class Main extends Sprite 
	{
		private var _antPost:Point;
		private var _rotation:Number = 0;
		private var _ant:Ant;
		
		private var _ticker:Number = 0;
		private static const INTERVAL:Number = 30;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function createGrid($cols:Number, $rows:Number):void 
		{
			for (var i:int = 0; i < $cols; i++) 
			{
				for (var j:int = 0; j < $rows; j++) 
				{
					var cell:Cell = new Cell();
					cell.x = Cell.CELL_SIZE + (i * Cell.CELL_SIZE);
					cell.y = Cell.CELL_SIZE + (j * Cell.CELL_SIZE);
					addChild(cell);
				}
				
			}
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			createGrid(21, 21);
			_ant = new Ant();
			addChild(_ant);
			var cell:Cell = getObjectsUnderPoint(new Point(int(width / 2), int(height / 2)))[0] as Cell;
			_ant.x = cell.x;
			_ant.y = cell.y;
			TweenLite.delayedCall(5, moveAnt);
		}
		
		private function moveAnt():void 
		{
			var currPos:Point = new Point(_ant.x, _ant.y);
			var cell:Cell = getObjectsUnderPoint(currPos)[0] as Cell;
			if (!cell)
			{
				trace("ran out of cells");
				return;
			}
			trace("cell.alive", cell.alive);
			_ant.rotation += cell.alive ? 90 : -90;
			_rotation += cell.alive ? 90 : -90;
			if (_rotation < 0)
			{
				_rotation += 360;
			}
			if (_rotation >= 360)
			{
				_rotation -= 360;
			}
			trace(_rotation);
			cell.alive = !cell.alive;
			
			var newPoint:Point = currPos.clone();
			switch(_rotation)
			{
				case 0:
					newPoint.y -= Cell.CELL_SIZE;
					break;
				case 90:
					newPoint.x += Cell.CELL_SIZE;
					break;
				case 180:
					newPoint.y += Cell.CELL_SIZE;
					break;
				case 270:
					newPoint.x -= Cell.CELL_SIZE;
					break;
			}
			_ant.x = newPoint.x;
			_ant.y = newPoint.y;
			TweenLite.delayedCall(.1, moveAnt);
			//TweenLite.to(_ant, .1, { x:newPoint.x, y:newPoint.y, onComplete:moveAnt, ease:Linear.easeNone});
		}
		
	}
	
}