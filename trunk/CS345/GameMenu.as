package {
	import flash.display.*;
	import flash.events.*;
	
	public class GameMenu extends MovieClip{
		private var verticalMenu:Boolean;
		private var horizontalMenu:Boolean;
		private var piecesDisplayed:Array;
		
		public function GameMenu(v:Boolean, h:Boolean) {
			if v displayVertical(null);
			if h displayHorizontal(null);
		}//end GameMenu(Boolean,Boolean)
		public function GameMenu(myHex:Hex)
			displayVertical(myHex);
			if (myHex.hasPieces())
				displayHorizontal(myHex);
		}//end GameMenu(Hex)
		public function displayVertical(h:Hex) {
			if (h == null) {
				trace("This is not a valid hex");
			} else {
				trace("Terrain type: " + h.getTerrain())
			}
		}//end displayVertical
	}//end class
	
}//end package