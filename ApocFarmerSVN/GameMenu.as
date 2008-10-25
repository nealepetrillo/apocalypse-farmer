package {
	import flash.display.*;
	import flash.events.*;
	
	public class HorizontalGameMenu extends MovieClip{
		private var piecesDisplayed:Array;
		private var myGame:ApocFarmer;
		public function HorizontalGameMenu(game:ApocFarmer) {
			//x = ApocFarmer.BOARD_COLUMNS * WIDTH_OFFSET + HEX_WIDTH - WIDTH_OFFSET
			x = 0;
			y = ApocFarmer.BOARD_ROWS * HEX_HEIGHT + HEIGHT_OFFSET;
			myGame = game;
		}//end GameMenu(Boolean,Boolean)
		
		}//end GameMenu(Hex)
	}//end class
	
}//end package