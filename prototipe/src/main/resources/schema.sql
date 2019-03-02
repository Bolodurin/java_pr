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
COMMENT ON COLUMN user.summary_help IS 'Sum of helping for all the time';
COMMENT ON COLUMN user.help_for_last_month IS 'Sum of helping for last month';

CREATE SEQUENCE IF NOT EXISTS user_id_sequence START WITH 1 MINVALUE 1 INCREMENT BY 1;
COMMENT ON SEQUENCE user_id_sequence IS 'Sequence for identifiers if table ''user''';



CREATE TABLE IF NOT EXISTS key(
  close_key BIGINT PRIMARY KEY,
  open_key BIGINT UNIQUE NOT NULL,
  --FOREIGN KEY
  user_id BIGINT REFERENCES user(id) ON DELETE CASCADE,
  creating_time DATE,
  deleting_time DATE
);

COMMENT ON TABLE key IS 'Table containing key''s data';
COMMENT ON COLUMN key.close_key IS 'Close key for checking request';
COMMENT ON COLUMN key.open_key IS 'Open key for checking request';
COMMENT ON COLUMN key.user_id IS 'Id of user, who has got this key';
COMMENT ON COLUMN key.creating_time IS 'Time of creating key'
COMMENT ON COLUMN key.deleting_time IS 'Time of ending life circle of key'



CREATE TABLE IF NOT EXISTS request_from_user(
  request_id BIGINT PRIMARY KEY,
  file BYTEARRAY(1000) NOT NULL,
  proof BYTEARRAY(1000) NOT NULL,
  hash_file VARCHAR(100) NOT NULL,
  sign_hash VARCHAR(100) NOT NULL,
  close_key BIGINT  REFERENCES key(close_key),
  status_of_accept INT NOT NULL,
  reason_of_request INT NOT NULL,
  time_of_requesting DATE NOT NULL
);

CREATE SEQUENCE IF NOT EXISTS request_from_user_id_sequence START WITH 1 MINVALUE 1 INCREMENT BY 1;
COMMENT ON SEQUENCE request_from_user_id_sequence IS 'Sequence for identifiers if table ''request_from_user''';

COMMENT ON TABLE request_from_user IS 'Table consists from requests, which sends from users';
COMMENT ON COLUMN request_from_user.request_id IS 'Id of request''s from user';
COMMENT ON COLUMN request_from_user.file IS 'File, which was sending by user and there is a document';
COMMENT ON COLUMN request_from_user.proof IS 'File, which confirm document';
COMMENT ON COLUMN request_from_user.hash_file IS 'Hash of received file';
COMMENT ON COLUMN request_from_user.sign_hash IS 'Signed received hash of file';
COMMENT ON COLUMN request_from_user.close_key IS 'Close key, which signed file';
COMMENT ON COLUMN request_from_user.status_of_accept IS 'Status of accepting request';
COMMENT ON COLUMN request_from_user.reason_of_request IS 'One of the most popular reason for helping';



CREATE TABLE IF NOT EXISTS headman_request(
  request_id BIGINT PRIMARY KEY,
  file BYTEARRAY(1000) NOT NULL,
  user_id BIGINT REFERENCES user(id),
  time_of_requesting DATE
);

CREATE SEQUENCE IF NOT EXISTS headman_request_id_sequence START WITH 1 MINVALUE 1 INCREMENT BY 1;
COMMENT ON SEQUENCE headman_request_id_sequence IS 'Sequence for identifiers if table ''headman_request''';

COMMENT ON TABLE headman_request IS 'Table consists from requests, which sends from headman';
COMMENT ON COLUMN headman_request.request_id IS 'Id of request''s from headman';
COMMENT ON COLUMN headman_request.file IS 'File, which was sending by headman';
COMMENT ON COLUMN headman_request.file IS 'Time of sending request';


CREATE TABLE IF NOT EXISTS chairman_requests(
  user_id BIGINT REFERENCES user(id),
  request_id BIGINT REFERENCES request_from_user(request_id) ON DELETE CASCADE,
  CONSTRAINT user_request_pk PRIMARY KEY (user_id, request_id)
);

COMMENT ON TABLE user_request IS 'Table, which connect chairman with him requests';
COMMENT ON COLUMN user_request.user_id IS 'Chairman, who received the request from headman';
COMMENT ON COLUMN user_request.request_id IS 'One of the request, which received to chairman';


CREATE TABLE IF NOT EXISTS headman_request(
  user_id BIGINT REFERENCES user(id),
  request_id BIGINT REFERENCES request_from_user(request_id) ON DELETE CASCADE,
  CONSTRAINT user_request_pk PRIMARY KEY (user_id, request_id)
);

COMMENT ON TABLE user_request IS 'Table, which connect headman with him requests';
COMMENT ON COLUMN user_request.user_id IS 'Headman, who received the request from student';
COMMENT ON COLUMN user_request.request_id IS 'One of the request, which received to headman';


CREATE TABLE IF NOT EXISTS user_request(
  user_id BIGINT REFERENCES user(id) ON DELETE CASCADE,
  request_id BIGINT REFERENCES request_from_user(request_id) ON DELETE CASCADE,
  CONSTRAINT user_request_pk PRIMARY KEY (user_id, request_id)
);

COMMENT ON TABLE user_request IS 'Table, which connect user with him request';
COMMENT ON COLUMN user_request.user_id IS 'User, who sent the request';
COMMENT ON COLUMN user_request.request_id IS 'Request, which sent by user';
