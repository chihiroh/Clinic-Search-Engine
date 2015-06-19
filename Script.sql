
/*A list of the SQL queries used*/

/*nurse_login.php*/
SELECT * FROM nurse WHERE nurse_ID='$nurse_ID' AND nurse_password='$password'
SELECT nurse_name FROM nurse WHERE nurse_ID='$nurse_ID' AND nurse_password='$password'
	
/* Clients.php*/	
  SELECT * 
  FROM doctor
  WHERE doctor_gender= male 		
  ORDER BY doctor_name
  
/* NOTE: The SELECT phrase could be * or doctor_ID,doctor_name,specialization,doctor_degree,doctor_gender,doctor_rating.
  the WHERE phrase could be doctor_gender= male or doctor_gender= female.*/

/*clie_home.php*/  
 UPDATE clientinfo 
 SET client_rated = client_rated + 5
 WHERE cc_num = 1000
/* NOTE: The number in client_rated can be 1,5,10. cc_num can be any client care card number */
					 
UPDATE clientinfo 
SET times_rated = times_rated + 1
WHERE cc_num = 1000

/* NOTE: cc_num can be any client care card number */

SELECT times_rated
FROM  clientinfo
WHERE cc_num = 1000

/* NOTE: cc_num can be any client care card number */

UPDATE clientinfo 
SET   doctor_ID = 3500
WHERE cc_num = 1000

/* NOTE: cc_num can be any client care card number. doctor_ID can be any doctor's ID */  
  
UPDATE doctor 
SET  doctor_rating = (
						SELECT AVG(client_rated)
						FROM  clientinfo
						WHERE doctor_ID = 3500	
						GROUP BY doctor_ID)
		WHERE doctor_ID = 3500	 
/* NOTE: doctor_ID can be any doctor's ID */ 
  
SELECT doctor_ID, doctor_name, doctor_rating 
		FROM doctor d 
		WHERE d.doctor_rating >= ALL(SELECT d1.doctor_rating FROM doctor d1)  
		
	
/* delete_nurse.php */
DELETE  
FROM nurse
WHERE nurse_ID=$nurse_ID

SELECT nurse_ID, nurse_name, nurse_gender, nurse_degree 
FROM nurse 
WHERE nurse_degree LIKE '%$filterInput%'

DELETE  
FROM nurse
WHERE nurse_ID=$nurse_ID


/* stat.php */
SELECT MAX(ci.cc_num) AS max,  MIN(ci.cc_num) AS min
FROM clientInfo ci, clientHasRecordInfo cri, recordContentKeepsDisease rcd
WHERE ci.cc_num = cri.cc_num AND 
	  ri.record_ID = rcd.record_ID AND
	  cri.record_ID IN (SELECT c.record_ID 
						FROM clinicKeepsRecordInfo c
					 	WHERE c.clinic_ID = 200)


SELECT clinic_postal, count(*) as num
FROM clinicAddressPostal CAP, clinicInfo CI 
WHERE CAP.clinic_address = CI.clinic_address 
GROUP BY clinic_postal


SELECT distinct CI.cc_num, CI.client_name, CI.client_address, CI.client_phone, CI.birth_date
FROM clientInfo CI
WHERE NOT EXISTS (SELECT *
				  FROM disease d
				  WHERE NOT EXISTS (SELECT *
								    FROM clientHasRecordInfo CRI, recordContentKeepsDisease RCD
									WHERE RCD.disease_name = d.disease_name AND
									  	  CI.cc_num = CRI.cc_num AND
					 	   				  CRI.record_ID = RCD.record_ID))


SELECT rcd.disease_name, count(DISTINCT ci.cc_num) AS count
FROM clientInfo ci, clientHasRecordInfo cri, recordContentKeepsDisease rcd
WHERE ci.cc_num = cri.cc_num AND 
	  cri.record_ID = rcd.record_ID AND
	 cri.record_ID IN (SELECT c.record_ID 
			  		   FROM clinicKeepsRecordInfo c
			  		   WHERE c.clinic_ID = 200)
GROUP BY rcd.disease_name


SELECT DISTINCT ci.cc_num, ci.client_name, ci.client_address, 
				cap.client_postal, ci.client_phone, ci.birth_date, rcd.disease_name
