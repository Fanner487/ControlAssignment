ArrayList<Year> years = new ArrayList<Year>();
int which = 0;
float centX, centY;
float highest, border;
String[] company;
color[] companyColour; 
boolean lineG = false;
boolean scatG = false;
boolean coxG = false;
boolean doughG = false;
int bX;
int bY;
int bWidth;
int bHeight;

import controlP5.*;
ControlP5 controlP5;
controlP5.Button line;
controlP5.Button scatter;
controlP5.Button coxComb;
controlP5.Button doughnut;
controlP5.Button back;

PImage googleImg;
PImage appleImg;
PImage microsoftImg;

PFont font;

void setup()
{
  size(1366, 700);
  font = loadFont("BritannicBold-15.vlw");
  textFont(font);
  background(0);
  smooth();

  controlP5 = new ControlP5(this);
  
  loadData();
  displayFigures();

//  googleImg = loadImage();
//  appleImg = loadImage();
//  microsoftImg = loadImage();

  company = new String[3];
  company[0] = "Google";
  company[1] = "Apple";
  company[2] = "Microsoft";

  companyColour = new color[3];
  companyColour[0] = color(0, 0, 255);
  companyColour[1] = color(255);
  companyColour[2] = color(255, 0, 0);

  border = width * 0.05f;
  centX = height * 0.5f;
  centY = height * 0.5f;
  bX = width / 2;
  bY = height / 2;
  bWidth = 150;
  bHeight = 50;
  
  //creating buttons
  line = controlP5.addButton("lineGraph",1, bX,bY-100,bWidth, bHeight);
  scatter = controlP5.addButton("scatterGraph",1,bX,bY-50,bWidth, bHeight);
  coxComb = controlP5.addButton("coxComb",1,bX,bY,bWidth, bHeight);
  doughnut = controlP5.addButton("doughnutCharts",1,bX,bY+50,bWidth, bHeight);
  back = controlP5.addButton("back",1,width - 150, height - 50 ,bWidth, bHeight);
  back.hide();
   
  
}

void draw()
{ 
  
  if (lineG == true) {
    background(0);
    int x = mouseX;
    drawAxis(years.size(), 10, maximum(company[0]), border);
    for(int i = 0; i < company.length; i++)
    {
      drawTrendGraph(company[i], border, maximum(company[0]));
    }
    
    redLine(x);
    drawCircle(x);
  }
  
  if(scatG == true){
    background(0);
    drawAxis(years.size(), 10, maximum(company[0]), border);
    //change this using a for loop
    scatterGraph();
  }

  if(coxG == true){
    background(0);
    pushMatrix();
    translate(width * 0.25f, 0);
    drawTotalPieChart();
    popMatrix();
  }
  
  if(doughG == true){
    background(0);
    pushMatrix();
    translate(-(width * 0.05f), -(width * 0.1f));
    drawPieChart(company[0]);
    popMatrix();

    pushMatrix();
    translate(width * 0.25f, height * 0.2f);
    drawPieChart(company[0]);
    popMatrix();

    pushMatrix();
    translate(width * 0.55f, -(width * 0.1f));
    drawPieChart(company[0]);
    popMatrix();
  }
  
}//end draw


void controlEvent(ControlEvent theEvent)
{

  if (theEvent.controller().getName().equals("lineGraph")) {
    back.show();
    line.hide();
    scatter.hide();
    coxComb.hide();
    doughnut.hide();
    lineG = true;
    scatG = false;
    doughG = false;
    coxG = false;
    

  }

  if (theEvent.controller().getName().equals("scatterGraph")) {
    back.show();
    line.hide();
    scatter.hide();
    coxComb.hide();
    doughnut.hide();
    
    lineG = false;
    scatG = true;
    doughG = false;
    coxG = false;
    
  }

  if (theEvent.controller().getName().equals("doughnutCharts")) {       
    back.show();
    line.hide();
    scatter.hide();
    coxComb.hide();
    doughnut.hide();
    
    lineG = false;
    scatG = false;
    doughG = true;
    coxG = false;
    
  }

  if (theEvent.controller().getName().equals("coxComb")) {
  
    back.show();
    line.hide();
    scatter.hide();
    coxComb.hide();
    doughnut.hide();
    
    lineG = false;
    scatG = false;
    doughG = false;
    coxG = true;

  }
  
  if (theEvent.controller().getName().equals("back")) {
    background(0);
    lineG = false;
    scatG = false;
    doughG = false;
    coxG = false;
    back.hide();
    line.show();
    scatter.show();
    coxComb.show();
    doughnut.show();
  }

}

