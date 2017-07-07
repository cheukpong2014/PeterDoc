<%@ Control Language="C#" AutoEventWireup="True" CodeBehind="ClaimForm.ascx.cs" Inherits="Milton.Modules.eClaim.ClaimForm" %>
<%@ Register TagPrefix="dnn" Namespace="DotNetNuke.Web.Client.ClientResourceManagement" Assembly="DotNetNuke.Web.Client" %>
<%@ Register TagPrefix="dnn" Namespace="DotNetNuke.Web.Client.ClientResourceManagement" Assembly="DotNetNuke.Web.Client" %>

<dnn:DnnCssInclude runat="server" FilePath="http://code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />
<dnn:DnnJsInclude runat="server" FilePath="~/Resources/Shared/scripts/dnn.jquery.js" />
<!--
*
*
*
* Cost Tpye = Expense Type
* Voucher Date = Receipt Date
*
*
*
*
*
*
*
-->

<!--from dnn-->
<asp:HiddenField ID="hfLoginID" runat="server" />
<asp:HiddenField ID="hfLoginRefNo" runat="server" />
<asp:HiddenField ID="hfLoginName" runat="server" />
<asp:HiddenField ID="hfLoginRegion" runat="server" />
<asp:HiddenField ID="hfLoginDepartment" runat="server" />
<asp:HiddenField ID="hfFormID" runat="server" />
<asp:HiddenField ID="hfStatus" runat="server" />
<asp:HiddenField ID="hfCurrDate" runat="server" />
<!--from database table-->
<asp:HiddenField ID="hfBU" runat="server" />
<asp:HiddenField ID="hfFormType" runat="server" />
<asp:HiddenField ID="hfCostType" runat="server" />
<%--<asp:HiddenField ID="hfCurrency" runat="server" />--%>
<asp:HiddenField ID="hfDistCurr" runat="server" />
<asp:HiddenField ID="hfGSTCode" runat="server" />
<asp:HiddenField ID="hfTransportationType" runat="server" />
<!--may not have value-->
<asp:HiddenField ID="hfFormData" runat="server" />
<asp:HiddenField ID="hfFormDetailsData" runat="server" />
<asp:HiddenField ID="hfFormDataCreateBy" runat="server" />
<!--new-->
<asp:HiddenField ID="hfCanEditForm" runat="server" />
<asp:HiddenField ID="hfusingCurrency" runat="server" />
<style>
    div.row{
        display:none;
    }
    .toRight {
        text-align: right;
    }
    #claim1{
        border-collapse:collapse;
    }
    #claim1 th,#claim1 td{
        border: 1px solid black;
    }
    #signtable,#signtable thead,#signtable tr,#signtable th,#signtable td{
        border: 1px solid black;
        border-collapse:collapse;
    }
    #forScrollx{
        overflow-x: scroll;
    }
    #forScrollx input[type="text"], select, textarea, input[type="email"], input[type="search"], input[type="password"]{
        margin: 0px; 
    }
    .absoluteClear{
    }
    .btnToright{
        float:right;
    }
    h2{
        margin-top: 0px;
    }
    .hideTableColumn{
        display:none;
    }
    .hideCostType{
        display:none;
    }
</style>

