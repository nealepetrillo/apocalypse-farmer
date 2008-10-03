package {
	import flash.display.*;
	import flash.events.*;
	
	public class GamePiece extends MovieClip {
		private var type:String;
		private var strength:uint;
		private var myHex:Hex;
		private var movesPerTurn:uint;
		private var movesLeft:uint;
		
		public static var ARMY_UNIT:String = "This GamePices is an army unit.";
		public static var DEFAULT_MOVEMENT_VALUE:uint = 1;
		
		public function GamePiece(whereIAm:Hex, howStrongIAm:uint, whatIAm:String):void {
			myHex = whereIAm;
			strength = howStrongIAm;
			type = whatIAm;
			movesPerTurn = DEFAULT_MOVEMENT_VALUE;
			x = (ApocFarmer.HEX_WIDTH-this.width+5)/2;
			y = (ApocFarmer.HEX_HEIGHT-this.height+5)/2;
			myHex.addChild(this);
			this.stop();
			this.addEventListener(MouseEvent.CLICK,gamePieceClicked);
		}//end GamePiece(Hex,uint,String)
		
		public function alterStrength(alterByThisMuch:int):void {
			strength += alterByThisMuch;
		}//end alterStrength
		public function gamePieceClicked(event:MouseEvent) {
			return;
		}//end gamePieceClicked
		public function moveTo(newHex:Hex):Boolean{
			if ( (movesLeft > 0) && myHex.isNeighboring(newHex) ) {
				myHex = newHex;
				newHex.addChild(this);
				movesLeft--;
				return true;
			}//end if
			return false;
		}//end moveTo
	}//end class
}//end package