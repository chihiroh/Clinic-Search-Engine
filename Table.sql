-- Database Table Creation
--
--		This file will create the tables for use with the book 
--  Database Management Systems by Quentin Au, Yukang Zhang, Jin Zhang, and Chihiro Hanawa
--  
--  First drop any existing tables. Any errors are ignored.
-- use project;
SET FOREIGN_KEY_CHECKS=0;
drop table if exists clientAddressPostal cascade;
drop table if exists clientInfo cascade;
drop table if exists disease cascade;
drop table if exists clinicAddressPostal cascade;
drop table if exists clinicInfo cascade;
drop table if exists clientGoestoClinic cascade;
drop table if exists clientNumName cascade;
drop table if exists clientHasRecordInfo cascade;
drop table if exists recordInfo cascade;
drop table if exists nurse cascade;
drop table if exists nurseCreatesRecord cascade;
drop table if exists clinicKeepsRecordInfo cascade;
drop table if exists doctor cascade;
drop table if exists worksIn cascade;
drop table if exists assists cascade;
drop table if exists writes cascade;
drop table if exists recordContent cascade;
drop table if exists recordContentKeepsDisease cascade;
drop table if exists walkinClinic cascade;
SET foreign_key_checks = 1;
--
-- Now, add each table.
--
CREATE table clientAddressPostal(
	client_address varchar(40) primary key,
	client_postal varchar(10)
);

CREATE table clientInfo(
	cc_num numeric(10,0) primary key,
	client_address varchar(40),
	client_name varchar(30),
	client_phone numeric(10,0),
    client_password numeric(6,0),
	birth_date date,
	doctor_ID numeric(6,0),
	times_rated numeric(5,0),
	client_rated numeric(5,0)
);

CREATE table disease(
	disease_name varchar(20) primary key,
	symptom varchar(80)
);

CREATE table clinicAddressPostal(
	clinic_address varchar(40) primary key,
	clinic_postal varchar(10)
);

CREATE table clinicInfo(
	clinic_ID numeric(5,0) primary key, 
    clinic_name varchar(20),
	clinic_address varchar(40),
	clinic_phone numeric(10,0),
	business_hour varchar(50)
);

CREATE table clientGoestoClinic(
	cc_num numeric(10,0),
	clinic_ID numeric(5,0),
	primary key(cc_num, clinic_ID),
	foreign key(cc_num) references clientInfo(cc_num),
	foreign key(clinic_ID) references clinicInfo(clinic_ID)
);

CREATE table clientNumName(
	cc_num numeric(10,0) primary key,
	client_name varchar(30),
	foreign key(cc_num) references clientInfo(cc_num)
);

CREATE table nurse(
	nurse_ID numeric(6,0) primary key,
	nurse_name varchar(20),
	nurse_degree varchar(20),
	nurse_gender varchar(10),
    nurse_password numeric(6,0)
);

CREATE table recordInfo(
	record_ID numeric(8,0) primary key,
	nurse_ID numeric(6,0),
	cc_num numeric(10),
    clinic_ID numeric(5,0),
	foreign key(cc_num) references clientInfo(cc_num),
    foreign key(clinic_ID) references clinicInfo(clinic_ID),
	foreign key(nurse_ID) references nurse(nurse_ID) ON DELETE SET NULL
);

CREATE table clientHasRecordInfo(
	record_ID numeric(8,0) primary key,
	nurse_ID numeric(6,0),
	cc_num numeric(10,0),
	foreign key(cc_num) references clientInfo(cc_num),
	foreign key(nurse_ID) references nurse(nurse_ID) ON DELETE SET NULL
);

CREATE table nurseCreatesRecord(
	record_ID numeric(8,0),
	nurse_ID numeric(6,0),
	created_date date,
	primary key(record_ID, nurse_ID),
	foreign key(nurse_ID) references nurse(nurse_ID) ON DELETE CASCADE,
	foreign key(record_ID) references recordInfo(record_ID)
); 

CREATE table clinicKeepsRecordInfo(
	record_ID numeric(8,0) primary key,
	nurse_ID numeric(6,0),
	cc_num numeric(10,0),
	clinic_ID numeric (5,0) ,
	foreign key(cc_num) references clientInfo(cc_num),
	foreign key(clinic_ID) references clinicInfo(clinic_ID),
	foreign key(nurse_ID) references nurse(nurse_ID) ON DELETE SET NULL
);

CREATE table walkinClinic(
	clinic_ID numeric(5,0) primary key,
	waiting_time varchar(20)
);

CREATE table doctor(
	doctor_ID numeric(6,0) primary key,
	doctor_name varchar(20),
	specialization varchar(20),
	doctor_degree varchar(20),
	doctor_gender varchar(10),
    doctor_password numeric(6,0),
	doctor_rating  decimal(6,0)
);

