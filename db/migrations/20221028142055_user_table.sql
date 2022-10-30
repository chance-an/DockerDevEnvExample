-- migrate:up
SET FOREIGN_KEY_CHECKS = 0;
CREATE TABLE users
(
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Primary key',
    skey VARCHAR(255) UNIQUE KEY COMMENT 'Surrogate key',
    wechat_user_id VARCHAR(255) UNIQUE KEY COMMENT 'The primary key from WeChat side to identify an user',
    user_name VARCHAR(255) NOT NULL COMMENT 'User display name',
    phone VARCHAR(255) COMMENT 'User''s telephone or mobile phone number',
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Created time',
    modified TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Modified time'
);
SET FOREIGN_KEY_CHECKS = 1;

-- migrate:down
DROP TABLE users;
