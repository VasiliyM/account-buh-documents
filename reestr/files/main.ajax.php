<?php
ini_set('default_charset',"UTF-8");
if(!isset($_GET["action"])) {
    //Return result to
    $out = array('data' => []);
    echo json_encode($out); }
  else {
      require "../includes/constants.php";
//Open database connection
      $mysqli = mysqli_connect($host, $user, $password, $db);
      /* проверка подключения */
      if (mysqli_connect_errno()) {
          printf("Не удалось подключиться: %s\n", mysqli_connect_error());
          exit();
      };
// подставить менеджера
      session_start();
      $manager="%";
      $client="%";
// для русской кодировки
      mysqli_query($mysqli, "SET NAMES utf8");
// SQL запрос
      switch($_GET["action"]) {
        case 1:
            $sql = "SELECT z_tab_invoice.id as IDcheta, mang.nik as Mngr,klnt.client as Klient,
                        Concat (IF(z_tab_invoice.dt_of_pay > '0000-00-00',concat('Опл: ',DATE_FORMAT(z_tab_invoice.dt_of_pay,'%d.%m.%y'),', '),
                                IF((SELECT prv.id	FROM `z_confirmation` prv WHERE prv.sheet like 'z_tab_invoice' AND `prv`.`sheet_id` = z_tab_invoice.id LIMIT 1) IS NULL,'','<font color=\'red\'>не оплачен</font>, ')),
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
                              )	as Info,
                        z_tab_invoice.summa as SumScheta
                    FROM `z_tab_invoice`
                    LEFT JOIN tab_access mang ON z_tab_invoice.manager=mang.id
                    LEFT JOIN tab_klients klnt ON z_tab_invoice.client=klnt.id
                    LEFT JOIN tab_town ON z_tab_invoice.town = tab_town.id
                    LEFT JOIN tab_access otvetstv ON z_tab_invoice.responsible=otvetstv.id
                    WHERE `type_docum` = 2 AND z_tab_invoice.manager LIKE '$manager' AND z_tab_invoice.client LIKE '$client'
                    ORDER BY klnt.client ASC, z_tab_invoice.sap_id DESC";
            break;

        case 2:
            $sql = "SELECT z_tab_invoice.id as IDcheta, mang.nik as Mngr,klnt.client as Klient,
                    Concat (IF(z_tab_invoice.dt_of_pay > '0000-00-00',concat('Опл: ',DATE_FORMAT(z_tab_invoice.dt_of_pay,'%d.%m.%y'),', '),
                                IF((SELECT prv.id	FROM `z_confirmation` prv WHERE prv.sheet like 'z_tab_invoice' AND `prv`.`sheet_id` = z_tab_invoice.id LIMIT 1) IS NULL,'','<font color=\"red\">не оплачен</font>, ')),
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
                    WHERE `type_docum` = 2 AND z_tab_invoice.manager LIKE '$manager' AND z_tab_invoice.client LIKE '$client' AND z_tab_invoice.dt_of_pay = '0000-00-00' AND z_tab_invoice.not_incl_in_kreestr = 0
                          AND (((SELECT prv.status	FROM `z_confirmation` prv WHERE prv.sheet like 'z_tab_invoice' AND `prv`.`sheet_id` = z_tab_invoice.id LIMIT 1) IS NULL)
                                OR ((SELECT prv.status	FROM `z_confirmation` prv WHERE prv.sheet like 'z_tab_invoice' AND `prv`.`sheet_id` = z_tab_invoice.id ORDER by prv.tmstamp DESC LIMIT 1) IN (50)) )
                    ORDER BY klnt.client ASC, z_tab_invoice.sap_id DESC";
            break;

        case 3:
            $sql = "SELECT z_tab_invoice.id as IDcheta, mang.nik as Mngr,klnt.client as Klient,
                    Concat (IF(z_tab_invoice.dt_of_pay > '0000-00-00',concat('Опл: ',DATE_FORMAT(z_tab_invoice.dt_of_pay,'%d.%m.%y'),', '),
                                IF((SELECT prv.id	FROM `z_confirmation` prv WHERE prv.sheet like 'z_tab_invoice' AND `prv`.`sheet_id` = z_tab_invoice.id LIMIT 1) IS NULL,'','<font color=\"red\">не оплачен</font>, ')),
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
                    WHERE `type_docum` = 2 AND z_tab_invoice.manager LIKE '$manager' AND z_tab_invoice.client LIKE '$client'
                           AND (SELECT prv.status	FROM `z_confirmation` prv WHERE prv.sheet like 'z_tab_invoice' AND `prv`.`sheet_id` = z_tab_invoice.id ORDER BY prv.tmstamp DESC  LIMIT 1) NOT IN (30,50)
                           AND z_tab_invoice.dt_of_pay = '0000-00-00'
                    ORDER BY klnt.client ASC, z_tab_invoice.sap_id DESC";
            break;

    }; //switch
    $result = mysqli_query($mysqli, $sql);
//Add all records to an array
    while ($row = mysqli_fetch_array($result, MYSQL_NUM)) {
        if( is_null($row[2]) ) { $row[2]=''; };
        if( is_null($row[3]) ) { $row[3]=''; };
        $rows[] = $row;
    };
    mysqli_free_result($result);
    mysqli_close($mysqli);
//Return result to
    if(!empty($rows)) {
        $out = array('data' => $rows);
    } else {
        $out = array('data' => []);
    }
    echo json_encode($out);
}
?>