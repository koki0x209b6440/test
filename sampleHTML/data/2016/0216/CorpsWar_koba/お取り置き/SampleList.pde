class SampleListTest extends TestSampleList
{
  SampleListTest(PApplet papp)
  {
    super(papp);
    addScene(new Controller(papp) );
    addScene(new SceneTest(papp) );
    addScene(new Grass(papp) );
  }
  
}

class CenterProjectionList extends TestSampleList
{
  CenterProjectionList(PApplet papp)
  {
    super(papp);
    addScene(new SceneD(papp) );
    addScene(new SceneB(papp) );
    addScene(new Grass(papp) );
  }
  
}

class LeftProjectionList extends TestSampleList
{
  LeftProjectionList(PApplet papp)
  {
    super(papp);
    addScene(new SceneAl(papp) );
    addScene(new SceneCl(papp) );
    addScene(new SceneBl(papp) );
    addScene(new Controller(papp) );
    addScene(new Grass(papp) );
    
  }
  
}

class RightProjectionList extends TestSampleList
{
  RightProjectionList(PApplet papp)
  {
    super(papp);
    addScene(new SceneAr(papp) );
    addScene(new SceneCr(papp) );
    addScene(new SceneBr(papp) );
    
  }
  
}
