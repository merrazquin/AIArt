package 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import mx.graphics.codec.JPEGEncoder;
	import flash.net.FileReference;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Marcela Errazquin
	 */
	public class Main extends Sprite 
	{
		private var _controlBar:ControlBar;
		private var _canvas:Canvas;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			createUI();
			createCanvas();
		}
		
		private function createUI():void 
		{
			_controlBar = new ControlBar();
			_controlBar.addEventListener(Event.CHANGE, onRuleChanged);
			_controlBar.addEventListener("save", onSaveRequest);
			_controlBar.y = stage.stageHeight - _controlBar.height;
			addChild(_controlBar);

		}
		
		private function createCanvas():void 
		{
			_canvas = new Canvas(stage.stageWidth, stage.stageHeight - _controlBar.height);
			addChildAt(_canvas, 0);
			onRuleChanged(null);
		}
		
		private function onRuleChanged(e:Event):void 
		{
			_canvas.redraw(_controlBar.rule, _controlBar.pixelSize, _controlBar.colors);
		}
		
		private function onSaveRequest(e:Event):void 
		{
			
			var bounds:Rectangle = _canvas.getBounds(_canvas);
			var m:Matrix = new Matrix();
			m.translate(-bounds.left, -bounds.top);

			var bmpData:BitmapData = new BitmapData(bounds.width, bounds.height);
			bmpData.draw(_canvas, m);
			
			var encoder:JPEGEncoder = new JPEGEncoder();
			var byteArray:ByteArray = encoder.encode(bmpData);
			
			var fileRef:FileReference = new FileReference();
			fileRef.save(byteArray, "Rule_" + _controlBar.rule + ".png");
		}
	}
	
}