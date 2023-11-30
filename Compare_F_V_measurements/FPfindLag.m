function [ BegIdx, EndIdx, maxCorrVal] = FPfindLag( dataP,dataQ )
%FPFINDLAG Finds indexes for the Pusher data to be aligned with Qualisys
%   Finds the beginning index of the Qualisys recording in the Pusher data.
%   This is done using the correlation of all the channels measured by both
%   systems. The lag at which the maximum correlation is found for the
%   majority of the channels is chosen to be the beginning index. The
%   ending index is chosen to make the size of the aligned Pusher and
%   Qualisys data match. 
% INPUTS
% dataP: TreadmillRAWdata matrix with Pusher measurements
% dataQ: TreadmillRAWdata matrix with Qualisys measurements
% OUTPUTS
% BegIdx: Index at which the Pusher data should start to match the
% beginning of the Qualisys recording.
% EndIdx: Index at which the Pusher data should stop to match the ending of
% the Qualisys recording.
% COMMENTS
% The Pusher RAW data does not have the offset subtracted so some channels
% will not show the correlation pattern of the majority. The mode value of
% the lags is chosen to obtain a trustful value of BegIdx
% We know that in all the performed experiments so far (26-09-2019) the
% Pusher started recording before Qualisys and stopped recording after
% Qualisys. Thus, this function is designed to find the indexes at which
% the pusher data should be 'chopped' to match the beginning and end of
% Qualisys recording. If the recording order is not the same as described
% before, this function might give wrong ending values.
rowN = size(dataP,1);
for j = 1:rowN
   [caux,laux] = xcorr(dataP(j,:),dataQ(j,:));
   if j == 1
       maxCorrInd = zeros(rowN,1);
       maxCorrLag = zeros(rowN,1);
       Corrmat = zeros(rowN,length(caux));
       Lagmat = zeros(rowN,length(laux));
   end
   [maxCorrVal(j),ind] = max(caux);
   maxCorrInd(j) = ind;
   maxCorrLag(j) = laux(ind);
   Corrmat(j,:) = caux;
   Lagmat(j,:) = laux;    
end
BegIdx = mode(maxCorrLag);
EndIdx = size(dataQ,2) + BegIdx -1;
maxCorrVal = nanmean(maxCorrVal(j));
end

