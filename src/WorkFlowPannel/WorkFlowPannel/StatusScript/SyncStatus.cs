using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WorkFlowPannel
{
    public class SyncStatus
    {
        private string movieProcessed = "";
        private int movieDuration = -1;
        private int currentFrame = -1;
        private string stateProcess = "";
        private List<int> possiblesDesyncs = null;

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
        public int CurrentFrame
        {
            get { return currentFrame; }
            set { currentFrame = value; }
        }
        public string StateProcess
        {
            get { return stateProcess; }
            set { stateProcess = value; }
        }
        public List<int> PossiblesDesyncs
        {
            get { return possiblesDesyncs; }
            set { possiblesDesyncs = value; }
        }        

        public static SyncStatus getInstance() {
            return SyncStatus.SyncStatusKeeper.instance;
        }
        private static class SyncStatusKeeper
        {
            public static SyncStatus instance = new SyncStatus();
	    }
        public SyncStatus() {

        }
    }
}
