let bandera;
let virus;
let y = 0;

function setup() {

  // The background image must be the same size as the parameters
  // into the createCanvas() method. In this program, the size of
  // the image is 720x400 pixels.
  bandera = loadImage('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRFP56NAk5I6fktk4xaToeVG9ZH2MQnYGJnKw&usqp=CAU');

  virus=loadImage('data:image/jpeg;base64,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');
  
  
  virus.resize(50,50);
  bandera.resize(284,178);
   
  canvas=createCanvas(284, 178);
  canvas.parent('sketch-div');
}

function draw() {
  background(bandera);

  let dx,dy;
  let xvirus,yvirus;
  let sxvirus,syvirus;

  dx=0;dy=0;
  xvirus=284/2-25+dx;
  yvirus=178/2-25+dy;
  sxvirus=50;
  syvirus=50;

  if(xvirus<mouseX && mouseX<xvirus+sxvirus &&
     yvirus<mouseX && mouseY<yvirus+syvirus){
    //print("hola virus");
    dx =random(-2,2);
    dy =random(-2,2);
  }

  xvirus=284/2-25+dx;
  yvirus=178/2-25+dy;
  sxvirus=50;
  syvirus=50;
  
  image(virus,xvirus,yvirus,sxvirus,syvirus);

  /*stroke(226, 204, 0);
  line(0, y, width, y);

  y++;
  if (y > height) {
    y = 0;
  }*/
}

