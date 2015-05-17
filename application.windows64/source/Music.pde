import ddf.minim.*;
import java.util.*;    


AudioSample Jump;
AudioSample Dash;
AudioSample Bamboe;
AudioSample Hit;
AudioSample GameOver;
// A reference to the processing sound engine
Minim minim = new Minim(this);

// SampleBank loads all samples in the data directory of your project
// so they can be triggered at any time in your game
class Music {

  HashMap<String, AudioSample> samples;
  AudioPlayer musicPlayer;

  // Constructor
  Music() {
    samples = new HashMap<String, AudioSample>();
    loadAllSamples();
    Jump = minim.loadSample("jump.wav", 2048);
    Dash = minim.loadSample("dash.wav", 1500);
    Bamboe = minim.loadSample("bamboeeten.wav", 2048);
    Hit = minim.loadSample("hit2.wav", 3000);
    GameOver = minim.loadSample("gameover.wav", 1500);
  }

  // load the background music
  void loadMusic(String musicFileName) {
    musicPlayer = minim.loadFile(musicFileName);
  }

  // play the background music
  void playMusic() {
    musicPlayer.play();
    musicPlayer.setGain(40.0);
    musicPlayer.loop();
  }

  // stop the background music
  void muteMusic() {
    musicPlayer.pause();
  }
  
  void unmuteMusic(){
    musicPlayer.play();
  }
  

  // Add a new sample to the sample bank
  void add(String sampleFileName) {
    AudioSample sample = minim.loadSample(sampleFileName);
    samples.put(sampleFileName, sample);    
    println(sampleFileName);
  }

  // trigger a loaded sample by fileName
  void trigger(String sampleFileName) {
    //    if (!sampleFileName.endsWith(".wav") &&  samples.containsKey(sampleFileName + ".wav"))
    sampleFileName += ".wav";
    if (samples.containsKey(sampleFileName)) 
      samples.get(sampleFileName).trigger();
  }

  // load all .wav files in the processing data directory
  void loadAllSamples() {
    File dataFolder = new File(dataPath(""));
    File [] files = dataFolder.listFiles();

    for (File file : files)
      if (file.getName().toLowerCase().endsWith(".wav"))
        add(file.getName());
  }
}

