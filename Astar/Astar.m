clear;
clc;
%%
%设置地图参数
WIDTH  = 40;          %地图长度，即行数
LENGTH = 40;		  %地图长度，即列数
STARTPOINTX = WIDTH/4+2;      %起点横坐标
STARTPOINTY = LENGTH/4+2;	   %起点纵坐标
ENDPOINTX   = WIDTH-STARTPOINTX;     %终点横坐标
ENDPOINTY   = LENGTH-STARTPOINTY;    %终点纵坐标
OBSTACLEAMOUNT = WIDTH*LENGTH/4;     %障碍物数量,随机产生障碍物

%%
%将地图上的点初始化
point(WIDTH,LENGTH) = PointInfo;
for i = 1:WIDTH          	
    for j = 1:LENGTH
        point(i,j).xCoordinate = i;   %坐标设置好
        point(i,j).yCoordinate = j;
        point(i,j).h = 10*(abs(i-ENDPOINTX) + abs(j-ENDPOINTY) );      %可以事先计算出H，H这里用曼哈顿距离
    end                                                                %将H改为0，即Dijastra算法
end                                                                    %将H改为Inf，即广度优先算法BFS
point(STARTPOINTX,STARTPOINTY).g = 0; %起始点的g实际代价为0             %将障碍物数量设置为0，可以更好地看出他们的区别

%%
%产生障碍物
point(STARTPOINTX,STARTPOINTY).isStartPoint = true;
point(ENDPOINTX,ENDPOINTY).isEndPoint       = true;
tempX = 0;    %定义随机障碍物的临时坐标
tempY = 0;
tempObs = OBSTACLEAMOUNT;
%rng(0);      %去掉注释可使产生的随机障碍物不变   
while tempObs > 0
	tempX = randi(WIDTH,1);        %randi产生1-WIDTH之间的随机整数
	tempY = randi(LENGTH,1);
	if ~( ((tempX == STARTPOINTX) && (tempY == STARTPOINTY)) || ((tempX == ENDPOINTX) && (tempY == ENDPOINTY)) ) %#ok<*ALIGN> %随机产生的点不能为起始点和终点
    	if ~point(tempX,tempY).isObstacle        %只有不是障碍物的才能变成障碍物，不能重复设置
			point(tempX,tempY).isObstacle = true;
			tempObs = tempObs-1;
        end
    end
end

%%
%Astar算法的核心
openList = [];  %#ok<NASGU>  存放待扩展的节点
closeList = []; %存放以后不需要处理的点
gCost = [14 10 14;10 0 10;14 10 14] ; %当前点的8个相邻点的实际代价值设置
flag1 = false; %算法结束的两种情况：终点在openList中或者openList为空，
flag2 = false;
%1.将起点加入openList
openList = [STARTPOINTX,STARTPOINTY,point(STARTPOINTX,STARTPOINTY).f]; %分为3列，分别代表点的x,y,f
point(STARTPOINTX,STARTPOINTY).isOpenList = true;
%2.重复以下步骤
tic   %输出算法计算的时间，可用来比较算法的效率
while ~flag1 && ~flag2
    %3.选取F最小的放在open表首部
    [~,I] = sort(openList(:,3));
    openList = openList(I,:);
    %4.将F最小的点从openList移至closedList
    currentX = openList(1,1);   %存放当前最小F点的坐标
    currentY = openList(1,2);
    point(currentX,currentY).isCloseList = true;
    point(currentX,currentY).isOpenList = false;
    closeList = [closeList;openList(1,:)];  %#ok<AGROW>
    openList(1,:)=[];
    %5.根据周围的点是否在openList，采取两种不同的操作，分别如下：
    for i = -1:1
        tempX = currentX+i;  %用for循环获取相邻点的坐标(tempX,tempY)
        for j =-1:1
            tempY = currentY+j;       %如果周围点不是边界或者不在closedList或者障碍物，才能继续往下走
            if (tempX>=1) && (tempY>=1) && (tempX<=WIDTH) && (tempY<=LENGTH) && (~point(tempX,tempY).isObstacle) && (~point(tempX,tempY).isCloseList) 
                %i.如果周围的点在openList里,检查这条路径(即经由当前方格到达它那里)是否更好,用G值作参考;
                 tempG = gCost(i+2,j+2)+point(currentX,currentY).g;  %计算经由当前方格到该点的G值
                if point(tempX,tempY).isOpenList
                    %如果G更小，则把它的父亲设置为当前方格，并重新计算它的G和F值,并重新排序openList，否则什么都不做 
                    if tempG < point(tempX,tempY).g    %如果G更小
                        point(tempX,tempY).parent = point(currentX,currentY);   %把它的父亲设置为当前方格
						point(tempX,tempY).g = tempG;   %并重新计算它的G和F值
						[~,I] = sort(openList(:,3));    %重新排序openList
                        openList = openList(I,:);
                    end
                %ii.如果不在openList，把它加入 openList，并且把当前方格设置为它的父亲，记录该方格的 F，G 和 H 值。    
                else
                    point(tempX,tempY).g = tempG;       %先计算G和H值，再加入openList
					point(tempX,tempY).parent = point(currentX,currentY);
                    point(tempX,tempY).isOpenList = true;                   %加入openList
                    openList = [openList;tempX,tempY,point(tempX,tempY).f]; %#ok<AGROW> 
                end
            end
        end
        %6.检查是否能够结束算法，即终点是否已经在openList中或者openList是否为空。
        flag1 = point(ENDPOINTX,ENDPOINTY).isOpenList;
        flag2 = isempty(openList);
    end
 end
 toc
 %%
if flag1   %flag1位true,即找到了最短路径，用pointPrint输出路线
    disp( '路线总代价为:'+ point(ENDPOINTX,ENDPOINTY).f );
    disp('路线为(从下向上看):');
	pointPrint(point,ENDPOINTX,ENDPOINTY);
else
    disp('未找到路径');
end

