package
{
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.ColorPicker;
	import fl.controls.List;
	import fl.controls.NumericStepper;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * @author Marcela Errazquin
	 */
	public class ControlBar extends Sprite
	{
		private static const DEFAULT_COLORS:Array = [0xF04B55, 0xF48D9B, 0xADD8D6, 0x03A08E, 0xEFECD1];
		
		private var _ruleStepper:NumericStepper;
		private var _sizeStepper:NumericStepper;
		private var _colorPicker:ColorPicker;
		private var _colorTF:TextField;
		private var _addButton:Button;
		private var _deleteButton:Button;
		private var _moveUpButton:Button;
		private var _moveDownButton:Button;
		private var _colorList:List;
		private var _refreshButton:Button;
		private var _saveButton:Button;
		private var _useCirclesCB:CheckBox;
		private var _fillCirclesCB:CheckBox;
		
		public function ControlBar()
		{
			super();
			_ruleStepper = new NumericStepper();
			_sizeStepper = new NumericStepper();
			_colorPicker = new ColorPicker();
			_colorTF = new TextField();
			_addButton = new Button();
			_deleteButton = new Button();
			_refreshButton = new Button();
			_saveButton = new Button();
			_colorList = new List();
			_moveUpButton = new Button();
			_moveDownButton = new Button();			
			_useCirclesCB = new CheckBox();
			_fillCirclesCB = new CheckBox();
			
			configureControls();
			
			addChild(_ruleStepper);
			addChild(_sizeStepper);
			addChild(_colorTF);
			addChild(_colorPicker);
			addChild(_addButton);	
			addChild(_deleteButton);
			addChild(_refreshButton);
			addChild(_saveButton);
			addChild(_colorList);
			addChild(_moveUpButton);
			addChild(_moveDownButton);
			addChild(_useCirclesCB);
			addChild(_fillCirclesCB);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		public function get rule():uint { return _ruleStepper.value; }
		public function get pixelSize():uint { return _sizeStepper.value; }
		
		public function get colors():Array 
		{ 
			var arr:Array = [];
			for (var i:int = 0; i < _colorList.length; i++) 
			{
				arr.push(_colorList.getItemAt(i).data);
			}
			return arr.length ? arr : [0];
		}
		
		public function get useCircles():Boolean { return _useCirclesCB.selected; }
		public function get fillCircles():Boolean { return _fillCirclesCB.selected; }
		
		private function onDeleteColor($event:MouseEvent):void 
		{
			if (_colorList.selectedItems.length)
			{
				for each(var item:Object in _colorList.selectedItems)
				{
					_colorList.removeItem(item);
				}
				
				for (var i:int = 0; i < _colorList.length; i++) 
				{
					_colorList.getItemAt(i).order = i;
				}
				if (_colorList.length)
				{
					_colorList.sortItemsOn("order");
				}
				
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private function onAddColor($event:MouseEvent):void 
		{
			_colorList.addItem( { label:_colorTF.text.toLowerCase(), data:parseInt(_colorTF.text, 16), icon:ListIcon, order: _colorList.length } );
			
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
			
			if ($event.target == _colorPicker)
			{
				_colorTF.text = _colorPicker.hexValue;
			}
			if ($event.target == _colorTF)
			{
				_colorPicker.selectedColor = parseInt(_colorTF.text, 16);
			}
			
			if ($event.target == _useCirclesCB)
			{
				_fillCirclesCB.enabled = _useCirclesCB.selected;
			}
			
			if ($event.target != _colorPicker && $event.target != _colorList && $event.target != _colorTF) 
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
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
			_addButton.width = 40;
			
			_deleteButton.label = "-";
			_deleteButton.width = 40;
			
			_refreshButton.label = "R";
			_refreshButton.width = 40;
			
			_saveButton.label = "Save";
			_saveButton.width = 40;
			
			_colorTF.border = true;
			_colorTF.type = "input";
			_colorTF.restrict = "[0-9A-Fa-f]";
			_colorTF.maxChars = 6;
			_colorTF.multiline = _colorTF.wordWrap = false;
			_colorTF.text = _colorPicker.hexValue;
			_colorTF.width = 50;
			_colorTF.height = _colorTF.textHeight + 5;
			
			_colorList.iconField = "icon";
			_colorList.allowMultipleSelection = true;
			
			for each(var color:uint in DEFAULT_COLORS)
			{
				_colorList.addItem( { label:color.toString(16), data:color, icon:ListIcon, order: _colorList.length } );
			}
			
			_moveUpButton.label = "^";
			_moveUpButton.width = 40;
			
			_moveDownButton.label = "v";
			_moveDownButton.width = 40;
			
			_useCirclesCB.label = "Circle Segments";
			_useCirclesCB.width = 200;
			
			_fillCirclesCB.label = "Fill Circles";
			_fillCirclesCB.width = 200;
			_fillCirclesCB.enabled = false;
			
			_ruleStepper.x = _ruleStepper.y = _sizeStepper.y = _colorTF.y = _addButton.y = _moveUpButton.y = _colorList.y = _useCirclesCB.x = _fillCirclesCB.x = 5;
			_sizeStepper.x = _ruleStepper.x + _ruleStepper.width + 10;
			_colorTF.x = _colorPicker.x = _sizeStepper.x + _sizeStepper.width + 10;
			_colorPicker.y = _colorTF.y + _colorTF.height + 10;
			_addButton.x  = _deleteButton.x = _refreshButton.x = _saveButton.x = _colorTF.x + _colorTF.width + 10;
			_deleteButton.y = _addButton.y + _addButton.height + 10;
			_refreshButton.y = _deleteButton.y + _deleteButton.height + 10;
			_saveButton.y = _refreshButton.y + _refreshButton.height + 10;
			_colorList.x = _addButton.x + _addButton.width + 10;
			_moveUpButton.x = _moveDownButton.x = _colorList.x + _colorList.width + 10;
			_moveDownButton.y = _moveUpButton.y + _moveUpButton.height + 10;
			_useCirclesCB.y = _ruleStepper.y + _ruleStepper.height + 10;
			_fillCirclesCB.y = _useCirclesCB.y + _useCirclesCB.height + 10;
			
			_sizeStepper.addEventListener(Event.CHANGE, onRuleChanged);
			_ruleStepper.addEventListener(Event.CHANGE, onRuleChanged);
			_colorTF.addEventListener(Event.CHANGE, onRuleChanged);
			_colorPicker.addEventListener(Event.CHANGE, onRuleChanged);
			_colorList.addEventListener(Event.CHANGE, onRuleChanged);
			_addButton.addEventListener(MouseEvent.CLICK, onAddColor);
			_deleteButton.addEventListener(MouseEvent.CLICK, onDeleteColor);
			_refreshButton.addEventListener(MouseEvent.CLICK, onRuleChanged);
			_saveButton.addEventListener(MouseEvent.CLICK, onSaveButtonClicked);
			_moveUpButton.addEventListener(MouseEvent.CLICK, onColorReorder);
			_moveDownButton.addEventListener(MouseEvent.CLICK, onColorReorder);
			_useCirclesCB.addEventListener(Event.CHANGE, onRuleChanged);
			_fillCirclesCB.addEventListener(Event.CHANGE, onRuleChanged);
		}
		
		private function onColorReorder($event:MouseEvent):void 
		{
			var selectedIndex:int = _colorList.selectedIndex;
			if (selectedIndex == -1)
			{
				return;
			}
			var update:Boolean = false;
			if ($event.target == _moveUpButton && selectedIndex > 0)
			{
				_colorList.selectedItem.order -= 1;
				_colorList.getItemAt(selectedIndex - 1).order += 1;
				update = true;
			}
			if ($event.target == _moveDownButton && selectedIndex < _colorList.length - 1)
			{
				_colorList.selectedItem.order++;
				_colorList.getItemAt(selectedIndex + 1).order--;
				update = true;
			}
			
			if (update)
			{
				_colorList.sortItemsOn("order");
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private function onSaveButtonClicked($event:MouseEvent):void 
		{
			dispatchEvent(new Event("save"));
		}
	}

}