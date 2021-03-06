
% get recording names from database
dbConn = connect2DB('vp_sldata'); 
unitsDBinfo=stdata.alldb;
unitList=unitsDBinfo.rec_id;  %cellfun(@(x) x.unit_id, unitsDBinfo); Changed to a table (see CellArrayOfStruct2Table)
recNames=fetch(dbConn,['SELECT a_file FROM recordings r WHERE r.recording_id IN (' ...
    sprintf('%.0f,' ,unitList(1:end-1)) num2str(unitList(end)) ')']);
% just to make sure, re-order 
[~,resort]=sort(unitList);[~,resort]=sort(resort);recNames=recNames(resort);

% add names to data structure
data.cmdata.alldb=[data.cmdata.alldb cell2table(recNames)];
stdata.fileNames=stdata.alldb.recNames;

