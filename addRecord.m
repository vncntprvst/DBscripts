function [already_exists, success, rec_id] = addRecord( newrecord, conn )
%addRecord Adds a new recording session to the database, if none already
%exists.

% Check for existing record
query = ['SELECT r.recording_id, g.location FROM recordings r INNER JOIN grid g ON r.grid_id_fk = g.grid_id WHERE a_file = ''' newrecord.name 'A'''];           
results = fetch(conn,query);
already_exists = ~isempty(results);
success = true;
if ~already_exists
    try
        col_names = {'recording_id','lm_coord','ap_coord','depth','task',...
            'recloc','a_file','e_file','sp2_file','date','grid_id_fk','sessions_id_fk'}; %grid_id_fk was grid_fid
        [subj, coord, depth] = name2coords(newrecord.name);
        grid = whichGrid(subj, newrecord.chamber, conn);
        session_id = whichSession(subj, newrecord.session, conn);
        this_data = {[],coord.lm,coord.ap,depth, newrecord.task, newrecord.recloc, ...
            [newrecord.name 'A'], [newrecord.name 'E'], [newrecord.name '.smr'], ...
            newrecord.date,grid{1},session_id{1}};
        datainsert(conn,'recordings',col_names, this_data);
        commit(conn);
        query = ['SELECT recording_id FROM recordings WHERE a_file = ''' newrecord.name 'A'''];           
        new_results = fetch(conn,query);
    catch
        success = false;
    end
end


% If this record has an unspecified grid and there is one available, update
% it
if already_exists
    rec_id = cast(results{1}, 'int32'); % casting to int8 led to max value 127 :[ 
    if strcmp(results{2},'UNKNOWN') && ~strcmp(newrecord.chamber,'UNKNOWN')
        [subj, ~, ~] = name2coords(newrecord.name);
        grid = {whichGrid(subj, newrecord.chamber, conn)};
        col_names = {'grid_id_fk'};
        update(conn,'recordings',col_names,grid{1},['WHERE recording_id = ' num2str(results{1}) ';']);
        commit(conn);
    end
%     update(conn,'recordings',{'task'},{newrecord.task},['WHERE recording_id = ' num2str(results{1}) ';']);
%     commit(conn);
%     update(conn,'recordings',{'recloc'},{newrecord.recloc},['WHERE recording_id = ' num2str(results{1}) ';']);
%     commit(conn);
else
    rec_id = cast(new_results{1}, 'int32');
end

end

