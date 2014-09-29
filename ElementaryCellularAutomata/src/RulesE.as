package
{
	import flash.utils.Dictionary;
	
	/**
	 * Type-safe enumeration class.
	 * @author Marcela Errazquin
	 * @architects Christophe Herreman, Jorge Capote, Ryan Rauschkolb
	 * @usage Enumeration values are declared in your Enum class as follows:
	 * 		public static const MY_FIRST_ENUM : RulesE = new RulesE ( "MY_FIRST_ENUM" );
	 */
	public class RulesE
	{
		public static var map:Dictionary = new Dictionary();
		
		public static const AAA:RulesE = new RulesE("AliveAliveAlive", 7, 128);
		public static const AAD:RulesE = new RulesE("AliveAliveDead", 6, 64);
		public static const ADA:RulesE = new RulesE("AliveDeadAlive", 5, 32);
		public static const ADD:RulesE = new RulesE("AliveDeadDead", 4, 16);
		public static const DAA:RulesE = new RulesE("DeadAliveAlive", 3, 8);
		public static const DAD:RulesE = new RulesE("DeadAliveDead", 2, 4);
		public static const DDA:RulesE = new RulesE("DeadDeadAlive", 1, 2);
		public static const DDD:RulesE = new RulesE("DeadDeadDead", 0, 1);
		
		//----------- INTERNAL USAGE ONLY --------------------
		public function RulesE($name:String, $value:uint, $mask:uint, $primaryColor:uint = 0, $secondaryColor:uint = 0)
		{
			if (_enumCreated)
			{
				throw new Error("RulesE is an Enumeration Class and cannot be instantiated after run-time.");
			}
			_name = $name;
			_value = $value;
			_mask = $mask;
			_primaryColor = $primaryColor;
			_secondaryColor = $secondaryColor;
			map[_name] = this;
		}
		
		public function toString():String
		{
			return _name;
		}
		private var _name:String;
		private var _value:uint;
		private var _mask:uint;
		private var _primaryColor:uint;
		private var _secondaryColor:uint;
		private static var _enumCreated:Boolean = false;
		
		public function get mask():uint { return _mask; }
		
		public function get value():uint { return _value; }
		
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
		
		
		{ _enumCreated = true; }
		
		public static function getRules($ruleNum:uint):Array
		{
			var rules:Array = [];
			
			for each(var rule:RulesE in map)
			{
				if (rule.mask & $ruleNum)
				{
					rules.push(rule);
				}
			}
			
			return rules;
		}
		
		
	}

}