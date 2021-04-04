import java.util.Map;
import java.util.Iterator;

class GUI {
  boolean pressed = false;
  boolean released = false;
  boolean keyboard = false;
  HashMap groups = new HashMap();
  HashMap values = new HashMap();
  HashMap defined = new HashMap();
  int[] bounds = new int[100];
  int count;
  int activeId;
  int hoverId;
  int mouseX;
  int mouseY;

  int normalColor = 255;
  int hoverColor = 204;
  int activeColor = 156;
  int textColor = 0;
  int strokeColor = 0;
  int widthDefault = 100;
  int heightDefault = 30;
  int mOver = -1;

  void register(int id, int x, int y, int w, int h) {
    bounds[count*5] = id;
    bounds[count*5+1] = x; bounds[count*5+2] = y;
    bounds[count*5+3] = w; bounds[count*5+4] = h;
    defined.put(id,count);
    count++;
  }
  
  void begin() {
    activeId = -1;
    hoverId = -1;
    for (int i=0; i<count; i++)
      if ((bounds[i*5+1] < mouseX) && (mouseX < bounds[i*5+1]+bounds[i*5+3]) && 
        (bounds[i*5+2] < mouseY) && (mouseY <bounds[i*5+2]+bounds[i*5+4]))
        if (pressed)
          activeId = bounds[i*5];
        else
          hoverId = bounds[i*5];
  }
  
  void end() {
    pressed = false;
    released = false;
    keyboard = false;
  }
}

// Label - OK
// Button - OK 
// CheckBox - OK
// RadioButton - OK
// ListBox - OK
// Toolbar - OK
// Slider
// Spinner
// DropDownList
// Menu
// MenuBar
// ComboBox
// Icon
// Tab
// Scrollbar
// TextBox
// Tooltip
// Windows
// DialogBox
// Frame

GUI ui = new GUI();

boolean mouseOver(int x,int y,int w,int h) {
  return ((x < mouseX) && (mouseX < x+w) && 
    (y < mouseY) && (mouseY <y+h));
}

void _Label(String l, int x, int y, int w, int h) {
  fill(ui.textColor); 
  textAlign(CENTER,CENTER);
  text(l,x+w/2,y+h/2);
}

void Label(String l, int x, int y) {
  _Label(l,x,y,ui.widthDefault,ui.heightDefault);
}

boolean _Box(int x, int y, int w, int h, boolean t, boolean c, int g) {
  int id = x+y*1000;
  if ((g!=0)&&(ui.groups.get(id)==null))
    ui.groups.put(id,g);
  if (ui.defined.get(id)==null)
    ui.register(id,x,y,w,h);
  
  boolean checked = (ui.values.get(id)==null)?c:(boolean)ui.values.get(id);
  int fillColor = (id==ui.activeId||checked)?ui.activeColor:
                     (id==ui.hoverId)?ui.hoverColor:ui.normalColor;
  stroke(ui.strokeColor); 
  fill(fillColor);
  if (id == ui.activeId) {
    checked = (g==0)?(!checked):true;
    if (g!=0) {
      Iterator itr = ui.groups.entrySet().iterator();
      while (itr.hasNext()) {
        Map.Entry me = (Map.Entry)itr.next();
        if ((int)me.getValue()==g)
          ui.values.put(me.getKey(),false);
      }
    }
    if (t) ui.values.put(id,checked);
  }
  return checked;
}

boolean _Button(String l, int x, int y, int w, int h, boolean b, boolean t, boolean c, int g) {
  boolean checked = _Box(x,y,w,h,t,c,g);
  if (!b) noStroke();
  rect(x,y,w,h);
  _Label(l,x,y,w,h);
  return checked;
}

boolean Button(String l, int x, int y) {
  return _Button(l,x,y,ui.widthDefault,ui.heightDefault,true,false,false,0);
}

boolean _CheckBox(String l, int x, int y, int w, int h, boolean c) {
  boolean checked = _Box(x+5,y+h/3,10,10,true,c,0);
  rect(x+5,y+h/3,10,10);
  _Label(l,x+25,y,w-20,h);
  return checked;
}

