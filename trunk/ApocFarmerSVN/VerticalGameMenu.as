package {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	public class VerticalGameMenu extends MovieClip{
		private var myGame:ApocFarmer;
		private var currentHex:Hex;
		private var currentCommunity:Community;
		private var communityStats:TextField;
		private var createB:GUICreateArmyButton;
		private var produceB:GUIProduceButton;
		private var reinforceB:GUIReinforceButton;
		private var upgradeB:GUIUpgradeButton;
		private var endTurn:GUIEndTurn;
		public function VerticalGameMenu(game:ApocFarmer) {
			x = ApocFarmer.BOARD_COLUMNS * ApocFarmer.WIDTH_OFFSET + ApocFarmer.HEX_WIDTH - ApocFarmer.WIDTH_OFFSET;
			y = 0;
			myGame = game;
			myGame.addChild(this);
			stop();
		}//end GameMenu(Boolean,Boolean)
		public function newHex(h:Hex) {
			currentHex = h;
			currentCommunity = currentHex.myCommunity;
			drawMenu();
		}
		public function drawMenu() {
			if (currentCommunity != null) {
				if (communityStats != null && this.contains(communityStats)) {
					removeChild(communityStats)
				}//end if 
				communityStats = new TextField();
				communityStats.selectable = false;
				communityStats.width = 180;
				communityStats.x = 5;
				communityStats.appendText("Community Type: " + Community.COMMUNITY_TYPE[currentCommunity.myType] + '\n' +
											"Population: " + currentCommunity.myPop + '\n' +
											"Resources: " + currentCommunity.myResources + '\n');
				if (currentCommunity.myTask)
					communityStats.appendText(currentCommunity.myTask + '\n');
				if (currentCommunity.locked > 0 ) {
					communityStats.appendText("It is locked for the next " + currentCommunity.locked + " turn(s).\n");
				}//end if
				addChild(communityStats);
				if (currentCommunity.myHex.myPlayer.playerNum == 0 && myGame.currentPhase == AFTurn.MANAGE_PHASE) {
					
					if (currentCommunity.canUpgrade()) {
						if(!upgradeB) {
							upgradeB = new GUIUpgradeButton();
							addChild(upgradeB);
							upgradeB.addEventListener(MouseEvent.CLICK,upgradeClicked);
							upgradeB.y = 80;
						}//end if
					} else {
						if(upgradeB) {
							upgradeB.removeEventListener(MouseEvent.CLICK,upgradeClicked);
							if(contains(upgradeB))
								removeChild(upgradeB);
							upgradeB = null;
						}//end if
					}//end else
					if (currentCommunity.canCreateArmy(10)) {
						if(!createB) {
							createB = new GUICreateArmyButton();
							addChild(createB);
							createB.addEventListener(MouseEvent.CLICK, createClicked);
							createB.y = 145;
						}//end if
					} else {
						if(createB) {
							createB.removeEventListener(MouseEvent.CLICK, createClicked);
							if(contains(createB))
								removeChild(createB);
							createB = null;
						}//end if
					}//end else
					if (currentCommunity.canReinforce()) {
						if(!reinforceB) {
							reinforceB = new GUIReinforceButton();
							addChild(reinforceB);
							reinforceB.addEventListener(MouseEvent.CLICK, reinforceClicked);
							reinforceB.y = 170;
						}//end if
					} else {
						if(reinforceB) {
							reinforceB.removeEventListener(MouseEvent.CLICK, reinforceClicked);
							if(contains(reinforceB))
								removeChild(reinforceB);
							reinforceB = null;
						}//end if
					}//end else
					if (currentCommunity.locked == 0) {
						if(!produceB) {
							produceB = new GUIProduceButton();
							addChild(produceB);
							produceB.addEventListener(MouseEvent.CLICK, produceClicked);
							produceB.y = 215;
						}//end if
					} else {
						if(produceB) {
							produceB.removeEventListener(MouseEvent.CLICK, produceClicked);
							if(contains(produceB))
								removeChild(produceB);
							produceB = null;
						}//end if
					}//end else					
				}//end if
				
			} else {
				if (communityStats)
					if (this.contains(communityStats))
						removeChild(communityStats);
				if (upgradeB)
					if(contains(upgradeB))
						removeChild(upgradeB);
				if (createB)
					if(contains(createB))
						removeChild(createB);
				if (reinforceB)
					if(contains(reinforceB))
						removeChild(reinforceB);
				if (produceB)
					if(contains(produceB))
						removeChild(produceB);
			}//end if else
			if (myGame.playersTurn == ApocFarmer.HUMAN && myGame.currentPhase == AFTurn.MANAGE_PHASE) {
				if(!endTurn) {
					endTurn = new GUIEndTurn();
					endTurn.addEventListener(MouseEvent.CLICK, endTurnClicked);
					addChild(endTurn);
					endTurn.y = 350;
				}
			} else if (endTurn) {
				endTurn.removeEventListener(MouseEvent.CLICK, endTurnClicked);
				if(contains(endTurn))
					removeChild(endTurn);
				endTurn = null;
			}//end if else
				
		}//end drawMenu
		public function endTurnClicked(e:MouseEvent) {
			myGame.theTurn.endPhaseTwo();
		}//end endTurnClicked
		public function produceClicked(e:MouseEvent) {
			currentCommunity.locked = 1;
			currentCommunity.myTask = Community.TASK_PRODUCE;
			myGame.updateMenus(currentCommunity.myHex);
		}//end produceClicked
		public function upgradeClicked(e:MouseEvent) {
			currentCommunity.locked = 3;
			currentCommunity.myTask = Community.TASK_UPGRADE;
			myGame.updateMenus(currentCommunity.myHex);
		}//end upgradeClicked
		public function createClicked(e:MouseEvent) {
			currentCommunity.locked = 2;
			currentCommunity.myTask = Community.TASK_CREATE;
			myGame.updateMenus(currentCommunity.myHex);
		}//end createClicked
		public function reinforceClicked(e:MouseEvent) {
			currentCommunity.locked = 1;
			currentCommunity.myTask = Community.TASK_REINFORCE;
			myGame.updateMenus(currentCommunity.myHex);
		}//end reinforceClicked
	}//end class
	
}//end package