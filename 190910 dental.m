%% load STL file & make directory
clc; clear all; close all;

PATH.orig = '\Users\user\MATLAB Drive';
PATH.slic = '\Users\user\MATLAB Drive\SLICED';

cd(PATH.orig);
load('STL.mat');

if(isdir("SLICED"))
    rmdir SLICED s;
end
mkdir SLICED;

%% scatter sliced 2D image
COOR1 = FILE1.Points;
COOR2 = FILE2.Points;

COOR1(:,1) = round(COOR1(:,1)-min(COOR1(:,1)));
COOR2(:,1) = round(COOR2(:,1)-min(COOR2(:,1)));

e = max([COOR1(:,1);COOR2(:,1)]); % total number
n = 100; % partial number

for i = 1:n %e
    image = figure('visible','off');
    
    INDEX1 = find(COOR1(:,1)==i);
    POINT1{i} = [COOR1(INDEX1,2),COOR1(INDEX1,3)];
    scatter(POINT1{i}(:,1),POINT1{i}(:,2),2); hold on;
    INDEX2 = find(COOR2(:,1)==i);
    POINT2{i} = [COOR2(INDEX2,2),COOR2(INDEX2,3)];
    scatter(POINT2{i}(:,1),POINT2{i}(:,2),2); hold off;
    
    rang = [min([COOR1;COOR2]); max([COOR1;COOR2])];
    xlim(rang(:,2));
    ylim(rang(:,3));
    set(gca,'visible','off');
    
    cd(PATH.slic);
    filename = string(i)+'.png';
    saveas(image, filename);
end

%% derivatives within kernel
for i = 1:1000 %max(length(FILE1.Points),length(FILE2.Points))
    Ksize = 6;

    d1 = vecnorm(FILE1.Points-FILE1.Points(i,:),2,2);
    minmap = mink(d1,Ksize);
    map = ismember(d1, minmap(2:end));
    INDEX.D1 = find(map);

    KERNEL1 = [FILE1.Points(i,:);FILE1.Points(INDEX.D1,:)];
    INDEX.C1 = combnk(2:nnz(map),2);

    d2 = vecnorm(FILE2.Points-FILE2.Points(i,:),2,2);
    minmap = mink(d2,Ksize);
    map = ismember(d2, minmap(2:end));
    INDEX.D2 = find(map);

    KERNEL2 = [FILE2.Points(i,:);FILE2.Points(INDEX.D2,:)];
    INDEX.C2 = combnk(2:nnz(map),2);
    
    DERI1(i,1,:) = KERNEL1(1,:);
    DERI2(i,1,:) = KERNEL2(1,:);
    
    for j = 1:nchoosek(Ksize-2,2)
        P0 = KERNEL1(1,:);
        temp = KERNEL1(INDEX.C1(j,:)',:);
        P1 = temp(1,:); P2 = temp(2,:);
        DERI1(i,j+1,:) = cross(P0-P1, P0-P2);
        
        P0 = KERNEL2(1,:);
        temp = KERNEL2(INDEX.C2(j,:)',:);
        P1 = temp(1,:); P2 = temp(2,:);
        DERI2(i,j+1,:) = cross(P0-P1, P0-P2);
    end
    
    % figure;
    % scatter3(FILE1.Points(1,1), FILE1.Points(1,2), FILE1.Points(1,3), 'r'); hold on;
    % scatter3(FILE1.Points(INDEXD,1),FILE1.Points(INDEXD,2),FILE1.Points(INDEXD,3)); hold off;
end
    
%% deep learning layers
for i = 1:size(COOR1,1)
    
%     DERI1(:,1,1) = 
end