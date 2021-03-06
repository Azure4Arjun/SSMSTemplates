SELECT
    s.[Name] as [Schema]
,   t.[name] as [Table]
,   SUM(p.rows) as [RowCount]
FROM
    sys.schemas s
    LEFT OUTER JOIN 
        sys.tables t
        ON s.schema_id = t.schema_id
    LEFT OUTER JOIN 
        sys.partitions p
        ON t.object_id = p.object_id
    LEFT OUTER JOIN  
        sys.allocation_units a
        ON p.partition_id = a.container_id
WHERE
    p.index_id  in(0,1) -- 0 heap table , 1 table with clustered index
    AND p.rows is not null
    AND a.type = 1  -- row-data only , not LOB
GROUP BY 
    s.[Name]
,   t.[name]
ORDER BY 
    1
,   2