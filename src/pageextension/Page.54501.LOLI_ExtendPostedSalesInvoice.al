pageextension 54501 ExtendPostedSalesInvoice extends "Posted Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("&Invoice")
        {
            action("LOLI_Send Excel")
            {
                Caption = 'Send Email as Excel';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Visible = true;
                trigger OnAction()
                begin
                    SendSalesInvExcelEmail(Rec);
                end;
            }
        }
    }

    var
        myInt: Integer;
        Cust: Record Customer;

        ReportSelections: Record "Report Selections";
        FileName: Text;
        RecRef: RecordRef;
        XmlParameters: Text;
        EmailOutStream: OutStream;
        EmailInStream: InStream;
        SMTPMail: Codeunit Email;
        SMTPMailSetup: Codeunit "Email Message";
        SendToList: List of [Text];
        SendTo: Text[250];
        TempBlob: Codeunit "Temp Blob";
        SalesInvHeader: Record "Sales Invoice Header";
        Subject: Text[250];
        Body: Text[250];
        EmailSetupErr: Label 'There is no email setup in Customer card for the customer = %1';
        ConfirmMsg: Label 'Customer is set to receive sales invoice in Excel, Do you want to Send Sales Invoice in Excel?';

    procedure SendSalesInvExcelEmail(recPostedSalesInv: Record "Sales Invoice Header")
    var
    begin
        IF Cust.GET(recPostedSalesInv."Sell-to Customer No.") then begin

            Rec.SetRecFilter;
            RecRef.open(Database::"Sales Invoice Header");
            RecRef.SetView(Rec.GetView);
            RecRef.SetTable(SalesInvHeader);
            FileName := 'SalesInvoice-' + SalesInvHeader."Sell-to Customer No." + '_' + FORMAT(WORKDATE, 6, '<Day,2><Month,2><Year,2>') + '_' + SalesInvHeader."No." + '.xlsx';

            TempBlob.CreateInStream(EmailInStream, TextEncoding::UTF8);
            TempBlob.CREATEOUTSTREAM(EmailOutStream, TextEncoding::UTF8);

            IF REPORT.SaveAs(54500, XMLParameters, ReportFormat::Excel, EmailOutStream, RecRef) THEN;

            IF Cust."E-Mail" <> '' THEN BEGIN
                SendToList.Add(Cust."E-Mail");

                // SMTPMailSetup.GET;
                // SMTPMail.CreateMessage(SMTPMailSetup."Send As",
                //                     SMTPMailSetup."User ID",
                //                     SendToList,
                //                     'Sales Invoice' + '_' + SalesInvHeader."No.", '');

                Body := 'Please find your sales invoice. This is auto generated email. Please do not reply.';
                Subject := 'Sales Invoice' + '_' + SalesInvHeader."No.";
                // SMTPMail.AppendBody(FORMAT('<br>'));
                // SMTPMail.AddAttachmentStream(EmailInStream, FileName);
                // SMTPMail.Send();
                SMTPMailSetup.Create(SendToList, Subject, Body, true);
                SMTPMailSetup.AddAttachment(FileName, '', EmailInStream);
                SMTPMail.Send(SMTPMailSetup, Enum::"Email Scenario"::Default);

            end;
            RecRef.Close();

        end;
    end;
}