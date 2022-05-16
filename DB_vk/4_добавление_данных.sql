/*
Тема для курсового проекта: база данных хостинга
Она будет содержать данные о пользователях, тикеты, данные о виртуальных серверах и пр. 
Если получится сделать кластерную БД, то в итоге вижу проект так: 
Есть 3 сервера, на каждом из них запущена БД с данными о пользователях, серверах и тд. 
Если один из серверов отключается, то другие 2 работают. 
Как только 3-й включается, он должен восстановить БД и кластер должен работать как надо.
*/

USE vk;

-- 1. Заполнение таблиц

INSERT INTO users (first_name, last_name, email, phone)
VALUES ('Igor', 'Petrov', 'igor@mail.com', '89213549560'),
('Oksana', 'Petrova', 'oksana@mail.com', '89213549561'),
('Katya', 'Olina', 'olina@mail.com', '89213845630'),
('Kirill', 'Saveliev', 'kirill@mail.com', '89237509630'),
('Masha', 'Masha', 'masha@mail.com', '89639645015'),
('Natasha', 'Kireeva', 'natasha@mail.com', '89132649614'),
('Misha', 'Medvedev', 'misha@mail.com', '89018356107'),
('Ksusha', 'Karlova', 'ksusha@mail.com', '89018466107');

ALTER TABLE friend_requests ADD CONSTRAINT CHECK(from_user_id != to_user_id); -- добавляем ограничение, что номер телефона должен состоять из 11 символов и только из цифр

SELECT * FROM users; -- данные добавлены

/* 
2. Написать скрипт, возвращающий список имен (только firstname) пользователей 
без повторений в алфавитном порядке
*/

SELECT first_name FROM users ORDER BY first_name ASC;

INSERT INTO profiles (user_id, gender, birthday, photo_id, city, country)
VALUES (3, 'x', '1999-04-03', NULL, 'Saratov', 'Russia'),
(4, 'x', '2009-01-08', NULL, 'Moskva', 'Russia'),
(5, 'm', '1998-12-12', NULL, 'Chelyabinsk', 'Russia'),
(6, 'f', '1973-04-05', NULL, 'Tver', 'Russia'),
(7, 'f', '2001-09-07', NULL, 'Moskva', 'Russia'),
(8, 'm', '1993-08-03', NULL, 'Kaliningrad', 'Russia'),
(9, 'f', '1989-12-10', NULL, 'N Tagil', 'Russia'),
(10, 'f', '1981-01-12', NULL, 'Moskva', 'Russia');

-- делаем id photo пользователей уникальми
ALTER TABLE profiles MODIFY COLUMN photo_id BIGINT UNSIGNED DEFAULT NULL UNIQUE;

SELECT * FROM profiles;

/*
3. Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных 
(поле is_active = false). Предварительно добавить такое поле в таблицу profiles со 
значением по умолчанию = true (или 1)
*/
ALTER TABLE profiles DROP COLUMN is_active;
ALTER TABLE profiles ADD COLUMN is_active BOOLEAN DEFAULT FALSE;

SELECT is_active FROM profiles;

UPDATE profiles
SET is_active = TRUE
WHERE YEAR(CURRENT_DATE) - YEAR(birthday) - RIGHT(CURRENT_DATE, 5) < RIGHT(birthday, 5) < 18; -- ошибка 1175, не понимаю почему

INSERT INTO messages (id, from_user_id, to_user_id, txt, is_delivered, created_at, updated_at)
VALUES (DEFAULT, 1, 2, 'Hi!', 1, DEFAULT, DEFAULT), 
(DEFAULT, 3, 5, 'Hi!', 1, DEFAULT, DEFAULT), 
(DEFAULT, 8, 9, 'Hi!', 1, DEFAULT, DEFAULT), 
(DEFAULT, 2, 9, 'Hi!', 1, DEFAULT, DEFAULT), 
(DEFAULT, 3, 1, 'Hi!', 1, DEFAULT, DEFAULT), 
(DEFAULT, 5, 3, 'Hi!', 1, DEFAULT, DEFAULT), 
(DEFAULT, 9, 8, 'Hi!', 1, DEFAULT, DEFAULT), 
(DEFAULT, 9, 2, 'Hi!', 1, DEFAULT, DEFAULT), 
(DEFAULT, 1, 3, 'Why do we speak english?', 1, DEFAULT, DEFAULT), 
(DEFAULT, 1, 2, '-___-', 1, DEFAULT, DEFAULT);

/*
4. Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней)
*/

UPDATE messages
SET created_at='2022-12-24 01:00:00'
WHERE id = 8;

