import controlP5.*;
import processing.video.*;
import java.awt.*;

ControlP5 controlP5;

Textlabel nameLabel;
Textlabel pathLabel;
Textlabel tagLabel;
Textlabel videoLabel;
Textlabel globalLabel;
Textlabel localLabel;
Textlabel descriptionLabel;
Textlabel numLabel;
Textarea pathTextarea;
ListBox listBox;
//Textfield nameTextfield;
Movie movie;
int movieIndex = 0;
boolean isPlaying = false;
String folderPath = "";
String fileName = "";
String tagString = "";
String[] val = {"", "", "", "", "", "", "" , ""};
ArrayList<String> videosName;
ArrayList<String> tagSet;
ArrayList<String> globalSet;
ArrayList<String> buffer;

PrintWriter printWriter = null;
CheckBox checkBox;
CheckBox globalCheckBox;
PFont font;

TextField textField = new TextField("", 20);
JSONArray jsonArray;
JSONObject globalObject;
JSONObject localObject = null;
boolean setting = true; 
boolean firstTime = true;

void setup() {
	size(1280, 768);
	controlP5 = new ControlP5(this);
	videosName = new ArrayList<String>();
	tagSet = new ArrayList<String>();
	buffer = new ArrayList<String>();
	
	//selectInput("Select the first video: ", "fileSelected");
	nameLabel = new Textlabel(controlP5, "Reviewer Name: ",80, 10, 100, 25);
	nameLabel.setFont(createFont("Georgia",16));
	pathLabel = new Textlabel(controlP5, "Video Folder: ", 80, 35, 100, 25);
	pathLabel.setFont(createFont("Georgia",16));
	videoLabel = new Textlabel(controlP5, "", 80, 600, 150, 25);
	videoLabel.setFont(createFont("Georgia", 16));
	descriptionLabel = new Textlabel(controlP5, "", 80, 625, 150, 25);
	descriptionLabel.setFont(createFont("Georgia", 16));
	globalLabel = new Textlabel(controlP5, "Global", 1030, 80, 150, 25);
	globalLabel.setFont(createFont("Georgia", 16));
	localLabel = new Textlabel(controlP5, "Local", 880, 80, 150, 25);
	localLabel.setFont(createFont("Georgia", 16));
	numLabel = new Textlabel(controlP5, "Start Num: ", 100, 80, 150, 25);
	numLabel.setFont(createFont("Georgia", 16));

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
    		 .setPosition(325, 80)
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
    controlP5.addTextfield("numValue")
    		 .setPosition(220, 80)
    		 .setSize(100, 25)
    		 .setFont(createFont("arial",14))
			 .setColor(color(255, 255, 0));
    
    checkBox = controlP5.addCheckBox("tag")
    					.setPosition(860, 110)
    					.setColorForeground(color(255, 255, 0))
    					.setColorActive(color(255, 0, 0))
    					.setColorLabel(color(255, 255, 255))
    					.setSize(20, 20)
    					.setItemsPerRow(1)
    					.setSpacingColumn(120)
    					.setSpacingRow(5);

    globalCheckBox = controlP5.addCheckBox("globalTag")
    						  .setPosition(1030, 110)
    						  .setColorForeground(color(255, 255, 0))
		    				  .setColorActive(color(255, 0, 0))
		    				  .setColorLabel(color(255, 255, 255))
		    				  .setSize(20, 20)
		    				  .setItemsPerRow(1)
		    				  .setSpacingColumn(120)
		    				  .setSpacingRow(5);
	initTag();
    textFont(font);
    if(setting == true){
	    controlP5.addButton("add")
	    		 .setPosition(760, 5)
	    		 .setSize(60,30);
	    tagLabel = new Textlabel(controlP5, "New Tag: ", 450, 5, 80, 25);
		tagLabel.setFont(createFont("Georgia", 16));
		add(textField);
	}

}

