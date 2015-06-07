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
