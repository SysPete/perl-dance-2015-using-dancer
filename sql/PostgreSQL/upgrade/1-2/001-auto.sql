-- Convert schema 'sql/_source/deploy/1/001-auto.yml' to 'sql/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE conferences ADD COLUMN start_date date;

;
ALTER TABLE medias ADD COLUMN priority integer DEFAULT 0 NOT NULL;
;

COMMIT;

