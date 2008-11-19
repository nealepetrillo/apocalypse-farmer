package {
	import flash.events.*;
	public class CombatEvent {
		public static const COMBAT_START:String = "A combat phase is starting.";
		public static const COMBAT_END:String = "A combat phase is ending.";
		
		public function CombatEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false){
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