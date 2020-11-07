Ns=input('Enter the no of stator slots: ');
Nm=input('Enter the no of permanent magnets: ');
Ncph=Ns/3;
sstar=max(floor(Ns/Nm),1);
for q=1:(Nm/2-1)
    knot=((2*Ns)/(3*Nm))*(1+3*q);
    if floor(knot)==knot
        break;
    end
end
%knot
thetak=zeros(1,Ns);
thetaAbsolute=zeros(1,Ns);
inOutPattern=zeros(2,Ns);
for k=1:Ns
    thetak(1,k)=180*(k-1)*(Nm/Ns);
    thetaAbsolute(1,k)=rem(thetak(1,k)+180,360)-180;
    if abs(thetaAbsolute(1,k))>90
        if thetaAbsolute(1,k)>0
            thetaAbsolute(1,k)=thetaAbsolute(1,k)-180;
        else
            thetaAbsolute(1,k)=180-abs(thetaAbsolute(1,k));
        end
        if rem(k+sstar,Ns)==0
            %fprintf('slot-%d....%d -> %d\n',k,Ns,k);
            inOutPattern(1,k)=Ns;
            inOutPattern(2,k)=k;
        else
            %fprintf('slot-%d....%d -> %d\n',k,rem(k+sstar,Ns),k);
            inOutPattern(1,k)=rem(k+sstar,Ns);
            inOutPattern(2,k)=k;
        end
    else
        if rem(k+sstar,Ns)==0
            %fprintf('slot-%d....%d -> %d\n',k,k,Ns);
            inOutPattern(1,k)=k;
            inOutPattern(2,k)=Ns;
        else
            %fprintf('slot-%d....%d -> %d\n',k,k,rem(k+sstar,Ns));
            inOutPattern(1,k)=k;
            inOutPattern(2,k)=rem(k+sstar,Ns);
        end
    end
end
%thetak
%to see the angle table see the thetaAbsolute
thetaAbsolute;
shortedTheta=sort(thetaAbsolute,'ascend');
%to see the selected thetas for a phase for better motor performance see
%the finalThetas
finalThetas=shortedTheta(1,Ncph+1:2*Ncph);
uniqueThetas=unique(finalThetas);
finalslotNumber=zeros(1,Ncph);
k=1;% to count the matched angles
flag=0;%to break the nested loop
for i=1:length(uniqueThetas)
    for j=1:Ns
        if k > Ncph && i<length(uniqueThetas)
            flag=1;
            display('Mulitple slot combinations for a phase exists');
            break;
        end
        if uniqueThetas(1,i)==thetaAbsolute(1,j)
            finalslotNumber(1,k)=j;
            k=k+1;
        end
    end
    if flag==1
        break;
    end
end
selectedSlotsPHASE_A=sort(finalslotNumber,'ascend');
selectedSlotsPHASE_B=rem(selectedSlotsPHASE_A+knot,Ns);
for i=1:Ncph
    if selectedSlotsPHASE_B(1,i)==0
        selectedSlotsPHASE_B(1,i)=Ns;
    end
end
selectedSlotsPHASE_C=rem(selectedSlotsPHASE_B+knot,Ns);
for i=1:Ncph
    if selectedSlotsPHASE_C(1,i)==0
        selectedSlotsPHASE_C(1,i)=Ns;
    end
end
phaseAPattern=zeros(3,Ncph);
for i=1:Ncph
    phaseAPattern(1,i)=selectedSlotsPHASE_A(1,i);
    phaseAPattern(2,i)=inOutPattern(1,selectedSlotsPHASE_A(1,i));
    phaseAPattern(3,i)=inOutPattern(2,selectedSlotsPHASE_A(1,i));
end
phaseBPattern=rem(phaseAPattern+knot,Ns);
phaseCPattern=rem(phaseBPattern+knot,Ns);
for i=1:3
    for j=1:Ncph
        if phaseBPattern(i,j)==0
            phaseBPattern(i,j)=Ns;
        end
        if phaseCPattern(i,j)==0
            phaseCPattern(i,j)=Ns;
        end
    end
end
display('Motor winding pattern [slot(in->out)]');
printFunction('PHASE-A slots',phaseAPattern,Ncph)
printFunction('PHASE-B slots',phaseBPattern,Ncph)
printFunction('PHASE-C slots',phaseCPattern,Ncph)

%to see in out table uncommnent it
%inOutPattern

% S=input('\nenter the motor RPM: ');
% fe=(Nm/120)*S;
% fprintf('commutation frequency = %f\n',fe);
% RPMvsCOMMFREQ=zeros(1,100);
% for i=1:100
%     RPMvsCOMMFREQ(1,i)=(Nm/120)*i;
% end    
% plot(RPMvsCOMMFREQ)


% T=5.84;
 Nc=Ncph;
% Lst=0.0278;
% Rro=0.075;
% Bg=1;
% i=8.552;
% N=T/(2*Nc*Bg*Lst*Rro*i);
% fprintf('no of turns needed = %f\n',N);



% T=zeros(1,50);
% N=1:50;
% for j=1:50
%     T(1,j)=2*Nc*N(1,j)*Bg*Rro*Lst*i;
% end
% % plot(N,T)

%parameters for 18S20P motor
Ebmax=48;
Bg=1;
Lst=1*0.0254;
Rro=(3.7/2)*0.0254;
wm=Ebmax/(2*Ncph*15*Bg*Lst*Rro);
wm=(wm/4.47)*9.55

sample=50;
wm=zeros(1,sample);
T=zeros(1,sample);
N=1:sample;
i=2;
for j=1:sample
    wm(1,j)=Ebmax/(2*Ncph*N(1,j)*Bg*Lst*Rro);
    wm(1,j)=(wm(1,j)/4.47)*9.55;
    
    T(1,j)=2*Nc*N(1,j)*Bg*Rro*Lst*i*4.47;
end
plot(N,wm), xlabel('turns'), ylabel('RPM'), title('RPM Vs Turns'),
grid on,
figure,plot(N,T), xlabel('turns'), ylabel('Torque'), title('Torque Vs Turns'),
grid on

a=360/(3*Nm/2);
b=360/Ns;

for i=1:15
    if floor(a*i/b)==(a*i/b)
        slotsBwtHS=(a*i/b);
        break;
    end
end
fprintf('no of slots between hall sensors is %d\n',slotsBwtHS);


