<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="exportExcel.ascx.cs" Inherits="Milton.Modules.eClaim.exportExcel" %>
<%@ Register TagPrefix="dnn" Namespace="DotNetNuke.Web.Client.ClientResourceManagement" Assembly="DotNetNuke.Web.Client" %>
<dnn:DnnJsInclude runat="server" FilePath="~/Plug-in/DataTables/media/js/jquery.dataTables.min.js" />
<dnn:DnnJsInclude runat="server" FilePath="~/Plug-in/DataTables/extensions/TableTools/js/dataTables.tableTools.min.js" />
<dnn:DnnCssInclude runat="server" FilePath="~/Plug-in/DataTables/media/css/jquery.dataTables.css" />
<dnn:DnnCssInclude runat="server" FilePath="~/Plug-in/DataTables/extensions/TableTools/css/dataTables.tableTools.css" />
<!-- for range date picker-->
<%--<dnn:DnnCssInclude runat="server" FilePath="./js/font-awesome.min.css" />
<dnn:DnnCssInclude runat="server" FilePath="./js/daterangepicker.min.css" />
<dnn:DnnJsInclude runat="server" FilePath="./js/moment.min.js" />
<dnn:DnnJsInclude runat="server" FilePath="./js/jquery.daterangepicker.min.js" />--%>

<link rel="stylesheet" href="/DesktopModules/eClaim/js/font-awesome.min.css" />
<link rel="stylesheet" href="/DesktopModules/eClaim/js/daterangepicker.min.css" />
<script src="/DesktopModules/eClaim/js/moment.min.js" type="text/javascript"></script>
<script src="/DesktopModules/eClaim/js/jquery.daterangepicker.min.js"></script>


<asp:HiddenField ID="hfSubmitedForm" runat="server" />
<asp:HiddenField ID="hfSubmitedFormDetails" runat="server" />

<asp:HiddenField ID="hfBU" runat="server" />
<asp:HiddenField ID="hfFormType" runat="server" />
<asp:HiddenField ID="hfCostType" runat="server" />
<asp:HiddenField ID="hfCurrency" runat="server" />
<asp:HiddenField ID="hfGSTCode" runat="server" />
<asp:HiddenField ID="hfTransportationType" runat="server" />

<style>
#sumitedList .tg  {
	border-collapse:collapse;
	border-spacing:0;
}
#sumitedList .tg td{
	font-family:Arial, sans-serif;
	font-size:14px;
	padding:4px 20px;
	border-style:solid;
	border-width:1px;
	overflow:hidden;
	word-break:normal;
}
#sumitedList .tg th{
	font-family:Arial, sans-serif;
	font-size:14px;
	font-weight:normal;
	padding:4px 20px;
	border-style:solid;
	border-width:1px;
	overflow:hidden;
	word-break:normal;
}
#sumitedList td,th{
	vertical-align:top
}
</style>
<%--<input id="inputReceipt" type="text" name="" style="width: 190px">&nbsp;&nbsp;<input id="btnReceipt" type="button" name="name" value="Export by Receipt day" class="dnnPrimaryAction" /><br />
<input id="inputSubmission" type="text" name="" style="width: 190px">&nbsp;&nbsp;<input id="btnSubmission" type="button" name="name" value="Export by Submit. day" class="dnnPrimaryAction" /><br />--%>
<input id="btnExcel" type="button" name="name" value="Export Excel" class="dnnPrimaryAction" />
<table id="SumitedForm" style="width:100%"></table>
<table id="hiddenTable"></table>

