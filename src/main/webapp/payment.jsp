<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Point Of Sales | Dashboard</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="container">
    <div class="row">
        <div class="col-md-12">
            <div class="wrapper">
                <!-- Content Wrapper. Contains page content -->
                <div class="content-wrapper">
                    <!-- Content Header (Page header) -->
                    <section class="content-header">
                        <h1>
                            Payment
                        </h1>
                        <ol class="breadcrumb">
                            <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
                            <li class="active">Payment</li>
                        </ol>
                    </section>

                    <!-- Main content -->
                    <section class="content">
                        <div class="row">
                            <!-- left column -->
                            <div class="col-md-12">
                                <!-- general form elements -->
                                <div class="box box-primary">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">Add Payment</h3>
                                    </div>
                                    <!-- /.box-header -->
                                    <!-- form start -->
                                    <form role="form" id="payment-form">
                                        <div class="box-body">

                                            <div class="form-group">
                                                <label>Payment ID</label>
                                                <input type="text" class="form-control" id="id"
                                                       placeholder="Enter Payment ID" disabled>
                                            </div>
                                            <div class="form-group">
                                                <label>Description</label>
                                                <input type="text" class="form-control" id="description"
                                                       name="description"
                                                       placeholder="Enter Description" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Unit Price</label>
                                                <input type="number" class="form-control" id="unitPrice" name="unitPrice"
                                                       placeholder="Enter Unit Price" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Quantity</label>
                                                <input type="number" class="form-control" id="qtyOnHand" name="qtyOnHand"
                                                       placeholder="Enter Quantity" required>
                                            </div>

                                        </div>
                                        <!-- /.box-body -->
                                        <div class="box-footer" style="text-align: left">
                                            <button type="submit" class="btn btn-primary" id="btnSave"
                                                    >Save
                                            </button>
                                            <button type="reset" class="btn btn-primary" style="margin-left:30px">
                                                Clear
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                            <div class="col-md-12">
                                <div class="box">
                                    <div class="box-header">
                                        <h3 class="box-title">Payment Information</h3>
                                    </div>
                                    <!-- /.box-header -->
                                    <div class="box-body">
                                        <table id="payment-table" class="table table-bordered table-hover">
                                            <thead>
                                            <tr>
                                                <th>Payment ID</th>
                                                <th>Description</th>
                                                <th>Unit Price</th>
                                                <th>Quantity</th>
                                                <th>Remove</th>
                                            </tr>
                                            </thead>
                                            <tbody>

                                            </tbody>

                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>
                    <!-- /.content -->
                </div>
                <!-- /.content-wrapper -->

                <footer class="main-footer">
                    <!-- Default to the left -->
                </footer>
            </div>
        </div>
    </div>
</div>

<!-- ./wrapper -->

<!-- jQuery 2 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.0/jquery.validate.min.js"></script>
<script>
    $(document).ready(function () {
        var SERVER_URL = "http://localhost:8080";
        $("#payment-form").submit(function(e) {
            e.preventDefault();
            save();
        });
        function save() {
            var item = {
                id: $("#id").val(),
                description: $("#description").val(),
                unitPrice: $("#unitPrice").val(),
                qtyOnHand: $("#qtyOnHand").val()
            };
            var ajaxConfig = {
                method: item.id ? "PUT" : "POST",
                url: SERVER_URL + "/api/v1/payment",
                async: true,
                contentType: "application/json",
                data: JSON.stringify(item)
            };
            $.ajax(ajaxConfig).done(function (response, statusText, jxhr) {
                alert("Updated Successfully");
                loadAllPayment();
                $("#payment-form").reset();
            }).fail(function (jxhr, statusText, error) {
                alert("Unable to update the Payment, try again");
                console.log(error);
            });
        }

        $(document).on("click", ".btn-warning", function () {
            var row = $(this).closest('tr').data('payment');
            $("#id").val(row.id);
            $("#description").val(row.description);
            $("#unitPrice").val(row.unitPrice);
            $("#qtyOnHand").val(row.qtyOnHand);
        });

        $(document).on("click", ".btn-danger", function () {
            var row = $(this).closest('tr').data('payment');
            var ajaxConfig = {
                method: "DELETE",
                url: SERVER_URL + "/api/v1/payment/" + row.id
            };
            $.ajax(ajaxConfig).done(function (response, statusText, jxhr) {
                alert("Delete Successfull");
                loadAllPayment();
            }).fail(function (jxhr, statusText, error) {
                alert("Unable to Delete the Payment, try again");
                console.log(error);
            });
        });

        var loadAllPayment = function () {
            var table = $("#payment-table tbody");
            $.getJSON(SERVER_URL + "/api/v1/payment", function (data) {
                table.empty();
                $.each(data, function (key, row) {
                    var tblrow = $('<tr><td>' + row.id + '</td>' +
                        '<td>' + row.description + '</td>' +
                        '<td>' + row.unitPrice + '</td>' +
                        '<td>' + row.qtyOnHand + '</td>' +
                        '<td class="text-center"><button class="btn btn-warning btn-sm">EDIT</button>' +
                        '&nbsp;<button class="btn btn-danger btn-sm">DEL</button></td></tr>');
                    tblrow.closest('tr').data('payment', row);
                    table.append(tblrow);
                });
            })
        };

        loadAllPayment();
    });
</script>
</body>
</html>