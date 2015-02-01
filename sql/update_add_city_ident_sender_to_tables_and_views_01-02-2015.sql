ALTER TABLE  send ADD City_Ident_Sender INT(11) AFTER City_Ident;
ALTER TABLE  send_all ADD City_Ident_Sender INT(11) AFTER City_Ident;

CREATE or replace  ALGORITHM=UNDEFINED DEFINER=`dba`@`localhost` SQL SECURITY DEFINER VIEW `sends_all` 
AS select distinct `send_all`.`Ident` AS `Ident`,`send_all`.`Check` AS `Check`,`send_all`.`Start` AS `Start`,`send_all`.`Inspector_Ident` 
AS `Inspector_Ident`,`inspector`.`PeopleFIO` AS `PeopleFIO`,`send_all`.`ContractType_Ident` AS `ContractType_Ident`,`contracttype`.`Name` 
AS `ContracttypeName`,`send_all`.`Client_Ident` AS `Client_Ident`,`clients`.`Name` AS `ClientName`,`clients`.`Acronym` AS `ClientAcr`,`clients`.`Telephone` 
AS `ClientPhone`,`clients`.`PersonType_Ident` AS `Persontype_ident`,`send_all`.`Credit` AS `Credit`,`send_all`.`Contract` AS `Contract`,`send_all`.`Client_Ident_Sender` 
AS `Client_Ident_Sender`,`cl`.`Name` AS `ClientSenderName`,`cl`.`Acronym` AS `ClientSenderAcr`,`cl`.`Telephone` AS `ClientSenderPhone`,
`send_all`.`City_Ident` AS `City_Ident`,
`send_all`.`City_Ident_Sender` AS `City_Ident_Sender`,
`city`.`Name` AS `CityName`,`send_all`.`DateSend` AS `DateSend`,`send_all`.`Acceptor_Ident` AS `Acceptor_Ident`,`acceptor`.`Name` 
AS `AcceptorName`,`acceptor`.`Address` AS `AcceptorAddress`,`acceptor`.`Regime` AS `AcceptorRegime`,`acceptor`.`Phone` AS `AcceptorPhone`,`send_all`.`Forwarder_Ident` 
AS `Forwarder_Ident`,`forwarder`.`Name` AS `Forwarder`,`send_all`.`Rollout_Ident` AS `RollOut_Ident`,`rollout`.`Name` AS `RollOutName`,`send_all`.`Namegood_Ident` 
AS `Namegood_Ident`,`namegood`.`Name` AS `NamegoodName`,`send_all`.`Typegood_Ident` AS `Typegood_Ident`,`send_all`.`Weight` AS `Weight`,`send_all`.`Volume` AS `Volume`,`send_all`.`CountWeight` 
AS `CountWeight`,`send_all`.`Tariff` AS `Tariff`,concat(cast(((cast(`send_all`.`CountWeight` as decimal(10,2)) * cast(`send_all`.`Tariff` as decimal(10,2))) / 10) as decimal(15,2)),' руб.') 
AS `MoneyGD`,`send_all`.`Fare` AS `Fare`,`send_all`.`PackTarif` AS `PackTarif`,`send_all`.`AddServiceExp` AS `AddServiceExp`,`send_all`.`AddServicePack` 
AS `AddServicePack`,`send_all`.`AddServiceProp` AS `AddServiceProp`,`send_all`.`AddServicePrace` AS `AddServicePrace`,`send_all`.`InsuranceSum` 
AS `InsuranceSum`,`send_all`.`InsurancePercent` AS `InsurancePercent`,`send_all`.`InsuranceValue` AS `InsuranceValue`,`send_all`.`InsurancePay` 
AS `InsurancePay`,`send_all`.`SumCount` AS `SumCount`,`send_all`.`Typegood_Ident1` AS `Typegood_Ident1`,`send_all`.`Typegood_Ident2` AS `Typegood_Ident2`,`send_all`.`Namber` 
AS `Namber`,`send_all`.`PayType_Ident` AS `PayType_Ident`,`paytype`.`Name` AS `PayTypeName`,`send_all`.`NmberOrder` AS `NmberOrder`,`send_all`.`Invoice_Ident` AS `Invoice_Ident`,`invoice_all`.`Number` 
AS `InvoiceNumber`,`invoice_all`.`Data` AS `InvoiceDate`,`send_all`.`NumberCountPattern` AS `NumberCountPattern`,`send_all`.`PayText` AS `PayText`,`send_all`.`StatusSupp_Ident` 
AS `StatusSupp_Ident`,`sendtype`.`Name` AS `SendTypeName`,`send_all`.`DateSupp` AS `DateSupp`,`send_all`.`Supplier_Ident` AS `Supplier_Ident`,`supplier`.`Name` 
AS `SupplierName`,`send_all`.`SuppText` AS `SuppText`,cast(`send_all`.`PackCount` as char(60) charset utf8) AS `PackCount`,`send_all`.`ExpCount` AS `ExpCount`,`send_all`.`PropCount` 
AS `PropCount`,`send_all`.`ExpTarif` AS `ExpTarif`,`send_all`.`PropTarif` AS `PropTarif`,`send_all`.`Train_Ident` AS `Train_Ident`,`send_all`.`AddServStr` AS `AddServStr`,`send_all`.`AddServSum` 
AS `AddServSum`,`send_all`.`CutTarif` AS `CutTarif`,`train`.`Number` AS `Number`,`send_all`.`SumWay` AS `SumWay`,`send_all`.`NumberWay` AS `NumberWay`,`send_all`.`SumServ` 
AS `SumServ`,`send_all`.`NumberServ` AS `NumberServ`,`send_all`.`WeightGd` AS `WeightGd`,`send_all`.`PlaceGd` AS `PlaceGd`,`send_all`.`NumberPP` AS `NumberPP`,`send_all`.`PayTypeWay_Ident` 
AS `PayTypeWay_Ident`,`ptway`.`Name` AS `WayName`,`send_all`.`PayTypeServ_Ident` AS `PayTypeServ_Ident`,`ptserv`.`Name` AS `ServName`,`send_all`.`CountInvoice` AS `CountInvoice`,`send_all`.`PlaceC` 
AS `PlaceC`,'+' AS `Sel`,`severtrans`.`TP_return`(`send_all`.`Typegood_Ident`) AS `TP`,`severtrans`.`TP1_return`(`send_all`.`Typegood_Ident1`) AS `TP1`,`severtrans`.`TP2_return`(`send_all`.`Typegood_Ident2`) 
AS `TP2`,concat(`severtrans`.`TP_return`(`send_all`.`Typegood_Ident`),' ',`severtrans`.`TP1_return`(`send_all`.`Typegood_Ident1`),' ',`severtrans`.`TP2_return`(`send_all`.`Typegood_Ident2`)) 
AS `Typegood`,`akttek_all`.`IDENT` AS `Akttek_Ident`,`akttek_all`.`Number` AS `AkttekNumber`,`akttek_all`.`Data` AS `Akttekdata` from ((((((((((((((((`send_all` left join `inspector` 
on((`send_all`.`Inspector_Ident` = `inspector`.`Ident`))) left join `contracttype` on((`send_all`.`ContractType_Ident` = `contracttype`.`Ident`))) left join `clients` 
on((`clients`.`Ident` = `send_all`.`Client_Ident`))) left join `train` on((`train`.`Ident` = `send_all`.`Train_Ident`))) left join `city` on((`send_all`.`City_Ident` = `city`.`Ident`))) left join `acceptor` 
on((`acceptor`.`Ident` = `send_all`.`Acceptor_Ident`))) left join `rollout` on((`send_all`.`Rollout_Ident` = `rollout`.`Ident`))) left join `namegood` on((`send_all`.`Namegood_Ident` = `namegood`.`Ident`))) 
left join `forwarder` on((`forwarder`.`Ident` = `send_all`.`Forwarder_Ident`))) left join `paytype` on((`paytype`.`Ident` = `send_all`.`PayType_Ident`))) left join `supplier` 
on((`send_all`.`Supplier_Ident` = `supplier`.`Ident`))) left join `sendtype` on((`send_all`.`StatusSupp_Ident` = `sendtype`.`Ident`))) left join `invoice_all` 
on((`invoice_all`.`Ident` = `send_all`.`Invoice_Ident`))) left join `paytype` `ptway` on((`ptway`.`Ident` = `send_all`.`PayTypeWay_Ident`))) left join `paytype` `ptserv` 
on((`ptserv`.`Ident` = `send_all`.`PayTypeServ_Ident`))) left join ((`send_all` `s` left join `clients` `cl` on((`cl`.`Ident` = `s`.`Client_Ident_Sender`))) left join `akttek_all` 
on((`akttek_all`.`IDENT` = `s`.`Akttek_Ident`))) on((`send_all`.`Ident` = `s`.`Ident`)));

