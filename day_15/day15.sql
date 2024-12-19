SELECT place_name  
FROM sleigh_locations
INNER JOIN areas
ON ST_DWITHIN(coordinate::geography, polygon::geography, 0)