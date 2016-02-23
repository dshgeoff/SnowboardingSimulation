function startGame

%initializing figure and its properties
main_fig=figure('Name','test game',...
    'Position', [10 50 1000 600],...
    'Numbertitle','off',...
    'KeyPressFcn',@move_snowboarder);

%initializing axes and its properties
axesOne=axes('position', [0 0 1 1],...
    'Visible','off',...
    'NextPlot','add',...
    'XLim',[0 1],...
    'YLim',[0 1]);

global SKULL SKULL1 SKULL2 SKULL3 SKULL4 SKULL5 HEALTH_COUNT HEALTH1 HEALTH2 HEALTH3 HEALTH4 HEALTH5 iYeti DAQ SPEED CURRENT_POS SCORE_STRING WELCOME_TEXT SCORE POS PLAYER_POS TIMESTEP plot_handle0 plot_handle1 plot_handle2 plot_handle3 plot_handle4 plot_handle5 plot_handle6 player a1 b1 c1 d1 e1 f1 g1 a2 b2 c2 d2 e2 f2 g2;

%initializing various constants
SCORE=0;

%initializing the DAQ and setting various properties
DAQ=analoginput('mcc');
addchannel(DAQ,0:1);
set(DAQ,'SampleRate',10000);
set(DAQ,'SamplesPerTrigger',100);

%start game
welcome;

%sets welcome message on the screen
    function welcome        
        WELCOME_TEXT=text('String','PRESS 0 TO PLAY',...
            'Position',[.42 .52],...
            'FontSize',15);
    end

%function for the algorithm of the main game
    function main
        %sets the background and images used during the game
        set_background;
        health_bar;
        %prints current score (starts at 0)
        SCORE_STRING=text('Position',[.8 .1],...
                'String',SCORE);            
        %determining a random number for which the yeti will appear during the course of the game 
        Yeti1=randint(1,1,[3,9]);
        Yeti2=randint(1,1,[10,14]);
        Yeti3=randint(1,1,[15,29]);
        Yeti4=randint(1,1,[30,49]);
        Yeti5=randint(1,1,[50,100]);
        
        %starts the game(starts slow...finishes fast)..speed determined by
        %TIMESTEP and the number of trees depends on the throw tree
        %function
        for COUNT=0:1:100            
            if(COUNT>=0&&COUNT<3)
                TIMESTEP=.1;
                throw_one_tree;
            elseif(COUNT>=3&&COUNT<10)
                TIMESTEP=.05;
                if(COUNT==Yeti1)
                    throw_yeti;
                else
                    throw_one_tree;
                    throw_three_tree;
                end                
            elseif(COUNT>=10&&COUNT<15)
                TIMESTEP=.035;
                if(COUNT==Yeti2)
                    throw_yeti;
                else
                throw_three_tree;
                end
            elseif(COUNT>=15&&COUNT<30)
                TIMESTEP=.02;
                if(COUNT==Yeti3)
                    throw_yeti;
                else
                throw_three_tree;
                throw_five_tree;
                end
            else
                TIMESTEP=.01;
                if(COUNT==Yeti4)
                    throw_yeti;
                elseif(COUNT==Yeti5)
                    throw_yeti;
                else
                throw_five_tree;
                end
            end
            %if health bar runs out, quit game
            if(HEALTH_COUNT==0)
                break;
            end
        end 
    end
        
%function to position snowboarder
    function move_snowboarder(src,evnt)
        switch (evnt.Character)
            case('0')
                %provides user with the option of replaying the game
                set(WELCOME_TEXT,'Visible','off');
                main;                
        end         
    end

%function to move Yeti on a random line
    function throw_yeti
        
        rand_num=randint(1,1,[0,6]);
        object='y';
        for n=18:-1:0
            plot_on_line(n,rand_num,object);
            move_player(n);
            if(n==2)
                check_crash(object);                
            end

            pause(TIMESTEP);
            
            %resets constants before checking crash status
            a1=0; a2=0; b1=0; b2=0; c1=0; c2=0; d1=0; d2=0; e1=0; e2=0; f1=0; f2=0; g1=0; g2=0;
            
            %checks for crash...if crash display skull image
            if(n==0)
                set(SKULL,'XData',[0 .00001]);
                delete_plot(7);
            end
        end
    end

