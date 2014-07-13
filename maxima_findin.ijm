//define the directory wherein lie the images to be split
//make sure directory contains only those images you want to run into the macro
//no other directories or other odd files should be present
input = "/Users/genovillafano/Dropbox/1Current/AG_Hagedorn/140710-Dilute-and-HL5c-Wpeptide-fixed/Worked-Images/"
//define the directory whereto worked images should be saved
output = "/Users/genovillafano/Dropbox/1Current/AG_Hagedorn/Points/"
//gets list of file names given directory assigned to input and makes a list

list = getFileList(input); 

//looping over each image in the directory
for(i = 0; i < list.length; i++) {
 	stackmaxima(input, output, list[i]);
 	//selectWindow("Results");
	//saveAs('txt', output + "image" + i );
	close();
 	}
 	
 		

function stackmaxima(inpath, outpath, filename) {
	open(inpath + filename);
	run("Red");
	
	//Allowing user to play with noise tolerance before setting
	waitForUser("Decide first, in this prompt which noise tolerance is best by selecting 'preview point selection'.\n DO NOT SELECT 'count'");
	run("Find Maxima...");
	close();
	waitForUser("Now input noise tolerance for use on all slices.");
	
	
	open(inpath + filename);
	run("Red");	
	
	Dialog.create("Find Maxima");
	Dialog.addNumber("Noise Tolerance:", 1000);
	Dialog.addChoice("Output Type:", newArray("Count"));
			//^^^can add more output types here for other purposes
	Dialog.addCheckbox("Exclude Edge Maxima", false);
	//Dialog.addCheckbox("Preview", false);
	Dialog.addCheckbox("Light Background", false);
	Dialog.show();
	tolerance = Dialog.getNumber();
	type = Dialog.getChoice();
	exclude = Dialog.getCheckbox();
	light = Dialog.getCheckbox();
	
	options = " ";
	if (exclude) options = options + " exclude";
	if (light) options = options + " light";
	
	setBatchMode(true);
	input = getImageID();
	n = nSlices();

	//erro check sort of thing 
	print(filename + "-" + n);
	
	for (i=1; i <=n; i++) {
		showProgress(i,n);
		selectImage(input);
		setSlice(i);
		run("Find Maxima...", "noise="+ tolerance +" output=["+type+"]"+options);
		if (i==1)
			output = getImageID();
			else if (type!="Count") {
				run("Select All");
				run("Copy");
				close();
				selectImage(output);
				run("Add Slice");
				run("Paste");
				
			}

	}
	
	run("Select None");
	setBatchMode(false);
	
}