void draw() {
	background(0);
	nameLabel.draw(this);
	pathLabel.draw(this);
	globalLabel.draw(this);
	localLabel.draw(this);
	if(setting)
		tagLabel.draw(this);
	videoLabel.draw(this);
	descriptionLabel.draw(this);
	numLabel.draw(this);
	if(movie != null){
		if(!fileName.substring(0, 3).equals("IMG"))
			image(movie, 40, 110, 800, 450);
		else {
			//pushMatrix();
			//rotate(PI * 1.5);
			image(movie, 40, 110, 800, 450);
			//popMatrix();
		}
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
	if(firstTime){
		String name = controlP5.get(Textfield.class, "nameValue").getText();
		fileName = name;
		if(name != null && name != ""){
			String path = controlP5.get(Textfield.class, "pathValue").getText();
			if(path != null && path != ""){
				folderPath = path;
				//videosName = getVideofile(path);
				jsonArray = loadJSONArray("log.json");
				//readLog(0);
				println(controlP5.get(Textfield.class, "numValue").getText());
				if(controlP5.get(Textfield.class, "numValue").getText().length() > 0){
					int start = Integer.parseInt(controlP5.get(Textfield.class, "numValue").getText());
					movieIndex = start - 1;
					//println(movieIndex);
				}
				printWriter = createWriter(path + '/' + "result_" + name + ".csv");
				next();
				//checkBox.removeItem("rrrr");
			}
		}
	}else{
		println(controlP5.get(Textfield.class, "numValue").getText());
		if(controlP5.get(Textfield.class, "numValue").getText().length() > 0){
			int start = Integer.parseInt(controlP5.get(Textfield.class, "numValue").getText());
			movieIndex = start - 1;
			//println(movieIndex);
			next();
		}
	}
}

public void next(){
	//String tagString = "";
	//println("fuck: " + fuck);
	if(movieIndex + 1 < jsonArray.size()){
		println("var: "+movieIndex);
		if(!firstTime){

			movieIndex++;
			tagString = "";
			tagString += (val[0] + "_" + val[1] + "_" + val[2] + ", ");
			for(int i = 0;i < checkBox.getArrayValue().length; i++){
				int state = (int) checkBox.getArrayValue()[i];
				if(state == 1){
					tagString += (tagSet.get(i) + ", ");
				}
			}
			for(int i = 0;i < globalCheckBox.getArrayValue().length; i++){
				int state = (int) globalCheckBox.getArrayValue()[i];
				if(state == 1){
					tagString += (globalSet.get(i) + ", ");
				}
			}
			if(!tagString.equals((val[0] + "_" + val[1] + "_" + val[2] + ", ")) && !tagString.equals("")){
				//printWriter.println(tagString);
				tagString+= "\n";
				if(movieIndex - 1 >= buffer.size()){
					buffer.add(tagString);
				}else{
				 	buffer.set(movieIndex - 1, tagString);
				}
			}
			
		}
		else {
			firstTime = false;
		}
		println(buffer);
		checkBox.deactivateAll();
		globalCheckBox.deactivateAll();
		//printWriter.flush();
		val = readLog(movieIndex);
		fileName = val[6];
		videoDisplay(folderPath + '/' + val[6]);
		videoLabel.setText(val[7] + "--" + val[0] + "--" + val[1] + "--" + val[2] + ": " + val[6]);
		descriptionLabel.setText(val[3] + "\n\n" + val[4] + "\nrating: " + val[5]);
		//if(prevType.equals())
		loadTag(val[1], val[7].substring(0, 2));
		readTags();
	}
}

String[] readLog(int index){
	String[] value = {"", "", "", "", "", "", "" , ""};
	if(index < jsonArray.size()){
		JSONObject obj = jsonArray.getJSONObject(index);
		//println(obj.getJSONObject("file").getString("name"));
		value[0] = obj.getString("GlassType");
		value[1] = obj.getString("ConstraintType");
		value[2] = obj.getString("name");
		value[3] = obj.getString("method");
		value[4] = obj.getString("why");
		value[5] = obj.getString("rating");
		value[6] = obj.getJSONObject("file").getString("name");
		value[7] = obj.getString("intent");
	}
	return value;
}

void loadTag(String type, String intent){
	if(localObject != null){
		JSONObject localIntent = localObject.getJSONObject(intent);
		JSONArray localTags = localIntent.getJSONArray(type);
		println("tag: " + tagSet.size());
		int j = 0;
		int llength = tagSet.size();
		clearCheckBox();
		// for(int i = 0; i < llength; i++){
		// 	println("gan " + tagSet.size() + " fuck: " + checkBox.getArrayValue().length);
		// 	println(tagSet.get(i) + ":");
		// 	checkBox.removeItem(tagSet.get(i));
		// 	println("sexy");
		// 	//tagSet.remove(i);
		// }
		tagSet.clear();
		for(int i = 0; i < localTags.size(); i++){
			tagSet.add(localTags.getString(i));
		}
		for(int i = 0; i < tagSet.size(); i++){
			checkBox.addItem(tagSet.get(i), 100 * movieIndex - i);
		}
	}
}

void clearCheckBox(){
	controlP5.remove("tag");
	checkBox = controlP5.addCheckBox("tag")
    					.setPosition(860, 110)
    					.setColorForeground(color(255, 255, 0))
    					.setColorActive(color(255, 0, 0))
    					.setColorLabel(color(255, 255, 255))
    					.setSize(20, 20)
    					.setItemsPerRow(1)
    					.setSpacingColumn(120)
    					.setSpacingRow(5);
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
	if(movieIndex < jsonArray.size() && movieIndex > 0){
		movieIndex--;
		//next();
		val = readLog(movieIndex);
		fileName = val[6];
		videoDisplay(folderPath + '/' + val[6]);
		videoLabel.setText(val[7] + "--" + val[0] + "--" + val[1] + "--" + val[2] + ": " + val[6]);
		descriptionLabel.setText(val[3] + "\n\nWhy: " + val[4] + "\nrating: " + val[5]);
		loadTag(val[1], val[7].substring(0, 2));
		readTags();
		// movieIndex++;
	}
}

void readTags(){
	if(buffer.size() > movieIndex && movieIndex >= 0){
		String data = buffer.get(movieIndex);
		// String data[] = loadStrings("result_" + fileName + ".csv");
		// String dataLine = data[movieIndex];
		checkBox.deactivateAll();
		globalCheckBox.deactivateAll();
		String token[] = split(data, ", ");
		for(int i = 1; i < token.length; i++){
			for(int j = 0;j < tagSet.size(); j++){
				if(token[i].equals(tagSet.get(j))){
					checkBox.activate(j);
				}
			}
			for(int j = 0;j < globalSet.size(); j++){
				if(token[i].equals(globalSet.get(j))){
					globalCheckBox.activate(j);
				}
			}
		}
	}
}

public void replay(){
	videoDisplay(folderPath + '/' + val[6]);
}

public void done(){
	// for(int i = 0;i < checkBox.getArrayValue().length; i++){
	// 	int state = (int) checkBox.getArrayValue()[i];
	// 	if(state == 1){
	// 		println(tagSet.get(i));
	// 		tagString += (tagSet.get(i) + ", ");
	// 	}
	// }
	// if(tagString != null && tagString != ""){
	// 	printWriter.println(videosName.get(movieIndex) + ", " + tagString);
	// }
	tagString = "";
	tagString += (val[0] + "_" + val[1] + "_" + val[2] + ", ");
	for(int i = 0;i < checkBox.getArrayValue().length; i++){
		int state = (int) checkBox.getArrayValue()[i];
		if(state == 1){
			tagString += (tagSet.get(i) + ", ");
		}
	}
	for(int i = 0;i < globalCheckBox.getArrayValue().length; i++){
		int state = (int) globalCheckBox.getArrayValue()[i];
		if(state == 1){
			tagString += (globalSet.get(i) + ", ");
		}
	}
	if(!tagString.equals((val[0] + "_" + val[1] + "_" + val[2] + ", ")) && !tagString.equals("")){
		//printWriter.println(tagString);
		tagString+= "\n";
		if(movieIndex >= buffer.size()){
			buffer.add(tagString);
		}else{
		 	buffer.set(movieIndex - 1, tagString);
		}
	}
	
	for(int i = 0;i < buffer.size();i++){
		printWriter.println(buffer.get(i));
	}
	printWriter.flush();
	printWriter.close();
	saveJSONObject(localObject, "local.json");
	exit();
}

public void add(){
	String addTag = textField.getText();
	if(!addTag.equals("")){
		tagSet.add(addTag);
		localObject.getJSONObject(val[7].substring(0, 2)).getJSONArray(val[1]).append(addTag);
		checkBox.addItem(addTag, tagSet.size() - 1);
		textField.setText("");
	}
}

// public ArrayList<String> getVideofile(String path){
// 	File file = new File(path);
// 	File[] files = file.listFiles();
// 	ArrayList<String> videosName = new ArrayList<String>();
// 	for(int i = 0;i < files.length; i++){
// 		//println(files[i].getName());
// 		String[] token = split(files[i].getName(), ".");
// 		String format = token[token.length - 1];

// 		if(format.equals("mov") || format.equals("MOV") || format.equals("mp4")){
// 			println("format is: " + format);
// 			videosName.add(files[i].getName());
// 			//println(format);
// 		}	
// 	}
// 	return videosName;
// }

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

void initTag(){
	globalObject = loadJSONObject("global.json");
	globalSet = new ArrayList<String>();
	JSONArray globalArray = globalObject.getJSONArray("global");
	for(int i = 0; i < globalArray.size(); i++){
		globalSet.add(globalArray.getString(i));
		globalCheckBox.addItem(globalSet.get(i), i);
	}
	localObject = loadJSONObject("local.json");
	if(localObject == null){
		println("You don't have local.json");
		exit();
	}
}

