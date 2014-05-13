-------------------------
-- Flite Deck Database --
-------------------------

-- AIRPORT
select
airportid, iata_cd, closest_airportid,
UPPER(airport_name), UPPER(city_name), state_cd,
country_cd, ct1.value as timezone_cd, elevation_qty,
longest_runway_length_qty, latitude_qty, longitude_qty,
DECODE(instrument_approach_flag, 'T', 1, 0) instrument_approach_flag,
DECODE(INSTR(jeta_fuel_flag || jeta1_fuel_flag || jeta1plus_fuel_flag, 'T'), 0, 0, 1) fuel,
DECODE(customs_entry_flag, 'T', 1, DECODE(customs_landing_flag, 'T', 1, 0)) customs,
DECODE(airportid, 'KDCA', 'YES', 'KLGA', 'YES', 'CYYZ', 'YES', '07FA', 'YES', 'S05', 'YES', 'NO') slot_req
from
airport a, code_table_int ct1
where
a.airport_closed_flag = 'F'
and a.landing_type_cd = 'A'
and a.timezoneid_cd = ct1.codetableintid(+)
order by
country_cd, airportid

-- FBO
select
vendorid as fbo_id, replace(initcap(upper(vendor_name)), 'Netjets', 'NetJets') as fbo_name, airportid,
fbo_ranking_qty, decode(ct.codetableintid, 623, 'Approved', ct.value) as status,
summer_operating_hour_desc, winter_operating_hour_desc, sys_last_changed_ts
from
fbo f, code_table_int ct
where
f.vendor_status_id = ct.codetableintid(+) and
upper(vendor_name) not like '%DELETE%' and
upper(vendor_name) not like '%CLOSED%' and
upper(vendor_name) not like '%CUSTOMS%' and
vendor_name not like '~%' and
ct.codetableintid not in (227,229) and
airportid in (
select
airportid
from
airport a
where
a.airport_closed_flag = 'F'
and a.landing_type_cd = 'A'
)
order by
airportid

-- FBO ADDRESS
select
addressid, vendorid, initcap(upper(address_line1_txt)), initcap(upper(address_line2_txt)),
initcap(upper(address_line3_txt)), initcap(upper(address_line4_txt)), initcap(upper(address_line5_txt)),
city_name, state_province_name, postal_cd, country_cd,
sys_last_changed_ts
from
address
where
address_type_id=524 and
upper(city_name) != 'UNKNOWN' and
vendorid in (
select
vendorid
from
fbo f, code_table_int ct
where
f.vendor_status_id = ct.codetableintid(+) and
upper(vendor_name) not like '%DELETE%' and
upper(vendor_name) not like '%CLOSED%' and
upper(vendor_name) not like '%CUSTOMS%' and
vendor_name not like '~%' and
ct.codetableintid not in (227,229) and
airportid in (
select
airportid
from
airport a
where
a.airport_closed_flag = 'F'
and a.landing_type_cd = 'A'
)
)
order by country_cd, state_province_name

-- FBO PHONE
select
telephoneid, thevendor_vendorid fbo_id,
country_code_txt, area_code_txt, telephone_nbr_txt,
sys_last_changed_ts
from
telephone
where
telephone_type_id=1 and
telephone_nbr_txt not in ('0000000','0000','0','111111','00000000','00000') and
thevendor_vendorid in (
select
vendorid
from
fbo f, code_table_int ct
where
f.vendor_status_id = ct.codetableintid(+) and
upper(vendor_name) not like '%DELETE%' and
upper(vendor_name) not like '%CLOSED%' and
upper(vendor_name) not like '%CUSTOMS%' and
vendor_name not like '~%' and
ct.codetableintid not in (227,229) and
airportid in (
select
airportid
from
airport a
where
a.airport_closed_flag = 'F'
and a.landing_type_cd = 'A'
)
)

-- AIRCRAFT TYPE
-- Seems to be missing the Global 5000 and the Challenger 350
select * from (
select
typename, type_full_name, cabin_size_cd,
NVL(DECODE(typename, 'EMB-505', 7, pax_seat_qty), 0) as pax_seat_qty,
DECODE(typename, 'EMB-505', 3500, min_runway_length_qty) as min_runway_length_qty,
high_cruise_speed_qty, max_flying_time_qty, sys_last_changed_ts,
DECODE(typename,
  'CE-550-B', 'Citation Bravo',
  'CE-560', 'Citation V Ultra',
  'CE-560E', 'Citation Encore/+',
  'CE-560EP', 'Citation Encore/+',
  'CE-560XL', 'Citation Excel/XLS',
  'CE-560XLS', 'Citation Excel/XLS',
  'CE-680', 'Citation Sovereign',
  'CL-350', 'Challenger 350',
  'GL5000S', 'GLOBAL 5000',
  'GL6000S', 'GLOBAL 6000',
  'BD700-1A11', 'Global 5000',
  'BE-400A', 'Hawker 400XP',
  'CE-750', 'Citation X',
  'DA-7X', 'Falcon 7x',
  'DA-2000', 'Falcon 2000EX/2000',
  'DA-2EASY', 'Falcon 2000EX/2000',
  'DA-2000LX', 'Falcon 2000EX/2000',
  'EMB-505', 'Phenom 300',
  'G-200', 'G200',
  'GIV-SP', 'G450/G400/GIV-SP',
  'G-400', 'G450/G400/GIV-SP',
  'G-450', 'G450/G400/GIV-SP',
  'GV', 'G550/GV',
  'G-550', 'G550/GV',
  'H700', 'Hawker 700',
  'HS-125-750', 'Hawker 750',
  'HS-125-800XP', 'Hawker 900XP/800XP',
  'HS-125-800XPC', 'Hawker 900XP/800XP',
  'HS-125-900XP', 'Hawker 900XP/800XP',
  '') typegroupname
from
aircraft_type
where
-- Explicitly name the types that FliteDeck is using
typename in (
    'CE-550-B',
    'CE-560',
    'CE-560E',
    'CE-560EP',
    'CE-560XL',
    'CE-560XLS',
    'CE-680',
    'BE-400A',
    'CE-750',
    'DA-7X',
    'DA-2000', 
    'DA-2EASY',
    'DA-2000LX',
    'EMB-505',
    'G-200',
    'GIV-SP',
    'G-400',
    'G-450',
    'GV',
    'G-550',
    'H700',
    'HS-125-750',
    'HS-125-800XP',
    'HS-125-800XPC',
    'HS-125-900XP'
 )
union all
select 'CL-350', 'Challenger 350', 'M', 9, 4600, 470, 7.3, SYSDATE, 'Challenger 350' from dual
union all
select 'GL5000S', 'GLOBAL 5000', 'L', 13, 4500, 470, 10.3, SYSDATE, 'Global 5000' from dual
union all
select 'GL6000S', 'GLOBAL 6000', 'L', 13, 4500, 470, 10.3, SYSDATE, 'Global 6000' from dual
) order by typename

