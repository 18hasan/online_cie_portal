use cieportal;

create table AIQuestion(
   id varchar(10),
   name varchar(500) PRIMARY KEY,
   opt1 varchar(500),
   opt2 varchar(500),
   opt3 varchar(500),
   opt4 varchar(500),
   answer varchar(500)
);

create table DBMSQuestion(
   id varchar(10),
   name varchar(500) PRIMARY KEY,
   opt1 varchar(500),
   opt2 varchar(500),
   opt3 varchar(500),
   opt4 varchar(500),
   answer varchar(500)
);
-- Create a function to check 1NF
DELIMITER //
/*CREATE FUNCTION IsIn1NF_dbms()
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE is_1nf BOOLEAN;

    -- Check if each column has atomic values
    SET is_1nf = (
        SELECT
            COUNT(DISTINCT id) = COUNT(id),
            COUNT(DISTINCT name) = COUNT(name),
            COUNT(DISTINCT opt1) = COUNT(opt1),
            COUNT(DISTINCT opt2) = COUNT(opt2),
            COUNT(DISTINCT opt3) = COUNT(opt3),
            COUNT(DISTINCT opt4) = COUNT(opt4),
            COUNT(DISTINCT answer) = COUNT(answer)
        FROM DBMSQuestion
    );

    RETURN is_1nf;
END //
DELIMITER ;*/

drop table dbmsquestion;
create table OSSPQuestion(
   id varchar(10),
   name varchar(500) PRIMARY KEY,
   opt1 varchar(500),
   opt2 varchar(500),
   opt3 varchar(500),
   opt4 varchar(500),
   answer varchar(500)
);

DELIMITER //
CREATE FUNCTION IsIn1NF_AIQuestion()
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE is_1nf BOOLEAN;

    -- Check if each column has atomic values
    SET is_1nf = (
        SELECT
            COUNT(DISTINCT id) = COUNT(id),
            COUNT(DISTINCT name) = COUNT(name),
            COUNT(DISTINCT opt1) = COUNT(opt1),
            COUNT(DISTINCT opt2) = COUNT(opt2),
            COUNT(DISTINCT opt3) = COUNT(opt3),
            COUNT(DISTINCT opt4) = COUNT(opt4),
            COUNT(DISTINCT answer) = COUNT(answer)
        FROM OSSPQuestion
    );

    RETURN is_1nf;
END //
DELIMITER ;
-- Check if AIQuestion table is in 1NF
CALL IsIn1NF_dbms();

create table FLATQuestion(
   id varchar(10),
   name varchar(500) PRIMARY KEY, 
   opt1 varchar(500),
   opt2 varchar(500),
   opt3 varchar(500), 
   opt4 varchar(500),
   answer varchar(500)
);

drop procedure Check1NF;
DELIMITER //
CREATE PROCEDURE Check1NF(IN table_name VARCHAR(255))
BEGIN
    DECLARE has_repeating_groups BOOLEAN;

    -- Check for repeating groups in each column based on the provided table name
    IF table_name = 'FLATQuestion' THEN
        SET has_repeating_groups = (
            SELECT
                COUNT(DISTINCT id) < COUNT(id) OR
                COUNT(DISTINCT name) < COUNT(name) OR
                COUNT(DISTINCT opt1) < COUNT(opt1) OR
                COUNT(DISTINCT opt2) < COUNT(opt2) OR
                COUNT(DISTINCT opt3) < COUNT(opt3) OR
                COUNT(DISTINCT opt4) < COUNT(opt4) OR
                COUNT(DISTINCT answer) < COUNT(answer)
            FROM cieportal.FLATQuestion
        );
    ELSEIF table_name = 'OSSPQuestion' THEN
        SET has_repeating_groups = (
            SELECT
                COUNT(DISTINCT id) < COUNT(id) OR
                COUNT(DISTINCT name) < COUNT(name) OR
                COUNT(DISTINCT opt1) < COUNT(opt1) OR
                COUNT(DISTINCT opt2) < COUNT(opt2) OR
                COUNT(DISTINCT opt3) < COUNT(opt3) OR
                COUNT(DISTINCT opt4) < COUNT(opt4) OR
                COUNT(DISTINCT answer) < COUNT(answer)
            FROM cieportal.OSSPQuestion
        );
    -- Add more conditions for other tables as needed
    END IF;

    -- Signal an exception if repeating groups are detected
    IF has_repeating_groups THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Table does not meet 1NF criteria';
    END IF;
END //
DELIMITER ;

CALL Check1NF('osspquestion');