<script type="text/javascript">
    $(document).ready(function () {
        var jsLoginID = $("#<%=hfLoginID.ClientID%>").val();
        var jsLoginRefNo = $("#<%=hfLoginRefNo.ClientID%>").val();
        var jsLoginName = $("#<%=hfLoginName.ClientID%>").val();
        var jsLoginRegion = $("#<%=hfLoginRegion.ClientID%>").val();
        var jsLoginDepartment = $("#<%=hfLoginDepartment.ClientID%>").val();
        var jsFormID = $("#<%=hfFormID.ClientID%>").val();
        var jsStatus = $("#<%=hfStatus.ClientID%>").val();
        var jsUsingCurrency = $("#<%=hfusingCurrency.ClientID%>").val();

        var jsBU = JSON.parse($("#<%=hfBU.ClientID%>").val());
        var jsFormType = JSON.parse($("#<%=hfFormType.ClientID%>").val());
        var jsCostType = JSON.parse($("#<%=hfCostType.ClientID%>").val());
        <%--var jsCurrency = JSON.parse($("#<%=hfCurrency.ClientID%>").val());--%>
        var jsDistCurr = JSON.parse($("#<%=hfDistCurr.ClientID%>").val());
        var jsGSTCode = JSON.parse($("#<%=hfGSTCode.ClientID%>").val());
        var jsTransportationType = JSON.parse($("#<%=hfTransportationType.ClientID%>").val());

        function rangeDatePicker(from, to) {
            from.datepicker({
                dateFormat: "yy-mm-dd",
                onClose: function (selectedDate) {
                    //var addOneDay = new Date(selectedDate);
                    //addOneDay.setDate(addOneDay.getDate() + 1)
                    if (selectedDate != '')
                        to.datepicker("option", "minDate", selectedDate);
                }
            }).attr('readOnly', 'true');
            to.datepicker({
                dateFormat: "yy-mm-dd",
                onClose: function (selectedDate) {
                    //var subOneDay = new Date(selectedDate);
                    //subOneDay.setDate(subOneDay.getDate() - 1)
                    if (selectedDate != '')
                        from.datepicker("option", "maxDate", selectedDate);
                }
            }).attr('readOnly', 'true');
        }

        function addRowFromAddtable(FormType) {
            addRow(FormType);
            //var tempDate = jsFormDetailsData[i].VoucDate;
            $('#GrandTotal').prev().find(".inputCostType").val($('.atCostType').val());
            $('#GrandTotal').prev().find(".inputVouDate").val($('.atVouDate').val());
            var substringtxt = $('.atCostType :selected').text();
            if (substringtxt.indexOf(":") > 0) {
                substringtxt = substringtxt.substring(substringtxt.indexOf(":") + 2, substringtxt.length);
            }
            $('#GrandTotal').prev().find(".txtCostType").text(substringtxt);
            checkCostType($('#GrandTotal').prev().find(".inputCostType"));
            //var tempDate = jsFormDetailsData[i].PeriodFrom;
            $('#GrandTotal').prev().find(".inputDateFrom").val($('.atDateFrom').val());
            //var tempDate = jsFormDetailsData[i].PeriodTo;
            $('#GrandTotal').prev().find(".inputDateTo").val($('.atDateTo').val());
            $('#GrandTotal').prev().find(".inputLocFrom").val($('.atLocFrom').val());
            $('#GrandTotal').prev().find(".inputLocTo").val($('.atLocTo').val());
            $('#GrandTotal').prev().find(".inputTransType").val($('.atTransType').val());
            $('#GrandTotal').prev().find(".inputDesc").val($('.atDesc').val());
            //var tempBool = (jsFormDetailsData[i].AutoCal == "Y") ? true : false;
            //$('#GrandTotal').prev().find(".inputAutoCal").prop('checked', tempBool);
            $('#GrandTotal').prev().find(".inputOrgCurr").val($('.atOrgCurr').val());
            $('#GrandTotal').prev().find(".inputExcTax").val($('.atExcTax').text());
            $('#GrandTotal').prev().find(".inputTaxAmt").val($('.atTaxAmt').text());
            $('#GrandTotal').prev().find(".inputTaxType").val($('.atTaxType').val());
            $('#GrandTotal').prev().find(".inputIncTax").val($('.atIncTax').val());
            $('#GrandTotal').prev().find(".inputCurr").val($('.atCurr').val());
            $('#GrandTotal').prev().find(".inputRate").val($('.atRate').val());
            $('#GrandTotal').prev().find(".inputTotal").val($('.atTotal').text());
            //var tempBool2 = (jsFormDetailsData[i].IncludeRef == "Y") ? true : false;
            $('#GrandTotal').prev().find(".inputRef").prop('checked', $(".atRef").is(':checked'));
            $('#GrandTotal').prev().find(".inputRemark").val($('.atRemark').val());
        }

        function setAddTable(FormType) {
            var CostTypeOption = "";
            for (var i = 0; i < jsCostType.length; i++) {
                if (FormType == jsCostType[i].FormType) {
                    CostTypeOption += "<option code='" + jsCostType[i].AccountCode + "' value='" + jsCostType[i].ID + "' displayType='" + jsCostType[i].DisplayType + "'>" + jsCostType[i].CostTypeDesc + "</option>";
                }
            }
            var CurrencyOption = "";
            for (var i = 0; i < jsDistCurr.length; i++) {
                CurrencyOption += "<option value='" + jsDistCurr[i].CurrencyCode + "'>" + jsDistCurr[i].CurrencyCode + "</option>";
            }
            var GSTCodeOption = "";
            for (var i = 0; i < jsGSTCode.length; i++) {
                GSTCodeOption += "<option percent='" + jsGSTCode[i].TaxRate + "' value='" + jsGSTCode[i].ID + "'>" + jsGSTCode[i].TaxDesc + "</option>";
            }
            var TransportationTypeOption = "";
            TransportationTypeOption += "<option style='display:none' value='-1'></option>";
            for (var i = 0; i < jsTransportationType.length; i++) {
                TransportationTypeOption += "<option value='" + jsTransportationType[i].ID + "'>" + jsTransportationType[i].TransportationTypeDesc + "</option>";
            }
            $('#addtable .atCostType').children().remove();
            $('#addtable .atTransType').children().remove();
            $('#addtable .atCurr').children().remove();
            $('#addtable .atOrgCurr').children().remove();
            $('#addtable .atTaxType').children().remove();
            $('#addtable atDateFrom').val('');
            $('#addtable atDateTo').val('');
            $('#addtable atLocFrom').val('');
            $('#addtable atLocTo').val('');
            $('#addtable atDesc').val('');

            $('#addtable .atCostType').append(CostTypeOption); 
            $('#addtable .atTransType').append(TransportationTypeOption);
            $('#addtable .atTaxType').append(GSTCodeOption);
            $('#addtable .atCurr').append(CurrencyOption);
            $('#addtable .atOrgCurr').append(CurrencyOption);

            $('#addtable .atOrgCurr').val(jsUsingCurrency);
            $('#addtable .atCurr').val(jsUsingCurrency);
            $(".atVouDate").datepicker({
                dateFormat: "yy-mm-dd"
            }).attr('readOnly', 'true');
            rangeDatePicker($(".atDateFrom"),$(".atDateTo"));
        }

        function addRow(FormType) {
            //get data from radio
            var CostTypeOption = "";
            for (var i = 0; i < jsCostType.length; i++) {
                if (FormType == jsCostType[i].FormType) {
                    CostTypeOption += "<option code='" + jsCostType[i].AccountCode + "' value='" + jsCostType[i].ID + "' displayType='" + jsCostType[i].DisplayType + "'>" + jsCostType[i].CostTypeDesc + "</option>";
                }
            }
            var CurrencyOption = "";
            for (var i = 0; i < jsDistCurr.length; i++) {
                CurrencyOption += "<option value='" + jsDistCurr[i].CurrencyCode + "'>" + jsDistCurr[i].CurrencyCode + "</option>";
            }
            var GSTCodeOption = "";
            for (var i = 0; i < jsGSTCode.length; i++) {
                GSTCodeOption += "<option percent='"+jsGSTCode[i].TaxRate+"' value='" + jsGSTCode[i].ID + "'>" + jsGSTCode[i].TaxDesc + "</option>";
            }
            var TransportationTypeOption = "";
            for (var i = 0; i < jsTransportationType.length; i++) {
                TransportationTypeOption += "<option value='" + jsTransportationType[i].ID + "'>" + jsTransportationType[i].TransportationTypeDesc + "</option>";
            }
            TransportationTypeOption += "<option selected='selected' style='display:none' value='-1'></option>";
            var eClaimRow = '<tr class="rowClaimDetails">\
                                    <td class="t01"><a class="delRow" style="cusor:pointer;"><img src="/Icons/Sigma/Delete_16X16_Standard_2.png"></a></td>\
                                    <td class="t02"><select style="display:none;" class="inputCostType">' + CostTypeOption + '</select><label class="txtCostType"></label></td>\
                                    <td class="t03"><input type="" name="" value="" class="inputVouDate" style="width:90px"></td>\
                                    <td class="t04 tdDetails" align="left" nowrap="">\
                                        <span class="spanDate"><label>Date From:</label><input type="" name="" value="" class="inputDateFrom"><label>Date To:</label><input type="" name="" value="" class="inputDateTo"><br /></span>\
                                        <span class="spanLoc"><label>LOC From:</label><input type="" name="" value="" class="inputLocFrom"><label>LOC To:</label><input type="" name="" value="" class="inputLocTo"><br /></span>\
                                        <span class="spanTrans"><label>TRAN Type:</label><select class="inputTransType">' + TransportationTypeOption + '</select><br /></span>\
                                        <span class="spanDesc"><label>DESC:</label><input type="" name="" value="" class="inputDesc"></span>\
                                    </td>\
                                    \
                                    <td class="t05"><select class="inputOrgCurr">' + CurrencyOption + '</select></td>\
                                    <td class="t06"><input type="" name="" value="0" class="inputExcTax toRight dollar calTotal1"></td>\
                                    <td class="t07"><input type="" name="" value="0" class="inputTaxAmt toRight dollar calTotal2"></td>\
                                    <td class="t08"><select class="inputTaxType">' + GSTCodeOption + '</select></td>\
                                    <td class="t09"><input type="" name="" value="0" class="inputIncTax toRight dollar calTotal3"></td>\
                                    <td class="t10"><select class="inputCurr">' + CurrencyOption + '</select></td>\
                                    <td class="t11"><input type="" name="" value="1" class="inputRate toRight exRate"></td>\
                                    <td class="t12"><input type="" name="" value="0" class="inputTotal toRight dollar calTotal4"></td>\
                                    <td class="t13"><input type="" name="" value="" class="inputRemark"></td>\
                                    <td class="t14 incRef"><input type="checkbox" name="" value="" class="inputRef toRight"></td>\
                                </tr>';
            $(eClaimRow).insertBefore('#GrandTotal');
            $('#GrandTotal').prev().find('.inputOrgCurr').val(jsUsingCurrency);
            $('#GrandTotal').prev().find('.inputCurr').val(jsUsingCurrency);
            $('#GrandTotal').prev().find(".inputVouDate").datepicker({
                dateFormat: "yy-mm-dd"
            }).attr('readOnly', 'true');

            rangeDatePicker($('#GrandTotal').prev().find(".inputDateFrom"), $('#GrandTotal').prev().find(".inputDateTo"));
            reflashTotal();
            $('#GrandTotal').prev().find(".inputCostType").attr("disabled", true);
            $('#GrandTotal').prev().find(".inputIncTax").attr("disabled", true);
            $('#GrandTotal').prev().find(".inputTotal").attr("disabled", true);
            //$('#GrandTotal').prev().find(".inputExcTax").change(function () {
            //    var IncTax = $(this).parent().parent().find(".inputIncTax").val();
            //    $(this).parent().parent().find(".inputTaxAmt").val((IncTax - $(this).val()).toFixed("2"));

            //});
            //$('#GrandTotal').prev().find(".inputTaxAmt").change(function () {
            //    var IncTax = $(this).parent().parent().find(".inputIncTax").val();
            //    $(this).parent().parent().find(".inputExcTax").val((IncTax - $(this).val()).toFixed("2"));
            //});
            //$('#GrandTotal').prev().find(".inputRate").change(function () {
            //    var IncTax = $(this).parent().parent().find(".inputIncTax").val();
            //    $(this).parent().parent().find(".inputTotal").val((IncTax*$(this).val()).toFixed("2"));
            //});
        }
        function loadFormBasicData() {
            //1. put all BU options into <select>
            var BUOption = "";
            for (var i = 0; i < jsBU.length; i++) {
                BUOption += "<option value='" + jsBU[i].BUCode + "'>" + jsBU[i].BUCode + "</option>";
            }
            $('#inputBU').append(BUOption);
            //2. put all FormType radio input into <td>
            var FormTypeOption = "";
            for (var i = 0; i < jsFormType.length; i++) {
                FormTypeOption += "<input id='radio" + jsFormType[i].ClaimFormTypeCode + "' type='radio' name='inputFormType[]' value='" + jsFormType[i].ClaimFormTypeCode + "'> <label for='radio" + jsFormType[i].ClaimFormTypeCode + "'>" + jsFormType[i].ClaimFormTypeDesc + "</label>";
            }
            $('#inputFormType').append(FormTypeOption);
        }
        function code1() {
            var jsFormData = JSON.parse($('#<%=hfFormData.ClientID%>').val());
            $("#inputID").text(jsFormData[0].ID);
            $("#inputRefNo").text(jsFormData[0].RefNo);
            $("#inputRegion").text(jsFormData[0].Region);
            $("#inputEmployee").text($('#<%=hfFormDataCreateBy.ClientID%>').val());
            $('#inputBU').val(jsFormData[0].BusinessUnit);
            var tempDate = jsFormData[0].SubmissionDate;
            $("#inputSubDate").text(unix_to_readable(tempDate));
            $("#radio" + jsFormData[0].ClaimFormType).attr('checked', 'checked');
            setFormType();
            $('#inputProjCode').val(jsFormData[0].JobNo);
            $('#inputProjName').val(jsFormData[0].ProjectName);
        }
        function loadFormData() {
            //load database data (@db)
            //if first create,
            //load form id = 0
            if (jsStatus == "0") {
                $('#inputID').text(jsFormID);
                $('#inputRefNo').text(jsLoginRefNo);
                $('#inputRegion').text(jsLoginRegion);
                $('#inputEmployee').text(jsLoginName);
                $('#inputBU').val(jsLoginDepartment);
                $("#inputSubDate").text($('#<%=hfCurrDate.ClientID%>').val());
                $('#radio' + jsFormType[0].ClaimFormTypeCode).trigger('click');
                setFormType();
            }
            //if saved
            if (jsStatus == "1") {
                code1();
                $("#inputSubDate").text($('#<%=hfCurrDate.ClientID%>').val());
                
                if ($('#<%=hfCanEditForm.ClientID%>').val() == "false") {
                    $('#basicInfo').find("input,textarea,select").attr("disabled", true);
                }
            }
            //if submited
            if (jsStatus == "2") {
                code1();
                $('#basicInfo').find("input,textarea,select").attr("disabled", true);
            }
            //if canceled
            if (jsStatus == "3") {
                code1();
                $('#basicInfo').find("input,textarea,select").attr("disabled", true);
            }
        }
        function code2() {
            var jsFormDetailsData = $("#<%=hfFormDetailsData.ClientID%>").val();
            jsFormDetailsData = JSON.parse(jsFormDetailsData);
            for (var i = 0; i < jsFormDetailsData.length; i++) {
                addRow(getFormType());
                //CurrencyOption += "<option value='" + jsFormDetailsData[i].CurrencyRegion + "'>" + jsCurrency[i].CurrencyCode + "</option>";
                $('#GrandTotal').prev().find(".inputCostType").val(jsFormDetailsData[i].CostTypeID);
                var substringtxt = $('#GrandTotal').prev().find('.inputCostType :selected').text();
                if (substringtxt.indexOf(":") > 0) {
                    substringtxt = substringtxt.substring(substringtxt.indexOf(":") + 2, substringtxt.length);
                }
                $('#GrandTotal').prev().find(".txtCostType").text(substringtxt);
                checkCostType($('#GrandTotal').prev().find(".inputCostType"));
                var tempDate = jsFormDetailsData[i].VoucDate;
                $('#GrandTotal').prev().find(".inputVouDate").val(unix_to_readable(tempDate));
                var tempDate = jsFormDetailsData[i].PeriodFrom;
                $('#GrandTotal').prev().find(".inputDateFrom").val(unix_to_readable(tempDate));
                var tempDate = jsFormDetailsData[i].PeriodTo;
                $('#GrandTotal').prev().find(".inputDateTo").val(unix_to_readable(tempDate));
                $('#GrandTotal').prev().find(".inputLocFrom").val(jsFormDetailsData[i].LocationFrom);
                $('#GrandTotal').prev().find(".inputLocTo").val(jsFormDetailsData[i].LocationTo);
                $('#GrandTotal').prev().find(".inputTransType").val(jsFormDetailsData[i].TransportationTypeID);
                $('#GrandTotal').prev().find(".inputDesc").val(jsFormDetailsData[i].Description);
                //var tempBool = (jsFormDetailsData[i].AutoCal == "Y") ? true : false;
                //$('#GrandTotal').prev().find(".inputAutoCal").prop('checked', tempBool);
                $('#GrandTotal').prev().find(".inputOrgCurr").val(jsFormDetailsData[i].OriginalCurrencyCode);
                $('#GrandTotal').prev().find(".inputExcTax").val(jsFormDetailsData[i].OriginalAmount);
                $('#GrandTotal').prev().find(".inputTaxAmt").val(jsFormDetailsData[i].TaxAmount);
                $('#GrandTotal').prev().find(".inputTaxType").val(jsFormDetailsData[i].GSTCode);
                $('#GrandTotal').prev().find(".inputIncTax").val(jsFormDetailsData[i].AmountWithTax);
                $('#GrandTotal').prev().find(".inputCurr").val(jsFormDetailsData[i].ClaimedCurrencyCode);
                $('#GrandTotal').prev().find(".inputRate").val(jsFormDetailsData[i].ExchangeRate);
                $('#GrandTotal').prev().find(".inputTotal").val(jsFormDetailsData[i].TotalAmount);
                var tempBool2 = (jsFormDetailsData[i].IncludeRef == "Y") ? true : false;
                $('#GrandTotal').prev().find(".inputRef").prop('checked', tempBool2);
                $('#GrandTotal').prev().find(".inputRemark").val(jsFormDetailsData[i].Remarks);
            }
            
            var jsFormData = JSON.parse($('#<%=hfFormData.ClientID%>').val());
            if (jsLoginID != jsFormData[0].CreatedBy) {
                //if the user is super user, he cannot change this claim form
                /*
                $('#basicInfo').find("input,textarea,select").attr("disabled", true);
                $("#forScrollx").find("input,textarea,select").attr("disabled", true);
                $("#forScrollx").find("a").click(function () { return false; });
                $("#forScrollx").find("a").css('color', 'black');
                $('#addtable').hide();
                $('#addtableTitle').hide();
                //$('#addtable2').hide();
                //$('#addtable3').hide();
                $('#btnAddRow2').hide();
                $('.t01').addClass('hideTableColumn');
                */
            }
        }
        function loadFormDetailsData() {
            if (jsStatus == "0") {

            }
            if (jsStatus == "1") {
                code2();
                if ($('#<%=hfCanEditForm.ClientID%>').val() == "false") {
                    $("#forScrollx").find("input,textarea,select").attr("disabled", true);
                    $("#forScrollx").find("a").click(function () { return false; });
                    $("#forScrollx").find("a").css('color', 'black');
                    $('#addtable').hide();
                    $('#addtableTitle').hide();
                    //$('#addtable2').hide();
                    //$('#addtable3').hide();
                    $('#btnAddRow2').hide();
                    $('.t01').addClass('hideTableColumn');
                }
            }
            if (jsStatus == "2") {
                code2();
                $("#forScrollx").find("input,textarea,select").attr("disabled", true);
                $("#forScrollx").find("a").click(function () { return false; });
                $("#forScrollx").find("a").css('color', 'black');
                $('#addtable').hide();
                $('#addtableTitle').hide();
                //$('#addtable2').hide();
                //$('#addtable3').hide();
                $('#btnAddRow2').hide();
                $('.t01').addClass('hideTableColumn');
            }
            if (jsStatus == "3") {
                code2();
                $("#forScrollx").find("input,textarea,select").attr("disabled", true);
                $("#forScrollx").find("a").click(function () { return false; });
                $("#forScrollx").find("a").css('color', 'black');
                $('#addtable').hide();
                $('#addtableTitle').hide();
                //$('#addtable2').hide();
                //$('#addtable3').hide();
                $('#btnAddRow2').hide();
                $('.t01').addClass('hideTableColumn');
            }
        }

        function checkCostType(element) {
            $(element).parent().parent().find('.tdDetails input').val('');
            $(element).parent().parent().find('.tdDetails .inputTransType').val(-1);
            $(element).parent().parent().find('.spanDate').addClass('hideCostType');
            $(element).parent().parent().find('.spanLoc').addClass('hideCostType');
            $(element).parent().parent().find('.spanTrans').addClass('hideCostType');
            $(element).parent().parent().find('.spanDesc').addClass('hideCostType');
            $(element).parent().parent().find('.inputExcTax').removeClass("cashAdv");
            $(element).parent().parent().find('.inputTaxAmt').removeClass("cashAdv");
            $(element).parent().parent().find('.inputIncTax').removeClass("cashAdv");
            $(element).parent().parent().find('.inputTotal').removeClass("cashAdv");
            switch ($(element).children(':selected').attr('displayType')) {
                case '-1'://less cash advance
                    $(element).parent().parent().find('.inputExcTax').addClass("cashAdv");
                    $(element).parent().parent().find('.inputTaxAmt').addClass("cashAdv");
                    $(element).parent().parent().find('.inputIncTax').addClass("cashAdv");
                    $(element).parent().parent().find('.inputTotal').addClass("cashAdv");
                    $(element).parent().parent().find('.spanDesc').removeClass('hideCostType'); break;
                case '0':
                    break;
                case 'LTDesc':
                    $(element).parent().parent().find('.spanLoc').removeClass('hideCostType');
                    $(element).parent().parent().find('.spanTrans').removeClass('hideCostType');
                    $(element).parent().parent().find('.spanDesc').removeClass('hideCostType'); break;
                case 'LDesc':
                    $(element).parent().parent().find('.spanLoc').removeClass('hideCostType');
                    $(element).parent().parent().find('.spanDesc').removeClass('hideCostType'); break;
                case 'DDesc':
                    $(element).parent().parent().find('.spanDate').removeClass('hideCostType');
                    $(element).parent().parent().find('.spanDesc').removeClass('hideCostType'); break;
                case 'Desc':
                    $(element).parent().parent().find('.spanDesc').removeClass('hideCostType'); break;
                case 'DLTDesc':
                    $(element).parent().parent().find('.spanDate').removeClass('hideCostType');
                    $(element).parent().parent().find('.spanLoc').removeClass('hideCostType');
                    $(element).parent().parent().find('.spanTrans').removeClass('hideCostType');
                    $(element).parent().parent().find('.spanDesc').removeClass('hideCostType'); break;
                case 'DLDesc':
                    $(element).parent().parent().find('.spanDate').removeClass('hideCostType');
                    $(element).parent().parent().find('.spanLoc').removeClass('hideCostType');
                    $(element).parent().parent().find('.spanDesc').removeClass('hideCostType'); break;
                case 'DTDesc':
                    $(element).parent().parent().find('.spanDate').removeClass('hideCostType');
                    $(element).parent().parent().find('.spanTrans').removeClass('hideCostType');
                    $(element).parent().parent().find('.spanDesc').removeClass('hideCostType'); break;
                case 'TDesc':
                    $(element).parent().parent().find('.spanTrans').removeClass('hideCostType');
                    $(element).parent().parent().find('.spanDesc').removeClass('hideCostType'); break;
                default:
                    console.log('no data');
            }
        }
        function checkatCostType(element) {
            $('.trDate').hide();
            $('.trLoc').hide();
            $('.trTrans').hide();
            $('.trDesc').hide();
            $('.atIncTax').removeClass("cashAdv");
            switch ($(element).children(':selected').attr('displayType')) {
                case '-1'://less cash advance
                    $(".atIncTax").addClass("cashAdv"); 
                    $('.trDesc').show(); break;
                case '0':
                    break;
                case 'LTDesc':
                    $('.trLoc').show();
                    $('.trTrans').show();
                    $('.trDesc').show(); break;
                case 'LDesc':
                    $('.trLoc').show();
                    $('.trDesc').show(); break;
                case 'DDesc':
                    $('.trDate').show();
                    $('.trDesc').show(); break;
                case 'Desc':
                    $('.trDesc').show(); break;
                case 'DLTDesc':
                    $('.trDate').show();
                    $('.trLoc').show();
                    $('.trTrans').show();
                    $('.trDesc').show(); break;
                case 'DLDesc':
                    $('.trDate').show();
                    $('.trLoc').show();
                    $('.trDesc').show(); break;
                case 'DTDesc':
                    $('.trDate').show();
                    $('.trTrans').show();
                    $('.trDesc').show(); break;
                case 'TDesc':
                    $('.trTrans').show();
                    $('.trDesc').show(); break;
                default:
                    console.log('no data');
            }
            $('#addtable atDateFrom').val('');
            $('#addtable atDateTo').val('');
            $('#addtable atLocFrom').val('');
            $('#addtable atLocTo').val('');
            $('#addtable atDesc').val('');
            if ($('.atTransType').is(':visible')) {
                $('#addtable .atTransType').val(1);
            } else {
                $('#addtable .atTransType').val(-1);
            }
        }
        function clearAddTable() {
            $('#addtable input').val('');
            $('#addtable input').val('');
            if ($('.atTransType').is(':visible')) {
                $('#addtable .atTransType').val(1);
            } else {
                $('#addtable .atTransType').val(-1);
            }
            $('#addtable input').val('');
            $('#addtable .atTaxType').val(1);
            $('#addtable .atOrgCurr').val(jsUsingCurrency);
            $('#addtable .atCurr').val(jsUsingCurrency);
            $('#addtable .atExcTax').val(0);
            $('#addtable .atTaxAmt').val(0);
            $('#addtable .atIncTax').val(0);
            $('#addtable .atRate').val(1);
            $('#addtable .atTotal').val(0);
            reflashTotal();
            $('#addtable .atRef').prop('checked', false);
        }
        //assist function
        function clearTable() {
            $('.rowClaimDetails').remove();
        }
        function getFormType() {
            return $('input[name="inputFormType[]"]:checked').val();
        }
        function setFormType() {
            if (getFormType() == 'G') {
                $('#PJDetails').hide();
                clearTable();
            } else {
                $('#PJDetails').show();
                clearTable();
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
        function eventListener() {//all delegate event listener
            $("body").delegate(".dollar", "change", function () {
            //$(".dollar").on('change', function () {
                if ($(this).hasClass("cashAdv")) {
                    //for less cash advance
                    if (this.value > 0) {
                        this.value = 0 - this.value;
                    }
                    this.value = this.value.replace(/(?!^-)[^0-9.]/g, "");
                    this.value = parseFloat(this.value).toFixed("2");
                    formula();
                } else {
                    //for other cost type
                    this.value = this.value.replace(/[^0-9\.]/g, '');
                    this.value = parseFloat(this.value).toFixed("2");
                    formula();
                }
            });
            $("body").delegate(".inputRemark", "keyup", function () {
                $('#forAutoWidth').css('font', $(this).css('font'));
                $('#forAutoWidth').text($(this).val());
                $(this).css('width', $('#forAutoWidth').width() + 10);
            });
            $("body").delegate(".inputDesc", "keyup", function () {
                $('#forAutoWidth').css('font', $(this).css('font'));
                $('#forAutoWidth').text($(this).val());
                $(this).css('width', $('#forAutoWidth').width() + 10);
            });
            $("body").delegate(".inputExcTax", "change", function () {
                var IncTax = $(this).parent().parent().find(".inputIncTax").val();
                if ($(this).hasClass("cashAdv")) {
                    if (parseFloat($(this).val()) < parseFloat(IncTax)) {
                        $(this).val(IncTax);
                    }
                } else {
                    if (parseFloat($(this).val()) > parseFloat(IncTax)) {
                        $(this).val(IncTax);
                    }
                }
                $(this).parent().parent().find(".inputTaxAmt").val((IncTax - $(this).val()).toFixed("2"));
                formula();
            });
            $("body").delegate(".inputTaxAmt", "change", function () {
                var IncTax = $(this).parent().parent().find(".inputIncTax").val();
                if ($(this).hasClass("cashAdv")) {
                    if (parseFloat($(this).val()) < parseFloat(IncTax)) {
                        $(this).val(IncTax);
                    }
                } else {
                    if (parseFloat($(this).val()) > parseFloat(IncTax)) {
                        $(this).val(IncTax);
                    }
                }
                $(this).parent().parent().find(".inputExcTax").val((IncTax - $(this).val()).toFixed("2"));
                formula();
            });
            $("body").delegate(".exRate", "change", function () {
                var IncTax = $(this).parent().parent().find(".inputIncTax").val();
                $(this).parent().parent().find(".inputTotal").val((IncTax * $(this).val()).toFixed("2"));
                this.value = this.value.replace(/[^0-9\.]/g, '');
                this.value = parseFloat(this.value).toFixed("4");
                formula();
            });
            $("body").delegate(".cbt00", "change", function () {
                showHideTableColumn(this);
            });
            //This is for nav excel because all the currency should be the same.
            $("body").delegate(".atCurr", "change", function () {
                $('.inputCurr').val($(this).val());
                if ($('#cbt10').prop('checked') == false) { 
                    $('#cbt10').prop('checked', 'checked');
                    $(".cbt00").each(function () {
                        showHideTableColumn(this);
                    });
                }
                formula();
            });
            $("body").delegate(".inputCurr", "change", function () {
                $('.inputCurr').val($(this).val());
                $('.atCurr').val($(this).val());
                if ($('#cbt10').prop('checked') == false) {
                    $('#cbt10').prop('checked', 'checked');
                    $(".cbt00").each(function () {
                        showHideTableColumn(this);
                    });
                }
                formula();
            });
            $("body").delegate(".inputOrgCurr", "change", function () {
                formula();
            });
            $('#showall').click(function () {
                $('.cbt00').prop('checked', 'checked');
                $(".cbt00").each(function () {
                    showHideTableColumn(this);
                });
            });
            $('#showpart').click(function () {
                $('.cbt00').prop('checked', '');
                $('#cbt02').prop('checked', 'checked');
                $('#cbt04').prop('checked', 'checked');
                $('#cbspanLoc').prop('checked', 'checked');
                $('#cbspanDate').prop('checked', 'checked');
                $('#cbspanTrans').prop('checked', 'checked');
                $('#cbspanDesc').prop('checked', 'checked');
                $('#cbt06').prop('checked', 'checked');
                $('#cbt07').prop('checked', 'checked');
                $('#cbt09').prop('checked', 'checked');
                $('#cbt12').prop('checked', 'checked');
                $(".cbt00").each(function () {
                    showHideTableColumn(this);
                });
            });
            //cal row total
            $('.atIncTax').change(function () {
                formula();
            });
            $('.atRate').change(function () {
                formula();
            });
            $('.atTaxType').change(function () {
                formula();
            });
            //add button click
            $('#btnAddRow2').click(function () {
                if ($('#claim1 tr').length < 202) {
                    addRowFromAddtable(getFormType());
                    clearAddTable();
                    formula();
                } else {
                    alert('The number of row cannot exceed 200');
                }
            });
            //change add table cost type
            $("#addtable").delegate(".atCostType", "change", function () {
                checkatCostType(this);
                clearAddTable();
            });
            //change cost type
            $("#claim1").delegate(".inputCostType", "change", function () {
                checkCostType(this);
            });
            //delete icon
            $("#claim1").delegate(".delRow", "click", function () {
                var r = confirm("Do you want to delete this row?");
                if (r == true) {
                    $(this).closest('tr').remove();
                    formula();
                }
            });
            //change form type
            $('input[name="inputFormType[]"]').click(function (e, isTrigger) {
                var cnfrm = confirm('Do you really want to change form type? All the unsaved data will be lost.');
                if (cnfrm != true) {
                    return false;
                } else {
                    setFormType();
                    $('#PJDetails input').val('');
                    clearAddTable();
                    setAddTable(getFormType());
                    checkatCostType($('.atCostType'));
                    formula();
                }
            });
        }

        function showHideTableColumn(temp) {
            var tempClass = $(temp).attr('id').substring(2, $(temp).attr('id').length);
            tempClass = '.' + tempClass;
            if ($(temp).is(':checked')) {
                $(tempClass).removeClass('hideTableColumn');
            } else {
                $(tempClass).addClass('hideTableColumn');
            }
        }
        function reflashTotal() {
            //show/hide the Receipt List at the beginning
            $(".cbt00").each(function () {
                showHideTableColumn(this);
            });
            //set the dollar from 0 to 0.00
            $(".dollar").each(function (index, element) {
                if (this.value != '') {
                    if ($(this).hasClass("cashAdv")) {
                        //for less cash advance
                        if (this.value > 0) {
                            this.value = 0 - this.value;
                        }
                        this.value = this.value.replace(/(?!^-)[^0-9.]/g, "");
                        this.value = parseFloat(this.value).toFixed("2");
                    } else {
                        //for other cost type
                        this.value = this.value.replace(/[^0-9\.]/g, '');
                        this.value = parseFloat(this.value).toFixed("2");
                    }
                }
            });
            //set the exchange rate frm 0 to 0.0000
            $(".exRate").each(function (index, element) {
                if (this.value != '') {
                    this.value = this.value.replace(/[^0-9\.]/g, '');
                    this.value = parseFloat(this.value).toFixed("4");
                }
            });
        }
        function formula() {
            var taxRate = $('.atTaxType :selected').attr('percent') / 100 + 1;
            var incTax = $('.atIncTax').val();
            var orgAmt = (incTax / taxRate).toFixed("2");
            var taxAmt = (incTax - orgAmt).toFixed("2");
            $('.atExcTax').text(orgAmt);
            $('.atTaxAmt').text(taxAmt);
            var finalTotal = (incTax * $('.atRate').val()).toFixed("2");
            $('.atTotal').text(finalTotal);
            //calTotal new start
            var arrTotal1 = [];
            var arrTotal2 = [];
            var arrTotal3 = [];
            var arrTotal4 = [];
            var arrayClaimedCurr = [];
            for (var i = 0; i < jsDistCurr.length; i++) {
                arrTotal1[jsDistCurr[i].CurrencyCode] = 0;
                arrTotal2[jsDistCurr[i].CurrencyCode] = 0;
                arrTotal3[jsDistCurr[i].CurrencyCode] = 0;
                arrTotal4[jsDistCurr[i].CurrencyCode] = 0;
            }
            $('.rowClaimDetails').each(function (index, element) {
                arrTotal1[$(this).find('.inputOrgCurr').val()] += parseFloat($(this).find('.calTotal1').val());
                arrTotal2[$(this).find('.inputOrgCurr').val()] += parseFloat($(this).find('.calTotal2').val());
                arrTotal3[$(this).find('.inputOrgCurr').val()] += parseFloat($(this).find('.calTotal3').val());
                arrTotal4[$(this).find('.inputCurr').val()] += parseFloat($(this).find('.calTotal4').val());
            });
            var txtTotal1 = "";
            var txtTotal2 = "";
            var txtTotal3 = "";
            var txtTotal4 = "";
            for (var x = 0; x < jsDistCurr.length; x++) {
                var tempTotal1 = arrTotal1[jsDistCurr[x].CurrencyCode];
                var tempTotal2 = arrTotal2[jsDistCurr[x].CurrencyCode];
                var tempTotal3 = arrTotal3[jsDistCurr[x].CurrencyCode];
                var tempTotal4 = arrTotal4[jsDistCurr[x].CurrencyCode];
                if (tempTotal1 != 0) {
                    txtTotal1 = txtTotal1 + jsDistCurr[x].CurrencyCode + ": " + tempTotal1.toFixed("2") + "<br>";
                }
                if (tempTotal2 != 0) {
                    txtTotal2 = txtTotal2 + jsDistCurr[x].CurrencyCode + ": " + tempTotal2.toFixed("2") + "<br>";
                }
                if (tempTotal3 != 0) {
                    txtTotal3 = txtTotal3 + jsDistCurr[x].CurrencyCode + ": " + tempTotal3.toFixed("2") + "<br>";
                }
                if (tempTotal4 != 0) {
                    txtTotal4 = txtTotal4 + jsDistCurr[x].CurrencyCode + ": " + tempTotal4.toFixed("2") + "<br>";
                }
            }
            txtTotal1 = txtTotal1 == "" ? 0.00 : txtTotal1;
            txtTotal2 = txtTotal2 == "" ? 0.00 : txtTotal2;
            txtTotal3 = txtTotal3 == "" ? 0.00 : txtTotal3;
            txtTotal4 = txtTotal4 == "" ? 0.00 : txtTotal4;
            $('#total1').html(txtTotal1);
            $('#total2').html(txtTotal2);
            $('#total3').html(txtTotal3);
            $('#total4').html(txtTotal4);
            //calTotal
            //var total = 0;
            //$('#total1').text(total);
            //$('.calTotal1').each(function (index, element) {
            //    total += parseFloat($(element).val());
            //    $('#total1').text(total.toFixed("2"));
            //});
            //var total = 0;
            //$('#total2').text(total);
            //$('.calTotal2').each(function (index, element) {
            //    total += parseFloat($(element).val());
            //    $('#total2').text(total.toFixed("2"));
            //});
            //var total = 0;
            //$('#total3').text(total);
            //$('.calTotal3').each(function (index, element) {
            //    total += parseFloat($(element).val());
            //    $('#total3').text(total.toFixed("2"));
            //});
            //var total = 0;
            //$('#total4').text(total);
            //$('.calTotal4').each(function (index, element) {
            //    total += parseFloat($(element).val());
            //    $('#total4').text(total.toFixed("2"));
            //});
            //end
            $(".inputDesc").each(function () {
                //$(this).css('width', ($(this).val().length+1)*7);
                $('#forAutoWidth').css('font', $(this).css('font'));
                $('#forAutoWidth').text($(this).val());
                $(this).css('width', $('#forAutoWidth').width() + 10);
            });
            $(".inputRemark").each(function () {
                //$(this).css('width', ($(this).val().length + 1) * 7);
                $('#forAutoWidth').css('font', $(this).css('font'));
                $('#forAutoWidth').text($(this).val());
                $(this).css('width', $('#forAutoWidth').width() + 10);
            });
        }
        //main process
        loadFormBasicData();
        loadFormData();
        loadFormDetailsData();
        setAddTable(getFormType());
        checkatCostType($('.atCostType'));
        //event listener
        eventListener();
        reflashTotal();
        formula();
    });
</script>
<label id="forAutoWidth" style="display:none;"></label>
<h3><u>Expenditure Claim Form</u></h3>
<table id="basicInfo">
<tbody>
<tr style="display:none;">
<td><label>ID: </label></td>
<td><label id="inputID">cannot find value</label></td>
</tr>
<tr>
<td><label>Reference No: </label></td>
<td><label id="inputRefNo">cannot find value</label></td>
</tr>
<tr>
<td><label>Region: </label></td>
<td><label id="inputRegion">cannot find value</label></td>
</tr>
    <tr>
<td><label>Employee: </label></td>
<td><label id="inputEmployee">cannot find value</label></td>
</tr>
<tr>
<td><label>Business Unit: </label></td>
<td><select name="" id="inputBU">

</select></td>
</tr>
<tr>
<td><label>Submission Date: </label></td>
<td><label id="inputSubDate">cannot find value</label></td>
</tr>
<tr>
<td><label>Attached file: </label></td>
    <td><input type="file" id="fileActual" multiple="multiple" onchange="UploadActual(this,event);" /><br /><div id="progressbar"></div><ul id="liActualAttached"></ul></td>
</tr>
<tr>
    <td></td>
    <td><label>File size cannot exceed 8 mb and file format should be pdf.</label></td>
</tr>
<tr>
    <td>
        <label>Type:</label>
    </td>
    <td id="inputFormType">
        <%--<input id="radioGE" type="radio" name="inputClaimType[]"> <label for="radioGE">General Expense</label>
        <input id="radioPJ" type="radio" name="inputClaimType[]"><label for="radioPJ">Project</label>--%>
    </td>
</tr>
<tr id="PJDetails">
    <td><label>Project Code:</label></td>
    <td><input name="" value="" id="inputProjCode"></td>
    <td><label>Project Name:</label></td>
    <td><input name="" value="" id="inputProjName"></td>
</tr>
</tbody></table>









<style type="text/css">
    #addtable{
        border-collapse:collapse;
        border: 1px solid black;
    }
    #addtable td{
        border: 1px solid black;
        width: 120px;
    }
    #addtable tr:first-child td{
        padding:0px;
    }
    .dollar{
        margin:0px;
        width: 100%;
        padding:0px;
        text-align: right;
    }
    .exRate{
        margin:0px;
        width: 100%;
        padding:0px;
        text-align: right;
    }
    #trDollar>td{
        text-align: right;
    }
    #contain td,th{
        padding:9px;
    }
    .incRef{
        display:none;
    }
