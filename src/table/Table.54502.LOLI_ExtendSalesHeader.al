tableextension 54502 "LOLI_ExtendSalesHeader" extends "Sales Header"
{
    fields
    {
        field(54500; "LOLI_Adjusted Profit Amt"; Decimal)
        {
            Caption = 'Adjusted Profit';
            DataClassification = ToBeClassified;
        }
        field(54501; "LOLI_Adjusted Profit Per"; Decimal)
        {
            Caption = 'Adjusted Profit %';
            DataClassification = ToBeClassified;
        }
        field(54502; "LOLI_Volume"; Decimal)
        {
            Caption = 'Volume';
            DataClassification = ToBeClassified;
        }
        field(54503; "LOLI_Gross Weight"; Decimal)
        {
            Caption = 'Weight';
            DataClassification = ToBeClassified;
        }
        field(54504; "LOLI_No. of Pallet Height"; Decimal)
        {
            Caption = 'No. of Pallet Height';
            DataClassification = ToBeClassified;
        }
        field(54505; "LOLI_No. of Pallet Weight"; Decimal)
        {
            Caption = 'No. of Pallet Weight';
            DataClassification = ToBeClassified;
        }
        field(54506; "LOLI_Pallet Total"; Decimal)
        {
            Caption = 'Pallet Total';
            DataClassification = ToBeClassified;
        }
    }
}
