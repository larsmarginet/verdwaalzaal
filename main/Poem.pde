class Poem {
    Movie video;
    Amplitude[] tracks =  new Amplitude[0];
  
    Poem(PApplet parent, String source, Amplitude[] files) {
        video = new Movie(parent, source);


        for (int i = 0; i < files.length; i++) {
            tracks = (Amplitude[]) append(tracks, files[i]);
        }
    }
}
