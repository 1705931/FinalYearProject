import javax.script.ScriptException;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.IOException;

public class MainGUI extends JFrame{
    private JButton analyseRepoButton;
    private JPanel rootPanel;
    private JComboBox repoSelector;
    private JButton showTableButton;
    private JTextArea rOutputArea;
    private JButton generateCSVButton;
    private JButton generateResults;
    String[] dirnames; //this array stores the names of directories
    File f = new File("D:\\IntelliJ Projects\\VulinOSS\\vulinoss"); //path of where the directories are
    Roperations r = new Roperations();

    public MainGUI()
    {
        //Create a JScrollPane and add the JPanel to it
        JScrollPane scroller = new JScrollPane(rootPanel);
        this.getContentPane().add(scroller, BorderLayout.CENTER);
        add(scroller);

        //for each directory name, add it to the repoSelector JComboBox
        for (String s : dirnames = f.list()) {
            repoSelector.addItem(s);
        }

        setTitle("Python Repo Analyser");
        setSize(400, 500);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        analyseRepoButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e)
            {
                try{
//                    Runtime.getRuntime().exec("cmd /c start cmd.exe /K \"cd ..\\VulinOSS\\vulinoss && bandit -r " + repoSelector.getSelectedItem() + " -f json -o ..\\data\\python_output\\" + repoSelector.getSelectedItem() + "_vuln.json");
                    Runtime.getRuntime().exec("cmd /c start cmd.exe /K \"cd ..\\VulinOSS\\vulinoss && bandit -r " + repoSelector.getSelectedItem() + " -f json -o ..\\..\\FinalYearProject\\src\\main\\bandit_output\\" + repoSelector.getSelectedItem() + "_vuln.json");
                } catch (Exception ex) {
                    System.out.println(ex);
                    ex.printStackTrace();
                }
            }
        });

        showTableButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    String result = r.generateTable(repoSelector.getSelectedItem());
                    rOutputArea.setText("");
                    rOutputArea.append(result);
                } catch (ScriptException | IOException scriptException) {
                    scriptException.printStackTrace();
                }
            }
        });

        generateCSVButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    String result = r.generateCSV(repoSelector.getSelectedItem());
                    rOutputArea.setText("");
                    rOutputArea.append(result);
                } catch (ScriptException | IOException scriptException) {
                    scriptException.printStackTrace();
                }
            }
        });

        generateResults.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    String result = r.generateResults(repoSelector.getSelectedItem());
                    rOutputArea.setText("");
                    rOutputArea.append(result);
                } catch (ScriptException | IOException scriptException) {
                    scriptException.printStackTrace();
                }
            }
        });
    }
}
