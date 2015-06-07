# Функция необходимая для отображения информации  о счете в Системе учета бух документов 
DROP FUNCTION IF EXISTS `klients`.`BdGetChetInfo` //
CREATE FUNCTION `BdGetChetInfo` (`idInTab` INT(11) UNSIGNED ) RETURNS VARCHAR(2000) CHARSET cp1251 DETERMINISTIC READS SQL DATA SQL SECURITY INVOKER
  BEGIN
      RETURN (SELECT CONCAT ('№сч: ',`z_tab_invoice`.`num_invoice`,", ",CAST(DATE_FORMAT(z_tab_invoice.dt_invoice,'%d.%m.%y') AS CHAR),", сумма: ",CAST(`z_tab_invoice`.`summa` AS CHAR),' грн',
                              IF(`z_tab_invoice`.`type_docum` = '1',CAST(concat(', ежемес.услуга за ',z_tab_invoice.month_pay,'.',z_tab_invoice.year_pay) AS CHAR),''),
                              IF(`z_tab_invoice`.`dt_of_pay`='0000-00-00','',concat(', опл: ',CAST(DATE_FORMAT(`z_tab_invoice`.`dt_of_pay`,'%d.%m.%y') AS CHAR))),
                              IF(`z_tab_invoice`.`reestr_num` = '','',concat(', реестр ',`z_tab_invoice`.`reestr_num`)),
                              IF(`z_tab_invoice`.`not_incl_in_reestr` = '1',', реестр-не включать','')
                              ,', отв: ',tab_access.nik,' ',z_tab_invoice.inv_copy_or_orig,', ',
                              z_tab_invoice.description
                              ) AS Schet
    FROM  `z_tab_invoice` 
    LEFT JOIN tab_access ON   z_tab_invoice.responsible=tab_access.id
    WHERE  z_tab_invoice.id = idInTab);
END //


# Функция необходимая для отображения информации  о Акте в Системе учета бух документов 
DROP FUNCTION IF EXISTS `klients`.`BdGetAktInfo` //
CREATE FUNCTION `BdGetAktInfo` (`idInTab` INT(11) UNSIGNED ) RETURNS VARCHAR(2000) CHARSET cp1251 DETERMINISTIC READS SQL DATA SQL SECURITY INVOKER
  BEGIN
    DECLARE Act VARCHAR(600);
        SELECT CONCAT ('№акт: ',`z_tab_certificate`.`num_certif`,", ",CAST(DATE_FORMAT(z_tab_certificate.dt_certif,'%d.%m.%y') AS CHAR),
                ', ',CAST(z_tab_certificate.certif_pay AS CHAR),' грн',
                IF(`z_tab_certificate`.`not_incl_in_reestr` = '1',', реестр-не включать',''),
                IF(`z_tab_certificate`.`num_reestr` = '','',concat(', реестр ',CAST(`z_tab_certificate`.`num_reestr` AS CHAR))),
                IF(`z_tab_certificate`.`dt_out_to_buh` = '0000-00-00','',concat(' от ',CAST(DATE_FORMAT(`z_tab_certificate`.`dt_out_to_buh`,'%d.%m.%y') AS CHAR))),
                ', ',z_tab_certificate.description
                ) INTO Act
        FROM z_tab_certificate WHERE  z_tab_certificate.id_certif = idInTab LIMIT 1;
    IF Act <> 'NULL' THEN RETURN Act;
    ELSE RETURN '...';
    END IF;
  END //

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