void scatterGraph()
{

  stroke(0, 0, 255);
  fill(0, 0, 255);

  for (int i = 0; i < years.size (); i ++)
  {
    Year value = years.get(i);
    float size = 100;
    float sizeGoogle = map(value.google, 0, maxValueOfThree(), 0, size);
    float sizeApple = map(value.apple, 0, maxValueOfThree(), 0, size);
    ;
    float sizeMicrosoft = map(value.microsoft, 0, maxValueOfThree(), 0, size);
    ;

    stroke(companyColour[0]);
    fill(companyColour[0]);
    float x = map(i, 0, years.size(), border, width - border);
    float y = map(value.google, 0, maximum(company[0]), height - border, border);

    ellipse((float)x, y, sizeGoogle, sizeGoogle);

    x = map(i, 0, years.size(), border, width - border);
    y = map(value.apple, 0, maximum(company[0]), height - border, border);

    stroke(companyColour[1]);
    fill(companyColour[1]);
    ellipse((float)x, y, sizeApple, sizeApple);

    x = map(i, 0, years.size(), border, width - border);
    y = map(value.microsoft, 0, maximum(company[0]), height - border, border);

    stroke(companyColour[2]);
    fill(companyColour[2]);
    ellipse((float)x, y, sizeMicrosoft, sizeMicrosoft);
  }
}

void drawBarChart()
{
  float horizontalWindowSize = width - (border / 3);
  //float verticalWindowSize = height - (border / 2);
  float sizeInterval = horizontalWindowSize / (float)years.size();
  float sizeEachBar = sizeInterval / 3;

  for (int i = 0; i < years.size (); i++)
  {
    Year value = years.get(i);
    fill(255);
    float x = border + (sizeInterval * i);
    float y = x;
    float barWidth = sizeEachBar;
    float barHeight = map(value.google, 0, maximum(company[0]), height - border, border);
    rect((float)x, y, barWidth, barHeight);
  }
}

void redLine(int x)
{
  if (x > border && x < width - (border * 2)) 
  {

    line(x, border, x, height - border);
  } else if (x > width - (border * 2)) {

    line(width - (border*2), border, width - (border*2), height - border);
  } else if (x < border) {

    line(border, border, border, height - border);
  }
}

void drawCircle(int x)
{
  float textX = width - (border * 2);
  float y = border;
  //only executes if x is within borders of graph
  if (x > border && x < width - (border * 2)) {
    int num = (int)map(x, border, width - border, 0, years.size());
    float mapX = map(x, 0, years.size(), border, height - border);

    Year year = years.get(num);

    float googleY = map(year.google, 0, maxValueOfThree(), height - border, border);
    float appleY = map(year.apple, 0, maxValueOfThree(), height - border, border);
    float microsoftY = map(year.microsoft, 0, maxValueOfThree(), height - border, border);

    stroke(companyColour[0]);
    fill(companyColour[0]);
    ellipse(mapX, googleY, 10, 10);

    stroke(companyColour[1]);
    fill(companyColour[1]);
    ellipse(mapX, appleY, 10, 10);

    stroke(companyColour[2]);
    fill(companyColour[2]);
    ellipse(mapX, microsoftY, 10, 10);

    //PUT DISPLAY ON GRAPH SIDE
    //printing year and GDP amount beside red circle
    textAlign(LEFT, LEFT);
    textSize(15);


    if (x >= border && x <= width - (border * 2)) {
      fill(companyColour[0]);
      text("Google: " + year.google, textX, y);
      fill(companyColour[1]);
      text("Apple: " + year.apple, textX, y + 30);
      fill(companyColour[2]);
      text("Microsoft: " + year.microsoft, textX, y + 60);
    } else if (x < border) {      
      fill(companyColour[0]);
      text("Google: " + years.get(0).google, textX, y);
      fill(companyColour[1]);
      text("Apple: " + years.get(0).apple, textX, y + 30);
      fill(companyColour[2]);
      text("Microsoft: " + years.get(0).microsoft, textX, y + 60);
    } else if (x > border - (width * 2)) {
      fill(companyColour[0]);
      text("Google: " + years.get(years.size() - 1).google, textX, y);
      fill(companyColour[1]);
      text("Apple: " + years.get(years.size() - 1).apple, textX, y + 30);
      fill(companyColour[2]);
      text("Microsoft: " + years.get(years.size() - 1).microsoft, textX, y + 60);
    }
  }
}

