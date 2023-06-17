input="/Users/speio/OneDrive/Uconn-Sem-8/FP_TimeCourse_Int_LamB_staining/Counting_60x_images/deconv_images_only/Require_Different_stack_selection/even_more_special_cases/"
output="/Users/speio/OneDrive/Uconn-Sem-8/FP_TimeCourse_Int_LamB_staining/Counting_60x_images/worked_for_lamin_classification/"
list = getFileList(input); 

//looping over each image in the directory
for(i = 0; i < list.length; i++) {
	setBatchMode("true");
	run("Bio-Formats", "open="+input+list[i]+" autoscale color_mode=Colorized rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	run("Set Scale...", "distance=15.5763 known=1 pixel=1 unit=micron global"); // set scale before substack
	file_name=getTitle(); //get original title
	makeRectangle(31, 32, 964, 961); //crop deconvolution edges
		run("Crop");
	run("Enhance Contrast", "saturated=0.25");
	mid_slice = floor(nSlices()/6);
	setSlice(mid_slice);
	Stack.setChannel(2);
	run("Enhance Contrast", "saturated=0.35");
	run("Green");
	Stack.setChannel(3);
	run("Enhance Contrast", "saturated=0.35");
	Stack.setChannel(1);
	run("Enhance Contrast", "saturated=0.35");
	Stack.setDisplayMode("composite");
	run("Flatten", "stack");
	//Create substack based on center of z stack +/- 10
	mid_slice = floor(nSlices()/2);
	Start_slice=1 ;
	Stop_slice=nSlices() ;
	run("Make Substack...", "channels=1-3 slices="+Start_slice+"-"+Stop_slice);
	//Subtract background, add scale
	run("Subtract Background...", "rolling=100 sliding stack");
	run("Scale Bar...", "width=5 height=4 font=14 color=White background=None location=[Lower Right] bold overlay");
	Stack.setChannel(2);
	run("Z Project...", "projection=[Max Intensity]");
	saveAs("PNG", output+file_name);
	close();
	close();
	close();
 	}


