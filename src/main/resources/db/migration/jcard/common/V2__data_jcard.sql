--------------
-- currency --
--------------
INSERT INTO currency(id, name, symbol)
VALUES
    ('840', 'US Dollars', 'USD'),
    ('032', 'Pesos argentinos', '$')
ON CONFLICT (id) DO UPDATE SET (name, symbol) = (EXCLUDED.name, EXCLUDED.symbol);

----------
-- acct --
----------
INSERT INTO acct (id, subclass, root, code, description, created, type, parent)
VALUES
    (0, 'C', 0, 'jcard', 'jCard ${sorType}', current_date, 0, null)
ON CONFLICT (id) DO UPDATE SET (subclass, root, code, description, created, type, parent) =
                                   (EXCLUDED.subclass, EXCLUDED.root, EXCLUDED.code, EXCLUDED.description,
                                    EXCLUDED.created, EXCLUDED.type, EXCLUDED.parent);

-------------
-- journal --
-------------
INSERT INTO journal (id, name, start, end_, closed, chart)
VALUES
    (0, 'jcard', '2001-01-01', '2100-12-31', 'f', 0)
ON CONFLICT (id) DO UPDATE SET (name, start, end_, closed, chart) =
                                   (EXCLUDED.name, EXCLUDED.start, EXCLUDED.end_, EXCLUDED.closed, EXCLUDED.chart);

-----------
-- layer --
-----------
INSERT INTO layer (id, journal, name)
VALUES
    (840, 0, 'Dollars'),
    (1840, 0, 'Pending Dollars'),
    (32, 0, 'Pesos Argentinos'),
    (1032, 0, 'Pending Pesos Argentinos')
ON CONFLICT (id, journal) DO UPDATE SET name = EXCLUDED.name;


------------------
-- card_product --
------------------
INSERT INTO card_products (id, name, active, pos, atm, moto, ecommerce, tips, anonymous, startdate, enddate,
                           issuedaccount)
VALUES
    (0, 'jCard', 'Y', 'N', 'N', 'N', 'N', 'N', 'N', current_date, '2049-01-01', 0) -- issuedAccount should be changed
ON CONFLICT (id) DO UPDATE SET (name, active, pos, atm, moto, ecommerce, tips, anonymous, startdate, enddate,
                                issuedaccount) =
                                   (EXCLUDED.name, EXCLUDED.active, EXCLUDED.pos, EXCLUDED.atm, EXCLUDED.moto,
                                    EXCLUDED.ecommerce, EXCLUDED.tips, EXCLUDED.anonymous, EXCLUDED.startdate,
                                    EXCLUDED.enddate, EXCLUDED.issuedaccount);

--------------
-- ruleinfo --
--------------
INSERT INTO ruleinfo (id, description, clazz, layers, param, journal, account)
VALUES
    (0, 'Verifies permissions, start/end dates, status, and chart', 'org.jpos.gl.rule.CanPost', null, null, 0, null),
    (1, 'Verifies that credits equals debits', 'org.jpos.gl.rule.DoubleEntry', '840,1840,32,1032', null, 0, null)
ON CONFLICT (id) DO UPDATE SET (description, clazz, layers, param, journal, account) =
                                   (EXCLUDED.description, EXCLUDED.clazz, EXCLUDED.layers, EXCLUDED.param,
                                    EXCLUDED.journal, EXCLUDED.account);

------------
-- gluser --
------------
INSERT INTO gluser (id, nick, name)
VALUES
    (4, 'admin', 'System Administrator')
ON CONFLICT (id) DO UPDATE SET (nick, name) = (EXCLUDED.nick, EXCLUDED.name);

------------
-- glperm --
------------
INSERT INTO glperm (id, name, gluser, journal)
VALUES
    (0, 'read', 4, null),
    (1, 'write', 4, null),
    (2, 'grant', 4, null),
    (3, 'summarize', 4, 0),
    (4, 'read', 4, 0),
    (5, 'checkpoint', 4, 0),
    (6, 'post', 4, 0)
ON CONFLICT (id) DO UPDATE SET (name, gluser, journal) = (EXCLUDED.name, EXCLUDED.gluser, EXCLUDED.journal);

---------------
-- sysconfig --
---------------
INSERT INTO sysconfig (id, value, readperm, writeperm)
VALUES
    ('ATC_EXCESS_LIMIT', '200', 'sysconfig.read', 'sysadmin')
ON CONFLICT (id) DO UPDATE SET (value, readperm, writeperm) = (EXCLUDED.value, EXCLUDED.readperm, EXCLUDED.writeperm);


INSERT INTO rc(
    id, mnemonic, description)
VALUES (8888, 'card.blocked', 'Card state is BLOCKED');
INSERT INTO rc_locale(
    id, resultcode, resultinfo, extendedresultcode, locale)
VALUES (8888, 8888, 'Card state is BLOCKED', null, 'JCARD');

INSERT INTO rc(
    id, mnemonic, description)
VALUES (8889, 'card.created', 'Card state is CREATED');
INSERT INTO rc_locale(
    id, resultcode, resultinfo, extendedresultcode, locale)
VALUES (8889, 8889, 'Card state is CREATED', null, 'JCARD');

INSERT INTO rc(
    id, mnemonic, description)
VALUES (8890, 'card.embossed', 'Card state is EMBOSSED');
INSERT INTO rc_locale(
    id, resultcode, resultinfo, extendedresultcode, locale)
VALUES (8890, 8890, 'Card state is EMBOSSED', null, 'JCARD');

INSERT INTO rc(
    id, mnemonic, description)
VALUES (8891, 'card.reembossed', 'Card state is RE-EMBOSSED');
INSERT INTO rc_locale(
    id, resultcode, resultinfo, extendedresultcode, locale)
VALUES (8891, 8891, 'Card state is RE-EMBOSSED', null, 'JCARD');

INSERT INTO rc(
    id, mnemonic, description)
VALUES (8892, 'invalid.card.state', 'Invalid card state');
INSERT INTO rc_locale(
    id, resultcode, resultinfo, extendedresultcode, locale)
VALUES (8892, 8892, 'Invalid card state', null, 'JCARD');

INSERT INTO rc(
    id, mnemonic, description)
VALUES (8893, 'invalid.transaction.classification', 'Invalid transaction classification');
INSERT INTO rc_locale(
    id, resultcode, resultinfo, extendedresultcode, locale)
VALUES (8893, 8893, 'Invalid transaction classification', null, 'JCARD');

INSERT INTO rc(
    id, mnemonic, description)
VALUES (8894, 'invalid.state.transition', 'Invalid state transition');
INSERT INTO rc_locale(
    id, resultcode, resultinfo, extendedresultcode, locale)
VALUES (8894, 8894, 'Invalid state transition', null, 'JCARD');

INSERT INTO rc(id, mnemonic, description) VALUES (9108, 'min.or.max.amount.load.exceed', 'Maximum or minimum amount of load exceeded');
INSERT INTO rc_locale(id,resultcode,resultinfo,extendedresultcode,locale) VALUES (9108,9108, 'Maximum or minimum amount of load exceeded',null,'JCARD');

INSERT INTO rc(
    id, mnemonic, description)
VALUES (9110, 'not.supported.f117', 'Transaction not supported');
INSERT INTO rc_locale(
    id, resultcode, resultinfo, extendedresultcode, locale)
VALUES (9110, 9110, 'Transaction not supported', null, 'JCARD');

INSERT INTO rc(id, mnemonic, description) VALUES (9111, 'bai.not.supported', 'BAI is not supported by issuer');
INSERT INTO rc_locale(id,resultcode,resultinfo,extendedresultcode,locale) VALUES (9111,9111, 'BAI is not supported by issuer',null,'JCARD');

INSERT INTO rc(id, mnemonic, description) VALUES (9112, 'min.purchase.amount.invalid.cashback', 'Cashback not supported due to min purchase amount');
INSERT INTO rc_locale(id,resultcode,resultinfo,extendedresultcode,locale) VALUES (9112,9112, 'Cashback not supported due to min purchase amount',null,'JCARD');

INSERT INTO rc(id, mnemonic, description) VALUES (1891, 'host.unreachable', 'Host Unreachable');
INSERT INTO rc_locale(id, resultcode, resultinfo, extendedresultcode, locale) VALUES (1891, 1891, 'Host Unreachable', null, 'JCARD');

INSERT INTO rc(id, mnemonic, description) VALUES (9114, 'risk.level.exceeded', 'Risk Level exceeded');
INSERT INTO rc_locale(id, resultcode, resultinfo, extendedresultcode, locale) VALUES (9114, 9114, 'Risk Level exceeded', null, 'JCARD');

INSERT INTO rc(id, mnemonic, description)
VALUES (9444, 'invalid.card.sequence.number', 'Card sequence number cant be null');
INSERT INTO rc_locale(id,resultcode,resultinfo,extendedresultcode,locale)
VALUES (9444,9444, 'Card sequence number cant be null',null,'JCARD');

UPDATE sysconfig
SET value = '41.001'
WHERE id = 'GL_ISSUERS_LOSSES_ACCT'
  AND value = '41';


INSERT INTO sysconfig (id, value, readperm, writeperm)
VALUES ('GL_TRANSFERRED_MONEY_ACCT', '29.001', 'login', 'sysadmin')
    ON CONFLICT DO NOTHING;


