package {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*
	
	public class GamePiece extends MovieClip {
		private var type:String;
		public var resources:uint;
		public var population:uint;
		public var myHex:Hex;
		private var movesPerTurn:uint;
		private var movesLeft:uint;
		public var myDisplayInfo:PieceInfo;
		public var myPlayer:Player;
		
		public static var ARMY_UNIT:String = "This GamePices is an army unit.";
		public static var DEFAULT_MOVEMENT_VALUE:uint = 1;
		
		public function GamePiece(whereIAm:Hex, pop:uint, res:uint, whatIAm:String, aPlayer:Player):void {
			myHex = whereIAm;
			myHex.myPlayer = aPlayer;
			myPlayer = aPlayer;
			myPlayer.addPiece(this);
			resources = res;
			population = pop;
			//trace("rus: " + resources + "\tpop: " + population);
			type = whatIAm;
			movesPerTurn = DEFAULT_MOVEMENT_VALUE;
			x = (ApocFarmer.HEX_WIDTH-this.width+5)/2;
			y = (ApocFarmer.HEX_HEIGHT-this.height+5)/2;
			myHex.addPiece(this);
			gotoAndStop(myPlayer.GPFRAME);
			myDisplayInfo = new PieceInfo(this);
			//addEventListener(MouseEvent.CLICK,gamePieceClicked);
		}//end GamePiece(Hex,uint,String)
		
		public override function toString():String {
			return "GamePiece on " + myHex.getRow() + "," + myHex.getColumn();
		}
								
		public function beenSelected() {
			myHex.myGame.selectedPiece = this;
			myDisplayInfo.gotoAndStop(2);
			if(myPlayer.GPFRAME == 2)
				myDisplayInfo.gotoAndStop(4);
		}
		public function unSelect() {
			myDisplayInfo.gotoAndStop(1);
			if(myPlayer.GPFRAME == 2)
				myDisplayInfo.gotoAndStop(3);
		}
		public function alterPop(pop:int) {
			population += pop;
			myDisplayInfo = new PieceInfo(this);
		}//end alterStrength
		
		public function alterResources(res:int) {
			resources += res; 
		}//end alterResources
		
		public function gamePieceClicked(event:MouseEvent) {
			return;
		}//end gamePieceClicked
		
		public function moveToHex(newHex:Hex):Boolean{
			if (newHex == null) {
				myHex.myPieces.splice(myHex.myPieces.indexOf(this),1);
				if (myHex.contains(this))
					myHex.removeChild(this);
				if(myHex.myPieces.length == 0 && myHex.myCommunity == null)
					myHex.myPlayer = null;
				return true;
			} else if ( myHex.myGame.currentPhase == AFTurn.MOVEMENT_PHASE && myHex.isNeighboring(newHex) ) {
				if (newHex.myPlayer != null && myPlayer != newHex.myPlayer) {
					trace("Combat should begin...");
					myHex.myGame.theTurn.startCombat(new CombatEvent(CombatEvent.COMBAT_START, this, newHex.myPieces, newHex));
				}else {
					myHex.myPieces.splice(myHex.myPieces.indexOf(this),1);
					if(myHex.myPieces.length == 0 && myHex.myCommunity == null)
						myHex.myPlayer = null;
					myHex = newHex;
					newHex.addPiece(this);
					//movesLeft--;
					return true;
				}//end if else
			}//end if else if
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
		
		public function createCommunity():void {
			myHex.foundCommunity(this);
		}
		
		
	}//end class
}//end package