ALTER TABLE consumer DROP IF EXISTS     securedata;
ALTER TABLE consumer DROP IF EXISTS     kid;
ALTER TABLE consumer ADD  IF NOT EXISTS hash varchar(8192);
