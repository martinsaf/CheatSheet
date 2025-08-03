#List available sniffinf interfaces
tshark -D

#Choose an interface to capture live traffic
tshark -i 1
tshark -i ens55

#Sniff the traffic like tcpdump
tshark

#Read/input function. Read a capture file
tshark -r demo.pcapng

#Packet count. Stop after capturing a specified number of packets.
##E.g. stop after capturing/filtering/reading 10 packets
tshark -c 10

#Read by count, show only the first 2 packets.
tshark -r demo.pcapng -c e

#Write/ouput function. Write the sniffed traffic to a file
tshark -w sample.capture.pcap

#Read the first packet of the demo.pcapng, create write-demo.pcap and save the first packet there.
tshark -r demo.pcapng -c 1 -w write-demo.pcap

#Read the write-demo.pcap and show the packet bytes/details.
tshark -r write-demo.pcap

#Read the packets from write-demo.pcap and show the packet byte/details
tshark -r write-demo.pcap -x

##Verbose. 
###Provide detailed information for each packet. This option will provide details similar to Wireshark's "Packet Details Pane".
tshark -V

##Verbosity
tshark -r demo.pcapng -c 1 -V

##Silent mode.
###Suspress the packet output on the terminal.
tshark -q

##Display packet bytes.
###Show packet details in hex and ASCII dump for each packet.
tshark -x
