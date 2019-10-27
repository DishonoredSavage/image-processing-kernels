PImage img;
float[][] identity = 
{
 {0, 0, 0},
 {0, 1, 0},
 {0, 0, 0}
};
float[][] edgeDetection = 
{
 {-1, -1, -1},
 {-1,  8, -1},
 {-1, -1, -1}
};
float[][] sharpen = 
{
 { 0, -1,  0},
 {-1,  5, -1},
 { 0, -1,  0}
};
float[][] gaussianBlur = 
{
 {(float)1/16, (float)2/16, (float)1/16},
 {(float)2/16, (float)4/16, (float)2/16},
 {(float)1/16, (float)2/16, (float)1/16}
};
float[][] gx = 
{
 {-1, 0,  1},
 {-2, 0,  2},
 {-1, 0,  1}
};
float[][] gy = 
{
 {-1, -2, -1},
 { 0,  0,  0},
 { 1,  2,  1}
};

float[] updtVals;
int sobelCount = 0;

void setup() {
  size(932,933);
  img = loadImage("tiger.jpg");
  loadPixels();   
  img.loadPixels(); 
  updtVals = new float[img.pixels.length];
  updatePixels();
  //// interesting output (comment out sobel operator application)
  //applyOneChannel(edgeDetection, true);
  //applyOneChannel(sharpen, false);
  // sobel operator application
  makeGrayscale();
  applyOneChannel(gaussianBlur, true);
  applyOneChannel(gx, false);
  applyOneChannel(gy, false);
}

void draw() {
}

void makeGrayscale() {
  loadPixels();   
  img.loadPixels(); 
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++ ) {  
      int loc = x + y*img.width;
      float r = red   (img.pixels[loc]);
      float g = green (img.pixels[loc]);
      float b = blue  (img.pixels[loc]);   
      float c = (r + g + b)/3;
      c = constrain(c,0,255);
      img.pixels[loc] = color(c);
      pixels[loc] = color(c);
    }
  }
  updatePixels();
}

void applyThreeChannels(float[][] kernel, boolean saveToImage) {
  loadPixels();   
  img.loadPixels(); 
  for (int xLp = 0; xLp < img.width; xLp++) {
    int x = xLp;
    if (x == 0) 
      x = img.width;
    for (int yLp = 0; yLp < img.height; yLp++ ) {
      int y = yLp;
      if (y == 0)
        y = img.height;
        
      int loc00 = (x-1)%img.width + ((y-1)%img.height)*img.width;
      float r00 = red   (img.pixels[loc00]);
      float g00 = green (img.pixels[loc00]);
      float b00 = blue  (img.pixels[loc00]);
      
      int loc01 = (x)%img.width + ((y-1)%img.height)*img.width;
      float r01 = red   (img.pixels[loc01]);
      float g01 = green (img.pixels[loc01]);
      float b01 = blue  (img.pixels[loc01]);
      
      int loc02 = (x+1)%img.width + ((y-1)%img.height)*img.width;
      float r02 = red   (img.pixels[loc02]);
      float g02 = green (img.pixels[loc02]);
      float b02 = blue  (img.pixels[loc02]);      
      
      int loc10 = (x-1)%img.width + ((y)%img.height)*img.width;
      float r10 = red   (img.pixels[loc10]);
      float g10 = green (img.pixels[loc10]);
      float b10 = blue  (img.pixels[loc10]);
      
      int loc11 = (x)%img.width + ((y)%img.height)*img.width;
      float r11 = red   (img.pixels[loc11]);
      float g11 = green (img.pixels[loc11]);
      float b11 = blue  (img.pixels[loc11]);
      
      int loc12 = (x+1)%img.width + ((y)%img.height)*img.width;
      float r12 = red   (img.pixels[loc12]);
      float g12 = green (img.pixels[loc12]);
      float b12 = blue  (img.pixels[loc12]);
      
      int loc20 = (x-1)%img.width + ((y+1)%img.height)*img.width;
      float r20 = red   (img.pixels[loc20]);
      float g20 = green (img.pixels[loc20]);
      float b20 = blue  (img.pixels[loc20]);
      
      int loc21 = (x)%img.width + ((y+1)%img.height)*img.width;
      float r21 = red   (img.pixels[loc21]);
      float g21 = green (img.pixels[loc21]);
      float b21 = blue  (img.pixels[loc21]);
      
      int loc22 = (x+1)%img.width + ((y+1)%img.height)*img.width;
      float r22 = red   (img.pixels[loc22]);
      float g22 = green (img.pixels[loc22]);
      float b22 = blue  (img.pixels[loc22]);
      
      float r = kernel[0][0] * r00 + kernel[0][1] * r01 + kernel[0][2] * r02 +
                kernel[1][0] * r10 + kernel[1][1] * r11 + kernel[1][2] * r12 +
                kernel[2][0] * r20 + kernel[2][1] * r21 + kernel[2][2] * r22;
      
      float g = kernel[0][0] * g00 + kernel[0][1] * g01 + kernel[0][2] * g02 +
                kernel[1][0] * g10 + kernel[1][1] * g11 + kernel[1][2] * g12 +
                kernel[2][0] * g20 + kernel[2][1] * g21 + kernel[2][2] * g22;
      
      float b = kernel[0][0] * b00 + kernel[0][1] * b01 + kernel[0][2] * b02 +
                kernel[1][0] * b10 + kernel[1][1] * b11 + kernel[1][2] * b12 +
                kernel[2][0] * b20 + kernel[2][1] * b21 + kernel[2][2] * b22;
      
      float sum = r + g + b;
      sum = constrain(sum,0,255);
      if (sobelCount > 0)
        updtVals[loc11] = sqrt(pow(sum, 2) + pow(updtVals[loc11], 2));
      updtVals[loc11] = sum;
    }
  }
  for (int i = 0; i < pixels.length; i++) {
    if (saveToImage)
      img.pixels[i] = color(updtVals[i]);
    pixels[i] = color(updtVals[i]);
  }
  updatePixels();
  if (kernel == gx) 
    sobelCount++;
}