use cieportal;
DELIMITER //
DELIMITER //
DELIMITER //
CREATE PROCEDURE Check2NF(IN table_name VARCHAR(255))
BEGIN
    DECLARE has_partial_dependencies BOOLEAN;

    -- Check for partial dependencies in each column based on the provided table name
    IF table_name = 'FLATQuestion' THEN
        SET has_partial_dependencies = (
            SELECT
                COUNT(DISTINCT id) < COUNT(id) OR
                COUNT(DISTINCT name) < COUNT(name) OR
                COUNT(DISTINCT opt1) < COUNT(opt1) OR
                COUNT(DISTINCT opt2) < COUNT(opt2) OR
                COUNT(DISTINCT opt3) < COUNT(opt3) OR
                COUNT(DISTINCT opt4) < COUNT(opt4) OR
                COUNT(DISTINCT answer) < COUNT(answer) OR
                COUNT(DISTINCT CONCAT(id, name)) < COUNT(DISTINCT id, name)
            FROM cieportal.FLATQuestion
        );
    ELSEIF table_name = 'OSSPQuestion' THEN
        SET has_partial_dependencies = (
            SELECT
                COUNT(DISTINCT id) < COUNT(id) OR
                COUNT(DISTINCT name) < COUNT(name) OR
                COUNT(DISTINCT opt1) < COUNT(opt1) OR
                COUNT(DISTINCT opt2) < COUNT(opt2) OR
                COUNT(DISTINCT opt3) < COUNT(opt3) OR
                COUNT(DISTINCT opt4) < COUNT(opt4) OR
                COUNT(DISTINCT answer) < COUNT(answer) OR
                COUNT(DISTINCT CONCAT(id, name)) < COUNT(DISTINCT id, name)
            FROM cieportal.OSSPQuestion
        );
   
    END IF;

    -- Signal an exception if partial dependencies are detected
    IF has_partial_dependencies THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'does not meet 2NF criteria';
    END IF;
END //
DELIMITER ;
CALL Check2NF('osspquestion');

DELIMITER //
CREATE PROCEDURE Check3NF(IN table_name VARCHAR(255))
BEGIN
    DECLARE has_transitive_dependencies BOOLEAN;

    -- Check for transitive dependencies in each column based on the provided table name
    IF table_name = 'FLATQuestion' THEN
        SET has_transitive_dependencies = (
            SELECT
                COUNT(DISTINCT id) < COUNT(id) OR
                COUNT(DISTINCT name) < COUNT(name) OR
                COUNT(DISTINCT opt1) < COUNT(opt1) OR
                COUNT(DISTINCT opt2) < COUNT(opt2) OR
                COUNT(DISTINCT opt3) < COUNT(opt3) OR
                COUNT(DISTINCT opt4) < COUNT(opt4) OR
                COUNT(DISTINCT answer) < COUNT(answer) OR
                COUNT(DISTINCT CONCAT(id, name)) < COUNT(DISTINCT CONCAT(id, name)) OR
                COUNT(DISTINCT CONCAT(name, opt1)) < COUNT(DISTINCT CONCAT(name, opt1))
            FROM cieportal.FLATQuestion
        );
    ELSEIF table_name = 'OSSPQuestion' THEN
        SET has_transitive_dependencies = (
            SELECT
                COUNT(DISTINCT id) < COUNT(id) OR
                COUNT(DISTINCT name) < COUNT(name) OR
                COUNT(DISTINCT opt1) < COUNT(opt1) OR
                COUNT(DISTINCT opt2) < COUNT(opt2) OR
                COUNT(DISTINCT opt3) < COUNT(opt3) OR
                COUNT(DISTINCT opt4) < COUNT(opt4) OR
                COUNT(DISTINCT answer) < COUNT(answer) OR
                COUNT(DISTINCT CONCAT(id, name)) < COUNT(DISTINCT CONCAT(id, name)) OR
                COUNT(DISTINCT CONCAT(name, opt1)) < COUNT(DISTINCT CONCAT(name, opt1))
            FROM cieportal.OSSPQuestion
        );
    -- Add more conditions for other tables as needed
    END IF;

    -- Signal an exception if transitive dependencies are detected
    IF has_transitive_dependencies THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = ' does not meet 3NF criteria';
    END IF;
END //
DELIMITER ;

CALL Check3NF('flatquestion');





create table IOTQuestion(
   id varchar(10),
   name varchar(500) PRIMARY KEY,
   opt1 varchar(500),
   opt2 varchar(500), 
   opt3 varchar(500),
   opt4 varchar(500),
   answer varchar(500)
);
create table AllQuestion(
   id varchar(10),
   name varchar(500) PRIMARY KEY,
   opt1 varchar(500),
   opt2 varchar(500), 
   opt3 varchar(500),
   opt4 varchar(500),
   answer varchar(500)
);

