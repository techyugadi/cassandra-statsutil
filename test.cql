CREATE KEYSPACE example WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

use example;

CREATE TABLE IF NOT EXISTS mydata ( serialnum int PRIMARY KEY, txtlabel text, data int);
CREATE INDEX idx_mydata ON mydata (txtlabel);

INSERT INTO mydata (serialnum, txtlabel, data) VALUES (1, 'A', 1);
INSERT INTO mydata (serialnum, txtlabel, data) VALUES (2, 'A', 2);
INSERT INTO mydata (serialnum, txtlabel, data) VALUES (3, 'A', 3);
INSERT INTO mydata (serialnum, txtlabel, data) VALUES (4, 'A', 4);
INSERT INTO mydata (serialnum, txtlabel, data) VALUES (5, 'A', 5);
INSERT INTO mydata (serialnum, txtlabel, data) VALUES (6, 'A', 6);
INSERT INTO mydata (serialnum, txtlabel, data) VALUES (7, 'A', 7);
INSERT INTO mydata (serialnum, txtlabel, data) VALUES (8, 'A', 8);
INSERT INTO mydata (serialnum, txtlabel, data) VALUES (9, 'A', 9);
INSERT INTO mydata (serialnum, txtlabel, data) VALUES (10, 'B', 9);
INSERT INTO mydata (serialnum, txtlabel, data) VALUES (11, 'B', 8);
INSERT INTO mydata (serialnum, txtlabel, data) VALUES (12, 'B', 7);
INSERT INTO mydata (serialnum, txtlabel, data) VALUES (13, 'B', 6);
INSERT INTO mydata (serialnum, txtlabel, data) VALUES (14, 'B', 5);
INSERT INTO mydata (serialnum, txtlabel, data) VALUES (15, 'B', 4);
INSERT INTO mydata (serialnum, txtlabel, data) VALUES (16, 'B', 3);
INSERT INTO mydata (serialnum, txtlabel, data) VALUES (17, 'B', 2);
INSERT INTO mydata (serialnum, txtlabel, data) VALUES (18, 'B', 1);

SELECT variance (data) FROM mydata WHERE txtlabel='B';
SELECT stdev (data) FROM mydata WHERE txtlabel='B';

CREATE TABLE IF NOT EXISTS mytuples ( serialnum int PRIMARY KEY, txtlabel text, data tuple<int, double>);
CREATE INDEX idx_mytuples ON mytuples (txtlabel);

INSERT INTO mytuples (serialnum, txtlabel, data) VALUES (1, 'A', (1, 0.1));
INSERT INTO mytuples (serialnum, txtlabel, data) VALUES (2, 'A', (2, 0.2));
INSERT INTO mytuples (serialnum, txtlabel, data) VALUES (3, 'A', (3, 0.3));
INSERT INTO mytuples (serialnum, txtlabel, data) VALUES (4, 'A', (4, 0.4));
INSERT INTO mytuples (serialnum, txtlabel, data) VALUES (1, 'B', (1, 0.1));
INSERT INTO mytuples (serialnum, txtlabel, data) VALUES (1, 'A', (1, 0.1));
INSERT INTO mytuples (serialnum, txtlabel, data) VALUES (5, 'B', (1, 0.1));
INSERT INTO mytuples (serialnum, txtlabel, data) VALUES (6, 'B', (2, 0.2));
INSERT INTO mytuples (serialnum, txtlabel, data) VALUES (7, 'B', (3, 0.3));
INSERT INTO mytuples (serialnum, txtlabel, data) VALUES (8, 'B', (4, 0.3));
INSERT INTO mytuples (serialnum, txtlabel, data) VALUES (9, 'B', (5, 0.05));
INSERT INTO mytuples (serialnum, txtlabel, data) VALUES (10, 'B', (6, 0.05));

SELECT wtaverage (data) FROM mytuples WHERE txtlabel='B';


CREATE TABLE IF NOT EXISTS points ( serialnum int PRIMARY KEY, txtlabel text, xyz tuple<int, int, int>);

CREATE INDEX idx_points ON points (txtlabel);

INSERT INTO points (serialnum, txtlabel, xyz) VALUES (1, 'A', (1, 1, 1));
INSERT INTO points (serialnum, txtlabel, xyz) VALUES (2, 'A', (2, 2, 2));
INSERT INTO points (serialnum, txtlabel, xyz) VALUES (3, 'A', (3, 3, 3));
INSERT INTO points (serialnum, txtlabel, xyz) VALUES (4, 'A', (4, 4, 4));
INSERT INTO points (serialnum, txtlabel, xyz) VALUES (5, 'A', (7, 6, 5));
INSERT INTO points (serialnum, txtlabel, xyz) VALUES (6, 'A', (6, 6, 6));

SELECT centroid (xyz) FROM points WHERE txtlabel='A';

CREATE TABLE IF NOT EXISTS mycorr ( serialnum int PRIMARY KEY, txtlabel text, data tuple<int, int>);
CREATE INDEX idx_mycorr ON mycorr (txtlabel);

INSERT INTO mycorr (serialnum, txtlabel, data) VALUES (1, 'A', (1, 9));
INSERT INTO mycorr (serialnum, txtlabel, data) VALUES (2, 'A', (2, 8));
INSERT INTO mycorr (serialnum, txtlabel, data) VALUES (3, 'A', (3, 7));
INSERT INTO mycorr (serialnum, txtlabel, data) VALUES (4, 'A', (4, 6));
INSERT INTO mycorr (serialnum, txtlabel, data) VALUES (5, 'A', (5, 5));
INSERT INTO mycorr (serialnum, txtlabel, data) VALUES (6, 'A', (6, 4));
INSERT INTO mycorr (serialnum, txtlabel, data) VALUES (7, 'A', (7, 3));
INSERT INTO mycorr (serialnum, txtlabel, data) VALUES (8, 'A', (8, 2));
INSERT INTO mycorr (serialnum, txtlabel, data) VALUES (9, 'A', (9, 1));

SELECT correlation (data) FROM mycorr WHERE txtlabel='A';
