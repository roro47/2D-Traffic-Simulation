%This is the file of simulation for single lane.Run this file for single lane simulation.
function traffic_single_lane
    f = figure('Visible','on', 'Position', [0, 0,1300,1200]);
    axs1 = axes('Parent', f,... 
                'Units', 'pixels',...
                'Position', [25, 200,1300,200],...
                'Visible', 'on');
    axs2 = axes('Parent', f,...
           'Units', 'pixels',...
           'Position', [50, 425, 280, 235],...
           'Visible', 'on');
    plot_the_jam = animatedline(axs2,'Color', [0 .7 .7]);
    htext_label_aftertime = uicontrol(f,...
                                  'Style', 'text',...
                                  'String', 'Init shock after: ',...
                                  'Position', [10, 135, 70, 25]);
    htext_aftertime = uicontrol(f,...
                            'Style', 'edit',...
                            'String','0',...
                            'Position', [90, 135, 70, 25],...
                            'Callback', @edit_callback_init_shocktime);
    htext_label_shocktime = uicontrol(f,...
                            'Style', 'text',...
                            'String', 'Shock time: ',...
                            'Position', [10, 100, 70, 25]);
    htext_shocktime = uicontrol(f,...
                            'Style', 'edit',...
                            'String', '0',...
                            'Position', [90, 100, 70, 25],...
                            'Callback', @edit_callback_shocktime);
    axs1.XLim = [0,1300];
    axs1.YLim = [0,250];
    hrun = uicontrol(f,...
                 'Style', 'pushbutton',...
                 'String', 'Run',...
                 'Position', [30, 10, 70, 25],...
                 'Callback', @button_callback_run);
    addpath cars_class
    length = 10;
    width = 4;
    n_cars = 50;
    road_limit = 1200;
    initial_posy = 125;
    time_total = 0;
    converted_time_total = 0;
    init_shocktime = 0;
    shocktime = 0;
    time_old = 0;
    distance_between_car = (road_limit+500 - length*n_cars)/n_cars;
    dt = 1;%1
    safety_time = 2;
    distance_velocity_ratio = safety_time*1000/60/60;
    velocity_car = distance_between_car/distance_velocity_ratio;
    %this calculates the distance travelled in km per hour
    acceleration_car = 2;
    number_jam = 0;
    number_jam_list = [];
    time_jam_list = [];
    tau = 11;
    sigma = 0.0001;
    label = 0;
    label2 = 0;
    for i = 1:n_cars
        initial_posx = 1200 - length/2 - (length + distance_between_car)*(i-1);
            if i == 1
                the_cars(i) = Object_car_rec(length, width, initial_posx, initial_posy, velocity_car, acceleration_car,'b', axs1);
            else if i > 1
            the_cars(i) = Object_car_rec(length, width, initial_posx, initial_posy, velocity_car, acceleration_car,'r',axs1);
                end
            end
    end
    
    function button_callback_run(hObject, callbackdata)
    run = true;
    anim = timer('TimerFcn', @runanimationfcn,...
                'ExecutionMode','fixedRate',...
                'Period', dt,...
                'TasksToExecute', Inf);
    start(anim);                           
    end

    function runanimationfcn(source,event)
        for k = 1:n_cars
            if k == 1
                if time_total > init_shocktime && time_total < init_shocktime + shocktime 
                    time_old = time_total;
                    the_cars(k).velocity_car = 0;
                elseif time_total > (init_shocktime + shocktime)
%                     for i = 1:n_cars
%                         the_cars(i).velocity_car = 0;
%                     end
                    the_cars(k).velocity_car = velocity_car;
                end
            end
            the_cars(k).update_position_car(); 
            %this control the further movement of the car
        end
        %moderation for the motion of car
        for j = 2:n_cars
                d_between = the_cars(j-1).posx_car - the_cars(j).posx_car-length;
                desired_velocity = d_between/distance_velocity_ratio;
                %normal_value = normrnd(0,sigma*d_between,1);
                normal_value = randn;
                %the_cars(j).velocity_car = the_cars(j).velocity_car + (desired_velocity - the_cars(j).velocity_car)*tau/(tau+d_between) + normal_value;
                the_cars(j).velocity_car = the_cars(j).velocity_car + (desired_velocity-the_cars(j).velocity_car)*tau/(tau+d_between);
                disp(the_cars(j).velocity_car - desired_velocity)
                
                state = 0;
           
                if the_cars(j).velocity_car < 0|| the_cars(j).velocity_car ==0 %0.007
                    if label > 0 
                        for a = 1:label
                            if number_jam_list(a) == j
                                 state = state + 1;
                            end
                        end
                        if state == 0
                            number_jam = number_jam + 1;
                            label = label+1;
                            number_jam_list(label) = j;
                            time_jam_list(label) = time_total + dt;
                        end
                    elseif label == 0
                        number_jam = number_jam+1;
                        label = label + 1;
                        number_jam_list(label) = j;
                        time_jam_list(label) = time_total + dt;
                    end
                end
                
        end
        disp(number_jam_list);
        disp(time_jam_list);
        time_total = time_total + dt;
        if number_jam < n_cars
            x_number_jam = time_total;
            y_number_jam = number_jam;
            addpoints(plot_the_jam, x_number_jam, number_jam);
        end
    end
    function edit_callback_init_shocktime(hObject, callbackdata,handles)
        init_shocktime = str2double(get(hObject,'String'));
    end

    function edit_callback_shocktime(hObject, callbackdata,handles)
        shocktime = str2double(get(hObject, 'String'));
    end
    function closefigurefcn(source, event)
         stop(anim);
         delete(anim);
    end

end
