//define the directory wherein lie the images to be split
input = '/Users/speio/OneDrive/Uconn-Sem-8/FP_TimeCourse_Int_LamB_staining/Time_course_slides_LamB_PolII_D4H8/Deconvulted_images_only/test/';
output = '/Users/speio/OneDrive/Uconn-Sem-8/FP_TimeCourse_Int_LamB_staining/Time_course_slides_LamB_PolII_D4H8/Deconvulted_images_only/worked/';
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
	midslice_and_export(input, list[i]);
	close();
 	}

function midslice_and_export(inpath, filename) {	
	run("Bio-Formats", "open= "+inpath+filename+" autoscale color_mode=Colorized rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	//resetMinAndMax();
	//print(filename + nSlices);
	// remember the original hyperstack
	id = getImageID();
	 
	// we need to know only how many frames there are
	getDimensions(dummy, dummy, dummy, dummy, nFrames);
	 
	// for each frame...
	for (frame = 1; frame <= nFrames; frame++) {
	    // select the frame
	    selectImage(id);
	    Stack.setPosition(1, 1, frame);
	 
	    // extract one frame
	    run("Reduce Dimensionality...", "channels slices keep");
	}
	 
	// close the original hyperstack
	selectImage(id);
	close();
	setBatchMode(true);
	id = getImageID();
	selectImage(id);
	imageTitle=getTitle();//returns a string with the image title 
	makeRectangle(31, 32, 964, 961); //crop deconvolution edges
	run("Crop");
	//run("Subtract Background...", "rolling=100 sliding stack");
	//saveAs('tiff', output+imageTitle);
	mid_slice = floor(nSlices()/6);
	run("Make Substack...", "channels=1-3 slices="+mid_slice);
	//setSlice(midslice);
	//selectImage(imageTitle+"-1")
	Stack.setDisplayMode("composite");
	run("Multiply...", "value=4");
	imageTitle=getTitle();//returns a string with the image title 
	saveAs('tiff', output+imageTitle+"slice_"+mid_slice);
	setBatchMode(false);
	close();
}
