class Toast {
  private int age = 0;
  private int duration;
  private int fade = 0;
  private String message;
  private float x;
  private float y;
  private color c;
  private float size;
  private float xVel;
  private float yVel;
  private float xAcc;
  private float yAcc;
  public Toast(String text, float x_, float y_, int duration_, float size_, int fade_, color c_, 
                  float xVelocity, float yVelocity, float xAcceleration, float yAcceleration){
    message = text;
    x=x_;
    y=y_;
    duration = duration_;
    fade = fade_;
    c = c_;
    size = size_;
    xVel = xVelocity;
    yVel = yVelocity;
    xAcc = xAcceleration;
    yAcc = yAcceleration;
  }
  public void show(){
    textSize(size);
    fill(c, constrain(map(age, duration-fade, duration, 255, 0), 0, 255));
    textAlign(CENTER);
    text(message, x, y);
    age++;
    xVel+=xAcc;
    yVel+=yAcc;
    x+=xVel;
    y+=yVel;
  }
  public boolean dead(){
    return age > duration;
  }
}
