import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.sound.midi.*;
import java.util.*;
import java.io.*;
import java.net.*;

public class midi_test{
   public static void main(String[] args){  
      TextAreaFrame frame = new TextAreaFrame();
      frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
      frame.show();
   }
}

class TextAreaFrame extends JFrame{
   public TextAreaFrame(){  
		setTitle("MIDI-TEST");
		setSize(WIDTH, HEIGHT);

		myGateway = new Gateway(7777,7777);	  
		
		Container contentPane = getContentPane();

		buttonPanel = new JPanel();
		textArea = new JTextArea(4, 20);
		dispositivi=new JComboBox();
		dispositivi.setEditable(false);
		int num_device = MidiSystem.getMidiDeviceInfo().length;
		if (num_device<1){
		  System.out.println("Il sistema non possiede alcun dispositivo MIDI installato \n");
		  System.exit(0);
		}
		for (int i=0;i<num_device;i++)
		 dispositivi.addItem(MidiSystem.getMidiDeviceInfo()[i].getName());

		buttonPanel.add(dispositivi);
					  
		startBtn = new JButton("START");
		buttonPanel.add(startBtn);
		startBtn.addActionListener(new
		 ActionListener()
		 {
		    public void actionPerformed(ActionEvent event)
		    {
		
				int current_device=dispositivi.getSelectedIndex();
				
				String str;
				str="device info:\n"+MidiSystem.getMidiDeviceInfo()[0].toString()+"\n";				
				try{
					myTDevice=MidiSystem.getMidiDevice(MidiSystem.getMidiDeviceInfo()[current_device]);
					MidiIn m=new MidiIn(myTDevice,textArea,myGateway);
						
				}catch (Exception e){
					str+="ERROR\n"+e;
				}
			   textArea.append(str);
		    }
		 });
		contentPane.add(buttonPanel, BorderLayout.NORTH);
	
		scrollPane = new JScrollPane(textArea);
		contentPane.add(scrollPane, BorderLayout.CENTER);
   }

   public static final int WIDTH = 400;
   public static final int HEIGHT = 200;  

   private Gateway myGateway;
   private MidiDevice myDevice;
   private MidiDevice myTDevice;
   private MidiDevice myRDevice;	
   private Transmitter myT;
   private Receiver myR;
   private JTextArea textArea;
   
   private JScrollPane scrollPane;
   private JPanel buttonPanel;
   private JButton startBtn;     
   private JComboBox dispositivi; 
}


class Gateway {
    private OscServer oscServer;
    private TcpServer tcpServer;

    public Gateway(int oscPort, int flashPort) {
        System.out.println("Attempting to start OSC / Flash Gateway server");
	// --- create the servers
	oscServer = new OscServer(oscPort, this);
	tcpServer = new TcpServer(flashPort, this);
	// --- start their threads
	oscServer.start();
	tcpServer.start();
    }

    public void broadcastMessage(String message) {
    tcpServer.broadcastMessage(message);
    }

    public void sendPacket(OscPacket packet) {
    Debug.writeActivity("Gateway transporting OSC packet.");
    oscServer.sendPacket(packet);
    }
}




class MidiIn implements Receiver {
    private final Transmitter inputTrans;

	private MidiDevice mOUT ;
	private JTextArea myT;
	private Gateway myG;
	
    public MidiIn (MidiDevice MidiOUT,JTextArea T,Gateway G ) throws MidiUnavailableException {
		myT=T;
		myG=G;
		mOUT = MidiOUT;
		mOUT.open();
		inputTrans=mOUT.getTransmitter();
		inputTrans.setReceiver(this);
		System.out.println("APERTO");
    }

	public void close(){
		this.close();
	}

   public void send(MidiMessage message, long deltaTime){
		ShortMessage shortMessage = (ShortMessage) message;
		// get messageInfos
		int midiChannel = shortMessage.getChannel();
		int midiCommand = shortMessage.getCommand();
		int midiData1 = shortMessage.getData1();
		int midiData2 = shortMessage.getData2();
		myT.setText(midiChannel+"	"+midiCommand+"	"+midiData1+"	"+midiData2+"\n");
		myG.broadcastMessage(midiChannel+"	"+midiCommand+"	"+midiData1+"	"+midiData2+"\n");
//		System.out.println("channel:"+midiChannel+"command"+midiCommand+"data1"+midiData1+"data2"+midiData2);	
	}
}
