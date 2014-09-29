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
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var rules:Array = RulesE.getRules(18);
			var colors:Array = [0xF04B55, 0xF48D9B, 0xADD8D6, 0x03A08E, 0xEFECD1];
			colors.sort();
			for each(var rule:RulesE in rules)
			{
				var color:uint = colors.shift();
				rule.primaryColor = color;
				colors.push(color);
				
				color = colors.shift();
				colors.push(color);
				rule.secondaryColor = color;
			}
			var firstGen:Array = [new Cell(1, colors[0], colors[1])];
			var gen:Array = createGenerations([firstGen], rules, 8);
			printGenerations(gen);
			drawGenerations(gen, 50);
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
			if (!$depth)
			{
				return $generations;
			}
			if (!$generations.length)
			{
				$generations.push([new Cell(1)]);
			}
			for each(var gen:Array in $generations)
			{
				gen.unshift(new Cell());
				gen.push(new Cell());
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