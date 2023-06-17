
input = File.openDialog('Choose Tiff file to count');
open(input)
//run("LSM...");
composite_bool = getBoolean("Is image to be counted a multi-channel image? ");
	if(composite_bool == true){
		Stack.setDisplayMode("composite");
	}


Dialog.create("Input parameters");
	Dialog.addNumber("Minimum Size:", 23);
	Dialog.addNumber("Maximum Size:", 10000);
	Dialog.addNumber("Minimum Circularity:", 0.10);
	Dialog.addNumber("Maximum Circularity:", 1.00);
	Dialog.addCheckbox("Light Background", false);
	Dialog.show();
		min_size = Dialog.getNumber();
		max_size = Dialog.getNumber();
		min_circ = Dialog.getNumber();
		max_circ = Dialog.getNumber();
		dark_bkgr = Dialog.getCheckbox();
		
setBatchMode(true);
 
run("RGB Color", "frames keep" );
run("Smooth", "stack");
run("Smooth", "stack");
run("8-bit");
//preparing image
setAutoThreshold("Huang dark");
setOption("BlackBackground", dark_bkgr);
run("Convert to Mask", "method=Huang background=Dark");
run("Watershed", "stack");
//counting
setBatchMode(false);
run("Analyze Particles...", "size=&min_size-&max_size circularity=&min_circ-&max_circ show=Outlines display clear include summarize stack");

