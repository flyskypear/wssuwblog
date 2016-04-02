% Ying Zhang May, 2015, modified for wssuwblog tutorial April, 2016
% calculate RPS and RPSS

clear all
clc


% read observations, here we use synthetical data from randomly simulated
% data from normal distribution for the tutorial

obs = randn(29,1);

% read predicted/modeled data, again, we use hythetical data here
% and we have 100 predicted/modeled data in this case (it can also be just
% one deterministic prediction, instead of 100 predictions in normal dist.)

mod = repmat(obs,1,100) + normrnd(0,.5,29,100);

% if we plot this, we can see the 100 predictions and one observed t-s in
% thick black line
plot(mod)
hold on 
plot(obs,'k','linewidth',2)

%nc = the different categories you want to choose.  
%For example, for 30 years, nc=[10,10,10] for 3 equal categories.  
%You could choose nc=[5,20,5] if you were more interested in extremes.
nc = [7 , 8 , 7]; % sum to number of years (here = 29)

[nt,nr]=size(mod); % nt is number of time-steps and nr is number of predicted t-s

[a,b]=sort(obs);
ncs=cumsum(nc);

for l=1:length(nc)-1;
    thres(l)=a(ncs(l)+1); % find thresholds to define categories
end
thres=[-Inf thres +Inf];

clobs=NaN*ones(size(obs));
for i=1:length(nc);
    aa=find(obs >= thres(i) & obs < thres(i+1)); 
    clobs(aa)=i*ones(size(aa)); %assign obs to categoriy 1,2,3
end

classo=zeros(nt,length(nc));
for j=1:nt;
    classo(j,clobs(j))=[1]; % find pdf for obs in each category
end

for j=1:nt;
    modul=mod(j,:);
    for i=1:length(nc);
         aa=find(modul >= thres(i) & modul < thres(i+1));
         cl(i)=length(aa);
    end
    clmod(j,:)=cl;   % assign mod in yr j to categoriy 1,2,3 and find pdf
    clear cl aa modul        
end

clmod=clmod./nr;

classo=cumsum(classo'); %CDF
clmod=cumsum(clmod');   %CDF
RPS=sum((clmod-classo).^2);

climo=nc./nt;
climo=cumsum(climo(:));
climo=climo*ones(1,nt);
RPSclim=sum((climo-classo).^2);
RPSS=100*(1-(RPS./RPSclim));
RPSSmedian = median(RPSS);
% check the MatLab command window of the printed out RPSS score
disp([num2str(RPSSmedian),'%', ' - this is the RPSS score']) 
