

with flight_nos as (
	select cid, origin,destination, rank()over(partition by cid order by fid) as rnk 
    	from flights
    	),
final_destination as (
	select cid,destination, rnk
	from(
		select cid,destination, max(rnk) over(partition by cid order by cid) as max_rnk, rnk
		from flight_nos 
		)max_rnk
	where max_rnk=rnk
	),
origin as (
	select cid, origin
    	from flight_nos
	where rnk = 1
	)
	
select origin.cid, origin.origin, final_destination.destination
from origin, final_destination
where origin.cid = final_destination.cid

