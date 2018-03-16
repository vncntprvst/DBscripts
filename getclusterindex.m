function clusterIdx=getclusterindex(dbConn,unitList,extraField)
% get cluster index from database

if nargin > 2
    clusterIdx=fetch(dbConn,['SELECT profile_type,' extraField ' FROM clusters c WHERE c.cluster_id IN (' ...
        sprintf('%.0f,' ,unitList(1:end-1)) num2str(unitList(end)) ')']);
    [~,resort]=sort(unitList);[~,resort]=sort(resort);
    clusterIdx=cell2mat(clusterIdx(resort,:));
else
    clusterIdx=fetch(dbConn,['SELECT profile_type FROM clusters c WHERE c.cluster_id IN (' ...
        sprintf('%.0f,' ,unitList(1:end-1)) num2str(unitList(end)) ')']);
    [~,resort]=sort(unitList);[~,resort]=sort(resort);
    clusterIdx=[clusterIdx{resort}]';
end