DELETE FROM messages WHERE created_at > NOW(); -- 

SELECT * FROM messages;

INSERT INTO friend_requests (from_user_id, to_user_id, accepted)
VALUES (5, 2, 1),
(3, 4, 1),
(5, 6, 1),
(7, 8, 1),
(9, 10, 1),
(10, 2, 1),
(9, 2, 1),
(8, 2, 1),
(7, 2, 1);

SELECT * FROM friend_requests;

INSERT INTO communities (id, name, description, admin_id)
VALUES (DEFAULT, 'Number3', 'I am number 3', 1),
(DEFAULT, 'Number4', 'I am number 4', 1),
(DEFAULT, 'Number5', 'I am number 5', 1),
(DEFAULT, 'Number6', 'I am number 6', 1),
(DEFAULT, 'Number7', 'I am number 7', 1),
(DEFAULT, 'Number8', 'I am number 8', 1),
(DEFAULT, 'Number9', 'I am number 9', 1),
(DEFAULT, 'Number10', 'I am number 10', 1);

SELECT * FROM communities;

INSERT INTO communities_users (community_id, user_id, created_at)
VALUES (1, 3, DEFAULT),
(1, 4, DEFAULT),
(2, 8, DEFAULT),
(8, 9, DEFAULT),
(1, 10, DEFAULT),
(1, 5, DEFAULT),
(1, 6, DEFAULT),
(1,7, DEFAULT),
(4, 2, DEFAULT);

SELECT * FROM communities_users;

INSERT INTO media_types (id, name)
VALUES (DEFAULT, 'GIF'),
(DEFAULT, 'видео');

SELECT * FROM media_types;

INSERT INTO media (id, user_id, media_types_id, file_name, file_size, created_at)
VALUES (DEFAULT, 2, 8, '1.mp4', 100, DEFAULT),
(DEFAULT, 3, 2, '1.mp3', 100, DEFAULT),
(DEFAULT, 4, 1, '4.jpg', 100, DEFAULT),
(DEFAULT, 5, 1, 'imhh.jpg', 100, DEFAULT),
(DEFAULT, 6, 1, 'fbhb.jpg', 100, DEFAULT),
(DEFAULT, 7, 1, 'nnf.jpg', 100, DEFAULT),
(DEFAULT, 8, 1, 'imjg.jpg', 100, DEFAULT);

-- делаем foreign key на media
ALTER TABLE profiles ADD CONSTRAINT FOREIGN KEY(photo_id) REFERENCES media(id);

SELECT * FROM media;

INSERT INTO posts (id, user_id, txt, created_at, updated_at)
VALUES (DEFAULT, 1, 'post1', DEFAULT, DEFAULT),
(DEFAULT, 2, 'post2', DEFAULT, DEFAULT),
(DEFAULT, 3, 'post3', DEFAULT, DEFAULT),
(DEFAULT, 4, 'post4', DEFAULT, DEFAULT),
(DEFAULT, 5, 'post5', DEFAULT, DEFAULT),
(DEFAULT, 6, 'post6', DEFAULT, DEFAULT),
(DEFAULT, 7, 'post7', DEFAULT, DEFAULT),
(DEFAULT, 8, 'post8', DEFAULT, DEFAULT),
(DEFAULT, 9, 'post9', DEFAULT, DEFAULT),
(DEFAULT, 10, 'post10', DEFAULT, DEFAULT);

SELECT * FROM posts;

INSERT INTO likes_on_posts (post_id, user_id)
VALUES (1, 2),
(1, 3),
(1, 4),
(1, 5),
(8, 2),
(9, 2),
(10, 2),
(2, 5),
(2, 7),
(2, 8);

SELECT * FROM likes_on_posts;

INSERT INTO comments_on_posts (post_id, user_id, txt, created_at, updated_at)
VALUE (1, 1, 'Comment 1', DEFAULT, DEFAULT),
(1, 2, 'Comment 2', DEFAULT, DEFAULT),
(6, 1, 'Comment 3', DEFAULT, DEFAULT),
(9, 4, 'Comment 4', DEFAULT, DEFAULT),
(10, 5, 'Comment 5', DEFAULT, DEFAULT),
(4, 6, 'Comment 6', DEFAULT, DEFAULT),
(4, 10, 'Comment 7', DEFAULT, DEFAULT),
(5, 7, 'Comment 8', DEFAULT, DEFAULT),
(3, 2, 'Comment 9', DEFAULT, DEFAULT),
(6, 4, 'Comment 10', DEFAULT, DEFAULT);

SELECT * FROM comments_on_posts;
