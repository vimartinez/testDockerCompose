---------------------
-- Test data: ISOR --
---------------------

----------
-- acct --
----------
INSERT INTO acct (id, subclass, root, code, description, created, type, parent)
VALUES
    (43, 'F', 0, '21.001.0000001', 'Cardholder 0000001', current_date, 2, 21),
    (44, 'F', 0, '21.001.0000002', 'Cardholder 0000002', current_date, 2, 21),
    (45, 'F', 0, '21.001.0000003', 'Cardholder 0000003', current_date, 2, 21),
    (46, 'F', 0, '21.002.0000001', 'Gift Card 0000001', current_date, 2, 22),
    (47, 'F', 0, '21.002.0000002', 'Gift Card 0000002', current_date, 2, 22)
ON CONFLICT (id) DO UPDATE SET (subclass, root, code, description, created, type, parent) =
                                   (EXCLUDED.subclass, EXCLUDED.root, EXCLUDED.code, EXCLUDED.description,
                                    EXCLUDED.created, EXCLUDED.type, EXCLUDED.parent);

-------------------
-- card_products --
-------------------
UPDATE card_products
SET bin = '454621', range =  '010'
WHERE id = 0;

INSERT INTO card_products (id, name, active, pos, atm, moto, ecommerce, tips, anonymous, startdate, enddate,
                           issuedaccount, feeaccount, issuer, bin, key_set_id)
VALUES
    (1, 'jCard Gold', 'Y', 'N', 'N', 'N', 'N', 'N', 'N', current_date, '2049-01-01', 4, 36, 0, null, (select id from key_set where name = 'visa-key-set')),
    (2, 'Gift Cards', 'Y', 'N', 'N', 'N', 'N', 'N', 'Y', current_date, '2049-01-01', 4, 36, 0, null, null)
ON CONFLICT (id) DO UPDATE SET (name, active, pos, atm, moto, ecommerce, tips, anonymous, startdate, enddate,
                                issuedaccount,key_set_id) =
                                   (EXCLUDED.name, EXCLUDED.active, EXCLUDED.pos, EXCLUDED.atm, EXCLUDED.moto,
                                    EXCLUDED.ecommerce, EXCLUDED.tips, EXCLUDED.anonymous, EXCLUDED.startdate,
                                    EXCLUDED.enddate, EXCLUDED.issuedaccount, EXCLUDED.key_set_id);

----------------
-- cardholder --
----------------
INSERT INTO cardholder (id, realid, active, startdate, enddate, honorific, gender, firstname, lastname, issuer, nationality,
                        national_identifier)
VALUES
    (0, '0000001', 'Y', current_date, '2049-01-01', 'Mr.', 'M', 'Joe', 'Holder', 0, 'ARG', 'rOEvnZVfsEFk9wc6'),
    (1, '0000000001', 'Y', current_date, '2049-01-01', null, null, null, 'Holder', 0, 'ARG', 'rOEvnZVfsEFk9wc6'),
    (2, '0000001459', 'N', current_date, '2049-01-01', null, null, null, 'Holder', 0, 'ARG', 'rOEvnZVfsEFk9wc6'),
    (3, '0000001561', 'Y', current_date, '2049-01-01', 'Mrs.', 'F', 'Alice', 'Gaviola', 0, 'ARG', 'rOEvnZVfsEFk9wc6'),
    (4, '1441994047036', 'Y', current_date, '2049-01-01', null, null, 'Jane Modificada!!!!!!', 'Doe', 0, 'ARG',
     'rOEvnZVfsEFk9wc6'),
    (5, '0000003', 'Y', '2005-01-01', '2049-01-01', 'Mr.', 'M', 'Wally', 'Holder', 0, 'ARG', 'rOEvnZVfsEFk9wc6')
ON CONFLICT (id) DO UPDATE SET (realid, active, startdate, enddate, honorific, gender, firstname, lastname,
                                issuer, nationality, national_identifier) =
                                   (EXCLUDED.realid, EXCLUDED.active, EXCLUDED.startdate, EXCLUDED.enddate,
                                    EXCLUDED.honorific, EXCLUDED.gender, EXCLUDED.firstname, EXCLUDED.lastname,
                                    EXCLUDED.issuer, EXCLUDED.nationality, EXCLUDED.national_identifier);

------------------------
-- cardholder_address --
------------------------
INSERT INTO cardholder_address (id, cardholderid, active, type, street, number, locality, state, country, postal_code,
                                floor, apartment)
