UPDATE acct SET code = '11.001.20' WHERE id = 4;

INSERT INTO acct (id, subclass, root, code, description, created, type, parent)
VALUES (32, 'F', 0, '11.001.00', 'Received Money', current_date, 1, 3);

UPDATE sysconfig SET value = '11.001.20' WHERE id = 'GL_CARDHOLDER_TRANSITORY_ACCT';

INSERT INTO sysconfig (id, value, readperm, writeperm)
VALUES ('GL_RECEIVED_MONEY_ACCT', '11.001.00', 'login', 'sysadmin');