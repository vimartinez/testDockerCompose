INSERT INTO acct (id, subclass, root, code, description, created, type, parent)
VALUES (31, 'F', 0, '21.006', 'RG 5272', current_date, 2, 12) ON CONFLICT (id) DO
UPDATE SET (subclass, root, code, description, created, type, parent) =
    (EXCLUDED.subclass, EXCLUDED.root, EXCLUDED.code, EXCLUDED.description,
    EXCLUDED.created, EXCLUDED.type, EXCLUDED.parent);

INSERT INTO sysconfig (id, value, readperm, writeperm)
VALUES ('GL_RG5272_ACCT', '21.006', 'login', 'sysadmin') ON CONFLICT (id) DO
UPDATE SET (value, readperm, writeperm) = (EXCLUDED.value, EXCLUDED.readperm, EXCLUDED.writeperm);