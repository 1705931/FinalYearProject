import org.apache.maven.scm.provider.ScmProviderRepositoryWithHost;

import javax.script.ScriptException;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class MainGUI extends JFrame{
    private JButton analyseRepoButton;
    private JPanel rootPanel;
    private JComboBox repoSelector;
    private JButton showResultsButton;
    private JTextArea rOutputArea;
    private JButton loadReposButton;
    private JButton generateNumberOfVulnFilesButton;
    private JButton generateLinesInRepoButton;
    String[] dirNames; //this array stores the names of directories
    Roperations r = new Roperations();

    public MainGUI()
    {
        //Create a JScrollPane, add the JPanel and a scroll bar to it
        JScrollPane scroller = new JScrollPane(rootPanel);
        this.getContentPane().add(scroller, BorderLayout.CENTER);
        add(scroller);
        //Set the title of the program
        setTitle("Python Repo Analyser");
        //Set the size of the window
        setSize(1200, 1000);
        //Set the default operation to terminate the program if the GUI is closed
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        //Set the output text area to wrap
        rOutputArea.setLineWrap(true);

        loadReposButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                JFileChooser dirChooser = new JFileChooser();
                dirChooser.setDialogTitle("Choose a Source of Data");
                dirChooser.setCurrentDirectory(new File(System.getProperty("user.home")));
                dirChooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
                int result = dirChooser.showOpenDialog(null);
                if (result == JFileChooser.APPROVE_OPTION) {
                    repoSelector.removeAllItems();
                    File selectedFolder = dirChooser.getSelectedFile();
                    for (String s : dirNames = selectedFolder.list()){
                        repoSelector.addItem(s);
                    }
                }
            }
        });

        analyseRepoButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e)
            {
                try{
                    Runtime.getRuntime().exec("cmd /c start cmd.exe /K \"cd ..\\VulinOSS\\vulinoss && bandit -r " + repoSelector.getSelectedItem() + " -f json -o ..\\..\\FinalYearProject\\src\\main\\bandit_output\\" + repoSelector.getSelectedItem() + "_vuln.json");
                } catch (Exception ex) {
                    System.out.println(ex);
                    ex.printStackTrace();
                }
            }
        });

        showResultsButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    String result = r.generateResults(repoSelector.getSelectedItem());
                    rOutputArea.setText("");
//                    rOutputArea.append(result + result.length());
                    rOutputArea.append(result);
//                    if(result.length() > 1000){
//                        File resultTable = new File("test.txt");
//                            System.out.println("File created: " + resultTable.getName());
//                            FileWriter writer = new FileWriter("test.txt");
//                            writer.write(result);
//                            writer.close();
//                            System.out.println("Write Successful");
//                    }
                } catch (ScriptException | IOException scriptException) {
                    scriptException.printStackTrace();
                }
            }
        });

        generateNumberOfVulnFilesButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try{
                    String result = r.generateVulnFiles(repoSelector.getSelectedItem());
                    rOutputArea.setText("");
                    rOutputArea.append(result);
                    FileWriter csvWriter = new FileWriter("vuln_files_lines_in_repo.csv", true);
                    csvWriter.append(result);
                    csvWriter.append(",");
                    csvWriter.flush();
                    csvWriter.close();
                } catch (ScriptException | IOException scriptException) {
                    scriptException.printStackTrace();
                }
            }
        });

        generateLinesInRepoButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try{
                    String result = r.generateLinesInRepo(repoSelector.getSelectedItem());
                    rOutputArea.setText("");
                    rOutputArea.append(result);
                    FileWriter csvWriter = new FileWriter("vuln_files_lines_in_repo.csv", true);
                    csvWriter.append(result);
                    csvWriter.flush();
                    csvWriter.close();
                } catch (ScriptException | IOException scriptException) {
                    scriptException.printStackTrace();
                }
            }
        });
    }
}
