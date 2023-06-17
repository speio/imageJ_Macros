import ij.*;
import ij.measure.*;
import ij.plugin.*;
import ij.plugin.filter.*;
import ij.process.*;
import ij.gui.*;
import java.awt.*;

/**
* "AnalyzeParticles" for each slice of stack
*    record:
*        slice# in "Slice" column
*         topLeft x,y and ncoords to allow re_autoOutline of particles
*
*/
public class Stack_Particle_Analyzer implements PlugIn, Measurements {

	public void run(String arg) {
		if (IJ.versionLessThan("1.19s"))
			return;
		ImagePlus imp = WindowManager.getCurrentImage();
		if (imp==null)
			{IJ.noImage(); return;}
		analyzeStackParticles(imp);
	}

	public void analyzeStackParticles(ImagePlus imp) {
		if (imp==null || imp.getType()!=ImagePlus.GRAY8)
			{IJ.error("8-bit grayscale image required"); return;}
		int measurements = Analyzer.getMeasurements();
		measurements |= AREA+CENTROID;
		Analyzer.setMeasurements(measurements);
		Analyzer.resetCounter();
		ResultsTable rt = new ResultsTable();
		int options = 0;
		int minSize=1, maxSize=999999;
		MyParticleAnalyzer pa = new MyParticleAnalyzer(options, measurements, rt, minSize, maxSize);
		pa.setup("",imp);
           		ImageWindow win = imp.getWindow();
           		win.running = true;
		int nSlices=imp.getStackSize();
		for (int i=1;i<=nSlices;i++) {
			IJ.showProgress((double)i/nSlices);
			if(!win.running)break;
			imp.setSlice(i);
			if(!pa.analyze(imp,imp.getProcessor()))
				break;
		}
		IJ.showProgress(1.0);
	}
}

class MyParticleAnalyzer extends ParticleAnalyzer {
	int SLI,XTL,YTL,NCO;

	public MyParticleAnalyzer(int options, int measurements, ResultsTable rt, int min, int max) {
		super(options, measurements, rt, min, max);
		SLI = rt.getFreeColumn("Slice");
		XTL = rt.getFreeColumn("Xtopl");
		YTL = rt.getFreeColumn("Ytopl");
		NCO = rt.getFreeColumn("nCoord");
	}
    
	// Overrides method with the same in AnalyzeParticles that's called once for each particle
	protected void saveResults(ImageStatistics stats, Roi roi) {
		super.saveResults(stats, roi);
		int coordinates = ((PolygonRoi)roi).getNCoordinates();
		Rectangle r = roi.getBoundingRect();
		int x = r.x+((PolygonRoi)roi).getXCoordinates()[coordinates-1];
		int y = r.y+((PolygonRoi)roi).getYCoordinates()[coordinates-1];
		rt.addValue(SLI,imp.getCurrentSlice());
		rt.addValue(XTL,x);
		rt.addValue(YTL,y);
		rt.addValue(NCO,coordinates);
		analyzer.updateHeadings();
		analyzer.displayResults();
	}
}
