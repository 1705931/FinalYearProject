import com.github.rcaller.rstuff.RCaller;
import com.github.rcaller.rstuff.RCode;
import com.github.rcaller.scriptengine.RCallerScriptEngine;
import org.renjin.script.RenjinScriptEngineFactory;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;
import java.io.FileNotFoundException;

public class Roperations {

    public void testR() throws ScriptException, FileNotFoundException {
        //Renjin attempt:
        // create a script engine manager
        RenjinScriptEngineFactory factory = new RenjinScriptEngineFactory();
        // create a Renjin engine:
        ScriptEngine engine = factory.getScriptEngine();
        engine.eval(new java.io.FileReader("D:\\IntelliJ Projects\\FinalYearProject\\src\\Rscripts\\test.R"));
    }
}
