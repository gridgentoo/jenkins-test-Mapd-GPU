select
  x100k,
  count(y10),
  sum(y10),
  max(y10),
  min(y10),
  avg(y10)
from
  ##TAB##
group by 
    x100k
limit 100