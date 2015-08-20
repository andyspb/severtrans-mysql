CREATE or replace  ALGORITHM=UNDEFINED DEFINER=`dba`@`localhost` SQL SECURITY DEFINER VIEW `ActiveClients` 
AS
SELECT DISTINCT `clients`.FullName,`clients`.PersonType_Ident,`clients`.Inperson,`clients`.Telephone,`clients`.Email,`clients`.Inn,`clients`.KPP
FROM `severtrans`.`clients`
inner  join `severtrans`.`sends` on `clients`.`Ident`=`sends`.`Client_Ident`;