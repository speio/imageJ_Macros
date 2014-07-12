//define the directory wherein lie the images to be split
//make sure directory contains only those images you want to run into the macro
//no other directories or other odd files should be present
input = "/Volumes/TRANSCEND/Rachel1/Dilute-and-HL5c-Wpeptide-fixed/Raw-Images/"
//define the directory whereto worked images should be saved
output = "/Volumes/TRANSCEND/Rachel1/Dilute-and-HL5c-Wpeptide-fixed/Worked-Images/"
//gets list of file names given directory assigned to input and makes a list

list = getFileList(input); 


//looping over each file in the input directory
for(i = 0; i < (list.length-40); i++)
	splitting(input, output, list[i]);
	
function splitting(input, output, filename) {
		open(input + filename);
		window = getTitle();
		run("Split Channels");
		//name2 is used to select which window (GFP channel) to close and ignore
		name2 = "C1-" + window;
		selectWindow(name2);
		close();

		//Working only with RFP/Red/Atg8(in this instance) channel
		run("Red");
		run("Multiply...", "value=1.700 stack");
		run("Delete Slice"); 
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


