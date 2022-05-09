page 54500 "LOLI Posted Sales Invoices"
{
    Caption = 'Posted Sales Invoices Lolliland';
    CardPageID = "Posted Sales Invoice";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Invoice,Navigate,Correct';
    RefreshOnActivate = true;
    SourceTable = "Sales Invoice Header";
    UsageCategory = Lists;
    ApplicationArea = all;
    SourceTableView = SORTING("Posting Date")
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posting Date';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer';
                    ToolTip = 'Specifies the name of the customer that you shipped the items on the invoice to.';
                }
                field("LOLI Adjusted Profit Per"; Rec."LOLI_Adjusted Profit Per")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Adjusted Profit %';
                }
                field("LOLI Adjusted Profit Amt"; Rec."LOLI_Adjusted Profit Amt")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Adjusted Profit';
                }
                field(LOLI_Volume; Rec."LOLI_Volume")
                {
                    ApplicationArea = All;
                    Caption = 'Volume';
                }
                field("LOLI_Gross Weight"; Rec."LOLI_Gross Weight")
                {
                    ApplicationArea = All;
                    Caption = 'Gross Weight';
                }
                field("LOLI_No. of Pallet Height"; Rec."LOLI_No. of Pallet Height")
                {
                    ApplicationArea = All;
                    Caption = 'No. of Pallet Height';
                    Visible = false;
                }
                field("LOLI_No. of Pallet Weight"; Rec."LOLI_No. of Pallet Weight")
                {
                    ApplicationArea = All;
                    Caption = 'No. of Pallet Weight';
                    Visible = false;
                }
                field("LOLI_Pallet Total"; Rec."LOLI_Pallet Total")
                {
                    ApplicationArea = All;
                    Caption = 'Pallet Total';
                }
                field("Ship-to County"; Rec."Ship-to County")
                {
                    ApplicationArea = All;
                    Caption = 'State';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total, in the currency of the invoice, of the amounts on all the invoice lines. The amount does not include tax.';

                    trigger OnDrillDown()
                    begin
                        Rec.SetRange("No.");
                        PAGE.RunModal(PAGE::"Posted Sales Invoice", Rec)
                    end;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total of the amounts, including tax, on all the lines on the document.';

                    trigger OnDrillDown()
                    begin
                        Rec.SetRange("No.");
                        PAGE.RunModal(PAGE::"Posted Sales Invoice", Rec)
                    end;
                }
                field("Sell-to County"; Rec."Sell-to County")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'State';
                }
                field("No. of Carton"; Rec."No. of Carton")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Carton';
                }
                field("No. of Sales Lines"; Rec."No. of Sales Lines")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'No. of Sales Lines';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Caption = 'Location Code';
                }

            }
        }
        area(factboxes)
        {
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Advanced;
                ShowFilter = false;
                Visible = NOT IsOfficeAddin;
            }
            systempart(Control1900383207; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Invoice")
            {
                Caption = '&Invoice';
                Image = Invoice;
                // action(Statistics)
                // {
                //     ApplicationArea = Advanced;
                //     Caption = 'Statistics';
                //     Image = Statistics;
                //     Promoted = true;
                //     PromotedCategory = Category4;
                //     PromotedIsBig = true;
                //     ShortCutKey = 'F7';
                //     ToolTip = 'View statistical information, such as the value of posted entries, for the record.';

                //     trigger OnAction()
                //     begin
                //         OnBeforeCalculateSalesTaxStatistics(Rec);
                //         if Rec."Tax Area Code" = '' then
                //             PAGE.RunModal(PAGE::"Sales Invoice Statistics", Rec, Rec."No.")
                //         else
                //             PAGE.RunModal(PAGE::"Sales Invoice Stats.", Rec, Rec."No.");
                //     end;
                // }
                action("Co&mments")
                {
                    ApplicationArea = Advanced;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = CONST("Posted Invoice"),
                                  "No." = FIELD("No.");
                    ToolTip = 'View or add comments for the record.';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
                action(IncomingDoc)
                {
                    AccessByPermission = TableData "Incoming Document" = R;
                    ApplicationArea = Advanced;
                    Caption = 'Incoming Document';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'View or create an incoming document record that is linked to the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        IncomingDocument.ShowCard(Rec."No.", Rec."Posting Date");
                    end;
                }
            }
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics 365 for Sales';
                Visible = CRMIntegrationEnabled;
                action(CRMGotoInvoice)
                {
                    ApplicationArea = Suite;
                    Caption = 'Invoice';
                    Enabled = CRMIsCoupledToRecord;
                    Image = CoupledSalesInvoice;
                    ToolTip = 'Open the coupled Dynamics 365 for Sales invoice.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowCRMEntityFromRecordID(Rec.RecordId);
                    end;
                }
                action(CreateInCRM)
                {
                    ApplicationArea = Suite;
                    Caption = 'Create Invoice in Dynamics 365 for Sales';
                    Enabled = NOT CRMIsCoupledToRecord;
                    Image = NewSalesInvoice;
                    ToolTip = 'Generate the document in the coupled Dynamics 365 for Sales account.';

                    trigger OnAction()
                    var
                        SalesInvoiceHeader: Record "Sales Invoice Header";
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CurrPage.SetSelectionFilter(SalesInvoiceHeader);
                        CRMIntegrationManagement.CreateNewRecordsInCRM(SalesInvoiceHeader);
                    end;
                }
                action(ShowLog)
                {
                    ApplicationArea = Suite;
                    Caption = 'Synchronization Log';
                    Image = Log;
                    ToolTip = 'View integration synchronization jobs for the posted sales invoice table.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowLog(Rec.RecordId);
                    end;
                }
            }
        }
        area(processing)
        {

            action(SendCustom)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send';
                Ellipsis = true;
                Enabled = NOT IsPostedSalesInvoicesEmpty;
                Image = SendToMultiple;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Prepare to send the document according to the customer''s sending profile, such as attached to an email. The Send document to window opens where you can confirm or select a sending profile.';

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    SalesInvHeader.SendRecords;
                end;
            }
            action(Print)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                Visible = NOT IsOfficeAddin;

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    SalesInvHeader.PrintRecords(true);
                end;
            }
            action(Email)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send by &Email';
                Image = Email;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                ToolTip = 'Prepare to send the document by email. The Send Email window opens prefilled for the customer where you can add or change information before you send the email.';

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    SalesInvHeader.EmailRecords(true);
                end;
            }
            action(Navigate)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Navigate';
                Image = Navigate;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category5;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
                Visible = NOT IsOfficeAddin;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
            action(ActivityLog)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Activity Log';
                Image = Log;
                ToolTip = 'View the status and any errors if the document was sent as an electronic document or OCR file through the document exchange service.';

                trigger OnAction()
                var
                    ActivityLog: Record "Activity Log";
                begin
                    ActivityLog.ShowEntries(Rec.RecordId);
                end;
            }
            group(Correct)
            {
                Caption = 'Correct';
                action(CorrectInvoice)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Correct';
                    Enabled = NOT IsPostedSalesInvoicesEmpty;
                    Image = Undo;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Scope = Repeater;
                    ToolTip = 'Reverse this posted invoice and automatically create a new invoice with the same information that you can correct before posting. This posted invoice will automatically be canceled.';
                    Visible = IsFoundationEnabled;

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Correct PstdSalesInv (Yes/No)", Rec);
                    end;
                }
                action(CancelInvoice)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel';
                    Enabled = NOT IsPostedSalesInvoicesEmpty;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Scope = Repeater;
                    ToolTip = 'Create and post a sales credit memo that reverses this posted sales invoice. This posted sales invoice will be canceled.';
                    Visible = IsFoundationEnabled;

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Cancel PstdSalesInv (Yes/No)", Rec);
                    end;
                }
                action(CreateCreditMemo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Corrective Credit Memo';
                    Enabled = NOT IsPostedSalesInvoicesEmpty;
                    Image = CreateCreditMemo;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category6;
                    Scope = Repeater;
                    ToolTip = 'Create a credit memo for this posted invoice that you complete and post manually to reverse the posted invoice.';

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                        CorrectPostedSalesInvoice: Codeunit "Correct Posted Sales Invoice";
                    begin
                        CorrectPostedSalesInvoice.CreateCreditMemoCopyDocument(Rec, SalesHeader);
                        PAGE.Run(PAGE::"Sales Credit Memo", SalesHeader);
                    end;
                }
            }
            group(Invoice)
            {
                Caption = 'Invoice';
                Image = Invoice;
                action(Customer)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer';
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("Sell-to Customer No.");
                    Scope = Repeater;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or edit detailed information about the customer.';
                }
                action(ShowCreditMemo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Canceled/Corrective Credit Memo';
                    Enabled = Rec.Cancelled OR Rec.Corrective;
                    Image = CreditMemo;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    Scope = Repeater;
                    ToolTip = 'Open the posted sales credit memo that was created when you canceled the posted sales invoice. If the posted sales invoice is the result of a canceled sales credit memo, then canceled sales credit memo will open.';

                    trigger OnAction()
                    begin
                        Rec.ShowCanceledOrCorrCrMemo;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        DocExchStatusStyle := Rec.GetDocExchStatusStyle;
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
        CRMIsCoupledToRecord := CRMIntegrationEnabled and CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RecordId);
    end;

    trigger OnAfterGetRecord()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        recSalesInvLine: Record "Sales Invoice Line";
    begin
        recSalesInvLine.Reset();
        recSalesInvLine.SetRange("Document No.", Rec."No.");
        if recSalesInvLine.Find('-') then
            repeat
                Rec."No. of Carton" := Rec."No. of Carton" + recSalesInvLine.Quantity;
            until recSalesInvLine.Next = 0;

        DocExchStatusStyle := Rec.GetDocExchStatusStyle;

        SalesInvoiceHeader.CopyFilters(Rec);
        IsPostedSalesInvoicesEmpty := SalesInvoiceHeader.IsEmpty;
        SalesInvoiceHeader.SetFilter("Document Exchange Status", '<>%1', Rec."Document Exchange Status"::"Not Sent");
        DocExchStatusVisible := not SalesInvoiceHeader.IsEmpty;

        CalcAdjustProfit;
    end;

    trigger OnInit()
    begin
        DocExchStatusVisible := false;
    end;

    trigger OnOpenPage()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        OfficeMgt: Codeunit "Office Management";
        HasFilters: Boolean;
    begin
        HasFilters := Rec.GetFilters <> '';
        Rec.SetSecurityFilterOnRespCenter;
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
        if HasFilters then
            if Rec.FindFirst then;
        IsOfficeAddin := OfficeMgt.IsAvailable;
        IsPostedSalesInvoicesEmpty := SalesInvoiceHeader.IsEmpty;
    end;

    var
        ApplicationAreaSetup: Record "Application Area Setup";
        DocExchStatusStyle: Text;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        DocExchStatusVisible: Boolean;
        IsOfficeAddin: Boolean;
        IsPostedSalesInvoicesEmpty: Boolean;
        IsFoundationEnabled: Boolean;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateSalesTaxStatistics(var SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
    end;

    local procedure CalcAdjustProfit()
    var
        CostCalcMgt: Codeunit "Cost Calculation Management";
        TaxArea: Record "Tax Area";
        Currency: Record Currency;
        SalesInvLine: Record "Sales Invoice Line";
        CustAmount: Decimal;
        TotalAdjCostLCY: Decimal;
        AmountLCY: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";
        AdjProfitLCY: Decimal;
        AdjProfitPct: Decimal;
        SalesRecv: Record "Sales & Receivables Setup";
    begin
        Clear(SalesInvLine);
        Clear(CustAmount);
        Clear(TotalAdjCostLCY);
        Clear(AmountLCY);
        Clear(AdjProfitLCY);
        Clear(AdjProfitPct);
        if TaxArea.Get(Rec."Tax Area Code") then;
        if SalesRecv.Get() then;

        if Rec."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else
            Currency.Get(Rec."Currency Code");

        SalesInvLine.SetRange("Document No.", Rec."No.");
        if SalesInvLine.Find('-') then
            repeat
                CustAmount := CustAmount + SalesInvLine.Amount;
                TotalAdjCostLCY := TotalAdjCostLCY + CostCalcMgt.CalcSalesInvLineCostLCY(SalesInvLine);
            until SalesInvLine.Next = 0;

        if Rec."Currency Code" = '' then
            AmountLCY := CustAmount
        else
            AmountLCY :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                WorkDate, Rec."Currency Code", CustAmount, Rec."Currency Factor");

        AdjProfitLCY := AmountLCY - TotalAdjCostLCY;
        if AmountLCY <> 0 then
            AdjProfitPct := Round(100 * AdjProfitLCY / AmountLCY, 0.1);

        Rec."LOLI_Adjusted Profit Amt" := AdjProfitLCY;
        Rec."LOLI_Adjusted Profit Per" := AdjProfitPct;

        if SalesInvLine."Unit Volume" > 0 then begin
            if SalesRecv."LOLI_Pallet Volume Formula" <> 0 then
                Rec."LOLI_No. of Pallet Height" := (SalesInvLine."Unit Volume" / SalesRecv."LOLI_Pallet Volume Formula")
            else
                Rec."LOLI_No. of Pallet Height" := (SalesInvLine."Unit Volume" / 2.9)
        end;

        if SalesInvLine."Gross Weight" > 0 then begin
            if SalesRecv."LOLI_Pallet Weight Formula" <> 0 then
                Rec."LOLI_No. of Pallet Weight" := (SalesInvLine."Gross Weight" / SalesRecv."LOLI_Pallet Weight Formula")
            else
                Rec."LOLI_No. of Pallet Weight" := (SalesInvLine."Gross Weight" / 1020)
        end;

        if (Rec."LOLI_No. of Pallet Height" <= Rec."LOLI_No. of Pallet Weight") then
            Rec."LOLI_Pallet Total" := Rec."LOLI_No. of Pallet Weight"
        else
            Rec."LOLI_Pallet Total" := Rec."LOLI_No. of Pallet Height";

    end;
}