void drawTotalPieChart()
{
  int[] total = new int[3]; 
  float newX, newY;
  float highestTotal = 0;

  newX = width * 0.25f;
  newY = height * 0.5f;

  total[0] = sum(company[0]);
  total[1] = sum(company[1]);
  total[2] = sum(company[2]);

  for (int i = 0; i < total.length; i ++)
  {
    if (total[i] > highestTotal) {
      highestTotal = total[i];
    }
  }


  float sum = sum(company[0]) + sum(company[1]) + sum(company[2]);
  float thetaPrev = 0;
  float totalThree = total[0] + total[1] + total[2];

  for (int i = 0; i < total.length; i ++)
  {

    float mapX = map(total[i], 0, highestTotal, 0, centX);
    float mapY = map(total[i], 0, highestTotal, 0, centY);
    //Year year = years.get(i); 
    fill(companyColour[i]);
    stroke(companyColour[i]);

    float theta = map(total[i], 0, sum, 0, TWO_PI);
    textAlign(CENTER);
    textSize(15);
    //float col = map(total[i], 0, max, 255, 100);
    float thetaNext = thetaPrev + theta;
    float radius = newX * 0.6f;
    //float radius = centX * 2.0f;
    float x = newX + sin(thetaPrev + (theta * 0.5f) + HALF_PI) * radius;      
    float y = newY - cos(thetaPrev + (theta * 0.5f) + HALF_PI) * radius;
    fill(255);
    textSize(11);
    text(company[i] + ": " + (int)map(total[i], 0, sum, 0, 100) + "%", x, y);             
    stroke(companyColour[i]);
    fill(companyColour[i]);               
    arc(newX, newY, mapX, mapY, thetaPrev, thetaNext);
    thetaPrev = thetaNext;
  }
}

//possibility to use a button, slider or some shit to go through the years. 

void drawPieChart(String comp)
{
  float thetaPrev = 0;
  float size = 170;
  float sum = 0;
  float max = 0;
  float theta = 0;
  float col = 0;
    if (comp.equals(company[0])) {
    sum = sum(company[0]);
    max = maximum(company[0]);
  }
  if (comp.equals(company[1])) {
    sum = sum(company[1]);
    max = maximum(company[1]);
  }  
  if (comp.equals(company[2])) {
    sum = sum(company[2]);
    max = maximum(company[2]);
  } 

  for (int i = 0; i < years.size (); i ++)
  {
    Year year = years.get(i);
    fill(year.c);
    stroke(year.c);
    if (comp.equals(company[0])) {
      theta = map(year.google, 0, sum, 0, TWO_PI);
    }
    if (comp.equals(company[1])) {
      theta = map(year.apple, 0, sum, 0, TWO_PI);
    }  
    if (comp.equals(company[2])) {
      theta = map(year.microsoft, 0, sum, 0, TWO_PI);
    }

    textAlign(CENTER);

    if (comp.equals(company[0])) {
      col = map(year.google, 0, max, 255, 100);
    }
    if (comp.equals(company[1])) {
      col = map(year.apple, 0, max, 255, 100);
    }  
    if (comp.equals(company[2])) {
      col = map(year.microsoft, 0, max, 255, 100);
    }

    float thetaNext = thetaPrev + theta;
    float radius = centX * 0.55f;
    //float radius = centX * 2.0f;
    float x = ((centX) + sin(thetaPrev + (theta * 0.5f) + HALF_PI) * radius);      
    float y = ((centY) - cos(thetaPrev + (theta * 0.5f) + HALF_PI) * radius);
    fill(255);
    textSize(12);
    if (comp.equals(company[0])) {
      text(year.y + ": " + (int)map(year.google, 0, sum(company[0]), 0, 100) + "%", x, y);
    }
    if (comp.equals(company[1])) {
      text(year.y + ": " + (int)map(year.apple, 0, sum(company[1]), 0, 100) + "%", x, y);
    }  
    if (comp.equals(company[2])) {
      text(year.y + ": " + (int)map(year.microsoft, 0, sum(company[2]), 0, 100) + "%", x, y);
    }

    stroke(0, col, col);
    fill(0, col, col);               
    arc(centX, centY, centX * 0.8, centY * 0.8f, thetaPrev, thetaNext);
    thetaPrev = thetaNext;

    stroke(255);
    fill(0);
    ellipse(centX, centY, size, size);
  }
}

