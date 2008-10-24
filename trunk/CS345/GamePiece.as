package {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*
	
	public class GamePiece extends MovieClip {
		private var type:String;
		private var strength:uint;
		private var myHex:Hex;
		private var movesPerTurn:uint;
		private var movesLeft:uint;
		public var myDisplayInfo:PieceInfo;
		
		public static var ARMY_UNIT:String = "This GamePices is an army unit.";
		public static var DEFAULT_MOVEMENT_VALUE:uint = 1;
		
		public function GamePiece(whereIAm:Hex, howStrongIAm:uint, whatIAm:String):void {
			myDisplayInfo = new PieceInfo(this);
			myHex = whereIAm;
			strength = howStrongIAm;
			type = whatIAm;
			movesPerTurn = DEFAULT_MOVEMENT_VALUE;
			x = (ApocFarmer.HEX_WIDTH-this.width+5)/2;
			y = (ApocFarmer.HEX_HEIGHT-this.height+5)/2;
			myHex.addPiece(this);
			stop();
			//addEventListener(MouseEvent.CLICK,gamePieceClicked);
		}//end GamePiece(Hex,uint,String)
		
		public function beenSelected() {
			myHex.myGame.selectedPiece = this;
			myDisplayInfo.gotoAndStop(2);
		}
		public function unSelect() {
			myDisplayInfo.gotoAndStop(1);
		}
		public function alterStrength(alterByThisMuch:int):void {
			strength += alterByThisMuch;
		}//end alterStrength
		public function gamePieceClicked(event:MouseEvent) {
			return;
		}//end gamePieceClicked
		public function moveToHex(newHex:Hex):Boolean{
			if ( /*(movesLeft > 0) &&*/ myHex.isNeighboring(newHex) ) {
				myHex.myPieces.splice(myHex.myPieces.indexOf(this,1));
				myHex = newHex;
				newHex.addPiece(this);
				//movesLeft--;
				return true;
			}//end if
			return false;
		}//end moveTo
		public function displayInfo(x0:uint, y0:uint):PieceInfo {
			myDisplayInfo.x = x0;
			myDisplayInfo.y = y0;
			var t:TextField = new TextField();
			var tf:TextFormat = new TextFormat();
			tf.size = 40;
			t.text = String(strength);
			t.type = TextFieldType.DYNAMIC;
			t.selectable = false;
			t.setTextFormat(tf);
			myDisplayInfo.addChild(t);
			return myDisplayInfo;
		}//end displayInfo
		
		
	}//end class
}//end package