package{
	import flash.display.*;
	
	public class Community extends MovieClip{
		
		
		private static var UPGRADE_COST = 0;
		private static var MAX_POPULATION = 1;
		private static var PROD_RATE = 2;
		private static var RECRUIT_RATE = 3;
		private static var DEF_VALUE = 4;
		
		private static var VILLAGE:uint = 1;
		private static var VILLAGE_STATS = [0,20,10,5,10];
										   
		private static var TOWN:uint = 2;
		private static var TOWN_STATS:Array = [20,50,20,10,20];
		
		public static var CITY:uint = 3;
		private static var CITY_STATS = [40,80,30,15,30];
		
		public static var communityTypes = new Array([VILLAGE_STATS, TOWN_STATS, CITY_STATS]);
		private static var COMMUNITY_STATS:Array = ["Upgrade Cost", "Max Population", "Production Rate", "Recruitment Rate", "Defense Value"];
		
		public var myTask:String;
		private var myType:uint;
		private var myPop:uint;
		private var myResources:uint;
		private var myHex:Hex;
		
		
		public var locked:uint;
		
		
		public function Community(pop:uint, rus:uint, h:Hex):void
		{			
			myHex = h;
			
			for(var i:int = communityTypes.length - 1;i >= 0;--i)
			{
				if(rus >= communityTypes[i][UPGRADE_COST])
				{
					myType = i;
					myPop = pop;
					myResources = rus - communityTypes[i][UPGRADE_COST];
					i = -1;
					myHex.myPlayer.addCommunity(this); 
					this.gotoAndStop(myType);
				}
			}
		}
		
		public function setStats(cType:uint, pop:uint, rus:uint):void
		{
			myType = cType;
			myPop = pop;
			myResources = rus;
		}
		
		public function upgrade():void
		{
			if(canUpgrade())
			{
				if(myType < communityTypes.length)
				{
					if(myResources >= communityTypes[myType][UPGRADE_COST])
					{
						myTask = "Upgrading";
						locked = 3;
						myResources = myResources - communityTypes[myType][UPGRADE_COST];
						myType = myType + 1;
						
					}
				}
			}
		}
		
		public function canUpgrade():Boolean
		{
			if(myResources >= communityTypes[myType][UPGRADE_COST])
			{
				return true; 
			}
			else
			{
				return false;
			}
		}
		
		public function reinforce(piece:GamePiece, n:uint):void {
			if ((myResources > n) && (myPop > n) && (n >0) ) {
				
				myTask = "Reinforcing";
				myResources = myResources - n; 
				myPop = myPop - n;
				locked = 1;
				piece.alterResources(n);
				piece.alterPop(n);
			}
			else {
				trace("error in communities class: unable to add resources!! P.S. Congradulations You've Won THE GAME!!"); 
			}
		}
		
		public function produce():void {
			
			myTask = "Producing";
			locked = 1;
			myResources = myResources + communityTypes[myType][PROD_RATE] + 
							ApocFarmer.terrainTypes[myHex.myTerrainType][ApocFarmer.PROD_BONUS];
							
			myPop = myPop + communityTypes[myType][RECRUIT_RATE]; 
			
			if(myPop > communityTypes[myType][MAX_POPULATION]) {
				myPop = communityTypes[myType][MAX_POPULATION];
			}
		}
		
		public function createArmy(n:uint):void {
			
			n = n +10; 
			
			if(canCreateArmy(n)) {
				myTask = "Creating an army";
				locked = 2;
				myResources = myResources - n;
				myPop = myPop - n;
				
				new GamePiece(myHex, n, n, GamePiece.ARMY_UNIT,myHex.myPlayer);
			}
			else {
				trace("not enough resources to create army");
			}
		}
		public function canCreateArmy(n:uint):Boolean {
			
			n = n+10;
			if(myResources >= n && myPop >= n) {
				return true; 
			}
			else {
				return false;
			}
		}
			
			
				
			
			
		
	}//End Class
}//End Package