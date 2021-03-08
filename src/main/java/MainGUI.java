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
    private JComboBox repoSelector; //dropdown menu for choosing a repo
    private JButton showResultsButton; //generate results button
    private JTextArea rOutputArea; //results area
    private JButton loadReposButton; //load repos button
    private JButton showTablesButton; //generate tables button
    String[] dirNames; //this array stores the names of directories
    String targetPath; //needed for running Bandit on the correct repo
    Roperations r = new Roperations(); //instance of the Roperations class

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
                    targetPath = selectedFolder.getAbsolutePath();
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
                    System.out.println(targetPath);
                    if (targetPath != null){
                        Runtime.getRuntime().exec("cmd /c start cmd.exe /K \"cd " + targetPath + " && bandit -r " + repoSelector.getSelectedItem() + " -f json -o ..\\..\\FinalYearProject\\src\\main\\bandit_output\\" + repoSelector.getSelectedItem() + "_vuln.json");
                    } else {
                        rOutputArea.setText("");
                        rOutputArea.append("Make sure to load a repository first!");
                    }
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
                } catch (Exception exception) {
                    rOutputArea.setText("");
                    rOutputArea.append("No vulnerabilities found, make sure there are Python files in the repository");
                    exception.printStackTrace();
                }
            }
        });

        showTablesButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    String result = r.generateTables(repoSelector.getSelectedItem());
                    rOutputArea.setText("");
                    if(result.length() > 5000) {
                        File resultTable = new File(repoSelector.getSelectedItem()+"_table.txt");
                        System.out.println("File created: " + resultTable.getName());
                        FileWriter writer = new FileWriter(repoSelector.getSelectedItem()+"_table.txt");
                        writer.write(result);
                        writer.close();
                        System.out.println("Write Successful");
                    } else {
                        rOutputArea.append(result);
                    }
                } catch (Exception exception) {
                    rOutputArea.setText("");
                    rOutputArea.append("No vulnerabilities found, make sure there are Python files in the repository");
                    exception.printStackTrace();
                }
            }
        });
    }
}
