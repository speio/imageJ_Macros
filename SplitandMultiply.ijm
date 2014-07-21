//define the directory wherein lie the images to be split
//make sure directory contains only those images you want to run into the macro
//no other directories or other odd files should be present
input = "/Users/genovillafano/Dropbox/1Current/AG_Hagedorn/140716-NewPeptidevsOld-ABD-test/Worked-Images/"
//define the directory whereto worked images should be saved
output = "/Users/genovillafano/Dropbox/1Current/AG_Hagedorn/140716-NewPeptidevsOld-ABD-test/Worked-Images/"
//gets list of file names given directory assigned to input and makes a list

list = getFileList(input); 


//looping over each file in the input directory
for(i = 0; i < (list.length); i++)
	repeat_action(input, output, list[i]);
	
function repeat_action(input, output, filename) {
		open(input + filename);
		window = getTitle();
		//use to split up channels and throw some away, once split channels are selected
		//by name2 = "C2-" + window, and closed, change this to select the appropriate windows
		//to close
		//run("Split Channels");
		//name2 is used to select which window to close and ignore
		name2 = "C2-" + window;
		//selectWindow(name2);
		//close();

		//Working only with selected channel, apply transformations:
		//run("Red");
		//run("Divide...", "value=1.500 stack");
		//run("Delete Slice"); 
		
		run("Subtract Background...", "rolling=50 stack");
		saveAs('Tiff', output + filename);
		close();

		
}



//                    %%%%%%Stuff to get working later%%%%%%
//input = ""
//output = ""
//Dialog.create("stuff");
//Dialog.addString("type/paste the full path to directory of images:", input)
//Dialog.show()
//Dialog.addString("\n type/paste the full path to the output directory for finished images", output)
//Dialog.show();
//output = Dialog.getString();
//input = Dialog.getString();


