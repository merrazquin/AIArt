package 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Marcela Errazquin
	 */
	public class Main extends Sprite 
	{
		private var _controlBar:ControlBar;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			createUI();
			redraw();
		}
		
		private function createUI():void 
		{
			_controlBar = new ControlBar();
			_controlBar.addEventListener(Event.CHANGE, onRuleChanged);
			_controlBar.y = stage.stageHeight - _controlBar.height;
			addChild(_controlBar);

		}
		
		private function onRuleChanged(e:Event):void 
		{
			redraw();
		}
		
		private function redraw():void 
		{
			graphics.clear();
			var rules:Array = RulesE.getRules(_controlBar.rule);
			var colors:Array = _controlBar.colors;
			for each(var rule:RulesE in rules)
			{
				var color:uint = colors.shift();
				rule.primaryColor = color;
				colors.push(color);
				
				color = colors.shift();
				colors.push(color);
				rule.secondaryColor = color;
			}
			
			var pixelSize:Number = _controlBar.pixelSize;
			var numCols:int = Math.floor(stage.stageWidth / pixelSize);
			var numRows:int = Math.floor((stage.stageHeight - _controlBar.height) / pixelSize);
			var firstGen:Array = [];
			for(var i:int = 0; i < numCols; i++)
			{
				firstGen.push(new Cell());
			}
			var centerCell:Cell = firstGen[Math.round(numCols/2)];
			centerCell.state = 1;
			colors.push(centerCell.primaryColor = colors.shift());
			colors.push(centerCell.secondaryColor = colors.shift());
			var gen:Array = createGenerations([firstGen], rules, numRows);
			drawGenerations(gen, pixelSize);			
		}
		
		private function drawGenerations($gen:Array, pixelSize:Number):void 
		{
			var currX:Number = 0;
			var currY:Number = 0;
			for each(var generation:Array in $gen)
			{
				for each(var cell:Cell in generation)
				{
					if (cell.state)
					{
						var random1:Number = Math.random();
						var random2:Number = Math.random();
						if (random1 > .5)
						{
							drawTLTriangle(graphics, random2 > .5 ? cell.primaryColor : cell.secondaryColor, currX, currY, pixelSize);
							drawBRTriangle(graphics, random2 > .5 ? cell.secondaryColor : cell.primaryColor, currX, currY, pixelSize);
						}
						else
						{
							drawTRTriangle(graphics, random2 > .5 ? cell.primaryColor : cell.secondaryColor, currX, currY, pixelSize);
							drawBLTriangle(graphics, random2 > .5 ? cell.secondaryColor : cell.primaryColor, currX, currY, pixelSize);
						}
					}
					currX += pixelSize;
				}
				currX = 0;
				currY += pixelSize;
			}
		}
		
		private function drawBRTriangle($graphics:Graphics, $color:uint, $x:Number, $y:Number, $pixelSize:Number):void 
		{
			$graphics.beginFill($color);
			$graphics.moveTo($x + $pixelSize, $y + $pixelSize);
			$graphics.lineTo($x + $pixelSize, $y);
			$graphics.lineTo($x, $y + $pixelSize);
			$graphics.lineTo($x + $pixelSize, $y + $pixelSize);
			$graphics.endFill();
		}
		
		private function drawBLTriangle($graphics:Graphics, $color:uint, $x:Number, $y:Number, $pixelSize:Number):void 
		{
			$graphics.beginFill($color);
			$graphics.moveTo($x, $y + $pixelSize);
			$graphics.lineTo($x + $pixelSize, $y + $pixelSize);
			$graphics.lineTo($x, $y);
			$graphics.lineTo($x, $y + $pixelSize);
			$graphics.endFill();
		}
		
		private function drawTLTriangle($graphics:Graphics, $color:uint, $x:Number, $y:Number, $pixelSize:Number):void 
		{
			$graphics.beginFill($color);
			$graphics.moveTo($x, $y);
			$graphics.lineTo($x + $pixelSize, $y);
			$graphics.lineTo($x, $y + $pixelSize);
			$graphics.lineTo($x, $y);
			$graphics.endFill();
		}
		
		private function drawTRTriangle($graphics:Graphics, $color:uint, $x:Number, $y:Number, $pixelSize:Number):void 
		{
			$graphics.beginFill($color);
			$graphics.moveTo($x + $pixelSize, $y);
			$graphics.lineTo($x + $pixelSize, $y + $pixelSize);
			$graphics.lineTo($x, $y);
			$graphics.lineTo($x + $pixelSize, $y);
			$graphics.endFill();
		}
		
		
		private function printGenerations($gen:Array):void 
		{
			for each(var generation:Array in $gen)
			{
				trace(generation.join("") + "\n");
			}
		}
		
		private function createGenerations($generations:Array, $rules:Array/*RulesE*/, $depth:int):Array 
		{
			if (!$depth || !$generations.length)
			{
				return $generations;
			}
			
			var currentGeneration:Array = $generations[$generations.length - 1];
			var nextGeneration:Array = [];
			
			
			for (var i:int = 0; i < currentGeneration.length; i++) 
			{
				var comparisonStr:String = "";
				
				if (i == 0) comparisonStr += "0";
				else comparisonStr += currentGeneration[i - 1].state ? "1" : "0";
				comparisonStr += currentGeneration[i].state ? "1" : "0";
				if (i == currentGeneration.length -1) comparisonStr += "0";
				else comparisonStr += currentGeneration[i + 1].state ? "1" : "0";
				
				var comparison:uint = parseInt(comparisonStr, 2);
				var newCell:Cell = new Cell();
				for each(var rule:RulesE in $rules)
				{
					if (rule.value == comparison)
					{
						newCell.state = 1;
						newCell.primaryColor = rule.primaryColor;
						newCell.secondaryColor = rule.secondaryColor;
						break;
					}
				}
				
				nextGeneration.push(newCell);
			}
			
			$generations.push(nextGeneration);
			createGenerations($generations, $rules, $depth - 1);
			return $generations;
		}
		
	}
	
}