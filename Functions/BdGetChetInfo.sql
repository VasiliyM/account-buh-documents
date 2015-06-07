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
