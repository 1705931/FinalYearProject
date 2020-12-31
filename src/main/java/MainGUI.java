import javax.script.ScriptException;
import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

public class MainGUI extends JFrame{
    private JButton analyseRepoButton;
    private JPanel rootPanel;
    private JComboBox repoSelector;
    private JButton analyseResultButton;
    private JLabel rOutput;
    String[] dirnames; //this array stores the names of directories
    File f = new File("D:\\IntelliJ Projects\\VulinOSS\\vulinoss"); //path of where the directories
    Roperations r = new Roperations();

    public MainGUI()
    {
        //This uses the designer form
        add(rootPanel);

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
                    Runtime.getRuntime().exec("cmd /c start cmd.exe /K \"cd ..\\VulinOSS\\vulinoss && bandit -r " + repoSelector.getSelectedItem() + " -f json -o ..\\..\\FinalYearProject\\src\\main\\Rscripts\\bandit_output\\" + repoSelector.getSelectedItem() + "_vuln.json");
                } catch (Exception ex) {
                    System.out.println(ex);
                    ex.printStackTrace();
                }
            }
        });

        analyseResultButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    String result = r.testR(repoSelector.getSelectedItem());
                    rOutput.setText(result);
                } catch (ScriptException | FileNotFoundException scriptException) {
                    scriptException.printStackTrace();
                } catch (IOException ioException) {
                    ioException.printStackTrace();
                }
            }
        });
    }
}
