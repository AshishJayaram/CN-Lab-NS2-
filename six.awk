BEGIN {
	FTPPackets = 0;
	FTPSize = 0;
	CBRPackets = 0;
	CBRSize = 0;
}

{
	event=$1;
	packetType= $5;
	packetsize= $6;
	if(event == "r" && packetType == "tcp")
	{
		FTPPackets++;
		FTPSize = packetsize;
	}
	if(event == "r" && packetType == "cbr")
	{
		CBRPackets++;
		CBRSize = packetsize;
	}
}

END {
	totalFTP=FTPPackets*FTPSize;
	totalCBR=CBRPackets*CBRSize;
	printf("\nThe throughput of FTP application is %d Bytes per second \n", totalFTP/123.0);
	printf("\nThe throughput of CBR application is %d Bytes per second \n", totalFTP/124.0);
}