boolean CheckBox(String l,int x,int y,boolean c) {
  return _CheckBox(l,x,y,ui.widthDefault,ui.heightDefault,c);
}

boolean _RadioButton(String l,int x, int y, int w, int h, int g, boolean c) {
  boolean checked = _Box(x,y+h/2-5,10,10,true,c,g);
  ellipse(x+5,y+h/2,10,10);
  _Label(l,x+25,y,w-20,h);
  return checked;
}

boolean RadioButton(String l,int x, int y, int g, boolean c) {
  return _RadioButton(l,x,y,ui.widthDefault,ui.heightDefault,g,c);
}

String _ListBox(String[] labels, int x, int y, int w, int h, int s, boolean t) {
  int id = t?x+y*1000:0;
  String selected = null;
  int n = labels.length;
  int h0 = h/n;
  rect(x-1,y-1,w+2,h+2);
  for (int i=0;i<n;i++)
    if (_Button(labels[i],x,y+(h0+s)*i,w,h0,false,true,false,id))
      selected = labels[i];
  return selected;
}

String ListBox(String[] labels, int x, int y, boolean t) {
  return _ListBox(labels,x,y,ui.widthDefault,ui.heightDefault*labels.length,0,t);
}

String _ToolBar(String[] labels, int x, int y, int w, int h, int s, boolean t) {
  int id = t?x+y*1000:0;
  String selected = null;
  int n = labels.length;
  int w0 = w/n;
  rect(x-1,y-1,w+1,h+1);
  for (int i=0;i<n;i++)
    if (_Button(labels[i],x+(w0+s)*i,y,w0,h,false,true,false,id))
      selected = labels[i];
  return selected;
}

String ToolBar(String[] labels, int x, int y, boolean t) {
  return _ToolBar(labels,x,y,ui.widthDefault*labels.length,ui.heightDefault,0,t);
}

String _TextBox(String t, int x,int y, int w, int h) {
  int id = x+y*1000;
  String value = ui.values.get(id)==null?t:(String)ui.values.get(id);
  boolean mOver = mouseOver(x,y,w,h);
  int fillColor = mOver?ui.hoverColor:ui.normalColor;
  fill(ui.normalColor);
  if (mOver&&ui.keyboard) {
    if (key == BACKSPACE)
       value = value.substring(0,value.length()-1);
    else
       value = value+str(key);
    ui.values.put(id,value);
  }
  stroke(ui.strokeColor);
  fill(fillColor);
  ui.values.put(id,value);
  rect(x,y,w,h);
  _Label(value,x,y,w,h);
  return value;
}

String TextBox(String t, int x,int y, int w, int h) {
  return _TextBox(t,x,y,ui.widthDefault,ui.heightDefault);
}

int _Slider(int v, int min, int max,int x, int y, int w, int h) {
  int id = x+y*1000;
  int value = ui.values.get(id)==null?v:(int)ui.values.get(id);
  boolean mOver = mouseOver(x,y,w,h);
  int fillColor = mOver?ui.activeColor:ui.hoverColor;
  stroke(ui.strokeColor);
  fill(ui.normalColor);
  rect(x,y,w,h);
  if (mOver&&ui.pressed) {
    value = (int)map(mouseX, x, x+w, min, max);
    ui.values.put(id,value);
  }
  fill(fillColor);
  rect(x+value,y,h,h);
  _Label(value+"",x,y,w,h);
  return value;
}

int Slider(int v,int x, int y) {
  return _Slider(v,0,100,x,y,ui.widthDefault,ui.heightDefault/2);
}

void mouseMoved() {
  ui.mouseX = mouseX;
  ui.mouseY = mouseY;
}

void mousePressed() {
  ui.pressed = true;
  ui.mouseX = mouseX;
  ui.mouseY = mouseY;
}

void mouseReleased() {
  ui.pressed = false;
  ui.released = true;
  ui.mouseX = mouseX;
  ui.mouseY = mouseY;
}

void keyPressed() {
  ui.keyboard = true;
}