%function to move one tree in figure
    function throw_one_tree
        %generates a random number to place tree on a random location
        rand_num=randint(1,1,[0,6]);
        
        object='t';
        
        for n=18:-1:2            
            plot_on_line(n,rand_num,object);
            move_player(n);
            %checks for crash
            if(n==2)
                check_crash(object);
            end
            pause(TIMESTEP);
            %resets constants before checking crash status
            a1=0; a2=0; b1=0; b2=0; c1=0; c2=0; d1=0; d2=0; e1=0; e2=0; f1=0; f2=0; g1=0; g2=0;
            %removes image from screen/render tree image 'invisible'
            if(n==2)
                set(SKULL,'XData',[0 .00001]);
                delete_plot(rand_num);
            end
        end
    end
        
%function to move three tree in figure
    function throw_three_tree
        %loop that generates 3 different random integers to place trees
        while(1)
            rand_num1=randint(1,1,[0,6]);
            rand_num2=randint(1,1,[0,6]);
            rand_num3=randint(1,1,[0,6]);
            if(rand_num1~=rand_num2&&rand_num2~=rand_num3&&rand_num3~=rand_num1)
                break;
            end
        end        
        object='t';
        for n=18:-1:2            
            move_player(n);
            plot_on_line(n,rand_num1,object);
            plot_on_line(n,rand_num2,object);
            plot_on_line(n,rand_num3,object);            
            %checks for crash
            if(n==2)
                check_crash(object);
            end
            pause(TIMESTEP);
            %resets constants before checking crash status
            a1=0; a2=0; b1=0; b2=0; c1=0; c2=0; d1=0; d2=0; e1=0; e2=0; f1=0; f2=0; g1=0; g2=0;
            %removes image from screen/render tree image 'invisible'
            if(n==2)
                set(SKULL,'XData',[0 .00001]);
                delete_plot(rand_num1);
                delete_plot(rand_num2);
                delete_plot(rand_num3);
            end
        end
    end

%function to move five tree in figure
    function throw_five_tree 
        %loop that generates 5 different random integers to place trees
        while(1)
            num=randint(1,5,[0,6]);
            if(num(1)~=num(2)&&num(1)~=num(3)&&num(1)~=num(4)&&num(1)~=num(5)&&num(2)~=num(3)&&num(2)~=num(4)&& num(2)~=num(5)&&num(3)~=num(4)&&num(3)~=num(5)&&num(4)~=num(5))
                break;
            end
        end  
        object='t';        
        for n=18:-1:2
            move_player(n);
            plot_on_line(n,num(1),object);
            plot_on_line(n,num(2),object);
            plot_on_line(n,num(3),object);
            plot_on_line(n,num(4),object);
            plot_on_line(n,num(5),object);
            %checks for crash
           if(n==2)
               check_crash(object);
           end           
           pause(TIMESTEP);
            %resets constants before checking crash status
           a1=0; a2=0; b1=0; b2=0; c1=0; c2=0; d1=0; d2=0; e1=0; e2=0; f1=0; f2=0; g1=0; g2=0;
           %removes image from screen/render tree image 'invisible'
           if(n==2)
               set(SKULL,'XData',[0 .00001]);
               delete_plot(num(1));
               delete_plot(num(2));
               delete_plot(num(3));
               delete_plot(num(4));
               delete_plot(num(5));
           end
        end
    end