</style>
<h4 id="addtableTitle"><u>Receipt Details</u></h4>
<table id="addtable">
    <tr style="visibility:hidden;">
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
    </tr>
    <tr>
        <td><label>Expense Type:</label></td>
        <td colspan="3"><select class="atCostType"></select></td>
        <td><label>Receipt Date:</label></td>
        <td colspan="3"><input class="atVouDate"></td>
    </tr>



    <tr class="trDate">
        <td><label>Date From:</label></td>
        <td colspan="3"><input class="atDateFrom" readonly="readonly"></td>
        <td><label>Date To:</label></td>
        <td colspan="3"><input class="atDateTo" readonly="readonly"></td>
    </tr>
    <tr class="trLoc">
        <td><label>Location From:</label></td>
        <td colspan="3"><input class="atLocFrom"></td>
        <td><label>Location To:</label></td>
        <td colspan="3"><input class="atLocTo"></td>
    </tr>
    <tr class="trTrans">
        <td><label>Transportation Type:</label></td>
        <td colspan="7"><select class="atTransType"></select></td>
    </tr>
    <tr class="trDesc">
        <td><label>Description:</label></td>
        <td colspan="7"><input class="atDesc" style="width:100%;"></td>
    </tr>

    <tr>
        <td>Original Currency</td>
        <td>Amount (Excl. Tax)</td>
        <td>Tax Amount</td>
        <td>Tax</td>
        <td>Amount (Incl. Tax)</td>
        <td>Currency Claimed</td>
        <td>Exchange Rate</td>
        <td>Total Claim Amount</td>
    </tr>
    <tr class="trDollar">
        <td><select class="atOrgCurr"></select></td>
        <td><label class="atExcTax" style="float:right;">0</label></td>
        <td><label class="atTaxAmt" style="float:right;">0</label></td>
        <td><select class="atTaxType"></select></td>
        <td><input class="dollar atIncTax" value="0"></td>
        <td><select class="atCurr"></select></td>
        <td><input class="exRate atRate" value="1"></td>
        <td><label class="atTotal" style="float:right;">0</label></td>
    </tr>
    <tr>
        <td><label>Remark:</label></td>
        <td colspan="7"><input class="atRemark" type="" name="" style="width:100%;"></td>
    </tr>
    <tr class="incRef">
        <td><label>Inc. Ref:</label></td>
        <td colspan="7"><input class="atRef" type="checkbox" name="" id=""></td>
    </tr>
