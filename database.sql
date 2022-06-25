drop database refugees;
create database refugees;
use  refugees;

CREATE TABLE countries (
id_country int(10) PRIMARY KEY AUTO_INCREMENT,
country_name VARCHAR(10) not null,
nationality VARCHAR(25)not null
);
insert into countries  (country_name, nationality)values  ( 'Russia', 'Russian ');

CREATE TABLE states (
id_states int(10) PRIMARY KEY AUTO_INCREMENT,
state_name VARCHAR(10) not null,
id_country int(10) not null,
FOREIGN KEY(id_country) REFERENCES countries (id_country)
);

insert into states  (state_name, id_country) values  ( 'São Paulo', 1);


CREATE TABLE origin_adresses (
zip_code int(11) PRIMARY KEY,
origin_city VARCHAR(10) not null,
id_states int(10) not null,
FOREIGN KEY(id_states) REFERENCES states (id_states)

);

insert into origin_adresses values  (17019520, 'Bauru', 2);

CREATE TABLE ong (
id_ong int(10) PRIMARY KEY AUTO_INCREMENT,
ong_name VARCHAR(10) not null,
ong_phone VARCHAR(11) not null,
ong_email VARCHAR(50)not null,
id_states int(10) not null,
FOREIGN KEY(id_states) REFERENCES states (id_states)
);

insert into ong (ong_name, ong_phone, ong_email, id_states ) values  ( 'Bem-vindx', '14997852145', 'example@example.com', 2);

CREATE TABLE destination_addresses (
zip_code int(11) PRIMARY KEY,
destination_city VARCHAR(30) not null,
id_ong int(10) not null,
FOREIGN KEY(id_ong) REFERENCES ong (id_ong)
);

insert into destination_addresses  values  (17019527, 'Rio Preto', 2);


CREATE TABLE visas (
id_visas int(3) PRIMARY KEY AUTO_INCREMENT,
visa_validity_date DATETIME not null,
visa_type VARCHAR(1)not null
);


insert into visas ( visa_validity_date, visa_type) values  ( '2025-04-21', 'E');


CREATE TABLE passport (
id_passport int(3) PRIMARY KEY AUTO_INCREMENT,
password_validity_date DATETIME not null

);

insert into passport ( password_validity_date) values  ( '2024-04-21');

CREATE TABLE refugees (
personal_id numeric(12) PRIMARY KEY ,
complete_name VARCHAR(255) not null,
date_register DATETIME not null,
origin_zip_code int(11) not null,
nationality_country int(10) not null,
gender VARCHAR(1) not null,
FOREIGN KEY(origin_zip_code) REFERENCES origin_adresses (zip_code),
FOREIGN KEY(nationality_country) REFERENCES countries (id_country)
);

CREATE TABLE brazilian_refugees (
    personal_id numeric(12) PRIMARY KEY ,
    complete_name varchar(255) not null
);



CREATE TABLE voucher (
    id_voucher int(5) PRIMARY KEY AUTO_INCREMENT,
    voucher_issuance datetime not null,
    voucher_validity datetime not null,
    personal_id numeric(12) not null,
    FOREIGN KEY(personal_id) REFERENCES brazilian_refugees (personal_id)
);

insert into  refugees values  (45571779801, 'Brenda Silva', '2022-02-25', '17019520',  1, 'f');



DELIMITER $
		CREATE TRIGGER tgr_add_brazilian_refugees after INSERT
		ON refugees	FOR EACH ROW
		BEGIN
        IF NEW.nationality_country = 1 then
			call proc_add_brazilian_refugees (new.personal_id, new.complete_name);
		end if;
		END$
DELIMITER ;


CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_add_brazilian_refugees`(in p_personal_id numeric(12), in p_complete_name varchar(255))
BEGIN

   INSERT INTO brazilian_refugees values  (p_personal_id,p_complete_name);
               
                            
END