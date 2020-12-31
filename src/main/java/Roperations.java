import org.renjin.script.RenjinScriptEngineFactory;

import javax.script.ScriptEngine;
import javax.script.ScriptException;
import java.io.*;

public class Roperations {

    public String testR(Object repoName) throws ScriptException, IOException {
        //Renjin attempt:
        // create a script engine manager
        RenjinScriptEngineFactory factory = new RenjinScriptEngineFactory();
        // create a Renjin engine:
        ScriptEngine engine = factory.getScriptEngine();

        engine.put("inputData", ("src\\main\\bandit_output\\"+repoName+"_vuln.json"));

        //Code to store R output in the Java program
        StringWriter outputWriter = new StringWriter();
        //set the writer of Renjin so that the output is stored in a java StringWriter
        engine.getContext().setWriter(outputWriter);
        //the output of the R script will now go to a StringWriter rather than the console
        engine.eval(new java.io.FileReader("src\\main\\Rscripts\\test.R"));
        //convert the StringWriter output to a String
        String output = outputWriter.toString();
        System.out.println("The R script says: " + output);

        // Reset output to console
        engine.getContext().setWriter(new PrintWriter(System.out));
        return output;
    }
}
