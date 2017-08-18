%connect to StarStim
stimElectrode = 1;
returnElectrode = 2; %#ok<*NASGU> % Not really used.
amplitude = 500; % Microampere
transition = 100; % Time to ramp up and down, in milliseconds.
host = 'moustache.vision.rutgers.edu'; % The PC that runs the NIC software.
template = 'left VLPFC';  % This template applies 0 mA for 1 hour. The online changes below implement the actual stimulation.
fake = true; % Set to true to test code without StarSTim connected.
delete(timerfindall); %  Should
ss = starstim(host,template,fake);
start(ss); % Start the template (= 0 mA "stimulation");
