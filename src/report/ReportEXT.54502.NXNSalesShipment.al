reportextension 54502 SalesShipment_Ext extends "NXN- Sales - Shipment"
{
    dataset
    {
        modify("Sales Shipment Header")
        {
            trigger OnAfterAfterGetRecord()
            var
                SalesInvoiceHeader: Record "Sales Invoice Header";
                I: Integer;
            begin
                Clear(InvoiceNo);
                I := 0;
                SalesInvoiceHeader.SetRange("Order No.", "Order No.");
                I := SalesInvoiceHeader.Count;
                If I = 1 then begin
                    If SalesInvoiceHeader.FindFirst() then
                        InvoiceNo := SalesInvoiceHeader."No."
                end else
                    InvoiceNo := '';
            end;
        }
        add(copyloop)
        {
            column(InvoiceCaption; InvoiceCaptionLBL)
            { }
            column(InvoiceNo; InvoiceNo)
            { }
        }
    }

    requestpage
    {
        // Add changes to the requestpage here
    }

    // rendering
    // {
    //     layout(LayoutName)
    //     {
    //         Type = RDLC;
    //         LayoutFile = 'mylayout.rdl';
    //     }
    // }
    var
        InvoiceCaptionLBL: Label 'Invoice No.';
        InvoiceNo: Code[20];
}