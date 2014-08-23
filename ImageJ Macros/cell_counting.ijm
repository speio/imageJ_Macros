macro "Watershed_Count" {
Dialog.create("Choose Input parameters");
	Dialog.addCheckbox("Movie (multi-slice tiff, gif, etc.)", false);
	Dialog.addCheckbox("Single Image", false);
	Dialog.addCheckbox("Batch Count a Folder", false);
	Dialog.addCheckbox("Display Preview (slower)", false);
	Dialog.show();
		movie = Dialog.getCheckbox();
		single = Dialog.getCheckbox();
		folder = Dialog.getCheckbox();
		preview = Dialog.getCheckbox();

Dialog.create("Choose counting parameters for image(s)");
	Dialog.addNumber("Minimum Size:", 23.5);
	Dialog.addNumber("Maximum Size:", 10000);
	Dialog.addNumber("Minimum Circularity:", 0.00);
	Dialog.addNumber("Maximum Circularity:", 1.00);
	Dialog.addCheckbox("Dark Background", true);
	Dialog.addCheckbox("Set Threshold Manually", false);
	Dialog.addChoice("Thresholding method", newArray("Default", "Huang", "Intermodes", "IsoData", "IJ_IsoData",
	"Li", "MaxEntropy", "Mean", "MinError", "Minimum", "Moments", "Otsu", "Percentile", "RenyiEntropy",
	"Shanbhag", "Triangle", "Yen"));
	Dialog.show();
		min = Dialog.getNumber();
		max = Dialog.getNumber();
		min_c = Dialog.getNumber();
		max_c = Dialog.getNumber();
		drk = Dialog.getCheckbox();
		mask_method = Dialog.getChoice();
		man_thresh = Dialog.getCheckbox();
		
if(man_thresh == true){ preview = true}

if(movie == true || single == true){
	composite_bool = getBoolean("Is image to be counted a multi-channel image? ");
	
	Z = false ;
	if(single == true){
		Z = getBoolean("Is image a z-stack?");
	}
	
	input = File.openDialog('Choose Tiff file to count');	
	count(input, min, max, min_c, max_c, drk, composite_bool, Z, preview);
}

//define the directory wherein lie the images for which the repeated commands will loop
if(folder == true){
	input = '';
	while(File.isDirectory(input) != true){
		waitForUser("Please select a file within the directory you wish to count");
		input = File.openDialog('file');
		input = File.getParent(input);
		
	}
	//making input readable
	input = input + "/";

	//checking details of files to be counted
	composite_bool = getBoolean("Are images to be counted multi-channel?");
	Z = getBoolean("Are images z-stacks?");
	
	//gets list of file names given directory assigned to input and makes a list
	list = getFileList(input); 
	
	//defines the directory whereto worked images should be saved
	File.makeDirectory(input + "Counted");
	output = input + "Counted/";
	
	//looping over each file in the input directory
	print("The files in the input directory were counted in the order:");
	print("(Filename) %%% (Cycle number)");
	for(i = 0; i < (list.length); i++){
		a = i ; 
		count(list[a], min, max, min_c, max_c, drk, composite_bool, Z, preview);
			//error check print out order that programme counted files
			print(list[a] + " %%% " + a );
		saveAs("Tiff", output + list[a]);
		close();
		close();
	}
}

function count(filename, min, max, min_c, max_c, drk, composite_bool, Z, preview) { 
	//is preview?
	setBatchMode(true);
	if(preview == true){
		setBatchMode(false);
	}
	
	open(filename);
	window = getTitle();
	selectWindow(window);

	//is composite?
	if(composite_bool == true){
	Stack.setDisplayMode("composite");
	}
	
	//is Z stack?
	if(Z == true){
		 run("Z Project...", "start="+1+" stop="+nSlices+" projection=[Sum Slices]"); 
		}
		
	//preparing image
	run("RGB Color", "frames keep");
	run("Smooth", "stack");
	run("Smooth", "stack");
	setOption("BlackBackground", drk);
	
	//stops for user to input threshold
	if(man_thresh == true){
		run("Threshold...");
		waitForUser("Set the threshold and press OK, \n or cancel to exit."); 
	}

	run("8-bit");
	//Threshold sets to...
	if(man_thresh != true && mask_method == "Default"){
		setThreshold(12.4,500);
	}
	if(man_thresh != true && mask_method != "Default"){
		if(drk == true){drk = "Dark";} else {drk = "Light";}
		run("Convert to Mask", "method=&mask_method background=&drk");
	}
	run("Make Binary");
	run("Watershed", "stack");
	//counting
	if(single == true){setBatchMode(true);}
	run("Analyze Particles...", "size=&min-&max circularity=&min_c-&max_c show=Outlines display clear include summarize stack");
	}
}