VALUES
    (0, 0, 'Y', 'LEGAL', 'Avenida Siempreviva', '743', 'Buenos Aires', 'AR-B', 'ARG', 1424, null, null),
    (1, 1, 'Y', 'LEGAL', 'Avenida Siempreviva', '743', 'Buenos Aires', 'AR-B', 'ARG', 1424, null, null),
    (2, 2, 'Y', 'LEGAL', 'Avenida Siempreviva', '743', 'Buenos Aires', 'AR-B', 'ARG', 1424, null, null),
    (3, 3, 'Y', 'LEGAL', 'Avenida Siempreviva', '743', 'Buenos Aires', 'AR-B', 'ARG', 1424, null, null),
    (4, 4, 'Y', 'LEGAL', 'Avenida Siempreviva', '743', 'Buenos Aires', 'AR-B', 'ARG', 1424, null, null),
    (5, 5, 'Y', 'LEGAL', 'Avenida Siempreviva', '743', 'Buenos Aires', 'AR-B', 'ARG', 1424, null, null)
ON CONFLICT (id) DO UPDATE SET (cardholderid, active, type, street, number, locality, state, country, postal_code,
                                floor, apartment) =
                                   (EXCLUDED.cardholderid, EXCLUDED.active, EXCLUDED.type, EXCLUDED.street,
                                    EXCLUDED.number, EXCLUDED.locality, EXCLUDED.state, EXCLUDED.country,
                                    EXCLUDED.postal_code, EXCLUDED.floor, EXCLUDED.apartment);

--------------------------------
-- cardholder_identifications --
--------------------------------
INSERT INTO cardholder_identifications (id, cardholderid, active, type, number, country)
VALUES
       (0, 0, 'Y', 'DNI', '5632870', 'ARG'),
       (1, 1, 'Y', 'DNI', '5632871', 'ARG'),
       (2, 2, 'Y', 'DNI', '5632872', 'ARG'),
       (3, 3, 'Y', 'DNI', '5632873', 'ARG'),
       (4, 4, 'Y', 'DNI', '5632874', 'ARG'),
       (5, 5, 'Y', 'DNI', '5632875', 'ARG'),
       (6, 0, 'Y', 'CUIL', '5632870', 'ARG'),
       (7, 1, 'Y', 'CUIL', '5632871', 'ARG'),
       (8, 2, 'Y', 'CUIL', '5632872', 'ARG'),
       (9, 3, 'Y', 'CUIL', '5632873', 'ARG'),
       (10, 4, 'Y', 'CUIL', '5632874', 'ARG'),
       (11, 5, 'Y', 'CUIL', '5632875', 'ARG')
ON CONFLICT (id) DO UPDATE SET (cardholderid, active, type, number, country) =
                                   (EXCLUDED.cardholderid, EXCLUDED.active, EXCLUDED.type,
                                    EXCLUDED.number, EXCLUDED.country);



----------
-- card --
----------
INSERT INTO card (id, token, bin, lastfour, kid, securedata, hash, startdate,
                  enddate, cardholder, cardproduct, account, virtual_state, physical_state)
