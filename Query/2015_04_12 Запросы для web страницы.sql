SQL запросы:

1.Получить из БДСЭ список менеджеров:
SELECT `id`, `nik` FROM `tab_access` WHERE `activated` = '1' ORDER BY `nik` ASC

2.Получить из БДСЭ список клиентов:
SELECT `id`,`client` FROM `tab_klients` WHERE `type_partn` = '1' ORDER BY `client` ASC 

3.Получить из БДСЭ список статусов которые можно присвоить: 
SELECT `id`,`state` FROM `z_confirm_catal` ORDER BY `z_confirm_catal`.`id` ASC

Основная таблица: 
4.Получить из БД "Все документы"

SET @manager='%';
SET @client='%';
	SELECT z_tab_invoice.id as IDcheta, mang.nik as Mngr,klnt.client as Klient, 
	    Concat (IF(z_tab_invoice.dt_of_pay > '0000-00-00',concat('Опл: ',DATE_FORMAT(z_tab_invoice.dt_of_pay,'%d.%m.%y'),', '), 
	    			IF((SELECT prv.id	FROM `z_confirmation` prv WHERE prv.sheet like 'z_tab_invoice' AND `prv`.`sheet_id` = z_tab_invoice.id LIMIT 1) IS NULL,'','<font color="red">не оплачен</font>, ')),
	    		detail_of_pay,', ',tab_town.town,' ',z_tab_invoice.address,', ',CAST(z_tab_invoice.sap_id AS CHAR),IF(z_tab_invoice.planner_id='0','',concat(', плнр ',
	    	    CAST(z_tab_invoice.planner_id AS CHAR))),', <strong>',
	    	    (SELECT partner.client
				FROM tab_catal_dogovor
					LEFT JOIN `z_connecttable` ON `tab_catal_dogovor`.`id`=`z_connecttable`.`tab_b_id`
    				LEFT JOIN `tab_klients` partner ON  `z_connecttable`.`tab_a_id`=`partner`.`id`
				WHERE  tab_catal_dogovor.id = z_tab_invoice.num_dogovor  AND `z_connecttable`.`tab_a` like 'tab_klients' AND `z_connecttable`.`tab_b` like 'tab_catal_dogovor' LIMIT 1
				UNION ALL
				SELECT z_tab_klients.client
				FROM tab_catal_dogovor
					LEFT JOIN `z_connecttable` ON `tab_catal_dogovor`.`id`=`z_connecttable`.`tab_b_id`
    				LEFT JOIN `z_tab_klients`  ON  `z_connecttable`.`tab_a_id`=`z_tab_klients`.`id`
				WHERE  tab_catal_dogovor.id = z_tab_invoice.num_dogovor  AND `z_connecttable`.`tab_a` like 'z_tab_klients' AND `z_connecttable`.`tab_b` like 'tab_catal_dogovor' LIMIT 1),
	    	     ' счет ',z_tab_invoice.num_invoice,'</strong> от ',DATE_FORMAT(z_tab_invoice.dt_invoice,'%d.%m.%y'),' отв ',otvetstv.nik,', ',z_tab_invoice.description,
	    	     IF ((SELECT prv.id	FROM `z_confirmation` prv WHERE prv.sheet like 'z_tab_invoice' AND `prv`.`sheet_id` = z_tab_invoice.id LIMIT 1) IS NULL,'',
	    	     	(SELECT concat(' (<strong>Статус:</strong> ',z_confirm_catal.state,' ',DATE_FORMAT(z_confirmation.tmstamp,'%d.%m.%y'),', ',whostatus.nik,')')
					FROM `z_confirmation`
					LEFT JOIN tab_access whostatus ON z_confirmation.persona=whostatus.id
					LEFT JOIN  z_confirm_catal ON z_confirmation.status=z_confirm_catal.id 
					WHERE z_confirmation.sheet like 'z_tab_invoice' AND `z_confirmation`.`sheet_id` = z_tab_invoice.id ORDER BY z_confirmation.tmstamp DESC LIMIT 1)
	    	     	) 
	    	     ) as Info, 
	   z_tab_invoice.summa as SumScheta
FROM `z_tab_invoice` 
LEFT JOIN tab_access mang ON z_tab_invoice.manager=mang.id
LEFT JOIN tab_klients klnt ON z_tab_invoice.client=klnt.id
LEFT JOIN tab_town ON z_tab_invoice.town = tab_town.id
LEFT JOIN tab_access otvetstv ON z_tab_invoice.responsible=otvetstv.id
WHERE `type_docum` = 2 AND z_tab_invoice.manager LIKE @manager AND z_tab_invoice.client LIKE @client 
ORDER BY klnt.client ASC, z_tab_invoice.sap_id DESC


