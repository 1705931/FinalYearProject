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
    private final JFileChooser dirSelector = new JFileChooser();
    String[] dirNames; //this array stores the names of directories
    File f = new File("D:\\IntelliJ Projects\\VulinOSS\\vulinoss"); //path of where the directories are
    Roperations r = new Roperations();

    public MainGUI()
    {
        //Create a JScrollPane, add the JPanel and a scroll bar to it
        JScrollPane scroller = new JScrollPane(rootPanel);
        this.getContentPane().add(scroller, BorderLayout.CENTER);
        add(scroller);

//        dirSelector.setDialogTitle("Choose a Python Repository");
//        dirSelector.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);

        //For each directory name, add it to the repoSelector JComboBox
        for (String s : dirNames = f.list()) {
            repoSelector.addItem(s);
        }
        //Set the title of the program
        setTitle("Python Repo Analyser");
        //Set the size of the window
        setSize(1200, 1000);
        //Set the default operation to terminate the program if the GUI is closed
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        //Set the output text area to wrap
        rOutputArea.setLineWrap(true);

//        loadReposButton.addActionListener(new ActionListener() {
//            @Override
//            public void actionPerformed(ActionEvent e) {
//                if (dirSelector.showOpenDialog(null) == JFileChooser.APPROVE_OPTION){
//                    File file = dirSelector.getCurrentDirectory();
//                    System.out.println(file);
//                    String fileName = file.getAbsolutePath();
//                    System.out.println(fileName);
//                    File f = new File(fileName);
//                    //For each directory name, add it to the repoSelector JComboBox
//                    for (String s : dirNames = f.list()) {
//                        repoSelector.addItem(s);
//                    }
//                }
//            }
//        });

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
                    rOutputArea.append(result + result.length());
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
    }
}
