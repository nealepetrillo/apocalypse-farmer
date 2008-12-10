package {
	
	class Player {
				
		public var communities:Array = new Array(); //List of owned communities 
		public var armies:Array = new Array(); //List of availiable armies
		public var playerNum:uint; //Player Number
		public var GPFRAME = 1;
		
		
		public function Player(playerNumber:uint):void
		{
			playerNum = playerNumber;
		}
		
		public function getPlayerNum():uint
		{
			return playerNum;
		}
		
		public function addCommunity(c:Community):void
		{
			communities.push(c); 
		}
		
		public function addPiece(a:GamePiece):void
		{
			armies.push(a);
		}
		
	}//end class
}//end package