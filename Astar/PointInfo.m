classdef PointInfo
    %点的类属性
    %点的一些基本信息
    properties
	  xCoordinate;	   
      yCoordinate;
      
      isStartPoint = false;    %是否是起点
	  isEndPoint   = false;    %是否是终点
	  isObstacle   = false;    %是否是障碍物   
	  isCloseList  = false;    %是否在closed表
	  isOpenList   = false;    %是否在open表
	  iskeyPoint   = false;    %是否是最短路径上的点
	
	  g = Inf;    %g，点到待扩展点的实际代价
	  h = Inf;    %h，待扩展点到终点的估计代价
      
      parent;     %点的父节点，倒着遍历即可找到路径
    end
    
    properties(Dependent)  %f一直等于g+h，故将其设为独立的属性，自动计算
      f;
    end
    methods
      function value = get.f(obj)
          value = obj.g+obj.h;
      end
    end
end
