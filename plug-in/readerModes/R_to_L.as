class R_to_L {
	var n:Number;
	var nOut:Number;
	var startTxt:String;
	var startTxtLength:Number;
	var txtDef:String;
	var txtLength:Number;
	var txtOutLength:Number;
	var myTxt:String;
	var myTxtOut:String
	function R_to_L() {
	}
	function starter(trgt) {
		this.n = 0;
		this.nOut = 0;
		this.startTxt = "                      ";
		this.startTxtLength = this.startTxt.length;
		this.txtLength = trgt.myTxt.length+this.startTxt.length;
		this.txtOutLength = trgt.myTxtOut.length+this.startTxt.length;
		trgt.left.onPress();
		myPlay(trgt)
	}
	function myPlay(trgt) {
		if (trgt.myTxt.length>0) {
			trgt.txtInt = setInterval(this, "leggi", trgt._parent.mySequencer.msVal, trgt);
		}
	}
	function myStop(trgt) {
		clearInterval(trgt.txtInt);
	}
	function myRewind(trgt) {
		this.n = 0;
	}
	function leggi(trgt) {
		this.myTxt = this.startTxt+trgt.myTxt+" "+trgt.myTxt+" "+trgt.myTxt;
		this.myTxtOut = this.startTxt+trgt.myTxtOut+" "+trgt.myTxtOut+" "+trgt.myTxtOut;
		trgt.lettore(this.myTxt.substring(this.n, this.n+20), this.myTxtOut.substring(this.nOut, this.nOut+20), this.myTxt.substring(this.startTxtLength, this.startTxtLength+20));
		if (this.n>this.txtLength-2) {
			this.n = this.startTxtLength;
		} else {
			this.n++;
		}
		if (this.nOut>this.txtOutLength-2) {
			this.nOut = this.startTxtLength;
		} else {
			this.nOut++;
		}
	}
}
