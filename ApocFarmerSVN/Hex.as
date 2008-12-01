package {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	public class Hex extends MovieClip {
		private var row:uint;
		private var column:uint;
		public var borderingHexes:Array = new Array();
		private var playerOwned:Boolean = false;
		private var unoccupied:Boolean = true;
		private var myAI:AIPlayer = null;
		public var myPieces:Array = new Array();
		private var displayStrength:TextField = new TextField();
		private var myVillage:Village = null;
		private var myTerrainType:uint;
		private var myProdBonus:Number;
		private var myDefBonus:Number;
		private var myMoveValue:Number;
		public var myGame:ApocFarmer;
		private var myCommunity:Community = null;
		//direction of bordering hexes constants
		public 
		
		public function Hex(game:ApocFarmer):void {
			myGame = game;
			row = 0;
			column = 0;
			addEventListener(MouseEvent.CLICK,clickedHex);
			buttonMode = true;
			stop();
			myTerrainType = Math.floor(Math.random()*ApocFarmer.terrainTypes.length);
			myProdBonus = ApocFarmer.terrainTypes[myTerrainType][ApocFarmer.PROD_BONUS];
			myDefBonus = ApocFarmer.terrainTypes[myTerrainType][ApocFarmer.DEF_BONUS];
			myMoveValue = ApocFarmer.terrainTypes[myTerrainType][ApocFarmer.MOV_VALUE];
			gotoAndStop(myTerrainType + ApocFarmer.FRAME_OFFSET);
		}//end Hex
		public function setTerrain(t:uint) {
			if (0 <= t && t < ApocFarmer.terrainTypes.length)
			myTerrainType = t;
			myProdBonus = ApocFarmer.terrainTypes[myTerrainType][ApocFarmer.PROD_BONUS];
			myDefBonus = ApocFarmer.terrainTypes[myTerrainType][ApocFarmer.DEF_BONUS];
			myMoveValue = ApocFarmer.terrainTypes[myTerrainType][ApocFarmer.MOV_VALUE];
			gotoAndStop(myTerrainType + ApocFarmer.FRAME_OFFSET);
		}//end setTerrain
		public function foundCommunity(cType:uint, pop:uint, rus:uint) {
			myCommunity = new Community();
			myCommunity.gotoAndStop(cType);
			myCommunity.stats = {type:cType, population:pop, resources:rus, task:"IDLE"};
			playerOwned = true;
			addChild(myCommunity);
			myCommunity.addEventListener(MouseEvent.CLICK,clickedCommunity);
		}//end foundVillage
		public function foundAICommunity(cType:uint, pop:uint, rus:uint, ai:AIPlayer){
			myCommunity = new Community();
			myCommunity.gotoAndStop(cType);
			myCommunity.stats = {type:cType, population:pop, resources:rus, task:"IDLE"};
			playerOwned = false;
			myAI = ai;
			addChild(myCommunity);
		}
		public function addPiece(gp:GamePiece) {
			myPieces.push(gp);
			addChild(gp);
			if(causesBattle(gp)) {
				throw new CombatEvent();
		}
		public function selectPiece():GamePiece {
			return myPieces[0];
		}//end selectPiece
		public function clickedHex(event:MouseEvent) {
			myGame.boardClick(this);
		}//end clickedHex 
		public function clickedCommunity(event:MouseEvent) {
			
		}//end clickedCommunity
		public function setNeighbors(allHexes:Array):void {
			/*
			trace("Hex:" + this.column + ", " + this.row);
			for (var i:uint = 0; i < allHexes.length; i++)
				for (var j:uint = 0; j < allHexes[i].length; j++)
					trace(allHexes[i][j].column + ", " + allHexes[i][j].row);
			*/
			//detect a corner hex
			if (this.column == 0 && this.row == 0) { 						//NW corner
				borderingHexes.push(allHexes[column+1][row]);
				borderingHexes.push(allHexes[column+1][row+1]);
				borderingHexes.push(allHexes[column][row+1]);
			} 
			else if (this.column == 0 && this.row == allHexes[column].length-1) { //SW corner
				borderingHexes.push(allHexes[column][row-1]);
				borderingHexes.push(allHexes[column+1][row]);
			}
			else if (this.column == allHexes.length -1) {
				if (this.row == 0) { 										//NE corner
					borderingHexes.push(allHexes[column-1][row]);
					borderingHexes.push(allHexes[column][row+1]);
					if (!this.isUpperHex()) 				//checks for odd column
						borderingHexes.push(allHexes[column-1][row+1]);
				}
				else if (this.row == allHexes[column].length-1) { 		//SE corner
					borderingHexes.push(allHexes[column][row-1]);
					borderingHexes.push(allHexes[column-1][row]);
					if (this.isUpperHex()) 				//checks for odd column
						borderingHexes.push(allHexes[column-1][row-1]);
				}
				else { //right edge
					borderingHexes.push(allHexes[column][row-1]);
					borderingHexes.push(allHexes[column][row+1]);
					borderingHexes.push(allHexes[column-1][row]);
					if (this.isUpperHex())
						borderingHexes.push(allHexes[column-1][row-1]);
					else 
						borderingHexes.push(allHexes[column-1][row+1]);
				}//end else right edge
			}
			else if (this.row == 0) { //if upper edge
					if (this.isUpperHex()) {
						borderingHexes.push(allHexes[column-1][row]);
						borderingHexes.push(allHexes[column][row+1]);
						borderingHexes.push(allHexes[column+1][row]);
					} 
					else {
						borderingHexes.push(allHexes[column-1][row]);
						borderingHexes.push(allHexes[column-1][row+1]);
						borderingHexes.push(allHexes[column][row+1]);
						borderingHexes.push(allHexes[column+1][row+1]);
						borderingHexes.push(allHexes[column+1][row]);
					}
				}//end if-else upper edge
			else if (this.row == allHexes[column].length-1) { //if bottom edge
					borderingHexes.push(allHexes[column-1][row]);
					borderingHexes.push(allHexes[column][row-1]);
					borderingHexes.push(allHexes[column+1][row]);
					if (this.isUpperHex())
						borderingHexes.push(allHexes[column-1][row-1]);
					borderingHexes.push(allHexes[column+1][row-1]);
				}//end if bottome edge
			else if (this.column == 0) { //if left edge
					borderingHexes.push(allHexes[column][row-1]);
					borderingHexes.push(allHexes[column+1][row]);
					borderingHexes.push(allHexes[column+1][row+1]);
					borderingHexes.push(allHexes[column][row+1]);
				}//end if left edge
			else { //there are six possible neighbors for internal hexes
				borderingHexes.push(allHexes[column+1][row]);
				borderingHexes.push(allHexes[column-1][row]);
				borderingHexes.push(allHexes[column][row+1]);
				borderingHexes.push(allHexes[column][row-1]);
				if (isUpperHex()) {
					borderingHexes.push(allHexes[column-1][row-1]);
					borderingHexes.push(allHexes[column+1][row-1]);
				} 
				else {
					borderingHexes.push(allHexes[column-1][row+1]);
					borderingHexes.push(allHexes[column+1][row+1]);
				}//end if - else upper internal hex
			}//end else intenrnal hex
		}//end setNeighbors(Array)
		public function isNeighboring(anotherHex:Hex):Boolean {
			for (var i:uint = 0; i < borderingHexes.length; i++) {
				if (borderingHexes[i] == anotherHex)
					return true;
			}//end for
			return false;
		}//end isNeighboring(Hex)
		public function setRow(n:uint) {
			row = n;
			return;
		}//end setRow(uint)
		public function setColumn(n:uint) {
			column = n;
			return;
		}//end setColumn
		public function isUpperHex() {
			return ((uint(column/2) + uint(column/2)) != column);
		}//end isUpperHex
		public function getRow():uint {
			return row;
		}//end row
		public function getColumn():uint {
			return column;
		}//end column
		public function getTerrain():String {
			if (myTerrainType == ApocFarmer.PLAINS)
				return "Plains";
			else if (myTerrainType == ApocFarmer.SWAMP)
				return "Swampland";
			else if (myTerrainType == ApocFarmer.FOREST)
				return "Forest";
			return null;
		}//end getTerrain
		public function getPieces() {
			return myPieces;
		}
	}//end class
	
}//end package