
drop index ux_bank_code_branch on bank 
;
alter table bank add _ukey varchar(50) not null default ''
;
create index ix__ukey on bank (_ukey)
;
update bank set _ukey=objid where _ukey=''
;
create unique index uix_code_branchname on bank (code, branchname, _ukey)
;

create table ztmpdev_bank  
select 
  bankid as objid, null as state, bank_name as name, 
  case 
    when bank_name like 'banc%de%oro%' then 'BDO' 
    when bank_name like 'bank%phil%island%' then 'BPI' 
    when bank_name like 'china%bank%' then 'CB' 
    when bank_name like 'security%bank%' then 'SB' 
    when bank_name like 'union%bank%' then 'UB' 
    else '' 
  end as code, 
  '' as branchname, '' as address, 'local' as deposittype, 0 as depository 
from ( 
  select distinct cp.bankid, cp.bank_name
  from checkpayment cp 
    left join bank on bank.objid = cp.bankid 
  where cp.depositvoucherid is null
    and bank.objid is null 
  order by cp.bank_name 
)t1 
;
alter table ztmpdev_bank add finalbankid varchar(50) null 
;
alter table ztmpdev_bank add finalbankname varchar(255) null 
;
alter table ztmpdev_bank add finalbankcode varchar(50) null 
;
update ztmpdev_bank set finalbankcode = concat(code,'-') where finalbankcode is null 
;
update 
  ztmpdev_bank aa, ( 
    select t1.*, (select objid from  ztmpdev_bank where finalbankcode = t1.finalbankcode order by name limit 1) as finalbankid 
    from ( select distinct finalbankcode from ztmpdev_bank )t1 
  )bb 
set aa.finalbankid = bb.finalbankid 
where aa.finalbankcode = bb.finalbankcode 
;
update 
  ztmpdev_bank aa, ( 
    select distinct a.finalbankid, 
      (select name from ztmpdev_bank where objid = a.finalbankid limit 1) as finalbankname 
    from ztmpdev_bank a 
  )bb 
set aa.finalbankname = bb.finalbankname 
where aa.finalbankid = bb.finalbankid 
;
insert into bank (
  objid, state, name, code, branchname, address, deposittype, depository 
) 
select 
  z.objid, z.state, z.name, z.finalbankcode, z.branchname, z.address, z.deposittype, z.depository 
from ( select distinct finalbankid from ztmpdev_bank )t1 
  inner join ztmpdev_bank z on z.objid = t1.finalbankid 
;
update checkpayment aa,  ztmpdev_bank bb 
set aa.bankid = bb.finalbankid 
where aa.bankid = bb.objid 
;

alter table checkpayment add constraint fk_checkpayment_bankid 
  foreign key (bankid) references bank (objid) 
; 

drop table ztmpdev_bank
;
