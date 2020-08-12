/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80019
 Source Host           : localhost:3306
 Source Schema         : library

 Target Server Type    : MySQL
 Target Server Version : 80019
 File Encoding         : 65001

 Date: 25/06/2020 17:24:21
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `admin_id` int(0) NOT NULL,
  `pwd` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `admin_name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `admin_sex` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `admin_tel` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`admin_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1001, '1234', '陈勤', '男', '13572082079');

-- ----------------------------
-- Table structure for book
-- ----------------------------
DROP TABLE IF EXISTS `book`;
CREATE TABLE `book`  (
  `book_id` int(0) NOT NULL,
  `book_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `publisher` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `state` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `other_info` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`book_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of book
-- ----------------------------
INSERT INTO `book` VALUES (1001, '数据库系统概论', '王珊，萨师煊', '高等教育出版社', '不在库', '');
INSERT INTO `book` VALUES (1002, '格林童话', '安徒生', '商务印书馆', '不在库', '');
INSERT INTO `book` VALUES (1003, '软件详细设计', '杜瑾，樊海伟', '西安电子科技大学出版社', '在库', '');
INSERT INTO `book` VALUES (1004, 'web应用开发技术:jsp', '崔尚森', '西安电子科技大学出版社', '在库', '');
INSERT INTO `book` VALUES (1005, '软件质量保证与测试', '李晓红', '清华大学出版社', '在库', '');
INSERT INTO `book` VALUES (1006, '网络化测控技术', '余立建', '西南交通大学出版社', '在库', '');
INSERT INTO `book` VALUES (1007, '格林童话', '安徒生', '商务印书馆', '不在库', '');
INSERT INTO `book` VALUES (1008, 'web应用开发技术：jsp', '崔尚森', '西安电子大学出版社', '不在库', '');
INSERT INTO `book` VALUES (1009, '数据库系统概论', '王珊，萨师煊', '高等教育出版社', '不在库', '独家');

-- ----------------------------
-- Table structure for borrow_record
-- ----------------------------
DROP TABLE IF EXISTS `borrow_record`;
CREATE TABLE `borrow_record`  (
  `borrow_record_id` int(0) NOT NULL,
  `book_id` int(0) NOT NULL,
  `reader_id` int(0) NOT NULL,
  `start_date` timestamp(0) NOT NULL,
  `end_date` timestamp(0) NULL DEFAULT NULL,
  PRIMARY KEY (`borrow_record_id`) USING BTREE,
  INDEX `book_id`(`book_id`) USING BTREE,
  INDEX `reader_id`(`reader_id`) USING BTREE,
  CONSTRAINT `borrow_record_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `borrow_record_ibfk_2` FOREIGN KEY (`reader_id`) REFERENCES `reader` (`reader_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of borrow_record
-- ----------------------------
INSERT INTO `borrow_record` VALUES (1, 1002, 1002, '2020-06-24 23:51:41', '2020-06-24 23:52:00');
INSERT INTO `borrow_record` VALUES (2, 1009, 1002, '2020-06-24 23:51:45', '2020-06-24 23:52:02');
INSERT INTO `borrow_record` VALUES (3, 1001, 1002, '2020-06-09 23:52:13', '2020-06-24 23:55:08');
INSERT INTO `borrow_record` VALUES (4, 1002, 1002, '2020-06-24 23:52:15', '2020-06-24 23:55:29');
INSERT INTO `borrow_record` VALUES (5, 1003, 1002, '2020-06-24 23:52:18', '2020-06-24 23:55:31');
INSERT INTO `borrow_record` VALUES (6, 1001, 1001, '2020-06-25 09:49:34', '2020-06-25 09:49:41');
INSERT INTO `borrow_record` VALUES (7, 1002, 1001, '2020-06-25 09:49:37', NULL);
INSERT INTO `borrow_record` VALUES (8, 1001, 1001, '2020-06-01 12:18:03', NULL);
INSERT INTO `borrow_record` VALUES (9, 1009, 1002, '2020-06-25 12:59:10', NULL);
INSERT INTO `borrow_record` VALUES (10, 1008, 1002, '2020-06-25 12:59:12', NULL);
INSERT INTO `borrow_record` VALUES (11, 1007, 1002, '2020-06-25 12:59:14', NULL);

-- ----------------------------
-- Table structure for punish_record
-- ----------------------------
DROP TABLE IF EXISTS `punish_record`;
CREATE TABLE `punish_record`  (
  `punish_record_id` int(0) NOT NULL,
  `borrow_record_id` int(0) NOT NULL,
  `extra_days` int(0) NULL DEFAULT NULL,
  PRIMARY KEY (`punish_record_id`) USING BTREE,
  UNIQUE INDEX `borrow_record_id`(`borrow_record_id`) USING BTREE,
  CONSTRAINT `punish_record_ibfk_1` FOREIGN KEY (`borrow_record_id`) REFERENCES `borrow_record` (`borrow_record_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of punish_record
-- ----------------------------
INSERT INTO `punish_record` VALUES (1, 3, 15);
INSERT INTO `punish_record` VALUES (2, 8, NULL);

-- ----------------------------
-- Table structure for reader
-- ----------------------------
DROP TABLE IF EXISTS `reader`;
CREATE TABLE `reader`  (
  `reader_id` int(0) NOT NULL,
  `pwd` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `reader_name` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `reader_sex` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `reader_tel` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `blacklist` int(0) NULL DEFAULT NULL,
  PRIMARY KEY (`reader_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of reader
-- ----------------------------
INSERT INTO `reader` VALUES (1001, '1234', '张三', '男', '13552082099', 0);
INSERT INTO `reader` VALUES (1002, '1234', '李四', '男', '12345678901', 0);

-- ----------------------------
-- Procedure structure for borrow
-- ----------------------------
DROP PROCEDURE IF EXISTS `borrow`;
delimiter ;;
CREATE PROCEDURE `borrow`(readerid INT,bookid INT)
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
;;
delimiter ;

-- ----------------------------
-- Procedure structure for recover_rights
-- ----------------------------
DROP PROCEDURE IF EXISTS `recover_rights`;
delimiter ;;
CREATE PROCEDURE `recover_rights`(id INT)
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
	SET extra_days = DATEDIFF( CURRENT_DATE (), startdate ) 
	WHERE
		punish_record_id =id;
	call return_book( readerid, bookid );
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for return_book
-- ----------------------------
DROP PROCEDURE IF EXISTS `return_book`;
delimiter ;;
CREATE PROCEDURE `return_book`(readerid INT, bookid INT)
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
;;
delimiter ;

-- ----------------------------
-- Procedure structure for update_punish
-- ----------------------------
DROP PROCEDURE IF EXISTS `update_punish`;
delimiter ;;
CREATE PROCEDURE `update_punish`(max_keeping_days INT)
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
	label :
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
			borrow_record_id = _borrow_record_id;
		
		SET num = num + 1;
		IF
			( num1=0&&enddate IS NULL && DATEDIFF( CURRENT_DATE (), startdate )> max_keeping_days ) THEN
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
;;
delimiter ;

-- ----------------------------
-- Event structure for punish
-- ----------------------------
DROP EVENT IF EXISTS `punish`;
delimiter ;;
CREATE EVENT `punish`
ON SCHEDULE
EVERY '1' MINUTE STARTS '2020-06-24 14:36:01'
DO call update_punish('10')
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
