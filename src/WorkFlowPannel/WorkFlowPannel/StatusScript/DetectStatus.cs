using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WorkFlowPannel
{
    public class DetectStatus
    {
        private string movieProcessed = "";
        private int movieDuration = -1;
        private int firstLaglessFrame = -1;
        private int screenhotOffset = -1;
        private string stateProcess = "";
        private int currentScreenshotProcess = -1;
        private List<int> checkpoints = null;
        private List<int> fixedDesyncs = null;

        public string MovieProcessed
        {
            get { return movieProcessed; }
            set { movieProcessed = value; }
        }
        public int MovieDuration
        {
            get { return movieDuration; }
            set { movieDuration = value; }
        }
        public int FirstLaglessFrame
        {
            get { return firstLaglessFrame; }
            set { firstLaglessFrame = value; }
        }
        public int ScreenhotOffset
        {
            get { return screenhotOffset; }
            set { screenhotOffset = value; }
        }
        public string StateProcess
        {
            get { return stateProcess; }
            set { stateProcess = value; }
        }
        public int CurrentScreenshotProcess
        {
            get { return currentScreenshotProcess; }
            set { currentScreenshotProcess = value; }
        }
        public List<int> Checkpoints
        {
            get { return checkpoints; }
            set { checkpoints = value; }
        }
        public List<int> FixedDesyncs
        {
            get { return fixedDesyncs; }
            set { fixedDesyncs = value; }
        }
        public static DetectStatus getInstance() {
            return DetectStatus.DetectStatusKeeper.instance;
        }        
	    private static class DetectStatusKeeper{
            public static DetectStatus instance = new DetectStatus();
	    }	
        public DetectStatus(){
        }

    }
}
