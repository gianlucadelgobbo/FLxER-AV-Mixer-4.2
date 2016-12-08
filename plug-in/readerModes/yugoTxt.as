class yugoTxt extends MovieClip {
	var interval:Number;
	var trgt:MovieClip;
	var titArray:Array;
	var titArrayOut:Array;
	var waitChar:String;
	var charSpeed:Number;
	var moveFix:Number;
	var moveRange:Number;
	var moveTrigger:Number;
	/////////
	var str:String;
	var strOut:String;
	var randomList:Array;
	var textCount:Number;
	var fixLength:Number;
	var fixStr:String;
	var a:Number;
	/////
	var cMin:Number;
	var cMax:Number;
	var n_word:Number;
	var n_wordOut:Number;
	var listener:Array;
	var c:Number;
	/////
	var randomTypo;
	var end_textCount;
	var end_charMotion;
	var typoText;
	var previous_instance;
	function yugoTxt() {
		interval = 2000;
		//trgt = typoText;
		//titArray = _global.titles;
		waitChar = "-";
		moveFix = 10;
		moveRange = 15;
		moveTrigger = 12;
		charSpeed = 2;
		///////
		cMin = 33;
		cMax = 96;
		listener = [];
		var myTxt:String;
		var myTxtOut:String;
	}
	function starter(trgt) {
		n_word = 0;
		myPlay(trgt);
	}
	function myPlay(trgt) {
		clearInterval(c);
		if (trgt.myTxt.length>0) {
			waitChar = "-";
			moveFix = 10;
			moveRange = 15;
			moveTrigger = 12;
			charSpeed = 2;
			//trgt.txtInt = setInterval(this, "setText", interval, trgt, waitChar, charSpeed, moveFix, moveRange, moveTrigger);
			setText(trgt, waitChar, charSpeed, moveFix, moveRange, moveTrigger);
		}
	}
	function myStop(trgt) {
		clearInterval(trgt.txtInt);
	}
	function myRewind(trgt) {
		n_word = 0;
		n_wordOut = 0;
	}
	function setText(trgt, waitChar, charSpeed, moveFix, moveRange, moveTrigger) {
		titArray = trgt.myTxt.split(" ");
		titArrayOut = trgt.myTxtOut.split(" ");
		str = titArray[n_word].toUpperCase();
		strOut = titArrayOut[n_wordOut].toUpperCase();
		if (str != undefined) {
			randomList = [];
			textCount = 0;
			fixLength = 0;
			fixStr = "";
			for (a=0; a<=str.length-1; a++) {
				if (str.charAt(a) != " ") {
					randomList[a] = (moveFix+Math.round(Math.random()*moveRange))*(Math.round(Math.random())-0.500000)*2;
				} else {
					randomList[a] = 0;
				}
			}
			trgt.txtInt = setInterval(this, "randomMotion", trgt._parent.mySequencer.msVal/10, trgt);
			//trgt.onEnterFrame = this.randomMotion;
		}
		n_word++;
		n_wordOut++;
		if (n_word>=titArray.length) {
			n_word = 0;
		}
		if (n_wordOut>=titArrayOut.length) {
			n_wordOut = 0;
		}
	}
	function randomMotion(trgt) {
		trgt.lettore(fixStr, fixStr, fixStr);
		var tmp = fixStr;
		//this.text = fixStr;
		end_charMotion = true;
		for (a=fixLength; a<=textCount; a++) {
			if (randomList[a] != 0 && randomList[a] != undefined) {
				end_charMotion = false;
				if (Math.abs(randomList[a])<=moveTrigger) {
					var charcode = Math.min(Math.max(str.charCodeAt(a)+randomList[a], cMin), cMax);
					tmp = tmp+String.fromCharCode(charcode);
					trgt.lettore(tmp, tmp, fixStr);
					//this.text = this.text+String.fromCharCode(charcode);
				} else {
					tmp = tmp+waitChar;
					trgt.lettore(tmp, tmp, fixStr);
					//this.text = this.text+waitChar;
				}
				if (randomList[a]>0) {
					randomList[a] = randomList[a]-1;
				} else {
					randomList[a] = randomList[a]+1;
				}
			} else {
				if (fixLength == a-1) {
					fixLength = a;
					fixStr = str.substring(0, fixLength);
				}
				tmp = tmp+str.charAt(a);
				trgt.lettore(tmp, tmp, fixStr);
				//this.text = this.text+str.charAt(a);
			}
		}
		if (textCount<=str.length) {
			textCount = textCount+charSpeed;
		} else {
			end_textCount = true;
		}
		if (end_charMotion && end_textCount) {
			stopAction(trgt);
		}
	}
	function stopAction(trgt) {
		clearInterval(trgt.txtInt);
		c = setInterval(this, "myPlay", trgt._parent.mySequencer.msVal, trgt);
		// delete trgt.onEnterFrame;
		delete randomList;
		delete textCount;
		delete end_textCount;
		delete end_charMotion;
		delete fixStr;
		delete fixLength;
		delete str;
	}
}
