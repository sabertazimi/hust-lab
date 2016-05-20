function slide=dskdemo2;
%DSKDEMO2 Control Toolbox demonstration
%   This MATLAB demo adapted from ...
%   DISKDEMO.M Demonstration design of a hard disk digital controller.

%   Ned Gulley, 6-21-93
%   Copyright (c) 1986-98 by The MathWorks, Inc.
%   $Revision: 1.9 $  $Date: 1998/12/23 18:40:13 $

% This is a slideshow file for use with playshow.m and makeshow.m
% Too see it run, type 'playshow dskdemo2', 

%========== Slide 1 ==========
if nargout<1,
  playshow dskdemo2
else
  %========== Slide 1 ==========

  slide(1).code={
      'cla reset;',
      'dskwheel(.5,.6,.3);',
      'hold on',
      'x1=0.2109;',
      'y1=0.2670;',
      'dskwheel(x1,y1,0.05);',
      'x=[0.2487,0.5563,0.5685,0.2701,0.2518]-0.05;',
      'y=[0.2853,0.3980,0.3736,0.2457,0.2853];',
      'fill(x,y,''w'');',
      'plot(0.5,0.5,''k.'',''MarkerSize'',20);',
      'axis square',
      'title(''Disk Platen - Read/Write Head'');',
      'hold on',
      'set(gca,''XTick'',[],''YTick'',[],''box'',''on'',''Ylim'',[.1 1.1],''Xlim'',[0 1])'};
  slide(1).text={
      ' Press the "Start" button to see an example of the           ',
      ' Control System Toolbox being used to design a controller    ',
      ' for a disk drive read/write head.                           ',
      '                                                             '};
      
  %========== Slide 2 ==========

  slide(2).code={
      'cla reset;',
      'dskwheel(.5,.6,.3);',
      'hold on',
      'x1=0.2109;',
      'y1=0.2670;',
      'dskwheel(x1,y1,0.05);',
      'x=[0.2487,0.5563,0.5685,0.2701,0.2518]-0.05;',
      'y=[0.2853,0.3980,0.3736,0.2457,0.2853];',
      'fill(x,y,''w'');',
      'plot(0.5,0.5,''k.'',''MarkerSize'',20);',
      'axis square',
      'title(''Disk Platen - Read/Write Head'');',
      'hold on',
      'set(gca,''XTick'',[],''YTick'',[],''box'',''on'',''Ylim'',[.1 1.1],''Xlim'',[0 1])'};
  slide(2).text={
      ' Our task is to design a digital controller that can be used to ',  
      ' provide accurate positioning of the read/write head.           ',  
      ' Conceptually, this is very similar to moving (as quickly as    ',  
      ' possible) the tone-arm of a record-player to a certain track.  ',  
      ' The task is tricky because there is always some flexibility in ',  
      ' the mechanism, and bad control law design can lead to poor     ',  
      ' performance (slow track-finding) or even instability, where the',  
      ' read/write head hopelessly flails back and forth.              '};

  %========== Slide 3 ==========

  slide(3).code={
      'ax = findobj(gcf,''Type'',''axes'');'
      'axesPos = get(ax(end),''position'');',
      'set(gca,''position'',axesPos);',
      'dskwheel(.5,.6,.3);',
      'hold on',
      'x1=0.2109;',
      'y1=0.2670;',
      'dskwheel(x1,y1,0.05);',
      'x=[0.2487,0.5563,0.5685,0.2701,0.2518]-0.05;',
      'y=[0.2853,0.3980,0.3736,0.2457,0.2853];',
      'fill(x,y,''w'');',
      'plot(0.5,0.5,''k.'',''MarkerSize'',20);',
      'axis square',
      'title(''Disk Platen - Read/Write Head'');',
      'hold on',
      'set(gca,''XTick'',[],''YTick'',[],''box'',''on'',''Ylim'',[.1 1.1],''Xlim'',[0 1])'};
  slide(3).text={
      ' First we will enter the mathematical model for the plant. We ',  
      ' will model this system as a simple second order plant. The   ',  
      ' inertia of the head assembly I=0.01 kg-m^2, the viscous      ',  
      ' damping coefficient C=0.004 N-m/(rad/sec), the return spring ',  
      ' constant K=10 N-m/rad, and the motor torque constant         ',  
      ' Ki=0.05 N-m/rad.                                             ',  
      '                                                              ',  
      ' >> I=0.01; C=0.004; K=10; Ki=0.05;                           '};

  %========== Slide 4 ==========

  slide(4).code={
      'I = 0.01; C = 0.004; K = 10; Ki = 0.05; Ts = 0.005;',
      'sys = tf(Ki,[I C K]);',
      'sys = c2d(sys,Ts);',
      'w = logspace(0,3);',
      'cla reset',
      'step(sys);',
      'drawnow'};
  slide(4).text={
      ' Next, we must discretize our plant since it is continuous.   ',  
      ' Since our plant will have a digital-to-analog-converter (with',  
      ' a zero-order hold) connected to its input, use the "zoh"    ',  
      ' discretization method of the function C2D. Use sample       ',  
      ' time Ts = 0.005  (5 ms). A step response plot is shown.     ', 
      ' >> sys = tf(Ki,[I C K]);',
      ' >> sys = c2d(sys,0.005);            ', 
      ' >> step(sys);                                            '};

  %========== Slide 5 ==========

  slide(5).code={
      'zgrid(''new''),',
      'axis square',
      'pzmap(sys);',
      'drawnow'};
  slide(5).text={
   ' Clearly the damping is far too light! The system oscillates',  
      ' quite a bit. We can check this by computing and plotting   ',  
      ' the open loop eigenvalues with the PZMAP command.          ',  
      '                                                            ',  
      ' >> zgrid(''new''); axis square;                           ',  
      ' >> pzmap(sys)                                             '};

  %========== Slide 6 ==========

  slide(6).code={
      'zgrid(''new''),',
      'axis square',
      'rlocus(sys);',
      'set(gca,''Xlim'',[-1 1],''Ylim'',[-1.5,1.5]);',
      'drawnow'};
  slide(6).text={
      ' Note that the poles are very lightly damped and near the   ',  
      ' unit circle. We need to design a compensator that increases',  
      ' the damping of this system. Let''s try the most basic      ',  
      ' compensator: a simple gain.                                ',  
      '                                                            ',  
      ' >> zgrid(''new''); rlocus(sys);                            '};

  %========== Slide 7 ==========

  slide(7).code={
      'drawnow',
      'sysc = zpk(0.85,0,1,0.005);',
      'sys2 = sysc * sys;' };
  slide(7).text={
      ' As shown in the root locus, the poles quickly leave the unit',  
      ' circle and go unstable. We need to introduce some lead or   ',  
      ' a compensator with some zeros. We will try the compensator  ',  
      ' D(z)=K(z+a)/(z+b), where a=-0.85 and b=0 and connect the    ',  
      ' compensator in series with the plant.                       ',  
      '',
      '    >> sysc = zpk(0.85,0,1,0.005);                             ',  
      '    >> sys2 = sysc * sys;                                ',  
      '                                                             '};

  %========== Slide 8 ==========

  slide(8).code={
      'ax = findobj(gcf,''Type'',''axes'');'
      'axesPos = get(ax(end),''position'');',
      'set(gca,''position'',axesPos);',
      'zgrid(''new'');',
      'axis square',
      'rlocus(sys2);',
      'k=4100;',
      'r=rlocus(sys2,k);',
      'hold on;',
      'plot(r,''+'');',
      'set(gca,''Xlim'',[-1 1],''Ylim'',[-1.5,1.5]);',
      'hold off' };
  slide(8).text={
   ' Here is another root locus plot. This time the poles stay    ',  
      ' within the unit circle for some time. By choosing a gain with',  
      ' reasonable damping, we can arrive at a suitable design.      ',  
      ' The "+" symbol shows the final location of the closed-loop   ',  
      ' roots.                                                       ', 
      '',
      '   >> k = 4100; r = rlocus(sys2,k);                           ',  
      '   >> plot(r,''+'')                                           '};

  %========== Slide 9 ==========

  slide(9).code={
      'cla reset;',
      'sysc = feedback(sys2,k);',
      'step(sysc)',
      'drawnow' };
  slide(9).text={
      ' Here is the closed-loop step response for our disk drive.   ',  
      ' The response looks pretty good and settles in about 14      ',  
      ' samples (which is 14*Ts, or 0.07 secs). At this point, we   ',  
      ' can consider the design complete, or try to refine it. ',  
      '                                                             ',  
      ' >> sysc = feedback(sys2,k);                                 ',  
      ' >> step(sysc);                                              '};

 end   % End of demo