%function to plot one object on line that inputs appropriate vertical
%location, horizontal location, and object type(tree or yeti)
    function plot_on_line(n,num,object)
        %inputs the horizontal location of the object and plot on
        %appropriate coordinate
        switch(num)
            case(0)
                %code that plots object on line 0 where x=y
                %and determines the appropriate dimensions
                Xmin=n*.025;
                delta_x=(1-2*n*.025)/12;
                Y_0=n*.025;
                delta_y=(1-2*Y_0)/4;
                %outputs image of appropriate object(tree or yeti)
                if(object=='y')
                    set(iYeti,...
                        'XData',[Xmin-delta_x Xmin+delta_x],...
                        'YData',[Y_0+delta_y Y_0]);
                elseif(object=='t')
                    set(plot_handle0,...
                        'XData',[Xmin-delta_x Xmin+delta_x],...
                        'YData',[Y_0+delta_y Y_0]);
                end
                %presets location when n=2 in the loop in the function
                %throw
                if(n==2)
                    a1=.05-delta_x;
                    a2=.05+delta_x;
                else
                    a1=0;
                    a2=0;
                end
            case(1)
                %executes similar algorithm for line 1, x=(4y+1)/6
                Xmin=((n*0.1)+1)/6;
                delta_x=(1-2*n*.025)/12;
                Y_0=n*.025;
                delta_y=(1-2*Y_0)/4;
                if(object=='y')
                    set(iYeti,...
                    'XData',[Xmin-delta_x Xmin+delta_x],...
                    'YData',[Y_0+delta_y Y_0]);
                elseif(object=='t')
                set(plot_handle1,...
                    'XData',[Xmin-delta_x Xmin+delta_x],...
                    'YData',[Y_0+delta_y Y_0]);
                end
                if(n==2)
                    b1=.2-delta_x;
                    b2=.2+delta_x;
                else
                    b1=0;
                    b2=0;
                end
            case(2)
                %executes similar algorithm for line 2, x=(y+1)/3
                Xmin=((n*.025)+1)/3;
                delta_x=(1-2*n*.025)/12;
                Y_0=n*.025;
                delta_y=(1-2*Y_0)/4;
                if(object=='y')
                    set(iYeti,...
                    'XData',[Xmin-delta_x Xmin+delta_x],...
                    'YData',[Y_0+delta_y Y_0]);
                elseif(object=='t')
                set(plot_handle2,...
                    'XData',[Xmin-delta_x Xmin+delta_x],...
                    'YData',[Y_0+delta_y Y_0]);
                end
                if(n==2)
                    c1=.35-delta_x;
                    c2=.35+delta_x;
                else
                    c1=0;
                    c2=0;
                end
            case(3)
                %executes similar algorithm for line 3, x=.5
                Xmin=.5;
                delta_x=(1-2*n*.025)/12;
                Y_0=n*.025;
                delta_y=(1-2*Y_0)/4;
                if(object=='y')
                    set(iYeti,...
                    'XData',[Xmin-delta_x Xmin+delta_x],...
                    'YData',[Y_0+delta_y Y_0]);
                elseif(object=='t')
                set(plot_handle3,...
                    'XData',[Xmin-delta_x Xmin+delta_x],...
                    'YData',[Y_0+delta_y Y_0]);
                end
                if(n==2)
                    d1=.5-delta_x;
                    d2=.5+delta_x;
                else
                    d1=0;
                    d2=0;
                end
            case(4)
                %executes similar algorithm for line 4, x=(2-y)/3
                Xmin=(2-(n*.025))/3;
                delta_x=(1-2*n*.025)/12;
                Y_0=n*.025;
                delta_y=(1-2*Y_0)/4;
                if(object=='y')
                    set(iYeti,...
                    'XData',[Xmin-delta_x Xmin+delta_x],...
                    'YData',[Y_0+delta_y Y_0]);
                elseif(object=='t')
                set(plot_handle4,...
                    'XData',[Xmin-delta_x Xmin+delta_x],...
                    'YData',[Y_0+delta_y Y_0]);
                end
                if(n==2)
                    e1=.65-delta_x;
                    e2=.65+delta_x;
                else
                    e1=0;
                    e2=0;
                end
            case(5)
                %executes similar algorithm for line 5,x=(5-4y)/6
                Xmin=(5-(n*.1))/6;
                delta_x=(1-2*n*.025)/12;
                Y_0=n*.025;
                delta_y=(1-2*Y_0)/4;
                if(object=='y')
                    set(iYeti,...
                    'XData',[Xmin-delta_x Xmin+delta_x],...
                    'YData',[Y_0+delta_y Y_0]);
                elseif(object=='t')
                set(plot_handle5,...
                    'XData',[Xmin-delta_x Xmin+delta_x],...
                    'YData',[Y_0+delta_y Y_0]);
                end
                if(n==2)
                    f1=.8-delta_x;
                    f2=.8+delta_x;
                else
                    f1=0;
                    f2=0;
                end
            case(6)
                %executes similar algorithm for line 6, x=1-y
                Xmin=1-n*.025;
                delta_x=(1-2*n*.025)/12;
                Y_0=n*.025;
                delta_y=(1-2*Y_0)/4;
                if(object=='y')
                    set(iYeti,...
                    'XData',[Xmin-delta_x Xmin+delta_x],...
                    'YData',[Y_0+delta_y Y_0]);
                elseif(object=='t')
                set(plot_handle6,...
                    'XData',[Xmin-delta_x Xmin+delta_x],...
                    'YData',[Y_0+delta_y Y_0]);
                end
                if(n==2)
                    g1=.95-delta_x;
                    g2=.95+delta_x;
                else
                    g1=0;
                    g2=0;
                end          
        end
    end