5.Получить из БД счета "Требуется подтверждение менеджера"
SET @manager='%';
SET @client='%';
	SELECT z_tab_invoice.id as IDcheta, mang.nik as Mngr,klnt.client as Klient, 
	    Concat (IF(z_tab_invoice.dt_of_pay > '0000-00-00',concat('Опл: ',DATE_FORMAT(z_tab_invoice.dt_of_pay,'%d.%m.%y'),', '), 
	    			IF((SELECT prv.id	FROM `z_confirmation` prv WHERE prv.sheet like 'z_tab_invoice' AND `prv`.`sheet_id` = z_tab_invoice.id LIMIT 1) IS NULL,'','<font color="red">не оплачен</font>, ')),
	    		detail_of_pay,', ',tab_town.town,' ',z_tab_invoice.address,', ',CAST(z_tab_invoice.sap_id AS CHAR),IF(z_tab_invoice.planner_id='0','',concat(', плнр ',
	    	    CAST(z_tab_invoice.planner_id AS CHAR))),', <strong>',
	    	    (SELECT partner.client
				FROM tab_catal_dogovor
					LEFT JOIN `z_connecttable` ON `tab_catal_dogovor`.`id`=`z_connecttable`.`tab_b_id`
    				LEFT JOIN `tab_klients` partner ON  `z_connecttable`.`tab_a_id`=`partner`.`id`
				WHERE  tab_catal_dogovor.id = z_tab_invoice.num_dogovor  AND `z_connecttable`.`tab_a` like 'tab_klients' AND `z_connecttable`.`tab_b` like 'tab_catal_dogovor' LIMIT 1
				UNION ALL
				SELECT z_tab_klients.client
				FROM tab_catal_dogovor
					LEFT JOIN `z_connecttable` ON `tab_catal_dogovor`.`id`=`z_connecttable`.`tab_b_id`
    				LEFT JOIN `z_tab_klients`  ON  `z_connecttable`.`tab_a_id`=`z_tab_klients`.`id`
				WHERE  tab_catal_dogovor.id = z_tab_invoice.num_dogovor  AND `z_connecttable`.`tab_a` like 'z_tab_klients' AND `z_connecttable`.`tab_b` like 'tab_catal_dogovor' LIMIT 1),
	    	     ' счет ',z_tab_invoice.num_invoice,'</strong> от ',DATE_FORMAT(z_tab_invoice.dt_invoice,'%d.%m.%y'),' отв ',otvetstv.nik,', ',z_tab_invoice.description,
	    	     IF ((SELECT prv.id	FROM `z_confirmation` prv WHERE prv.sheet like 'z_tab_invoice' AND `prv`.`sheet_id` = z_tab_invoice.id LIMIT 1) IS NULL,'',
	    	     	(SELECT concat(' (<strong>Статус:</strong> ',z_confirm_catal.state,' ',DATE_FORMAT(z_confirmation.tmstamp,'%d.%m.%y'),', ',whostatus.nik,')')
					FROM `z_confirmation`
					LEFT JOIN tab_access whostatus ON z_confirmation.persona=whostatus.id
					LEFT JOIN  z_confirm_catal ON z_confirmation.status=z_confirm_catal.id 
					WHERE z_confirmation.sheet like 'z_tab_invoice' AND `z_confirmation`.`sheet_id` = z_tab_invoice.id ORDER BY z_confirmation.tmstamp DESC LIMIT 1)
	    	     	) 	
	    	     ) as Info, 
	   z_tab_invoice.summa as SumScheta
FROM `z_tab_invoice` 
LEFT JOIN tab_access mang ON z_tab_invoice.manager=mang.id
LEFT JOIN tab_klients klnt ON z_tab_invoice.client=klnt.id
LEFT JOIN tab_town ON z_tab_invoice.town = tab_town.id
LEFT JOIN tab_access otvetstv ON z_tab_invoice.responsible=otvetstv.id
WHERE `type_docum` = 2 AND z_tab_invoice.manager LIKE @manager AND z_tab_invoice.client LIKE @client AND z_tab_invoice.dt_of_pay = '0000-00-00'
	  AND (((SELECT prv.status	FROM `z_confirmation` prv WHERE prv.sheet like 'z_tab_invoice' AND `prv`.`sheet_id` = z_tab_invoice.id LIMIT 1) IS NULL)
	  		OR ((SELECT prv.status	FROM `z_confirmation` prv WHERE prv.sheet like 'z_tab_invoice' AND `prv`.`sheet_id` = z_tab_invoice.id ORDER by prv.tmstamp DESC LIMIT 1) IN (50)) )