void drawAxis(int horizontalIntervals, int verticalIntervals, float vertDataRange, float border)
{
  stroke(200, 200, 200);
  fill(200, 200, 200);

  int fromLast = 50;
  int offset = 5;

  // Draw the horizontal axis
  stroke(256, 0, 0);
  line(border, height - border, width - (border * 2), height - border);

  float horizontalWindowRange = (width - (border * 2.0f));
  float horizontalDataGap = years.size() / horizontalIntervals;

  float horizontalWindowGap = horizontalWindowRange / horizontalIntervals;
  float tickSize = border * 0.1f;

  float firstYear = years.get(0).y;

  // Draw the ticks
  for (int i = 0; i < horizontalIntervals; i ++)
  {

    float x = border + (i * horizontalWindowGap);
    line(x, height - (border - tickSize), x, (height - border));
    //float textY = height - (border * 0.5f);
  }

  for (int i = 0; i < horizontalIntervals; i += 2) {
    float x = border + (i * horizontalWindowGap);
    float textY = height - (border * 0.5f);
    // Print the date
    textAlign(CENTER, CENTER);
    textSize(12);
    text((int)(firstYear + i * horizontalDataGap), x, textY);
  }

  // Draw the vertical axis
  line(border, border, border, height - border);

  float verticalDataGap = vertDataRange / verticalIntervals;
  float verticalWindowRange = height - (border * 2.0f);
  float verticalWindowGap = verticalWindowRange / verticalIntervals;

  for (int i = 0; i <= verticalIntervals; i ++)
  {
    float y = (height - border) - (i * verticalWindowGap);
    line(border - tickSize, y, border, y);
    float hAxisLabel = verticalDataGap * i;

    textAlign(RIGHT, CENTER);

    text((int)hAxisLabel, border - (tickSize * 2.0f), y);
  }
}

void drawTrendGraph(String comp, float border, float maxValue) {
  float y1 = 0;
  float y2 = 0;
  for (int i = 1; i < years.size (); i ++)
  {
    stroke(0, 0, 255);
    fill(0, 0, 255);
    Year value = years.get(i);
    Year minusValue = years.get(i-1);
    float x1 = map(i-1, 0, years.size(), border, width - border);
    float x2 = map(i, 0, years.size(), border, width - border);

    if (comp.equals(company[0])) {
      stroke(companyColour[0]);
      fill(companyColour[0]);
      y1 = map(minusValue.google, 0, maxValue, height - border, border);
      y2 = map(value.google, 0, maxValue, height - border, border);
    }
    if (comp.equals(company[1])) {
      stroke(companyColour[1]);
      fill(companyColour[1]);
      y1 = map(minusValue.apple, 0, maxValue, height - border, border);
      y2 = map(value.apple, 0, maxValue, height - border, border);
    }  
    if (comp.equals(company[2])) {
      stroke(companyColour[2]);
      fill(companyColour[2]);
      y1 = map(minusValue.microsoft, 0, maxValue, height - border, border);
      y2 = map(value.microsoft, 0, maxValue, height - border, border);
    }

    line((float)x1, y1, (float)x2, y2);

  }
}

int maxValueOfThree() {

  int[] arr = new int[3];
  int max = 0;

  arr[0] = maximum(company[0]);
  arr[1] = maximum(company[1]);
  arr[2] = maximum(company[2]);

  for (int i = 0; i < arr.length; i++) {

    if (arr[i] > max) {

      max = arr[i];
    }
  }

  return max;
}

void loadData() {

  String[] lines = loadStrings("newData.txt");

  for (int i = 0; i < lines.length; i++)
  {
    Year year = new Year(lines[i]);
    years.add(year);
  }
}

void displayFigures() {

  for (int i = 0; i < years.size (); i++) {

    Year select  = years.get(i);
    select.display();
  }
}
int sum(String comp)
{
  int sum = 0;

  for (int i = 0; i < years.size (); i++) {

    Year select = years.get(i);

    if (comp.equals(company[0])) {
      sum += select.google;
    }
    if (comp.equals(company[1])) {
      sum += select.apple;
    }
    if (comp.equals(company[2])) {
      sum += select.microsoft;
    }
  }

  return sum;
}

float average(String comp) {

  int total = 0;

  if (comp.equals(company[0])) {
    total = sum(company[0]);
  }
  if (comp.equals(company[1])) {
    total = sum(company[1]);
  }
  if (comp.equals(company[2])) {
    total = sum(company[2]);
  }

  float avg = total / years.size();

  return avg;
}

int maximum(String comp) {

  int max = 0;

  for (int i = 0; i < years.size (); i++) {
    Year n = years.get(i);

    if (comp.equals(company[0])) {
      if (n.google > max) {

        max = n.google;
      }
    }
    if (comp.equals(company[1])) {
      if (n.apple > max) {

        max = n.apple;
      }
    }
    if (comp.equals(company[2])) {
      if (n.microsoft > max) {

        max = n.microsoft;
      }
    }
  }

  return max;
}
