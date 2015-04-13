-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`dba`@`%` PROCEDURE `BookselSetRowNumber`()
begin
   set @number=-(select count(*) from `invoice` left join `clients` on (`invoice`.`Clients_Ident` = `clients`.`Ident`));
end
