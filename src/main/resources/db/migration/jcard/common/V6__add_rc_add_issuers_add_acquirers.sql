INSERT INTO public.rc(id, mnemonic, description)
VALUES (9450, 'international.cashback.not.allowed', 'International Cashback not allowed');

INSERT INTO public.rc_locale(id,resultcode,resultinfo,extendedresultcode,locale)
VALUES (9450, 9450, 'International Cashback not allowed', null, 'JCARD');

INSERT INTO public.rc(id, mnemonic, description) VALUES (5000, 'purchase.only.amount.approved', 'Purchase amount only approved');

INSERT INTO public.rc_locale(id,resultcode,resultinfo,extendedresultcode,locale) VALUES (5000,5000, 'Purchase amount only approved',null,'JCARD');

INSERT INTO issuers (id, institutionid, active, name, tz, startdate, enddate, journal, assetsaccount, earningsaccount)
select 1, '00000000002', 'Y', '${issuerName}-mc', 'UTC', current_date, '2100-01-01', 0, acc.id, 35
from acct acc
where acc.id = 3
  and 0 = (select count(id) from issuers where id = 1) limit 1;

INSERT INTO acquirers (id, active, institutionid, name, transactionaccount, feeaccount, refundaccount, depositaccount, issuer)
select 1, 'Y', '00000000002', 'MASTERCARD', acc.id, 19, 10, 11, 1
from acct acc
where acc.id = 18
  and 0 = (select count(id) from acquirers where id = 1) limit 1;
