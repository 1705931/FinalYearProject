import org.renjin.script.RenjinScriptEngineFactory;
import org.renjin.sexp.SEXP;

import javax.script.ScriptEngine;
import javax.script.ScriptException;
import java.io.*;

public class Roperations {

    // create a script engine manager
    RenjinScriptEngineFactory factory = new RenjinScriptEngineFactory();
    // create a Renjin engine:
    ScriptEngine engine = factory.getScriptEngine();

    public String generateResults(Object repoName) throws ScriptException, IOException {
        //add an "inputData" variable, which is the file path of the json files that are generated by bandit
        engine.put("inputData", ("src\\main\\bandit_output\\"+repoName+"_vuln.json"));
        //Code to store R output in the Java program
        StringWriter outputWriter = new StringWriter();
        //set the writer of Renjin so that the output is stored in a java StringWriter
        engine.getContext().setWriter(outputWriter);
        //the output of the R script will now go to a StringWriter rather than the console
        engine.eval(new java.io.FileReader("src\\main\\Rscripts\\generateVulnStats.R"));
        //Print some statistics for a selected repository
        engine.eval("cat(\"Number of Files Scanned:\", files_scanned, \"\n\")");
        engine.eval("cat(\"Number of Vulnerable Files in the Repository:\", nrow(filename_table), \"\n\")");
        engine.eval("cat(\"Number of Issues Found:\", issues_found, \"\n\")");
        engine.eval("cat(\"Number of Lines in the Repository:\", loc_in_repo[[1]], \"\n\")");
        //Print the average line number for each severity
        engine.eval("cat(\"Average Line Number for Low Severity Issues:\", mean_low_sev, \"\n\")");
        engine.eval("cat(\"Average Line Number for Medium Severity Issues:\", mean_medium_sev, \"\n\")");
        engine.eval("cat(\"Average Line Number for High Severity Issues:\", mean_high_sev, \"\n\")");
        //Print a table showing the total number of issues for each severity
        engine.eval("cat(\"\nTotal Number of Severities: \\n\")");
        engine.eval("print(total_issue_sev)");

//        engine.eval("for(i in filename_table$filename){\n" +
//                "  print(i)\n" +
//                "}");
//        engine.eval("for (i in filename_table$line_numbers){\n" +
//                "  print(mean(as.integer(unlist(strsplit(i, \",\")))))\n" +
//                "}");
        //
//        engine.eval("cat(\"\nSummary of the tests that found vulnerabilities: \\n\")");
//        engine.eval("print(summary_table, width = 500)");
        //
        engine.eval("cat(\"\nLine Numbers for each Issue Severity: \\n\")");
        engine.eval("print(line_no_table, width = 500)");
        //
        engine.eval("cat(\"\nIssues Grouped by Filename: \\n\")");
        engine.eval("print(filename_table, width = 500)");
        //
//        engine.eval("cat(\"\nLine Number vs Issue Severity Table:\n\")");
//        engine.eval("print(issue_sev_vs_line_no)");

        //convert the StringWriter output to a String
        String output = outputWriter.toString();
        //print the result to console
//        System.out.println("The R script says:\n" + output);

        SEXP result = (SEXP)engine.eval(new java.io.FileReader("src\\main\\Rscripts\\generateVulnStats.R"));
        System.out.println("The R script says: " + result);
        // determine the Java class of the result:
        Class objectType = result.getClass();
        System.out.println("Java class is: " + objectType.getName());
        // use the getTypeName() method of the SEXP object to get R's type name:
        System.out.println("In R, typeof(res) would give '" + result.getTypeName() + "'");
        return output;
    }

    public String generateFilesScanned(Object repoName) throws ScriptException, IOException {
        engine.put("inputData", ("src\\main\\bandit_output\\"+repoName+"_vuln.json"));
        StringWriter outputWriter = new StringWriter();
        engine.getContext().setWriter(outputWriter);
        engine.eval(new java.io.FileReader("src\\main\\Rscripts\\generateVulnStats.R"));
        engine.eval("print(files_scanned)");
        String output = outputWriter.toString();
        return output;
    }
    public String generateIssuesFound(Object repoName) throws ScriptException, IOException {
        engine.put("inputData", ("src\\main\\bandit_output\\"+repoName+"_vuln.json"));
        StringWriter outputWriter = new StringWriter();
        engine.getContext().setWriter(outputWriter);
        engine.eval(new java.io.FileReader("src\\main\\Rscripts\\generateVulnStats.R"));
        engine.eval("print(issues_found)");
        String output = outputWriter.toString();
        return output;
    }
    public String generateVulnFiles(Object repoName) throws ScriptException, IOException {
        engine.put("inputData", ("src\\main\\bandit_output\\"+repoName+"_vuln.json"));
        StringWriter outputWriter = new StringWriter();
        engine.getContext().setWriter(outputWriter);
        engine.eval(new java.io.FileReader("src\\main\\Rscripts\\generateVulnStats.R"));
        engine.eval("print(nrow(filename_table))");
        String output = outputWriter.toString();
        return output;
    }
    public String generateLinesInRepo(Object repoName) throws ScriptException, IOException {
        engine.put("inputData", ("src\\main\\bandit_output\\"+repoName+"_vuln.json"));
        StringWriter outputWriter = new StringWriter();
        engine.getContext().setWriter(outputWriter);
        engine.eval(new java.io.FileReader("src\\main\\Rscripts\\generateVulnStats.R"));
        engine.eval("print(loc_in_repo[[1]])");
        String output = outputWriter.toString();
        return output;
    }
}
