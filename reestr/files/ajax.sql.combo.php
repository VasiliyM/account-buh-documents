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
        $sql = "SELECT `id`,`state` FROM `z_confirm_catal` ORDER BY `z_confirm_catal`.`id` ASC";
        $res = mysqli_query($mysqli, $sql);
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
        $stat=$_POST['stat'];
        $str=rtrim($_POST['id']);
        $list=explode(" ", $str);
        foreach($list as $value)
        {
            $sql="INSERT INTO `klients`.`z_confirmation` (`id`, `persona`, `sheet`, `sheet_id`, `status`, `tmstamp`) VALUES (NULL, '$persona', 'z_tab_invoice', '$value', '$stat', CURRENT_TIMESTAMP)";
            if (mysqli_query($mysqli, $sql) === TRUE) {
                $str = "Ok!";
            } else {
                $str = "Error.";
            };
        };
        echo "Ok!";
        break;
};
mysqli_close($mysqli);
?>