INSERT INTO rc(id, mnemonic, description) VALUES (1892, 'not.allowed.card.usagelimit', 'Transaction not allowed due to Card usage limit settings');
INSERT INTO rc_locale(id, resultcode, resultinfo, extendedresultcode, locale) VALUES (1892, 1892, 'Transaction not allowed due to Card usage limit settings', null, 'JCARD');
INSERT INTO rc(id, mnemonic, description) VALUES (1893, 'not.allowed.cardproduct.usagelimit ', 'Transaction not allowed due to Card Product usage limit settings');
INSERT INTO rc_locale(id, resultcode, resultinfo, extendedresultcode, locale) VALUES (1893, 1893, 'Transaction not allowed due to Card Product usage limit settings', null, 'JCARD');
INSERT INTO rc(id, mnemonic, description) VALUES (1894, 'not.allowed.account.usagelimit', 'Transaction not allowed due to Account usage limit settings');
INSERT INTO rc_locale(id, resultcode, resultinfo, extendedresultcode, locale) VALUES (1894, 1894, 'Transaction not allowed due to Account usage limit settings', null, 'JCARD');

---- Usage Limit ----
insert into usage_limit (id, name, createdtimestamp,
                         allowecommerce, allowpurchasechip, allowpurchasecontactless, allowatmoperation,
                         allowatmwithdrawal, allowoct,allowpurchasemagneticstripe)
values (1,'Allow all types',current_date,true,true,true,true,true,true,true)
    ON CONFLICT (id)  DO NOTHING;
insert into usage_limit (id, name, createdtimestamp,
                         allowecommerce, allowpurchasechip, allowpurchasecontactless, allowatmoperation,
                         allowatmwithdrawal, allowoct,allowpurchasemagneticstripe)
values (2,'Not allow all types',current_date,false,false,false,false,false,false,false)
    ON CONFLICT (id)  DO NOTHING;
insert into usage_limit (id, name, createdtimestamp)
values (3,'All null',current_date)
    ON CONFLICT (id)  DO NOTHING;
update card_products set usage_limit_id = 1;
update card set usage_limit_id = 1;


INSERT INTO rc(id, mnemonic, description) VALUES (1022, 'previously.presented', 'Previously presented');
INSERT INTO rc_locale(id, resultcode, resultinfo, extendedresultcode, locale) VALUES (1022, 1022, 'Previously presented', null, 'JCARD');


INSERT INTO rc(id, mnemonic, description) VALUES (9120, 'not.allowed.mcc.usagelimit', 'MCC not supported');
INSERT INTO rc_locale(id,resultcode,resultinfo,extendedresultcode,locale) VALUES (9120,9120, 'Transaction not allowed due to MCC usage limit settings',null,'JCARD');


INSERT INTO usage_limit (id, name, createdtimestamp,
                         allowecommerce, allowpurchasechip,
                         allowpurchasecontactless, allowatmoperation,
                         allowatmwithdrawal, allowoct,allowpurchasemagneticstripe,
                         countrieswhitelist,countriesblacklist)
VALUES (4,'Allow all types with both country list configured',current_date,
        true,true,true,true,true,true,true,'US,AR','AD,AF');

INSERT INTO usage_limit (id, name, createdtimestamp,
                         allowecommerce, allowpurchasechip,
                         allowpurchasecontactless, allowatmoperation,
                         allowatmwithdrawal, allowoct,allowpurchasemagneticstripe,
                         countrieswhitelist)
VALUES (5,'Allow all types with white list country',current_date,
        true,true,true,true,true,true,true,'US,AR');

INSERT INTO usage_limit (id, name, createdtimestamp,
                         allowecommerce, allowpurchasechip,
                         allowpurchasecontactless, allowatmoperation,
                         allowatmwithdrawal, allowoct,allowpurchasemagneticstripe,
                         countriesblacklist)
VALUES (6,'Allow all types with black list country',current_date,
        true,true,true,true,true,true,true,'AD,AF');


INSERT INTO rc(id, mnemonic, description) VALUES (9113,'country.not.present.in.white.list', 'Country not allowed because it is not present in white list');
INSERT INTO rc_locale(id,resultcode,resultinfo,extendedresultcode,locale) VALUES (9113,9113,'Country not allowed because it is not present in white list',null,'JCARD');

INSERT INTO rc(id, mnemonic, description) VALUES (9115,'country.is.present.in.black.list', 'Country not allowed because it is present in black list');
INSERT INTO rc_locale(id,resultcode,resultinfo,extendedresultcode,locale) VALUES (9115,9115,'Country not allowed because it is present in black list',null,'JCARD');


INSERT INTO rc(id, mnemonic, description) VALUES (1895, 'not.allowed.tcc.usagelimit', 'Transaction not allowed due to TCC usage limit settings');
INSERT INTO rc_locale(id, resultcode, resultinfo, extendedresultcode, locale) VALUES (1895, 1895, 'Transaction not allowed due to TCC usage limit settings', null, 'JCARD');


INSERT INTO tcc (code, description) VALUES
                                        ('A','Vehicle Rentals'),
                                        ('C','Cash Disbursements'),
                                        ('F','Restaurants'),
                                        ('H','Hotels and Motels'),
                                        ('O','Hospitals, Education and School Expenses'),
                                        ('P','Payment Service Providers'),
                                        ('R','All Other Merchants, Cardholder Activated Payment Terminals, U.S. Post Exchange'),
                                        ('T','Pre-Authorised Mail Orders, Pre-Authorised Telephone Orders'),
                                        ('U','Cardholder Activated Terminals, Unique Transaction Semi-Cash Disbursements'),
                                        ('X','Airlines, Railroads, Transportation, Travel Agencies'),
                                        ('Z','Cash Disbursements');