</table>
<br />
<input type="button" value="Add row" id="btnAddRow2" class="dnnPrimaryAction">

<h4><u>Receipt List</u></h4>
<label>The below checkbox can show/hide the column of the Receipt List table. Checking or unchecking these checkboxes do not affect your claim form.</label><br />
<input id="showall" type="button" name="" value="Show all" style="width:102px" />
<%--<input id="cbt01" class="cbt00" type="checkbox" /><label for="cbt01">Control&nbsp;&nbsp;</label>--%>
<input id="cbt02" class="cbt00" type="checkbox" checked="checked" /><label for="cbt02">Expense Type&nbsp;&nbsp;</label>
<input id="cbt03" class="cbt00" type="checkbox" /><label for="cbt03">Receipt Date&nbsp;&nbsp;</label>
<input id="cbt04" class="cbt00" type="checkbox" checked="checked" /><label for="cbt04">Details&nbsp;&nbsp;</label>
<input id="cbspanLoc" class="cbt00" type="checkbox" checked="checked" /><label for="cbspanLoc">Loc From/To&nbsp;&nbsp;</label>
<input id="cbspanDate" class="cbt00" type="checkbox" checked="checked" /><label for="cbspanDate">Date From/To&nbsp;&nbsp;</label>
<input id="cbspanTrans" class="cbt00" type="checkbox" checked="checked" /><label for="cbspanTrans">Trans Type&nbsp;&nbsp;</label>
<input id="cbspanDesc" class="cbt00" type="checkbox" checked="checked" /><label for="cbspanDesc">Desc&nbsp;&nbsp;</label>
<input id="cbt05" class="cbt00" type="checkbox" /><label for="cbt05">Original Currency&nbsp;&nbsp;</label>
<br />
<input id="showpart" type="button" name="" value="Show default" />
<input id="cbt06" class="cbt00" type="checkbox" checked="checked" /><label for="cbt06">Amount(Excl. Tax)&nbsp;&nbsp;</label>
<input id="cbt07" class="cbt00" type="checkbox" checked="checked" /><label for="cbt07">Tax Amount&nbsp;&nbsp;</label>
<input id="cbt08" class="cbt00" type="checkbox" /><label for="cbt08">Tax&nbsp;&nbsp;</label>
<input id="cbt09" class="cbt00" type="checkbox" checked="checked" /><label for="cbt09">Amount (Incl. Tax)&nbsp;&nbsp;</label>
<input id="cbt10" class="cbt00" type="checkbox" /><label for="cbt10">Currency Claimed&nbsp;&nbsp;</label>
<input id="cbt11" class="cbt00" type="checkbox" /><label for="cbt11">Exchange Rate&nbsp;&nbsp;</label>
<input id="cbt12" class="cbt00" type="checkbox" checked="checked" /><label for="cbt12">Total&nbsp;&nbsp;</label>
<input id="cbt13" class="cbt00" type="checkbox" /><label for="cbt13">Remark&nbsp;&nbsp;</label>






