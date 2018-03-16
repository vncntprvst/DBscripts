function [col_names, this_data] = dataFromSort(conn, newsort )
%dataFromSort formats column names and data for database insertion
col_names = {'sort_id', 'processed_mat', 'comments', 'user', 'origin',...            
        's_file', 't_file', 'recording_id_fk'}; % recording_id_fk was recording_fid
    ssdir = getSsdir(conn);
    subj = whichSubj(newsort.name(1));
    if strcmp(newsort.origin,'Rex')
        this_data = {[],['processed\' subj '\'  newsort.name '.mat'],...
        newsort.comments, ...
        newsort.user, ...
        newsort.origin, ...
        '', ...
        '', ...
        newsort.parent};
    elseif strcmp(newsort.origin,'Spike2')
    this_data = {[],['processed\' subj '\'  newsort.name '.mat'],...
        newsort.comments, ...
        newsort.user, ...
        newsort.origin, ...
        [subj '\Spike2Exports\'  newsort.name 's.mat'], ...
        [subj '\Spike2Exports\'  newsort.name 't.mat'], ...
        newsort.parent};
    end
end

