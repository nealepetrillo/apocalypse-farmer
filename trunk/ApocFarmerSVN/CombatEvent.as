package {
	import flash.events.*;
	public class CombatEvent {
		public static const COMBAT_START:String = "A combat phase is starting.";
		public static const COMBAT_END:String = "A combat phase is ending.";
		public attacker:GamePiece;
		public defenders:Array;
		public battleSite:Hex;
		
		public function CombatEvent(type:String, att:GamePiece, defs:Array, loc:Hex, bubbles:Boolean = false, cancelable:Boolean = false){
			attacker = att;
			defenders = defs;
			battleSite = loc;			
			super(type,bubbles,cancelable);
		}
		
		public override function clone():Event {
			return new CombatEvent(type, bubbles, cancelable);
		}
		
		public override function toString():String {
			return formatToString("CombatEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
		
	}//end class
}//end package