package {
	
	import flash.events.*;
	
	public class PhaseEvent extends Event{
		public static const NEW_PHASE:String = "The turn is entering into a new phase.";
		
		public function PhaseEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false){
			super(type,bubbles,cancelable);
		}
		
		public override function clone():Event {
			return new PhaseEvent(type, bubbles, cancelable);
		}
		
		public override function toString():String {
			return formatToString("PhaseEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
		
	}//end class
}//end package