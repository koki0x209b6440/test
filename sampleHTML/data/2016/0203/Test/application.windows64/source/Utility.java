
import java.io.IOException;

import java.io.ByteArrayOutputStream;
import java.io.ObjectOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ObjectInputStream;

//http://www.javaroad.jp/java_io7.htm
//http://d.hatena.ne.jp/amachang/20100326/1269585997
//http://www.atsuhiro-me.net/processing/serializable

public class Utility{
   
  public static Object deepClone(Object from) {
    ByteArrayOutputStream out=null;
    ObjectOutputStream outObj=null;
    ByteArrayInputStream in=null;
    ObjectInputStream inObj=null;
    Object clone=null;
     try{
        out = new ByteArrayOutputStream();
        outObj = new ObjectOutputStream(out);
        outObj.writeObject(from);
        outObj.flush();
        
        in = new ByteArrayInputStream(out.toByteArray() );
        inObj = new ObjectInputStream(in);
        clone = inObj.readObject();
     }catch(IOException e){
       //e.printStackTrace();
     }catch(ClassNotFoundException e){ 
       //
     }finally{
       try{
         if(out!=null)out.close();
         if(outObj!=null)outObj.close();
         if(in!=null)in.close();
         if(inObj!=null)inObj.close();
       }catch(IOException e){
         //
       }
     }
     
      return clone;
    }
}
