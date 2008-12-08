package{
	
	public class Community {
		
		
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
		private var myType:uint;
		private var myPop:uint;
		private var myResources:uint;

		
		
		
		public function Community(pop:uint, rus:uint):void
		{			
			for(int i = communityTypes.length - 1;i >= 0;--i)
			{
				if(rus >= communityTypes[i][UPGRADE_COST])
				{
					myType = i;
					myPop = pop;
					myResources = rus - communityTypes[i][0];
					i = -1;//ghetto BREAK statement 
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
					if(myResources >= communityTypes[myType][0])
					{
						myResources = myResources - communityTypes[myType][0];
						myType = myType + 1;
					}
				}
			}
		}
		
		public function canUpgrade():Boolean
		{
			if(myResources >= communityTypes[myType][0])
			{
				return true; 
			}
			else
			{
				return false;
			}
		}
		
	}//End Class
}//End Package