INSERT INTO mcc (code, tcc, description) VALUES
                                             ('742',null,'Veterinary Services'),
                                             ('763',null,'Agricultural Co-operatives'),
                                             ('780',null,'Horticultural Services, Landscaping Services'),
                                             ('1520',null,'General Contractors-Residential and Commercial'),
                                             ('1711',null,'Air Conditioning Contractors, Sales and Installation, Heating Contractors, Sales, Service, Installation'),
                                             ('1731',null,'Electrical Contractors'),
                                             ('1740',null,'Insulation, Contractors, Masonry, Stonework Contractors, Plastering Contractors, Stonework and Masonry Contractors, Tile Settings Contractors'),
                                             ('1750',null,'Carpentry Contractors'),
                                             ('1761',null,'Roofing, Contractors, Sheet Metal Work, Contractors, Siding, Contractors'),
                                             ('1771',null,'Contractors, Concrete Work'),
                                             ('1799',null,'Contractors, Special Trade, Not Elsewhere Classified'),
                                             ('2741',null,'Miscellaneous Publishing and Printing'),
                                             ('2791',null,'Typesetting, Plate Making, & Related Services'),
                                             ('2842',null,'Specialty Cleaning, Polishing, and Sanitation Preparations'),
                                             ('3000',null,'UNITED AIRLINES'),
                                             ('3001',null,'AMERICAN AIRLINES'),
                                             ('3002',null,'PAN AMERICAN'),
                                             ('3003',null,'Airlines'),
                                             ('3004',null,'TRANS WORLD AIRLINES'),
                                             ('3005',null,'BRITISH AIRWAYS'),
                                             ('3006',null,'JAPAN AIRLINES'),
                                             ('3007',null,'AIR FRANCE'),
                                             ('3008',null,'LUFTHANSA'),
                                             ('3009',null,'AIR CANADA'),
                                             ('3010',null,'KLM (ROYAL DUTCH AIRLINES)'),
                                             ('3011',null,'AEORFLOT'),
                                             ('3012',null,'QUANTAS'),
                                             ('3013',null,'ALITALIA'),
                                             ('3014',null,'SAUDIA ARABIAN AIRLINES'),
                                             ('3015',null,'SWISSAIR'),
                                             ('3016',null,'SAS'),
                                             ('3017',null,'SOUTH AFRICAN AIRWAYS'),
                                             ('3018',null,'VARIG (BRAZIL)'),
                                             ('3019',null,'Airlines'),
                                             ('3020',null,'AIR-INDIA'),
                                             ('3021',null,'AIR ALGERIE'),
                                             ('3022',null,'PHILIPPINE AIRLINES'),
                                             ('3023',null,'MEXICANA'),
                                             ('3024',null,'PAKISTAN INTERNATIONAL'),
                                             ('3025',null,'AIR NEW ZEALAND'),
                                             ('3026',null,'Airlines'),
                                             ('3027',null,'UTA/INTERAIR'),
                                             ('3028',null,'AIR MALTA'),
                                             ('3029',null,'SABENA'),
                                             ('3030',null,'AEROLINEAS ARGENTINAS'),
                                             ('3031',null,'OLYMPIC AIRWAYS'),
                                             ('3032',null,'EL AL'),
                                             ('3033',null,'ANSETT AIRLINES'),
                                             ('3034',null,'AUSTRAINLIAN AIRLINES'),
                                             ('3035',null,'TAP (PORTUGAL)'),
                                             ('3036',null,'VASP (BRAZIL)'),
                                             ('3037',null,'EGYPTAIR'),
                                             ('3038',null,'KUWAIT AIRLINES'),
                                             ('3039',null,'AVIANCA'),
                                             ('3040',null,'GULF AIR (BAHRAIN)'),
                                             ('3041',null,'BALKAN-BULGARIAN AIRLINES'),
                                             ('3042',null,'FINNAIR'),
                                             ('3043',null,'AER LINGUS'),
                                             ('3044',null,'AIR LANKA'),
                                             ('3045',null,'NIGERIA AIRWAYS'),
                                             ('3046',null,'CRUZEIRO DO SUL (BRAZIJ)'),
                                             ('3047',null,'THY (TURKEY)'),
                                             ('3048',null,'ROYAL AIR MAROC'),
                                             ('3049',null,'TUNIS AIR'),
                                             ('3050',null,'ICELANDAIR'),
                                             ('3051',null,'AUSTRIAN AIRLINES'),
                                             ('3052',null,'LANCHILE'),
                                             ('3053',null,'AVIACO (SPAIN)'),
                                             ('3054',null,'LADECO (CHILE)'),
                                             ('3055',null,'LAB (BOLIVIA)'),
                                             ('3056',null,'QUEBECAIRE'),
                                             ('3057',null,'EASTWEST AIRLINES (AUSTRALIA)'),
                                             ('3058',null,'DELTA'),
                                             ('3059',null,'Airlines'),
                                             ('3060',null,'NORTHWEST'),
                                             ('3061',null,'CONTINENTAL'),
                                             ('3062',null,'WESTERN'),
                                             ('3063',null,'US AIR'),
                                             ('3064',null,'Airlines'),
                                             ('3065',null,'AIRINTER'),
                                             ('3066',null,'SOUTHWEST'),
                                             ('3067',null,'Airlines'),
                                             ('3068',null,'Airlines'),
                                             ('3069',null,'SUN COUNTRY AIRLINES'),
                                             ('3070',null,'Airlines'),
                                             ('3071',null,'AIR BRITISH COLUBIA'),
                                             ('3072',null,'Airlines'),
                                             ('3073',null,'Airlines'),
                                             ('3074',null,'Airlines'),
                                             ('3075',null,'SINGAPORE AIRLINES'),
                                             ('3076',null,'AEROMEXICO'),
                                             ('3077',null,'THAI AIRWAYS'),
                                             ('3078',null,'CHINA AIRLINES'),
                                             ('3079',null,'Airlines'),
                                             ('3080',null,'Airlines'),
                                             ('3081',null,'NORDAIR'),
                                             ('3082',null,'KOREAN AIRLINES'),
                                             ('3083',null,'AIR AFRIGUE'),
                                             ('3084',null,'EVA AIRLINES'),
                                             ('3085',null,'MIDWEST EXPRESS AIRLINES, INC.'),
                                             ('3086',null,'Airlines'),
                                             ('3087',null,'METRO AIRLINES'),
                                             ('3088',null,'CROATIA AIRLINES'),
                                             ('3089',null,'TRANSAERO'),
                                             ('3090',null,'Airlines'),
                                             ('3091',null,'Airlines'),
                                             ('3092',null,'Airlines'),
                                             ('3093',null,'Airlines'),
                                             ('3094',null,'ZAMBIA AIRWAYS'),
                                             ('3095',null,'Airlines'),
                                             ('3096',null,'AIR ZIMBABWE'),
                                             ('3097',null,'Airlines'),
                                             ('3098',null,'Airlines'),
                                             ('3099',null,'CATHAY PACIFIC'),
                                             ('3100',null,'MALAYSIAN AIRLINE SYSTEM'),
                                             ('3101',null,'Airlines'),
                                             ('3102',null,'IBERIA'),
                                             ('3103',null,'GARUDA (INDONESIA)'),
                                             ('3104',null,'Airlines'),
                                             ('3105',null,'Airlines'),
                                             ('3106',null,'BRAATHENS S.A.F.E. (NORWAY)'),
                                             ('3107',null,'Airlines'),
                                             ('3108',null,'Airlines'),
                                             ('3109',null,'Airlines'),
                                             ('3110',null,'WINGS AIRWAYS'),
                                             ('3111',null,'BRITISH MIDLAND'),
                                             ('3112',null,'WINDWARD ISLAND'),
                                             ('3113',null,'Airlines'),
                                             ('3114',null,'Airlines'),
                                             ('3115',null,'Airlines'),
                                             ('3116',null,'Airlines'),
                                             ('3117',null,'VIASA'),
                                             ('3118',null,'VALLEY AIRLINES'),
                                             ('3119',null,'Airlines'),
                                             ('3120',null,'Airlines'),
                                             ('3121',null,'Airlines'),
                                             ('3122',null,'Airlines'),
                                             ('3123',null,'Airlines'),
                                             ('3124',null,'Airlines'),
                                             ('3125',null,'TAN'),
                                             ('3126',null,'TALAIR'),
                                             ('3127',null,'TACA INTERNATIONAL'),
                                             ('3128',null,'Airlines'),
                                             ('3129',null,'SURINAM AIRWAYS'),
                                             ('3130',null,'SUN WORLD INTERNATIONAL'),
                                             ('3131',null,'Airlines'),
                                             ('3132',null,'Airlines'),
                                             ('3133',null,'SUNBELT AIRLINES'),
                                             ('3134',null,'Airlines'),
                                             ('3135',null,'SUDAN AIRWAYS'),
                                             ('3136',null,'Airlines'),
                                             ('3137',null,'SINGLETON'),
                                             ('3138',null,'SIMMONS AIRLINES'),
                                             ('3139',null,'Airlines'),
                                             ('3140',null,'Airlines'),
                                             ('3141',null,'Airlines'),
                                             ('3142',null,'Airlines'),
                                             ('3143',null,'SCENIC AIRLINES'),
                                             ('3144',null,'VIRGIN ATLANTIC'),
                                             ('3145',null,'SAN JUAN AIRLINES'),
                                             ('3146',null,'LUXAIR'),
                                             ('3147',null,'Airlines'),
                                             ('3148',null,'Airlines'),
                                             ('3149',null,'Airlines'),
                                             ('3150',null,'Airlines'),
                                             ('3151',null,'AIR ZAIRE'),
                                             ('3152',null,'Airlines'),
                                             ('3153',null,'Airlines'),
                                             ('3154',null,'PRINCEVILLE'),
                                             ('3155',null,'Airlines'),
                                             ('3156',null,'Airlines'),
                                             ('3157',null,'Airlines'),
                                             ('3158',null,'Airlines'),
                                             ('3159',null,'PBA'),
                                             ('3160',null,'Airlines'),
                                             ('3161',null,'ALL NIPPON AIRWAYS'),
                                             ('3162',null,'Airlines'),
                                             ('3163',null,'Airlines'),
                                             ('3164',null,'NORONTAIR'),
                                             ('3165',null,'NEW YORK HELICOPTER'),
                                             ('3166',null,'Airlines'),
                                             ('3167',null,'Airlines'),
                                             ('3168',null,'Airlines'),
                                             ('3169',null,'Airlines'),
                                             ('3170',null,'NOUNT COOK'),
                                             ('3171',null,'CANADIAN AIRLINES INTERNATIONAL'),
                                             ('3172',null,'NATIONAIR'),
                                             ('3173',null,'Airlines'),
                                             ('3174',null,'Airlines'),
                                             ('3175',null,'Airlines'),
                                             ('3176',null,'METROFLIGHT AIRLINES'),
                                             ('3177',null,'Airlines'),
                                             ('3178',null,'MESA AIR'),
                                             ('3179',null,'Airlines'),
                                             ('3180',null,'Airlines'),
                                             ('3181',null,'MALEV'),
                                             ('3182',null,'LOT (POLAND)'),
                                             ('3183',null,'Airlines'),
                                             ('3184',null,'LIAT'),
                                             ('3185',null,'LAV (VENEZUELA)'),
                                             ('3186',null,'LAP (PARAGUAY)'),
                                             ('3187',null,'LACSA (COSTA RICA)'),
                                             ('3188',null,'Airlines'),
                                             ('3189',null,'Airlines'),
                                             ('3190',null,'JUGOSLAV AIR'),
                                             ('3191',null,'ISLAND AIRLINES'),
                                             ('3192',null,'IRAN AIR'),
                                             ('3193',null,'INDIAN AIRLINES'),
                                             ('3194',null,'Airlines'),
                                             ('3195',null,'Airlines'),
                                             ('3196',null,'HAWAIIAN AIR'),
                                             ('3197',null,'HAVASU AIRLINES'),
                                             ('3198',null,'Airlines'),
                                             ('3199',null,'Airlines'),
                                             ('3200',null,'FUYANA AIRWAYS'),
                                             ('3201',null,'Airlines'),
                                             ('3202',null,'Airlines'),
                                             ('3203',null,'GOLDEN PACIFIC AIR'),
                                             ('3204',null,'FREEDOM AIR'),
                                             ('3205',null,'Airlines'),
                                             ('3206',null,'Airlines'),
                                             ('3207',null,'Airlines'),
                                             ('3208',null,'Airlines'),
                                             ('3209',null,'Airlines'),
                                             ('3210',null,'Airlines'),
                                             ('3211',null,'Airlines'),
                                             ('3212',null,'DOMINICANA'),
                                             ('3213',null,'Airlines'),
                                             ('3214',null,'Airlines'),
                                             ('3215',null,'DAN AIR SERVICES'),
                                             ('3216',null,'CUMBERLAND AIRLINES'),
                                             ('3217',null,'CSA'),
                                             ('3218',null,'CROWN AIR'),
                                             ('3219',null,'COPA'),
                                             ('3220',null,'COMPANIA FAUCETT'),
                                             ('3221',null,'TRANSPORTES AEROS MILITARES ECCUATORANOS'),
                                             ('3222',null,'COMMAND AIRWAYS'),
                                             ('3223',null,'COMAIR'),
                                             ('3224',null,'Airlines'),
                                             ('3225',null,'Airlines'),
                                             ('3226',null,'Airlines'),
                                             ('3227',null,'Airlines'),
                                             ('3228',null,'CAYMAN AIRWAYS'),
                                             ('3229',null,'SAETA SOCIAEDAD ECUATORIANOS DE TRANSPORTES AEREOS'),
                                             ('3230',null,'Airlines'),
                                             ('3231',null,'SASHA SERVICIO AERO DE HONDURAS'),
                                             ('3232',null,'Airlines'),
                                             ('3233',null,'CAPITOL AIR'),
                                             ('3234',null,'BWIA'),
                                             ('3235',null,'BROKWAY AIR'),
                                             ('3236',null,'Airlines'),
                                             ('3237',null,'Airlines'),
                                             ('3238',null,'BEMIDJI AIRLINES'),
                                             ('3239',null,'BAR HARBOR AIRLINES'),
                                             ('3240',null,'BAHAMASAIR'),
                                             ('3241',null,'AVIATECA (GUATEMALA)'),
                                             ('3242',null,'AVENSA'),
                                             ('3243',null,'AUSTRIAN AIR SERVICE'),
                                             ('3244',null,'Airlines'),
                                             ('3245',null,'Airlines'),
                                             ('3246',null,'Airlines'),
                                             ('3247',null,'Airlines'),
                                             ('3248',null,'Airlines'),
                                             ('3249',null,'Airlines'),
                                             ('3250',null,'Airlines'),
                                             ('3251',null,'ALOHA AIRLINES'),
                                             ('3252',null,'ALM'),
                                             ('3253',null,'AMERICA WEST'),
                                             ('3254',null,'TRUMP AIRLINE'),
                                             ('3255',null,'Airlines'),
                                             ('3256',null,'ALASKA AIRLINES'),
                                             ('3257',null,'Airlines'),
                                             ('3258',null,'Airlines'),
                                             ('3259',null,'AMERICAN TRANS AIR'),
                                             ('3260',null,'Airlines'),
                                             ('3261',null,'AIR CHINA'),
                                             ('3262',null,'RENO AIR, INC.'),
                                             ('3263',null,'Airlines'),
                                             ('3264',null,'Airlines'),
                                             ('3265',null,'Airlines'),
                                             ('3266',null,'AIR SEYCHELLES'),
                                             ('3267',null,'AIR PANAMA'),
                                             ('3268',null,'Airlines'),
                                             ('3269',null,'Airlines'),
                                             ('3270',null,'Airlines'),
                                             ('3271',null,'Airlines'),
                                             ('3272',null,'Airlines'),
                                             ('3273',null,'Airlines'),
                                             ('3274',null,'Airlines'),
                                             ('3275',null,'Airlines'),
                                             ('3276',null,'Airlines'),
                                             ('3277',null,'Airlines'),
                                             ('3278',null,'Airlines'),
                                             ('3279',null,'Airlines'),
                                             ('3280',null,'AIR JAMAICA'),
                                             ('3281',null,'Airlines'),
                                             ('3282',null,'AIR DJIBOUTI'),
                                             ('3283',null,'Airlines'),
                                             ('3284',null,'AERO VIRGIN ISLANDS'),
                                             ('3285',null,'AERO PERU'),
                                             ('3286',null,'AEROLINEAS NICARAGUENSIS'),
                                             ('3287',null,'AERO COACH AVAIATION'),
                                             ('3288',null,'Airlines'),
                                             ('3289',null,'Airlines'),
                                             ('3290',null,'Airlines'),
                                             ('3291',null,'ARIANA AFGHAN'),
                                             ('3292',null,'CYPRUS AIRWAYS'),
                                             ('3293',null,'ECUATORIANA'),
                                             ('3294',null,'ETHIOPIAN AIRLINES'),
                                             ('3295',null,'KENYA AIRLINES'),
                                             ('3296',null,'Airlines'),
                                             ('3297',null,'Airlines'),
                                             ('3298',null,'AIR MAURITIUS'),
                                             ('3299',null,'WIDEROS FLYVESELSKAP'),
                                             ('3351',null,'AFFILIATED AUTO RENTAL'),
                                             ('3352',null,'AMERICAN INTL RENT-A-CAR'),
                                             ('3353',null,'BROOKS RENT-A-CAR'),
                                             ('3354',null,'ACTION AUTO RENTAL'),
                                             ('3355',null,'Car Rental'),
                                             ('3356',null,'Car Rental'),
                                             ('3357',null,'HERTZ RENT-A-CAR'),
                                             ('3358',null,'Car Rental'),
                                             ('3359',null,'PAYLESS CAR RENTAL'),
                                             ('3360',null,'SNAPPY CAR RENTAL'),
                                             ('3361',null,'AIRWAYS RENT-A-CAR'),
                                             ('3362',null,'ALTRA AUTO RENTAL'),
                                             ('3363',null,'Car Rental'),
                                             ('3364',null,'AGENCY RENT-A-CAR'),
                                             ('3365',null,'Car Rental'),
                                             ('3366',null,'BUDGET RENT-A-CAR'),
                                             ('3367',null,'Car Rental'),
                                             ('3368',null,'HOLIDAY RENT-A-WRECK'),
                                             ('3369',null,'Car Rental'),
                                             ('3370',null,'RENT-A-WRECK'),
                                             ('3371',null,'Car Rental'),
                                             ('3372',null,'Car Rental'),
                                             ('3373',null,'Car Rental'),
                                             ('3374',null,'Car Rental'),
                                             ('3375',null,'Car Rental'),
                                             ('3376',null,'AJAX RENT-A-CAR'),
                                             ('3377',null,'Car Rental'),
                                             ('3378',null,'Car Rental'),
                                             ('3379',null,'Car Rental'),
                                             ('3380',null,'Car Rental'),
                                             ('3381',null,'EUROP CAR'),
                                             ('3382',null,'Car Rental'),
                                             ('3383',null,'Car Rental'),
                                             ('3384',null,'Car Rental'),
                                             ('3385',null,'TROPICAL RENT-A-CAR'),
                                             ('3386',null,'SHOWCASE RENTAL CARS'),
                                             ('3387',null,'ALAMO RENT-A-CAR'),
                                             ('3388',null,'Car Rental'),
                                             ('3389',null,'AVIS RENT-A-CAR'),
                                             ('3390',null,'DOLLAR RENT-A-CAR'),
                                             ('3391',null,'EUROPE BY CAR'),
                                             ('3392',null,'Car Rental'),
                                             ('3393',null,'NATIONAL CAR RENTAL'),
                                             ('3394',null,'KEMWELL GROUP RENT-A-CAR'),
                                             ('3395',null,'THRIFTY RENT-A-CAR'),
                                             ('3396',null,'TILDEN TENT-A-CAR'),
                                             ('3397',null,'Car Rental'),
                                             ('3398',null,'ECONO-CAR RENT-A-CAR'),
                                             ('3399',null,'Car Rental'),
                                             ('3400',null,'AUTO HOST COST CAR RENTALS'),
                                             ('3401',null,'Car Rental'),
                                             ('3402',null,'Car Rental'),
                                             ('3403',null,'Car Rental'),
                                             ('3404',null,'Car Rental'),
                                             ('3405',null,'ENTERPRISE RENT-A-CAR'),
                                             ('3406',null,'Car Rental'),
                                             ('3407',null,'Car Rental'),
                                             ('3408',null,'Car Rental'),
                                             ('3409',null,'GENERAL RENT-A-CAR'),
                                             ('3410',null,'Car Rental'),
                                             ('3411',null,'Car Rental'),
                                             ('3412',null,'A-1 RENT-A-CAR'),
                                             ('3413',null,'Car Rental'),
                                             ('3414',null,'GODFREY NATL RENT-A-CAR'),
                                             ('3415',null,'Car Rental'),
                                             ('3416',null,'Car Rental'),
                                             ('3417',null,'Car Rental'),
                                             ('3418',null,'Car Rental'),
                                             ('3419',null,'ALPHA RENT-A-CAR'),
                                             ('3420',null,'ANSA INTL RENT-A-CAR'),
                                             ('3421',null,'ALLSTAE RENT-A-CAR'),
                                             ('3422',null,'Car Rental'),
                                             ('3423',null,'AVCAR RENT-A-CAR'),
                                             ('3424',null,'Car Rental'),
                                             ('3425',null,'AUTOMATE RENT-A-CAR'),
                                             ('3426',null,'Car Rental'),
                                             ('3427',null,'AVON RENT-A-CAR'),
                                             ('3428',null,'CAREY RENT-A-CAR'),
                                             ('3429',null,'INSURANCE RENT-A-CAR'),
                                             ('3430',null,'MAJOR RENT-A-CAR'),
                                             ('3431',null,'REPLACEMENT RENT-A-CAR'),
                                             ('3432',null,'RESERVE RENT-A-CAR'),
                                             ('3433',null,'UGLY DUCKLING RENT-A-CAR'),
                                             ('3434',null,'USA RENT-A-CAR'),
                                             ('3435',null,'VALUE RENT-A-CAR'),
                                             ('3436',null,'AUTOHANSA RENT-A-CAR'),
                                             ('3437',null,'CITE RENT-A-CAR'),
                                             ('3438',null,'INTERENT RENT-A-CAR'),
                                             ('3439',null,'MILLEVILLE RENT-A-CAR'),
                                             ('3440',null,'VIA ROUTE RENT-A-CAR'),
                                             ('3441',null,'Car Rental'),
                                             ('3501',null,'HOLIDAY INNS, HOLIDAY INN EXPRESS'),
                                             ('3502',null,'BEST WESTERN HOTELS'),
                                             ('3503',null,'SHERATON HOTELS'),
                                             ('3504',null,'HILTON HOTELS'),
                                             ('3505',null,'FORTE HOTELS'),
                                             ('3506',null,'GOLDEN TULIP HOTELS'),
                                             ('3507',null,'FRIENDSHIP INNS'),
                                             ('3508',null,'QUALITY INNS, QUALITY SUITES'),
                                             ('3509',null,'MARRIOTT HOTELS'),
                                             ('3510',null,'DAYS INN, DAYSTOP'),
                                             ('3511',null,'ARABELLA HOTELS'),
                                             ('3512',null,'INTER-CONTINENTAL HOTELS'),
                                             ('3513',null,'WESTIN HOTELS'),
                                             ('3514',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3515',null,'RODEWAY INNS'),
                                             ('3516',null,'LA QUINTA MOTOR INNS'),
                                             ('3517',null,'AMERICANA HOTELS'),
                                             ('3518',null,'SOL HOTELS'),
                                             ('3519',null,'PULLMAN INTERNATIONAL HOTELS'),
                                             ('3520',null,'MERIDIEN HOTELS'),
                                             ('3521',null,'CREST HOTELS (see FORTE HOTELS)'),
                                             ('3522',null,'TOKYO HOTEL'),
                                             ('3523',null,'PENNSULA HOTEL'),
                                             ('3524',null,'WELCOMGROUP HOTELS'),
                                             ('3525',null,'DUNFEY HOTELS'),
                                             ('3526',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3527',null,'DOWNTOWNER-PASSPORT HOTEL'),
                                             ('3528',null,'RED LION HOTELS, RED LION INNS'),
                                             ('3529',null,'CP HOTELS'),
                                             ('3530',null,'RENAISSANCE HOTELS, STOUFFER HOTELS'),
                                             ('3531',null,'ASTIR HOTELS'),
                                             ('3532',null,'SUN ROUTE HOTELS'),
                                             ('3533',null,'HOTEL IBIS'),
                                             ('3534',null,'SOUTHERN PACIFIC HOTELS'),
                                             ('3535',null,'HILTON INTERNATIONAL'),
                                             ('3536',null,'AMFAC HOTELS'),
                                             ('3537',null,'ANA HOTEL'),
                                             ('3538',null,'CONCORDE HOTELS'),
                                             ('3539',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3540',null,'IBEROTEL HOTELS'),
                                             ('3541',null,'HOTEL OKURA'),
                                             ('3542',null,'ROYAL HOTELS'),
                                             ('3543',null,'FOUR SEASONS HOTELS'),
                                             ('3544',null,'CIGA HOTELS'),
                                             ('3545',null,'SHANGRI-LA INTERNATIONAL'),
                                             ('3546',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3547',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3548',null,'HOTELES MELIA'),
                                             ('3549',null,'AUBERGE DES GOVERNEURS'),
                                             ('3550',null,'REGAL 8 INNS'),
                                             ('3551',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3552',null,'COAST HOTELS'),
                                             ('3553',null,'PARK INNS INTERNATIONAL'),
                                             ('3554',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3555',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3556',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3557',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3558',null,'JOLLY HOTELS'),
                                             ('3559',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3560',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3561',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3562',null,'COMFORT INNS'),
                                             ('3563',null,'JOURNEYS END MOTLS'),
                                             ('3564',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3565',null,'RELAX INNS'),
                                             ('3566',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3567',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3568',null,'LADBROKE HOTELS'),
                                             ('3569',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3570',null,'FORUM HOTELS'),
                                             ('3571',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3572',null,'MIYAKO HOTELS'),
                                             ('3573',null,'SANDMAN HOTELS'),
                                             ('3574',null,'VENTURE INNS'),
                                             ('3575',null,'VAGABOND HOTELS'),
                                             ('3576',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3577',null,'MANDARIN ORIENTAL HOTEL'),
                                             ('3578',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3579',null,'HOTEL MERCURE'),
                                             ('3580',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3581',null,'DELTA HOTEL'),
                                             ('3582',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3583',null,'SAS HOTELS'),
                                             ('3584',null,'PRINCESS HOTELS INTERNATIONAL'),
                                             ('3585',null,'HUNGAR HOTELS'),
                                             ('3586',null,'SOKOS HOTELS'),
                                             ('3587',null,'DORAL HOTELS'),
                                             ('3588',null,'HELMSLEY HOTELS'),
                                             ('3589',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3590',null,'FAIRMONT HOTELS'),
                                             ('3591',null,'SONESTA HOTELS'),
                                             ('3592',null,'OMNI HOTELS'),
                                             ('3593',null,'CUNARD HOTELS'),
                                             ('3594',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3595',null,'HOSPITALITY INTERNATIONAL'),
                                             ('3596',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3597',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3598',null,'REGENT INTERNATIONAL HOTELS'),
                                             ('3599',null,'PANNONIA HOTELS'),
                                             ('3600',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3601',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3602',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3603',null,'NOAHS HOTELS'),
                                             ('3604',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3605',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3606',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3607',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3608',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3609',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3610',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3611',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3612',null,'MOVENPICK HOTELS'),
                                             ('3613',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3614',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3615',null,'TRAVELODGE'),
                                             ('3616',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3617',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3618',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3619',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3620',null,'TELFORD INTERNATIONAL'),
                                             ('3621',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3622',null,'MERLIN HOTELS'),
                                             ('3623',null,'DORINT HOTELS'),
                                             ('3624',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3625',null,'HOTLE UNIVERSALE'),
                                             ('3626',null,'PRINCE HOTELS'),
                                             ('3627',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3628',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3629',null,'DAN HOTELS'),
                                             ('3630',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3631',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3632',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3633',null,'RANK HOTELS'),
                                             ('3634',null,'SWISSOTEL'),
                                             ('3635',null,'RESO HOTELS'),
                                             ('3636',null,'SAROVA HOTELS'),
                                             ('3637',null,'RAMADA INNS, RAMADA LIMITED'),
                                             ('3638',null,'HO JO INN, HOWARD JOHNSON'),
                                             ('3639',null,'MOUNT CHARLOTTE THISTLE'),
                                             ('3640',null,'HYATT HOTEL'),
                                             ('3641',null,'SOFITEL HOTELS'),
                                             ('3642',null,'NOVOTEL HOTELS'),
                                             ('3643',null,'STEIGENBERGER HOTELS'),
                                             ('3644',null,'ECONO LODGES'),
                                             ('3645',null,'QUEENS MOAT HOUSES'),
                                             ('3646',null,'SWALLOW HOTELS'),
                                             ('3647',null,'HUSA HOTELS'),
                                             ('3648',null,'DE VERE HOTELS'),
                                             ('3649',null,'RADISSON HOTELS'),
                                             ('3650',null,'RED ROOK INNS'),
                                             ('3651',null,'IMPERIAL LONDON HOTEL'),
                                             ('3652',null,'EMBASSY HOTELS'),
                                             ('3653',null,'PENTA HOTELS'),
                                             ('3654',null,'LOEWS HOTELS'),
                                             ('3655',null,'SCANDIC HOTELS'),
                                             ('3656',null,'SARA HOTELS'),
                                             ('3657',null,'OBEROI HOTELS'),
                                             ('3658',null,'OTANI HOTELS'),
                                             ('3659',null,'TAJ HOTELS INTERNATIONAL'),
                                             ('3660',null,'KNIGHTS INNS'),
                                             ('3661',null,'METROPOLE HOTELS'),
                                             ('3662',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3663',null,'HOTELES EL PRESIDENTS'),
                                             ('3664',null,'FLAG INN'),
                                             ('3665',null,'HAMPTON INNS'),
                                             ('3666',null,'STAKIS HOTELS'),
                                             ('3667',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3668',null,'MARITIM HOTELS'),
                                             ('3669',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3670',null,'ARCARD HOTELS'),
                                             ('3671',null,'ARCTIA HOTELS'),
                                             ('3672',null,'CAMPANIEL HOTELS'),
                                             ('3673',null,'IBUSZ HOTELS'),
                                             ('3674',null,'RANTASIPI HOTELS'),
                                             ('3675',null,'INTERHOTEL CEDOK'),
                                             ('3676',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3677',null,'CLIMAT DE FRANCE HOTELS'),
                                             ('3678',null,'CUMULUS HOTELS'),
                                             ('3679',null,'DANUBIUS HOTEL'),
                                             ('3680',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3681',null,'ADAMS MARK HOTELS'),
                                             ('3682',null,'ALLSTAR INNS'),
                                             ('3683',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3684',null,'BUDGET HOST INNS'),
                                             ('3685',null,'BUDGETEL HOTELS'),
                                             ('3686',null,'SUISSE CHALETS'),
                                             ('3687',null,'CLARION HOTELS'),
                                             ('3688',null,'COMPRI HOTELS'),
                                             ('3689',null,'CONSORT HOTELS'),
                                             ('3690',null,'COURTYARD BY MARRIOTT'),
                                             ('3691',null,'DILLION INNS'),
                                             ('3692',null,'DOUBLETREE HOTELS'),
                                             ('3693',null,'DRURY INNS'),
                                             ('3694',null,'ECONOMY INNS OF AMERICA'),
                                             ('3695',null,'EMBASSY SUITES'),
                                             ('3696',null,'EXEL INNS'),
                                             ('3697',null,'FARFIELD HOTELS'),
                                             ('3698',null,'HARLEY HOTELS'),
                                             ('3699',null,'MIDWAY MOTOR LODGE'),
                                             ('3700',null,'MOTEL 6'),
                                             ('3701',null,'GUEST QUARTERS (Formally PICKETT SUITE HOTELS)'),
                                             ('3702',null,'THE REGISTRY HOTELS'),
                                             ('3703',null,'RESIDENCE INNS'),
                                             ('3704',null,'ROYCE HOTELS'),
                                             ('3705',null,'SANDMAN INNS'),
                                             ('3706',null,'SHILO INNS'),
                                             ('3707',null,'SHONEYS INNS'),
                                             ('3708',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3709',null,'SUPER8 MOTELS'),
                                             ('3710',null,'THE RITZ CARLTON HOTELS'),
                                             ('3711',null,'FLAG INNS (AUSRALIA)'),
                                             ('3712',null,'GOLDEN CHAIN HOTEL'),
                                             ('3713',null,'QUALITY PACIFIC HOTEL'),
                                             ('3714',null,'FOUR SEASONS HOTEL (AUSTRALIA)'),
                                             ('3715',null,'FARIFIELD INN'),
                                             ('3716',null,'CARLTON HOTELS'),
                                             ('3717',null,'CITY LODGE HOTELS'),
                                             ('3718',null,'KAROS HOTELS'),
                                             ('3719',null,'PROTEA HOTELS'),
                                             ('3720',null,'SOUTHERN SUN HOTELS'),
                                             ('3721',null,'HILTON CONRAD'),
                                             ('3722',null,'WYNDHAM HOTEL AND RESORTS'),
                                             ('3723',null,'RICA HOTELS'),
                                             ('3724',null,'INER NOR HOTELS'),
                                             ('3725',null,'SEAINES PLANATION'),
                                             ('3726',null,'RIO SUITES'),
                                             ('3727',null,'BROADMOOR HOTEL'),
                                             ('3728',null,'BALLYS HOTEL AND CASINO'),
                                             ('3729',null,'JOHN ASCUAGAS NUGGET'),
                                             ('3730',null,'MGM GRAND HOTEL'),
                                             ('3731',null,'HARRAHS HOTELS AND CASINOS'),
                                             ('3732',null,'OPRYLAND HOTEL'),
                                             ('3733',null,'BOCA RATON RESORT'),
                                             ('3734',null,'HARVEY/BRISTOL HOTELS'),
                                             ('3735',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3736',null,'COLORADO BELLE/EDGEWATER RESORT'),
                                             ('3737',null,'RIVIERA HOTEL AND CASINO'),
                                             ('3738',null,'TROPICANA RESORT AND CASINO'),
                                             ('3739',null,'WOODSIDE HOTELS AND RESORTS'),
                                             ('3740',null,'TOWNPLACE SUITES'),
                                             ('3741',null,'MILLENIUM BROADWAY HOTEL'),
                                             ('3742',null,'CLUB MED'),
                                             ('3743',null,'BILTMORE HOTEL AND SUITES'),
                                             ('3744',null,'CAREFREE RESORTS'),
                                             ('3745',null,'ST. REGIS HOTEL'),
                                             ('3746',null,'THE ELIOT HOTEL'),
                                             ('3747',null,'CLUBCORP/CLUB RESORTS'),
                                             ('3748',null,'WELESLEY INNS'),
                                             ('3749',null,'THE BEVERLY HILLS HOTEL'),
                                             ('3750',null,'CROWNE PLAZA HOTELS'),
                                             ('3751',null,'HOMEWOOD SUITES'),
                                             ('3752',null,'PEABODY HOTELS'),
                                             ('3753',null,'GREENBRIAH RESORTS'),
                                             ('3754',null,'AMELIA ISLAND PLANATION'),
                                             ('3755',null,'THE HOMESTEAD'),
                                             ('3756',null,'SOUTH SEAS RESORTS'),
                                             ('3757',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3758',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3759',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3760',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3761',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3762',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3763',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3764',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3765',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3766',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3767',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3768',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3769',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3770',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3771',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3772',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3773',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3774',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3775',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3776',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3777',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3778',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3779',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3780',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3781',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3782',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3783',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3784',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3785',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3786',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3787',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3788',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3789',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3790',null,'Hotels/Motels/Inns/Resorts'),
                                             ('3816',null,'Home2Suites'),
                                             ('3835',null,'* MASTERS ECONOMY INNS'),
                                             ('4011',null,'Railroads'),
                                             ('4111',null,'Local/Suburban Commuter Passenger Transportation, Railroads, Feries, Local Water Transportation.'),
                                             ('4112',null,'Passenger Railways'),
                                             ('4119',null,'Ambulance Services'),
                                             ('4121',null,'Taxicabs and Limousines'),
                                             ('4131',null,'Bus Lines, Including Charters, Tour Buses'),
                                             ('4214',null,'Motor Freight Carriers, Moving and Storage Companies, Trucking, Local/Long Distance, Delivery Services, Local'),
                                             ('4215',null,'Courier Services, Air or Ground, Freight forwarders'),
                                             ('4225',null,'Public warehousing, Storage'),
                                             ('4411',null,'Steamship and Cruise Lines, Cruise and Steamship Lines'),
                                             ('4457',null,'Boat Rentals and Leases'),
                                             ('4468',null,'Marinas, Marine Service, and Supplies'),
                                             ('4511','X','Airlines and Air Carries'),
                                             ('4582',null,'Airports, Airport Terminals, Flying Fields'),
                                             ('4722',null,'Travel Agencies and Tour Operations'),
                                             ('4723',null,'Package Tour Operators (For use in Germany only)'),
                                             ('4784',null,'Toll and Bridge Fees'),
                                             ('4789',null,'Transportation Services, Not elsewhere classified)'),
                                             ('4812',null,'Telecommunications Equipment including telephone sales'),
                                             ('4813',null,'Special Telecom Merchants'),
                                             ('4814',null,'Telecommunication Services, Including Local and Long Distance Calls, Credit Card Calls, and Facsimile Services, Fax services, Telecommunication Services'),
                                             ('4815',null,'VisaPhone'),
                                             ('4816',null,'Computer Network/Information Services/Computer Network Services'),
                                             ('4821',null,'Telegraph services'),
                                             ('4829','U','Money Orders, Wire Transfer'),
                                             ('4899',null,'Cable and other pay television (previously Cable Services)'),
                                             ('4900',null,'Electric, Gas, Sanitary and Water Utilities'),
                                             ('5013',null,'Motor vehicle supplies and new parts'),
                                             ('5021',null,'Office and Commercial Furniture'),
                                             ('5039',null,'Construction Materials, Not Elsewhere Classified'),
                                             ('5044',null,'Office, Photographic, Photocopy, and Microfilm Equipment'),
                                             ('5045',null,'Computers, Computer Peripheral Equipment, Software'),
                                             ('5046',null,'Commercial Equipment, Not Elsewhere Classified'),
                                             ('5047',null,'Medical, Dental Ophthalmic, Hospital Equipment and Supplies'),
                                             ('5051',null,'Metal Service Centers and Offices'),
                                             ('5065',null,'Electrical Parts and Equipment'),
                                             ('5072',null,'Hardware Equipment and Supplies'),
                                             ('5074',null,'Plumbing and Heating Equipment and Supplies'),
                                             ('5085',null,'Industrial Supplies, Not Elsewhere Classified'),
                                             ('5094',null,'Precious Stones, Metals, Watches, and Jewelry'),
                                             ('5099',null,'Durable Goods, Not Elsewhere Classified'),
                                             ('5111',null,'Stationery, Office Supplies, Printing, and Writing Paper'),
                                             ('5122',null,'Drugs, Drug Proprietaries, and Druggist Sundries'),
                                             ('5131',null,'Piece Goods, Notions, and Other Dry Goods'),
                                             ('5137',null,'Mens Womens and Childrens Uniforms and Commercial Clothing'),
                                             ('5139',null,'Commercial Footwear'),
                                             ('5169',null,'Chemicals and Allied Products, Not Elsewhere Classified'),
                                             ('5172',null,'Petroleum and Petroleum Products'),
                                             ('5192',null,'Books, Periodicals, and Newspapers'),
                                             ('5193',null,'Florists Supplies, Nursery Stock and Flowers'),
                                             ('5198',null,'Paints, Varnishes, and Supplies'),
                                             ('5199',null,'Non-durable Goods, Not Elsewhere Classified'),
                                             ('5200',null,'Home Supply Warehouse Stores'),
                                             ('5211',null,'Lumber and Building Materials Stores'),
                                             ('5231',null,'Glass, Paint, and Wallpaper Stores'),
                                             ('5251',null,'Hardware Stores'),
                                             ('5261',null,'Nurseries, Lawn and Garden Supply Store'),
                                             ('5271',null,'Mobile Home Dealers'),
                                             ('5300',null,'Wholesale Clubs'),
                                             ('5309',null,'Duty Free Store'),
                                             ('5310',null,'Discount Stores'),
                                             ('5311',null,'Department Stores'),
                                             ('5331',null,'Variety Stores'),
                                             ('5399',null,'Misc. General Merchandise'),
                                             ('5411','R','Grocery Stores and Supermarkets'),
                                             ('5422',null,'Freezer and Locker Meat Provisioners'),
                                             ('5441',null,'Candy, Nut, and Confectionery Stores'),
                                             ('5451',null,'Dairy Products Stores'),
                                             ('5462',null,'Bakeries'),
                                             ('5499',null,'Miscellaneous Food Stores, Convenience Stores and Specialty Markets'),
                                             ('5511',null,'Car and Truck Dealers (New and Used) Sales, Service, Repairs, Parts, and Leasing'),
                                             ('5521',null,'Automobile and Truck Dealers (Used Only)'),
                                             ('5531',null,'Automobile Supply Stores'),
                                             ('5532',null,'Automotive Tire Stores'),
                                             ('5533',null,'Automotive Parts, Accessories Stores'),
                                             ('5541','R','Service Stations ( with or without ancillary services)'),
                                             ('5542',null,'Automated Fuel Dispensers'),
                                             ('5551',null,'Boat Dealers'),
                                             ('5561',null,'Recreational and Utility Trailers, Camp Dealers'),
                                             ('5571',null,'Motorcycle Dealers'),
                                             ('5592',null,'Motor Home Dealers'),
                                             ('5598',null,'Snowmobile Dealers'),
                                             ('5599',null,'Miscellaneous Auto Dealers'),
                                             ('5611',null,'Men’s & Boy’s Clothing and Accessories Stores'),
                                             ('5621',null,'Women’s Ready-to-Wear Stores'),
                                             ('5631',null,'Women’s Accessory and Specialty Shops'),
                                             ('5641',null,'Children’s and Infant’s Wear Stores'),
                                             ('5651',null,'Family Clothing Stores'),
                                             ('5655',null,'Sports and Riding Apparel Stores'),
                                             ('5661',null,'Shoe Stores'),
                                             ('5681',null,'Furriers and Fur Shops'),
                                             ('5691',null,'Men’s & Women’s Clothing Stores'),
                                             ('5697',null,'Tailors, Seamstress, Mending, and Alterations'),
                                             ('5698',null,'Wig and Toupee Stores'),
                                             ('5699',null,'Miscellaneous Apparel and Accessory Shops'),
                                             ('5712',null,'Furniture, Home Furnishings, and Equipment Stores (Except Appliances)'),
                                             ('5713',null,'Floor Covering Stores'),
                                             ('5714',null,'Drapery, Window Covering and Upholstery Stores'),
                                             ('5718',null,'Fireplace, Fireplace Screens, and Accessories Stores'),
                                             ('5719',null,'Miscellaneous Home Furnishing Specialty Stores'),
                                             ('5722',null,'Household Appliance Stores'),
                                             ('5732',null,'Electronic Sales'),
                                             ('5733',null,'Music Stores, Musical Instruments, Piano Sheet Music'),
                                             ('5734',null,'Computer Software Stores'),
                                             ('5735',null,'Record Shops'),
                                             ('5811',null,'Caterers'),
                                             ('5812',null,'Eating Places and Restaurants'),
                                             ('5813',null,'Drinking Places: Bars, Taverns, Nightclubs, Cocktail Lounges, and Discotheques'),
                                             ('5814',null,'Fast Food Restaurants'),
                                             ('5815',null,'Digital Goods: Media, Books, Movies, Music'),
                                             ('5816',null,'Digital Goods: Games'),
                                             ('5817',null,'Digital Goods: Applications (Excludes Games)'),
                                             ('5818',null,'Digital Goods: Large Digital Goods Merchant'),
                                             ('5832',null,'Antique Shops, Sales, Repairs, and Restoration Services'),
                                             ('5912',null,'Drug Stores and Pharmacies'),
                                             ('5921',null,'Package Stores, Beer, Wine, and Liquor'),
                                             ('5931',null,'Used Merchandise and Secondhand Stores'),
                                             ('5932',null,'Antique Shops'),
                                             ('5933',null,'Pawn Shops and Salvage Yards'),
                                             ('5935',null,'Wrecking and Salvage Yards'),
                                             ('5937',null,'Antique Reproductions'),
                                             ('5940',null,'Bicycle Shops, Sales and Service'),
                                             ('5941',null,'Sporting Goods Stores'),
                                             ('5942',null,'Book Stores'),
                                             ('5943',null,'Stationery Stores, Office and School Supply Stores'),
                                             ('5944',null,'Jewelry Stores, Watches, Clocks, and Silverware Stores'),
                                             ('5945',null,'Hobby, Toy, and Game Shops'),
                                             ('5946',null,'Camera and Photographic Supply Stores'),
                                             ('5947','R','Card Shops, Gift, Novelty, and Souvenir Shops'),
                                             ('5948',null,'Leather Foods Stores'),
                                             ('5949',null,'Sewing, Needle, Fabric, and Price Goods Stores'),
                                             ('5950',null,'Glassware/Crystal Stores'),
                                             ('5960',null,'Direct Marketing: Insurance Services'),
                                             ('5961',null,'Mail Order Houses Including Catalog Order Stores, Book/Record Clubs (No longer permitted for U.S. original presentments)'),
                                             ('5962',null,'Direct Marketing: Travel-Related Arrangement Services'),
                                             ('5963',null,'Door-to-Door Sales'),
                                             ('5964',null,'Direct Marketing, Catalog Merchant'),
                                             ('5965',null,'Direct Marketing, Catalog and Catalog and Retail Merchant'),
                                             ('5966',null,'Direct Marketing: Outbound Telemarketing Merchants'),
                                             ('5967',null,'Direct Marketing: Inbound Teleservices Merchants'),
                                             ('5968',null,'Direct Marketing: Continuity/Subscription Merchants'),
                                             ('5969',null,'Direct Marketing: Other Direct Marketing Merchants (Not Elsewhere Classified)'),
                                             ('5970',null,'Artists Supply and Craft Shops'),
                                             ('5971',null,'Art Dealers and Galleries'),
                                             ('5972',null,'Stamp and Coin Stores, Philatelic and Numismatic Supplies'),
                                             ('5973',null,'Religious Goods Stores'),
                                             ('5975',null,'Hearing Aids, Sales, Service, and Supply Stores'),
                                             ('5976',null,'Orthopedic Goods Prosthetic Devices'),
                                             ('5977',null,'Cosmetic Stores'),
                                             ('5978',null,'Typewriter Stores, Sales, Rental, Service'),
                                             ('5983',null,'Fuel, Fuel Oil, Wood, Coal, Liquefied Petroleum'),
                                             ('5992',null,'Florists'),
                                             ('5993',null,'Cigar Stores and Stands'),
                                             ('5994',null,'News Dealers and Newsstands'),
                                             ('5995',null,'Pet Shops, Pet Foods, and Pet Supplies'),
                                             ('5996',null,'Swimming Pools, Sales, Service, and Supplies'),
                                             ('5997',null,'Electric Razor Stores, Sales and Service'),
                                             ('5998',null,'Tent and Awning Shops'),
                                             ('5999','R','Miscellaneous and Specialty Retail Shops'),
                                             ('6010','C','Financial Institutions, Manual Cash Disbursements'),
                                             ('6011','Z','Financial Institutions, Manual Cash Disbursements'),
                                             ('6012','R','Financial Institutions, Merchandise and Services'),
                                             ('6051',null,'Non-Financial Institutions, Foreign Currency, Money Orders (not wire transfer) and Travelers Cheques'),
                                             ('6211','R','Security Brokers/Dealers'),
                                             ('6300','R','Insurance Sales, Underwriting, and Premiums'),
                                             ('6381',null,'Insurance Premiums, (no longer valid for first presentment work)'),
                                             ('6399',null,'Insurance, Not Elsewhere Classified ( no longer valid forfirst presentment work)'),
                                             ('6513',null,'Real Estate Agents and Managers - Rentals'),
                                             ('7011',null,'Lodging: Hotels, Motels, Resorts, and Central Reservation Services (Not Elsewhere Classified)'),
                                             ('7012',null,'Timeshares'),
                                             ('7032',null,'Sporting and Recreational Camps'),
                                             ('7033',null,'Trailer Parks and Camp Grounds'),
                                             ('7210',null,'Laundry, Cleaning, and Garment Services'),
                                             ('7211',null,'Laundry, Family and Commercial'),
                                             ('7216',null,'Dry Cleaners'),
                                             ('7217',null,'Carpet and Upholstery Cleaning'),
                                             ('7221',null,'Photographic Studios'),
                                             ('7230',null,'Barber and Beauty Shops'),
                                             ('7251',null,'Shop Repair Shops and Shoe Shine Parlors, and Hat Cleaning Shops'),
                                             ('7261',null,'Funeral Service and Crematories'),
                                             ('7273',null,'Dating and Escort Services'),
                                             ('7276',null,'Tax Preparation Service'),
                                             ('7277',null,'Counseling Services: Debt, Marriage, and Personal'),
                                             ('7278',null,'Buying/Shopping Services, Clubs'),
                                             ('7296',null,'Clothing Rental, Costumes, Formal Wear, Uniforms'),
                                             ('7297',null,'Massage Parlors'),
                                             ('7298',null,'Health and Beauty Shops'),
                                             ('7299',null,'Miscellaneous Personal Services (Not Elsewhere Classified)'),
                                             ('7311',null,'Advertising Services'),
                                             ('7321',null,'Consumer Credit Reporting Agencies'),
                                             ('7332',null,'Blueprinting and Photocopying Services'),
                                             ('7333',null,'Commercial Photography, Art and Graphics'),
                                             ('7338',null,'Quick Copy, Reproduction and Blueprinting Services'),
                                             ('7339',null,'Stenographic and Secretarial Support Services'),
                                             ('7342',null,'Exterminating and Disinfecting Services'),
                                             ('7349',null,'Cleaning and Maintenance, Janitorial Services'),
                                             ('7361',null,'Employment Agencies, Temporary Help Services'),
                                             ('7372',null,'Computer Programming, Integrated Systems Design and Data Processing Services'),
                                             ('7375',null,'Information Retrieval Services'),
                                             ('7379',null,'Computer Maintenance, Repair, and Services (Not Elsewhere Classified)'),
                                             ('7392',null,'Management, Consulting, and Public Relations Services'),
                                             ('7393',null,'Protective and Security Services, Including Armored Carsand Guard Dogs'),
                                             ('7394',null,'Equipment Rental and Leasing Services, Tool Rental, Furniture Rental, and Appliance Rental'),
                                             ('7395',null,'Photofinishing Laboratories, Photo Developing'),
                                             ('7399',null,'Business Services (Not Elsewhere Classified)'),
                                             ('7511',null,'Truck Stop'),
                                             ('7512',null,'Car Rental Companies ( Not Listed Below)'),
                                             ('7513',null,'Truck and Utility Trailer Rentals'),
                                             ('7519',null,'Motor Home and Recreational Vehicle Rentals'),
                                             ('7523',null,'Automobile Parking Lots and Garages'),
                                             ('7531',null,'Automotive Body Repair Shops'),
                                             ('7534',null,'Tire Re-treading and Repair Shops'),
                                             ('7535',null,'Paint Shops, Automotive'),
                                             ('7538',null,'Automotive Service Shops'),
                                             ('7542',null,'Car Washes'),
                                             ('7549',null,'Towing Services'),
                                             ('7622',null,'Radio Repair Shops'),
                                             ('7623',null,'Air Conditioning and Refrigeration Repair Shops'),
                                             ('7629',null,'Electrical And Small Appliance Repair Shops'),
                                             ('7631',null,'Watch, Clock, and Jewelry Repair'),
                                             ('7641',null,'Furniture, Furniture Repair, and Furniture Refinishing'),
                                             ('7692',null,'Welding Repair'),
                                             ('7699',null,'Repair Shops and Related Services,Miscellaneous'),
                                             ('7800',null,'Government-Owned Lotteries'),
                                             ('7801',null,'Government-Licensed On-Line Casinos (On-Line Gambling)'),
                                             ('7802',null,'Government-Licensed Horse/Dog Racing'),
                                             ('7829',null,'Motion Pictures and Video Tape Production and Distribution'),
                                             ('7832',null,'Motion Picture Theaters'),
                                             ('7841',null,'Video Tape Rental Stores'),
                                             ('7911',null,'Dance Halls, Studios and Schools'),
                                             ('7922',null,'Theatrical Producers (Except Motion Pictures), Ticket Agencies'),
                                             ('7929',null,'Bands, Orchestras, and Miscellaneous Entertainers (Not Elsewhere Classified)'),
                                             ('7932',null,'Billiard and Pool Establishments'),
                                             ('7933',null,'Bowling Alleys'),
                                             ('7941',null,'Commercial Sports, Athletic Fields, Professional Sport Clubs, and Sport Promoters'),
                                             ('7991',null,'Tourist Attractions and Exhibits'),
                                             ('7992',null,'Golf Courses, Public'),
                                             ('7993',null,'Video Amusement Game Supplies'),
                                             ('7994',null,'Video Game Arcades/Establishments'),
                                             ('7995',null,'Betting, Including Lottery Tickets, Casino Gaming Chips, Off-Track Betting, and Wagers at Race Tracks'),
                                             ('7996',null,'Amusement Parks, Carnivals, Circuses, Fortune Tellers'),
                                             ('7997',null,'Membership Clubs, Country Clubs, and Private Golf Courses'),
                                             ('7998',null,'Aquariums, Sea-aquariums, Dolphinariums'),
                                             ('7999',null,'Recreation Services (Not Elsewhere Classified)'),
                                             ('8011',null,'Doctors and Physicians (Not Elsewhere Classified)'),
                                             ('8021',null,'Dentists and Orthodontists'),
                                             ('8031',null,'Osteopaths'),
                                             ('8041',null,'Chiropractors'),
                                             ('8042',null,'Optometrists and Ophthalmologists'),
                                             ('8043',null,'Opticians, Opticians Goods and Eyeglasses'),
                                             ('8044',null,'Opticians, Optical Goods, and Eyeglasses (no longer validfor first presentments)'),
                                             ('8049',null,'Podiatrists and Chiropodists'),
                                             ('8050',null,'Nursing and Personal Care Facilities'),
                                             ('8062',null,'Hospitals'),
                                             ('8071',null,'Medical and Dental Laboratories'),
                                             ('8099',null,'Medical Services and Health Practitioners (Not Elsewhere Classified)'),
                                             ('8111',null,'Legal Services and Attorneys'),
                                             ('8211',null,'Elementary and Secondary Schools'),
                                             ('8220',null,'Colleges, Junior Colleges, Universities, and ProfessionalSchools'),
                                             ('8241',null,'Correspondence Schools'),
                                             ('8244',null,'Business and Secretarial Schools'),
                                             ('8249',null,'Vocational Schools and Trade Schools'),
                                             ('8299',null,'Schools and Educational Services (Not Elsewhere Classified)'),
                                             ('8351',null,'Child Care Services'),
                                             ('8398',null,'Charitable and Social Service Organizations'),
                                             ('8641',null,'Civic, Fraternal, and Social Associations'),
                                             ('8651',null,'Political Organizations'),
                                             ('8661',null,'Religious Organizations'),
                                             ('8675',null,'Automobile Associations'),
                                             ('8699',null,'Membership Organizations ( Not Elsewhere Classified)'),
                                             ('8734',null,'Testing Laboratories ( non-medical)'),
                                             ('8911',null,'Architectural, Engineering and Surveying Services'),
                                             ('8931',null,'Accounting, Auditing, and Bookkeeping Services'),
                                             ('8999',null,'Professional Services (Not Elsewhere Classified)'),
                                             ('9211',null,'Court Costs, including Alimony and Child Support'),
                                             ('9222',null,'Fines'),
                                             ('9223',null,'Bail and Bond Payments'),
                                             ('9311',null,'Tax Payments'),
                                             ('9399',null,'Government Services (Not Elsewhere Classified)'),
                                             ('9402',null,'Postal Services, Government Only'),
                                             ('9405',null,'Intra, Government Transactions'),
                                             ('9700',null,'Automated Referral Service ( For Visa Only)'),
                                             ('9701',null,'Visa Credential Service ( For Visa Only)'),
                                             ('9702',null,'GCAS Emergency Services ( For Visa Only)'),
                                             ('9950',null,'Intra, Company Purchases ( For Visa Only)');


UPDATE rc
SET description = 'Transaction not allowed due to MCC usage limit settings'
WHERE id = 9120;

UPDATE rc
SET mnemonic = 'not.allowed.cardproduct.usagelimit'
WHERE id = 1893;


INSERT INTO sysconfig (id, value, readperm, writeperm)
VALUES ('GL_INTERCHANGE_RECEIVABLE_ACCT', '12.001.00', 'login', 'sysadmin')
    ON CONFLICT (id) DO UPDATE SET (value, readperm, writeperm) = (EXCLUDED.value, EXCLUDED.readperm, EXCLUDED.writeperm);
INSERT INTO sysconfig (id, value, readperm, writeperm)
VALUES ('GL_INTERCHANGE_EARNING_ACCT', '30.002', 'login', 'sysadmin')
    ON CONFLICT (id) DO UPDATE SET (value, readperm, writeperm) = (EXCLUDED.value, EXCLUDED.readperm, EXCLUDED.writeperm);


UPDATE usage_limit SET allowecommerce = 'ALLOWED', allowpurchasechip = 'ALLOWED', allowpurchasecontactless = 'ALLOWED',
                       allowatmoperation = 'ALLOWED', allowatmwithdrawal = 'ALLOWED', allowoct = 'ALLOWED',
                       allowpurchasemagneticstripe = 'ALLOWED' WHERE id IN (1,4,5,6);
UPDATE usage_limit SET allowecommerce = 'REJECTED', allowpurchasechip = 'REJECTED', allowpurchasecontactless = 'REJECTED',
                       allowatmoperation = 'REJECTED', allowatmwithdrawal = 'REJECTED', allowoct = 'REJECTED',
                       allowpurchasemagneticstripe = 'REJECTED' WHERE id = 2;
UPDATE usage_limit SET allowecommerce = 'UNDEFINED', allowpurchasechip = 'UNDEFINED', allowpurchasecontactless = 'UNDEFINED',
                       allowatmoperation = 'UNDEFINED', allowatmwithdrawal = 'UNDEFINED', allowoct = 'UNDEFINED',
                       allowpurchasemagneticstripe = 'UNDEFINED' WHERE id = 3;

INSERT INTO sysconfig (id, value, readperm, writeperm)
VALUES
    ('SYS_DEFAULT_USAGE_LIMIT', '1', 'sysadmin', 'sysadmin')
    ON CONFLICT (id) DO NOTHING;

UPDATE card_products
SET usage_limit_id = 1
WHERE id IN (0,1,2);

UPDATE mcc
SET description = 'ITA SPA'
WHERE code like '3013';

UPDATE mcc
SET description = 'EASTERN'
WHERE code like '3019';

UPDATE mcc
SET description = 'FLYDUBAI'
WHERE code like '3070';

UPDATE mcc
SET description = 'SWOOP'
WHERE code like '3080';

UPDATE mcc
SET description = 'XIAMENAIR'
WHERE code like '3081';

UPDATE mcc
SET description = 'TOKYUHOTELS'
WHERE code like '3630';

UPDATE mcc
SET description = 'TOYOKOINN'
WHERE code like '3756';

INSERT INTO mcc (code, tcc, description) VALUES
    ('3303',NULL,'TIGERAIR');

INSERT INTO mcc (code, tcc, description) VALUES
    ('3308',NULL,'CSAIR');

INSERT INTO mcc (code, tcc, description) VALUES
    ('7322',NULL,'Debt Collection Agencies');

INSERT INTO mcc (code, tcc, description) VALUES
    ('8082',NULL,'Home Health Care Service');
