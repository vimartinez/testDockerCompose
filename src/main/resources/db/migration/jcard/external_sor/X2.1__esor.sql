----------
-- ESOR --
----------

-----------------------
-- Chart of accounts --
-----------------------
INSERT INTO acct (id, subclass, root, code, description, created, type, parent)
VALUES
    (1, 'C', 0, '1', 'Assets', current_date, 1, 0),
    (2, 'C', 0, '11', 'Issuer', current_date, 1, 1),
    (3, 'C', 0, '11.001', 'Issuer ${issuerName}', current_date, 1, 2),
    (4, 'F', 0, '11.001.00', 'Cardholder Transitory', current_date, 1, 3),
    (5, 'F', 0, '11.001.01', 'Exchange Rate Conversion', current_date, 1, 3),
    (6, 'C', 0, '12', 'Receivables', current_date, 1, 1),
    (7, 'F', 0, '12.001', 'Interchange Receivable', current_date, 1, 6),
    (8, 'C', 0, '2', 'Liabilities', current_date, 2, 0),
    (9, 'C', 0, '20', 'Payables', current_date, 2, 8),
    (10, 'F', 0, '20.001', 'Clearing Visa Transactions', current_date, 2, 9),
    (11, 'F', 0, '20.002', 'Clearing Mastercard Transactions', current_date, 2, 9),
    (12, 'C', 0, '21', 'Tax', current_date, 2, 8),
    (13, 'F', 0, '21.001', 'Ley 27.541', current_date, 2, 12),
    (14, 'F', 0, '21.002', 'RG4240', current_date, 2, 12),
    (15, 'F', 0, '21.003', 'RG4815', current_date, 2, 12),
    (16, 'F', 0, '21.004', 'Ret IIBB', current_date, 2, 12),
    (17, 'F', 0, '21.005', 'IVA', current_date, 2, 12),
    (18, 'C', 0, '29', 'Temporary Liabilities', current_date, 2, 8),
    (19, 'F', 0, '29.001', 'Transferred Money', current_date, 2, 18),
    (20, 'F', 0, '29.002', 'Transferred Fee', current_date, 2, 18),
    (21, 'F', 0, '29.003', 'Impuestos Reservados', current_date, 2, 18),
    (22, 'C', 0, '3', 'Earnings', current_date, 2, 0),
    (23, 'C', 0, '30', 'Issuers 001', current_date, 2, 22),
    (24, 'F', 0, '30.001', 'Earned fees', current_date, 2, 23),
    (25, 'F', 0, '30.002', 'Interchange Earning', current_date, 2, 23),
    (26, 'C', 0, '4', 'Losses', current_date, 2, 0),
    (27, 'C', 0, '40', 'Refunds to claim', current_date, 2, 26),
    (28, 'F', 0, '40.001', 'Chargebacks', current_date, 2, 27),
    (29, 'C', 0, '41', 'Ajustes Varios', current_date, 2, 26),
    (30, 'F', 0, '41.001', 'Ajuste loss', current_date, 2, 29)
ON CONFLICT (id) DO UPDATE SET (subclass, root, code, description, created, type, parent) =
                                   (EXCLUDED.subclass, EXCLUDED.root, EXCLUDED.code, EXCLUDED.description,
                                    EXCLUDED.created, EXCLUDED.type, EXCLUDED.parent);

-------------------------
-- issuers & acquirers --
-------------------------
INSERT INTO issuers (id, institutionid, active, name, tz, startdate, enddate, journal, assetsaccount, earningsaccount)
VALUES
    (0, '00000000001', 'Y', '${issuerName}', 'UTC', current_date, '2100-01-01', 0, 3, 23)
    ON CONFLICT (id) DO UPDATE SET (institutionid, active, name, tz, startdate, enddate, journal, assetsaccount,
                            earningsaccount) =
                            (EXCLUDED.institutionid, EXCLUDED.active, EXCLUDED.name, EXCLUDED.tz,
                            EXCLUDED.startdate, EXCLUDED.enddate, EXCLUDED.journal, EXCLUDED.assetsaccount,
                            EXCLUDED.earningsaccount);

