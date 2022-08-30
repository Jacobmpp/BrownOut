class Action{
  public String type;
  public PVector location;
  public boolean[][] goal;
  public Action(String what, PVector where){
    type = what;
    location = where;
  }
  public Action(String what){
    type = what;
  }
  public Action(String what, boolean[][] notACopy){
    type = what;
    if(notACopy.length<1)return;
    goal = new boolean[notACopy.length][notACopy[0].length];
    for(int i = 0; i < notACopy.length; i++){
      for(int j = 0; j < notACopy[0].length; j++){
        goal[i][j] = notACopy[i][j];
      }
    }
  }
}
