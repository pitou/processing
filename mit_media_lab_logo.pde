import java.util.Random;
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;

final int numsqBlack = 3;
final int numsqColor = 3;
int[][] sqBlack;
int[][] sqColor;
final int sqBlackSide = 40;
final int sqColorSide = 90;

void setup() {
  background(255);
  size(320, 320);
  smooth();
  randEverything();
}

void randEverything() {
  //println("Quadrati NERI");
  sqBlack = randCoord(numsqBlack, 8, 1);
  
  //println("Quadrati COLORATI");
  sqColor = randCoord(numsqColor, 3, 0);
}

int[][] randCoord(int numQuadrati, int latoPiano, int distanzaMinima)
{
  List<Integer> list = new ArrayList<Integer>();
  for(int i=0; i<latoPiano * numQuadrati; i++){
    list.add(i);
  }
  
  int[][] arr = new int[numQuadrati][2];
  
  for (int j = 0; j < 2; j++) {
    Collections.shuffle(list);
    Integer[] randomArray = list.subList(0, numQuadrati).toArray(new Integer[numQuadrati]);
  
    for(int k = 0; k < randomArray.length; k++){
      int c = randomArray[k] / numQuadrati;
      arr[k][j] = c;
    }
  }
  
  for (int j = 0; j < numQuadrati; j++) {
    //println("coordinate quadrato " +j+" : "+ arr[j][0] + "x" + arr[j][1]);
    
    int[][] res = pleaseYourHighnessDontEatOtherPeople(arr, numQuadrati, j, latoPiano, distanzaMinima);
    if (res != null) {
      arr = res;
      j--; // riverifico lo stesso quadrato
    }
  }
  
  println("-----------------------------");
  
  return arr;
}

int[][] pleaseYourHighnessDontEatOtherPeople(int[][] arr, int numQuadrati, int indiceRe, int latoPiano, int distanzaMinima) {
  Random randGenerator = new Random();
  
  boolean modificato = false;
  
  for (int i = 0; i < numQuadrati; i++) {
    if (i == indiceRe) {
      continue;
    }
    
    int diff0 = abs(arr[i][0] - arr[indiceRe][0]);
    int diff1 = abs(arr[i][1] - arr[indiceRe][1]);
    
    if (diff0 <= distanzaMinima && diff1 <= distanzaMinima) {
      println ("rirandomo (diff"+i+"-"+indiceRe+" = "+arr[i][0] +"-"+arr[indiceRe][0]+", diff"+i+"-"+indiceRe+" = "+arr[i][1] +"-"+ arr[indiceRe][1]+")");
      arr[indiceRe][0] = randGenerator.nextInt(latoPiano);
      arr[indiceRe][1] = randGenerator.nextInt(latoPiano);
      println("nuove coordinate quadrato " +indiceRe+" : "+ arr[indiceRe][0] + "x" + arr[indiceRe][1]);
      
      diff0 = abs(arr[i][0] - arr[indiceRe][0]);
      diff1 = abs(arr[i][1] - arr[indiceRe][1]);
      
      modificato = true;
      break;
    }
  }
  
  if (modificato) {
    return arr;
  } else {
    return null;
  }
}

void draw()
{
  background(255);
  drawsqBlack(g, sqBlack);
  noLoop();
}

