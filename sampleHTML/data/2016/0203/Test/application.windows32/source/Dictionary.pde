
import java.util.HashMap;

public class ObjectBlocksDictionary{
//　わざわざインスタンスをマップに入れる理由(重くね？とか他に手段あるだろ、とか対策):
//べつにブロックタイプ入力受け取って　if(type==hoge) return new HogeObject();を連ねても良いが、
//クリエイティブモード時のアイテム一覧を実現するのに、この辞書があればget(n).drawAsItemをfor文で回せば
//いい。(そこまで考えたはいいがdrawAsItemメソッド、そもそもアイテムの概念すらまだ無いが)
//　で、辞書でブロックタイプを索引して、見つけたブロックのコピーを出力する(インスタンス生成の代用)
//"なんとなく一覧からブロックを取り出す方がそれっぽい"と思ったから、だが、シリアライズまでやったのはやりすぎか。
//せっかくなのでセーブデータ入出力、特に入力に役立てようとも思う。
//(セーブデータ入出力こそシリアライズでなんとかできるかもだから、この辞書はシリアライズの練習台になったと
//結果論で言えるかも？)

//追記:アイテム一覧だけでなく、所持アイテムの描画、つまりアイテムとしての各ブロックの描画(ワールドの座標に対応しない)
//はここのをgetで使おうと思う。(アイテム欄未実装だが)(メモ:所持品の位置や個数やタイプはどう処理するか迷う)
 private HashMap<Integer,ObjectBlock> obDic=new HashMap<Integer,ObjectBlock>();
 private ObjectBlock obj;

 ObjectBlocksDictionary(WorldData world){
   obDic.put(0,new NoObject(0,0,0) );
   obDic.put(1,new PlayerBlock(0,0,0));
   obDic.put(2,new ColorfulBox(0,0,0,255,255,255));
   obDic.put(3,new ColorfulBox(0,0,0,255,0,0));
   obDic.put(4,new ColorfulBox(0,0,0,100,100,100));
 }

 public ObjectBlock export(int x,int y,int z,   int newType){
   return obDic.get(newType).getCopy(x,y,z);
 }
 public ObjectBlock export(ObjectBlock obj,   int newType){
   return obDic.get(newType).getCopy(obj.x, obj.y, obj.z);
 }

}
