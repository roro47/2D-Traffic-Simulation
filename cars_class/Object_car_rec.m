%This is the file for the object of car for single lane.
classdef Object_car_rec <handle
    properties(SetAccess = public)
        length
        width
        color_car
        posx_car
        posy_car
        object_car
        pos_car
        velocity_car
        acceleration_car
    end
    methods
        function obj = Object_car_rec(length, width, posx_car, posy_car, velocity_car,acceleration_car,color_car,the_axis)
            if (nargin ~= 0 && width > 0 && length >0  && velocity_car > 0 && acceleration_car > 0)
            obj.color_car = color_car;
            obj.length = length;
            obj.width = width;
            obj.posx_car = posx_car;
            obj.posy_car = posy_car;
            obj.velocity_car = velocity_car;
            obj.acceleration_car = acceleration_car;
            obj.pos_car = [obj.posx_car-obj.length/2, obj.posy_car-obj.width/2,obj.length,obj.width];
            obj.object_car = rectangle('Position', obj.pos_car,...
                                       'FaceColor', obj.color_car,...
                                       'Parent', the_axis);
            
            end
        end
        function obj = update_position_car(obj)
            obj.posx_car = obj.posx_car + obj.velocity_car*1000/60/60;
            obj.pos_car = [obj.posx_car-obj.length/2, obj.posy_car-obj.width/2,obj.length,obj.width];
            set(obj.object_car, 'Position', obj.pos_car);
        end
        
        function obj = shock(obj)
            obj.velocity_car = 0;
        end
        
        function obj = set_velocity_car(obj, velocity_car)
            obj.velocity_car = velocity_car;
        end
    end
end
