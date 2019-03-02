CREATE TABLE IF NOT EXISTS user(
  id BIGINT PRIMARY KEY,
  email VARCHAR(100) UNIQUE NOT NULL,
  fname VARCHAR(100) NOT NULL,
  sname VARCHAR(100) NOT NULL,
  group_num VARCHAR(10),
  password_hash VARCHAR(255) NOT NULL,
  password_salt VARCHAR(32) NOT NULL,
  role INT NOT NULL,
  course_num INT NOT NULL,
  facul_num INT NOT NULL,
  start_ban DATE,
  end_ban DATE,
  summary_help INT,
  help_for_last_month INT
);

COMMENT ON TABLE user IS 'Table containing the application users'' data';
COMMENT ON COLUMN user.id IS 'User''s identifier';
COMMENT ON COLUMN user.email IS 'User''s email';
COMMENT ON COLUMN user.fname IS 'User''s first name';
COMMENT ON COLUMN user.sname IS 'User''s second name';
COMMENT ON COLUMN user.group_num IS 'User''s number of group';
COMMENT ON COLUMN user.password_hash IS 'User''s password hash';
COMMENT ON COLUMN user.password_salt IS 'A salt to calculate a password hash';
COMMENT ON COLUMN user.role IS 'User''s role:student, headman, or chairman';
COMMENT ON COLUMN user.course_num IS 'User''s course number';
COMMENT ON COLUMN user.facul_num IS 'User''s faculty number';
COMMENT ON COLUMN user.start_ban IS 'Start date of user''s ban';
COMMENT ON COLUMN user.end_ban IS 'End date of user''s ban';

CREATE SEQUENCE IF NOT EXISTS user_id_sequence START WITH 1 MINVALUE 1 INCREMENT BY 1;
COMMENT ON SEQUENCE user_id_sequence IS 'Sequence for identifiers if table ''user''';


CREATE TABLE IF NOT EXISTS key(
  close_key BIGINT PRIMARY KEY,
  open_key BIGINT UNIQUE NOT NULL,
  --FOREIGN KEY
  user_id BIGINT REFERENCES user(id) ON DELETE CASCADE,
  creating_time DATE,
  deleting_time DATE
)

COMMENT ON TABLE key IS 'Table containing key''s data';
COMMENT ON COLUMN key.close_key IS 'Close key for checking request';
COMMENT ON COLUMN key.open_key IS 'Open key for checking request';
COMMENT ON COLUMN key.user_id IS 'Id of user, who has got this key';
COMMENT ON COLUMN key.creating_time IS 'Time of creating key'
COMMENT ON COLUMN key.deleting_time IS 'Time of ending lifecircle of key'

CREATE TABLE IF NOT EXISTS request_from_user(
  request_id BIGINT PRIMARY KEY,
  file VARBINARY(1000) NOT NULL,
  proof VARBINARY(1000) NOT NULL,
  hash_file VARCHAR(100) NOT NULL,
  sign_hash VARCHAR(100) NOT NULL,
  close_key BIGINT PRIMARY KEY,
  status_of_accept INT NOT NULL,
  reason_of_request INT NOT NULL
)