<iframe id="txtArea1" style="display:none"></iframe>
<script>
    $(document).ready(function () {
        //start (for export Excel by day range)
        //$('#inputReceipt').dateRangePicker();
        //$('#inputSubmission').dateRangePicker();
        //end (for export Excel by day range)

        var jsSubmitedForm = JSON.parse($("#<%=hfSubmitedForm.ClientID%>").val());
        
        var rowSubmitedForm = "";
        rowSubmitedForm += "<thead><tr>\
                                <th>Control</th>\
                                <th>Submission Date</th>\
                                <th>BU</th>\
                                <th>Created By</th>\
                                <th>Claim Form Type</th>\
                            </tr></thead><tbody>"
        for (var i = 0; i < jsSubmitedForm.length; i++) {
            rowSubmitedForm += "<tr><td><input type='checkbox' id='cbExcel' value=" + i + "></td>";
            rowSubmitedForm += "<td>" + unix_to_readable(jsSubmitedForm[i].SubmissionDate) + "</td>";
            rowSubmitedForm += "<td>" + jsSubmitedForm[i].BusinessUnit + "</td>";
            rowSubmitedForm += "<td>" + jsSubmitedForm[i].CreatedBy + "</td>";
            rowSubmitedForm += "<td>" + displayFormType(jsSubmitedForm[i]) + "</td>";
            rowSubmitedForm += "</tr>";
        }
        rowSubmitedForm += "</tbody>";
        $('#SumitedForm').append(rowSubmitedForm);

        var dataTable = $("#SumitedForm").DataTable({
            "autoWidth": false,
            "paging": true,
            "iDisplayLength": 10
        });


        function displayFormType(form)
        {
            if (form.ClaimFormType == "P")
            {
                var str = form.ProjectName + " (" + form.JobNo + ")";
                return str;
            }
            else if (form.ClaimFormType == "G")
            {
                return "General Expense";
            } else {
                return form.ClaimFormType;
            }
        }
        function unix_to_readable(timestamp) {
            if (timestamp == null)
                return '';
            timestamp = timestamp.substring(6, timestamp.length - 1)
            var date = new Date(parseInt(timestamp));
            return date.getFullYear() + '-'
                 + ('0' + (date.getMonth() + 1)).slice(-2) + '-'
                 + ('0' + date.getDate()).slice(-2);
        }
        var tempRow = "";
        $('#btnExcel').click(function () {
            var allID = "";
            <%--var jsTransportationType = JSON.parse($("#<%=hfTransportationType.ClientID%>").val());--%>
            $('#hiddenTable').children().remove();
            tempRow = "";
            dataTable.$("#cbExcel:checked", { "page": "all" }).each(function (index, Element) {
                addDetailsToTable($(Element).val());
            });
            //$('#SumitedForm tr').each(function (index, Element) {
            //    if ($(Element).find("#cbExcel").is(':checked')) {
            //        addDetailsToTable($(Element).find("#cbExcel").val());
            //    }
            //});
            $('#hiddenTable').append(tempRow);
            fnExcelReport("hiddenTable");
            $('#hiddenTable').hide();
        });
        function addDetailsToTable(index) {
            var id = jsSubmitedForm[index].ID
            $.ajax({
                type: "GET",
                contentType: "application/json; charset=utf-8",
                url: "/DesktopModules/eClaim/API/Webservices/GetFormDetails?formID=" + id,
                datatype: "JSON",
                async:false,
                success: function (result) {
                //$.getJSON(, function (result) {
                    //var objResult = jQuery.parseJSON(result);
                    var jsBU = JSON.parse($("#<%=hfBU.ClientID%>").val());
                    var jsFormType = JSON.parse($("#<%=hfFormType.ClientID%>").val());
                    var jsCostType = JSON.parse($("#<%=hfCostType.ClientID%>").val());
                    <%--var jsCurrency = JSON.parse($("#<%=hfCurrency.ClientID%>").val());--%>
                    var jsGSTCode = JSON.parse($("#<%=hfGSTCode.ClientID%>").val());
                    //tempRow += "<tr><td>" + unix_to_readable(jsSubmitedForm[index].SubmissionDate) + "</td>";
                    //tempRow += "<td>" + jsSubmitedForm[index].BusinessUnit + "</td>";
                    //tempRow += "<td>" + jsSubmitedForm[index].CreatedBy + "</td>";
                    //tempRow += "<td>" + displayFormType(jsSubmitedForm[index]) + "</td></tr>";
                    var claimedCurr = result.length > 0 ? result[0].ClaimedCurrencyCode : "";
                    tempRow += "<tr>\
                                <td bgcolor='#87AFC6'>Posting Date</td>\
                                <td bgcolor='#87AFC6'>Document Date</td>\
                                <td bgcolor='#87AFC6'>Document No.</td>\
                                <td bgcolor='#87AFC6'>Account Type</td>\
                                <td bgcolor='#87AFC6'>Account No.</td>\
                                <td bgcolor='#87AFC6'>Job No.</td>\
                                <td bgcolor='#87AFC6'>Job Task No.</td>\
                                <td bgcolor='#87AFC6'>Description</td>\
                                <td bgcolor='yellow'>Amount Incl. Tax in " + claimedCurr + "</td>\
                                <td bgcolor='#87AFC6'>Job Quantity</td>\
                                <td bgcolor='#87AFC6'>Employee Code</td>\
                                <td bgcolor='#87AFC6'>Pic Code</td>\
                                <td bgcolor='#87AFC6'>Cost Centre Code</td>\
                                <td bgcolor='#87AFC6'>VAT Prod. Posting Group</td>\
                                <td bgcolor='#87AFC6'>VAT Amount</td>\
                            </tr>"
                    var displayTotal = 0;
                    var displayDesc = "";
                    var displayAccNo = "";
                    for (var i = 0; i < result.length; i++) {
                        displayGSTCode = "";
                        for (var x = 0; x < jsGSTCode.length; x++) {
                            if(jsGSTCode[x].ID==result[i].GSTCode)
                                displayGSTCode = jsGSTCode[x].Code
                        }
                        /*
                        1. all Account Type are G/L Account but the Account No is refer to the “Cost Type” table
                        2. Account Code 62012110 don't have type
                        */
                        displayAccNo = "";
                        for (var y = 0; y < jsCostType.length; y++) {
                            if (jsCostType[y].ID == result[i].CostTypeID) {
                                displayAccNo = jsCostType[y].AccountCode;
                            }
                        }
                    
                        var today = new Date();
                        var dd = today.getDate();
                        var mm = today.getMonth()+1; //January is 0!
                        var yyyy = today.getFullYear();
                        if(dd<10){
                            dd='0'+dd;
                        } 
                        if(mm<10){
                            mm='0'+mm;
                        } 
                        var today = dd + '/' + mm + '/' + yyyy;

                        //if it is the org curr != claimed curr, multiply exchange rate and make the box yellow
                        var cal1 = result[i].AmountWithTax;
                        var cal2 = result[i].TaxAmount;
                        var rowAmountWithTax = "<td>" + cal1 + "</td>";
                        var rowTaxAmount = "<td>" + cal2 + "</td>";
                        if (result[i].OriginalCurrencyCode != claimedCurr) {
                            cal1 = (result[i].AmountWithTax * result[i].ExchangeRate).toFixed("2");
                            cal2 = (result[i].TaxAmount * result[i].ExchangeRate).toFixed("2");
                            rowAmountWithTax = "<td bgcolor='yellow'>" + cal1 + "</td>";
                            rowTaxAmount = "<td bgcolor='yellow'>" + cal2 + "</td>";
                        }
                        //

                        tempRow += "<tr>";
                        tempRow = tempRow + "<td>" + today + "</td>";//OK
                        tempRow = tempRow + "<td>" + today + "</td>";//OK
                        tempRow = tempRow + "<td>" + jsSubmitedForm[index].ProjectName + "</td>";//OK
                        tempRow = tempRow + "<td>" + "G/L Account" + "</td>";//OK
                        tempRow = tempRow + "<td>" + displayAccNo + "</td>";//OK
                        tempRow = tempRow + "<td>" + jsSubmitedForm[index].JobNo + "</td>";//OK
                        tempRow = tempRow + "<td>" + "25010" + "</td>";//OK
                        tempRow = tempRow + "<td>" + result[i].Description + "</td>";//need to enhance
                        //tempRow = tempRow + "<td>" + result[i].OriginalCurrencyCode + "</td>";//OK
                        tempRow = tempRow + rowAmountWithTax//OK
                        displayTotal += parseFloat(cal1);
                        //tempRow = tempRow + "<td>" + result[i].ClaimedCurrencyCode + "</td>";//OK
                        //tempRow = tempRow + "<td>" + result[i].TotalAmount + "</td>";//OK
                        tempRow = tempRow + "<td>" + "1" + "</td>";//OK
                        tempRow = tempRow + "<td>" + "" + "</td>";//OK
                        tempRow = tempRow + "<td>" + "NA" + "</td>";//OK
                        tempRow = tempRow + "<td>" + "OPN" + "</td>";//OK
                        tempRow = tempRow + "<td>" + displayGSTCode + "</td>";//OK
                        tempRow = tempRow + rowTaxAmount//OK
                        tempRow += "</tr>";
                    }
                    displayTotal = (0 - parseFloat(displayTotal)).toFixed('2');//EmployeeCode
                    displayDesc = jsSubmitedForm[index].ClaimFormType == "P" ? jsSubmitedForm[index].JobNo : jsSubmitedForm[index].EmployeeCode;
                    if (displayDesc == null || displayDesc.trim() == "") {
                        displayDesc = "<td bgcolor='red'>Cannot find EmployeeCode, please connect it department.</td>"
                    }else{
                        displayDesc = "<td>" + displayDesc + "</td>";
                    }
                    displayAccNo = jsSubmitedForm[index].AccountNo;
                    if (displayAccNo == null || displayAccNo.trim() == "") {
                        displayAccNo = "<td bgcolor='red'>Cannot find AccountNo, please connect it department.</td>";
                    } else {
                        displayAccNo = "<td>" + displayAccNo + "</td>";
                    }
                    tempRow += "<tr>";
                    tempRow = tempRow + "<td>" + today + "</td>";//OK
                    tempRow = tempRow + "<td>" + today + "</td>";//OK
                    tempRow = tempRow + "<td>" + jsSubmitedForm[index].ProjectName + "</td>";//OK
                    tempRow = tempRow + "<td>" + "Vendor" + "</td>";//OK
                    tempRow = tempRow + displayAccNo;//OK
                    tempRow = tempRow + "<td>" + "" + "</td>";//OK
                    tempRow = tempRow + "<td>" + "" + "</td>";//OK
                    tempRow = tempRow + displayDesc;//OK
                    //tempRow = tempRow + "<td>" + "" + "</td>";//OK
                    tempRow = tempRow + "<td>" + displayTotal + "</td>";//OK
                    //tempRow = tempRow + "<td>" + "" + "</td>";//OK
                    //tempRow = tempRow + "<td>" + "" + "</td>";//OK
                    tempRow = tempRow + "<td>" + "" + "</td>";//OK
                    tempRow = tempRow + "<td>" + "" + "</td>";//OK
                    tempRow = tempRow + "<td>" + "" + "</td>";//OK
                    tempRow = tempRow + "<td>" + "" + "</td>";//OK
                    tempRow = tempRow + "<td>" + "" + "</td>";//OK
                    tempRow = tempRow + "<td>" + "" + "</td>";//OK
                    tempRow += "</tr><tr></tr>";
                }
            });
        }

        function fnExcelReport(tableID) {
            var tab_text = "<table border='2px'><tr><td colspan='10'><h2>If the cell box is in yellow color, it means that the value has multiplied the exchange rate.</h2></td></tr><tr>";
            var textRange; var j = 0;
            tab = document.getElementById(tableID); // id of table

            for (j = 0 ; j < tab.rows.length ; j++) {
                tab_text = tab_text + tab.rows[j].innerHTML + "</tr>";
                //tab_text=tab_text+"</tr>";
            }

            tab_text = tab_text + "</table>";
            tab_text = tab_text.replace(/<A[^>]*>|<\/A>/g, "");//remove if u want links in your table
            tab_text = tab_text.replace(/<img[^>]*>/gi, ""); // remove if u want images in your table
            tab_text = tab_text.replace(/<input[^>]*>|<\/input>/gi, ""); // reomves input params

            var ua = window.navigator.userAgent;
            var msie = ua.indexOf("MSIE ");

            if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./))      // If Internet Explorer
            {
                txtArea1.document.open("txt/html", "replace");
                txtArea1.document.write(tab_text);
                txtArea1.document.close();
                txtArea1.focus();
                sa = txtArea1.document.execCommand("SaveAs", true, "download.xls");
            }
            else               //other browser not tested on IE 11
                sa = window.open('data:application/vnd.ms-excel,' + encodeURIComponent(tab_text));

            return (sa);
        }
    });
</script>