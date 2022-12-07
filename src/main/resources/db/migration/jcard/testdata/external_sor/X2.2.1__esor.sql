---------------------
-- Test data: ESOR --
---------------------

----------------
-- cardholder --
----------------
INSERT INTO cardholder (id, realid, active, startdate, enddate, honorific, gender, firstname, lastname, issuer)
VALUES
    (6, '00', 'Y', current_date, '2049-01-01', 'Mr.', 'M', 'Joe esor', 'Holder', 0)
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
    (0, 6, 'Y', 'LEGAL', 'Avenida Siempreviva', '743', 'Buenos Aires', 'AR-B', 'ARG', 1424, null, null)
ON CONFLICT (id) DO UPDATE SET (cardholderid, active, type, street, number, locality, state, country, postal_code,
                                floor, apartment) =
                                   (EXCLUDED.cardholderid, EXCLUDED.active, EXCLUDED.type, EXCLUDED.street,
                                    EXCLUDED.number, EXCLUDED.locality, EXCLUDED.state, EXCLUDED.country,
                                    EXCLUDED.postal_code, EXCLUDED.floor, EXCLUDED.apartment);
--------------------------------
-- cardholder_identifications --
--------------------------------
INSERT INTO cardholder_identifications (id, cardholderid, active, type, number, country)
VALUES (0, 6, 'Y', 'DNI', '5632874', 'ARG'),
       (1, 6, 'Y', 'CUIL', '5632874', 'ARG')
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
            'F146F9BD47ED44C378C98F7C91BFDDE23077024D', '2005-01-01', '2049-01-01', 6,
     0, null, 'ACTIVE', 'ACTIVE'),
    (9, '389308e3-183d-4ea7-b194-bf48a6d4404f', '600933', '3419', 'bdk.001', (decode(
            'dace1adc5d54ef513d6eb5fe3807d9bf39fa38180af0faf15c8e64a59d2709be6794836a046b925a2397f068c1cae770784a66f91d6209904a3412048218cc40',
            'hex')), '3B39AC07735BBBB46A82D8201D86A342920D26D9', '2021-10-15', '2025-05-31', 6,
     0, null, 'CREATED', null),
    (7, '3ce9e198-a1f3-49b3-9f0d-35e595099ea6', '488234', '2019',
        'dek.001',
         E'\\x8AD9D5CFD76745EFD6F16E188A33D720E0146882B81F78C1640625082FE31083CD918C1A191AF9C7F26C16966C89EE2300FC4B88FE89E16BC58A5857FE94F9CDB3B8DA83AFB4E641875BA2F975C4D7292C992356964C70A58DEAA13B2CDCB6822EAFE1F33A770398FF9FC47E6AD035676FC09E66918B9EAF778BDE519111A879C163A025A9F9',
        '18813DC1A1F9B2EE6646DF90FDA71E8BAE9402DA', '2021-10-15', '2025-05-31', 6,
     0, null, 'ACTIVE', 'ACTIVE'),
    (8, '000000009', '600933', '0013', 'bdk.001',
     E'\\x92F2864A194C20B34FE686293ED3A423B8FC25575E82DCB36AE694E5639503D74DBF7977979A7AF4E4ABDAA75C840931DAC4C9677631EAF6C5F3595AE9165ADA',
     'D370D23243D2332553B0F51405841F0D5B39CFE4', '2005-01-01', '2015-01-01', 6, 0, NULL, 'CREATED', null),
    (12, 'd3734497-1c20-4cfd-ae07-6b665dccca06', '600933', '4799', 'dek.001',
     E'\\x1942C5A18C0A21B7A3C63991C21FB6E82A303D7DEBA76E98EF3BF0013A3A710129D4CE26B19BFF88748093D61A205AB17CA0532B5C90D0A4D630FABE70D7D2E36811457E64DC9B5760EF06FF9899409B389027B0DD023733C1B85F5466EE1C6E52F8C3577FC566BE53F89A02B2C2CF20C7C31E779685C31B83A55C2CC929918EF62106ADE817',
     '2E218278BBEAAB048F2FB85DBB2843D70C019245', '2022-06-24', '2027-06-30', 6, 0, null, 'ACTIVE', 'STOLEN'),
    (10,'76fd004d-d6ff-4f11-b019-ad128bbd5692','454621','1170','bdk.001',decode(
            'DF7554ADFDA402F75B839DCD7F61020B2AF64ECE85FA03F5D9D4541D37017A1E8CD1638F832F8835496A4A8F0C646825946B0CD19A60081FD6E262957FA3A17577FFAB05F7A0A7F84895001A54F69E95D060855CB38998A70D3320244112075FF98E0C054675E72670F756E4AE64AB62A17EC070B46B2D05','hex'),
     'D2EA35A49562660F71DFB93B85D8D910D0C5FEC5','2022-01-22','2022-02-01',6,0,NULL, 'CREATED', null),
    (11,'11322259-4660-4489-a416-f1710a842696','454621','2996','bdk.001',decode(
            '3EB91FF2E07C3BC79D32CD57A8EA3B10506B4E4E174F79B0B0DE41FCD3281D219CBD157CA41D44A88D72292C6E2AB8270E344D1EE2405B3DCF4A73441177A49E045B287BDDB5DCC8081B324B9DE414C64F8A0EC1749EF7F9669D4151DF0EADBF96D10960AC03108208B59E15107C105E062967C40BE58779','hex'),
     '9D00FBB59A006A9402C3E5FB719EC9E8FE82509C','2022-05-03','2027-05-31',6,0,NULL, 'CREATED', null)
ON CONFLICT (id) DO UPDATE SET (token, bin, lastfour, kid, securedata, hash,
                                startdate, enddate, cardholder, cardproduct, account) =
                                   (EXCLUDED.token, EXCLUDED.bin, EXCLUDED.lastfour, EXCLUDED.kid, EXCLUDED.securedata,
                                    EXCLUDED.hash, EXCLUDED.startdate, EXCLUDED.enddate, EXCLUDED.cardholder,
                                    EXCLUDED.cardproduct, EXCLUDED.account);

-------------------
-- card_accounts --
-------------------
INSERT INTO card_accounts (id, account, currency)
VALUES
    (9, 4, '032'),
    (7, 4, '032'),
    (10, 4, '032'),
    (11, 4, '032'),
     (12, 4, '032')
ON CONFLICT (id, currency) DO UPDATE SET account = EXCLUDED.account;

-------------------------
-- cardholder_accounts --
-------------------------
INSERT INTO cardholder_accounts (id, account, currency)
VALUES
    (6, 4, '032')
ON CONFLICT (id, currency) DO UPDATE SET account = EXCLUDED.account;

-------------------
-- card_products --
-------------------
UPDATE card_products
SET bin = '454621', range =  '005'
WHERE id = 0;

--------------------------
-- usage_limits_account --
--------------------------
insert into usage_limit_account (id, usageLimit, finalAccount)
values (4,1,4)
ON CONFLICT (id) DO NOTHING;