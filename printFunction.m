function ret=printFunction(dataString,dataUser,Ncph)
    for i=1:length(dataString)
        fprintf('%c',dataString(1,i));
    end
    fprintf('----> ');
    for i=1:Ncph
        fprintf('%d(%d->%d)  ',dataUser(1,i),dataUser(2,i),dataUser(3,i))
    end
    fprintf('\n');
end