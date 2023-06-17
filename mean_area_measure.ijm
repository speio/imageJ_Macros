//define the directory wherein lie the images to be split
input = ' /Users/genovillafano/OneDrive/Uconn-Sem-4/Lab/Microscopy/Strep_488_NTP_BioNTP_Mitotic_Count/test';
output = ' /Users/genovillafano/OneDrive/Uconn-Sem-4/Lab/Microscopy/Strep_488_NTP_BioNTP_Mitotic_Count/out/'
while(File.isDirectory(input) != true){
	ask_exit = getBoolean("Please select a file within the directory. \n  \n or Exit? (y/n)");
	if(ask_exit == true){
		exit();
	}
	input = File.openDialog('file');
	input = File.getParent(input);
	
}
input = input + "/";
list = getFileList(input); 

//looping over each image in the directory
for(i = 0; i < list.length; i++) {
	stackmaxima(input, list[i]);
 	//selectWindow("Results");
	//saveAs('txt', output + "image" + i );
		close();
 	}

function stackmaxima(inpath, filename) {	

	open(inpath + filename);
	resetMinAndMax();
	print(filename + nSlices);
	
	setBatchMode(true);
	input = getImageID();
	n = nSlices();
	selectImage(input);
	imageTitle=getTitle();//returns a string with the image title 
	run("Split Channels"); 
	selectWindow("C1-"+imageTitle); 
	close();
	selectWindow("C2-"+imageTitle);

	//looping over each slice given inputted parameters
	for (i=3; i <=7; i++) {
		showProgress(i,n);
		setSlice(i);
		run("Find Maxima...", "noise=120.9 output=[Point Selection] exclude");
		run("Measure");
		// Save results
		//selectWindow("Results");
		//saveAs('txt', output + "image" + i );
		//
	
		

	}
	
	run("Select None");
	setBatchMode(false);
	
}
