
/*
 * Need to clean up and organize javascript code.
 *
 */

window.addEventListener('load', onLoad);

// Global Variables

// Clear canvas: ctx.clearRect(0,0,canvasElem.width,canvasElem.height)
var leftPad = 10;
var topPad = 10;
var pixelWidth = 10;
var maxSize = 50;
var divUpCanvas = new Array(5);
var imageWidth = 0;
var imageHeight = 0;

let canvasElem = document.getElementById("pixelCanvas");
const ctx = canvasElem.getContext('2d');

document.getElementById('txtboxWidth').value = 0;
document.getElementById('txtboxHeight').value = 0;

class pixel {
  constructor(id, xStart, yStart, color) {
    this.id = id;
	this.xStart = xStart;
    this.yStart = yStart;
	this.color = color;
  }
}

function getMousePosition(canvas, event) {
	let rect = canvas.getBoundingClientRect();
	let x = event.clientX - rect.left;
	let y = event.clientY - rect.top;
	document.getElementById('xpos').innerHTML = x;
	document.getElementById('ypos').innerHTML = y.toFixed(2);
	theColor = document.getElementById('selColor').value;
	
	document.getElementById('inSquare').innerHTML = 'None';
	
	for(let i = 0; i < divUpCanvas.length; i++){
		let x1 = divUpCanvas[i].xStart;
		let x2 = divUpCanvas[i].xStart + pixelWidth;
		let y1 = divUpCanvas[i].yStart;
		let y2 = divUpCanvas[i].yStart + pixelWidth;
		if(((x>=x1) & (x<x2)) & ((y>=y1) & (y<y2))){
			document.getElementById('inSquare').innerHTML = divUpCanvas[i].id;
			ctx.fillStyle = theColor; // Change with color input.
			ctx.fillRect(divUpCanvas[i].xStart, divUpCanvas[i].yStart, pixelWidth, pixelWidth);
			divUpCanvas[i].color = theColor;
		}
	}
	
	// Debug code to check rgb888 to rgb565 conversion.
	let rgb888 = parseInt(theColor.slice(1),16);
	let rgb555 = ((rgb888 & 0xf80000) >> 8) | ((rgb888 & 0xf800) >> 6) | ((rgb888 & 0xf8) >> 3);
	rgb555 = rgb555 & 0x007FFF;
	console.log(rgb555.toString(16));
}

/*
 * btnUpdateSize()
 *
 * Runs when user wants to update canvas size.
 *
 */
function btnUpdateSize(){
	
	// Get width and height from text box.
	imageWidth = document.getElementById('txtboxWidth').value;
	imageHeight = document.getElementById('txtboxHeight').value;
	if(imageWidth > maxSize){
		imageWidth = maxSize;
		document.getElementById('txtboxWidth').value = maxSize;
	}
	if(imageHeight > maxSize){
		imageHeight = maxSize;
		document.getElementById('txtboxHeight').value = maxSize;
	}
	
	// Clear out old image.
	ctx.clearRect(0,0,canvasElem.width,canvasElem.height);
	
	divUpCanvas.length = 0;	// Reset divUpCanvas length.
	
	// Set up pixel dimensions.
	// Set row to start at the center minus imageWidth*pixeWidth/2.
	leftOffset = canvasElem.width/2 - (imageWidth*pixelWidth)/2;
	topOffset = canvasElem.height/2 - (imageHeight*pixelWidth)/2;
	for(let i = 0; i < imageHeight; i++){
		for(let j = 0; j < imageWidth; j++){
			let temp = new pixel(1+i*imageWidth+j,(j*pixelWidth + leftOffset),(i*pixelWidth + topOffset),'#000000');
			divUpCanvas.push(temp);
		}
	}
	
	
	var colorFlag = true;
	for(let i = 0; i < divUpCanvas.length; i++){
		/*if(colorFlag){
			ctx.fillStyle = '#F9DC5C';
			colorFlag = false;
		}
		else{
			ctx.fillStyle = '#FF556C';
			colorFlag = true;
		}*/
		ctx.fillStyle = '#000000';
		ctx.fillRect(divUpCanvas[i].xStart, divUpCanvas[i].yStart, pixelWidth, pixelWidth);
	}
	
	// Draw bright green border.
	ctx.fillStyle = '#65FE08';
	// Left side.
	ctx.fillRect(leftOffset-4,topOffset-4,4,imageHeight*pixelWidth+8);
	// Right side.
	ctx.fillRect(leftOffset+imageWidth*pixelWidth,topOffset-4,4,imageHeight*pixelWidth+8);
	// Top side.
	ctx.fillRect(leftOffset-4,topOffset-4,imageWidth*pixelWidth+8,4);
	// Bottom side.
	ctx.fillRect(leftOffset-4,topOffset+imageHeight*pixelWidth,imageWidth*pixelWidth+8,4);
}

canvasElem.addEventListener("mousedown", function(e)
{
	getMousePosition(canvasElem, e);
});
		
/*
 * When page loads.
 *
 */
function onLoad(event) {
	btnUpdateSize();
}


/*
 *
 *
 */
function btnGenerateCode(){
	
	// Append to one string to send to scrollable textbox.
	
	let ignColor = document.getElementById('ignColor').value;
	let codeStr = "<br>; LC-3 Image Generator<br><br>";
	
	codeStr = codeStr + "; Change to desired start location.<br>";
	codeStr = codeStr + ".ORIG x5000<br><br>";
	
	codeStr = codeStr + "; Width = " + imageWidth + ", Height = " + imageHeight + "<br><br>";
	
	codeStr = codeStr + "; Using lc3ig prefix to ensure unique labels.<br>";
	
	for(let i = 0; i < divUpCanvas.length; i++){
		
		let rowStr = (parseInt(i/imageWidth)).toString();
		let colStr = (i%imageWidth).toString();
		let rgb888 = parseInt(divUpCanvas[i].color.slice(1),16);
		let rgb555 = ((rgb888 & 0xf80000) >> 8) | ((rgb888 & 0xf800) >> 6) | ((rgb888 & 0xf8) >> 3);
		if(divUpCanvas[i].color == ignColor){
			rgb555 = rgb555 & 0x007FFF;
		}
		else{
			rgb555 = rgb555 & 0x007FFF;
			rgb555 = rgb555 | 0x008000;
		}
		let colorStr = "x" + rgb555.toString(16);
		codeStr = codeStr + "lc3ig" + "ROW" + rowStr + "COL" + colStr + " .FILL " + colorStr + "<br>";
	}	
	
	codeStr = codeStr + "<br>.END";
	
	document.getElementById('txtboxCode').innerHTML = codeStr;
}