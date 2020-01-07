function [OUT]  = core_dic_func100(I_vol1,IN,InitPoint)
% Derivative of core_dic_func10
% All ba_interp2 replaced by interp2
% Siganl sampling removed
% Coded by H.K.  
    
    %checker=input(' ok ? ');
    
    %cl = clock;
    OUT = weaveWeft_dic(I_vol1,IN.mag,IN.RAD,IN.BUF,InitPoint);
    % echo info pick up
    % densblock writer
    %OUT = dataB(OUT);
    %OUT.tm = etime(clock,cl);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fn: file name
% RAD: disk size
% BUF: cropping square around the currently tracked point
% InitPoint: the set of points in the first frame
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [OUT] = weaveWeft_dic(MM,mag,RAD,BUF,InitPoint)
    
    % BUF = around square - speed optimization
    % RAD =radius of disk,aka CLIP in othr functions, range of search area
    % SAM = downsample of points
    % TM = vector of path along time strand - start with end
    % MSK = mask for points to track - maybe all ones - switch - single 1
    
    
    % THIS DEFINES THE DOMAIN AROUND THE POINTS    
    radius = round(0.5*RAD);   % radius of the disk
    iradius = RAD;  % number of points along the radius
    %itheta = 100;   % number of points around disk
    %MAG=mag
    mag=4;
    n_radius=radius*mag+1;
    [XC YC] = ndgrid(linspace(-radius,radius,n_radius),linspace(-radius,radius,n_radius)); % create the nhood
    Nhood = [reshape(XC,n_radius^2,1) reshape(YC,n_radius^2,1)];                          % create the nhood    
    % THIS DEFINES THE DOMAIN AROUND THE POINTS
    
    % make the mmreader
    %MM = mmreader(fn);
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % operate on weft
    %IE = double(imread(fn{1}));
    IE = double(MM(:,:,1));
    %IE = IE(:,:,1);
    
    h = waitbar(0,'Point Tracking In Progress..');

    for img = 1:size(MM,3)-1;
         waitbar(img / size(MM,3));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        IS = IE;                                % end image and the start image                               
        %IE = double(imread(fn{img+1}));         % get the next image
        IE = double(MM(:,:,img+1));         % get the next image
        %IE = IE(:,:,1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % InitPoint(i,:,img) start as 2 column matrix, it after first run, 
        % this will increase to 3 column matrix.
        
        tic
        % for each point
        for i = 1:size(InitPoint,1)
            initP = [1 0 0 1 0 0];              % init the deformation gradient tensor            
           % [M(i,img,:) TIME F] = track_dic(IS,IE,Nhood,InitPoint(i,:,img),10^-4,RAD+BUF,initP);
            [M(i,img,:) TIME F] = track_dic(IS,IE,Nhood,InitPoint(i,:,img),10^-4,RAD,initP);
            %place function tocompare NCC here
           
        % passing dispplacement information of M (end-1:end) to Initpoint
            InitPoint(i,:,img+1) = squeeze(M(i,img,end-1:end))' + InitPoint(i,:,img)   
            
            %> added by Hiro 8-21-2012
            %[NCC_val,SNR_val]=ncc_check_func(IS,IE,XC,YC,InitPoint,img,i)
            %NCC_mtx(i,img)=NCC_val;
            %SNR_mtx(i,img)=SNR_val;
            NCC_mtx=1;
            SNR_mtx=1;
            %< 
            
          %  fprintf(['DW :' num2str(i) ':' num2str(size(InitPoint,1)) ':' num2str(img) ':' num2str(MM.NumberOfFrames) '\n'])            
        end
        %check=input('check out M-matrix');
        % for each point
        toc
    end
    delete(h)
    % operate on weft
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % return the fiber bundle
    OUT.IP = InitPoint;
    OUT.M = M;
    OUT.NCC=NCC_mtx;
    OUT.SNR=SNR_mtx;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tracking code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [T TIME DELTA] = track_dic(SI,EI,X,P,ERR,CLIP,initP)
    warning('off','MATLAB:rankDeficientMatrix');
    %%%%%%%%%%%%%%%%%%
    % SI = start image whole image
    % EI = end image whole image
    % X = domain around point P
    % P = point in start image to track
    % ERR = acceptable error
    % CLIP = defines the "smaller"/"clipped" image size
    % create domain to work within    
    %%%%%%%%%%%%%%%%%%    
    % create the working domain - crop out the image
    [Y1 Y2] = ndgrid(P(2)-CLIP:P(2)+CLIP,P(1)-CLIP:P(1)+CLIP);
    % clip working domain

    
    %SI = ba_interp2(SI,Y2,Y1); %//C-code (use interp within matlab)
    %EI = ba_interp2(EI,Y2,Y1); %//C-code (use Ninterp2 within matlab)  
    
    SI = interp2(SI,Y2,Y1); %//C-code (use interp within matlab)
    EI = interp2(EI,Y2,Y1); %//C-code (use Ninterp2 within matlab)  
    
    
    % gradient of the start image
    [G1 G2] = gradient(SI);    
    % init the transformation
    T = initP;    
    dX = [1 1];
    %Ii = ba_interp2(SI,X(:,1)+CLIP+1,X(:,2)+CLIP+1);        % Clip, Vectorization and Interpolation  should be smaller!!!!
    %G1i = ba_interp2(G1,X(:,1)+CLIP+1,X(:,2)+CLIP+1);       % interpolate the gradient of the first image within the n-hood
    %G2i = ba_interp2(G2,X(:,1)+CLIP+1,X(:,2)+CLIP+1);       % interpolate the gradient of the second image withing the n-hood 

    Ii = interp2(SI,X(:,1)+CLIP+1,X(:,2)+CLIP+1);        % Clip, Vectorization and Interpolation  should be smaller!!!!
    G1i = interp2(G1,X(:,1)+CLIP+1,X(:,2)+CLIP+1);       % interpolate the gradient of the first image within the n-hood
    G2i = interp2(G2,X(:,1)+CLIP+1,X(:,2)+CLIP+1);       % interpolate the gradient of the second image withing the n-hood     
    
    G = [G1i G2i];                                          % glue the arrays together
    cnt = 1;                                                % init the count var
    F = 1;
    history = [];
    % this is the magic - combines the gradients with the displacement
    % vectors to create the needed matrix for the least squares solution        
    M = [G.*repmat(X(:,1),[1 2]) G(:,1) G.*repmat(X(:,2),[1 2]) G(:,2)]; 
    while F & norm(dX(end-1:end)) > ERR
        TR = reshape(T,[2 3]);                              % this reshapes the transformation
        Xt = (TR*[X ones(size(X,1),1)]')';                  % concatenate ones onto the n-hood and translate the n-hood via the transformation     
        Gi = interp2(EI,Xt(:,1)+CLIP+1,Xt(:,2)+CLIP+1);  % interpolate the second image within the translated n-hood           
        dX = M\(Ii-Gi);                                     % least squares solution
        dX = [dX(1) dX(2) dX(4) dX(5) dX(3) dX(6)]';        % shuffle the dX around     
        T = T + dX';                                        % displace the tranformation                
        history(cnt) = norm(Ii(:)-Gi(:));          
        if cnt >= 2
           F = history(cnt)< history(cnt-1);
        end
        cnt = cnt + 1;
    end
    TIME = 1;                                             % this is the delta t
    DELTA = norm(Ii(:)-Gi(:));                              % this is the difference between the first and second images
end


%{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% called to make a spaced mask
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [InitPoint] = defPT(SZ,SAM,PAD)

    % define the points to track
    [g1 g2] = ndgrid(1:SZ(1),1:SZ(2));
    g = (mod(g1,SAM) == 0) & (mod(g2,SAM) == 0);
    
    % pad the borders
	for i = 1:4
        g(1:round((PAD+.05*PAD)),:) = 0;
        g = imrotate(g,-90);
    end 
    % pad the borders
    
    % define the points to track
    [InitPoint(:,2) InitPoint(:,1)] = find(g);
    % define the points to track
end

%{
%% try call to data
core('G:\S16\DAY 2\ATM\MM_S16_7_16_L_ATM_1.avi')
%}    
%}
