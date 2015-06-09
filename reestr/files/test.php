<?php

$str="2 3 56 ";
$str=rtrim($str);
echo $str, "<br>";
$list=explode(" ", $str);
print_r($list);
echo "<br>";
foreach($list as $value)
{
    $str="INSERT INTO `klients`.`z_confirmation` (`id`, `persona`, `sheet`, `sheet_id`, `status`, `tmstamp`) VALUES (NULL, 'PERSONA', 'z_tab_invoice', 'IDDOCUM', '$value', CURRENT_TIMESTAMP)";
    echo $str, "<br>";
}
?>