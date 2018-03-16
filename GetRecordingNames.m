% get recording names from database

unitList=unitsDBinfo.rec_id;  %cellfun(@(x) x.unit_id, unitsDBinfo); Changed to a table
recNames=fetch(dbConn,['SELECT a_file FROM recordings r WHERE r.recording_id IN (' ...
    sprintf('%.0f,' ,unitList(1:end-1)) num2str(unitList(end)) ')']);
% just to make sure, re-order 
[~,resort]=sort(unitList);[~,resort]=sort(resort);recNames=recNames(resort);

% add names to data structure
data.gsdata.alldb=[data.gsdata.alldb cell2table(recNames)];


