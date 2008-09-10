﻿package {
	import flash.display.*;
	import flash.events.*;
	
	public class Hex extends MovieClip {
		private var row:uint;
		private var column:uint;
		private var borderingHexes:Array = new Array();
		
		public function Hex():void {
			row = 0;
			column = 0;
		}//end Hex
		public function setNeighbors(allHexes:Array):void {
			//detect a corner hex
			if (this.column == 0 && this.row == 0) { 						//NW corner
				borderingHexes.push(allHexes[column+1][row]);
				borderingHexes.push(allHexes[column+1][row+1]);
				borderingHexes.push(allHexes[column][row+1]);
			} else if (this.column == 0 && this.row == allHexes[column].length) { //SW corner
				borderingHexes.push(allHexes[column][row+1]);
				borderingHexes.push(allHexes[column+1][row]);
			} else if (this.column == allHexes.length -1) {
				if (this.row == 0) { 										//NE corner
					borderingHexes.push(allHexes[column-1][row]);
					borderingHexes.push(allHexes[column][row+1]);
					if (this.isUpperHex()) 				//checks for odd column
						borderingHexes.push(allHexes[column-1][row+1]);
				} else if (this.row == allHexes[column].length) { 		//SE corner
					borderingHexes.push(allHexes[column][row+1]);
					borderingHexes.push(allHexes[column-1][row]);
					if (this.isUpperHex()) 				//checks for odd column
						borderingHexes.push(allHexes[column-1][row-1]);
				}//end if-else left corners
			} else {
				
			//detect an edge hex
			if (this.row == 0) {
				if (this.isUpperHex()) {
					borderingHexes.push(allHexes[column-1][row]);
					borderingHexes.push(allHexes[column][row+1]);
					borderingHexes.push(allHexes[column+1][row]);
				} else {
					borderingHexes.push(allHexes[column-1][row]);
					borderingHexes.push(allHexes[column-1][row+1]);
					borderingHexes.push(allHexes[column][row+1]);
					borderingHexes.push(allHexes[column+1][row+1]);
					borderingHexes.push(allHexes[column+1][row]);
			}}//end if-else upper edge
			if (this.row == allHexes[column].length) {
				borderingHexes.push(allHexes[column-1][row]);
				borderingHexes.push(allHexes[column][row-1]);
				borderingHexes.push(allHexes[column+1][row]);
				if (this.isUpperHex()) {
					borderingHexes.push(allHexes[column-1][row-1]);
					borderingHexes.push(allHexes[column+1][row-1]);
			}}//end if bottome edge
			if (this.column == 0) {
				borderingHexes.push(allHexes[column][row-1]);
				borderingHexes.push(allHexes[column+1][row]);
				borderingHexes.push(allHexes[column+1][row+1]);
				borderingHexes.push(allHexes[column][row+1]);
			}//end if left edge
			if (this.column == allHexes.length -1) {
				borderingHexes.push(allHexes[column][row-1]);
				borderingHexes.push(allHexes[column][row+1]);
				borderingHexes.push(allHexes[column-1][row]);
				if (this.isUpperHex())
					borderingHexes.push(allHexes[column-1][row-1]);
				else borderingHexes.push(allHexes[column-1][row+1]);
			}//end if right edge
				
			//there are six possible neighbors for internal hexes
			borderingHexes.push(allHexes[column+1][row]);
			borderingHexes.push(allHexes[column-1][row]);
			borderingHexes.push(allHexes[column][row+1]);
			borderingHexes.push(allHexes[column][row-1]);
			if (isUpperHex()) {
				borderingHexes.push(allHexes[column-1][row-1]);
				borderingHexes.push(allHexes[column+1][row-1]);
			} else {
				borderingHexes.push(allHexes[column-1][row+1]);
				borderingHexes.push(allHexes[column+1][row+1]);
			}//end if - else
			}//end else intenrnal hex
		}//end setNeighbors(Array)
		public function setRow(n:uint) {
			row = n;
			return;
		}//end setRow(uint)
		public function setColumn(n:uint) {
			column = n;
			return;
		}//end setColumn
		public function isUpperHex() {
			return ((uint(column/2) + uint(column/2)) != column);
		}//end isUpperHex
	}//end class
	
}//end package