%sFile = 'MelexisOutput.csv';
if ~isempty(instrfind)
     fclose(instrfind);
      delete(instrfind);
end
clear all; 
filename='C:\Users\kmana\Desktop\Matlab\MLX_Read.csv'; % filename here
writeFileName='C:\Users\kmana\Desktop\Matlab\SensorData.csv'; % file to write to 
% add method to write to file
  % if the file does not exists, read instrumentation
    delete(instrfindall);   %pre-emptively close all ports
    s1 = serial('COM8');    %define serial port to read the Arduino
    s1.BaudRate=115200;     %define baud rate
	s1.InputBufferSize=2^21; % increase the buffer size 2^29 is the maximum accepted
	s1.Terminator = 'CR'; % this is different for different files
    fopen(s1);
    s1.ReadAsyncMode = 'continuous';
    fileID = fopen(filename,'w');
    
    while(s1.BytesAvailable <= 0)  %wait until Arduino outputs data 
        
    end
    mData=zeros(1,768); % initialize data array
    mPktCnt = zeros(1,65000);
    for i = 1:35000
        sSerialData = fscanf(s1); %read sensor inside the loop
        t = strsplit(sSerialData,','); % same character as the Arduino code
        for j=1:768
            mData(j) = str2double(t(j));
            fprintf(fileID, '%2.2f,', mData(j));
        end
        mPktCnt(i) = mData(1);
        mData
        fprintf(fileID, '\n');
    end  
     
    fclose(s1);
    fclose(fileID);
    delete(s1);
    delete(instrfindall);    % close the serial port