void drawsqBlack(PGraphics pg, int [][] sqBlack)
{
  noStroke();
  
  int[] palettes = { #FF0000, #FFCC00, #0000FF };
  
  Random randGenerator = new Random();
  
  for (int i = 0; i< numsqBlack; i++) {
    stroke(palettes[i]);
    fill(palettes[i]);
    
    int c_x1 = sqColor[i][0] * sqColorSide;
    int c_y1 = sqColor[i][1] * sqColorSide;
    int c_x2 = sqColor[i][0] * sqColorSide + sqColorSide;
    int c_y2 = sqColor[i][1] * sqColorSide + sqColorSide;
  
    int b_x1 = sqBlack[i][0] * sqBlackSide;
    int b_y1 = sqBlack[i][1] * sqBlackSide;
    int b_x2 = sqBlack[i][0] * sqBlackSide + sqBlackSide;
    int b_y2 = sqBlack[i][1] * sqBlackSide + sqBlackSide;
    
    // verifico che il nero non sia racchiuso nel colorato o che non sia in corrispondenza
    if ((c_y1 <= b_y1 && b_y2 <= c_y2) || (c_x1 <= b_x1 && b_x2 <= c_x2)
     || (c_x1 <= b_x2 && b_x2 <= c_x2) || (c_y1 <= b_y2 && b_y2 <= c_y2)
     || (c_x1 <= b_x1 && b_x1 <= c_x2 && c_x2 <= b_x2 && 
           ((c_y1 <= b_y1 && b_y1 <= c_y2 && c_y2 <= b_y2) || (b_y1 <= c_y1 && c_y1 <= b_y2 && b_y2 <= c_y2)))
     )
    {
      println(i + "   RIQUADRIFIFAFEWFWEFWEFWFWE");
      
      sqBlack[i][0] = randGenerator.nextInt(8);
      sqBlack[i][1] = randGenerator.nextInt(8);
      
      for (int j = 0; j < numsqBlack; j++) {
        // rirandomizzo la posizione del quadrato nero perché ha più possibilità 
        // di trovare spazi liberi secondo le regole del Re-che-non-mangia
        int[][] res = pleaseYourHighnessDontEatOtherPeople(sqBlack, 3, i, 8, 1);
        
        if (res != null) {
          println(i + "   new res");
          sqBlack = res;
          j--; // riverifico lo stesso quadrato
        }
      }
      
      
      i--; // riverifico lo stesso quadrato
    }
    else {
      // CASO A
      // colorato/nero in basso a sinistra rispetto a nero/colorato 
      if ((b_x2 < c_x1 && c_y2 < b_y1) || (c_x2 < b_x1 && b_y2 < c_y1)
       || (b_y2 < c_y1 && c_x1 < b_x1 && b_x1 < c_x2 && c_x2 < b_x2)
       || (b_x2 < c_x1 && c_y1 < b_y1 && b_y1 < c_y2 && c_y2 < b_y2)
       || (c_y2 < b_y1 && b_x1 < c_x1 && c_x1 < b_x2 && b_x2 < c_x2)
       || (c_x2 < b_x1 && b_y1 < c_y1 && c_y1 < b_y2 && b_y2 < c_y2)
      )  {
        beginShape();
        vertex(c_x2, c_y2);
        if (b_x1 > c_x1) {
          vertex(c_x1, c_y2);
        }
        else {
          vertex(c_x2, c_y1);
        }
        vertex(c_x1, c_y1);
        vertex(b_x1, b_y1);
        vertex(b_x2, b_y2);
        endShape(CLOSE);
      }
      // CASO B
      // colorato/nero in basso a destra rispetto a nero/colorato
      else 
      if ((b_x2 < c_x1 && b_y2 < c_y1) || (c_x2 < b_x1 && c_y2 < b_y1)
       || (c_x2 < b_x1 && c_y1 < b_y1 && b_y1 < c_y2 && c_y2 < b_y2)  // CASO B1
       || (c_y2 < b_y1 && c_x1 < b_x1 && b_x1 < c_x2 && c_x2 < b_x2)  // CASO B2
       || (b_y2 < c_y1 && b_x1 < c_x1 && c_x1 < b_x2 && b_x2 < c_x2)  // CASO B3
       || (b_x2 < c_x1 && b_y1 < c_y1 && c_y1 < b_y2 && b_y2 < c_y2)  // CASO B4
      )
      {
        beginShape();
        vertex(c_x2, c_y1);
        if (b_x1 > c_x1) {
          vertex(c_x1, c_y1);
        }
        else {
          vertex(c_x2, c_y2);
        }
        vertex(c_x1, c_y2);
        vertex(b_x1, b_y2);
        vertex(b_x2, b_y1);
        endShape(CLOSE);
      }
    }    
  }
  
  noStroke();
  fill(0);
  for(int i=0; i<sqBlack.length; i++){
    rect(sqBlack[i][0]*sqBlackSide, sqBlack[i][1]*sqBlackSide, sqBlackSide, sqBlackSide);
  }
}

void mousePressed(){
  background(255);
  randEverything();
  loop();
}
