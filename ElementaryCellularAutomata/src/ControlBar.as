package
{
	import fl.controls.Button;
	import fl.controls.ColorPicker;
	import fl.controls.List;
	import fl.controls.NumericStepper;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * @author Marcela Errazquin
	 */
	public class ControlBar extends Sprite
	{
		private static const DEFAULT_COLORS:Array = [0xF04B55, 0xF48D9B, 0xADD8D6, 0x03A08E, 0xEFECD1];
		private var _ruleStepper:NumericStepper;
		private var _sizeStepper:NumericStepper;
		private var _colorPicker:ColorPicker;
		private var _addButton:Button;
		private var _deleteButton:Button;
		private var _colorList:List;
		
		public function ControlBar()
		{
			super();
			_ruleStepper = new NumericStepper();
			_sizeStepper = new NumericStepper();
			_colorPicker = new ColorPicker();
			_addButton = new Button();
			_deleteButton = new Button();
			_colorList = new List();
			
			configureControls();
			
			addChild(_ruleStepper);
			addChild(_sizeStepper);
			addChild(_colorPicker);
			addChild(_addButton);	
			addChild(_colorList);
			addChild(_deleteButton);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		public function get rule():uint { return _ruleStepper.value; }
		public function get pixelSize():uint { return _sizeStepper.value; }
		public function get colors():Array 
		{ 
			var arr:Array = [];
			for (var i:int = 0; i < _colorList.dataProvider.length; i++) 
			{
				arr.push(_colorList.getItemAt(i).data);
			}
			return arr.length ? arr : [0];
		}
		
		private function onDeleteColor($event:MouseEvent):void 
		{
			if (_colorList.selectedItems.length)
			{
				for each(var item:Object in _colorList.selectedItems)
				{
					_colorList.removeItem(item);
				}
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private function onAddColor($event:MouseEvent):void 
		{
			_colorList.addItem( { label:_colorPicker.hexValue, data:_colorPicker.selectedColor, icon:ListIcon } );
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function addedToStage($event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, stage.stageWidth, height);
			graphics.endFill();
		}
		
		private function onRuleChanged($event:Event):void 
		{
			$event.stopImmediatePropagation();
			
			if ($event.target != _colorPicker && $event.target != _colorList) dispatchEvent($event.clone());
		}
		
		private function configureControls():void 
		{
			_ruleStepper.minimum = 0;
			_ruleStepper.maximum = 255;
			_ruleStepper.value = 102
			
			_sizeStepper.minimum = 5;
			_sizeStepper.maximum = 100;
			_sizeStepper.value = 30;
			_sizeStepper.stepSize = 5;
			
			_addButton.label = "+";
			_addButton.setSize(40, _addButton.height);
			
			_deleteButton.label = "-";
			_deleteButton.setSize(40, _deleteButton.height);
			
			_colorList.iconField = "icon";
			_colorList.allowMultipleSelection = true;
			for each(var color:uint in DEFAULT_COLORS)
			{
				_colorList.addItem( { label:color.toString(16), data:color, icon:ListIcon } );
			}
			
			_ruleStepper.x = _ruleStepper.y = _sizeStepper.y = _colorPicker.y = _addButton.y = _colorList.y = 5;
			_sizeStepper.x = _ruleStepper.x + _ruleStepper.width + 10;
			_colorPicker.x = _sizeStepper.x + _sizeStepper.width + 10;
			_addButton.x  = _colorPicker.x + _colorPicker.width + 20;
			_deleteButton.x = _addButton.x;
			_deleteButton.y = _addButton.y + _addButton.height + 20;
			_colorList.x = _addButton.x + _addButton.width + 20;
			
			_sizeStepper.addEventListener(Event.CHANGE, onRuleChanged);
			_ruleStepper.addEventListener(Event.CHANGE, onRuleChanged);
			_colorPicker.addEventListener(Event.CHANGE, onRuleChanged);
			_colorList.addEventListener(Event.CHANGE, onRuleChanged);
			_addButton.addEventListener(MouseEvent.CLICK, onAddColor);
			_deleteButton.addEventListener(MouseEvent.CLICK, onDeleteColor);
		}
	}

}