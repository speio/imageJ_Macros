setBatchMode("true");
	//run("Bio-Formats", "open="+input+list[i]+" autoscale color_mode=Colorized rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
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
	//Create substack based on center of z stack +/- 10
	mid_slice = floor(nSlices()/2);
	Start_slice=5 ;
	Stop_slice=nSlices() ;
	run("Make Substack...", "channels=1-3 slices="+Start_slice+"-"+Stop_slice);
	//Subtract background
	run("Subtract Background...", "rolling=100 sliding stack");
	//CREATE BINARY MASK WITH DAPI CHANNEL
	Start_slice=1 ;
	Stop_slice=nSlices();
	print(file_name);
	//run("Make Substack...", "channels=3 slices="+Start_slice+"-"+Stop_slice);
	run("Split Channels");
	selectWindow("C3-"+file_name);
	//run("Z Project...", "projection=[Average Intensity]");
	run("Make Binary", "method=Default background=Dark black");
	//Split channels and run coloc2
	
	close(); //closes channel 3 which is dapi

	//run("Scale Bar...", "width=5 height=4 font=14 color=White background=None location=[Lower Right] bold overlay");