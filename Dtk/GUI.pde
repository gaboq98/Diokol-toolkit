

void setup() {
  size(640,480);
}

void draw() {
  background(243);
  
  ui.begin();
  
  Label("Label",10,10);
  
  if (Button("OK",10,40))
    print("OK");

  if (Button("CANCEL",10,80))
    print("CANCEL");
    
  CheckBox("Check",10,120,false);
    
  RadioButton("Button 1",150,120,1,false);
  RadioButton("Button 2",250,120,1,false);
    
  ToolBar(new String[] {"Apples","Oranges","Bananas"},10,160,true);
  
  ListBox(new String[] {"Apples","Oranges","Bananas"},150,10,true);
  
  String value = TextBox("XXX",10,200,60,30);
  
  Slider(10,100,240);

  ui.end();
}
