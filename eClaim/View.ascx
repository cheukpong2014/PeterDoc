<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="View.ascx.cs" Inherits="Milton.Modules.eClaim.View" %>
<%@ Register TagPrefix="dnn" Namespace="DotNetNuke.Web.Client.ClientResourceManagement" Assembly="DotNetNuke.Web.Client" %>

<dnn:DnnJsInclude runat="server" FilePath="~/Plug-in/DataTables/media/js/jquery.dataTables.min.js" />
<dnn:DnnJsInclude runat="server" FilePath="~/Plug-in/DataTables/extensions/TableTools/js/dataTables.tableTools.min.js" />
<dnn:DnnCssInclude runat="server" FilePath="~/Plug-in/DataTables/media/css/jquery.dataTables.css" />
<dnn:DnnCssInclude runat="server" FilePath="~/Plug-in/DataTables/extensions/TableTools/css/dataTables.tableTools.css" />

<%--<script src="/DesktopModules/eClaim/js/loopj-jquery-tokeninput-201d2d1/src/jquery.tokeninput.js" type="text/javascript"></script>
<link rel="stylesheet" href="/DesktopModules/eClaim/js/loopj-jquery-tokeninput-201d2d1/styles/token-input.css" />
<link rel="stylesheet" href="/DesktopModules/eClaim/js/loopj-jquery-tokeninput-201d2d1/styles/token-input-facebook.css" />
<link rel="stylesheet" href="/DesktopModules/eClaim/js/loopj-jquery-tokeninput-201d2d1/styles/token-input-mac.css" />--%>
<dnn:DnnJsInclude runat="server" FilePath="~/Resources/Shared/Components/Tokeninput/jquery.tokeninput.js" />
<dnn:DnnCssInclude runat="server" FilePath="~/Resources/Shared/Components/Tokeninput/Themes/token-input.css" />
<dnn:DnnCssInclude runat="server" FilePath="~/Resources/Shared/Components/Tokeninput/Themes/token-input-facebookex.css" />
<dnn:DnnCssInclude runat="server" FilePath="~/Resources/Shared/Components/Tokeninput/Themes/token-input-mac.css" />

<asp:HiddenField ID="hfCreateForOthers" runat="server" />

<asp:Button OnClick="btnCreate_Click" ID="btnViewClaimForm" CssClass="dnnPrimaryAction" resourcekey="btnCreate" runat="server" />
<asp:Button ID="btnExport" Text="Export Excel" runat="server" resourcekey="btnExport" CssClass="dnnPrimaryAction" onClientClick="if(popup()){return false;}" />
<asp:Button ID="btnExportByReceiptDate" runat="server" resourcekey="btnExportByReceiptDate" CssClass="dnnPrimaryAction" onClientClick="if(popup2()){return false;}" />
<span id="spanCreateForOthers" runat="server"><br />
    <table style="width:100%">
        <tr>
            <td style="width:12%">
                Create for others:
            </td>
            <td style="width:15%">
                <input id="txtName" type="text" />
            </td>
            <td style="width:73%">
                &nbsp;&nbsp;
                <asp:Button OnClick="btnCreateForOthers_Click" ID="btnCreateForOthers" CssClass="dnnPrimaryAction" resourcekey="btnCreateForOthers" runat="server" onClientClick="if(checkTokenInput()){return false;}"/>
            </td>
        </tr>
    </table>
</span>
<asp:GridView ID="gvTable" runat="server" RowHeaderColumn="1" CssClass="display dt-body-center" BorderStyle="None" Border="0" GridLines="None" OnRowDataBound="gvTable_RowDataBound">
</asp:GridView>

<style>
    /*.hiddenColumn {
        display: none;
    }*/
    .pointer{
        cursor: pointer;
    }
</style>

<script>
    function checkTokenInput() {
        if ($('#txtName').val() == "") {
            return true;
        }
    }
    function popup() {
        <%--window.location.href = "javascript:dnnModal.show('<%=DotNetNuke.Common.Globals.NavigateURL("Edit","mid=" + ModuleId) + "?popUp=true"%>&start=" + eventData.format("DD-MM-YYYY") + "&teamId="+teamId+"',false,400,800,true,'javascript:$(\\'#calendar\\').fullCalendar(\\'refetchEvents\\');')";--%>
        window.location.href = "javascript:dnnModal.show('<%=DotNetNuke.Common.Globals.NavigateURL("exportExcel","mid=" + ModuleId) + "?popUp=true"%>&start=1&teamId=2',false,620,800,true,'javascript: console.log(123);')";
        return true;
    }
    function popup2() {
        window.location.href = "javascript:dnnModal.show('<%=DotNetNuke.Common.Globals.NavigateURL("exportByReceiptDate","mid=" + ModuleId) + "?popUp=true"%>&start=1&teamId=2',false,620,800,true,'javascript: console.log(123);')";
        return true;
    }
    $(document).ready(function () {
        
        

        var table = $("#<%=gvTable.ClientID%>").DataTable({
            "aaSorting": [0, 'desc'],
            "autoWidth": true,
            "scrollX": true,
            "iDisplayLength": 25
            //"columnDefs": [
            //    {
            //        "render": function (data, type, row) {
            //            return data + ' (' + row[3] + ')';
            //        },
            //        "targets": 6
            //    }
            //]
            //"columnDefs": [
            //    //{ "width": "150px", "targets": [0] },
            //    //{ "width": "109px", "targets": [3] },
            //    //{ "width": "179px", "targets": [5] },
            //    //{ "width": "99px", "targets": [2, 4] },
            //    {
            //        "targets": [0],"visible": false
            //    }
            //]
        });

        $("#<%=gvTable.ClientID%>").on('click', 'tr', function () {
            window.location.href = "<%= EditUrl(string.Empty, string.Empty, "ClaimForm")%>/id/" + table.row(this).data()[0] + "/";
        });

        $("#<%=gvTable.ClientID%>").on('mouseover', 'tr', function () {
            $(this).addClass("dtHighlight");
            $(this).addClass("pointer");
        });

        $("#<%=gvTable.ClientID%>").on('mouseleave', 'tr', function () {
            $(this).removeClass("dtHighlight");
            $(this).removeClass("pointer");
        });
        
        var serviceUrl = "/DesktopModules/eClaim/API/Webservices/SearchUser?userid="+<%=UserId%>+"&";
        $("#txtName").tokenInput(serviceUrl, {
            theme: "facebook",
            preventDuplicates: true,
            resultsFormatter: function (item) {
                return "<li class='user'><span>" + item.region + ":" + item.name + "</span>&nbsp;<span>&lt;" + item.email + "&gt;</span></li>";
            },
            tokenLimit: 1,
            theme: "facebook",
            onAdd: function (item) {
                $("#<%=hfCreateForOthers.ClientID%>").val(item.id);
            },
            fail: function (ts) {
                console.log(ts);
            }
        });
    });
</script>