CREATE table worksIn(
	doctor_ID numeric(6,0),
	clinic_ID numeric (5,0),
	primary key(doctor_ID, clinic_ID),
	foreign key(clinic_ID) references clinicInfo(clinic_ID),
	foreign key(doctor_ID) references doctor(doctor_ID)
);

CREATE table assists(
	doctor_ID numeric(6,0),
	nurse_ID numeric(6,0),
	primary key(doctor_ID, nurse_ID),
	foreign key(doctor_ID) references doctor(doctor_ID),
	foreign key(nurse_ID) references nurse(nurse_ID) ON DELETE CASCADE
);

CREATE table recordContent(
	record_ID numeric(8,0),
	updated_date date,
	note varchar(1000),
	doctor_ID numeric(6,0),
	primary key(record_ID, updated_date),
	foreign key(doctor_ID) references doctor(doctor_ID)
);

CREATE table writes(
	doctor_ID numeric(6,0),
	record_ID numeric(8,0),
	updated_date date,
	primary key(doctor_ID, record_ID, updated_date),
	foreign key(doctor_ID) references doctor(doctor_ID),
	foreign key(record_ID,updated_date) references recordContent(record_ID, updated_date)
);

CREATE table recordContentKeepsDisease(
	disease_name varchar(30),
	record_ID numeric(8,0),
	updated_date date,	
	primary key(disease_name,record_ID,updated_date),
	foreign key(disease_name) references disease(disease_name),
	foreign key(record_ID,updated_date) references recordContent(record_ID, updated_date)
);
--
-- done adding all of the tables, now add in some tuples
-- 
/*Ken's part*/
insert into clientAddressPostal values('5448 Saunders Cres 100 Mile House','V0K 2E1');
insert into clientAddressPostal values('21751 136 Ave, Maple Ridge','V4R 2T4');
insert into clientAddressPostal values('6039 12th Ave, Burnaby',' V6J 2G4');
insert into clientAddressPostal values('1520 13th Ave W, Vancouver','V3N 2J2');
insert into clientAddressPostal values('6767 Balaclava St, Vancouver','V6N 0A7');
insert into clientAddressPostal values('120 Cordova St E, Vancouver','V6A 1K9');
insert into clientAddressPostal values('420 Maple St E, Vancouver', 'V7B 1C5'); -- ADDED

insert into clientInfo values(1000,'5448 Saunders Cres 100 Mile House','Amy',6043676653,123456,'2015-7-30',0,0,0);
insert into clientInfo values(2000,'21751 136 Ave, Maple Ridge','Kenji',6043676654,234567,'2015-2-4',0,0,0);
insert into clientInfo values(3000,'6039 12th Ave, Burnaby','Lili',6043676659,345678,'2013-5-13',0,0,0);
insert into clientInfo values(9000,'1520 13th Ave W, Vancouver','Helen',6043676651,456789,'2012-8-15',0,0,0);
insert into clientInfo values(4000,'6767 Balaclava St, Vancouver','Bebe',6043676658,567890,'2014-10-30',0,0,0);
insert into clientInfo values(6000,'120 Cordova St E, Vancouver','Tintin',6043676655,654321,'2014-10-25',0,0,0);
insert into clientInfo values(5000,'420 Maple St E, Vancouver','Marie',6049998888,765432,'2000-07-26',0,0,0); -- ADDED

insert into disease values('headache','head hurts');
insert into disease values('broken leg','leg is broken');
insert into disease values('broken arm','arm is broken');
insert into disease values('stomachache','stomach hurts');
insert into disease values('broken neck','neck is broken');


insert into clinicAddressPostal values('3355 William Ave, North Vancouver','V7K 1Z7');
insert into clinicAddressPostal values('6670 64 St, Delta','V4K 4E2');
insert into clinicAddressPostal values('2260 64 Ave, Langley','V2Y 2N8');
insert into clinicAddressPostal values('1301 Lillooet Rd,Vancouver','V7J 2J1');
insert into clinicAddressPostal values('1251 Gilbert Rd, Richmond','V7E 2H8');

insert into clinicInfo values(100,'Quentin Clinic','3355 William Ave, North Vancouver',5043676652,'');
insert into clinicInfo values(200,'Ken Clinic','6670 64 St, Delta',5043676653,'8am to 9pm');
insert into clinicInfo values(300,'Happy Clinic','2260 64 Ave, Langley',5043676654,'1pm to 5pm');
insert into clinicInfo values(400,'Heal Clinic','1301 Lillooet Rd,Vancouver',5043676656,'11am to 5pm');
insert into clinicInfo values(500,'Excellent Clinic','1251 Gilbert Rd, Richmond',5043676657,'10am to 6pm');