%sets object on lines to be very small, thus 'invisible'
    function delete_plot(num)
        switch(num)
            case(0)
                set(plot_handle0,...
                'XData',[0 .000001],...
                'YData',[0 .000001]);
            case(1)
                set(plot_handle1,...
                'XData',[0 .000001],...
                'YData',[0 .000001]);
            case(2)
                set(plot_handle2,...
                'XData',[0 .000001],...
                'YData',[0 .000001]);
            case(3)
                set(plot_handle3,...
                'XData',[0 .000001],...
                'YData',[0 .000001]);
            case(4)
                set(plot_handle4,...
                'XData',[0 .000001],...
                'YData',[0 .000001]);
            case(5)
                set(plot_handle5,...
                'XData',[0 .000001],...
                'YData',[0 .000001]);
            case(6)
                set(plot_handle6,...
                'XData',[0 .000001],...
                'YData',[0 .000001]);
            case(7)
                set(iYeti,...
                'XData',[0 .000001],...
                'YData',[0 .000001]);
        end
    end

%function to check for collision with yeti or tree
    function check_crash(object)        
            crash=0;
            %if left side of the player image is within an image of a tree,
            %then crash
            if(CURRENT_POS>=a1&&CURRENT_POS<=a2)
                crash=1;
            elseif(CURRENT_POS>=b1&&CURRENT_POS<=b2)
                crash=1;
            elseif(CURRENT_POS>=c1&&CURRENT_POS<=c2)
                crash=1;
            elseif(CURRENT_POS>=d1&&CURRENT_POS<=d2)
                crash=1;
            elseif(CURRENT_POS>=e1&&CURRENT_POS<=e2)
                crash=1;
            elseif(CURRENT_POS>=f1&&CURRENT_POS<=f2)
                crash=1;
            elseif(CURRENT_POS>=g1&&CURRENT_POS<=g2)
                crash=1;
            end
            
            %if right side of the player image is within an image of a tree,
            %then crash
            if(CURRENT_POS+.05>=a1&&CURRENT_POS+.05<=a2)
                crash=1;
            elseif(CURRENT_POS+.05>=b1&&CURRENT_POS+.05<=b2)
                crash=1;
            elseif(CURRENT_POS+.05>=c1&&CURRENT_POS+.05<=c2)
                crash=1;
            elseif(CURRENT_POS+.05>=d1&&CURRENT_POS+.05<=d2)
                crash=1;
            elseif(CURRENT_POS+.05>=e1&&CURRENT_POS+.05<=e2)
                crash=1;
            elseif(CURRENT_POS+.05>=f1&&CURRENT_POS+.05<=f2)
                crash=1;
            elseif(CURRENT_POS+.05>=g1&&CURRENT_POS+.05<=g2)
                crash=1;
            end

            %exectues algorithm if player crashes with a tree (reduce
            %health, display skull image, and sets score)
            if(object=='t')
                if(crash==1)
                    set(SKULL,'XData',[.05+CURRENT_POS CURRENT_POS-.05]);
                    if(HEALTH_COUNT==5)
                        set(HEALTH5,'XData',[0 .00001],'YData',[0 .00001]);
                    elseif(HEALTH_COUNT==4)
                        set(HEALTH4,'XData',[0 .00001],'YData',[0 .00001]);
                    elseif(HEALTH_COUNT==3)
                        set(HEALTH3,'XData',[0 .00001],'YData',[0 .00001]);
                    elseif(HEALTH_COUNT==2)
                        set(HEALTH2,'XData',[0 .00001],'YData',[0 .00001]);
                    elseif(HEALTH_COUNT==1)
                        set(HEALTH1,'XData',[0 .00001],'YData',[0 .00001]);
                    end
                    HEALTH_COUNT=HEALTH_COUNT-1;
                    SCORE=SCORE-200;
                else
                    SCORE=SCORE+200;
                end
                set(SCORE_STRING,'String',SCORE);
            end
            
            %exectues algorithm if player crashes with a yeti (reduce
            %health, display skull image, and sets score)
            if(object=='y')
                if(crash==1)
                    set(SKULL,'XData',[.05+CURRENT_POS CURRENT_POS-.05]);
                    if(HEALTH_COUNT==5)
                        set(HEALTH5,'XData',[0 .00001],'YData',[0 .00001]);
                    elseif(HEALTH_COUNT==4)
                        set(HEALTH4,'XData',[0 .00001],'YData',[0 .00001]);
                    elseif(HEALTH_COUNT==3)
                        set(HEALTH3,'XData',[0 .00001],'YData',[0 .00001]);
                    elseif(HEALTH_COUNT==2)
                        set(HEALTH2,'XData',[0 .00001],'YData',[0 .00001]);
                    elseif(HEALTH_COUNT==1)
                        set(HEALTH1,'XData',[0 .00001],'YData',[0 .00001]);
                    end
                    HEALTH_COUNT=HEALTH_COUNT-1;
                    SCORE=SCORE/2;
                else
                    SCORE=SCORE*2;
                end
                set(SCORE_STRING,'String',SCORE);
            end
    end

