INSERT INTO cardproducts (id, name,active,pos,atm,moto,ecommerce,ds) VALUES (1, 'Default','Y','Y','Y','Y','Y','xml') ON CONFLICT (id) DO NOTHING;
INSERT INTO cardproducts (id, name,active,pos,atm,moto,ecommerce,ds) VALUES (2, 'BIMO','Y','Y','Y','Y','Y','bimo') ON CONFLICT (id) DO NOTHING;
INSERT INTO cardproducts (id, name,active,pos,atm,moto,ecommerce,ds) VALUES (3, 'XPERIENCE','Y','Y','Y','Y','Y','xperience') ON CONFLICT (id) DO NOTHING;
INSERT INTO binrange (id, start, "end", weight, cardproduct) VALUES (1, '800000000000','899999999999', 0, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO binrange (id, start, "end", weight, cardproduct) VALUES (2, '480000000000','489999999999', 0, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO binrange (id, start, "end", weight, cardproduct) VALUES (3, '600000000000','699999999999', 0, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO binrange (id, start, "end", weight, cardproduct) VALUES (4, '4546210100000000','4546210109999999', 0, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO binrange (id, start, "end", weight, cardproduct) VALUES (5, '4546210000000000','4546210109999999', 0, 3) ON CONFLICT (id) DO NOTHING;