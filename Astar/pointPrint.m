function pointPrint(point,ENDPOINTX,ENDPOINTY)
%POINTPRINT�������ͼ��·���ĺ���
%�����ͼ��Ϣ���յ㣬�����丸�ڵ㣬�����ҵ�·��
    %���ȸ��ݸ��ڵ��ҳ�·���еĹؼ��㣬�������һ���ڵ���ǰ��
	tempPoint = point(ENDPOINTX,ENDPOINTY);  %����һ����ʱ����Ÿ��ڵ���Ϣ
    path = [];   %PATH����·����
    while ~isempty(tempPoint.parent)
        tempPoint = tempPoint.parent;
		tempX = tempPoint.xCoordinate;
        tempY = tempPoint.yCoordinate; 
        disp('("+tempX+","+tempY+")');
		point(tempX,tempY).iskeyPoint = true;
        path = [path;tempX,tempY];   %#ok<AGROW>
    end
    
	%�����ͼ���
    colormap([0 0 0;1 1 1;1 0 0;0 1 0;0 0 1]);%������ɫ���ֱ����0��ɫ��1��ɫ��2��ɫ��3��ɫ��4��ɫ
    map = ones(size(point,1),size(point,2));
	for i = 1:size(map,1)     %#ok<ALIGN>
		for j = 1:size(map,2) %#ok<ALIGN>
            if point(i,j).isStartPoint
				map(i,j) = 2;   %����ú�ɫ��ʾ
            elseif point(i,j).isEndPoint
    		    map(i,j) = 2;   %�յ�Ҳ�ú�ɫ��ʾ
            elseif point(i,j).isObstacle
				map(i,j) = 0;   %�ϰ����ú�ɫ��ʾ
            elseif point(i,j).isCloseList || point(i,j).isOpenList 
                map(i,j) = 4;   %��չ������ɫ��ʾ
            else
                map(i,j) = 1;   %��ͨ���ð�ɫ��ʾ 
            end
        end
    end
    map(i+1,j+1) = 5;   %�轫map��չһ��
   
    pcolor(map);    %�����·��������ľ�̬��
    %colorbar;      %�ɲ鿴��ɫ���
    set(gca,'XTick',1:size(map,2)-1,'YTick',1:size(map,1)-1);   %����������
    axis image xy;      %��ÿ��������ʹ����ͬ�����ݵ�λ������һ��
    
    hold on; 
    
    t =text(j+2,i,'���յ�');  %��text���ͼ��
    t.BackgroundColor = 'r';
     t.FontWeight = 'bold' ;

    t =text(j+2,i*3/4,'�ϰ���');
    t.BackgroundColor =[0 0 0];
    t.FontWeight = 'bold' ;
    t.Color = [1 1 1];

    t =text(j+2,i/2,'·����');
    t.BackgroundColor ='g';
    t.FontWeight = 'bold' ;
    
    t =text(j+2,i/4,'��չ��');
    t.BackgroundColor = 'b';
    t.FontWeight = 'bold' ;
  
    %��̬���·����,����ɫ��ʾ
    for i = flip(1:size(path,1)-1) %��·�����ǵ��Ŵ�ŵģ��跭תһ�£������һ��������㣬�������
        x = path(i,1);
        y = path(i,2);
        fill([y,y+1,y+1,y],[x,x,x+1,x+1],'g'); %�����·��������ľ�̬��
        pause(0.01);  %��ʱ0.01s���ɾݴ����ö�̬���Ƶ��
    end
    hold off
  
end

