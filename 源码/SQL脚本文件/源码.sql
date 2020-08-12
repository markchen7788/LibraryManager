CREATE TABLE reader (
	reader_id INT ( 10 ) PRIMARY KEY CHECK(reader_id LIKE '____%'),/*读者号必须大于4位*/
	pwd VARCHAR ( 20 ) CHECK(pwd LIKE '____%')NOT NULL,/*密码必须大于4位*/
	reader_name VARCHAR ( 10 ) NOT NULL,
	reader_sex VARCHAR ( 2 ) NOT NULL CHECK (
	reader_sex IN ( "男", "女" )),/*性别男或女*/
	reader_tel VARCHAR ( 11 ) CHECK(reader_tel LIKE '___________')/*电话必须11位*/
);
CREATE TABLE book (
	book_id INT ( 10 ) PRIMARY KEY CHECK(book_id LIKE '____%'),/*书号必须大于4位*/
	book_name VARCHAR ( 50 ) NOT NULL,
	author VARCHAR ( 50 ) NOT NULL,
	publisher VARCHAR ( 50 ) NOT NULL,
	state VARCHAR ( 10 ) CHECK (
	state IN ( '在库', '不在库' )) NOT NULL,/*书记状态只有在库与不在库*/
	other_info VARCHAR ( 30 ) 
);
CREATE TABLE admin (
	admin_id INT ( 10 ) PRIMARY KEY CHECK(admin_id LIKE '____%'),/*w完整性约束同读者*/
	pwd VARCHAR ( 20 ) CHECK(pwd LIKE '____%') NOT NULL,
	admin_name VARCHAR ( 10 ) NOT NULL,
	admin_sex VARCHAR ( 2 ) CHECK (
	admin_sex IN ( '男', '女' )),
	admin_tel VARCHAR ( 11 ) CHECK(admin_tel LIKE '___________')
);
CREATE TABLE borrow_record (/*借阅记录*/
	borrow_record_id INT ( 10 ) PRIMARY KEY,
	book_id INT ( 10 ) NOT NULL,
	reader_id INT ( 10 ) NOT NULL,
	start_date TIMESTAMP NOT NULL,
	end_date TIMESTAMP,/*end_date可以空值，空值代表未归还*/
	FOREIGN KEY ( book_id ) REFERENCES book ( book_id ) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY ( reader_id ) REFERENCES reader ( reader_id ) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE punish_record (/*处罚记录*/
	punish_record_id INT ( 10 ) PRIMARY KEY,
	borrow_record_id INT ( 10 ) UNIQUE NOT NULL,
	extra_days INT ( 10 ),/*可以空值，空值代表尚未缴纳罚款*/
	FOREIGN KEY ( borrow_record_id ) REFERENCES borrow_record ( borrow_record_id ) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE DEFINER=`root`@`localhost` PROCEDURE `borrow`(readerid INT,bookid INT)/*借书过程*/
BEGIN
DECLARE _state VARCHAR(10);
DECLARE num INT;
SELECT COUNT(*) INTO num FROM borrow_record;
SET num=num+1;
SELECT state INTO _state FROM book WHERE book_id=bookid;
IF(_state="在库")
THEN
 UPDATE book SET state="不在库"  WHERE book_id=bookid;
 INSERT INTO borrow_record(borrow_record_id,reader_id,book_id,start_date) VALUES(num,readerid,bookid,CURRENT_TIMESTAMP());
 END IF;
END

CREATE DEFINER=`root`@`localhost` PROCEDURE `return_book`(readerid INT, bookid INT)/*还书过程*/
BEGIN
/*输入id和书的id还书*/
	DECLARE
		_state VARCHAR ( 10 );
	DECLARE
		num INT;
	SELECT
		COUNT(*) INTO num 
	FROM
		borrow_record;
	
	SET num = num + 1;
	SELECT
		state INTO _state 
	FROM
		book 
	WHERE
		book_id = bookid;
	IF
		( _state = "不在库" ) THEN
			UPDATE book 
			SET state = "在库" 
		WHERE
			book_id = bookid;
		UPDATE borrow_record 
		SET end_date = CURRENT_TIMESTAMP() 
		WHERE
			readerid = reader_id 
			AND bookid = book_id 
			AND end_date IS NULL;
		
	END IF;
END

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_punish`(max_keeping_days INT)/*更新处罚记录过程*/
BEGIN
/*输入最大借阅天数，更新*/
	DECLARE
		_borrow_record_id INT;
	DECLARE
		startdate DATE;
	DECLARE
		enddate DATE;
	DECLARE
		num INT;
	DECLARE
		done INT DEFAULT 0;
	DECLARE
		num1 INT;
	DECLARE
		cur CURSOR FOR SELECT
		borrow_record_id,
		start_date,
		end_date 
	FROM
		borrow_record;
	DECLARE
		CONTINUE HANDLER FOR NOT found 
		SET done = 1;
/*指定游标循环结束时的返回值 */
	OPEN cur;
	label :/*遍历借阅记录*/
	LOOP
			FETCH cur INTO _borrow_record_id,
			startdate,
			enddate;
		SELECT
			COUNT(*) INTO num 
		FROM
			punish_record;
		SELECT
			COUNT(*) INTO num1 
		FROM
			punish_record 
		WHERE
			borrow_record_id = _borrow_record_id;/*判断该条记录是否已经加入违规记录*/
		
		SET num = num + 1;
		IF
			( num1=0&&enddate IS NULL && DATEDIFF( CURRENT_DATE (), startdate )> max_keeping_days ) THEN/*如果该条记录超过最大借阅期且未被收录*/
				INSERT INTO punish_record ( punish_record_id, borrow_record_id )
			VALUES
				( num, _borrow_record_id );
			
		END IF;
		IF
			done = 1 THEN
				LEAVE label;
			
		END IF;
		
	END LOOP label;
	CLOSE cur;
	
END
/*定时事务*/
CREATE EVENT punish
ON SCHEDULE EVERY 1 MINUTE/*正常情况应是每天定时更新一次违规记录，为了方便演示一分钟更新一次*/
DO call update_punish(10);
DROP EVENT punish;

CREATE DEFINER=`root`@`localhost` PROCEDURE `recover_rights`( id INT )/*恢复借阅权利过程*/
BEGIN
	DECLARE
		bookid INT;
	DECLARE
		readerid INT;
	DECLARE
		startdate DATE;
	SELECT
		book_id INTO bookid 
	FROM
		punish_record,
		borrow_record 
	WHERE
		punish_record.borrow_record_id = borrow_record.borrow_record_id 
		AND punish_record.punish_record_id = id;
	SELECT
		start_date INTO startdate 
	FROM
		punish_record,
		borrow_record 
	WHERE
		punish_record.borrow_record_id = borrow_record.borrow_record_id 
		AND punish_record.punish_record_id = id;
	SELECT
		reader_id INTO readerid 
	FROM
		punish_record,
		borrow_record 
	WHERE
		punish_record.borrow_record_id = borrow_record.borrow_record_id 
		AND punish_record.punish_record_id = id;
	UPDATE punish_record
	SET extra_days = DATEDIFF( CURRENT_DATE (), startdate ) /*计算超期天数*/
	WHERE
		punish_record_id =id;
	call return_book( readerid, bookid );/*调用还书过程*/
END