%function to initialize player and background
    function set_background        
        cdata1=imread('C:\Documents and Settings\w5v6\Desktop\FullBG','jpeg');
        image([0 1],[1 0],cdata1);
        tree_image;
        cdata2=imread('C:\Documents and Settings\w5v6\Desktop\Guy','jpeg');
        player=image([POS(PLAYER_POS)+.05 POS(PLAYER_POS)],[.15 0],cdata2);            
    end

%initialize health bar
    function health_bar
        cdata2=imread('C:\Documents and Settings\w5v6\Desktop\Skull','jpeg');
        SKULL=image([0 .00001],[.15 0],cdata2);
        SKULL1=image([.05 .1],[.95 .9],cdata2);
        SKULL2=image([.11 .16],[.95 .9],cdata2);
        SKULL3=image([.17 .22],[.95 .9],cdata2);
        SKULL4=image([.23 .28],[.95 .9],cdata2);
        SKULL5=image([.29 .34],[.95 .9],cdata2);
        cdata3=imread('C:\Documents and Settings\w5v6\Desktop\Health','jpeg');
        HEALTH1=image([.05 .1],[.95 .9],cdata3);
        HEALTH2=image([.11 .16],[.95 .9],cdata3);
        HEALTH3=image([.17 .22],[.95 .9],cdata3);
        HEALTH4=image([.23 .28],[.95 .9],cdata3);
        HEALTH5=image([.29 .34],[.95 .9],cdata3);
        HEALTH_COUNT=5;        
    end

%initialize images
    function tree_image
        cdata0=imread('C:\Documents and Settings\w5v6\Desktop\BigTree','jpeg');
        plot_handle0=image([0 .000001],[0 .000001],cdata0);
        plot_handle1=image([0 .000001],[0 .000001],cdata0);
        plot_handle2=image([0 .000001],[0 .000001],cdata0);
        plot_handle3=image([0 .000001],[0 .000001],cdata0);
        plot_handle4=image([0 .000001],[0 .000001],cdata0);
        plot_handle5=image([0 .000001],[0 .000001],cdata0);
        plot_handle6=image([0 .000001],[0 .000001],cdata0);
        cdata9=imread('C:\Documents and Settings\w5v6\Desktop\Yeti','jpeg');
        iYeti=image([0 .000001],[0 .00000001],cdata9);
    end

%function to move player
    function move_player(n)
        start(DAQ);
        %records DAQ values
        value=getdata(DAQ,1);
        %sets DAQ value to be a 1x1 matrix
        value=value(1,1);
        %if DAQ value is outside of equilibrium voltage range, position of
        %the player changes based on the magnitude of the DAQ value
        if((value<=-.4||value>=-.5)&&(value<=-1||value>=1))
            SPEED=(value/1);
            if((CURRENT_POS<=.95&&value>0)||(CURRENT_POS>=0&&value<0))
                CURRENT_POS=CURRENT_POS+(SPEED*TIMESTEP);
                set(player,...
                    'XData',[.05+CURRENT_POS CURRENT_POS]);
            end
        end
        stop(DAQ);
    end
end