package {
	import flash.display.*;
	import flash.events.*;
	
	public class ApocFarmer extends MovieClip{
				//////////////variable declarations////////////
		public static const BOARD_ROWS:uint = 8;
		public static const BOARD_COLUMNS:uint = 13;
		public static const HEX_HEIGHT:uint = 46;
		public static const HEX_WIDTH:uint = 53;
		public static const WIDTH_OFFSET:uint = 40;
		public static const HEIGHT_OFFSET:uint = 23;
		public static const HEX_BOARD_FRAME:uint = 2;
		private var hexList:Array = new Array();
		
		public static const TERRAIN_STATS:Array = ["Productivity Bonus", "Defense Bonus", "Movement Value"]
		public static const PROD_BONUS:uint = 0;
		public static const DEF_BONUS:uint = 1;
		public static const MOV_VALUE:uint = 2;
		
		
		public static const PLAINS:uint = 0;
		private static const PLAINS_STATS:Array = [5,0,1]
		
		public static const SWAMP:uint = 1;
		private static const SWAMP_STATS:Array = [-5,5,1]

		public static const FOREST:uint = 2;
		private static const FOREST_STATS:Array = [5,10,1]
		
		public static const terrainTypes:Array = new Array(PLAINS_STATS,SWAMP_STATS,FOREST_STATS);
		
		public static const FRAME_OFFSET = 2; //offset to add to terrain type to get the correct frame # in the hex mclip
		
		public static const COMMUNITY_STATS:Array = ["Upgrade Cost", "Max Population", "Production Rate", "Recruitment Rate", "Defense Value"]
		public static const UPGRADE_COST = 0;
		public static const MAX_POPULATION = 1;
		public static const PROD_RATE = 2;
		public static const RECRUIT_RATE = 3;
		public static const DEF_VALUE = 4;
		
		public static const VILLAGE:uint = 1;
		private static const VILLAGE_STATS = [0,20,10,5,10]
										   
		public static const TOWN:uint = 2;
		private static const TOWN_STATS:Array = [20,50,20,10,20]
		
		public static const CITY:uint = 3;
		private static const CITY_STATS = [40,80,30,15,30]
		
		public static const communityTypes = new Array(VILLAGE_STATS, TOWN_STATS, CITY_STATS);
		
		public static const HUMAN:uint = 0;
		public var playersTurn:uint = HUMAN;
		public var players:Array = new Array();
		public var theTurn:AFTurn = null;
		public var currentPhase:String;
				
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
			players.push(new AIPlayer(1));
			
			var randRow:uint = Math.floor(Math.random()*(BOARD_ROWS));
			var randCol:uint = Math.floor(Math.random()*BOARD_COLUMNS);
			trace(randRow + "," + randCol);
			var h0:Hex = hexList[randCol][randRow];
			
			randRow = Math.floor(Math.random()*(BOARD_ROWS));
			randCol = Math.floor(Math.random()*BOARD_COLUMNS);
			trace(randRow + "," + randCol);
			var h1:Hex = hexList[randCol][randRow];
			
			h0.foundCommunity(new GamePiece(h0, 100, 100, GamePiece.ARMY_UNIT, players[0])); 
			h1.foundCommunity(new GamePiece(h1, 100, 100, GamePiece.ARMY_UNIT, players[1]));
			
			new GamePiece(h0, 30, 30, GamePiece.ARMY_UNIT,players[0]);
			new GamePiece(h1, 30, 30, GamePiece.ARMY_UNIT,players[1]);
			
			
			theTurn = new AFTurn(players[playersTurn],this);
			

		}//end initializePlayers
		public function nextTurn() {
			if (players[++playersTurn] == null)//increment playersTurn, and if it's the last player
				playersTurn = 0;//then go back to the first player
			theTurn = new AFTurn(players[playersTurn],this);
		}//end nextTurn
		
		public function boardClick(h:Hex) {
			if (playersTurn == HUMAN) {
				if (selectedPiece != null && selectedPiece.myPlayer.playerNum == playersTurn) {
					selectedPiece.moveToHex(h);
					if (selectedPiece != null)//if it wasn't destroyed
						selectedPiece.unSelect();//unselect it
					selectedPiece = null;
					nextTurn();
					updateMenus(h);
					theTurn = new AFTurn(players[playersTurn],this);
				}
				selectedHex = h;
			}
			updateMenus(h);
		}//end boardClick
			
		public function updateMenus(h:Hex) {
			hMenu.newHex(h);
			//vMenu.newHex(h);
		}//end updateMenus
		
		public function destroyPiece(gp:GamePiece) {
			trace("Destroying " + gp.toString());
			gp.moveToHex(null);//move the piece off the board
			gp.myPlayer.armies.splice(gp.myPlayer.armies.indexOf(gp),1);//remove the piece from the players inventory
			if (selectedPiece == gp) {
				selectedPiece = null;
				gp.unSelect();
			}//end unselected the piece if necessary
			updateMenus(gp.myHex);
			if (hMenu.contains(gp.myDisplayInfo))
				hMenu.removeChild(gp.myDisplayInfo);
		}//end destroyPiece
		
		public function destroyCommunity(c:Community) {
			c.myHex.myPlayer.communities.splice(c.myHex.myPlayer.communities.indexOf(c),1);
			if (c.myHex.contains(c))
				c.myHex.removeChild(c);
		}//end destroyCommunity
	}//end class
	
	
}//end package