/*Quentin's part*/
insert into clientGoestoClinic values(1000,100);
insert into clientGoestoClinic values(2000,100);
insert into clientGoestoClinic values(3000,300);
insert into clientGoestoClinic values(4000,200);
insert into clientGoestoClinic values(9000,400);
insert into clientGoestoClinic values(1000,400);
insert into clientGoestoClinic values(1000,500);
insert into clientGoestoClinic values(5000,200); -- ADDED

insert into clientNumName values(1000,'Amy');
insert into clientNumName values(2000,'Kenji');
insert into clientNumName values(3000,'Lili');
insert into clientNumName values(9000,'Helen');
insert into clientNumName values(4000,'Bebe');
insert into clientNumName values(6000,'Tintin');
insert into clientNumName values(5000,'Marie');  -- ADDED

insert into nurse values(1000, 'Mimi', 'nursing','female',123456);
insert into nurse values(1100, 'Kiki', 'nursing','female',234567);
insert into nurse values(1200, 'Lala', 'nursing','female',345678);
insert into nurse values(1300, 'Bob', 'nursing','male',567890);
insert into nurse values(1400, 'Tim', 'nursing','male',654321);

insert into clientHasRecordInfo values(5000, 1000,1000);
insert into clientHasRecordInfo values(6000, 1100,2000);
insert into clientHasRecordInfo values(7000, 1200,3000);
insert into clientHasRecordInfo values(8000, 1300,4000);
insert into clientHasRecordInfo values(9000, 1400,9000);
insert into clientHasRecordInfo values(9100, 1400,6000); -- ADDED I think we need record for cc_num = 6000 too
insert into clientHasRecordInfo values(9200, 1400,5000); -- ADDED


insert into recordInfo values(5000,1000,1000,100);
insert into recordInfo values(6000,1100,2000,200);
insert into recordInfo values(7000,1200,3000,300);
insert into recordInfo values(8000,1300,4000,400);
insert into recordInfo values(9000,1400,9000,500);
insert into recordInfo values(9100,1400,6000,200);
insert into recordInfo values(9200,1400,5000,200); -- ADDED


insert into nurseCreatesRecord values(5000,1000,'2010-7-19');
insert into nurseCreatesRecord values(6000,1100,'2009-7-20');
insert into nurseCreatesRecord values(7000,1200,'2008-7-10');
insert into nurseCreatesRecord values(8000,1300,'2007-4-16');
insert into nurseCreatesRecord values(9000,1400,'2005-2-15');
insert into nurseCreatesRecord values(9100,1400,'2005-2-19');
insert into nurseCreatesRecord values(9200,1400,'2005-2-20'); -- ADDED

insert into clinicKeepsRecordInfo values(5000,1000,1000,100);
insert into clinicKeepsRecordInfo values(6000,1100,2000,200);
insert into clinicKeepsRecordInfo values(7000,1200,3000,300);
insert into clinicKeepsRecordInfo values(8000,1300,4000,400);
insert into clinicKeepsRecordInfo values(9000,1400,9000,500);
insert into clinicKeepsRecordInfo values(9100,1400,6000,200);
insert into clinicKeepsRecordInfo values(9200,1400,5000,200); -- ADDED

/*Chihiro's part*/
insert into walkinClinic values (100, '1 to 2 hours');
insert into walkinClinic values (200, '1 to 1.5 hours');
insert into walkinClinic values (300, '2 to 3 hours');
insert into walkinClinic values (400, '0 to 0.5 hours');
insert into walkinClinic values (500, '1 to 2.5 hours');

insert into doctor values (1500,'Dr. Howard Zamick','Brain', 'Doctor', 'male',123456,0);
insert into doctor values (2000,'Dr. Chelsea Berry','Dentistry', 'Doctor', 'female',234567,0);
insert into doctor values (2500,'Dr. Janan S. Sayyed','Cosmetic Surgery', 'Doctor', 'female',345678,0);
insert into doctor values (3000,'Dr. William Edwards','Nerve', 'Doctor', 'male',456789,0);
insert into doctor values (3500,'Dr. Steve Knighton','Spine', 'Doctor', 'male',567890,0);
insert into doctor values (4000,'Dr. David Close','Spine', 'Doctor', 'male',654321,0);

insert into worksIn values(1500, 100);
insert into worksIn values(1500, 300);
insert into worksIn values(2000, 400);
insert into worksIn values(2000, 200);
insert into worksIn values(2000, 100);
insert into worksIn values(2500, 500);
insert into worksIn values(3000, 500);
insert into worksIn values(3000, 400);
insert into worksIn values(3500, 100);
insert into worksIn values(3500, 300);
insert into worksIn values(3500, 200);
insert into worksIn values(4000, 200);

