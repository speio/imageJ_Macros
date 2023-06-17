//define the directory wherein lie the images to be split
input = '/Users/core_mac1/Desktop/Geno/OneDrive/Uconn-Sem-9/FP_TimeCourse_Int_LamB_staining/PolII_f12_Int11_FP-DMSO/deconvoluted_image_work/Images_to_process/'
output = '/Users/core_mac1/Desktop/Geno/OneDrive/Uconn-Sem-9/FP_TimeCourse_Int_LamB_staining/PolII_f12_Int11_FP-DMSO/deconvoluted_image_work/Area_measure_result_tables/'
outputImages = '/Users/core_mac1/Desktop/Geno/OneDrive/Uconn-Sem-9/FP_TimeCourse_Int_LamB_staining/PolII_f12_Int11_FP-DMSO/deconvoluted_image_work/Area_measure_output_images/'
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
	
	setBatchMode(false);
	id = getImageID();
	selectImage(id);
	imageTitle=getTitle();//returns a string with the image title 
	n = nImages();
	selectImage(id);
	// image edits before processing any of the channels
	makeRectangle(31, 32, 964, 961); //crop deconvolution edges
		run("Crop");
	run("Enhance Contrast", "saturated=0.25");
	print(nSlices);
	mid_slice = floor(nSlices()/6);
	setSlice(mid_slice);
	Stack.setChannel(2);
	run("Enhance Contrast", "saturated=0.35");
	run("Green");
	Stack.setChannel(3);
	run("Enhance Contrast", "saturated=0.35");
	Stack.setChannel(1);
	run("Enhance Contrast", "saturated=0.35");
	saveAs("Tiff", outputImages+imageTitle);
	}

function area_measure() {	
	setBatchMode(true);
	id = getImageID();
	selectImage(id);
	imageTitle=getTitle();//returns a string with the image title 
	n = nImages();
	mid_slice = floor(nSlices()/6);
	selectImage(id);
	
	// Threshold on the DAPI channel and redirect to other channels
	run("Split Channels"); //Spit, then select DAPI channel
	selectWindow("C3-"+imageTitle);
	run("Duplicate...", "duplicate");
	run("Z Project...", "projection=[Average Intensity]");
	run("Enhance Contrast", "saturated=0.25");
	saveAs("Tiff", outputImages + "Dapi_" + imageTitle);
	ZprojectImageTitle=getTitle();
	selectWindow(ZprojectImageTitle);
	
	// Create binary mask
	setAutoThreshold("Intermodes dark");
	run("Convert to Mask");
	run("Invert"); //Invert mask to measure outside of dapi signal
	maskImageTitle=getTitle();
	saveAs("Tiff", outputImages + "Mask_" + maskImageTitle);
	maskImageTitle=getTitle();
	
	//looping over each slice given inputted parameters

	//repeating measurement for other channel	
	selectWindow("C3-"+imageTitle);
	run("Set Measurements...", "area mean standard min integrated median stack display add redirect=C3-"+imageTitle);
	n = nSlices;
	print(n+"slices");
	for (i=1; i <=n; i++) {
		selectWindow("C3-"+imageTitle);
		showProgress(i,n);
		setSlice(i);
		selectWindow(maskImageTitle); 
		run("Analyze Particles...", "size=10-Infinity show=Outlines summarize display add");
	}
	// Save results for both channel measurements
		selectWindow("Results");
		saveAs('txt', output + "C3_" + imageTitle);
		saveAs('txt', output + "C3_" + "All_results");
		close();
		selectWindow("Results");
		close();
		
	run("Select None");
	setBatchMode(false);
	
	}
