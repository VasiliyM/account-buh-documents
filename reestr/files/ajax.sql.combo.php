<?php
ini_set('default_charset',"UTF-8");
/*Open database connection*/
require "../includes/constants.php";
/* проверка подключения */
$mysqli = mysqli_connect($host,$user,$password,$db);
if (mysqli_connect_errno()) {
    printf("Не удалось подключиться: %s\n", mysqli_connect_error());
    exit();
}
// для русской кодировки
mysqli_query($mysqli, "SET NAMES utf8");
/* запрос, в зависимости от параметра */
switch($_POST['action']) {
    /* заполнить стаусами */
    case "fillStatus":
        $sql = "SELECT id,state FROM z_confirm_catal ORDER BY id ASC";
        $res = mysqli_query($mysqli, $sql) or die(mysqli_error($mysqli));
        while ($row = mysqli_fetch_array($res, MYSQLI_ASSOC)) {
            echo '<option value="' . $row['id'] . '">' . $row['state'] . '</option>';
        };
        mysqli_free_result($res);
        break;
    /* добавить статус счету */
    case "insertStatus":
        /* Open session */
        session_start();
        $persona=$_SESSION['session_idusername'];
        $stat = htmlentities(mysqli_real_escape_string($mysqli, $_POST['stat']));;
        $dt = htmlentities(mysqli_real_escape_string($mysqli, date("Y-m-d", strtotime($_POST['dt']))));
        $desc = htmlentities(mysqli_real_escape_string($mysqli, $_POST['desc']));;
        $str=rtrim($_POST['id']);
        $list=explode(" ", $str);
        foreach($list as $value)
        {
            $sql = "INSERT INTO z_confirmation (id, persona, sheet, sheet_id, status, tmstamp) VALUES (NULL, '$persona', 'z_tab_invoice', '$value', '$stat', CURRENT_TIMESTAMP)";
            mysqli_query($mysqli, $sql) or die(mysqli_error($mysqli));
            if($desc == ''){
                $sql = "UPDATE z_tab_invoice SET dt_plan_of_pay='$dt' WHERE z_tab_invoice.id ='$value'";
            } else {
                $sql = "UPDATE z_tab_invoice SET dt_plan_of_pay='$dt', description = CONCAT(description,', ','$desc') WHERE z_tab_invoice.id ='$value'";
            }
            mysqli_query($mysqli, $sql) or die(mysqli_error($mysqli));
        };
        echo "Ok!";
        break;
};
mysqli_close($mysqli);
?>