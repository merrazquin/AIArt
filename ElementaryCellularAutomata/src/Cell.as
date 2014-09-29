package
{
	
	public class Cell
	{
		private var _state:uint;
		private var _primaryColor:uint;
		private var _secondaryColor:uint;
		
		public function Cell($state:uint = 0, $primaryColor:uint = 0, $secondaryColor:uint = 0)
		{
			super();
			_state = $state;
			_primaryColor = $primaryColor;
			_secondaryColor = $secondaryColor;
		}
		
		public function get state():uint { return _state; }
		
		public function set state(value:uint):void 
		{
			_state = value;
		}
		
		public function get primaryColor():uint { return _primaryColor; }
		
		public function set primaryColor(value:uint):void 
		{
			_primaryColor = value;
		}
		
		public function get secondaryColor():uint { return _secondaryColor; }
		
		public function set secondaryColor(value:uint):void 
		{
			_secondaryColor = value;
		}
		
		public function toString():String
		{
			return _state.toString();
		}
	}

}