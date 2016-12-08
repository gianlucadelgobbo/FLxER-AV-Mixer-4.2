class W_by_W {
	var n:Number;
	var nOut:Number;
	var myTxt:Array
	var myTxtOut:Array
	function W_by_W() {
	}
	function starter(trgt) {
		this.n = 0;
		this.nOut = 0;
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
		trace("leggi")
		this.myTxt = trgt.myTxt.split(" ");
		this.myTxtOut = trgt.myTxtOut.split(" ");
		trgt.lettore(this.myTxt[this.n], this.myTxtOut[this.nOut], this.myTxt[0])
		if (this.n>this.myTxt.length-2) {
			this.n = 0;
		} else {
			this.n++;
		}
		if (this.nOut>this.myTxtOut.length-2) {
			this.nOut = 0;
		} else {
			this.nOut++;
		}
	}
}
