
import java.io.*;

String getCal(String calstr)
{
   try
   {
     double answer=calculate(calstr);
     calstr="=  "+answer;
   }catch (Exception e)
   {
     calstr="=  Error";
   }
   return calstr;
}

static double calculate(String calstr) throws Exception
{
  
  StringReader r = new StringReader(calstr);
  StreamTokenizer st = new StreamTokenizer(r);
  SimpleCalculator calculator = new SimpleCalculator(st);
  return calculator.expression();
  
}