<div id="forScrollx">
<table id="claim1">
<thead>
<tr>
<th class="t01"></th>
<th class="t02">Expense Type</th><!--each cost type has account number, should insert into nav-->
<th class="t03">Receipt Date</th>
<th class="t04" style="width: 500px">Details</th>
<%--<th>AutoCal</th>--%>
<th class="t05">Original Currency</th>
<th class="t06" style="min-width:90px">Amount (Excl. Tax)</th>
<th class="t07" style="min-width:90px">Tax Amount</th>
<th class="t08">Tax</th>
<th class="t09" style="min-width:90px">Amount (Incl. Tax)</th>
<th class="t10">Currency Claimed</th>
<th class="t11" style="min-width:90px">Exchange Rate</th>
<th class="t12" style="min-width:90px">Total Claim Amount</th>
<th class="t13">Remark</th>
<th class="t14 incRef">Inc. Ref</th>
</tr>
</thead>
<tbody>
<tr id="GrandTotal">
    <td class="t01" style="border-right: 0px;border-left: 0px;border-bottom: 0px;"></td>
    <td class="t02" style="border-right: 0px;border-left: 0px;border-bottom: 0px;"></td>
    <td class="t03" style="border-right: 0px;border-left: 0px;border-bottom: 0px;"></td>
    <td class="t04" style="border-right: 0px;border-left: 0px;border-bottom: 0px;"></td>
    <td class="t05"><label style="font-weight:bold;">Grand total</label></td>
    <td class="t06 toRight" id="total1">0</td>
    <td class="t07 toRight" id="total2">0</td>
    <td class="t08 toRight">-</td>
    <td class="t09 toRight" id="total3">0</td>
    <td class="t10 toRight">-</td>
    <td class="t11 toRight">-</td>
    <td class="t12 toRight" id="total4">0</td>
    <td class="t13 toRight">-</td>
    <td class="t14 toRight incRef">-</td>