CREATE or replace  ALGORITHM=UNDEFINED DEFINER=`dba`@`localhost` SQL SECURITY DEFINER VIEW `sends` 
AS select distinct `send`.`Ident` AS `Ident`,`send`.`Check` AS `Check`,`send`.`Start` AS `Start`,`send`.`Inspector_Ident` 
AS `Inspector_Ident`,`inspector`.`PeopleFIO` AS `PeopleFIO`,`send`.`ContractType_Ident` AS `ContractType_Ident`,`contracttype`.`Name` 
AS `ContracttypeName`,`send`.`Client_Ident` AS `Client_Ident`,`clients`.`Name` AS `ClientName`,`clients`.`Acronym` AS `ClientAcr`,`clients`.`Telephone` 
AS `ClientPhone`,`clients`.`PersonType_Ident` AS `Persontype_ident`,`send`.`Credit` AS `Credit`,`send`.`Contract` AS `Contract`,`send`.`Client_Ident_Sender` 
AS `Client_Ident_Sender`,`cl`.`Name` AS `ClientSenderName`,`cl`.`Acronym` AS `ClientSenderAcr`,`cl`.`Telephone` AS `ClientSenderPhone`,
`send`.`City_Ident` AS `City_Ident`,
`send`.`City_Ident_Sender` AS `City_Ident_Sender`,
`city`.`Name` AS `CityName`,`send`.`DateSend` AS `DateSend`,`send`.`Acceptor_Ident` AS `Acceptor_Ident`,`acceptor`.`Name` 
AS `AcceptorName`,`acceptor`.`Address` AS `AcceptorAddress`,`acceptor`.`Regime` AS `AcceptorRegime`,`acceptor`.`Phone` AS `AcceptorPhone`,`send`.`Forwarder_Ident` 
AS `Forwarder_Ident`,`forwarder`.`Name` AS `Forwarder`,`send`.`Rollout_Ident` AS `RollOut_Ident`,`rollout`.`Name` AS `RollOutName`,`send`.`Namegood_Ident` 
AS `Namegood_Ident`,`namegood`.`Name` AS `NamegoodName`,`send`.`Typegood_Ident` AS `Typegood_Ident`,`send`.`Weight` AS `Weight`,`send`.`Volume` AS `Volume`,`send`.`CountWeight` 
AS `CountWeight`,`send`.`Tariff` AS `Tariff`,concat(cast(((cast(`send`.`CountWeight` as decimal(10,2)) * cast(`send`.`Tariff` as decimal(10,2))) / 10) as decimal(15,2)),' руб.') 
AS `MoneyGD`,`send`.`Fare` AS `Fare`,`send`.`PackTarif` AS `PackTarif`,`send`.`AddServiceExp` AS `AddServiceExp`,`send`.`AddServicePack` 
AS `AddServicePack`,`send`.`AddServiceProp` AS `AddServiceProp`,`send`.`AddServicePrace` AS `AddServicePrace`,`send`.`InsuranceSum` 
AS `InsuranceSum`,`send`.`InsurancePercent` AS `InsurancePercent`,`send`.`InsuranceValue` AS `InsuranceValue`,`send`.`InsurancePay` 
AS `InsurancePay`,`send`.`SumCount` AS `SumCount`,`send`.`Typegood_Ident1` AS `Typegood_Ident1`,`send`.`Typegood_Ident2` AS `Typegood_Ident2`,`send`.`Namber` 
AS `Namber`,`send`.`PayType_Ident` AS `PayType_Ident`,`paytype`.`Name` AS `PayTypeName`,`send`.`NmberOrder` AS `NmberOrder`,`send`.`Invoice_Ident` AS `Invoice_Ident`,`invoice`.`Number` 
AS `InvoiceNumber`,`invoice`.`Data` AS `InvoiceDate`,`send`.`NumberCountPattern` AS `NumberCountPattern`,`send`.`PayText` AS `PayText`,`send`.`StatusSupp_Ident` 
AS `StatusSupp_Ident`,`sendtype`.`Name` AS `SendTypeName`,`send`.`DateSupp` AS `DateSupp`,`send`.`Supplier_Ident` AS `Supplier_Ident`,`supplier`.`Name` 
AS `SupplierName`,`send`.`SuppText` AS `SuppText`,cast(`send`.`PackCount` as char(60) charset utf8) AS `PackCount`,`send`.`ExpCount` AS `ExpCount`,`send`.`PropCount` 
AS `PropCount`,`send`.`ExpTarif` AS `ExpTarif`,`send`.`PropTarif` AS `PropTarif`,`send`.`Train_Ident` AS `Train_Ident`,`send`.`AddServStr` AS `AddServStr`,`send`.`AddServSum` 
AS `AddServSum`,`send`.`CutTarif` AS `CutTarif`,`train`.`Number` AS `Number`,`send`.`SumWay` AS `SumWay`,`send`.`NumberWay` AS `NumberWay`,`send`.`SumServ` 
AS `SumServ`,`send`.`NumberServ` AS `NumberServ`,`send`.`WeightGd` AS `WeightGd`,`send`.`PlaceGd` AS `PlaceGd`,`send`.`NumberPP` AS `NumberPP`,`send`.`PayTypeWay_Ident` 
AS `PayTypeWay_Ident`,`ptway`.`Name` AS `WayName`,`send`.`PayTypeServ_Ident` AS `PayTypeServ_Ident`,`ptserv`.`Name` AS `ServName`,`send`.`CountInvoice` AS `CountInvoice`,`send`.`PlaceC` 
AS `PlaceC`,'+' AS `Sel`,`severtrans`.`TP_return`(`send`.`Typegood_Ident`) AS `TP`,`severtrans`.`TP1_return`(`send`.`Typegood_Ident1`) AS `TP1`,`severtrans`.`TP2_return`(`send`.`Typegood_Ident2`) 
AS `TP2`,concat(`severtrans`.`TP_return`(`send`.`Typegood_Ident`),' ',`severtrans`.`TP1_return`(`send`.`Typegood_Ident1`),' ',`severtrans`.`TP2_return`(`send`.`Typegood_Ident2`)) 
AS `Typegood`,`akttek`.`IDENT` AS `Akttek_Ident`,`akttek`.`Number` AS `AkttekNumber`,`akttek`.`Data` AS `Akttekdata` from ((((((((((((((((`send` left join `inspector` 
on((`send`.`Inspector_Ident` = `inspector`.`Ident`))) left join `contracttype` on((`send`.`ContractType_Ident` = `contracttype`.`Ident`))) left join `clients` 
on((`clients`.`Ident` = `send`.`Client_Ident`))) left join `train` on((`train`.`Ident` = `send`.`Train_Ident`))) left join `city` on((`send`.`City_Ident` = `city`.`Ident`))) left join `acceptor` 
on((`acceptor`.`Ident` = `send`.`Acceptor_Ident`))) left join `rollout` on((`send`.`Rollout_Ident` = `rollout`.`Ident`))) left join `namegood` on((`send`.`Namegood_Ident` = `namegood`.`Ident`))) 
left join `forwarder` on((`forwarder`.`Ident` = `send`.`Forwarder_Ident`))) left join `paytype` on((`paytype`.`Ident` = `send`.`PayType_Ident`))) left join `supplier` 
on((`send`.`Supplier_Ident` = `supplier`.`Ident`))) left join `sendtype` on((`send`.`StatusSupp_Ident` = `sendtype`.`Ident`))) left join `invoice` 
on((`invoice`.`Ident` = `send`.`Invoice_Ident`))) left join `paytype` `ptway` on((`ptway`.`Ident` = `send`.`PayTypeWay_Ident`))) left join `paytype` `ptserv` 
on((`ptserv`.`Ident` = `send`.`PayTypeServ_Ident`))) left join ((`send` `s` left join `clients` `cl` on((`cl`.`Ident` = `s`.`Client_Ident_Sender`))) left join `akttek` 
on((`akttek`.`IDENT` = `s`.`Akttek_Ident`))) on((`send`.`Ident` = `s`.`Ident`)));


