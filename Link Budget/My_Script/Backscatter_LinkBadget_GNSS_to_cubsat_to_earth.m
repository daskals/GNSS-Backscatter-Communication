%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Spiros Daskalakis                               %
%     last Revision 12/4/2019                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Sources: Paper title: "GNSS satellite transmit power and its impact on
%orbit determination"
close all;
clear all;
clc;

%GPS L1C  civilian-use
%Circular orbits with satellite altitude of 23222 km
DistanceGNSSSatteliteAntenna=2.23222E+07;
% Galileo signal at L1 is broadcast at 1575.42 MHz from any satellite
Frequency=1575.42e6;
lambda = physconst('LightSpeed')/Frequency;

%Sattelite EIRP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TransmitterPowerW=265; %Watts 
TransmitterPowerdBm = 10*log10(TransmitterPowerW/(1))+30;  %dBm
RF_Losses_trasmitter_path=-1.25; %dB
Transmitter_Antenna_Gain=14;   %dBi
Satellite_EIRP_dBm=TransmitterPowerdBm+RF_Losses_trasmitter_path+Transmitter_Antenna_Gain;  %dBm

%%%%%%%%%%%%%%%%%%RX antenna Earth%%%%%%%%%%%%%%%%%%%%%%%%%%%
RX_ant_gain=26; %(dBi) for 1.5 m parabolic antenna with 0.7 efficiency

%%%%%%%%%%%%%%%%%%% Earth receive%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Free space losses GNSS to earth
FSL_transmitter_receiver_losses=20*log10((4*pi*DistanceGNSSSatteliteAntenna)/lambda);
%Receive Power at earth from GNSS satellite 
Preceived_earth_dBm=Satellite_EIRP_dBm+RX_ant_gain-FSL_transmitter_receiver_losses

%Tag satellite
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%https://www.isispace.nl/product/dipole-antenna-system/
Tag_ant_gain=7; %db
Dist_tag_to_earth=500000; %%LEO amblitude 500-1000 Km
Dist_GNSS_to_cubesat=DistanceGNSSSatteliteAntenna-Dist_tag_to_earth;
%Bascatter loads at the cubesat
Za=50+j*0;
Zl1=11+j*145;
Zl2=8-j*205;
G1=(Za'-Zl1)/(Za+Zl1);
G2=(Za'-Zl2)/(Za+Zl2);

%%%%%%Free space losses from GNSS to tag
FSL_transmitter_tag_losses=20*log10((4*pi*Dist_GNSS_to_cubesat)/lambda);
%The backscattered power available from the tag is:
P_tag_available_dBm=Satellite_EIRP_dBm-FSL_transmitter_tag_losses+2*Tag_ant_gain+20*log10(abs(G1'-G2'))

%Free space losses from tag to earth:
FSL_tag_receiver=20*log10((4*pi*Dist_tag_to_earth)/lambda);
%Recieved power at earth from the tag is:
P_tag_recieve_dBm=P_tag_available_dBm+RX_ant_gain-FSL_tag_receiver


