# Запрос для Реестра для фин департамента (Ковальчук, счета которые утверждены но пока не оплаченны)
# Нужно добавить Если Срочно в оплату добавлять об этом инфо в коммент, а так же сортировать ко Срочности, а также включать те которые подтверждены до 15:00 или id шником в любое время

SELECT IF((fin.nplane) IS NULL,"",fin.nplane) as num, fin.postav as postav, fin.numinv as numsch,"" as dt, 
aminvoice as sum,"0" as stat, fin.artbudg as st, "" as reg, 
IF((SELECT prv.status	FROM `z_confirmation` prv WHERE prv.sheet like "z_tab_invoice" AND `prv`.`sheet_id` = fin.idnt ORDER BY prv.tmstamp DESC  LIMIT 1) = "20", 
(SELECT z_confirm_catal.state FROM `z_confirmation` prv LEFT JOIN  z_confirm_catal ON prv.status=z_confirm_catal.id 
WHERE prv.sheet like "z_tab_invoice" AND `prv`.`sheet_id` = fin.idnt ORDER BY prv.tmstamp DESC  LIMIT 1),"") AS coment, fin.tblkoval AS tabk, 
(SELECT DATE_FORMAT(prv.tmstamp,"%d.%m.%y %H:%i") FROM `z_confirmation` prv WHERE prv.sheet like "z_tab_invoice" AND `prv`.`sheet_id` = fin.idnt ORDER BY prv.tmstamp DESC  LIMIT 1) AS podtv 
FROM 
((SELECT kli.client AS nplane, provider.client AS postav,z_tab_invoice.num_invoice AS numinv, 
ROUND(z_tab_invoice.summa,2) AS aminvoice, z_tab_catal_type_budget_kovalchuk.kname  AS artbudg, 
z_tab_invoice.sap_id AS ts, z_tab_invoice.reestr_num_kovalchuk as tblkoval, z_tab_invoice.id as idnt 
FROM z_tab_invoice 
LEFT JOIN  tab_klients  kli ON z_tab_invoice.client=kli.id 
LEFT JOIN z_tab_catal_type_budget  ON z_tab_invoice.articl_budget =z_tab_catal_type_budget.id 
LEFT JOIN z_tab_catal_type_budget_kovalchuk ON z_tab_catal_type_budget.finKovalchuk = z_tab_catal_type_budget_kovalchuk.id 
LEFT JOIN tab_catal_dogovor ON z_tab_invoice.num_dogovor=tab_catal_dogovor.id 
LEFT JOIN z_connecttable ON tab_catal_dogovor.id = z_connecttable.tab_b_id AND z_connecttable.tab_b like "tab_catal_dogovor" 
LEFT JOIN tab_klients provider ON z_connecttable.tab_a_id = provider.id 
WHERE z_tab_invoice.type_docum = "2" AND z_tab_invoice.not_incl_in_kreestr = "0" AND z_connecttable.tab_a like "tab_klients" AND z_tab_invoice.dt_of_pay = "0000-00-00" 
AND (SELECT prv.status	FROM `z_confirmation` prv WHERE prv.sheet like "z_tab_invoice" AND prv.tmstamp <= concat(DATE(NOW()),"15:00:00") AND `prv`.`sheet_id` = z_tab_invoice.id ORDER BY prv.tmstamp DESC  LIMIT 1) NOT IN (30,50)) 
UNION ALL 
(SELECT kli.client AS nplane, provider.client AS postav, z_tab_invoice.num_invoice AS numinv, 
ROUND(z_tab_invoice.summa,2) AS aminvoice, z_tab_catal_type_budget_kovalchuk.kname  AS artbudg, 
z_tab_invoice.sap_id AS ts, z_tab_invoice.reestr_num_kovalchuk as tblkoval, z_tab_invoice.id as idnt 
FROM z_tab_invoice 
LEFT JOIN  tab_klients  kli ON z_tab_invoice.client=kli.id 
LEFT JOIN z_tab_catal_type_budget  ON z_tab_invoice.articl_budget =z_tab_catal_type_budget.id 
LEFT JOIN z_tab_catal_type_budget_kovalchuk ON z_tab_catal_type_budget.finKovalchuk = z_tab_catal_type_budget_kovalchuk.id 
LEFT JOIN tab_catal_dogovor ON z_tab_invoice.num_dogovor=tab_catal_dogovor.id 
LEFT JOIN z_connecttable ON tab_catal_dogovor.id = z_connecttable.tab_b_id AND z_connecttable.tab_b like "tab_catal_dogovor" 
LEFT JOIN z_tab_klients provider ON z_connecttable.tab_a_id = provider.id 
WHERE z_tab_invoice.type_docum = "2" AND z_tab_invoice.not_incl_in_kreestr = "0" AND z_connecttable.tab_a like "z_tab_klients" AND z_tab_invoice.dt_of_pay = "0000-00-00" 
AND (SELECT prv.status	FROM `z_confirmation` prv WHERE prv.sheet like "z_tab_invoice" AND prv.tmstamp <= concat(DATE(NOW()),"15:00:00") AND `prv`.`sheet_id` = z_tab_invoice.id ORDER BY prv.tmstamp DESC  LIMIT 1) NOT IN (30,50))) fin 
ORDER BY fin.artbudg ASC, coment DESC, podtv ASC
