package {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*
	
	public class GamePiece extends MovieClip {
		private var type:String;
		public var resources:uint;
		public var population:uint;
		private var myHex:Hex;
		private var movesPerTurn:uint;
		private var movesLeft:uint;
		public var myDisplayInfo:PieceInfo;
		public var myPlayer:Player;
		
		public static var ARMY_UNIT:String = "This GamePices is an army unit.";
		public static var DEFAULT_MOVEMENT_VALUE:uint = 1;
		
		public function GamePiece(whereIAm:Hex, pop:uint, res:uint, whatIAm:String, aPlayer:Player):void {
			myDisplayInfo = new PieceInfo(this);
			myHex = whereIAm;
			myPlayer = aPlayer;
			myPlayer.addPiece(this);
			resources = res;
			population = pop;
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
		public function alterPop(pop:uint) {
			population += pop;
		}//end alterStrength
		
		public function alterResources(res:uint) {
			resources += res; 
		}//end alterResources
		
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
			t.text = String(population);
			t.type = TextFieldType.DYNAMIC;
			t.selectable = false;
			t.setTextFormat(tf);
			myDisplayInfo.addChild(t);
			return myDisplayInfo;
		}//end displayInfo
		
		public function getLocation():Hex {
			return myHex;
		}
		
		
	}//end class
}//end package