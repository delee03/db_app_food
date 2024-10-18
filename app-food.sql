--kiểm tra version
SELECT VERSION();

CREATE DATABASE db_app_food

use db_app_food

--auto increment tự động tăng đảm bảo cột khóa chính luôn luôn là khóa chính duy nhất , không trùng nhau,

create table users (
	user_id int PRIMARY KEY AUTO_INCREMENT,
	full_name VARCHAR(255),
	email VARCHAR(255),
	password VARCHAR(255)
	
)


create table restaurants (
	res_id int PRIMARY KEY AUTO_INCREMENT,
	res_name VARCHAR(255),
	image VARCHAR(255),
	description VARCHAR(255)
	
)


create table likes (
	user_id int,
	res_id int,
	data_like VARCHAR,
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	FOREIGN KEY (res_id) REFERENCES restaurants(res_id)
	
)

create table rate_res (
	user_id int,
	res_id int,
	amount int,
	date_rate datetime,
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	FOREIGN KEY (res_id) REFERENCES restaurants(res_id)
)


--thêm dữ liệu 
INSERT INTO users ( full_name, email, password) VALUES
( "Nguyễn văn b", "test@gmail.com", "1234"),
( "Nguyễn văn c", "test@gmail.com", "1234"),
( "Nguyễn văn d", "test@gmail.com", "1234"),
( "Nguyễn văn e", "test@gmail.com", "1234"),
( "Nguyễn văn h", "test@gmail.com", "1234"),
( "Nguyễn văn f", "test@gmail.com", "1234");

-- --truy vấn 
-- SELECT * FROM users where user_id LIKE 2

select PASSWORD as "mật khẩu", email, full_name as "họ và tên" from users

--limit 
SELECT  *  from users limit 2

--Bài tập nhỏ 
--tạo table có tên là: foods
--field: foods_id là kiểu số, khóa chính, tự động tăng,
--field: foods_name là kiểu chữ,
--field: description là kiểu chữ
	
	CREATE TABLE foods (
		id int PRIMARY KEY AUTO_INCREMENT,
		food_names varchar(230),
		description TEXT,
		states BOOLEAN
	)
	
INSERT INTO foods (food_names, description, states) VALUES
( "Món mì xào", "ngon dữ thần", true),
( "Món mì ý", "ngon dữ thần", true),
( "Món phở", "ngon dữ thần", false),
( "Món lẩu tứ xuyên", "ngon dữ thần", false);
	
create TABLE orders (
	order_id int PRIMARY KEY auto_increment,
	user_id int ,
	food_id int,
	 foreign key (user_id) REFERENCES users(user_id),
		foreign key (food_id) REFERENCES foods(id)
)

insert into orders (order_id, user_id, food_id) values 
(1, 1, 1),
(2,2,1),
(3,3, 2),
(4, 4, 3),
(5, 5, 1),
(6, 1, 3),
(7, 4, 2),
(8, 1, 2),
(9, 1, 3),
(10, 2, 3)

TRUNCATE TABLE orders

--1 - 1(one to one)
--mô tả: mỗi bản ghi trong bảng A sẽ chỉ liên kết tới 1 bảng ghi trong bảng b


-- 1 - N (one to many)
select * from users
inner join orders on users.user_id = orders.user_id
-- inner join foods on foods.id = orders.food_id



--trường hợp 2 bảng có số lượng hàng bằng nhau 
--lấy from để làm chuẩn đi so sánh



--trường hợp 2 bảng có số lượng hàng khác nhau
--lấy bảng có ít hàng hơn làm chuẩn để đi so sánh

	
	
--left join 
--sẽ lấy tất cả các bản ghi bên trái , ngay cả khi không khớp với bản ghi bên phải
select * from users 
left join orders on orders.order_id = users.user_id

--right join
--sẽ lấy tất cả các bản ghi bên phải 
select * from users 
right join orders on orders.order_id = users.user_id

--cross join 
select * 
from orders 
cross join users

--group by
select * 
from orders 
inner join users on users.user_id = orders.user_id
group by users.user_id -- nếu chỉ có user_id cũng sẽ gây ra lỗi
--này sẽ gây ra lỗi : Column 'user_id' in group statement is ambigous vì groupby là nhóm theo cột 
--user_id mà lại có 2 cột user_id nên group by ko biết chọn cột nào


