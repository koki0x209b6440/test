

class SampleListTest extends TestSampleList
{
  SampleListTest(PApplet papp)
  {
    super(papp);
    addScene(new Controller(papp) );
    addScene(new SceneTest(papp) );
  }
  
}

class ListTestB extends TestSampleList
{
  ListTestB(PApplet papp)
  {
    super(papp);
    addScene(new Controller(papp) );
    addScene(new SceneTest(papp) );
    //addScene(new PoyoBall(papp) );
  }
  
}
