function pointPrint(point,ENDPOINTX,ENDPOINTY)
%POINTPRINT：输出地图及路径的函数
%输入地图信息及终点，根据其父节点，即可找到路径
    %首先根据父节点找出路线中的关键点，根据最后一个节点往前找
	tempPoint = point(ENDPOINTX,ENDPOINTY);  %定义一个临时结点存放父节点信息
    path = [];   %PATH保存路径点
    while ~isempty(tempPoint.parent)
        tempPoint = tempPoint.parent;
		tempX = tempPoint.xCoordinate;
        tempY = tempPoint.yCoordinate; 
        disp('("+tempX+","+tempY+")');
		point(tempX,tempY).iskeyPoint = true;
        path = [path;tempX,tempY];   %#ok<AGROW>
    end
    
	%输出地图情况
    colormap([0 0 0;1 1 1;1 0 0;0 1 0;0 0 1]);%设置颜色，分别代表0黑色、1白色、2红色、3绿色、4蓝色
    map = ones(size(point,1),size(point,2));
	for i = 1:size(map,1)     %#ok<ALIGN>
		for j = 1:size(map,2) %#ok<ALIGN>
            if point(i,j).isStartPoint
				map(i,j) = 2;   %起点用红色表示
            elseif point(i,j).isEndPoint
    		    map(i,j) = 2;   %终点也用红色表示
            elseif point(i,j).isObstacle
				map(i,j) = 0;   %障碍物用黑色表示
            elseif point(i,j).isCloseList || point(i,j).isOpenList 
                map(i,j) = 4;   %扩展点用蓝色表示
            else
                map(i,j) = 1;   %普通点用白色表示 
            end
        end
    end
    map(i+1,j+1) = 5;   %需将map扩展一格
   
    pcolor(map);    %输出除路径点以外的静态点
    %colorbar;      %可查看颜色情况
    set(gca,'XTick',1:size(map,2)-1,'YTick',1:size(map,1)-1);   %设置坐标轴
    axis image xy;      %沿每个坐标轴使用相同的数据单位，保持一致
    
    hold on; 
    
    t =text(j+2,i,'起终点');  %用text输出图例
    t.BackgroundColor = 'r';
     t.FontWeight = 'bold' ;

    t =text(j+2,i*3/4,'障碍点');
    t.BackgroundColor =[0 0 0];
    t.FontWeight = 'bold' ;
    t.Color = [1 1 1];

    t =text(j+2,i/2,'路径点');
    t.BackgroundColor ='g';
    t.FontWeight = 'bold' ;
    
    t =text(j+2,i/4,'扩展点');
    t.BackgroundColor = 'b';
    t.FontWeight = 'bold' ;
  
    %动态输出路径点,用绿色表示
    for i = flip(1:size(path,1)-1) %因路径点是倒着存放的，需翻转一下，且最后一个点是起点，无需输出
        x = path(i,1);
        y = path(i,2);
        fill([y,y+1,y+1,y],[x,x,x+1,x+1],'g'); %输出除路径点以外的静态点
        pause(0.01);  %延时0.01s，可据此设置动态输出频率
    end
    hold off
  
end

