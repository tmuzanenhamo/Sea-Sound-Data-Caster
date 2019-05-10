close all; clear all; clc;

in = input("Choose an option: ");

while (in != 0)

	if(in == 1)
		[FileName,PathName] = uigetfile('*.wav', 'Select audio file.');
		[~,audio.name] = fileparts(FileName);
		[audio.data, audio.fs] = audioread([PathName FileName]);

		file = 'text.txt';
		fid  = fopen(file, 'r');
		text = fread(fid,'*char')';
		fclose(fid);

		out = phase_enc(audio.data, text);
		audiowrite([audio.name,'_encoded.wav'], out, audio.fs);

		disp(['The encoded Signal is saved in ', PathName, audio.name, '_encoded.wav']);
    
    in = input("Choose an option: ");
    
    

	else
		fname = 'OceanWaves.wav';
		[y,fs]=audioread(fname);
		[FileName,PathName] = uigetfile('*.wav', 'Select audio file.');
		audio.data = audioread([PathName FileName]);

		file = 'text.txt';
		fid  = fopen(file, 'r');
		text = fread(fid,'*char')';
		fclose(fid);

		msg = phase_dec(audio.data, length(text));

		err = BER(text,msg);
		nc  = NC(text, msg);

		fprintf('Text: %s\n', msg); fprintf('BER : %d\n', err);
		fprintf('NC  : %d\n', nc);

		% Display the sampling info and length
		sz = size(y);
		n  = sz(1);
		printf('File: %s\nSamples: %d\nTime   : %d s\n',fname,n,n/fs);
		%printf("%d",y);

		% If longer than 500,000 samples cut if down else things are too slow!
		if (n>500000)
   		n=500000;
   		printf('Samples cropped to %d\n',n);
		end;

		% create time stamps for graph
		x = [0:1/fs:(n-1)/fs];

		% Display the graph
		plot(x,y(1:n));

		player = audioplayer(y,fs);
		play(player);


		break

	endif

end 
