clear;
clc;
%%
%���õ�ͼ����
WIDTH  = 40;          %��ͼ���ȣ�������
LENGTH = 40;		  %��ͼ���ȣ�������
STARTPOINTX = WIDTH/4+2;      %��������
STARTPOINTY = LENGTH/4+2;	   %���������
ENDPOINTX   = WIDTH-STARTPOINTX;     %�յ������
ENDPOINTY   = LENGTH-STARTPOINTY;    %�յ�������
OBSTACLEAMOUNT = WIDTH*LENGTH/4;     %�ϰ�������,��������ϰ���

%%
%����ͼ�ϵĵ��ʼ��
point(WIDTH,LENGTH) = PointInfo;
for i = 1:WIDTH          	
    for j = 1:LENGTH
        point(i,j).xCoordinate = i;   %�������ú�
        point(i,j).yCoordinate = j;
        point(i,j).h = 10*(abs(i-ENDPOINTX) + abs(j-ENDPOINTY) );      %�������ȼ����H��H�����������پ���
    end                                                                %��H��Ϊ0����Dijastra�㷨
end                                                                    %��H��ΪInf������������㷨BFS
point(STARTPOINTX,STARTPOINTY).g = 0; %��ʼ���gʵ�ʴ���Ϊ0             %���ϰ�����������Ϊ0�����Ը��õؿ������ǵ�����

%%
%�����ϰ���
point(STARTPOINTX,STARTPOINTY).isStartPoint = true;
point(ENDPOINTX,ENDPOINTY).isEndPoint       = true;
tempX = 0;    %��������ϰ������ʱ����
tempY = 0;
tempObs = OBSTACLEAMOUNT;
%rng(0);      %ȥ��ע�Ϳ�ʹ����������ϰ��ﲻ��   
while tempObs > 0
	tempX = randi(WIDTH,1);        %randi����1-WIDTH֮����������
	tempY = randi(LENGTH,1);
	if ~( ((tempX == STARTPOINTX) && (tempY == STARTPOINTY)) || ((tempX == ENDPOINTX) && (tempY == ENDPOINTY)) ) %#ok<*ALIGN> %��������ĵ㲻��Ϊ��ʼ����յ�
    	if ~point(tempX,tempY).isObstacle        %ֻ�в����ϰ���Ĳ��ܱ���ϰ�������ظ�����
			point(tempX,tempY).isObstacle = true;
			tempObs = tempObs-1;
        end
    end
end

%%
%Astar�㷨�ĺ���
openList = [];  %#ok<NASGU>  ��Ŵ���չ�Ľڵ�
closeList = []; %����Ժ���Ҫ����ĵ�
gCost = [14 10 14;10 0 10;14 10 14] ; %��ǰ���8�����ڵ��ʵ�ʴ���ֵ����
flag1 = false; %�㷨����������������յ���openList�л���openListΪ�գ�
flag2 = false;
%1.��������openList
openList = [STARTPOINTX,STARTPOINTY,point(STARTPOINTX,STARTPOINTY).f]; %��Ϊ3�У��ֱ������x,y,f
point(STARTPOINTX,STARTPOINTY).isOpenList = true;
%2.�ظ����²���
tic   %����㷨�����ʱ�䣬�������Ƚ��㷨��Ч��
while ~flag1 && ~flag2
    %3.ѡȡF��С�ķ���open���ײ�
    [~,I] = sort(openList(:,3));
    openList = openList(I,:);
    %4.��F��С�ĵ��openList����closedList
    currentX = openList(1,1);   %��ŵ�ǰ��СF�������
    currentY = openList(1,2);
    point(currentX,currentY).isCloseList = true;
    point(currentX,currentY).isOpenList = false;
    closeList = [closeList;openList(1,:)];  %#ok<AGROW>
    openList(1,:)=[];
    %5.������Χ�ĵ��Ƿ���openList����ȡ���ֲ�ͬ�Ĳ������ֱ����£�
    for i = -1:1
        tempX = currentX+i;  %��forѭ����ȡ���ڵ������(tempX,tempY)
        for j =-1:1
            tempY = currentY+j;       %�����Χ�㲻�Ǳ߽���߲���closedList�����ϰ�����ܼ���������
            if (tempX>=1) && (tempY>=1) && (tempX<=WIDTH) && (tempY<=LENGTH) && (~point(tempX,tempY).isObstacle) && (~point(tempX,tempY).isCloseList) 
                %i.�����Χ�ĵ���openList��,�������·��(�����ɵ�ǰ���񵽴�������)�Ƿ����,��Gֵ���ο�;
                 tempG = gCost(i+2,j+2)+point(currentX,currentY).g;  %���㾭�ɵ�ǰ���񵽸õ��Gֵ
                if point(tempX,tempY).isOpenList
                    %���G��С��������ĸ�������Ϊ��ǰ���񣬲����¼�������G��Fֵ,����������openList������ʲô������ 
                    if tempG < point(tempX,tempY).g    %���G��С
                        point(tempX,tempY).parent = point(currentX,currentY);   %�����ĸ�������Ϊ��ǰ����
						point(tempX,tempY).g = tempG;   %�����¼�������G��Fֵ
						[~,I] = sort(openList(:,3));    %��������openList
                        openList = openList(I,:);
                    end
                %ii.�������openList���������� openList�����Ұѵ�ǰ��������Ϊ���ĸ��ף���¼�÷���� F��G �� H ֵ��    
                else
                    point(tempX,tempY).g = tempG;       %�ȼ���G��Hֵ���ټ���openList
					point(tempX,tempY).parent = point(currentX,currentY);
                    point(tempX,tempY).isOpenList = true;                   %����openList
                    openList = [openList;tempX,tempY,point(tempX,tempY).f]; %#ok<AGROW> 
                end
            end
        end
        %6.����Ƿ��ܹ������㷨�����յ��Ƿ��Ѿ���openList�л���openList�Ƿ�Ϊ�ա�
        flag1 = point(ENDPOINTX,ENDPOINTY).isOpenList;
        flag2 = isempty(openList);
    end
 end
 toc
 %%
if flag1   %flag1λtrue,���ҵ������·������pointPrint���·��
    disp( '·���ܴ���Ϊ:'+ point(ENDPOINTX,ENDPOINTY).f );
    disp('·��Ϊ(�������Ͽ�):');
	pointPrint(point,ENDPOINTX,ENDPOINTY);
else
    disp('δ�ҵ�·��');
end