insert into assists values(2000, 1000);
insert into assists values(2000, 1200);
insert into assists values(3000, 1200);
insert into assists values(3000, 1400);
insert into assists values(3000, 1300);
insert into assists values(3500, 1000);
insert into assists values(3500, 1400);

insert into recordContent values(5000, '2013-05-05', 'Come back in a week', 1500);
insert into recordContent values(5000, '2013-05-12', 'Getting better', 1500);
insert into recordContent values(5000, '2013-05-19', 'Almost cured', 3500);
insert into recordContent values(5000, '2013-06-04', 'Completely cured', 2000);
insert into recordContent values(5000, '2013-06-05', 'Not too bad', 2000); -- Added
insert into recordContent values(5000, '2013-07-04', 'Not too bad', 2000); -- Added
insert into recordContent values(5000, '2013-08-04', 'Not too bad', 2000); -- Added
insert into recordContent values(6000, '2011-07-07', 'Not so serious', 2000);
insert into recordContent values(7000, '2013-05-05', 'Should be fine soon', 3500);
insert into recordContent values(7000, '2013-05-19', 'Not too bad', 2500);
insert into recordContent values(8000, '2012-07-07', 'Come back next week', 1500);
insert into recordContent values(8000, '2012-07-12', 'Almost cured', 3000);
insert into recordContent values(9000, '2011-07-07', 'Should be fine in a week', 3000);
insert into recordContent values(9100, '2015-02-15', 'Waiting for hope', 2500); 
insert into recordContent values(9200, '2015-02-15', 'Not too bad', 3500); -- ADDED
insert into recordContent values(9200, '2015-02-17', 'Should be fine soon', 2000); -- ADDED
insert into recordContent values(9200, '2015-02-28', 'Waiting for hope', 3500); -- ADDED
insert into recordContent values(9200, '2015-03-10', 'Come back next week', 4000); -- ADDED
insert into recordContent values(9200, '2015-04-20', 'Almost cured', 4000); -- ADDED


insert into writes values(1500, 5000, '2013-05-05');
insert into writes values(1500, 5000, '2013-05-12');
insert into writes values(3500, 5000, '2013-05-19');
insert into writes values(2000, 5000, '2013-06-04');
insert into writes values(2000, 5000, '2013-06-05');
insert into writes values(2000, 5000, '2013-07-04');
insert into writes values(2000, 5000, '2013-08-04');
insert into writes values(2000, 6000, '2011-07-07');
insert into writes values(3500, 7000, '2013-05-05');
insert into writes values(2500, 7000, '2013-05-19');
insert into writes values(1500, 8000, '2012-07-07');
insert into writes values(3000, 8000, '2012-07-12');
insert into writes values(3000, 9000, '2011-07-07');
insert into writes values(2500, 9100, '2015-02-15');
insert into writes values(3500, 9200, '2015-02-15'); -- ADDED
insert into writes values(2000, 9200, '2015-02-17'); -- ADDED
insert into writes values(3500, 9200, '2015-02-28'); -- ADDED
insert into writes values(4000, 9200, '2015-03-10'); -- ADDED
insert into writes values(4000, 9200, '2015-04-20'); -- ADDED


insert into recordContentKeepsDisease values('broken leg',5000,'2013-05-05');
insert into recordContentKeepsDisease values('broken leg',5000,'2013-05-12');
insert into recordContentKeepsDisease values('broken leg',5000,'2013-05-19');
insert into recordContentKeepsDisease values('broken leg',5000,'2013-06-04');
insert into recordContentKeepsDisease values('headache',5000,'2013-06-05'); -- ADDED
insert into recordContentKeepsDisease values('broken arm',5000,'2013-07-04'); -- ADDED
insert into recordContentKeepsDisease values('broken neck',5000,'2013-08-04'); -- ADDED
insert into recordContentKeepsDisease values('headache',6000,'2011-07-07');
insert into recordContentKeepsDisease values('stomachache',7000,'2013-05-05');
insert into recordContentKeepsDisease values('headache',7000,'2013-05-19');
insert into recordContentKeepsDisease values('broken neck',8000,'2012-07-07');
insert into recordContentKeepsDisease values('broken neck',8000,'2012-07-12');
insert into recordContentKeepsDisease values('headache',9000,'2011-07-07');
insert into recordContentKeepsDisease values('headache',9100,'2015-02-15');
insert into recordContentKeepsDisease values('headache',9200,'2015-02-15');  -- ADDED
insert into recordContentKeepsDisease values('broken leg',9200,'2015-02-17');  -- ADDED
insert into recordContentKeepsDisease values('broken arm',9200,'2015-02-28');  -- ADDED
insert into recordContentKeepsDisease values('stomachache',9200,'2015-03-10');  -- ADDED
insert into recordContentKeepsDisease values('broken neck',9200,'2015-04-20');  -- ADDED