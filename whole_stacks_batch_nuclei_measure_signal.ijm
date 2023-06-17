//define the directory wherein lie the images to be split
input = '/Users/speio/OneDrive/Uconn-Sem-9/TTF2_Ser2_Ser5_timecourse_imaging/deconvolved/Images_to_process/';
output = '/Users/speio/OneDrive/Uconn-Sem-9/TTF2_Ser2_Ser5_timecourse_imaging/deconvolved/Area_measure_results/'
outputImages = '/Users/speio/OneDrive/Uconn-Sem-9/TTF2_Ser2_Ser5_timecourse_imaging/deconvolved/Area_measure_results/Area_measure_output_images/'
while(!File.isDirectory(input)){
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
	pre_process(input,list[i]);
	area_measure(); //works on currently open image from pre_process function
	close();
 	}
function pre_process(inpath, filename) {	
	run("Bio-Formats", "open="+ inpath + filename + " autoscale color_mode=Colorized rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	resetMinAndMax();
	print(filename + nSlices);
	
	setBatchMode(true);
	id = getImageID();
	selectImage(id);
	imageTitle=getTitle();//returns a string with the image title 
	n = nImages();
	selectImage(id);
	// image edits before processing any of the channels
	makeRectangle(31, 32, 964, 961); //crop deconvolution edges
		run("Crop");
	run("Enhance Contrast", "saturated=0.25");
	mid_slice = floor(nSlices()/3);
	setSlice(mid_slice);
	Stack.setChannel(1);
	run("Enhance Contrast", "saturated=0.35");
	run("Magenta");
	Stack.setChannel(2);
	run("Enhance Contrast", "saturated=0.35");
	Stack.setChannel(3);
	run("Enhance Contrast", "saturated=0.35");
	Stack.setChannel(4);
	run("Enhance Contrast", "saturated=0.35");
	run("Subtract Background...", "rolling=200 disable stack");
	
	saveAs("Tiff", outputImages+imageTitle);
	}

function area_measure() {	
	setBatchMode(true);
	id = getImageID();
	selectImage(id);
	imageTitle=getTitle();//returns a string with the image title 
	n = nImages();
	selectImage(id);
	
	// Threshold DAPI channel and redirect to 488 channel
	run("Split Channels"); //Spit, then select DAPI channel
	selectWindow("C4-"+imageTitle); 
	run("Z Project...", "projection=[Max Intensity]");
	selectWindow("C4-"+imageTitle);
	close();
	// Create binary mask
	selectWindow("MAX_C4-"+imageTitle); 
	run("Multiply...", "value=1.950");
	run("Gaussian Blur...", "sigma=2");
	setAutoThreshold("Intermodes dark");
	run("Convert to Mask");
	maskImageTitle2=getTitle();
	run("Invert");
	saveAs("Tiff", outputImages+"Invert_mask_"+maskImageTitle2);
	maskImageTitle2=getTitle();
	//invert to get signal outside of chromatin
	
	//looping over each slice given inputted parameters
	//start 5 slices up from bottom
	
	run("Set Measurements...", "area mean standard min integrated median stack display add redirect=C1-"+imageTitle);
	selectWindow("C1-"+imageTitle);
	n = nSlices;
	print(n);
	for (i=5; i <=n; i++) {
		selectWindow("C1-"+imageTitle);
		showProgress(i,n);
		setSlice(i);
		selectWindow(maskImageTitle2); 
		run("Analyze Particles...", "size=10-Infinity show=Outlines summarize display add");
	}
	
	//repeating measurement for other channel	
	selectWindow("C2-"+imageTitle);
	run("Set Measurements...", "area mean standard min integrated median stack display add redirect=C2-"+imageTitle);
	n = nSlices;
	print(n+"slices");
	for (i=5; i <=n; i++) {
		selectWindow("C2-"+imageTitle);
		showProgress(i,n);
		setSlice(i);
		selectWindow(maskImageTitle2); 
		run("Analyze Particles...", "size=10-Infinity show=Outlines summarize display add");
	}
	//repeating measurement for other channel	
	selectWindow("C3-"+imageTitle);
	run("Set Measurements...", "area mean standard min integrated median stack display add redirect=C3-"+imageTitle);
	n = nSlices;
	print(n+"slices");
	for (i=5; i <=n; i++) {
		selectWindow("C3-"+imageTitle);
		showProgress(i,n);
		setSlice(i);
		selectWindow(maskImageTitle2); 
		run("Analyze Particles...", "size=10-Infinity show=Outlines summarize display add");
	}
	// Save results for both channel measurements
		selectWindow("Results");
		saveAs('txt', output + "Inverted_C3_2_1" + imageTitle);
		saveAs('txt', output + "Inverted_C3_2_1" + "All_results");
		close();
		selectWindow("Results");
		close();
		
	run("Select None");
	setBatchMode(false);
	
	}
