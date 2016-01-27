# Запрос для Отчета Ковальчук (reestr -> Отчеты -> Разовые ковальчук)

(SELECT tab_catal_comm_dep.namedepartment AS  Бизнес,
       tab_access.nik AS Менеджер,
       if(z_tab_invoice.sap_id != '0',z_tab_invoice.sap_id,'') AS 'SAP ID',
       if(z_tab_invoice.planner_id!='0',z_tab_invoice.planner_id,'') AS Планер,
       kli.client AS 'Клиент',tab_town.town AS 'Город',
       z_tab_invoice.address AS Адрес, 
       provider.client AS 'Стор.оператор',
       z_tab_invoice.num_invoice AS НомСчета,DATE_FORMAT(z_tab_invoice.dt_invoice,'%d.%m.%y') AS 'дата счета',
       z_tab_invoice.detail_of_pay AS 'НазнПлатежа',
       ROUND(z_tab_invoice.summa,2) AS Сумма,
       if(z_tab_invoice.dt_of_pay!='0000-00-00',DATE_FORMAT(z_tab_invoice.dt_of_pay,'%d.%m.%y'),'') AS 'Дата оплаты', 
       if(z_tab_invoice.reestr_num_kovalchuk !='0',z_tab_invoice.reestr_num_kovalchuk,'') AS 'Реестр Ковальчук',
       z_tab_catal_type_budget.statiya  AS 'Статья бюджета',
       COALESCE((SELECT z_confirm_catal.state
	   FROM `z_confirmation`
	   LEFT JOIN  z_confirm_catal ON z_confirmation.status=z_confirm_catal.id 
	   WHERE z_confirmation.sheet like 'z_tab_invoice' AND `z_confirmation`.`sheet_id` = z_tab_invoice.id 
	   ORDER BY z_confirmation.tmstamp DESC LIMIT 1),'') AS status,
       z_tab_invoice.description AS comment,
       DATE_FORMAT(z_tab_invoice.dt_plan_of_pay,"%d.%m.%y") as dtplanpay,
	   z_tab_invoice.sap_id AS 'ts'
FROM z_tab_invoice 
LEFT JOIN  tab_catal_comm_dep ON z_tab_invoice.business = tab_catal_comm_dep.id
LEFT JOIN  tab_access ON z_tab_invoice.manager=tab_access.id
LEFT JOIN  tab_klients  kli ON z_tab_invoice.client=kli.id
LEFT JOIN z_tab_catal_type_budget  ON z_tab_invoice.articl_budget 
=z_tab_catal_type_budget.id
LEFT JOIN tab_town ON z_tab_invoice.town =  tab_town.id
LEFT JOIN tab_catal_dogovor ON z_tab_invoice.num_dogovor=tab_catal_dogovor.id
LEFT JOIN z_connecttable ON tab_catal_dogovor.id = z_connecttable.tab_b_id
LEFT JOIN tab_klients provider ON z_connecttable.tab_a_id = provider.id
WHERE z_tab_invoice.type_docum = '2' AND z_connecttable.tab_b like 
'tab_catal_dogovor' AND z_connecttable.tab_a like 'tab_klients' AND 
z_tab_invoice.not_incl_in_kreestr = '0')
UNION ALL
(SELECT tab_catal_comm_dep.namedepartment AS  'Бизнес',
       tab_access.nik AS 'Менеджер',
       if(z_tab_invoice.sap_id != '0',z_tab_invoice.sap_id,'') AS 'SAP ID',
       if(z_tab_invoice.planner_id!='0',z_tab_invoice.planner_id,'') AS 'Планер',
       kli.client AS 'Клиент',tab_town.town AS 'Город',
       z_tab_invoice.address AS 'Адрес',   
       provider.client AS 'Стор.оператор',
       z_tab_invoice.num_invoice AS 'НомСчета',DATE_FORMAT(z_tab_invoice.dt_invoice,'%d.%m.%y') AS 'дата счета',
       z_tab_invoice.detail_of_pay AS 'НазнПлатежа',
       ROUND(z_tab_invoice.summa,2) AS 'Сумма',
       if(z_tab_invoice.dt_of_pay!='0000-00-00',DATE_FORMAT(z_tab_invoice.dt_of_pay,'%d.%m.%y'),'') AS 'Дата оплаты', 
       if(z_tab_invoice.reestr_num_kovalchuk !='0',z_tab_invoice.reestr_num_kovalchuk,'') AS 'Реестр Ковальчук',
       z_tab_catal_type_budget.statiya  AS 'Статья бюджета',
       COALESCE((SELECT z_confirm_catal.state
	   FROM `z_confirmation` cfrm
	   LEFT JOIN  z_confirm_catal ON cfrm.status=z_confirm_catal.id 
	   WHERE cfrm.sheet like 'z_tab_invoice' AND `cfrm`.`sheet_id` = z_tab_invoice.id 
	   ORDER BY cfrm.tmstamp DESC LIMIT 1),'') AS status,
       z_tab_invoice.description AS comment,
       DATE_FORMAT(z_tab_invoice.dt_plan_of_pay,"%d.%m.%y") as dtplanpay,
       z_tab_invoice.sap_id AS 'ts'
FROM z_tab_invoice 
LEFT JOIN  tab_catal_comm_dep ON z_tab_invoice.business = tab_catal_comm_dep.id
LEFT JOIN  tab_access ON z_tab_invoice.manager=tab_access.id
LEFT JOIN  tab_klients  kli ON z_tab_invoice.client=kli.id
LEFT JOIN z_tab_catal_type_budget  ON z_tab_invoice.articl_budget 
=z_tab_catal_type_budget.id
LEFT JOIN tab_town ON z_tab_invoice.town =  tab_town.id
LEFT JOIN tab_catal_dogovor ON z_tab_invoice.num_dogovor=tab_catal_dogovor.id
LEFT JOIN z_connecttable ON tab_catal_dogovor.id = z_connecttable.tab_b_id
LEFT JOIN z_tab_klients provider ON z_connecttable.tab_a_id = provider.id
WHERE z_tab_invoice.type_docum = '2' AND z_connecttable.tab_b like 
'tab_catal_dogovor' AND z_connecttable.tab_a like 'z_tab_klients' AND 
z_tab_invoice.not_incl_in_kreestr = '0')
ORDER BY ts DESC