ORDER BY klnt.client ASC, z_tab_invoice.sap_id DESC;

6.Получить из БД счета "Подтвержденные не оплаченные документы"

SET @manager='%';
SET @client='%';
	SELECT z_tab_invoice.id as IDcheta, mang.nik as Mngr,klnt.client as Klient, 
	    Concat (IF(z_tab_invoice.dt_of_pay > '0000-00-00',concat('Опл: ',DATE_FORMAT(z_tab_invoice.dt_of_pay,'%d.%m.%y'),', '), 
	    			IF((SELECT prv.id	FROM `z_confirmation` prv WHERE prv.sheet like 'z_tab_invoice' AND `prv`.`sheet_id` = z_tab_invoice.id LIMIT 1) IS NULL,'','<font color="red">не оплачен</font>, ')),
	    		detail_of_pay,', ',tab_town.town,' ',z_tab_invoice.address,', ',CAST(z_tab_invoice.sap_id AS CHAR),IF(z_tab_invoice.planner_id='0','',concat(', плнр ',
	    	    CAST(z_tab_invoice.planner_id AS CHAR))),', <strong>',
	    	    (SELECT partner.client
				FROM tab_catal_dogovor
					LEFT JOIN `z_connecttable` ON `tab_catal_dogovor`.`id`=`z_connecttable`.`tab_b_id`
    				LEFT JOIN `tab_klients` partner ON  `z_connecttable`.`tab_a_id`=`partner`.`id`
				WHERE  tab_catal_dogovor.id = z_tab_invoice.num_dogovor  AND `z_connecttable`.`tab_a` like 'tab_klients' AND `z_connecttable`.`tab_b` like 'tab_catal_dogovor' LIMIT 1
				UNION ALL
				SELECT z_tab_klients.client
				FROM tab_catal_dogovor
					LEFT JOIN `z_connecttable` ON `tab_catal_dogovor`.`id`=`z_connecttable`.`tab_b_id`
    				LEFT JOIN `z_tab_klients`  ON  `z_connecttable`.`tab_a_id`=`z_tab_klients`.`id`
				WHERE  tab_catal_dogovor.id = z_tab_invoice.num_dogovor  AND `z_connecttable`.`tab_a` like 'z_tab_klients' AND `z_connecttable`.`tab_b` like 'tab_catal_dogovor' LIMIT 1),
	    	     ' счет ',z_tab_invoice.num_invoice,'</strong> от ',DATE_FORMAT(z_tab_invoice.dt_invoice,'%d.%m.%y'),' отв ',otvetstv.nik,', ',z_tab_invoice.description,
	    	     IF ((SELECT prv.id	FROM `z_confirmation` prv WHERE prv.sheet like 'z_tab_invoice' AND `prv`.`sheet_id` = z_tab_invoice.id LIMIT 1) IS NULL,'',
	    	     	(SELECT concat(' (<strong>Статус:</strong> ',z_confirm_catal.state,' ',DATE_FORMAT(z_confirmation.tmstamp,'%d.%m.%y'),', ',whostatus.nik,')')
					FROM `z_confirmation`
					LEFT JOIN tab_access whostatus ON z_confirmation.persona=whostatus.id
					LEFT JOIN  z_confirm_catal ON z_confirmation.status=z_confirm_catal.id 
					WHERE z_confirmation.sheet like 'z_tab_invoice' AND `z_confirmation`.`sheet_id` = z_tab_invoice.id ORDER BY z_confirmation.tmstamp DESC LIMIT 1)
	    	     	) 
	    	     ) as Info, 
	   z_tab_invoice.summa as SumScheta
FROM `z_tab_invoice` 
LEFT JOIN tab_access mang ON z_tab_invoice.manager=mang.id
LEFT JOIN tab_klients klnt ON z_tab_invoice.client=klnt.id
LEFT JOIN tab_town ON z_tab_invoice.town = tab_town.id
LEFT JOIN tab_access otvetstv ON z_tab_invoice.responsible=otvetstv.id
WHERE `type_docum` = 2 AND z_tab_invoice.manager LIKE @manager AND z_tab_invoice.client LIKE @client 
	   AND (SELECT prv.status	FROM `z_confirmation` prv WHERE prv.sheet like 'z_tab_invoice' AND `prv`.`sheet_id` = z_tab_invoice.id ORDER BY prv.tmstamp DESC  LIMIT 1) NOT IN (30,50)
	   AND z_tab_invoice.dt_of_pay = '0000-00-00'
ORDER BY klnt.client ASC, z_tab_invoice.sap_id DESC;