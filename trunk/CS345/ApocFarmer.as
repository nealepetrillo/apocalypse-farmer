package {
	import flash.display.*;
	import flash.events.*;
	
	public class ApocFarmer extends MovieClip{
				//////////////variable declarations////////////
		public static var BOARD_ROWS:uint = 8;
		public static var BOARD_COLUMNS:uint = 13;
		public static var HEX_HEIGHT:uint = 46;
		public static var HEX_WIDTH:uint = 53;
		public static var WIDTH_OFFSET:uint = 40;
		public static var HEIGHT_OFFSET:uint = 23;
		public static var HEX_BOARD_FRAME:uint = 2;
		private var hexList:Array = new Array();
		public static var NUM_TERRAIN_TYPES = 6;
		
		public static var TERRAIN_STATS:Array = ["Productivity Bonus", "Attack Bonus", "Defense Bonus", "Movement Value"]
		public static var PROD_BONUS:uint = 0;
		public static var ATTACK_BONUS:uint = 1;
		public static var DEF_BONUS:uint = 2;
		public static var MOV_VALUE:uint = 3;
		public static var PLAINS:uint = 0;
		private static var PLAINS_STATS:Array = [1,1,0,1]
		public static var TOWN:uint = 1;
		private static var TOWN_STATS:Array = [3,0,3,1]
		public static var SWAMP:uint = 2;
		private static var SWAMP_STATS:Array = [-1,1,1,1]
		public static var HILL:uint = 3;
		private static var HILL_STATS:Array = [0,1,2,1]
		public static var IMPASS:uint = 4;
		private static var IMPASS_STATS:Array = [-3,0,0,0]
		public static var FOREST:uint = 5;
		private static var FOREST_STATS:Array = [1,2,2,1]
		public static var terrainTypes:Array = new Array(PLAINS_STATS,TOWN_STATS,SWAMP_STATS,HILL_STATS,IMPASS_STATS,FOREST_STATS);
		
		public var player1pieces:Array;
		public var player2pieces:Array;
		
		public var playersTurn:Boolean;
		public var aiPlayers:Array = new Array();
		public var selectedPiece:GamePiece;
				//////////////////constructors/////////////////////
		public function ApocFarmer():void {
			var startNewGame:NewGame = new NewGame();
			startNewGame.x = 175;
			startNewGame.y = 120;
			addChild(startNewGame);
			startNewGame.addEventListener(MouseEvent.CLICK,startGame);
			
		}//end ApocFarmer()
		
				//////////////////methods///////////////////////
		public function drawBoard():void {
			for (var hx:uint = 0; hx < BOARD_COLUMNS; hx++) {
				hexList.push(new Array());
				for (var hy:uint = 0; hy < BOARD_ROWS; hy++) {
					var h:Hex = new Hex();
					h.stop();
					h.x = hx * WIDTH_OFFSET;
					h.y = uint(isEven(hx)) * HEIGHT_OFFSET + hy * HEX_HEIGHT;
					addChild(h);
					h.setRow(hy);
					h.setColumn(hx);
					hexList[hx].push(h);
				}//end for hy
			}//end for hx
			for (var i:uint = 0; i < hexList.length; i++) {
				for (var j:uint = 0; j < hexList[i].length; j++) {
					hexList[i][j].setNeighbors(hexList);
					trace("Hex: " + hexList[i][j].getColumn() + ", " + hexList[i][j].getRow());
					for (var n:uint = 0; n < hexList[i][j].borderingHexes.length; n++)
						trace(hexList[i][j].borderingHexes[n].getColumn() + ", " + hexList[i][j].borderingHexes[n].getRow());
				}//end for j
			}//end for i
		}//end drawBoard()
		public function isEven(n:uint):Boolean {
			return ((uint(n/2) + uint(n/2)) == n);
		}//end isEven(uint)
		public function startGame(event:MouseEvent):void {
			gotoAndStop(HEX_BOARD_FRAME);
			removeChild(event.target as NewGame);
			drawBoard();
			initializePlayers();
			
		}//end startGame
		public function initializePlayers():void {
			player1pieces = [new GamePiece(hexList[0][2],1,GamePiece.ARMY_UNIT), new GamePiece(hexList[0][3],1,GamePiece.ARMY_UNIT), new GamePiece(hexList[0][4],1,GamePiece.ARMY_UNIT)];
			player2pieces = [new GamePiece(hexList[12][3],1,GamePiece.ARMY_UNIT), new GamePiece(hexList[12][4],1,GamePiece.ARMY_UNIT), new GamePiece(hexList[12][5],1,GamePiece.ARMY_UNIT)];
			
		}//end initializePlayers
		public function boardClick(h:Hex) {
			updateMenus(h);
			if(playersTurn) {
				if(selectedPiece!=null) {
					selectedPiece.moveTo(h);
					selectedPiece = null;
				}//end if
				else selectedPiece = h.selectPiece();
			}//end if
		}//end boardClick
			
	}//end class
	
	
}//end package