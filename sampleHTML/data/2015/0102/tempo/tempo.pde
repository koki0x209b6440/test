
/*
リズム抽出。合っているかわからん。mp3無理だった。

diffとかbpmの産出メソッドが興味ある。
*/
/*
wavファイルを一定時間(以下フレーム)ごとに区切る。
フレームごとの音量を求める。
隣り合うフレームの音量の増加量を求める。
増加量の時間変化の周波数成分を求める。
周波数成分のピークを検出する。
ピークの周波数からテンポを計算する。
ピークの周波数成分の位相から拍の開始位置を計算する。
*/

import ddf.minim.*;

Minim minim;
AudioSample sample;
AudioPlayer player;

PImage g;

//Rbpm を取得する
Pair<Float, Float> get_Rbpm(float[] D, float fbpm, float s) {
  int N = D.length;
  float a = 0, b = 0;
  for (int n = 0; n < N; n++) {
    a += D[n] * cos(TWO_PI * fbpm * n / s);
    b += D[n] * sin(TWO_PI * fbpm * n / s);
  }

  float c = atan2(b, a);
  while (c < 0) c += TWO_PI;

  return new Pair<Float, Float>(sqrt(sq(a) + sq(b)), c/(TWO_PI*fbpm));
}

//最良と考え得るbpmを返す。全てのデータはbpms と secs に格納する
Pair<Integer, Float> get_bpm(float[] diff, float rate, int frame_size, Float[] bpms, Float[] secs) {
  Pair<Integer, Float> res = new Pair<Integer, Float>(0, 0f);

  for (int bpm = 60; bpm < bpms.length+60; bpm++) {
    Pair<Float, Float> v = get_Rbpm(diff, bpm/60f, rate/frame_size); 
    bpms[bpm-60] = v.first;
    secs[bpm-60] = v.second;
    if (res.second < bpms[bpm-60]) {
      res.first = bpm;
      res.second = bpms[bpm-60];
    }
  }

  return res;
}

//src をframe_sizeごとに区切って差分をとりdst に代入する
void create_diff(float[] dst, float[] src, int frame_size) {
  float[] amp = new float[dst.length];
  for (int i = 0; i < amp.length; i++) {
    for (int j = 0; j < frame_size; j++) {
      amp[i] += sq(src[i * frame_size + j]);
    }
    amp[i] /= frame_size;
  }

  for (int i = 0; i < dst.length-1; i++) {
    dst[i] = max(amp[i+1] - amp[i], 0);
  }
}

void setup() {
  minim = new Minim(this);
  
  String filename = "input.wav";//default:  input.wav
 
  sample = minim.loadSample(filename);  //解析用
  player = minim.loadFile(filename);    //再生用
  float[] left = sample.getChannel(AudioSample.LEFT);
  float[] right =  sample.getChannel(AudioSample.RIGHT);

  float rate = sample.sampleRate();
  int sample_total = left.length;

  int frame_size = 480;
  int sample_max = sample_total - (sample_total % frame_size);
  int frame_max = sample_max / frame_size;
  float[] diff_left = new float[frame_max];

  create_diff(diff_left, left, frame_size);
  Float[] bpms = new Float[200+1];
  Float[] secs = new Float[200+1];
  Pair<Integer, Float> result = get_bpm(diff_left, rate, frame_size, bpms, secs);
  println(result);
  println(""+bpms[result.first- 60]+","+secs[result.first - 60]);

  //bpmの一致率的な
  size(400, 400);
  background(255);
  textAlign(CENTER);
  stroke(0);
  fill(0);

  float max_v = result.second;
  for (int i = 0; i< bpms.length; i++) {
    float x = map(i, 0, bpms.length, 20, width-20);
    float v = map(bpms[i], 0, max_v, 0, height - 50);
    line(x, height - 20, x, height -20 - v);

    if (i%10 == 0) {
      text(i+60, x, height);
    }
  }

  g = get();

  x = 60000f / result.first;
  d = secs[result.first-60];

  player.play();
}

void mousePressed(){
  player.rewind();
}

float pv = 0;
float r = 0;
float x, d;

void draw() {
  background(0);
  image(g, 0, 0);
  stroke(0);
  fill(0);

  float v = (player.position()-d)%x;
  if (v < pv) {
    r = 100;
  }
  pv = v;

  if(r>=70)ellipse(width/2, height/2, 100, 100);
  r = max(r-2, 0);
}

void stop() {
  sample.close();
  player.close();
  minim.stop();

  super.stop();
}

public class Pair<F, S> {
  public F first;
  public S second;

  public Pair(F f, S s) {
    first = f;
    second = s;
  }

  public String toString() {
    return first + ", " + second;
  }
}