void applyOneChannel(float[][] kernel, boolean saveToImage) {
  loadPixels();   
  img.loadPixels(); 
  for (int xLp = 0; xLp < img.width; xLp++) {
    int x = xLp;
    if (x == 0) 
      x = img.width;
    for (int yLp = 0; yLp < img.height; yLp++ ) {
      int y = yLp;
      if (y == 0)
        y = img.height;
      int loc00 = (x-1)%img.width + ((y-1)%img.height)*img.width;
      float h00 = brightness(img.pixels[loc00]);
      
      int loc01 = (x)%img.width + ((y-1)%img.height)*img.width;
      float h01 = brightness(img.pixels[loc01]);
      
      int loc02 = (x+1)%img.width + ((y-1)%img.height)*img.width;
      float h02 = brightness(img.pixels[loc02]);     
      
      int loc10 = (x-1)%img.width + ((y)%img.height)*img.width;
      float h10 = brightness(img.pixels[loc10]);
      
      int loc11 = (x)%img.width + ((y)%img.height)*img.width;
      float h11 = brightness(img.pixels[loc11]);
      
      int loc12 = (x+1)%img.width + ((y)%img.height)*img.width;
      float h12 = brightness(img.pixels[loc12]);
      
      int loc20 = (x-1)%img.width + ((y+1)%img.height)*img.width;
      float h20 = brightness(img.pixels[loc20]);
      
      int loc21 = (x)%img.width + ((y+1)%img.height)*img.width;
      float h21 = brightness(img.pixels[loc21]);
      
      int loc22 = (x+1)%img.width + ((y+1)%img.height)*img.width;
      float h22 = brightness(img.pixels[loc22]);
      
      float h = kernel[0][0] * h00 + kernel[0][1] * h01 + kernel[0][2] * h02 +
                kernel[1][0] * h10 + kernel[1][1] * h11 + kernel[1][2] * h12 +
                kernel[2][0] * h20 + kernel[2][1] * h21 + kernel[2][2] * h22;
      
      h = constrain(h,0,255);
      if (sobelCount > 0) {
        updtVals[loc11] = sqrt(pow(h, 2) + pow(updtVals[loc11], 2));
      }
      updtVals[loc11] = h;
    }
  }
  for (int i = 0; i < pixels.length; i++) {
    if (saveToImage)
      img.pixels[i] = color(updtVals[i]);
    pixels[i] = color(updtVals[i]);
  }
  updatePixels();
  if (kernel == gx) 
    sobelCount++;
}
