classdef PointInfo
    %���������
    %���һЩ������Ϣ
    properties
	  xCoordinate;	   
      yCoordinate;
      
      isStartPoint = false;    %�Ƿ������
	  isEndPoint   = false;    %�Ƿ����յ�
	  isObstacle   = false;    %�Ƿ����ϰ���   
	  isCloseList  = false;    %�Ƿ���closed��
	  isOpenList   = false;    %�Ƿ���open��
	  iskeyPoint   = false;    %�Ƿ������·���ϵĵ�
	
	  g = Inf;    %g���㵽����չ���ʵ�ʴ���
	  h = Inf;    %h������չ�㵽�յ�Ĺ��ƴ���
      
      parent;     %��ĸ��ڵ㣬���ű��������ҵ�·��
    end
    
    properties(Dependent)  %fһֱ����g+h���ʽ�����Ϊ���������ԣ��Զ�����
      f;
    end
    methods
      function value = get.f(obj)
          value = obj.g+obj.h;
      end
    end
end