INSERT INTO acquirers (id, active, institutionid, name, transactionaccount, feeaccount, refundaccount, depositaccount,
                       issuer)
VALUES
    (0, 'Y', '00000000001', '${acquirerName}', 10, 10, 10, 10, 0)
    ON CONFLICT (id) DO UPDATE SET (institutionid, active, name, transactionaccount, feeaccount, refundaccount,
                            depositaccount, issuer) =
                            (EXCLUDED.institutionid, EXCLUDED.active, EXCLUDED.name, EXCLUDED.transactionaccount,
                            EXCLUDED.feeaccount, EXCLUDED.refundaccount, EXCLUDED.depositaccount,
                            EXCLUDED.issuer);

-------------------
-- card_products --
-------------------
UPDATE card_products
SET (issuedaccount, feeaccount, issuer) = (4, 24, 0)
WHERE id = 0;

---------------
-- sysconfig --
---------------
INSERT INTO sysconfig (id, value, readperm, writeperm)
VALUES
    ('GL_CHART', 'jcard', 'sysconfig.read', 'sysconfig.write'),
    ('GL_JOURNAL', 'jcard', 'sysconfig.read', 'sysconfig.write'),
    ('GL_ISSUERS_ACCT', '11', 'sysconfig.read', 'sysconfig.write'),
    ('credit.test', null, null, null),
    ('debit.test', null, null, null),
    ('transfer.test', null, null, null),
    ('perm.sysadmin', 'System Administrator', 'sysadmin', 'sysadmin'),
    ('perm.login', 'Login', 'sysconfig.read', 'sysadmin'),
    ('perm.sysconfig', 'View and edit System Configuration', 'sysconfig.read', 'sysadmin'),
    ('perm.sysconfig.admin', 'Admin System Configuration', 'sysconfig.read', 'sysadmin'),
    ('perm.users.write', 'Write permission on Users', 'sysconfig.read', 'sysadmin'),
    ('perm.users.read', 'Read permission on Users', 'sysconfig.read', 'sysadmin'),
    ('perm.accounting', 'Access to accounting records', 'sysconfig.read', 'sysadmin'),
    ('sys.REMEMBER_PASSWORD_ENABLED', 'true', 'sysconfig.read', 'sysadmin'),
    ('sys.MAX_LOGIN_ATTEMPTS', '5', 'sysconfig.read', 'sysadmin'),
    ('sys.PASSWORD_AGE', '90', 'sysconfig.read', 'sysadmin'),
    ('GL_ISSUERS_ASSETS_ACCT', '11', 'login', 'sysadmin'),
    ('GL_ISSUERS_EARNINGS_ACCT', '31', 'login', 'sysadmin'),
    ('GL_ISSUERS_LOSSES_ACCT', '41.001', 'login', 'sysadmin'),
    ('auth.cashback.limit', 300000, 'sysadmin', 'sysadmin'),
    ('GL_EXCHANGE_RATE_CONVERSION_ACCT', '11.001.01', 'login', 'sysadmin'),
    ('GL_TRANSFERRED_MONEY_ACCT', '29.001', 'login', 'sysadmin'),
    ('GL_RESERVED_TAXES_ACCT', '29.003', 'login', 'sysadmin'),
    ('GL_LEY_27541_ACCT', '21.001', 'login', 'sysadmin'),
    ('GL_RG4240_ACCT', '21.002', 'login', 'sysadmin'),
    ('GL_RG4815_ACCT', '21.003', 'login', 'sysadmin'),
    ('GL_RET_IIBB_ACCT', '21.004', 'login', 'sysadmin'),
    ('GL_CARDHOLDER_TRANSITORY_ACCT', '11.001.00', 'login', 'sysadmin'),
    ('GL_TRANSFERRED_FEE_ACCT', '29.002', 'login', 'sysadmin'),
    ('GL_INTERCHANGE_EARNING_ACCT', '30.002', 'login', 'sysadmin'),
    ('GL_CLEARING_VISA_TXN_ACCT', '20.001', 'login', 'sysadmin')
ON CONFLICT (id) DO UPDATE SET (value, readperm, writeperm) = (EXCLUDED.value, EXCLUDED.readperm, EXCLUDED.writeperm);
