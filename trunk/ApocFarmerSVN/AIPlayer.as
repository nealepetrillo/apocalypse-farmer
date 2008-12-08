package {
	import flash.events.*;
	
	public class AIPlayer extends Player{
		
		public var activeArmy:uint;
		
		public function AIPlayer(playerNum:uint):void {
			super(playerNum);
		}
		
		public function movePiece(p:GamePiece, h:Hex):void {
			p.moveToHex(h);
		}
		
		public function startTurn():void {
			phaseOne();
			pahseTwo();
		}
		
		private function phaseOne():void {
			activeArmy = armies.length - 1;
			
			var currentHex:Hex = armies[activeArmy].getLocation();
			
			//Move primary Army counterclockwise 
			if(currentHex.NW != null) {
				armies[activeArmy].moveToHex(currentHex.NW);
			}
			else if(currentHex.SW != null) {
				armies[activeArmy].moveToHex(currentHex.SW);
			}
			else if(currentHex.S != null) {
				armies[activeArmy].moveToHex(currentHex.S);
			}
			else if(currentHex.SE != null) {
				armies[activeArmy].moveToHex(currentHex.SE);
			}
			else if(currentHex.NE != null) {
				armies[activeArmy].moveToHex(currentHex.NE);
			}
			else {
				trace ("Problem moving piece for " + myPlayer.getPlayerNum() + 
												": all neighbors are NULL")
			}//end if
		}//end function
		
		private function phaseTwo():void {
			
			//Found Community
			if(armies[activeArmy].myHex.myCommunity != null)
			{
				if (
				armies[activeArmy].
			
		}//end function
		

		
	}//end class
}//end package