--group by
select users.user_id , users.full_name, users.password, users.email --giải pháp cho việc trùng các cột cùng user_id nhưng lại khác các value khác
from users 
inner join orders on users.user_id = orders.user_id
group by users.user_id


--GROUP BY() -> dùng để thống kê , -> COUNT(); Max()
select users.user_id , users.full_name, users.password, users.email, COUNT(users.user_id) as "SỐ LƯỢNG"
from users 
inner join orders on orders.user_id = users.user_id
group by users.user_id

--ORDER BY() 
select users.user_id , users.full_name, users.password, users.email, COUNT(users.user_id) as "SỐ LƯỢNG"
from users 
inner join orders on orders.user_id = users.user_id
group by users.user_id
order by users.user_id desc

--TÌm 5 người đã orders nhiều nhất 
--limit 5: giới hạn kết quả chỉ trả ra 5
--khi một người mua hàng thì sẽ xuất hiện bên trong orders
--Mình sẽ tìm người dùng xuất hiện nhiều nhất bên trong bảng orders
--sắp xếp giảm dần để cho số count lên trên đầu (ngừi dùng mua nhiều nhất)

SELECT orders.user_id, users.full_name, users.email, count(orders.user_id) as "so luong" from orders
 join users on users.user_id = orders.user_id
group by orders.user_id
order by `so luong` desc
limit 1

-- tìm 2 thức ăn có lượt mua nhiều nhất 
select orders.food_id, foods.id, foods.food_names, foods.description, foods.states, count(orders.food_id)
from orders
 join foods on orders.food_id = foods.id
group by orders.food_id
order by orders.food_id desc
limit 2

--tìm người không hoạt động trong hệ thông 
--không đặt hàng , không like .................

--Bước 1 lấy tất cả dữ liệu bên trong orders
--bước 2 lấy thêm cả dữ liệu của bảng users
SELECT users.user_id, users.full_name, users.email, users.password from orders
right join users on orders.user_id = users.user_id
where orders.user_id is null


INSERT INTO restaurants (res_name, image, description) VALUES
( "Nhà hàng 1", "ảnh 1.img", "abc"),
( "Nhà hàng 2", "ảnh 2.img", "abc"),
( "Nhà hàng 3", "ảnh 3.img", "abc"),
( "Nhà hàng 4", "ảnh 4.img", "abc")


INSERT INTO likes (user_id, res_id, data_like) VALUES
( 4, 3, "10/10/2024"),
( 5, 3, "10/10/2024"),
( 8, 3, "10/10/2024"),
( 9, 3, "10/10/2024")

INSERT INTO rate_res (user_id, res_id,amount, date_rate) VALUES
( 4, 3,4, "10/10/2024"),
( 5, 3, 5,"10/10/2024"),
( 8, 3,4, "10/10/2024"),
( 9, 3, 3, "10/10/2024")



--Tim người đặt hàng nhiều nhất :
SELECT orders.user_id, users.full_name, users.email, count(orders.user_id) as "so luong" from orders
 join users on users.user_id = orders.user_id
group by orders.user_id
order by `so luong` desc
limit 1


--tìm 5 người like nhà hàng nhiều nhất:

select users.user_id, likes.user_id, users.full_name, users.email , count(likes.user_id) as "so luong like" from users
join likes on users.user_id = likes.user_id
group by likes.user_id
order by `so luong like` desc
limit 5


--tìm 2 nhà hàng có lượt like nhiều nhất
select restaurants.res_id, likes.res_id, restaurants.res_name, restaurants.image, restaurants.description, count(likes.res_id) as "số lượng like" from restaurants
join likes on restaurants.res_id = likes.res_id
group by likes.res_id
order by `số lượng like` desc
limit 2


--tìm người dùng không hoạt động trong hệ thống không like , không đặt đồ ăn, không đánh giá nhà hàng
select users.user_id, users.full_name, users.email, users.`password` from users
left join likes on users.user_id = likes.user_id 

left join orders on orders.user_id = users.user_id
left join rate_res on rate_res.user_id = users.user_id


where likes.user_id is null and orders.user_id is null and rate_res.user_id is null