-- AIRCRAFT RESTRICTION
select
ar.aircraftrestrictionsid, ar.type_name, ar.airport_id,
ar.approval_status_id, DECODE(ar.approval_status_id, 552, 'Prohibited', 553, 'Prohibited until Reviewed', ctt.value) restriction_type,
DECODE(r.for_takeoff, 'F', 0, 1) takeoff, DECODE(r.for_landing, 'F', 0, 1) landing, r.comment_txt
from
aircraft_restrictions ar,
(select aircraft_restriction_id, restriction_type_id, for_landing, for_takeoff, comment_txt from restriction
   where owner_services='T' and restriction_type_id not in (8,13) and UPPER(comment_txt) not like '%EJM%' and UPPER(comment_txt) not like '%EXECUTIVE JET MANAGEMENT%') r,
(select code, value from code_table_trans where tag='AircraftRestrictionType') ctt
where
ar.aircraftrestrictionsid=r.aircraft_restriction_id(+) and
ar.ej_company_id IN (1000001,1000011,1000012,1000021) and
ar.approval_status_id in (552,553) and
r.restriction_type_id=ctt.code(+) and
ar.airport_id in (
select
airportid
from
airport a
where
a.airport_closed_flag = 'F'
and a.landing_type_cd = 'A'
) and
type_name in (
'CE-550B'
,'GL5000S'
,'GL6000S'
,'BE-400A'
,'CE-560'
,'CE-560E'
,'CE-560EP'
,'CE-560XL'
,'CE-560XLS'
,'CE-680'
,'CE-750'
,'DA-2000'
,'DA-2000LX'
,'DA-2EASY'
,'DA-7X'
,'EMB-505'
,'EMB-505S'
,'G-200'
,'G-400'
,'G-450'
,'G-550'
,'GIV-SP'
,'GV'
,'HS-125-750'
,'HS-125-800XP'
,'HS-125-800XPC'
,'HS-125-900XP'
,'CL-350'
 )
 
 
---------------------------------
-- Flight & Trip Time Database --
---------------------------------

-- TurnTimeData 
select 
	e.AIRCRAFT_TYPE_BY_PROGRAM_ID,
	e.PROGRAM_ID,
	e.TYPE_NAME,
	e.MIN_NONREVENUE_TURN_TIME_QTY,
	e.MIN_REVENUE_TURN_TIME_QTY,
	e.ASAP_TURN_TIME_QTY,
	e.TECH_TURN_TIME_QTY,
	e.INTERNATIONAL_TURN_TIME_QTY,
	TO_CHAR(e.SYS_LAST_CHANGED_TS, 'mm/dd/yyyy HH24:MI')  lastChanged
from AIRCRAFT_TYPE_BY_PROGRAM e

-- StageDistSpeedData
select 
	e.STAGE_DIST_AND_SPEED_ID,
	e.AIRCRAFT_TYPENAME,
	e.DISTANCE_QTY,
	e.AVERAGE_SPEED_QTY,
	TO_CHAR(e.SYS_LAST_CHANGED_TS, 'mm/dd/yyyy HH24:MI')  lastChanged
from STAGE_DIST_AND_SPEED e

-- WindCorrectionsData
select 
	e.WINDCORRECTIONID,
	e.SPRING_FALL_CORRECTION,
	e.WINTER_CORRECTION,
	e.TRUE_COURSE,
	e.LATITUDE,
	e.SUMMER_CORRECTION,
	TO_CHAR(e.SYS_LAST_CHANGED_TS, 'mm/dd/yyyy HH24:MI')  lastChanged
from WIND_CORRECTIONS e

-- EnduranceEntryData
select 
  e.ENDURANCE_ENTRY_ID enduranceEntryId,
  e.AIRCRAFT_TYPENAME aircraftType,
  e.NUM_PAX numberOfPax,
  e.HEADWIND headwind,
  e.ENDURANCE endurance,
  e.RANGE range,
  TO_CHAR(e.SYS_LAST_CHANGED_TS, 'mm/dd/yyyy HH24:MI')  lastChanged
from endurance_entry e