select * from aiquestion;
select * from dbmsquestion;
select * from osspquestion;
select * from flatquestion;
select * from iotquestion;
select * from allquestion;


-- Create a stored procedure
DELIMITER //

CREATE PROCEDURE InsertAllQuestions()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE tableName VARCHAR(50);
    DECLARE cur CURSOR FOR
    
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'cieportal' AND table_name LIKE '%Question';   -- pattern matching 

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO tableName;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Dynamic SQL to insert into AllQuestions table
        SET @sql = CONCAT('INSERT INTO AllQuestion SELECT * FROM ', tableName);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END LOOP;

    CLOSE cur;
END //
DELIMITER ;

CALL InsertAllQuestions();

/* CREATE TABLE AllQuestion AS

SELECT id, name, opt1, opt2, opt3, opt4, answer
FROM AIQuestion
UNION
SELECT id, name, opt1, opt2, opt3, opt4, answer
FROM DBMSQuestion
UNION
SELECT id, name, opt1, opt2, opt3, opt4, answer
FROM OSSPQuestion
UNION
SELECT id, name, opt1, opt2, opt3, opt4, answer
FROM FLATQuestion
UNION
SELECT id, name, opt1, opt2, opt3, opt4, answer
FROM IOTQuestion;
*/

create table student(
  prnno varchar(15) PRIMARY KEY,
  name varchar(100),
  mname varchar(100),
  surname varchar(100),
  rollno varchar(15),
  gender varchar(50),
  email varchar(100),
  mobileno varchar(15),
  address varchar(500),
  marks int
);

-- Create a trigger to handle deletion from AllQuestions
DELIMITER //

CREATE TRIGGER DeleteFromBaseTables
AFTER DELETE ON AllQuestion
FOR EACH ROW
BEGIN
    DELETE FROM AIQuestion WHERE name = OLD.name;
    DELETE FROM DBMSQuestion WHERE name = OLD.name;
    DELETE FROM OSSPQuestion WHERE name = OLD.name;
    DELETE FROM FLATQuestion WHERE name = OLD.name;
    DELETE FROM IOTQuestion WHERE name = OLD.name;
END;
//
DELIMITER ;
drop trigger DeleteFromBaseTables;



/*-- Create a trigger to handle deletion from AllQuestions
DELIMITER //
CREATE TRIGGER DeleteFromBaseTables
AFTER DELETE ON AllQuestions
FOR EACH ROW
BEGIN
    DECLARE base_table_name VARCHAR(50);

    SET base_table_name = SUBSTRING(OLD.name, 1, LENGTH(OLD.name) - LENGTH('Question'));

    SET @sql = CONCAT('DELETE FROM ', base_table_name, ' WHERE id = ?');
    SET @id = OLD.id;
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @id;
    DEALLOCATE PREPARE stmt;
END;
//
DELIMITER ;
*/
-- Create a trigger to handle updates in AllQuestions
DELIMITER //
CREATE TRIGGER UpdateBaseTables
AFTER UPDATE ON AllQuestion
FOR EACH ROW
BEGIN
    UPDATE AIQuestion SET
        name = NEW.name,
        opt1 = NEW.opt1,
        opt2 = NEW.opt2,
        opt3 = NEW.opt3,
        opt4 = NEW.opt4,
        answer = NEW.answer
    WHERE id = OLD.id;

    UPDATE DBMSQuestion SET
        name = NEW.name,
        opt1 = NEW.opt1,
        opt2 = NEW.opt2,
        opt3 = NEW.opt3,
        opt4 = NEW.opt4,
        answer = NEW.answer
    WHERE id = OLD.id;

    UPDATE OSSPQuestion SET
        name = NEW.name,
        opt1 = NEW.opt1,
        opt2 = NEW.opt2,
        opt3 = NEW.opt3,
        opt4 = NEW.opt4,
        answer = NEW.answer
    WHERE id = OLD.id;

    UPDATE FLATQuestion SET
        name = NEW.name,
        opt1 = NEW.opt1,
        opt2 = NEW.opt2,
        opt3 = NEW.opt3,
        opt4 = NEW.opt4,
        answer = NEW.answer
    WHERE id = OLD.id;

    UPDATE IOTQuestion SET
        name = NEW.name,
        opt1 = NEW.opt1,
        opt2 = NEW.opt2,
        opt3 = NEW.opt3,
        opt4 = NEW.opt4,
        answer = NEW.answer
    WHERE id = OLD.id;
END;
//
DELIMITER ;
