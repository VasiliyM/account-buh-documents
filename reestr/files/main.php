<?php
    ini_set('default_charset',"UTF-8");
    // проверка на существование открытой сессии (вставлять во все новые файлы)
    session_start();
    if(!isset($_SESSION["session_username"])) {
        header("location: ../index.html");
    } else {
        $idnik = $_SESSION["session_idusername"];
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="shortcut icon" href="bootstrap/docs/assets/ico/favicon_new.ico">
    <title>ДКП, Датагруп, подтверждение счетов</title>
	<!-- Bootstrap core CSS -->
    <link href="../js/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom styles for this template -->
    <link href="../js/bootstrap/css/starter-template.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link href="../css/jquery.dataTables.css" rel="stylesheet">
    <link href="../css/dataTables.bootstrap.css" rel="stylesheet">
    <link href="../css/dataTables.tableTools.css" rel="stylesheet">
    <!-- Уникальные стили для этой страницы -->
    <link href="../css/main.css" rel="stylesheet">
</head>
<body>


<?php
/*главное меню*/
    require "../includes/header.menu.php";
/*получить имя залогинившегося*/
    require "../includes/constants.php";
    require "get.nameAccess.php";
?>


<div class="well">
<!-- Extra small button group -->
    <div class="page-header">
<!--        <form class="navbar-form navbar-left" role="search">
          <div class="form-group" >
            <input type="text" class="form-control" placeholder="" disabled>
          </div>
          <button type="submit" class="btn btn-primary" disabled >Поиск</button>
        </form>
-->
        <div class="btn-group pull-right">
            <select id="doc" class="form-control" name="document" onchange="selectDocument();">
                <option value="1">Все документы</option>
                <option value="2" selected>Требуется подтверждение менеджера</option>
                <option value="3">Подтвержденные неоплаченные документы</option>
            </select>
        </div>
    </div>
</div>



<div class="panel panel-default">
  <div class="panel-body">


      <!-- DataTable -->
    <table id="table_main" class="display cell-border" cellspacing="0" width="100%">
        <thead>
            <tr>
                <th>№</th>
                <th>Менеджер</th>
                <th>Клиент</th>
                <th>Информация о счете</th>
                <th>Сумма</th>
            </tr>
        </thead>
        <tfoot>
            <tr>
                <th>№</th>
                <th>Менеджер</th>
                <th>Клиент</th>
                <th>Информация о счете</th>
                <th>Сумма</th>
            </tr>
        </tfoot>
    </table>

      <div class="pull-right form-inline">
          <input type="date" class="form-control" name="dt_plan">
          <input type="text" class="form-control" name="description">
          <label for="stat" class="form-control" id="lbl_stat">Выбранным документам присвоить статус:</label>
          <select id="stat" class="form-control" name="status" onchange="javascript:selectStatus();">
          <!--    <option value="Подтвердить оплату">Подтвердить оплату</option>
              <option value="Срочно в оплату">Срочно в оплату</option>
              <option value="Отменен">Отменен</option>
              <option value="Перенесен на следующий день">Перенесен на следующий день</option>
              -->
          </select>
          <button type="button" id="button" class="btn btn-primary">Применить</button>
      </div>

  </div>
</div>
  <div class="alert alert-warning" role="alert">* Документы получившие подтверждение до 15:00 попадут в оплату на следующий день,подтвержденные после 15:00 будут переданны в оплату через день</div>
  </div>
  </div>



  </body>
  <!-- jQuery -->
<script src="../js/jquery-1.11.1.min.js"></script>
<!-- bootstrap -->
<script src="../js/bootstrap/js/bootstrap.min.js"></script>
<!-- DataTables -->
<script src="../js/jquery.dataTables.min.js"></script>
<script src="../js/dataTables.bootstrap.js"></script>
<script src="../js/dataTables.tableTools.min.js"></script>
<!-- my script -->
<script>
    $(document).ready( function (){
        // вернуть ФИО и ID залогиненого
        var idnik = "<?php echo $idnik; ?>";
        var nik = "<?php echo $nik; ?>";
        //console.log(idnik +' - '+ nik);
        // DataTable
        mTable = $('#table_main').DataTable({
            "processing": true,
            "pagingType": "full_numbers",
            "iDisplayLength": 100,
            "ajax": {
                "url": "main.ajax.php?action=2"
            },
            "aoColumns": [
                { "width": "5%" },
                { "width": "10%", "bSortable": false },
                { "width": "20%", "bSortable": false },
                { "width": "55%" },
                { "width": "10%" }
            ],
            "order": [],
            "dom": 'T<"clear">lftrip',
            "tableTools": {
                "sRowSelect":   'multi',
                "aButtons":     [ 'select_all', 'select_none' ]
            },
            "language": {
                "url": '../includes/rassian.json'
            },
            "initComplete": function ( settings, json ) {
                this.api().columns().every(function () {
                    var column = this, idx = column.index();
                    if (idx == 1 || idx == 2) {
                        if (idx == 1) {
                            var nameCol = 'Менеджер';
                            var classCol = 'class="input-sm select-tbl1"'
                        } else {
                            var nameCol = 'Клиент';
                            var classCol = 'class="input-sm select-tbl2"'
                        }
                        var select = $('<select ' + classCol + '><option value="">' + nameCol + '</option></select>')
                            .appendTo($(column.header()).empty())
                            .on('change', function () {
                                var val = $.fn.dataTable.util.escapeRegex(
                                    $(this).val()
                                );

                                column
                                    .search(val ? '^' + val + '$' : '', true, false)
                                    .draw();
                            });

                        column.data().unique().sort().each(function (d, j) {
                            if ( d == nik ) {
                                select.append('<option selected value="' + d + '">' + d + '</option>');
                            }
                            else {
                                select.append('<option value="' + d + '">' + d + '</option>');
                            }
                        });
                    }
                });
            }
        });
        // начальная установка: выбор записей залогиневшегося
        mTable.column( 1 ).search( nik  ).draw( false );
        //выставить начльную дату (NOW + 14 day)
        var d = new Date();
        d.setDate(d.getDate() + 14);
        $('input[name="dt_plan"]').attr("value", d.toISOString().substring(0, 10));
        // заполнить ComboBox "status"
        $.ajax({
            type: "post",
            url: "ajax.sql.combo.php",
            data: { action: 'fillStatus' },
            cache: false,
            success: function(responce) { $('select[name="status"]').html(responce); }
        });
        // BUTTON: отрабатывает клик! по кнопке
        $('#button').click( function () {
            var dt1 = new Date();
            var dt2 = $('input[name="dt_plan"]').val();
            dt2 = new Date(dt2);
            var flag = true;
            if(isNaN(dt2)) {
                alert('Дату необходимо выбрать');
                flag = false;
            } else {
                if (dt2.getFullYear() === dt1.getFullYear() && dt2.getDate() === dt1.getDate() && dt2.getMonth() === dt1.getMonth()) {
                    alert('Дата должна быть больше текущей');
                    flag = false;
                } else {
                    if (dt1 > dt2) {
                        alert('Дата должна быть больше текущей');
                        flag = false;
                    }
                }
            };
            if(flag) {
                var list = '';
                $("tbody tr.selected").each(function () {
                    // список ID выбранных строк
                    var getValue = $(this).find("td:eq(0)").html();
                    list += Number(getValue) + ' ';
                });
                if (list.length > 0) {
                    var num = $('select[name="status"]').val();
                    var dt = $('input[name="dt_plan"]').val();
                    var str = $('input[name="description"]').val();
                    $.ajax({
                        type: "post",
                        url: "ajax.sql.combo.php",
                        data: {action: 'insertStatus', id: list, stat: num, dt: dt, desc: str},
                        cache: false,
                        success: function (responce) {
                            selectDocument();
                        }
                    });
                }
            }
        } );
    }); //$(document).ready

    // отрабатывает ComboBox "document"
    function selectDocument() {
        var num = $('select[name="document"]').val();
        var ajaxURL = 'main.ajax.php?action=' + num;
        mTable.ajax.url( ajaxURL ).load(function() {
            loadInitComplete();
        });
        if (num == 1 || num == 3) {
            //не доступно для изменений
            document.getElementById('lbl_stat').setAttribute("disabled","disabled");
            document.getElementById('stat').setAttribute("disabled","disabled");
            document.getElementById('button').setAttribute("disabled","disabled");
        } else {
            //доступно для изменений
            document.getElementById('lbl_stat').removeAttribute("disabled");
            document.getElementById('stat').removeAttribute("disabled");
            document.getElementById('button').removeAttribute("disabled");
        };
    };
    // вспомогательная: дублирует InitComplete при перезагрузке
    function loadInitComplete() {
        // эта цепочка удаляет все фильтры примененные к DataTable:
        mTable
            .search( '' )
            .columns().search( '' )
            .draw();
        // заполнить select для выбранных полей
        mTable.columns().every( function () {
            var column = this, idx = column.index();
            if(idx == 1 || idx == 2) {
                if (idx == 1) {
                    var nameCol = 'Менеджер';
                    var classCol = 'class="input-sm select-tbl1"'
                } else {
                    var nameCol = 'Клиент';
                    var classCol = 'class="input-sm select-tbl2"'
                }
                var select = $('<select ' + classCol + '><option value="">' + nameCol + '</option></select>')
                    .appendTo($(column.header()).empty())
                    .on('change', function () {
                        var val = $.fn.dataTable.util.escapeRegex(
                            $(this).val()
                        );
                        column
                            .search(val ? '^' + val + '$' : '', true, false)
                            .draw();
                    });
                column.data().unique().sort().each(function (d, j) {
                    select.append('<option value="' + d + '">' + d + '</option>');
                });
            }
        } );
    };
    function selectStatus(){
        var num = $('select[name="status"]').val();
        var d = new Date();
        if(num == 10){
            d.setDate(d.getDate() + 14);
            $('input[name="dt_plan"]').val(d.toISOString().substring(0, 10));
        };
        if(num == 20){
            switch(d.getDay()){
                case 5:
                    d.setDate(d.getDate() + 3);
                    break;
                case 6:
                    d.setDate(d.getDate() + 2);
                    break;
                default:
                    d.setDate(d.getDate() + 1);
                    break;
            };
            $('input[name="dt_plan"]').val(d.toISOString().substring(0, 10));
        };
       // console.log(d.toISOString().substring(0, 10));
    };
</script>
</html>
<?php } ?>