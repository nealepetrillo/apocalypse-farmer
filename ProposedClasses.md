**Here's a list of Classes I propose we'll need, with basic details fleshed out.**

```
class GameBoard extends MovieClip
	GameBoard(Sprite, Array)
	GameBoard()
	Sprite backgroundImg
	Array hexList
```
```
class Hex extends Button
	Hex()
	Hex(Button)
	Hex(char)
	Hex(char terrainType, uint ambientRadiation)
	Bool playerOwned
	 villagePresent ???
	uint defensiveValue
	float ambientRadiation
	float productionValue
	char terrainType
	uint movementBonus
	uint maxPopluation
	uint positionIndex
```
```
class Village extends Button
	Village()
	Village(uint numberOfPeople)
	uint numFarmers
	uint numCraftsman
	float productionBonus
	float radiationBonus
	uint currentPopulation	
```
```
class GamePiece extends Button
	GamePiece(uint size)
	GamePiece(String UNIT_TYPE)
	bool amryUnit
	uint size
	uint defensiveValue
	uint offensiveValue
	uint movementValue
```
```
class Player
	Player()
	String name
	uint difficultyLevel
	bool territorialControlWin
	bool deathmatchWin
	bool technologyWin
	Array indecesOfVillages
	Array  indecesOfGamePieces
```
**Feel free to edit this list, but please leave a note in the log if you do.**