%read the image
I = imread('pictures/aliens/yellow.jpg');	
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
fileID = fopen ('vhdlTable/yellow.vhd', 'w');
fprintf (fileID, 'type memoryPicture is array(0 to ');
fprintf (fileID, '%d', y-1);
fprintf (fileID, ', 0 to ');
fprintf (fileID, '%d', x-1);
fprintf (fileID, ') of integer;\n');
fprintf (fileID, 'constant picture : memoryPicture:=(\n(');
for i = 1:size(COLOR(:), 1)-1
    fprintf (fileID, '16#');
    fprintf (fileID, '%x', COLOR(i)); % COLOR (dec) -> print to file (hex)
    fprintf (fileID, '#');
    if width == 0 % line end
        fprintf (fileID, '),\n(');
        width=x-1;
    else % not end of line
        fprintf (fileID, ',');
        width=width-1;
    end
end
fprintf (fileID, '16#');
fprintf (fileID, '%x', COLOR(size(COLOR(:), 1))); % last pixel
fprintf (fileID, '#');
fprintf (fileID, '));');
fclose (fileID);

%translate to hex to see how many lines
COLOR_HEX = dec2hex(COLOR);
