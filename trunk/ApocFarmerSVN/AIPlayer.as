package {
	import flash.events.*;
	
	public class AIPlayer extends Player{
		
		public function AIPlayer(playerNum:uint):void
		{
			new Player(playerNum);
		}
		
		public function movePiece(p:GamePiece, h:Hex):void
		{
			p.moveToHex(h);
		}
		
		public function startTurn():void
		{
			
		}
		

		
	}//end class
}//end package