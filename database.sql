create database refugees;
use  refugees;

CREATE TABLE countries (
id_country numeric(10) PRIMARY KEY,
country_name VARCHAR(10) not null,
nationality VARCHAR(25)not null
);

insert into countries values (07, 'Brazil', 'brazilian');

CREATE TABLE states (
id_states numeric(10) PRIMARY KEY,
state_name VARCHAR(10) not null,
id_country numeric(10) not null,
FOREIGN KEY(id_country) REFERENCES countries (id_country)
);

insert into states values (01, 'São Paulo', 07);


CREATE TABLE origin_adresses (
zip_code numeric(11) PRIMARY KEY,
origin_city VARCHAR(10) not null,
id_states numeric(10) not null,
FOREIGN KEY(id_states) REFERENCES states (id_states)

);

insert into origin_adresses values (17019520, 'Bauru', 01);
insert into origin_adresses values (17019527, 'Rio Preto', 01);

CREATE TABLE ong (
id_ong numeric(10) PRIMARY KEY,
ong_name VARCHAR(10) not null,
ong_phone VARCHAR(11) not null,
ong_email VARCHAR(50)not null,
id_states numeric(10) not null,
FOREIGN KEY(id_states) REFERENCES states (id_states)
);

insert into ong values (0100, 'Bem-vindx', '14997852145', 'example@example.com', 01);

CREATE TABLE destination_addresses (
zip_code numeric(11) PRIMARY KEY,
destination_city VARCHAR(30) not null,
id_ong numeric(10) not null,
FOREIGN KEY(id_ong) REFERENCES ong (id_ong)

);

insert into destination_addresses values (17019527, 'Rio Preto', 0100);


CREATE TABLE visas (
id_visas NUMERIC(3) primary key,
visa_validity_date DATETIME not null,
visa_type VARCHAR(1)not null
);


insert into visas values (004, '2025-04-21', 'E');


CREATE TABLE passport (
id_passport NUMERIC(3) primary key,
password_validity_date DATETIME not null

);

insert into passport values (003, '2024-04-21');

CREATE TABLE refugees (
personal_id NUMERIC(11) primary key,
complete_name VARCHAR(255) not null,
date_register DATETIME not null,
origin_zip_code numeric(11) not null,
nationality_country numeric(10) not null,
gender VARCHAR(1) not null,
FOREIGN KEY(origin_zip_code) REFERENCES origin_adresses (zip_code),
FOREIGN KEY(nationality_country) REFERENCES countries (id_country)
);

CREATE TABLE brazilian_refugees (
    personal_id numeric(12) primary key,
    complete_name varchar(255) not null
);


CREATE TABLE voucher (
    id_voucher numeric(5) primary key,
    voucher_issuance datetime not null,
    voucher_validity datetime not null,
    personal_id numeric(12) not null,
    FOREIGN KEY(personal_id) REFERENCES brazilian_refugees (personal_id)
);

insert into  refugees values (45571779800, 'Brenda Silva', '2022-02-25', '17019520',  07, 'f');


drop TRIGGER tgr_add_brazilian_refugees;

	DELIMITER $
		CREATE TRIGGER tgr_add_brazilian_refugees after INSERT
		ON refugees	FOR EACH ROW
		BEGIN
        IF NEW.nationality_country = 07 then
			call proc_add_brazilian_refugees (new.personal_id, new.complete_name);
		end if;
		END$
	DELIMITER ;


CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_add_brazilian_refugees`(in p_cpf numeric(12), in p_br_name varchar(120))
BEGIN
                declare mensagem varchar(40);
                declare exit handler for 1062
                BEGIN
                    /*
                    set mensagem = "CPF already exist";
                    select mensagem; */
                    end;
                INSERT INTO brazilian_refugees values (p_cpf,p_br_name);
               /* set mensagem = "Brazillian refugee requistered";
                    select mensagem; */
                            
                end