</tr>
</tbody>
</table>
<%--<br>
<input type="button" value="Add row" id="btnAddRow" class="dnnPrimaryAction">--%>
</div>
<br>


<asp:Button ID="btnDelete" CssClass="dnnPrimaryAction" runat="server" resourcekey="" OnClientClick="cancelForm();" OnClick="btnDelete_Click" Text="Delete" />
<span class="btnToright">
<asp:Button ID="btnRelease" CssClass="dnnPrimaryAction" runat="server" resourcekey="" OnClick="btnRelease_Click" Text="Release" />
<asp:Button ID="btnSubmit" CssClass="dnnPrimaryAction" runat="server" resourcekey="" OnClick="btnSubmit_Click" Text="Confirm" />
<asp:Button ID="btnSave2" CssClass="dnnPrimaryAction" runat="server" resourcekey="" OnClick="btnSave_Click" Text="Save" OnClientClick="if(!jsSave()){return false;}" />
<asp:Button ID="btnReport" CssClass="dnnPrimaryAction" runat="server" resourcekey="" OnClick="btnReport_Click" Text="Export PDF" />
<asp:Button ID="btnBack" CssClass="dnnSecondaryAction" runat="server" resourcekey="" OnClick="btnBack_Click" Text="Back" />

</span>
<br /><br />
<label>Remark: After save, you can download the pdf of this form.</label>
<script>
    $("#<%=btnDelete.ClientID%>").dnnConfirm({
        text: "Do you really want to delete this form? All the unsaved data will be lost.",
        title: "Confirm",
        isButton: true
    });
    $("#<%=btnDelete.ClientID%>").click(function (e, isTrigger) {
        if (isTrigger) {
            
        } else {
            return false;
        }
    });
    $("#<%=btnSubmit.ClientID%>").dnnConfirm({
        text: "After submission, you cannot modify this form anymore.<br />Do you want to confirm this form?",
        title: "Confirm",
        isButton: true
    });
    $("#<%=btnSubmit.ClientID%>").click(function (e, isTrigger) {
        if (isTrigger) {
            jsSave();
        } else {
            return false;
        }
    });
    $("#<%=btnRelease.ClientID%>").dnnConfirm({
        text: "Do you want to release this form?",
        title: "Confirm",
        isButton: true
    });
    $("#<%=btnRelease.ClientID%>").click(function (e, isTrigger) {
        if (isTrigger) {
            jsSave();
        } else {
            return false;
        }
    });
    function freshBar(evt) {
        if (evt.lengthComputable) {
            var percentComplete = (evt.loaded / evt.total) * 100;
            $('#progressbar').progressbar("option", "value", percentComplete);
        }
    }
    var uploadedFile = [];
    var fileLimit = 8;
    function UploadActual(sender, event) {
        if ($('#liActualAttached').children().length > 0) {
            document.getElementById(sender.id).value="";
            alert('Only one file can be uploaded');
            sender.value = null;
            return false;
        }
        if(sender.files[0].size>(1024*1024*fileLimit)){
            alert('The file size should smaller than 8mb.');
            sender.value = null;
            return false;
        }
        var ext = sender.value;
        var ext_length = ext.lastIndexOf('.');
        ext = ext.substring(ext_length+1,ext.length);
        ext = ext.toLowerCase();
        if(ext != 'pdf')
        {
            document.getElementById(sender.id).value="";
            alert('The file format should be in pdf format.');
            sender.value = null;
            return false;
        }
        if(!sender || !sender.value) return;  
        if (sender.files.length > 0) {
            var _formdata = new FormData();
            $.each(sender.files, function (i) {
                _formdata.append("fileActual"+i, this);
            });
            $.ajax({
                url: "/DesktopModules/eClaim/API/Webservices/UploadActual?appID="+$('#inputRefNo').text(),
                method: 'POST',
                xhr: function () {
                    myXhr = $.ajaxSettings.xhr();
                    if (myXhr.upload) {
                        $('#progressbar').progressbar();
                        myXhr.upload.addEventListener('progress', freshBar, false);
                    }
                    return myXhr;
                },
                error: function (jqxhr, textStatus, errorThrown) {
                    console.log(jqxhr);
                    console.log(textStatus);
                    console.log(errorThrown);

                    //for (key in jqxhr)
                    //    alert(key + ":" + jqxhr[key])
                    //for (key2 in textStatus)
                    //    alert(key + ":" + textStatus[key])
                    //for (key3 in errorThrown)
                    //    alert(key + ":" + errorThrown[key])
                },
                success: function (result) {
                    var isContainInvalidFile = false;
                    var invalidFilesCount = 0;
                    $.each(result, function (i, v) {
                           
                        if (v != null){
                            if (uploadedFile.indexOf(v.FileName) == -1) {
                                uploadedFile.push(v.FileName);
                                $("#liActualAttached").append(liActualFile(v.fileId,v.FileName, v.AccessPath));
                            }
                        }else{
                            invalidFilesCount++;
                            isContainInvalidFile = true;
                        }
                    });
                    if (isContainInvalidFile){
                        alert(String.format("Contain invalid file", invalidFilesCount));
                            sender.value = null;
                            return false;
                        }
                    },
                    complete: function (result){
                        $( "#progressbar" ).progressbar("destroy");
                        sender.value = null;
                    },
                    data: _formdata,
                    cache: false,
                    contentType: false,
                    processData: false
                });
            }
    }
    
    function liActualFile(fileId,FileName, AccessPath){
        var delId = "deleteId" + fileId;
        var liFileDelBtn = $("<a id='" + delId + "' name='deleteActualFile' href='javascript:deleteActualFile(\"" + FileName + "\",\""+delId+"\")'><img src='<%=DotNetNuke.Entities.Icons.IconController.IconURL("Delete")%>' /></a>").dnnConfirm({
            text: 'Do you want to delete this file?',
            yesText: 'Yes',
            noText: 'No',
            title: 'Confirm'
        });
        var liFileA = $("<a target='_blank' href='" + AccessPath + "?"+Date.now()+"'>" + FileName + "</a>");

        return $("<li>").append($("<span>").append(liFileA,liFileDelBtn));
    }

    function deleteActualFile(FileName, delId) {
        $.ajax({
            url: "/DesktopModules/eClaim/API/Webservices/DeleteActual?appID="+$('#inputRefNo').text(), //server script to process data
            method: 'POST',
            data: FileName,
            datatype: "text",
            success: function () {
                $("#"+delId).closest("li").remove();
                var result = uploadedFile.indexOf(FileName);
                if (result > -1) {
                    uploadedFile.splice(result, 1);
                }
            },
            error: function (jqxhr, textStatus, errorThrown) {
                console.log(jqxhr);
                console.log(textStatus);
                console.log(errorThrown);

                //for (key in jqxhr)
                //    alert(key + ":" + jqxhr[key])
                //for (key2 in textStatus)
                //    alert(key + ":" + textStatus[key])
                //for (key3 in errorThrown)
                //    alert(key + ":" + errorThrown[key])
            },
        });
    }

    function cancelForm() {
        $('#<%=hfFormID.ClientID%>').val($('#inputID').text());

    }
    function postClaimForm() {
        var ClaimForm = {
            ID: $("#inputID").text(),
            RefNo: $("#inputRefNo").text(),
            Region: $("#inputRegion").text(),
            BusinessUnit: $('#inputBU').val(),
            SubmissionDate: $("#inputSubDate").text(),
            ClaimFormType: $('input[name="inputFormType[]"]:checked').val(),
            JobNo: $('#inputProjCode').val(),
            ProjectName: $('#inputProjName').val()
        };
        $('#<%=hfFormData.ClientID%>').val(JSON.stringify(ClaimForm));
    }
    
    function postClaimFormDetails() {
        var ClaimFormDetails = '{"data":[';
        $('#claim1>tbody tr').each(function (index, Element) {
            if ($(Element).attr('id') != 'GrandTotal') {
                ClaimFormDetails += '{"ClaimFormID":"' + $("#inputID").text() + '",';
                ClaimFormDetails += '"SeqNo":"' + index + '",';
                ClaimFormDetails += '"VoucDate":"' + $(Element).find(".inputVouDate").val() + '",';
                ClaimFormDetails += '"CostTypeID":"' + $(Element).find(".inputCostType").val() + '",';
                ClaimFormDetails += '"PeriodFrom":"' + $(Element).find(".inputDateFrom").val() + '",';
                ClaimFormDetails += '"PeriodTo":"' + $(Element).find(".inputDateTo").val() + '",';
                ClaimFormDetails += '"LocationFrom":"' + $(Element).find(".inputLocFrom").val() + '",';
                ClaimFormDetails += '"LocationTo":"' + $(Element).find(".inputLocTo").val() + '",';
                ClaimFormDetails += '"TransportationTypeID":"' + $(Element).find(".inputTransType").val() + '",';
                ClaimFormDetails += '"Description":"' + $(Element).find(".inputDesc").val() + '",';
                //ClaimFormDetails += '"AutoCal":"' + (($(Element).find(".inputAutoCal").is(':checked') == true) ? 'Y' : 'N') + '",';
                ClaimFormDetails += '"OriginalCurrencyCode":"' + $(Element).find(".inputOrgCurr").val() + '",';
                ClaimFormDetails += '"OriginalAmount":"' + $(Element).find(".inputExcTax").val() + '",';
                ClaimFormDetails += '"TaxAmount":"' + $(Element).find(".inputTaxAmt").val() + '",';
                ClaimFormDetails += '"GSTCode":"' + $(Element).find(".inputTaxType").val() + '",';
                ClaimFormDetails += '"AmountWithTax":"' + $(Element).find(".inputIncTax").val() + '",';
                ClaimFormDetails += '"ClaimedCurrencyCode":"' + $(Element).find(".inputCurr").val() + '",';
                ClaimFormDetails += '"ExchangeRate":"' + $(Element).find(".inputRate").val() + '",';
                ClaimFormDetails += '"TotalAmount":"' + $(Element).find(".inputTotal").val() + '",';
                ClaimFormDetails += '"IncludeRef":"' + (($(Element).find(".inputRef").is(':checked') == true) ? 'Y' : 'N') + '",';
                ClaimFormDetails += '"Remarks":"' + $(Element).find(".inputRemark").val() + '"},';
            } else {
                if (ClaimFormDetails.slice(-1) == ',') { 
                    ClaimFormDetails = ClaimFormDetails.substring(0, ClaimFormDetails.length - 1);
                }
                ClaimFormDetails += ']}';
                $('#<%=hfFormDetailsData.ClientID%>').val(ClaimFormDetails);
            }
        });
    }
    function jsSave() {
        postClaimForm();
        postClaimFormDetails();
        return true;
    }
</script>
