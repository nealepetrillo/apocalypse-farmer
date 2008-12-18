package {
	import flash.display.*;
	import flash.events.*;
	
	public class HorizontalGameMenu extends MovieClip{
		private var piecesDisplayed:Array = new Array();
		private var myGame:ApocFarmer;
		private var currentHex;
		private var PieceInfo_WIDTH = 60;
		public function HorizontalGameMenu(game:ApocFarmer) {
			x = 0;
			y = ApocFarmer.BOARD_ROWS * ApocFarmer.HEX_HEIGHT + ApocFarmer.HEIGHT_OFFSET;
			myGame = game;
			myGame.addChild(this);
			stop();
		}//end GameMenu(Boolean,Boolean)
		public function newHex(h:Hex) {
			for (var i:uint = 0; i < piecesDisplayed.length; i++)
				if (piecesDisplayed[i] && this.contains(piecesDisplayed[i].myDisplayInfo))
					removeChild(piecesDisplayed[i].myDisplayInfo);
			currentHex = h;
			piecesDisplayed = currentHex.getPieces();
			drawMenu();
		}
		public function drawMenu() {
			for (var i:uint = 0; i < piecesDisplayed.length; i++) {
				if (piecesDisplayed[i])
					addChild(piecesDisplayed[i].displayInfo(i*PieceInfo_WIDTH + 10,10));
			}//end for
		}//end drawMenu
	}//end class
	
}//end package