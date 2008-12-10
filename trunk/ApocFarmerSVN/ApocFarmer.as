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
		
		public static var TERRAIN_STATS:Array = ["Productivity Bonus", "Defense Bonus", "Movement Value"]
		public static var PROD_BONUS:uint = 0;
		public static var DEF_BONUS:uint = 1;
		public static var MOV_VALUE:uint = 2;
		
		
		public static var PLAINS:uint = 0;
		private static var PLAINS_STATS:Array = [5,0,1]
		
		public static var SWAMP:uint = 1;
		private static var SWAMP_STATS:Array = [-5,5,1]

		public static var FOREST:uint = 2;
		private static var FOREST_STATS:Array = [5,10,1]
		
		public static var terrainTypes:Array = new Array(PLAINS_STATS,SWAMP_STATS,FOREST_STATS);
		
		public static var FRAME_OFFSET = 2; //offset to add to terrain type to get the correct frame # in the hex mclip
		
		public static var COMMUNITY_STATS:Array = ["Upgrade Cost", "Max Population", "Production Rate", "Recruitment Rate", "Defense Value"]
		public static var UPGRADE_COST = 0;
		public static var MAX_POPULATION = 1;
		public static var PROD_RATE = 2;
		public static var RECRUIT_RATE = 3;
		public static var DEF_VALUE = 4;
		
		public static var VILLAGE:uint = 1;
		private static var VILLAGE_STATS = [0,20,10,5,10]
										   
		public static var TOWN:uint = 2;
		private static var TOWN_STATS:Array = [20,50,20,10,20]
		
		public static var CITY:uint = 3;
		private static var CITY_STATS = [40,80,30,15,30]
		
		public static var communityTypes = new Array([VILLAGE_STATS, TOWN_STATS, CITY_STATS]);
		
		public static var HUMAN:uint = 0;
		public var playersTurn:uint = HUMAN;
		public var players:Array = new Array();
		public var hMenu:HorizontalGameMenu;
		
		public var selectedHex:Hex = null;
		public var selectedPiece:GamePiece = null;
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
					var h:Hex = new Hex(this);
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
					/*
					trace("Hex: " + hexList[i][j].getColumn() + ", " + hexList[i][j].getRow());
					for (var n:uint = 0; n < hexList[i][j].borderingHexes.length; n++)
						trace(hexList[i][j].borderingHexes[n].getColumn() + ", " + hexList[i][j].borderingHexes[n].getRow());
					*/
				}//end for j
			}//end for i
		}//end drawBoard()
		public function isEven(n:uint):Boolean {
			return ((uint(n/2) + uint(n/2)) == n);
		}//end isEven(uint)
		public function startGame(event:MouseEvent):void {
			gotoAndStop(HEX_BOARD_FRAME);
			removeChild(event.target as NewGame);
			event.target.removeEventListener(MouseEvent.CLICK,startGame);
			drawBoard();
			hMenu = new HorizontalGameMenu(this);
			initializePlayers();
			
		}//end startGame
		public function initializePlayers():void {
			players.push(new Player(0));
			players.push(new AIPlayer(0));
			
			var randRow:uint = Math.floor(Math.random()*(BOARD_ROWS));
			var randCol:uint = Math.floor(Math.random()*BOARD_COLUMNS);
			var h0:Hex = hexList[randCol][randRow];
			
			randRow = Math.floor(Math.random()*(BOARD_ROWS));
			randCol = Math.floor(Math.random()*BOARD_COLUMNS);
			var h1:Hex = hexList[randCol][randRow];
			
			//h.foundCommunity(TOWN, 25, 30); 
			
			new GamePiece(h0, 5, 5, GamePiece.ARMY_UNIT,players[HUMAN]);
			new GamePiece(h1, 20, 20, GamePiece.ARMY_UNIT,players[1]);

		}//end initializePlayers
		public function boardClick(h:Hex) {
			if (selectedPiece != null) {
				selectedPiece.moveToHex(h);
				selectedPiece.unSelect();
				selectedPiece = null;
			}
			selectedHex = h;
			updateMenus(h);
		}//end boardClick
			
		public function updateMenus(h:Hex) {
			hMenu.newHex(h);
			//vMenu.newHex(h);
		}//end updateMenus
	}//end class
	
	
}//end package