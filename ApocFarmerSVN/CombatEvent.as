package {
	import flash.events.*;
	public class CombatEvent extends Event{
		public static const COMBAT_START:String = "A combat phase is starting.";
		public static const COMBAT_END:String = "A combat phase is ending.";
		public var attacker:GamePiece;
		public var defenders:Array;
		public var battleSite:Hex;
		
		public function CombatEvent(type:String, att:GamePiece, defs:Array, loc:Hex, bubbles:Boolean = false, cancelable:Boolean = false){
			attacker = att;
			defenders = defs;
			battleSite = loc;			
			super(type,bubbles,cancelable);
		}
		
		public override function clone():Event {
			return new CombatEvent(type, attacker, defenders, battleSite, bubbles, cancelable);
		}
		
		public override function toString():String {
			return formatToString("CombatEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
		
	}//end class
}//end package