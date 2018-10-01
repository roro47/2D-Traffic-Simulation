%This is the file for the object.Modify the behaviour of the car through this file.
classdef Object_car <handle
    properties(SetAccess = public)
        r_car
        d_car
        color_car
        center_posx_car
        center_posy_car
        r_circle
        pathangle
        object_car
        pos_car
        angular_velocity_car
        velocity_car
        angular_acceleration_car
    end
    methods
        function obj = Object_car(r_car,r_circle,pathangle,angular_velocity_car,velocity_car,angular_acceleration_car,color_car,the_axis)
            if (nargin ~= 0 && r_circle > 0 && r_car >0  && pathangle > 0 && angular_velocity_car > 0 && angular_acceleration_car > 0)
            obj.color_car = color_car;
            obj.r_circle = r_circle;
            obj.d_car = r_car * 2;
            obj.r_car = r_car;
            obj.pathangle = pathangle;
            obj.velocity_car = velocity_car;
            obj.center_posx_car = cos(obj.pathangle)*obj.r_circle;
            obj.center_posy_car = sin(obj.pathangle)*obj.r_circle;
            obj.angular_velocity_car = angular_velocity_car;
            obj.angular_acceleration_car = angular_acceleration_car;
            obj.pos_car = [obj.center_posx_car-10, obj.center_posy_car-10,obj.d_car,obj.d_car];
            obj.object_car = rectangle('Position', obj.pos_car,...
                                       'Curvature', [1 1],...
                                       'FaceColor', obj.color_car,...
                                       'Parent', the_axis);
            
            end
        end
        function obj = update_position_car(obj)
            obj.pathangle = obj.pathangle + obj.velocity_car*1000/60/60/obj.r_circle;
            obj.center_posx_car = cos(obj.pathangle)*obj.r_circle;
            obj.center_posy_car = sin(obj.pathangle)*obj.r_circle;
            obj.pos_car = [obj.center_posx_car-obj.r_car, obj.center_posy_car-obj.r_car ,obj.d_car,obj.d_car];
            set(obj.object_car, 'Position', obj.pos_car);
        end
        
        function obj = shock(obj)
            obj.velocity_car = 0;
        end
        
        function obj = set_angular_velocity_car(obj, angular_velocity_car)
            obj.angular_velocity_car = angular_velocity_car;
        end
    end
end
        
