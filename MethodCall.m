function [Btest, Bdata, Tdata] = MethodCall(Xtest, Xdata, bit, method, para, numTrain)
% input
% Xtest: test data
% Xdata: data from the dataset
% bit: the number of the bits
% method: the name of the method
% para: the parameter of the method
% numTrain: the number of the training data

% output
% Btest: binary codes of the test data
% Bdata: binary codes of the data from the dataset
% Tdata: the training time

% zero mean
m = mean(Xdata);
Xdata = bsxfun(@minus, Xdata, m);
Xtest = bsxfun(@minus, Xtest, m);

switch(method)

    % Locality sensitive hashing (LSH)
    case 'LSH'
        XX = [Xdata; Xtest];
        XX = XX * randn(size(XX,2),bit);
        Y = zeros(size(XX));
        Y(XX>=0)=1;
        Y = compactbit(Y);
        
        Tdata = 0;
        nTraining = size(Xdata, 1);
        Bdata = Y(1:nTraining,:);
        Btest = Y(nTraining+1:end,:);
        clear XX:
        clear Y;
        
        
    
       % ITQ method 
    case 'ITQ'
        % PCA

        XX = [Xdata; Xtest];
        rl = randperm(size(Xdata, 1));
		
        tic;
        [pc, l] = eigs(cov(double(Xdata(rl(1:numTrain),:))),bit);
        
        XX = XX * pc;
        % ITQ
        addpath('/common_code/itq');
        nTraining = size(Xdata, 1);
        [Y, R] = ITQ(XX(rl(1:numTrain),:),50);
        Tdata = toc;
        XX = XX*R;
        Y = zeros(size(XX));
        Y(XX>=0) = 1;
        Y = compactbit(Y>0);

        Bdata = Y(1:nTraining,:);
        Btest = Y(nTraining+1:end,:);
        clear XX;   
        clear Y;
        rmpath('/common_code/itq');
        
        
        
       % Concatenation Hashing method  
    case 'CH'
   
        addpath('/common_code/itq');
        
        KB = para.KB; % number of the clusters, 2 for 32 bits, and 4 for 64 bits as well as 128 bits
        rl = randperm(size(Xdata, 1));
        Xtrain = Xdata(rl(1:numTrain),:);
        
        tic;
       
        for i = 1 : 30
            if i == 1
                rrl = randperm(size(Xtrain, 1));
                centers = Xtrain(rrl(1:KB), :);
            else
                for j = 1 : KB
                    l = find(assignments == j);
                    centers(j, :) = mean(Xtrain(l, :), 1);
                end
            end
            DD = zeros(size(Xtrain, 1), KB);
            for j = 1 : KB
                D = bsxfun(@minus, Xtrain, centers(j, :));
                D = sum(D .^ 2, 2);
                DD(:, j) = D;
            end
            [~, assignments] = min(DD, [], 2);
        end

        
        XX = [Xdata; Xtest];
        
        display('clustering finished');
        
        
        bitRotation = zeros( KB, size(XX,2), bit/KB );
        bitMeans = zeros( KB, size(XX,2) );
        for i = 1 : KB
            tic;
            RX =  Xtrain(find(assignments==i),:);
            bitMeans( i, : ) = mean( RX, 1 );
            RX = bsxfun(@minus, RX, bitMeans( i, : ));
            [pc,~] = eigs(cov(double(RX)),bit/KB);
            RX = RX * pc;
            [Y, R] = ITQ(RX,50);
            toc;
            bitRotation( i, :, : ) = pc * R;
        end
        display('ITQ finished');
        Tdata = toc;
        nTraining = size(Xdata, 1);
        Bdata = zeros( nTraining, bit );
        Btest = zeros( size(XX,1)-nTraining, bit );
        
        
        
        tic;
        for i = 1 : KB
            RR = reshape(bitRotation( i, :, : ),[size(XX,2), bit/KB]);
            RX = bsxfun(@minus,XX( 1:nTraining, : ),bitMeans(i,:));
            RX = RX * RR;
            Bdata( :, (i-1)*(bit/KB)+1:i*(bit/KB))= (RX >= 0);
        end
        toc;
        tic;
        for i = 1 : KB
            RR = reshape(bitRotation( i, :, : ),[size(XX,2), bit/KB]);
            RX = bsxfun(@minus,XX( nTraining+1:end, : ),bitMeans(i,:));
            RX = RX * RR;
            Btest( :, (i-1)*(bit/KB)+1:i*(bit/KB))= (RX >= 0);
        end
        toc;
        display('encoding finished');
        Bdata = compactbit(Bdata);
        Btest = compactbit(Btest);        
        clear XX;
        rmpath('/common_code/itq');
        
end