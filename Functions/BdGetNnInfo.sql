  # Функция необходимая для отображения информации  о Налоговой накладной в Системе учета бух документов 
DROP FUNCTION IF EXISTS `klients`.`BdGetNnInfo` //
CREATE FUNCTION `BdGetNnInfo` (`idInTab` INT(11) UNSIGNED ) RETURNS VARCHAR(2000) CHARSET cp1251 DETERMINISTIC READS SQL DATA SQL SECURITY INVOKER
  BEGIN
    DECLARE NN VARCHAR (600);
      SELECT CONCAT ('№НН: ',`z_tab_tax_bill`.`num_taxbill`,", ",CAST(DATE_FORMAT(z_tab_tax_bill.dt_taxbill,'%d.%m.%y') AS CHAR),
                ', ',CAST(z_tab_tax_bill.taxbill_pay AS CHAR),' грн',
                IF(`z_tab_tax_bill`.`not_incl_in_reestr` = '1',', реестр-не включать',''),
                IF(`z_tab_tax_bill`.`num_reestr` = '','',concat(', реестр ',`z_tab_tax_bill`.`num_reestr`)),
                IF(`z_tab_tax_bill`.`dt_out_to_buh` = '0000-00-00','',concat(' от ',CAST(DATE_FORMAT(`z_tab_tax_bill`.`dt_out_to_buh`,'%d.%m.%y') AS CHAR))),
                ', ',z_tab_tax_bill.description
                ) INTO NN
            FROM z_tab_tax_bill WHERE z_tab_tax_bill.id=idInTab LiMIT 1;

    IF NN <> 'NULL' THEN RETURN NN;
    ELSE RETURN '...';
    END IF;
  END //