VALUES
    (0, '4f505f76-878c-4c13-9ad8-e2cff7473c01', '600933', '0011', 'dek.001', E'\\x980F410EF5D6FF7A6B89BF873F58CBB1381DD8E03848394DD3578B54FAABBB5D21F568037810D74398154CF5B37F20097C5C2224447C97C6DB9CAB8D30453E01C820EAF9217801DC350A6370FA5CB3C8142FCF7773F85AC28E7C562E4DE03C461E4EE5',
    'F146F9BD47ED44C378C98F7C91BFDDE23077024D', '2005-01-01', '2049-01-01', 0,
     1, null, 'CREATED', null),
    (1, '000000005', '600933', '0020', 'bdk.001', (decode(
            '5b837a191a45b391495bbc64a44c2c9bee6f8033912f977dc78b8248ad2ea6d049e829d1fb1acc6d0e372383385e15dd906cd200231ccc5b4e7c2f84d2f10f49',
            'hex')), 'C7FA39ADC31627CC0A02A5BB0EBA04B1E9C7B603', '2005-01-01', '2049-01-01', 0,
     0, null, 'CREATED', null),
    (2, '000000006', '604955', '0001', 'bdk.001', (decode(
            '131a8c5437c2e0292f0261d68a64138379be66d432943dc756ec48c2b8e85a6063f9c3ff1d944f773f12e476a03f1d2c35bb6905ccb272e4b6ded1b9b639225e',
            'hex')), '2E132C35BBC4D7270AA01F102C612DF967CB42EB', current_date, '2049-01-01', 0,
     1, null, 'CREATED', null),
    (3, null, '600933', '0025', 'bdk.001', (decode(
            '26d5dc9dc8a8c13b6e799efb5ef1f807ca9bdaf5b6d5234c815e9520e5d569d801ecbead56e6efa9fccb0fc984c6e04592ed6e3e7b4eabfcf362e0d9ef3d0bd6',
            'hex')), 'B5F4C406D7407F8789309B0E70DE18DB11C85B42', '2005-01-01', '2049-01-01',
     null, 2, null, 'CREATED', null),
    (4, null, '600933', '0033', 'bdk.001', (decode(
            '58efb697915849df45b99eb3d32a1061fc803cece98f2bd8cde2b368b463421aec7a1257e9d8983bd55e0fee48b646bde37568fcd41883eeb8f71cb350e1daf6',
            'hex')), 'A047C00606297986FA3FFF818CDBAE4B96BCB69B', current_date, '2049-01-01',
     3, 2, null, 'CREATED', null),
    (5, null, '600933', '2576', 'bdk.001', (decode(
            'a785b3ab67ec91589146bad35701088fbf15d273a14540cce8e43e2e28c860adacc93b11e744219bfa7b2a696085aeee25cadc7fc738a2e92c6d7288d4a97ae4c2147c5738f00c6f0ea3cb1e51a2c0b061bd9ca9fa5d5489',
            'hex')), '4712DC0D7BE8EDE335528CB147E8766A0E3D2EDC', '2015-09-11', '2049-12-31', 2,
     0, null, 'CREATED', null),
    (6, null, '600933', '1914', 'bdk.001', (decode(
            'e5e0080d92f7ad01d319f41998689b6b82276eec344472139cc1dd84355be91e1f3a65ffff3461a99998688e3c4d7ab62ad7f6f0762a92fb812e2b13bb30c3897c9b542b7ebe0c7d1508ca33e6ff72a8a4406d7bfc730312',
            'hex')), '46EC82E385D697A1F71F6AC55CDCDE5C3D71517B', '2015-09-11', '2049-12-31', 3,
     0, null, 'CREATED', null),
    (7, '3ce9e198-a1f3-49b3-9f0d-35e595099ea6', '488234', '2019',
     'dek.001',
     E'\\x8AD9D5CFD76745EFD6F16E188A33D720E0146882B81F78C1640625082FE31083CD918C1A191AF9C7F26C16966C89EE2300FC4B88FE89E16BC58A5857FE94F9CDB3B8DA83AFB4E641875BA2F975C4D7292C992356964C70A58DEAA13B2CDCB6822EAFE1F33A770398FF9FC47E6AD035676FC09E66918B9EAF778BDE519111A879C163A025A9F9',
     '18813DC1A1F9B2EE6646DF90FDA71E8BAE9402DA', '2021-10-15', '2025-05-31', 0,
     0, null, 'ACTIVE', 'ACTIVE'),   
    (8, '000000009', '600933', '0013', 'bdk.001',
     (decode('92F2864A194C20B34FE686293ED3A423B8FC25575E82DCB36AE694E5639503D74DBF7977979A7AF4E4ABDAA75C840931DAC4C9677631EAF6C5F3595AE9165ADA','hex')),
     'D370D23243D2332553B0F51405841F0D5B39CFE4', '2005-01-01', '2015-01-01', 5, 0, NULL, 'CREATED', null),
    (9, 'd3734497-1c20-4cfd-ae07-6b665dccca06', '600933', '4799', 'dek.001',
     E'\\x1942C5A18C0A21B7A3C63991C21FB6E82A303D7DEBA76E98EF3BF0013A3A710129D4CE26B19BFF88748093D61A205AB17CA0532B5C90D0A4D630FABE70D7D2E36811457E64DC9B5760EF06FF9899409B389027B0DD023733C1B85F5466EE1C6E52F8C3577FC566BE53F89A02B2C2CF20C7C31E779685C31B83A55C2CC929918EF62106ADE817',
     '2E218278BBEAAB048F2FB85DBB2843D70C019245', '2022-06-24', '2027-06-30', 0, 1, null, 'ACTIVE', 'STOLEN')
ON CONFLICT (id) DO UPDATE SET (token, bin, lastfour, kid, securedata, hash,
                                startdate, enddate, cardholder, cardproduct, account) =
                                   (EXCLUDED.token, EXCLUDED.bin, EXCLUDED.lastfour, EXCLUDED.kid, EXCLUDED.securedata,
                                    EXCLUDED.hash, EXCLUDED.startdate, EXCLUDED.enddate, EXCLUDED.cardholder,
                                    EXCLUDED.cardproduct, EXCLUDED.account);

