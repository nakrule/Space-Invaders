%read the image
I = imread('map/startScreen.jpg');	
[x,y,z] = size(I); % x = width, y = heigh
width = x-1;
		
%Extract RED, GREEN and BLUE components from the image
R = I(:,:,1);			
G = I(:,:,2);
B = I(:,:,3);

%make the numbers to be of double format for 
R = double(R);	
G = double(G);
B = double(B);

%Raise each member of the component by appropriate value. 
R = R.^(3/8); % 8 bits -> 3 bits
G = G.^(3/8); % 8 bits -> 3 bits
B = B.^(1/4); % 8 bits -> 2 bits

%tranlate to integer
R = uint8(R); % float -> uint8
G = uint8(G);
B = uint8(B);

%minus one cause sometimes conversion to integers rounds up the numbers wrongly
R = R-1;
G = G-1;
B = B-1;

%shift bits and construct one Byte from 3 + 3 + 2 bits
G = bitshift(G, 2);
R = bitshift(R, 5);
COLOR = R+G+B;

%save variable COLOR to a file in HEX format for the chip to read
fileID = fopen ('coe/startScreen.coe', 'w');
fprintf(fileID, 'memory_initialization_radix=16;\n');
fprintf(fileID, 'memory_initialization_vector=\n');

for i = 1:size(COLOR(:), 1)-1
    fprintf (fileID, '%x', COLOR(i)); % COLOR (dec) -> print to file (hex)
    fprintf (fileID, ',\n');
end
fprintf (fileID, '%x;', COLOR(size(COLOR(:), 1))); % last pixel
fclose (fileID);

%translate to hex to see how many lines
COLOR_HEX = dec2hex(COLOR);
