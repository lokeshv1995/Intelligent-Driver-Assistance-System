
%% open the serial port
s = serial('COM52');
        
set(s,'BaudRate',9600, 'Parity','none', 'Terminator', '!', 'InputBufferSize', 4500);
fopen(s);

count=1;

imleft=imread('left1.jpg');
imright=imread('right1.jpg');
imbreak = imread('sp1.jpg');


%% capture all serial data in infinite loop
while count==1
    
    A = fgetl(s);
    A
    if length(A)<2
        pause(1);
        continue;
    end
    A=strrep(A,'!','');
    res = strsplit(A,',')
    tsign=str2num(char(res(1)));
    tspeed=str2num(char(res(2)));
    
    if tsign==0
        [x,Fs,nbits]= wavread('left.wav');
        wavplay(x,Fs);
        figure
        imshow(imleft);
        
    end
    
    if tsign==1
         [x,Fs,nbits]= wavread('right.wav');
         wavplay(x,Fs);
         imshow(imright);
    end
    
    if tsign==2
               
        [x,Fs,nbits]= wavread('speedbrake.wav');
         wavplay(x,Fs);
         imshow(imbreak);
    end
    
    if tsign==3
       fprintf(1,'Vehicle Stopped\n');
       break;
        
    end
    
    accr=rand(1)*20;
    fprintf(1,'Random value generated %f \n',accr);
    if (accr>10)
        accr=accr-20;        
    end

    fprintf(1,'The current acceraleration value is %f \n',accr);
    
    if tspeed>0
        fprintf(1,'Reduce Your Speed to  %d \n',tspeed);
        
        if (accr>0)
              fprintf(1,'!!! Vehicle cannot accelearate in this situation, overspeed set, pls decelerate\n');
        else
              fprintf(1,'!!!Vehicle decelerating \n');
        end    
        [x,Fs,nbits]= wavread('overspeed.wav');
        wavplay(x,Fs);
        
    end
    
    pause(10);
end

 fclose(s);
 