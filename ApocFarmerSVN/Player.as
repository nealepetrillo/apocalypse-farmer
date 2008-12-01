package {
	
	class Player {
				
		private var communities:Array = new Array(); //List of owned communities 
		private var armies:Array = new Array(); //List of availiable armies
		private var playerNum:uint; //Player Number
		
		
		public function Player(playerNumber:uint):void
		{
			playerNum = playerNumber;
		}
		
		public function addCommunity(c:Community):void
		{
			communities.push(c); 
		}
		
		public function addArmy(a:GamePiece):void
		{
			armies.push(a);
		}
		
	}//end class
}//end package