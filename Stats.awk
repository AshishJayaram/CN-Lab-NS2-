BEGIN{
	packetlost=0;
}
	{
		event=$1;
		packettype=$5;
		if(packettype=="cbr")
		{
			if(event=="-")
				packetlost++;

		}
	}
END{printf("Number of packets lost is %d",packetlost);}
			
