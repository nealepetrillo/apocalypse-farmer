package {
	import flash.events.*;
	import flash.display.*;
	public class PieceInfo extends MovieClip {
		private var myPiece:GamePiece;
		public function PieceInfo(gp:GamePiece) {
			myPiece = gp
			addEventListener(MouseEvent.CLICK,pieceSelected);
			buttonMode = true;
			if(gp.myPlayer.GPFRAME == 2)
				gotoAndStop(3);
			stop();
		}
		public function pieceSelected(e:MouseEvent) {
			myPiece.beenSelected();
		}
	}
}