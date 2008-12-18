package{
	import flash.display.*;
	
	public class Community extends MovieClip{
		
		
		public static const UPGRADE_COST = 0;
		public static const MAX_POPULATION = 1;
		public static const PROD_RATE = 2;
		public static const RECRUIT_RATE = 3;
		public static const DEF_VALUE = 4;
		
		public static const VILLAGE:uint = 0;
		public static const VILLAGE_STATS = [10,20,10,5,10];
										   
		public static const TOWN:uint = 1;
		public static const TOWN_STATS:Array = [20,50,20,10,20];
		
		public static const CITY:uint = 2;
		public static const CITY_STATS = [40,80,30,15,30];
		
		public static const communityTypes = new Array(VILLAGE_STATS, TOWN_STATS, CITY_STATS);
		public static const COMMUNITY_STATS:Array = ["Upgrade Cost", "Max Population", "Production Rate", "Recruitment Rate", "Defense Value"];
		public static const COMMUNITY_TYPE:Array = ["Village", "Town", "City"];
		
		public var myTask:String;
		public var myType:uint;
		public var myPop:uint;
		public var myResources:uint;
		public var myHex:Hex;
		public var isHome:Boolean;
		
		public static const TASK_UPGRADE:String = "This community is upgrading itself.";
		public static const TASK_REINFORCE:String = "This community is reinforcing an army.";
		public static const TASK_CREATE:String = "This community is forming an army.";
		public static const TASK_PRODUCE:String = "This community is producing.";
		
		public var locked:int;
	
		
		
		public function Community(pop:uint, rus:uint, h:Hex, home:Boolean):void
		{			
			isHome = home;
			myHex = h;
			//trace("p: " + pop + "\tr: " + rus);
			
			for(var i:int = communityTypes.length - 1;i >= 0;--i)
			{
				trace(communityTypes[i][UPGRADE_COST]);
				if(rus >= communityTypes[i][UPGRADE_COST] && pop >= communityTypes[i][UPGRADE_COST])
				{
					myType = i;
					myPop = pop;
					myResources = rus  - communityTypes[i][UPGRADE_COST];
					i = -1;
					myHex.myPlayer.addCommunity(this); 
					this.gotoAndStop(myType+1);
					//trace("I am type: " +myType);
				}
			}
		}
		
		public function setStats(cType:uint, pop:uint, rus:uint):void
		{
			myType = cType;
			myPop = pop;
			myResources = rus;
		}
		
		public function setPop(p:uint) {
			myPop = p;
		}
		
		public function alterPop(n:uint) {
			myPop += n;
		}
		
		public function getPop():uint {
			return myPop;
		}
		
		public function upgrade():void
		{
			if(canUpgrade())
			{
				if(myType < communityTypes.length)
				{
					if(myResources >= communityTypes[myType][UPGRADE_COST])
					{
						myTask = TASK_UPGRADE;
						locked = 3;
						myResources = myResources - communityTypes[myType][UPGRADE_COST];
						myType = myType + 1;
						
					}
				}
			}
		}
		
		public function canUpgrade():Boolean
		{
			if(myResources >= communityTypes[myType][UPGRADE_COST] && locked == 0)
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
				
				myTask = TASK_REINFORCE;
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
		
		/*For AI Only*/
		public function canReinforce():Boolean {
			if((myResources > 10) && (myPop > 10) && (myHex.myPieces.length > 0) && locked == 0) {
				return true;
			}
			else {
				return false;
			}
		} //end canReinforce
		
		public function produce():void {
			
			myTask = TASK_PRODUCE;
			locked = 1;
			myResources = myResources + communityTypes[myType][PROD_RATE] + 
							ApocFarmer.terrainTypes[myHex.myTerrainType][ApocFarmer.PROD_BONUS];
							
			myPop = myPop + communityTypes[myType][RECRUIT_RATE]; 
			
			if(myPop > communityTypes[myType][MAX_POPULATION]) {
				myPop = communityTypes[myType][MAX_POPULATION];
			}
		}
		
		public function createArmy(n:uint):void {
			
			if(canCreateArmy(n)) {
				myTask = TASK_CREATE;
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
			
			if (n < 10)
				return false;
			if(myResources >= n && myPop >= n && locked == 0) {
				return true; 
			}
			else {
				return false;
			}
		}
			
			
				
			
			
		
	}//End Class
}//End Package