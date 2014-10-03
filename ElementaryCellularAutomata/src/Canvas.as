package  
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	

	
	/**
	 * @author Marcela Errazquin
	 */
	public class Canvas extends Sprite 
	{
		private var _width:Number;
		private var _height:Number;
		
		private var _rule:uint;
		private var _ruleSet:Array;
		private var _pixelSize:Number;
		private var _generations:Array;
		
		public function Canvas($width:Number, $height:Number) 
		{
			super();
			_width = $width;
			_height = $height;
		}
		
		public function redraw($rule:uint, $pixelSize:Number, $colors:Array, $useCircles:Boolean, $fillCircles:Boolean):void 
		{
			//TODO: only recreate rules if rule has changed - Marcela Errazquin 9/30/2014 3:11 PM
			var rules:Array = RulesE.getRules($rule);
			for each(var rule:RulesE in rules)
			{
				var color:uint = $colors.shift();
				rule.primaryColor = color;
				$colors.push(color);
				
				color = $colors.shift();
				$colors.push(color);
				rule.secondaryColor = color;
			}
			
			var numCols:int = Math.floor(_width / $pixelSize);
			var numRows:int = Math.floor(_height / $pixelSize) - 1;
			var firstGen:Array = [];
			for(var i:int = 0; i < numCols; i++)
			{
				firstGen.push(new Cell());
			}
			var centerCell:Cell = firstGen[Math.ceil(numCols/2)];
			centerCell.state = 1;
			$colors.push(centerCell.primaryColor = $colors.shift());
			$colors.push(centerCell.secondaryColor = $colors.shift());
			
			//TODO: only recreate generations if rule has changed - Marcela Errazquin 9/30/2014 3:11 PM
			var gen:Array = createGenerations([firstGen], rules, numRows);
			drawGenerations(gen, $pixelSize, $useCircles, $fillCircles);			
		}
		
		private function drawGenerations($gen:Array, pixelSize:Number, $useCircles:Boolean = false, $fillCircles:Boolean = false):void 
		{
			graphics.clear();
			var currX:Number = 0;
			var currY:Number = 0;
			for each(var generation:Array in $gen)
			{
				for each(var cell:Cell in generation)
				{
					if (cell.state)
					{
						var random1:Number = Math.random();
						if (random1 > .5)
						{
							if ($useCircles)
							{
								if ($fillCircles)
								{
									drawFilledSemiCircle("tl", graphics, cell.primaryColor, currX, currY, pixelSize);
									drawFilledSemiCircle("br", graphics, cell.secondaryColor, currX, currY, pixelSize);								
								}
								else
								{
									drawTLSemiCircle(graphics, cell.primaryColor, currX, currY, pixelSize);
									drawBRSemiCircle(graphics, cell.secondaryColor, currX, currY, pixelSize);								
								}
							}
							else
							{
								drawTLTriangle(graphics, cell.primaryColor, currX, currY, pixelSize);
								drawBRTriangle(graphics, cell.secondaryColor, currX, currY, pixelSize);								
							}
						}
						else
						{
							if ($useCircles)
							{
								if ($fillCircles)
								{
									drawFilledSemiCircle("tr", graphics, cell.primaryColor, currX, currY, pixelSize);
									drawFilledSemiCircle("bl", graphics, cell.secondaryColor, currX, currY, pixelSize);								
								}
								else
								{
									drawTRSemiCircle(graphics, cell.primaryColor, currX, currY, pixelSize);
									drawBLSemiCircle(graphics, cell.secondaryColor, currX, currY, pixelSize);								
								}
							}
							else
							{
								
								drawTRTriangle(graphics, cell.primaryColor, currX, currY, pixelSize);
								drawBLTriangle(graphics, cell.secondaryColor, currX, currY, pixelSize);								
							}
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
		
		private function drawTLSemiCircle($graphics:Graphics, $color:uint, $x:Number, $y:Number, $pizelSize:Number, $drawStems:Boolean = false):void 
		{
			$graphics.lineStyle(1, $color);
			drawSegment($graphics, $x, $y, $pizelSize * .5, 0, 90, $drawStems);
		}
		
		private function drawTRSemiCircle($graphics:Graphics, $color:uint, $x:Number, $y:Number, $pizelSize:Number, $drawStems:Boolean = false):void 
		{
			$graphics.lineStyle(1, $color);
			drawSegment($graphics, $x + $pizelSize, $y, $pizelSize * .5, 90, 180, $drawStems);
		}
		
		private function drawBLSemiCircle($graphics:Graphics, $color:uint, $x:Number, $y:Number, $pizelSize:Number, $drawStems:Boolean = false):void 
		{
			$graphics.lineStyle(1, $color);
			drawSegment($graphics, $x, $y + $pizelSize, $pizelSize * .5, 270, 360, $drawStems);
		}
		
		private function drawBRSemiCircle($graphics:Graphics, $color:uint, $x:Number, $y:Number, $pizelSize:Number, $drawStems:Boolean = false):void 
		{
			$graphics.lineStyle(1, $color);
			drawSegment($graphics, $x + $pizelSize, $y, $pizelSize * .5, 180, 270, $drawStems);
		}
		
		private function drawFilledSemiCircle($direction:String, $graphics:Graphics, $color:uint, $x:Number, $y:Number, $pizelSize:Number):void 
		{
			$graphics.beginFill($color);
			
			var drawingFuction:Function;
			switch($direction.toUpperCase())
			{
				case "TL":
					drawingFuction = drawTLSemiCircle;
					break;
				case "TR":
					drawingFuction = drawTRSemiCircle;
					break;
				case "BL":
					drawingFuction = drawBLSemiCircle;
					break;
				case "BR":
					drawingFuction = drawBRSemiCircle;
					break;
			}
			drawingFuction.call($direction, $graphics, $color, $x, $y, $pizelSize, true);
			$graphics.endFill();
		}

		private function drawSegment(graphics:Graphics, x:Number, y:Number, r:Number, aStart:Number, aEnd:Number, drawStems:Boolean = false, step:Number = 1):void 
		{
			// More efficient to work in radians
			var degreesPerRadian:Number = Math.PI / 180;
			aStart *= degreesPerRadian;
			aEnd *= degreesPerRadian;
			step *= degreesPerRadian;

			// Draw the segment
			if (drawStems)
			{
				graphics.moveTo(x, y);
			}
			else
			{
				graphics.moveTo(x + r * Math.cos(aStart), y + r * Math.sin(aStart));
			}
			
			for (var theta:Number = aStart; theta < aEnd; theta += Math.min(step, aEnd - theta)) 
			{
				graphics.lineTo(x + r * Math.cos(theta), y + r * Math.sin(theta));
			}
			
			graphics.lineTo(x + r * Math.cos(aEnd), y + r * Math.sin(aEnd));
			if (drawStems)
			{
				graphics.lineTo(x, y);
			}
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