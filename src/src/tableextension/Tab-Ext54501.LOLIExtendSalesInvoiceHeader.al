tableextension 54501 "LOLI_ExtendSalesInvoiceHeader" extends "Sales Invoice Header"
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
        field(54502; "No. of Sales Lines"; Integer)
        {
            Caption = 'No. of Sales Lines';
            FieldClass = FlowField;
            CalcFormula = Count("Sales Invoice Line" WHERE("Document No." = FIELD("No."), Type = FILTER(Item)));
        }
        field(54503; "No. of Carton"; Decimal)
        {
            Caption = 'No. of Carton';
        }
        field(54504; "LOLI_Volume"; Decimal)
        {
            Caption = 'Volume';
            DataClassification = ToBeClassified;
        }
        field(54505; "LOLI_Gross Weight"; Decimal)
        {
            Caption = 'Weight';
            DataClassification = ToBeClassified;
        }
        field(54506; "LOLI_No. of Pallet Height"; Decimal)
        {
            Caption = 'No. of Pallet Height';
            DataClassification = ToBeClassified;
        }
        field(54507; "LOLI_No. of Pallet Weight"; Decimal)
        {
            Caption = 'No. of Pallet Weight';
            DataClassification = ToBeClassified;
        }
        field(54508; "LOLI_Pallet Total"; Decimal)
        {
            Caption = 'Pallet Total';
            DataClassification = ToBeClassified;
        }

    }
}
