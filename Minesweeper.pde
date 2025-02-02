import de.bezier.guido.*;
private final int NUM_ROWS = 20;
private final int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r = 0; r < NUM_ROWS; r++){
      for (int c = 0; c < NUM_COLS; c++){
        buttons[r][c] = new MSButton(r,c);
      }
    }
    
    for(int i = 0;i < 30; i++){
      setMines();
    }
}
public void setMines()
{
    int row = (int)(Math.random() * NUM_ROWS);
    int col = (int)(Math.random() * NUM_COLS);
    if (!mines.contains(buttons[row][col])){
      mines.add(buttons[row][col]);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    for (int i  = 0; i < NUM_ROWS; i++){
      for (int j = 0; j < NUM_COLS; j++){
        if (!buttons[i][j].clicked && !mines.contains(buttons[i][j])){
          return false;
        }
      }
    }
    return true;
}
public void displayLosingMessage()
{
    buttons[8][7].setLabel("G");
    buttons[8][8].setLabel("E");
    buttons[8][9].setLabel("T");
    buttons[9][7].setLabel("G");
    buttons[9][8].setLabel("O");
    buttons[9][9].setLabel("O");
    buttons[9][10].setLabel("D");
}
public void displayWinningMessage()
{
    buttons[8][7].setLabel("W");
    buttons[9][7].setLabel("I");
    buttons[9][8].setLabel("N");
    buttons[10][7].setLabel("T");
    buttons[10][8].setLabel("H");
    buttons[10][9].setLabel("E");
    buttons[11][7].setLabel("C");
    buttons[11][8].setLabel("H");
    buttons[11][9].setLabel("A");
    buttons[11][10].setLabel("T");
}
public boolean isValid(int r, int c)
{
    //your code here
    if (r >= 0 && r  < NUM_ROWS && c >= 0 && c < NUM_COLS){
    return true;
    }
    else{ 
      return false;
    }
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
    for (int i = row - 1 ; i <= row + 1; i++){
      for (int j = col - 1; j <= col + 1; j++){
        if (isValid(i,j) && mines.contains(buttons[i][j])){
          numMines++;
        }
      }
    }
    if (mines.contains(buttons[row][col])){
      numMines--;
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if (mouseButton == RIGHT){
          if (isFlagged()){
            flagged = false;
            clicked = false;
          } 
          else {
            flagged = true;
            clicked = false;
          }
        }
        else if (mines.contains(this)){
          displayLosingMessage();
        }
        else if (countMines(myRow, myCol) > 0){
          buttons[myRow][myCol].setLabel(countMines(myRow, myCol));
        }
        else {
          for (int i = myRow - 1; i <= myRow + 1; i++){
            for (int j = myCol - 1; j <= myCol + 1; j++){
              if (isValid(i,j) && !buttons[i][j].clicked){
                buttons[i][j].mousePressed();
              }
            }
          }
        }
          
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
