pageextension 54515 "LOLI_ExtendSalesRecvSetup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Default Cancel Reason Code")
        {
            field("LOLI_Pallet Volume Formula"; Rec."LOLI_Pallet Volume Formula")
            {
                ApplicationArea = All;
                Caption = 'Pallet Volume Formula';
                DecimalPlaces = 0 : 5;
            }
            field("LOLI_Pallet Weight Formula"; Rec."LOLI_Pallet Weight Formula")
            {
                ApplicationArea = All;
                Caption = 'Pallet Weight Formula';
                DecimalPlaces = 0 : 5;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}