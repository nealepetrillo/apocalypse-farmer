package {
	import flash.events.*;
	
	public class AIPlayer extends Player{
		
		public var activeArmy:uint;
		
		public function AIPlayer(playerNum:uint):void {
			super(playerNum);
			GPFRAME = 2;
		}
		
		public function movePiece(p:GamePiece, h:Hex):void {
			p.moveToHex(h);
		}
		
		public function startTurn():void {
			phaseOne();
			phaseTwo();
			for (var i:uint = 0; i < communities.length; i++) {
				if(--communities[i].locked < 0)
					communities[i].locked = 0;
			}//end for
		}
		
		private function phaseOne():void {
			if (armies.length > 0) {
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
					trace ("Problem moving piece for " + getPlayerNum() + 
													": all neighbors are NULL")
				}//end if
			}//end if
		}//end function
		
		private function phaseTwo():void {
			activeArmy = armies.length-1;
			//Found Community
			if (armies.length > 0) {
				if(armies[activeArmy].myHex.myCommunity == null){
					armies[activeArmy].createCommunity();
				}//end if
			}//end if
			
			//Main Loop
			for(var i:int = 0; i<communities.length; ++i) {
				
				if(communities[i].locked == 0) {
					if((communities[i].myHex.myPieces.length != 0) && communities[i].canReinforce()){
						communities[i].reinforce(communities[i].myHex.myPieces[0], 10);
						trace(this + "is reinforcing.");
					}
					else if(communities[i].canCreateArmy(10)) {
						communities[i].createArmy(10);
						trace(this + "is building army");
					}
					else{
						communities[i].produce();
						trace(this + "is producing");
					}//end if
				}//end if
			}//end for		
		}//end function
		

		
	}//end class
}//end package