package {
	import flash.events.*;
	import flash.text.*;
	import flash.display.*;
	public class AFTurn extends EventDispatcher{
		public static const MOVEMENT_PHASE:String = "This is the movement phase";
		public static const MANAGE_PHASE:String = "This is the management phase";
		
		public var player:Player = null;
		public var game:ApocFarmer = null;
		public var combatInfo:TextField = new TextField();
		
		public function AFTurn(g:ApocFarmer) {
			game = g;
		}//end AFTurn
		public function startPhaseOne() {
			player = game.players[game.playersTurn];
			//game.playersTurn = player.playerNum;
			if (player.GPFRAME == 2) {
				(player as AIPlayer).startTurn();
				game.nextTurn();
			}//end if player is an AI
			else { //player is a human
				//trace("Human turn starting");
				game.currentPhase = MOVEMENT_PHASE;
				//addEventListener(PhaseEvent.NEW_PHASE, startPhaseTwo);
				//addEventListener(CombatEvent.COMBAT_START, this.startCombat);
				//trace("Worked? " + willTrigger(CombatEvent.COMBAT_START));
			}//end else			
		}//end startPhaseOne
		public function startPhaseTwo() {
			game.currentPhase = MANAGE_PHASE;
		}//end startPhaseTwo
		public function endPhaseTwo() {
			for (var i:uint = 0; i < player.communities.length; i++) {
				var c:Community = player.communities[i];
				c.locked --;
				if(c.locked <= 0) {
					c.locked = 0;
					if(c.myTask == Community.TASK_PRODUCE)
						c.produce();
					if(c.myTask == Community.TASK_UPGRADE)
						c.upgrade();
					if(c.myTask == Community.TASK_CREATE)
						c.createArmy(10);
					if(c.myTask == Community.TASK_REINFORCE)
						c.reinforce(c.myHex.myPieces[0],10);
					c.locked = 0;
				}//end if
			}//end for
			game.nextTurn();
		}//end endPhaseTwo
		public function startCombat(e:CombatEvent) {
			game.infoClip = new MovieClip();
			game.infoClip.stop();
			game.infoClip.x = ApocFarmer.BOARD_COLUMNS * ApocFarmer.WIDTH_OFFSET + ApocFarmer.HEX_WIDTH - ApocFarmer.WIDTH_OFFSET + 5;
			game.infoClip.y = ApocFarmer.BOARD_ROWS * ApocFarmer.HEX_HEIGHT + ApocFarmer.HEIGHT_OFFSET + 5;
			game.infoClip.addChild(combatInfo);
			combatInfo = new TextField();
			combatInfo.selectable = false;
			game.addChild(game.infoClip);
			
		
			trace("Combat starting...");
			combatInfo.appendText("Combat starting...\n");
			var attackStrength:Number = e.attacker.population * (1 + Math.random());
			var defenseValue:Number = e.battleSite.myDefBonus;
			var PlayerA = e.attacker.myPlayer;
			var PlayerD = e.defenders[0] ? e.defenders[0].myPlayer : e.battleSite.myPlayer;//set the defender player to the owner of the defending piece, of the defending community if no pieces exist
			if (e.battleSite.myCommunity != null)
				defenseValue += Community.communityTypes[e.battleSite.myCommunity.myType][Community.DEF_VALUE];
			var defenseStrength:uint = 0;
			for (var i:uint = 0; i < e.defenders.length; i++)
				defenseStrength += e.defenders[i].population;
			var totalDefense:Number = defenseValue * (1 + Math.random()) + defenseStrength;
			var losses:uint = 0;
			if (totalDefense >= attackStrength) { //defenders win
				trace("The defenders won");
				game.infoClip = new DyingGuy();
				combatInfo.appendText("The defenders won!\n");
				losses = e.attacker.population / 2;
				game.destroyPiece(e.attacker);
				for (i = 0; i < e.defenders.length && losses > 0; i ++) {//cycle through the defending armies to assign losses
					if (e.defenders[i].population > losses) { //if the current army can take all the losses and survive
						trace("Defending army survived");
						combatInfo.appendText("Defending army survived.\n");
						e.defenders[i].alterPop(-1*losses);
						losses = 0;
					}else if (e.defenders[i].population == losses) { //if the current army absorbs all the losses and dies
						trace("Defending army died");
						combatInfo.appendText("Defending army died.");
						game.destroyPiece(e.defenders[i]);
						losses = 0;
					}else if (e.defenders[i].population < losses) { //if the current army is destroyed and there's still losses
						trace("Defending army died");
						combatInfo.appendText("Defending army died.");
						losses -= e.defenders[i].population;
						game.destroyPiece(e.defenders[i]);
					}//end if else
				}//end for
				if (losses > 0) {
					if (e.battleSite.myCommunity != null) {//if there's still losses, try to assign them to a community
						if (e.battleSite.myCommunity.getPop() - losses/3 >= 10) {
							trace("Defending community reduced");
							combatInfo.appendText("Defending commnity reduced.");
							e.battleSite.myCommunity.alterPop(-1 * losses / 3);
						} else {
							trace("Defending community ravaged");
							combatInfo.appendText("Defending community ravaged.");
							e.battleSite.myCommunity.setPop(10);
						}//end if else community losses
					} else {
						trace("Defenders reduced to basic army");
						combatInfo.appendText("Defending armies ravaged.");
						new GamePiece(e.battleSite,10,10,GamePiece.ARMY_UNIT,PlayerD);//else leave the defender with only the smallest piece size left
					}//end if else 
				}//end if
				
			}else { //attakcers win
				trace("Attacers win");
				combatInfo.appendText("Attackers won!");
				losses = defenseStrength ? defenseStrength : e.battleSite.myCommunity.getPop();
				losses /= 2; //losses are set to half the defending armies strength (or the communitys strenght if no army is present)
				if (e.battleSite.myCommunity != null) {//if there's a community,
					trace("Destroying community");
					combatInfo.appendText("Destroying defending community...");
					game.destroyCommunity(e.battleSite.myCommunity);//then destroy it
				}//end if
				if (e.attacker.population - losses > 0) {//if the attacker can take the losses
					trace("Attacker reduced");
					combatInfo.appendText("Attacker reduced.");
					e.attacker.alterPop(-1 * losses);//then he does so, 
					e.battleSite.myPlayer = e.attacker.myPlayer;//and gets the hex,
					e.attacker.moveToHex(e.battleSite);
				}else {
					trace("Attacker destroyed");
					combatInfo.appendText("Attacker destroyed.");
					game.destroyPiece(e.attacker);//otherwise he gets destroyed
					e.attacker = null;
					e.battleSite.myPlayer = null;
				}//end if else
				trace("Destroying defending armies");
				combatInfo.appendText("Destroying defending armies...");
				for (i=0; i < e.defenders.length; i++) {//destroy all defending armies
					game.destroyPiece(e.defenders[i])
					e.defenders[i] = null;
				}//end for
				
				
			}//end if else
			game.updateMenus(e.battleSite);
		}//end startCombat
	}//end class
}//end package