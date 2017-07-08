
close all;
%% this loads startIndex and dirPath to workspace
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function [experimental, test] = framework(dirPath)
    dirPath= 'allPhotos';
    setFile = 'settings.mat';
    %this checks if file exists
    %https://www.mathworks.com/matlabcentral/answers/49414-check-if-a-file-exists
    if exist(setFile,'file')~=2
        disp('file does not exist');
        m = matfile(setFile);
        startIndex = 0;
        save(setFile);
    else
        load(setFile);
        disp('file exists');
        %provide option to change environment vars, resave
        %command is: save('settings','name-of-var','var','etc.');
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PUT all photos into EXPERIMENTAL var -
%rng(3);
folderName = strcat(dirPath, '/*.jpg'); 
orgFiles = dir(folderName);
Files = orgFiles(randperm(length(orgFiles)));
fLen = length(Files);

%store only the pic name
experimental={};

for i=1:fLen
    
    %turn all field images into country images
    prefix = Files(i).name(1:5);
    if strcmp(prefix,'field')
%         disp(Files(i));
        newName = strcat('country_1' ,Files(i).name(8:end));
        ext = strcat(dirPath,'/');
        movefile(strcat(ext,Files(i).name),strcat(ext,newName));
        
    end
%     disp(Files(i));
%     pause;
    
end
for k=1:fLen
   experimental{k} = Files(k); 
end



%% This creates the table and visualizes the results
%each feature gets an array to construct table
name = cell(0);
hArray = cell(0);
sArray = cell(0);
vArray = cell(0);
v_ir_Array = cell(0);

topHArray = cell(0);
topSArray = cell(0);
topVArray = cell(0);

midHArray = cell(0);
midSArray = cell(0);
midVArray = cell(0);

botHArray = cell(0);
botSArray = cell(0);
botVArray = cell(0);

quantLinesArray = cell(0);
strengthLinesArray = cell(0);

hogArray = cell(0);

lpqArray = cell(0);

VISUALIZE =   false;
for f = 1 : size(experimental,2)
   %get the picture going **********************
   figure(1);
   img = imread([dirPath,'/', experimental{f}.name]);
   %FIX THIS!!!!!!!
   color_image = img( 204: 585, 204 : 586, :);
   ir_image = img( 204: 585, 597 : 1172, :);
  % figure(2);
   %image(ir_image);
   %pause;
   %    NAME array ***************************
   regName= regexp(experimental{f}.name,'\w+[a-z]','match');
   %catch only 'coutry' not 'jpg' by doing regName(1) 
   %this works!
   name = [name; regName(1)];
   
  %% the arrays --------------------------------------------------------------
  %     HUE HIST array ************************
   hImg = rgb2hsv(color_image);
   hue = hImg(:,:,1);
   %automatically does it with 10 bins
   h_hist = hist(double(hue(:)));%),[0:1]);
   hArray = [hArray;h_hist];
   
   %    SATURATION HIST array *****************
   sat = hImg(:,:,2);
   s_hist = hist(double(sat(:)));
   sArray = [sArray;s_hist];

   %    VALUE HIST array **********************
        %for ir img
   irImg = rgb2hsv(ir_image);
   val = irImg(:,:,3);
   v_hist = hist(double(val(:)));
   v_ir_Array = [vArray;v_hist];
   
         %for color image
   val = hImg(:,:,3);
   v_hist = hist(double(val(:)));
   vArray = [vArray;v_hist];
   
   
   %    TOP-MIDDLE-BOTTOM for Sat + val *****************
   fullSize = size(color_image);
   fSize = fullSize(1);
   third = idivide(int8(fSize),int8(3),'floor');
   %    get top-mid-bottom
   top = color_image(1:third,:,:);
   middle = color_image(third:third*2,:,:);
   tThird = double(third*2);
   bot = color_image(tThird:end,:,:);
   
   %    top array **********
   tHue = top(:,:,1);
   tHue_hist = hist(double(tHue(:)));
   topHArray = [topHArray;tHue_hist];
   
   
   tSat = top(:,:,2);
   tSat_hist = hist(double(tSat(:)));
   topSArray = [topSArray;tSat_hist];
   
   tVal = top(:,:,1);
   tVal_hist = hist(double(tVal(:)));
   topVArray = [topVArray;tVal_hist];
   
   %    mid array **********
   mHue = middle(:,:,1);
   mHue_hist = hist(double(mHue(:)));
   midHArray = [midHArray;mHue_hist];
   
   mSat = middle(:,:,1);
   mSat_hist = hist(double(mSat(:)));
   midSArray = [midSArray;mSat_hist];
   
   mVal = middle(:,:,1);
   mVal_hist = hist(double(mVal(:)));
   midVArray = [midVArray;mVal_hist];
   
   
   %    bot array **********
    bHue = bot(:,:,1);
    bHue_hist = hist(double(bHue(:)));
    botHArray = [botHArray;bHue_hist];
    
    bSat = bot(:,:,2);
    bSat_hist = hist(double(bSat(:)));
    botSArray = [botSArray;bSat_hist];
    
    bVal = bot(:,:,3);
    bVal_hist = hist(double(bVal(:)));
    botVArray = [botVArray;bVal_hist];
