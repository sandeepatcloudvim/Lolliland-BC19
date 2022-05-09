tableextension 54503 "LOLI_ExtendSalesRecSetup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(54500; "LOLI_Pallet Volume Formula"; Decimal)
        {
            Caption = 'Pallet Volume Formula';
            DataClassification = ToBeClassified;
        }
        field(54501; "LOLI_Pallet Weight Formula"; Decimal)
        {
            Caption = 'Pallet Weight Formula';
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}