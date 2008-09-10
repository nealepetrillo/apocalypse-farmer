﻿package {
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
		}//end startGame
	}//end class
	
	
}//end package