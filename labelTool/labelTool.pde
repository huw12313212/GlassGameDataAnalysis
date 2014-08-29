import controlP5.*;
import processing.video.*;
import java.awt.*;

ControlP5 controlP5;

Textlabel nameLabel;
Textlabel pathLabel;
Textlabel tagLabel;
Textarea pathTextarea;
ListBox listBox;
//Textfield nameTextfield;
Movie movie;
int movieIndex = 0;
boolean isPlaying = false;
String folderPath = "";
String fileName = "";
String tagString = "";
ArrayList<String> videosName;
ArrayList<String> tagSet;
String[] basicSet = {"一", "二", "三", "四"};

PrintWriter printWriter = null;
CheckBox checkBox;
PFont font;

JFrame frame;
TextField textField = new TextField("type here", 20);


void setup() {
	size(1280, 768);
	controlP5 = new ControlP5(this);
	videosName = new ArrayList<String>();
	tagSet = new ArrayList<String>();
	
	//selectInput("Select the first video: ", "fileSelected");
	nameLabel = new Textlabel(controlP5, "Reviewer Name: ",80, 10, 100, 25);
	nameLabel.setFont(createFont("Georgia",16));
	pathLabel = new Textlabel(controlP5, "Video Folder: ", 80, 35, 100, 25);
	pathLabel.setFont(createFont("Georgia",16));
	tagLabel = new Textlabel(controlP5, "New Tag: ", 450, 5, 80, 25);
	tagLabel.setFont(createFont("Georgia", 16));

	
	font = createFont("蘋果儷中黑", 12);
	//textFont(font);
	ControlFont controlFont = new ControlFont(font, 12);
	controlP5.setFont(controlFont);
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
    		 .setPosition(100, 80)
    		 .setSize(80, 30);
    controlP5.addButton("choose")
    		 .setPosition(375, 35)
    		 .setSize(80, 30);
    controlP5.addButton("play")
    		 .setPosition(540, 80)
    		 .setSize(50, 30);
    controlP5.addButton("back")
    		 .setPosition(430, 80)
    		 .setSize(50, 30);
    controlP5.addButton("pause")
    		 .setPosition(485, 80)
    		 .setSize(50, 30);
    controlP5.addButton("replay")
    		 .setPosition(595, 80)
    		 .setSize(50, 30);
    controlP5.addButton("next")
    		 .setPosition(650, 80)
    		 .setSize(50, 30);
    controlP5.addButton("done")
    		 .setPosition(705, 80)
    		 .setSize(50, 30);
    controlP5.addButton("add")
    		 .setPosition(760, 5)
    		 .setSize(60,30);
    // controlP5.addTextfield("newTag")
    //          .setPosition(1000, 35)
    //          .setSize(150,25)
    //          .setColor(color(255, 255, 0));
    add(textField);
    checkBox = controlP5.addCheckBox("tag")
    					.setPosition(900, 80)
    					.setColorForeground(color(255, 255, 0))
    					.setColorActive(color(255, 0, 0))
    					.setColorLabel(color(255, 255, 255))
    					.setSize(30, 30)
    					.setItemsPerRow(2)
    					.setSpacingColumn(100)
    					.setSpacingRow(20);

    for(int i = 0;i < basicSet.length; i++){
    	tagSet.add(basicSet[i]);
    	checkBox.addItem(tagSet.get(i), i);
    }
    textFont(font);

}

void draw() {
	background(0);
	nameLabel.draw(this);
	pathLabel.draw(this);
	tagLabel.draw(this);
	if(movie != null){
		image(movie, 40, 110, 800, 450);
	}
	if(movie == null){
		isPlaying = false;
	}
	//nameTextarea.draw(this);
}

void folderSelected(File selection){
	if(selection == null){
		println("Nothing");
	}else{
		println(selection.getAbsolutePath());
		controlP5.get(Textfield.class, "pathValue").setText(selection.getAbsolutePath());
	}
}

public void controlEvent(ControlEvent event){

}

public void choose(){
	//selectInput("Select the first video: ", "fileSelected");
	selectFolder("select the folder contains videos:", "folderSelected");
	//selectFolder();
} 

public void confirm(){
	String name = controlP5.get(Textfield.class, "nameValue").getText();
	fileName = name;
	if(name != null && name != ""){
		String path = controlP5.get(Textfield.class, "pathValue").getText();
		if(path != null && path != ""){
			//videoDisplay(path);
			folderPath = path;
			videosName = getVideofile(path);
			//println("get all files");
			printWriter = createWriter(path + '/' + "result_" + name + ".csv");
			next();
		}
	}
}

public void next(){
	if(videosName.size() > 0 && movieIndex < videosName.size()){
		for(int i = 0;i < checkBox.getArrayValue().length; i++){
			int state = (int) checkBox.getArrayValue()[i];
			if(state == 1){
				println(tagSet.get(i));
				tagString += (tagSet.get(i) + ", ");
			}
		}
		if(tagString != null && tagString != ""){
			printWriter.println(videosName.get(movieIndex) + ", " + tagString);
			tagString = "";
		}
		checkBox.deactivateAll();
		videoDisplay(folderPath + '/' + videosName.get(movieIndex));
		movieIndex++;
	}
	
}

public void pause(){
	if(isPlaying){
		movie.pause();
		isPlaying = false;
	}
}

public void play(){
	if(!isPlaying){
		movie.play();
		isPlaying = true;
	}
}

public void back(){
	if(movieIndex < videosName.size() && movieIndex > 0){
		movieIndex--;
		videoDisplay(folderPath + '/' + videosName.get(movieIndex));
	}
}

public void replay(){
	videoDisplay(folderPath + '/' + videosName.get(movieIndex - 1));
}

public void done(){
	for(int i = 0;i < checkBox.getArrayValue().length; i++){
		int state = (int) checkBox.getArrayValue()[i];
		if(state == 1){
			println(tagSet.get(i));
			tagString += (tagSet.get(i) + ", ");
		}
	}
	if(tagString != null && tagString != ""){
		printWriter.println(videosName.get(movieIndex) + ", " + tagString);
	}
	if(printWriter != null){
		printWriter.flush();
		printWriter.close();
		exit();
	}
}

public void add(){
	String addTag = textField.getText();
	if(!addTag.equals("")){
		tagSet.add(addTag);
		checkBox.addItem(addTag, tagSet.size() - 1);
		textField.setText("");
	}
}

public ArrayList<String> getVideofile(String path){
	File file = new File(path);
	File[] files = file.listFiles();
	ArrayList<String> videosName = new ArrayList<String>();
	for(int i = 0;i < files.length; i++){
		//println(files[i].getName());
		String[] token = split(files[i].getName(), ".");
		String format = token[token.length - 1];

		if(format.equals("mov") || format.equals("MOV") || format.equals("mp4")){
			println("format is: " + format);
			videosName.add(files[i].getName());
			//println(format);
		}	
	}
	return videosName;
}

public void videoDisplay(String filePath){
	if(movie != null){
		movie.stop();
		movie = null;
	}

	movie = new Movie(this, filePath);
	movie.play();
	isPlaying = true;
	// println("fff");
}

void keyPressed(){
	if(key == ' '){
		if(isPlaying){
			if(movie != null){
				movie.pause();
				isPlaying = false;
			}
		}else{
			if(movie != null){
				movie.play();
				isPlaying = true;
			}	
		}
	}
}

void movieEvent(Movie m) {
  m.read();
}