%    %% hough transform -----------------------------------------------------
    %   HOUGH transform *******************************
    %   from https://www.mathworks.com/help/images/hough-transform.html
   
    %   make the lines **********
    %didn't specify that it needed to be in grayscale
    %but from research this summer I know it should be,
    gray = rgb2gray(color_image);
    BW = edge(gray,'canny');
    [H,theta,rho] = hough(BW);
    P = houghpeaks(H,10,'threshold',ceil(0.001*max(H(:))));
    %check for default max?
    lines = houghlines(BW,theta,rho, P,'FillGap',3,'MinLength',25);
    
    %   quantify the lines *******
    %quantity of lines
    area = fullSize(1) * fullSize(2);
    numLines = length(lines);
    quantLines = numLines / area;
    quantLinesArray = [quantLinesArray;quantLines];
    
    %strength of lines
     if numLines > 0
        sum = 0;
        for k = 1:numLines
            len = norm(lines(k).point1 - lines(k).point2);
            sum = sum + len;
        end
        strengthOfLines = sum / numLines;
     else
         strengthOfLines = 0;
    
     end
     strengthLinesArray = [strengthLinesArray; strengthOfLines];

     %% Histogram of Oriented Gradients (HOG features)
     hog = hist(extractHOGFeatures(gray));
     hogArray = [hogArray; hog];
%      
     
     %% LOCAL Phase Quantization (LPQ)
     % NEEDS NEURAL NET TOOLBOX AS A DEPENDENCY
     %[C,D,V] = lpqtopCov_([3 3],0.1,0.1,1);
     lpqHist = LPQdesc(gray,3,0,1,'nh');
     lpqArray = [lpqArray;lpqHist];
     
%         
     %% VISUALIZATION -----------------------------------------------------
    if VISUALIZE
         figure,imshow(color_image),hold on;
        max_len = 0;
        for k = 1:length(lines)
           xy = [lines(k).point1; lines(k).point2];
           plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

           % Plot beginnings and ends of lines
           plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
           plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

           % Determine the endpoints of the longest line segment
           len = norm(lines(k).point1 - lines(k).point2);
           if ( len > max_len)
              max_len = len;
              xy_long = xy;
           end
        end
        % highlight the longest line segment
        plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');

        pause;
        
        
        figure,imshow(color_image),hold on;
        max_len = 0;
        for k = 1:length(lines)
           xy = [lines(k).point1; lines(k).point2];
           plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

           % Plot beginnings and ends of lines
           plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
           plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

           % Determine the endpoints of the longest line segment
           len = norm(lines(k).point1 - lines(k).point2);
           if ( len > max_len)
              max_len = len;
              xy_long = xy;
           end
        end
        % highlight the longest line segment
        plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');

        pause;

        figure(2);
       image(color_image);
       
       %hue histogram
       figure(3);
       bar(h_hist);
       pause;
   
   
       %shows category name
       disp(regName(1));
       %shows color img
       image(color_image);  
       figure(2);
       %shows infared image
       image(ir_image);
       
       %hue histogram
       figure(3);
       bar(h_hist);
       pause;
    end
     %shows infared image
    
end

T = table(name,cell2mat(lpqArray))%,cell2mat(botVArray));%,cell2mat(botSArray)); %cell2mat(midHArray),cell2mat(midSArray),cell2mat(midVArray),
%T = table(name, cell2mat(lpqArray),cell2mat(hogArray),cell2mat(hArray),cell2mat(sArray),cell2mat(vArray),cell2mat(strengthLinesArray),cell2mat(quantLinesArray),cell2mat(topHArray),cell2mat(topVArray),cell2mat(topSArray),cell2mat(botHArray), cell2mat(botSArray),cell2mat(botVArray));
%T = table(name,cell2mat(v_ir_Array),cell2mat(hogArray));%,cell2mat(midHArray));%cell2mat(v_ir_Array));

%PLAY A SOUND -0--------
load handel
sound(y,Fs)