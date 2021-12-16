pageextension 54504 LOLI_ExtendPurchaseInvoices extends "Purchase Invoices"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;

    trigger OnOpenPage()
    begin

        Rec.SetFilter(Rec."No.", '<> %1 & <>%2 & <>%3', '108001', '108002', '108003');
    end;


}