
/*
  構文解析による、計算式の計算結果演算
  例：　(4+2)/3=2
*/

import java.io.*;

public class SimpleCalculator {
    static final int EOF = StreamTokenizer.TT_EOF;
    static final int EOL = StreamTokenizer.TT_EOL;
    static final int NUMBER = StreamTokenizer.TT_NUMBER;
    
    StreamTokenizer scanner;
    
    public static void main(String[] args) {
        try {
            InputStreamReader r = new InputStreamReader(System.in);
            StreamTokenizer st = new StreamTokenizer(new BufferedReader(r));
            SimpleCalculator calculator = new SimpleCalculator(st);
            
            for (;;) {
                while (st.nextToken() == EOL)
                    ;    // skip empty lines
                
                if (st.ttype == EOF)
                    break;
                else {
                    st.pushBack();
                    System.out.println("Answer: " + calculator.expression());
                }
            }
        }
        catch (Exception e) {
            System.err.println(e);
            System.exit(1);
        }
    }
    
    
    SimpleCalculator(StreamTokenizer st) {
        scanner = st;
        
        scanner.ordinaryChar('/');
        scanner.slashStarComments(true);
        scanner.slashSlashComments(true);
        scanner.eolIsSignificant(true);
    }
    
    /*
     * <expression> ::= <term> { [`+'|`-'] <factor> }
     * <factor> ::= <primary> { [`*'|`/'|`%'] <primary> }
     * <primary> ::= <number> | `(' <expression> `)'
     */
    
    double expression() throws Exception {
        double x, y;
        int tok;
        
        x = term();
        for (;;) {
            switch (scanner.nextToken()) {
                case EOF:
                case EOL:
                case ')':
                    scanner.pushBack();
                    return x;
                case '+':
                    y = term();
                    x = x + y;
                    break;
                case '-':
                    y = term();
                    x = x - y;
                    break;
                case NUMBER:
                    throw new Exception("Unexpected Number " + scanner.nval);
                default:
                    throw new Exception("Unexpected " + (char)scanner.ttype);
            }
        }
    }
    
    double term() throws Exception {
        double x, y;
        
        x = primary();
        for (;;) {
            switch (scanner.nextToken()) {
                case EOF:
                case EOL:
                case ')':
                case '+':
                case '-':
                    scanner.pushBack();
                    return x;
                case '*':
                    y = primary();
                    x = x * y;
                    break;
                case '/':
                    y = primary();
                    x = x / y;
                    break;
                case NUMBER:
                    throw new Exception("Unexpected Number " + scanner.nval);
                default:
                    throw new Exception("Unexpected " + (char)scanner.ttype);
            }
        }
    }
    
    double primary() throws Exception {
        double x;
        
        switch (scanner.nextToken()) {
            case '(':
                x = expression();
                if (scanner.nextToken() == ')')
                    return x;
                else
                    throw new Exception("parenthes mismatch");
            case NUMBER:
                return scanner.nval;
            default:
                throw new Exception("Syntax Error");
        }
    }
}