FROM clientInfo ci, clientAddressPostal cap, clientHasRecordInfo cri, 
	 recordContentKeepsDisease rcd, clinicKeepsRecordInfo c
WHERE ci.client_address = cap.client_address AND 
	  ci.cc_num = cri.cc_num AND 
	  cri.record_ID = rcd.record_ID AND 
	  rcd.disease_name LIKE '%$disease%' AND
	  c.cc_num = ci.cc_num AND
	  c.record_ID = rcd.record_ID AND
	  c.clinic_ID = 200


SELECT DISTINCT ci.cc_num, ci.client_name, ci.client_address, 
				cap.client_postal, ci.client_phone, ci.birth_date, rcd.disease_name
FROM clientInfo ci, clientAddressPostal cap, clientHasRecordInfo cri, 
	 recordContentKeepsDisease rcd, clinicKeepsRecordInfo c
WHERE ci.client_address = cap.client_address AND 
	  ci.cc_num = cri.cc_num AND 
	  cri.record_ID = rcd.record_ID AND
	  c.cc_num = ci.cc_num AND
	  c.record_ID = rcd.record_ID AND
	  c.clinic_ID = 200

/*Project all the attributes except client password when the cc_num is equal to the typed Care Card Number, joining recordInfo and clientInfo*/
SELECT C.cc_num, C.client_name, C.client_address, C.client_phone, C.birth_date, R.clinic_ID, R.record_ID, R.nurse_ID 
FROM recordInfo R,clientInfo C 
WHERE R.cc_num = C.cc_num AND R.cc_num = $searchquery
ORDER BY C.cc_num;

/*Project all the attributes except client password when the record_ID is equal to the typed Record ID, joining recordInfo and clientInfo*/
SELECT C.cc_num, C.client_name, C.client_address, C.client_phone, C.birth_date, R.clinic_ID, R.record_ID, R.nurse_ID 
FROM recordInfo R,clientInfo C 
WHERE R.cc_num = C.cc_num AND R.record_ID = $searchquery
ORDER BY C.cc_num;

/*Project all the attributes except client password when the client_name contains the typed name, joining recordInfo and clientInfo*/
SELECT C.cc_num, C.client_name, C.client_address, C.client_phone, C.birth_date, R.clinic_ID, R.record_ID, R.nurse_ID 
FROM recordInfo R,clientInfo C 
WHERE R.cc_num = C.cc_num AND C.client_name LIKE '%$searchquery%'
ORDER BY C.cc_num;

/*record_content_doctor.php and record_content_nurse.php*/

-- Project record content for the opened record_ID, joining recordContent and recordContentKeepsDisease
SELECT RC.record_ID, RC.updated_date, RC.note, RC.doctor_ID, RD.disease_name
FROM recordContent RC, recordContentKeepsDisease RD 
WHERE RC.record_ID = RD.record_ID AND RC.updated_date = RD.updated_date;

/*Select the cc_num for the opened record_ID*/
SELECT cc_num 
FROM recordInfo 
WHERE record_ID = $record_ID;

/*Select the client_name for the opened record_ID*/
SELECT client_name 
FROM ClientInfo 
WHERE cc_num = $cc_num;

/*added_record_content.php*/

-- Select the cc_num for the opened record_ID
SELECT cc_num 
FROM recordInfo 
WHERE record_ID = $record_ID;

-- Select the client_name for the opened record_ID
SELECT client_name 
FROM ClientInfo 
WHERE cc_num = $cc_num;

-- Insert the typed infomation into recordContent
INSERT INTO recordContent (record_ID, updated_date, note, doctor_ID) 
VALUES (?,?,?,?);

-- Insert the typed infomation into recordContentKeepsDisease
INSERT INTO recordContentKeepsDisease (disease_name, record_ID, updated_date) 
VALUES (?,?,?);

-- Project record content for the opened record_ID after inserting new record content, joining recordContent and recordContentKeepsDisease
SELECT RC.record_ID, RC.updated_date, RC.note, RC.doctor_ID, RD.disease_name
FROM recordContent RC, recordContentKeepsDisease RD 
WHERE RC.record_ID = $record_ID AND RC.record_ID = RD.record_ID AND RC.updated_date = RD.updated_date