-------------------
-- card_accounts --
-------------------
INSERT INTO card_accounts
    (id, account, currency)
VALUES
    (7, 43, '032'),
    (4, 44, '032'),
    (9, 45, '032')
ON CONFLICT (id, currency) DO UPDATE SET account = EXCLUDED.account;

-------------------------
-- cardholder_accounts --
-------------------------
INSERT INTO cardholder_accounts
    (id, account, currency)
VALUES
    (0, 43, '032'),
    (3, 44, '032'),
    (4, 45, '032')
ON CONFLICT (id, currency) DO UPDATE SET account = EXCLUDED.account;

--------------
-- ruleinfo --
--------------
INSERT INTO ruleinfo (id, description, clazz, layers, param, journal, account)
VALUES
    (2, 'Check that the account has always a balance greater than 960.00', 'org.jpos.gl.rule.FinalMinBalance',
     '032,1032', '960.00', 0, 44),
    (3, 'Verifies that credits equals debits', 'org.jpos.gl.rule.DoubleEntry', '032,1032,600,3600,4600,1600,5600', null,
     0, null)
ON CONFLICT (id) DO UPDATE SET (description, clazz, layers, param, journal, account) =
                                   (EXCLUDED.description, EXCLUDED.clazz, EXCLUDED.layers, EXCLUDED.param,
                                    EXCLUDED.journal, EXCLUDED.account);


-----------------------
-- velocity_profiles --
-----------------------
INSERT INTO velocity_profiles (id, name, active, approvalsonly, scopecard, scopeaccount, validonpurchase,
                               validonwithdrawal, validontransfer, currencycode, numberofdays, usagelimit,
                               amountlimit, cardproduct, posn, validoncredit, scopemonthly, scopedaily)
VALUES
    (0,'LimiteComprasMensuales','Y','N','Y','Y','Y','Y','N','032',0,100000,200000,0,0,'N','Y','N'),
    (1,'LimiteRetirosDiarios','Y','N','Y','Y','N','Y','N','032',0,3,15000,0,1,'N','N','Y')
ON CONFLICT (id) DO UPDATE SET (name, active, approvalsonly, scopecard, scopeaccount, validonpurchase,
                                validonwithdrawal, validontransfer, currencycode, numberofdays, usagelimit,
                                amountlimit, cardproduct, posn, validoncredit, scopemonthly,
                                scopedaily) =
                                   (EXCLUDED.name, EXCLUDED.active, EXCLUDED.approvalsonly, EXCLUDED.scopecard,
                                    EXCLUDED.scopeaccount, EXCLUDED.validonpurchase, EXCLUDED.validonwithdrawal,
                                    EXCLUDED.validontransfer, EXCLUDED.currencycode, EXCLUDED.numberofdays,
                                    EXCLUDED.usagelimit, EXCLUDED.amountlimit, EXCLUDED.cardproduct, EXCLUDED.posn,
                                    EXCLUDED.validoncredit, EXCLUDED.scopemonthly, EXCLUDED.scopedaily);

--------------
-- transacc --
--------------
INSERT INTO transacc (id, detail, tags, timestamp, postdate, journal)
VALUES
    (1670, 'Initial deposit cardholder 0000001', null, current_date, current_date, 0)
ON CONFLICT (id) DO UPDATE SET (detail, tags, timestamp, postdate, journal) =
                                   (EXCLUDED.detail, EXCLUDED.tags, EXCLUDED.timestamp, EXCLUDED.postdate,
                                    EXCLUDED.journal);

----------------
-- transentry --
----------------
INSERT INTO transentry (id, subclass, detail, tags, credit, layer, account, transaction, amount, posn)
VALUES
    (1, 'C', null, null, 'Y', 32, 43, 1670, 1000.00, 0),
    (2, 'D', 'EntryDetail', 'tag2', 'N', 32, 4, 1670, 1000.00, 1)
ON CONFLICT (id) DO UPDATE SET (subclass, detail, tags, credit, layer, account, transaction, amount, posn) =
                                   (EXCLUDED.subclass, EXCLUDED.detail, EXCLUDED.tags, EXCLUDED.credit, EXCLUDED.layer,
                                    EXCLUDED.account, EXCLUDED.transaction, EXCLUDED.amount, EXCLUDED.posn);

insert into usage_limit_account (id, usageLimit, finalAccount)
values
    (43,1,43),
    (44,1,44),
    (45,1,45)
  ON CONFLICT (id) DO NOTHING;