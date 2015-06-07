# Функция необходимая для отображения общей информации в Системе учета бухдокументов
DROP FUNCTION IF EXISTS `klients`.`BdGetNameOfPartner` //
CREATE FUNCTION `BdGetNameOfPartner` (`tab_name` VARCHAR(250), `idInTab` INT(11) UNSIGNED ) RETURNS VARCHAR(1000) CHARSET cp1251 DETERMINISTIC READS SQL DATA SQL SECURITY INVOKER
  BEGIN
    
    IF tab_name = 'z_tab_invoice' THEN 
        begin
        RETURN   (
               (SELECT CONCAT(`tab_klients`.`client`,', дог: ',`tab_catal_dogovor`.`dogovor`,", ",tab_town.town," ",z_tab_invoice.address,
                   IF (`z_tab_invoice`.`planner_id` = 0,'', concat(', планер: ', CAST(`z_tab_invoice`.`planner_id` AS CHAR)))) AS raz_doc
                   FROM `z_tab_invoice`
                   LEFT JOIN  `tab_catal_dogovor` ON `z_tab_invoice`.`num_dogovor`=`tab_catal_dogovor`.`id`
                   LEFT JOIN `z_connecttable` ON `tab_catal_dogovor`.`id`=`z_connecttable`.`tab_b_id`
                   LEFT JOIN `tab_klients` ON  `z_connecttable`.`tab_a_id`=`tab_klients`.`id`
                   LEFT JOIN tab_town ON z_tab_invoice.town=tab_town.id
                   WHERE z_tab_invoice.id = idInTab  AND `z_connecttable`.`tab_a` like 'tab_klients' AND `z_connecttable`.`tab_b` like 'tab_catal_dogovor' LIMIT 1
               UNION ALL
                SELECT CONCAT(`z_tab_klients`.`client`,", ",tab_town.town," ",z_tab_invoice.address,
                   IF (`z_tab_invoice`.`planner_id` = 0,'', concat(', планер: ', CAST(`z_tab_invoice`.`planner_id` AS CHAR)))) AS raz_doc
                   FROM `z_tab_invoice`
                   LEFT JOIN  `tab_catal_dogovor` ON `z_tab_invoice`.`num_dogovor`=`tab_catal_dogovor`.`id`
                   LEFT JOIN `z_connecttable` ON `tab_catal_dogovor`.`id`=`z_connecttable`.`tab_b_id`
                   LEFT JOIN `z_tab_klients` ON  `z_connecttable`.`tab_a_id`=`z_tab_klients`.`id`
                   LEFT JOIN tab_town ON z_tab_invoice.town=tab_town.id
                   WHERE z_tab_invoice.id = idInTab  AND `z_connecttable`.`tab_a` like 'z_tab_klients' AND `z_connecttable`.`tab_b` like 'tab_catal_dogovor' LIMIT 1)
          );
        end;

    ELSEIF tab_name = 'z_tab_certificate' THEN 
        begin
          RETURN (SELECT CONCAT(`tab_klients`.`client`,', дог: ',`tab_catal_dogovor`.`dogovor`,
                  IF (`z_tab_certificate`.`planner_id` =0,'',concat(', планер: ',CAST(`z_tab_certificate`.`planner_id` AS CHAR))),
                  IF (`z_tab_invoice`.`id` IS NOT null,concat(' (счет: ',z_tab_invoice.num_invoice,' от ',
                                                              CAST(DATE_FORMAT(z_tab_invoice.dt_invoice,'%d.%m.%y') AS CHAR),
                                                              ' оплачен ',CAST(DATE_FORMAT(`z_tab_invoice`.`dt_of_pay`,'%d.%m.%y') AS CHAR),
                                                              ')'),'')
                  ) AS raz_doc
                   FROM `z_tab_certificate`
                   LEFT JOIN  `tab_catal_dogovor` ON `z_tab_certificate`.`dogovor`=`tab_catal_dogovor`.`id`
                   LEFT JOIN `z_connecttable` ON `tab_catal_dogovor`.`id`=`z_connecttable`.`tab_b_id`
                   LEFT JOIN `tab_klients` ON  `z_connecttable`.`tab_a_id`=`tab_klients`.`id`
                   LEFT JOIN `z_tab_invoice` ON `z_tab_certificate`.`num_invoice`=`z_tab_invoice`.`id`
                   WHERE  z_tab_certificate.id_certif = idInTab  AND `z_connecttable`.`tab_a` like 'tab_klients' AND `z_connecttable`.`tab_b` like 'tab_catal_dogovor' LIMIT 1);
        end;

    ELSEIF tab_name = 'z_tab_tax_bill' THEN 
        begin
          RETURN (SELECT CONCAT(`tab_klients`.`client`,', дог: ',`tab_catal_dogovor`.`dogovor`,
                  IF (`z_tab_tax_bill`.`planner_id` =0,'',concat(', планер: ',CAST(`z_tab_tax_bill`.`planner_id` AS CHAR))), 
                  IF (`z_tab_invoice`.`id` IS NOT null,concat(' (счет: ',z_tab_invoice.num_invoice,' от ',
                                                              CAST(DATE_FORMAT(z_tab_invoice.dt_invoice,'%d.%m.%y') AS CHAR),
                                                              ' оплачен ',CAST(DATE_FORMAT(`z_tab_invoice`.`dt_of_pay`,'%d.%m.%y') AS CHAR),
                                                              ')'),'')
                  ) AS raz_doc
                   FROM `z_tab_tax_bill`
                   LEFT JOIN  `tab_catal_dogovor` ON `z_tab_tax_bill`.`dogovor`=`tab_catal_dogovor`.`id`
                   LEFT JOIN `z_connecttable` ON `tab_catal_dogovor`.`id`=`z_connecttable`.`tab_b_id`
                   LEFT JOIN `tab_klients` ON  `z_connecttable`.`tab_a_id`=`tab_klients`.`id`
                   LEFT JOIN `z_tab_invoice` ON `z_tab_tax_bill`.`num_invoice`=`z_tab_invoice`.`id`
                   WHERE  z_tab_tax_bill.id = idInTab  AND `z_connecttable`.`tab_a` like 'tab_klients' AND `z_connecttable`.`tab_b` like 'tab_catal_dogovor' LIMIT 1);
        end;

    ELSE RETURN CONCAT('Error, ', tab_name,' is not allowed as name of table in BdGetNameOfPartner function');
    END IF;
  END //
