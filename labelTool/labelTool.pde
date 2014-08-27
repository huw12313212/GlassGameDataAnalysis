import controlP5.*;
import processing.video.*;
ControlP5 controlP5;

Textlabel nameLabel;
Textlabel pathLabel;
Textarea pathTextarea;
//Textfield nameTextfield;
Movie movie;

void setup() {
	size(1360, 870);
	controlP5 = new ControlP5(this);
	//selectInput("Select the first video: ", "fileSelected");
	nameLabel = new Textlabel(controlP5, "Reviewer Name: ",80, 10, 100, 25);
	nameLabel.setFont(createFont("Georgia",16));
	pathLabel = new Textlabel(controlP5, "Video Path: ", 80, 35, 100, 25);
	pathLabel.setFont(createFont("Georgia",16));

	//nameTextfield = 
	controlP5.addTextfield("nameValue")
			 .setPosition(220, 10)
			 .setSize(100, 25)
			 .setFont(createFont("arial",14))
			 .setFocus(true)
			 .setColor(color(255, 255, 0));
	controlP5.addTextfield("pathValue")
             .setPosition(220, 35)
             .setSize(150,25)
             .setFont(createFont("arial",14))
             .setColor(color(255, 255, 0));
    controlP5.addButton("confirm")
    		 .setPosition(80, 80)
    		 .setSize(50, 30);
    controlP5.addButton("choose")
    		 .setPosition(375, 35)
    		 .setSize(50, 30);

}

void draw() {
	background(0);
	nameLabel.draw(this);
	pathLabel.draw(this);
	if(movie != null){
		image(movie, 40, 110);
	}
	//nameTextarea.draw(this);
}

void fileSelected(File selection){
	if(selection == null){
		println("Nothing");
	}else{
		println(selection.getAbsolutePath());
		controlP5.get(Textfield.class, "pathValue").setText(selection.getAbsolutePath());
	}
}

public void choose(){
	selectInput("Select the first video: ", "fileSelected");
} 

public void confirm(){
	String name = controlP5.get(Textfield.class, "nameValue").getText();
	if(name != null && name != ""){
		String path = controlP5.get(Textfield.class, "pathValue").getText();
		if(path != null && path != ""){
			videoDisplay(path);
		}
	}
}

public void videoDisplay(String filePath){
	String[] token = split(filePath, "/");
	String folderPath = "";
	for(int i =0;i < token.length - 1;i++){
		folderPath += token[i];
		folderPath += "/";
	}
	println(folderPath);
	movie = new Movie(this, folderPath + token[token.length - 1]);
	movie.play();
	println("fff");
}

void movieEvent(Movie m) {
  m.read();
}